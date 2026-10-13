# EVID-241 — Telemetria de quadros e máquina fraca emulada (2026-10-11)

**Origem:** dono, "vamos analisar o que podemos fazer sobre a fluidez em máquina fraca (EVID-240)".
**Desvio:** DEV-039 (PLAN_DEVIATION do PLAN-071); alvo notebook/PC antigo com Windows; alavancas A e F; por plano (PLAN-099, SPEC-172).
**Estado medido:** HEAD `b83f188` + árvore de trabalho; Godot 4.7.2. Logs em `.atena/generated/plan-099/`.

## 1. O que foi construído (alavanca A)
| Peça | O que faz |
|---|---|
| `core/frame_stats.gd` (`FrameStats`) | Histograma de 1 ms por janela e no total: quadros, fps, ms médio, p95, p99, máximo, quadros abaixo de 30 e de 20 fps. Descarta intervalos acima de 2 s (janela minimizada, Alt-Tab) e os conta em `ignorados` |
| `core/machine_info.gd` (`MachineInfo`) | SO e versão, CPU e núcleos, RAM física, GPU (nome e fornecedor), renderer e driver, janela, tela, taxa de atualização, modo, versão do Godot, web. **Sem** usuário, pasta, host nem identificador de máquina |
| `core/playtest.gd` | `frame_stats` alimentado em todo `_process`; **contexto de cada nota F5** ganha `maquina` e `quadros` |
| `ui/run.gd` | checkpoint `minute` leva `quadros` (a janela do minuto); `finish` leva `quadros_total` e `maquina`; estatística zerada ao abrir a run |
| `core/game.gd` | linha `Maquina: ...` no log do jogo |

Contrato v1 do registro da run (`/api/playtest/runs`) **intocado**: os campos novos vão só em `details` dos checkpoints, que já eram livres.

## 2. Emulação (alavanca F, `tools/perf_emulate.ps1`)
Nota de processo: a primeira rodada foi **descartada**. Com `powershell -File` o parâmetro `-Niveis 0,1,3,7` virou o texto "0,1,3,7" e foi lido como **137** queimadores (98 ms/passo, picos de 6,7 s). Defeito da ferramenta, corrigido (`-Niveis "0,1,3,7"`); nenhum número daquela rodada foi usado.

### `sim` (CPU contínua; 1 núcleo, molor e shedaklah, 60 s simulados, `replica_fiel=true`)
| Lentidão | Molor µs/passo | Shedaklah µs/passo | Fração do quadro de 16,7 ms |
|---|--:|--:|---|
| livre | 792 | 759 | ~5% |
| 1 núcleo, sem queimador | 820 | 781 | ~5% |
| ~2× (1 queimador) | 1.623 | 1.520 | ~10% |
| ~4× (3 queimadores) | 3.150 | 3.081 | ~19% |
| ~8× (7 queimadores) | 5.217 | 7.187 | 31–43% |

Leitura: **a simulação cabe no orçamento de 60 fps, em média, mesmo numa CPU 8× mais lenta presa a um núcleo.** O p95 e o pico dessa tabela (65–490 ms nas lentidões altas) são o escalonador do Windows tirando o jogo do núcleo para rodar os queimadores, não custo do código; só a média vale.

### `scene` (janela com GPU, molor, 68 inimigos, 66 draw calls, 900 quadros, vsync desligado)
| Condição | Quadro médio | p95 | Máx | Carga da fase |
|---|--:|--:|--:|--:|
| livre | 1,0 ms | 3,1 ms | 6,5 ms | 1,3 s |
| 1 núcleo | 1,1 ms | 1,8 ms | 4,0 ms | 1,6 s |
| ~2× | 1,4 ms | 3,5 ms | 7,2 ms | 1,6 s |
| ~4× | 1,4 ms | 3,4 ms | 7,2 ms | 1,6 s |
| ~8× | 1,4 ms | 3,5 ms | 8,1 ms | **3,2 s** |

**Estes números de `scene` NÃO são uma estimativa de máquina fraca.** O Windows aumenta a prioridade das threads gráficas que acordam de uma espera, então os queimadores não as seguram como seguram a simulação; o quadro quase não "sentiu" a lentidão. Só a **carga da fase** sentiu: 1,3 s → 3,2 s com 8× de lentidão.

## 3. Verificação
| Verificação | Resultado |
|---|---|
| Suíte (inclui `test_frame_stats`, novo) | 0 falhas; 2 mutações detectadas (limiar de intervalo longo e limite do balde de percentil) |
| Smoke 9 fases | ok |
| `controller_check` | 94/0 |
| `mobile_buttons_check` | 146/0 |
| `kit_test` | OK |
| `audit_projeto` | 0 erros, 7 avisos conhecidos |
| `backlog_check` | P0=0; 1 alerta (o link deste EVID, fechado com este registro) |

## 4. Limites e pendências
1. **A emulação é de CPU.** Não reproduz GPU, VRAM, disco nem o IPC de uma CPU antiga (cache, latência de memória). Estima a folga da simulação; **não prevê uma máquina específica**.
2. **Continua sem dado de campo.** A telemetria só começa a responder quando uma build com este código estiver nas mãos dos testers e chegarem notas ou ZIPs. Nenhum conjunto de máquina real foi coletado ainda.
3. **O que provavelmente decide em notebook antigo, e não foi medido:** vídeo integrado, VRAM (158–184 MB por fase, 844 texturas sem compressão) e a **carga da fase** (3,2 s a 8×).
4. Nada de judder/interpolação de física (alavanca B), modo desempenho (C), compressão de texturas (D) nem restos da simulação (E): ficaram de fora por decisão do dono; decidem-se pelos dados da telemetria.
5. A amostra desta medição é a do `durvall`; heróis com projéteis e zonas densas não foram medidos aqui.
6. Sem commit, push, exportação nem aviso aos testers. **A telemetria só chega ao tester em uma build nova.**
7. Arquivos `.uid` pendentes de commit (do PLAN-098 e deste): `tests/test_blocker_index.gd.uid`, `tests/test_reach_grid.gd.uid`, `tools/perf_probe.gd.uid`, `core/frame_stats.gd.uid`, `core/machine_info.gd.uid`, `tests/test_frame_stats.gd.uid`.
