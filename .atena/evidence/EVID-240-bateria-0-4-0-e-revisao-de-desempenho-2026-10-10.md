# EVID-240 — Bateria do release candidate 0.4.0 e revisão de desempenho (2026-10-10)

**Origem:** dono, "vamos fazer uma bateria de testes para essa atualização e revisar o que não foi otimizado desde o início do projeto, priorizar o que for mais antigo".
**Desvio:** DEV-038 (PLAN_DEVIATION do PLAN-071); rota "fazer agora e voltar"; por plano (PLAN-098, SPEC-171).
**Estado medido:** HEAD `602cef5` + árvore de trabalho (19 modificados e 130 novos de várias sessões, preservados). Godot 4.7.2. Logs em `.atena/generated/plan-098/`.

## 1. Bateria (S-002, antes das otimizações; repetida em S-008, depois)
| Verificação | Antes | Depois |
|---|---|---|
| Suíte completa (`tests/run_all.gd`) | 0 falhas | 0 falhas (inclui `test_blocker_index` e `test_reach_grid`, novos) |
| Smoke das 9 fases | ok | ok |
| `controller_check --headless` | 94/0 | 94/0 |
| `mobile_buttons_check --headless` | 146/0 | 146/0 |
| `kit_test` (com janela) | OK | OK |
| `audit_projeto` | 0 erros, 7 avisos (`boss_presentations`, já conhecidos: EVID-155, EVID-205) | igual |
| `backlog_check` | P0=0, 0 alertas | P0=0 (alertas apontavam o EVID-240 e o cartão TOOL-006, fechados com este registro) |
| Save real (`profile.json`) | `22bf8919…1ba` | `22bf8919…1ba` (intocado) |

Varredura dos logs: nenhum `SCRIPT ERROR` nem `Parse Error`. Só os avisos de encerramento "ObjectDB instances were leaked" (suíte 84, demais 4 a 6): higiene dos testes e do `quit()`, sem efeito no jogo.

## 2. Medição (S-005, `tools/perf_probe.tscn`)
Política fixa de jogo (afastar de inimigos, desviar de projéteis, escolher melhorias), semente 7, 300 s simulados a 60 passos/s por fase, bloqueios reais da fase (props e estruturas), herói não morre. A **réplica cronometrada do passo** produziu o mesmo hash do `Battle.step` real em todas as fases (a medição por seção é fiel).

Achados por ordem de idade do código (todos de 21/09, dia 1):
| # | Arquivo | Achado | Número |
|---|---|---|---|
| 1 | `core/hero.gd` `can_stand` | varria todos os bloqueios, por inimigo e por passo; é a maior parte de `enemies` (80–94% do passo) | Molor (196 bloqueios): 4,2 ms/passo; `_enemy_move` 54 µs por inimigo |
| 2 | `core/battle.gd` `_reach_grid` | inundação de 12 mil células refeita a cada interativo que nasce (45 s, eventos, baú de chefe) | picos de **25 a 58 ms** (2–3 quadros perdidos) em `director`, `stage_event`, `weapons`, `kill` |
| 3 | `core/battle.gd` `_enemy_step` (grade 3×3) | `_grid.get(chave, [])` alocava um `Array` por consulta | ~2–5% do passo |
| — | `ui/ground.gd` | **já otimizado:** as 9 fases usam o chão assado em imagem única (PLAN-054) | n/a |
| — | `ui/prop.gd` | `get_image()` por textura única: 85 texturas = **47 ms no total**, não é gargalo | descartado |
| — | `core/sfx.gd` | callback em todo nó adicionado: só `is BaseButton`; custo desprezível por estimativa (não medido) | descartado |
| — | `core/data.gd` | cache por nome, 59 consultas em `battle.gd` são acesso a dicionário | descartado |

Janela (`scene`, com GPU, sem vsync, 60 inimigos extras, 900 quadros): ~0,8–1,1 ms por quadro, 66–70 draw calls, ~3 mil primitivas, 158–184 MB de VRAM, 0 nós órfãos, 665–840 nós. Carga da fase: 430–460 ms (a primeira da sessão, 1,2 s, é fria). **Nesta máquina o jogo tem folga de ~10× sobre os 16,7 ms do quadro**; o ganho vale para máquinas mais fracas.

