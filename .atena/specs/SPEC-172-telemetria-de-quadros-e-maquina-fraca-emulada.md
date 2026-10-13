---
id: "SPEC-172"
title: "Telemetria de maquina e quadros no kit de playtest e emulacao de maquina fraca"
status: "IMPLEMENTADA LOCAL em 2026-10-11 (PLAN-099, EVID-241); aguarda dados de campo"
origin: planned
implementation_preceded_spec: false
request_classification: PLAN_DEVIATION
created: "2026-10-11"
relations: ["[[SPEC-171-bateria-da-0-4-0-e-revisao-de-desempenho-por-idade]]"]
cards: ["TOOL-007"]
---

# SPEC-172 — Telemetria de quadros e máquina fraca emulada

Origem: pedido do dono em 2026-10-11 ("vamos analisar o que podemos fazer sobre a fluidez em máquina fraca (EVID-240)"), após a análise que mostrou **zero dados de campo**: nenhum relato de lentidão e nenhum registro de hardware ou FPS no kit.

## Decisões do dono (2026-10-11)
| # | Decisão |
|---|---|
| D1 | Alvo: notebook ou PC antigo com Windows (o mesmo `.exe` dos testers). |
| D2 | Escopo: **A** (telemetria no kit F4–F7) e **F** (emulação de máquina fraca). B (judder/interpolação), C, D e E ficam fora. |
| D3 | Rota: fazer agora e voltar ao PLAN-071; por plano (DEV-039). |

## Evidência de partida
- `grep` no código: nenhuma coleta de `get_processor_name`, `get_video_adapter_name`, memória nem FPS (só o `walk_trace` de depuração).
- Os registros do kit (`estatisticas.log`, notas F5, log do jogo) já vão no ZIP do F7; `RunRecord.checkpoint(b, kind, details)` aceita `details` livres, sem tocar o contrato v1 (`/api/playtest/runs`).

## Comportamento novo
1. `FrameStats` (puro, testável): acumula o tempo de cada quadro num histograma de 1 ms; entrega por janela e no total `quadros`, `fps`, `ms_medio`, `ms_p95`, `ms_p99`, `ms_max`, `lentos_33` (acima de 33,3 ms) e `lentos_50`. Descarta intervalos acima de 2 s (janela minimizada, Alt-Tab).
2. `MachineInfo`: SO e versão, CPU (nome e núcleos), RAM física, GPU (nome e fornecedor), renderer e driver, resolução da janela e da tela, taxa de atualização, modo de tela e versão do Godot. **Sem** nome de usuário, pasta, host nem identificador de máquina.
3. O `Playtest` alimenta o `FrameStats` a cada quadro. Cada checkpoint `minute` leva `quadros` da janela do minuto; o `finish` leva `quadros_total` e `maquina`.
4. O contexto de cada nota F5 leva `maquina` (uma linha) e `quadros` (últimos segundos), então um "travou aqui" já chega com os números.
5. O log do jogo ganha uma linha `Maquina: ...` na abertura.
6. **Emulação:** `tools/perf_emulate.ps1` roda a sonda `perf_probe` com afinidade de 1 núcleo, prioridade reduzida e, opcionalmente, N queimadores no mesmo núcleo, que dividem a CPU; imprime o fator de lentidão medido e a fração do quadro de 16,7 ms usada. Limite declarado: emula CPU, **não** GPU nem VRAM.

## Fora do escopo
Interpolação de física e métrica de judder (B), modo desempenho (C), compressão de textura (D), restos da simulação (E), HUD de FPS visível ao jogador, envio automático para servidor e qualquer mudança de jogabilidade ou balanceamento.

## Aceite
1. `FrameStats` e `MachineInfo` com testes (histograma, percentis, descarte de intervalos longos, campos presentes, sem usuário nem caminho).
2. Checkpoint `minute` e `finish` com os campos novos; contrato v1 e o resto do snapshot intactos.
3. Contexto de nota com `maquina` e `quadros`; suíte, smoke, controller, mobile e kit sem falhas.
4. Emulação rodada com ao menos 3 níveis de lentidão e registrada no EVID-241, com o limite declarado.
5. Subjetivo (os dados chegarem de máquinas reais dos testers) pendente de playtest.
