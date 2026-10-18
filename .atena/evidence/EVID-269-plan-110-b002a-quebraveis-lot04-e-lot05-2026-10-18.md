# EVID-269 — PLAN-110 / SPEC-185, lote B-002 parte A (12 quebráveis, LOT04 e LOT05)

Data: 2026-10-18 · Estado: DRAFT (direção visual aceita pelo dono no pacote do Codex; preparação técnica e admissão são deste escopo) · Desvio: DEV-045.

## Fontes

12 grades 3×2 de 512×512 copiadas para `.atena/generated/chatgpt-integration-2026-10-17/b002/breakables/` com SHA-256 conferido contra os manifestos (12 de 12): QB01 v01, QB02 v03, QB03 v02, QB04 v01, QB05 v02, QB06 v02, QB07 v01, QB08 v02, QB09 v01, QB10 v01, QB11 v01, QB12 v02. As tentativas que o manifesto marca como não selecionadas (QB02 v01/v02, QB03/QB05/QB06 v01, QB08/QB12 v01) não foram usadas. O sexto quadro de cada grade é excluído; nenhum quadro de desaparecimento foi inventado.

## Preparação (`tools/prepare_breakable_deaths.gd`, relatório em `b002/breakables-preparacao.json`)

- Só limpa o ruído de alfa < 16/255 e torna opaco o sólido (alfa ≥ 0,9); cor, silhueta e luz ficam como entregues.
- Cada quadro é reduzido pelo mesmo fator, tirado do primeiro quadro contra a arte estática (altura visível), e posto numa célula de 512×512 na escala da arte estática: o primeiro quadro cobre a arte estática, a base fica na linha 432 e nenhum quadro é recentralizado sozinho (os estilhaços caem onde a fonte os pôs). Fatores de 0,40 (candelabro) a 0,93 (arbusto); 0 pixel fora da célula nas 12 tiras.
- Destino: `assets/animations/enemies/<id>/death.png`, 2560×512, 5 quadros, 9 fps, sem repetição.

## Ligação

`ui/enemy_view.gd`: tabela `DEATH_ONLY` (12 ids), célula e linha de base; a arte estática vale até a morte e, em `play_death()`, a tira a substitui no mesmo ponto de apoio da sombra (`_ground_point`). Posição, colisão, PV, loot e regras dos quebráveis não mudaram; inimigo comum segue com o desvanecer. `tests/test_breakable_death_art.gd` cobre as 12 tiras (tamanho, estado antes de quebrar, troca ao quebrar, base do primeiro quadro) e foi provado por mutação (12 falhas ao forçar a tira invisível).

## Verificação

- Importação sem erro; suíte 0 falhas em 3 de 4 execuções; **1 falha intermitente em `test_l5_boss_mechanics.gd`** ("quem fica no quadrante aceso deveria ser ferido", 50033,8 → 50033,8) numa execução, ausente nas duas seguintes e sem relação com este diff (nenhum código de chefe foi tocado); fica registrada para investigação.
- Smoke das 9 fases `ok`; `controller_check` 94/0; `mobile_buttons_check` 146/0. Os arquivos de perfil regravados por essas verificações foram restaurados.
- Capturas (`b002/capturas/quebraveis_*.png`): 12 quebráveis antes de quebrar e em 3 instantes da tira.

## Não verificado

Escala e leitura em jogo real (câmera e densidade de cena), duração de 0,55 s e peso do efeito: **o dono avalia**. Sem playtest, commit, push, build nem exportação.

## Pendência do B-002 (decisão do dono)

LOT03 (baús, loja, ferreiro, curandeiro, barril), LOT06 (idles de eventos, jato e ícone do lança-chamas), LOT07 (idles de 8 NPCs; NE06 retido), LOT08 a LOT12 (props, eventos, segredos, ruínas) pedem um sistema novo de animação de interações e NPCs (hoje `ui/overlay.gd` só anima 4 sheets fixos de 192 px) e registro contra os estáticos. É mudança de arquitetura de apresentação: aguardam aprovação própria.