## 3. Otimizações aplicadas (S-007); resultado idêntico
| # | Mudança | Prova de equivalência | Ganho medido |
|---|---|---|---|
| O1 | `Hero.can_stand`: índice espacial dos bloqueios (células de 6 tiles, refeito quando o array muda: hash + tamanho); o teste de cada bloqueio é o mesmo | `tests/test_blocker_index.gd`: 15,6 mil consultas (aleatórias e na borda exata ±0,0005) iguais à varredura completa, em mapas de 40 e 84; anexar, trocar, limpar e reatribuir o array; **mutação** (raio sem o maior bloqueio) → 2 falhas | custo/passo −4% a −48% (mais com mais bloqueios) |
| O2 | `Battle._reach_grid`: células bloqueadas e componentes livres calculados uma vez por fase e mapa (já aquecido em `place_scenery`); por consulta só se escolhem os componentes tocados pela célula do herói | `tests/test_reach_grid.gd`: grade **byte a byte** igual à busca em largura anterior (copiada no teste), com anel fechado de bloqueios e montanhas de Durão; **mutação** (só a célula do herói) → várias falhas em 4 combinações de fase e mapa | picos de interativos 25–58 ms → ≤ 1,6 ms |
| O3 | `Battle._grid.get(chave, EMPTY_CELL)` em vez de `[]` | hash igual; 6 de 6 comparações melhores | −2% a −5% |

**Hash do estado final (inimigos, tempo, PV, nível, posição, projéteis, zonas, estatísticas, armas): IGUAL antes e depois nas 9 fases**, e `replica_fiel=true` em todas.

| Fase | Bloqueios | µs/passo antes → depois | p95 antes → depois | Pico antes → depois |
|---|--:|---|---|---|
| Dagruve | 39 | 1444 → 1362 (−6%) | 1771 → 1817 | 33,0 → 7,3 ms |
| Docas | 49 | 1505 → 1342 (−11%) | 1946 → 1870 | 34,4 → 34,1 ms* |
| Shedaklah | 100 | 2597 → 1720 (−34%) | 3445 → 2344 | 58,8 → 37,4 ms* |
| Molor | 196 | 4225 → 2150 (−49%) | 5775 → 3252 | 54,3 → 20,4 ms* |
| Durão | 135 | 812 → 556 (−31%) | 1215 → 897 | 3,5 → 1,9 ms |
| Feng Tu | 115 | 943 → 559 (−41%) | 1432 → 860 | 1,9 → 2,4 ms |
| Shendilavri | 131 | 2102 → 1281 (−39%) | 2566 → 1777 | 51,1 → 8,0 ms |
| Goranthis | 142 | 768 → 436 (−43%) | 1446 → 781 | 2,1 → 2,0 ms |
| Pilares | 61 | 643 → 510 (−21%) | 1305 → 920 | 2,0 → 1,5 ms |

\* Os picos que restam **mudam de passo a cada execução** da mesma simulação determinística (hash igual), então são ruído do sistema (Windows, coletor, antivírus), não custo do código; o pico reproduzível era o dos interativos, e esse caiu para ≤ 1,6 ms (`spawn_random_interaction`, `fire_stage_event`, `kill`). O p95 e a média são a leitura confiável.

## 4. Não aplicado (candidatos, sem mudar comportamento ainda)
1. `_combat_count()` percorre os inimigos e chama `has_flag` (varredura de array) a cada passo: ~22 µs, ~1,5% do passo; um contador mantido nas mortes e nascimentos resolveria.
2. `_build_grid()` recria dicionário e arrays por passo: 20–55 µs (2–4%).
3. `_enemy_step` por inimigo faz ~10 µs fora da movimentação (chamadas a `_check_boss_phase`, `_decoy_for`, `RandomEvents.world_mult`, laços 3×3): reestruturar exige cuidado com a ordem de aplicação da separação.
4. `Hero.can_stand` ainda calcula `blockers.hash()` a cada chamada (~1,7 µs com 196 bloqueios); um sinal de "bloqueios mudaram" tiraria isso, mas exige tocar `ui/run.gd` e `StageStructures`.
5. Higiene: os testes não liberam todos os nós (84 instâncias vazadas no encerramento da suíte).

## 5. Pendências e limites
1. **Subjetivo (fluidez percebida, hitches em máquina fraca, 40+ min de partida) aguarda playtest do dono**; a medição aqui é CPU da simulação e um quadro com GPU nesta máquina.
2. A política da sonda não é a de um jogador: heróis e armas variam, e só `durvall` foi medido; outros heróis (principalmente com projéteis e zonas densas) não foram medidos.
3. A medição de `sfx.gd` foi por estimativa; o autoload não foi cronometrado.
4. Sem commit, push, exportação nem aviso aos testers. Arquivos de código alterados: `core/hero.gd`, `core/battle.gd`; novos: `tests/test_blocker_index.gd`, `tests/test_reach_grid.gd`, `tools/perf_probe.gd`, `tools/perf_probe.tscn`.
