---
id: "SPEC-176"
title: "Movimento dos heróis: marco M1 da demo (PLAN-103)"
status: "DRAFT em 2026-10-14; estrutura do PLAN-103 aprovada pelo dono; aguarda aprovação do lote B-002"
origin: planned
implementation_preceded_spec: false
request_classification: PLAN_CHANGE_REQUEST
created: "2026-10-14"
relations: ["[[PLAN-103-demo-completa-e-polida-2026-10-14]]", "[[SPEC-123-revisao-da-movimentacao-dos-herois]]", "[[SPEC-144-diagnostico-do-patinar-ao-andar-bug-028]]", "[[SPEC-154-pixels-soltos-dos-herois-pre-reducao-das-tiras-bug-029]]", "[[SPEC-112-normalizacao-base-e-bordas-dos-herois]]", "[[SPEC-160-arlindo-orlando-e-erik-blackthorn-jogaveis]]"]
cards: ["BUG-025", "BUG-027", "BUG-028", "BUG-029", "ART-033", "ART-045", "ART-031"]
content_state: DRAFT
---

# SPEC-176 — Movimento dos heróis (M1)

Origem: PLAN-103, marco M1, decisão D7 do dono (2026-10-14): "marco próprio, com decisão sua pelo olho". Retoma, sob um só guarda-chuva e com a decisão do dono no centro, o que ficou espalhado em SPEC-123, SPEC-144 e SPEC-154. Risco: **médio** (arte e escala dos 12 heróis; reversível por herói; sem regras de jogo).

## Objetivo

Os 12 heróis jogáveis andam, atacam e morrem com aparência **estável e legível** em 8 direções, sem patinar de forma perceptível, sem mostrar o rosto ao andar para cima e sem pixels soltos, **segundo o olho do dono** e segundo um checklist medido. Isso cumpre o critério 3 da Definição de Pronto da demo.

## Estado de partida (lido em 2026-10-14)

| Tema | Estado |
|---|---|
| **BUG-028** patinar de lado e nas diagonais | Adiado em 2026-10-05. A tentativa A+B (15 fps e `speed_scale` ligado à velocidade) foi testada no `.exe` e **revertida a pedido do dono**. EVID-197: troca de tira e queda ao idle descartadas em campo livre com teclado; a arte desenha pés lentos em todas as direções (E 61, SE 12, S 9, NE 17, N 27 px/s de passada desenhada contra 190 px/s reais, Durvall a 10 fps). H5 (descompasso física × render) e o caso mouse/analógico dependem da coleta no PC do dono |
| **BUG-027** costas ao andar para cima | Zynara, Leoric e Nyrelia têm `move_n` e `move_ne` geradas de frente; 6 tiras; prompts prontos em ART-PROMPTS-056 (ART-033); decisão de design do dono: costas inventadas a partir da frente |
| **BUG-029** pixels soltos | Causa medida (redução com vizinho mais próximo). Mipmaps rejeitados em 2026-10-05; variante C da SPEC-154 não adotada em 2026-10-09; `HERO_STRIP_SET` vazio; ferramenta `tools/reduce_hero_strips.gd` existe |
| **BUG-025** dimensões ao andar e atacar | PARCIAL: 29 tiras igualadas por código; o resto é erro de arte; revisão completa de escala combinada para quando as imagens novas entrarem |
| **ART-045** Erik e Arlindo | Arte própria integrada local v04 (18 tiras, 2 retratos); ER03 = 7 e ER06 = 5 quadros; AO09, AO10, ER03 e ER06 pendentes de aceite (exceção de 14/13 px aceita só em AO04/AO07) |
| **Contrato de animação** (PLAN-001 §26) | 8 fontes de movimento por herói (`move_n` a `move_nw`); espelho só onde a simetria visual for confirmada |
| Ferramentas já prontas | `tools/audit_hero_motion`, `tools/equalize_hero_frames.gd`, `tools/normalize_hero_scale.gd`, `tools/measure_walk_stride.gd`, `tools/walk_trace_probe.gd`, `ui/walk_trace.gd` (`--walk-debug`), `tools/reduce_hero_strips.gd`, lançador `.atena/generated/walk-debug/Abrir-jogo-com-diagnostico.cmd` |

## Heróis no escopo (12)

arlindo, bromnor, brook, durvall, erik, kayron, korrak, leoric, maelor, nyrelia, sylas, zynara. Inimigos, retratos e HQs ficam de fora.

## Princípios

