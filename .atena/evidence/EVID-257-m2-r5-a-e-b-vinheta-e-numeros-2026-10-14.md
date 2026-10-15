---
id: EVID-257
title: M2 R5, opcoes A (vinheta de vida baixa e golpe) e B (numeros mais legiveis)
spec: SPEC-177
plan: PLAN-103 / B-003
date: 2026-10-14
content_state: DRAFT
---

# EVID-257 — M2 R5, lotes A e B

Aprovacao do dono (G-M2-3, 2026-10-14): "Siga o M2 R5 com as opcoes A e B, um lote por opcao, com teste e captura."

## Lote A — aviso de vida baixa e de golpe recebido
- `core/danger_feedback.gd` (`DangerFeedback`, funcoes puras): vida baixa entra abaixo de 30% e sai acima de 36% (histerese); opacidade 0,14 a 0,42 mais pulso de 0,06 a cada 1,6 s; flash de golpe de 0,16 a 0,45 em 0,35 s; teto de 0,55.
- `ui/danger_vignette.gd` (`DangerVignette`): gradiente radial vermelho nas bordas, fade de 2/s, invisivel com vida boa, ignora o mouse.
- `ui/run.gd`: camada `DangerLayer` na camada do texto, criada antes dele (os numeros ficam acima); `tick` em `_process`; `on_hurt` no evento `hurt`.
- Dano continuo da neblina (SPEC-177 F-1) **nao** flasha, so entra na vida baixa; "Impacto reduzido" deixa a vinheta estatica (x0,7, sem pulso) e tira o flash.
- Some quando a partida acaba (`dead`/`won`).

## Lote B — numeros mais legiveis
| Numero | Antes | Depois |
|---|---|---|
| Acerto comum | 14 px, contorno 4 | 16 px, contorno 5 |
| Faixas 1 a 3 | 18, 24, 30 | 19, 25, 31 (contorno 5, 6, 7) |
| Dano recebido pelo heroi | 16 px, contorno 4 | 20 px, contorno 5, vermelho mais claro |
| Cura | 14 px | 16 px, contorno 5 |
| Avisos (Guarda, Esquiva, Barreira) | 12 px | 14 px, contorno 5 |
Limite de 14 numeros de acerto mantido. `tests/test_l3_damage_feedback.gd` passou de "14 px" para "16 px" (M2 R5 B).

## Verificacao
| Verificacao | Resultado |
|---|---|
| `tests/test_danger_feedback.gd` (novo): histerese, escala com a vida, estatica no impacto reduzido, flash (teto, decaimento, sem flash continuo/reduzido), fade, mouse, fim de partida, tamanhos do B | 0 falhas |
| Suite completa | 0 falhas |
| Smoke das nove fases | ok |
| Capturas `tools/capture_danger_feel.tscn` (dagruve, durvall), antes e depois | `.atena/generated/m2-game-feel/r5/{antes,depois}/` |

Antes = HEAD (`dadab18e`) com a mesma sequencia: normal, vida 25%, pulso, golpe de 20% da vida, vida 25% com impacto reduzido.

## Nao verificado (humano)
- Se a vinheta e util ou irritante, e se a forca esta certa (a primeira versao foi reduzida depois da captura: inicio em 68% do raio, 0,14 base).
- So uma fase e um heroi foram fotografados; piso claro (Durao, Feng Tu) merece conferencia.
- Numeros em combate denso (14 simultaneos) a 16 px nao foram fotografados em fase mais cheia.
- Custo em maquina fraca: a vinheta e uma textura 128x128 esticada, desligada com vida boa; nao medida com `FrameStats`.

## Reversao
`git checkout -- ui/run.gd core/damage_feedback.gd tests/test_l3_damage_feedback.gd` e apagar `core/danger_feedback.gd`, `ui/danger_vignette.gd` e seus testes; o commit e unico por lote quando autorizado.