1. **Decisão pelo olho do dono antes de qualquer lote.** Nenhuma tira é gerada em série e nenhum valor global de velocidade ou ritmo muda sem comparação lado a lado.
2. **Código antes de arte quando o código resolve**, porque é reversível e grátis; arte só onde o código não alcança.
3. **Piloto antes de expansão.** Um herói por problema, depois os 12.
4. **Nada é apagado.** Originais ficam; cada herói tem entrada por tabela e pode voltar ao estado atual.
5. **Campo livre e janela real.** Evidência de movimento vem de partida real com a janela aberta, não só de teste headless.

## Lotes e passos (B-002, aprovação por lote)

Os passos terminam, cada um, em resultado verificável e em checkpoint. Os **portões do dono (G-D1 a G-D4)** pedem decisão explícita e param a execução.

### Fase A — Linha de base (sem alterar arquivos do jogo, sem cota de imagem)

| Passo | O que | Saída |
|---|---|---|
| S-001 | **Tabela herói × direção** para os 12: frente, costas ou perfil por tira; altura, largura e base por quadro; margem de borda; relação ataque/idle; simetria para espelho. Inclui Zumbi e Bandido de Dagruve como referência (dono: "ótimos") | `.atena/generated/m1-movimento/baseline.csv` e prancha por herói |
| S-002 | **Checklist de aceite** (§Critérios) instanciado por herói com os valores medidos de partida, incluindo a passada desenhada versus a distância por ciclo (calibrada na linha de base) | `checklist.csv` com "passa/falha/a decidir" |
| S-003 | **Coleta opcional do dono** (5 min): lançador de diagnóstico, modos 1, 3 e 5, para fechar H5 e o caso mouse/analógico | CSVs do dono triados (NON_BLOCKING) |

### Fase B — Laboratório de caminhos para o patinar (BUG-028), sem arte nova

| Passo | O que | Saída |
|---|---|---|
| S-004 | **Laboratório comparável.** Flags só de desenvolvimento (sem mudar o padrão) para ligar, lado a lado no mesmo herói e fase, quatro caminhos: **C0** atual; **C1** ritmo e velocidade (fps do ciclo e `SPEED_PX`, matriz pequena, ex.: 10/12/15 fps e 190/160/140 px/s); **C2** reforço procedural da passada (balanço vertical, inclinação sutil e sombra sincronizados ao ciclo, como o Korrak já usa); **C3** passada maior por arte (piloto em Durvall, reaproveitando o pacote do Caio e ART-PROMPTS-055) | Lançador do laboratório + capturas e clipes por caminho |
| **G-D1** | **Escolha do dono pelo olho:** C0, C1, C2, C3 ou combinação. Se nenhum agradar, BUG-028 volta a "conhecido" com o motivo registrado | Decisão registrada em evidência |
| S-005 | Aplicar o caminho escolhido ao piloto e validar com trace (0 trocas e 0 quedas em campo livre) | Piloto aprovado |

### Fase C — Costas, pixels e dimensões

| Passo | O que | Saída |
|---|---|---|
| S-006 | **BUG-027 piloto:** gerar `move_n` e `move_ne` de **Zynara** (2 tiras, ART-PROMPTS-056), auditar (alfa real, grade, sem corte, escala do idle) e preparar candidatas | Candidatas em `.atena/generated/`, nada admitido |
| **G-D2** | **Aceite visual do dono** das costas de Zynara; só depois Leoric e Nyrelia (4 tiras) | Decisão por herói |
| S-007 | **BUG-029 recapturar:** com a escala e as tiras novas já estáveis, capturar o piloto (Kayron) em 1280×720 e 1920×1080 nas variantes A, B e C da SPEC-154, com o atual ao lado | Prancha comparativa |
| **G-D3** | **Decisão do dono sobre pixels soltos:** variante, outra ideia sua, ou "conhecido na demo" | Decisão registrada |
| S-008 | **Fechar ART-045:** decidir AO09, AO10, ER03 e ER06 (aceitar com exceção, regerar ou manter provisório) e fixar a escala de Erik e Arlindo no mesmo critério dos demais | Decisão por tira |
| S-009 | **Revisão completa de escala (BUG-025):** `normalize_hero_scale` e `equalize_hero_frames` nos 12, `HERO_IDLE_ART_HEIGHT` e `HERO_FEET_Y` atualizados, sem mudar a altura em tela de nenhum herói | Linha de base nova |

### Fase D — Aplicação e aceite

| Passo | O que | Saída |
|---|---|---|
| S-010 | **Aplicar nos 12 heróis**, em lotes de 3 a 4, cada lote com suíte e captura; um commit por mecânica de movimento (código) e um por pacote de arte | Commits locais |
| S-011 | **Verificação técnica:** suíte, `test_animation_assets`, marcos de pés, `edge_frames` = 0, trace em campo livre nas 8 direções por herói, smoke das nove fases, `controller_check` e `mobile_buttons_check` | Relatório |
| S-012 | **Checklist de aceite em janela real:** 12 heróis × 8 direções, clipes ou GIFs curtos e prancha final | Checklist assinado por herói |
| **G-D4** | **Aceite do dono** do movimento dos 12 heróis | Recibo de aceite |
| S-013 | EVID, cartões BUG-025/027/028/029 e ART-033/045, índices e "O que testar" da próxima build | Documentos; commit, push e build só com aprovação |

## Critérios de aceite (checklist M1)

Aplicados por herói; "a decidir" vira decisão do dono no G-D4.

| # | Critério | Como se mede |
|---|---|---|
| CK-1 | **Costas ao andar para cima:** N e NE mostram costas ou 3/4 de costas; o espelho de NO vem da mesma tira | Olho do dono; tabela herói × direção |
| CK-2 | **Sem patinar perceptível** ao andar de lado e nas diagonais | Olho do dono (G-D1); métrica de passada calibrada na S-002 |
| CK-3 | **Altura estável:** variação entre direções e entre idle, andar e ataque dentro de ±3% da altura do idle | `audit_hero_motion` |
| CK-4 | **Base estável:** pés na mesma linha entre quadros e direções (±1 px) | `audit_hero_motion` |
| CK-5 | **Sem corte:** `edge_frames` = 0 e margem transparente ≥ 2 px em todos os quadros usados | Auditoria |
| CK-6 | **Sem troca de tira nem queda ao idle** em campo livre | `walk_trace_probe` nas 8 direções |
| CK-7 | **Pixels soltos:** ausentes nas capturas em 1280×720 e 1920×1080, ou declarados "conhecidos" por decisão do dono (G-D3) | Prancha |
| CK-8 | **Espelho só com simetria:** nenhuma tira espelhada que troque a mão da arma ou o lado do emblema sem decisão registrada | Tabela de simetria da S-001 |
| CK-9 | **Altura em tela inalterada** em relação à de hoje (±1 px), salvo decisão registrada | Teste de escala |

## Não objetivos

Balanceamento de velocidade como regra de jogo (a mudança de `SPEED_PX` do C1, se escolhida, é de **apresentação** e passa pelo bot antes de qualquer commit); inimigos e chefes; VFX de ataque e habilidade; refazer o Korrak (ART-031, prioridade baixa; entra só se o G-D1 ou o G-D4 pedir); retratos; mobile; arte nova fora das 6 tiras de BUG-027, das candidatas do C3 e das pendências da ART-045.

## Lacunas

| Id | Lacuna | Classe | Tratamento recomendado |
|---|---|---|---|
| G1 | Coleta do dono para H5 e mouse/analógico | RESOLVABLE | Fazer em paralelo à fase A; sem ela, C1 e C2 valem por comparação visual |
| G2 | Herói do piloto de movimento e de pixels | RESOLVABLE | **Durvall** para passada (histórico e pacote do Caio) e **Kayron** para pixels (capturas do bug) |
| G3 | Cota do gerador de imagem para S-006 (6 tiras mais C3) | RESOLVABLE | Dono gera; a ordem é Zynara, depois Leoric e Nyrelia |
| G4 | Acionar o especialista Caio para o C3 | DEFERRED | Só se o G-D1 escolher C3; o pacote local `.atena/generated/caio-durvall/` já existe |
| G5 | Mudar `SPEED_PX` altera a sensação de jogo e a fuga de inimigos | RESOLVABLE | Medir com o bot por herói antes do commit; se o bot regredir, preferir C2 |
| — | Lacunas `BLOCKING` | — | **Nenhuma** |

## Salvaguardas

Sem dependências novas; nada em `assets/` é substituído sem aprovação visual e evidência (PLAN-001 §17); candidatas ficam em `.atena/generated/` e permanecem DRAFT; o conteúdo desta spec não promove nada a canon; commit, push, exportação e aviso exigem aprovação à parte; alterações de outras sessões ficam intactas.

## Riscos

| Risco | Mitigação |
|---|---|
| Nenhum caminho de código agrada ao olho | O G-D1 aceita "conhecido" com o motivo; o plano segue sem travar |
| Arte nova muda a escala e invalida a redução de pixels | A fase C ordena escala antes da recaptura; a ferramenta de redução regera por herói |
| Mudar velocidade quebra o balanceamento | Passa pelo bot e pelo G5; C2 é o plano B |
| Cota de imagem limita o piloto de passada | C3 é opcional; piloto em um herói; o resto só depois do G-D1 |
