# EVID-270 — PLAN-110 / SPEC-185, lote B-002 parte B (sistema de animação de interações e NPCs)

Data: 2026-10-18 · Estado: DRAFT (direção visual aceita pelo dono no pacote do Codex; preparação técnica e admissão são deste escopo) · Aprovação do sistema novo: dono, 2026-10-18 ("Aprovo o sistema novo de animação de interações e NPCs. Siga com o B-002 ... parando nas retenções").

## Sistema

- `ui/interaction_anim.gd` (`InteractionAnim`) e `data/interaction_anims.json` (36 tiras). Cada tira está na escala da arte estática (1 px = 1 px da textura estática) com 48 px de folga em volta (célula = textura + 96); o jogo desenha o quadro atual no retângulo da arte estática, ampliado pela folga, em loop de 5 fps, com fase própria por objeto. Sem tira, a arte estática segue como antes.
- Ligação em `ui/overlay.gd`: interações e eventos aleatórios (`_draw_over`), pontos de evento (`event_*`), câmara selada e aberta, NPCs aliados (`_draw_happenings`), ruína atrás do baú do ponto, e Eco. Interativo com cenário próprio (Poço de Oferendas, Oficina do Cais) não troca de arte.
- Aberturas dos baús em `ui/run.gd` (`_play_interaction`): `chest_open` (IA01) e `boss_chest_open` (IA02), 6 quadros de 256 px (arte estática de 192 px + 32 px de folga), 10 fps, mesma escala e mesmo ponto de apoio de antes. O `chest_open.png` antigo está em `b002/backup/`.

## Preparação (`tools/prepare_idle_strips.gd`, relatório em `b002/idles-preparacao.json`)

38 fontes copiadas com SHA-256 conferido contra os manifestos (38 de 38). Só limpa o ruído de alfa < 16/255 e torna opaco o sólido (alfa ≥ 0,9). Cada quadro é reduzido pelo mesmo fator (altura visível do primeiro quadro contra a arte estática; razões de largura entre 0,85 e 1,09) e o registro dos quadros 2 a N é corrigido só por translação (base e centro da parte baixa, como no quadro 1); 0 pixel fora da célula. Os deslocamentos aplicados ficam no relatório; os maiores são Doação (36 px horizontal e 24 vertical em 256), Nyxara (20 px) e Aposta (14 px), coerentes com os desvios de registro que o pacote já declarava.

| Lote | Peças integradas |
|---|---|
| LOT03 | IA01 baú comum e IA02 baú de chefe (aberturas); IA03 loja, IA04 ferreiro, IA05 curandeiro |
| LOT06 | IE01 doação, IE02 aposta, IE03 ampulheta, IE04 arcanista, IE05 peregrino, IE06 contador |
| LOT07 | NE01 João, NE02 desertor, NE03 vítima, NE04 Nyxara, NE05 Vaelis, NE07 Reaper, NE08 Vhaerith, NE09 mercador |
| LOT09 | EP01 trono, EP02 arco, EP03 massa, EP04 estrela, EP05 coração, EP06 esporo, EP07 limo |
| LOT10 | ES01 pacto, ES02 relicário, ES03 carroça, ES04 Eclipse, ES05 Eco, ES06 câmara selada, ES07 câmara aberta |
| LOT11 | RU01 Dagruve, RU02 Docas, RU03 Shedaklah, RU04 Molor, RU06 Feng-tu |

## Retido ou sem consumidor (NÃO integrado)

- **Retenções do pacote, preservadas:** NE06 Graz'zt (corte da espada) e seu candidato substituto LOT08 GR01 a GR04; RU05 Durao, RU07 Shendilavri e RU08 Goranthis e seus candidatos substitutos LOT12 (DR, SR, BR); FC02 (jato) e seus substitutos LOT08 FJ01 a FJ04. Nenhuma foi liberada por aceite de direção; `tests/test_interaction_anim.gd` impede que Graz'zt, Durao, Shendilavri e Goranthis entrem na tabela.
- **Sem consumidor no jogo:** LOT03 IA06 (barril; os barris são cenário sem morte), LOT06 FC01 (ícone do lança-chamas, MEC-004 não implementada) e LOT08 PR01 a PR03 (pavilhão, jaula e canoa, props hipotéticos sem uso previsto).
- Mantida a decisão do dono: UI01 (moldura de progresso) não integrada.

## Verificação

- Importação sem erro; `tests/run_all.gd` **0 falhas** e sem SCRIPT ERROR (`test_interaction_anim.gd` novo: tabela, tiras, células, base e altura do primeiro quadro, loop, fase, geometria; `test_animation_assets.gd` ajustado para as duas aberturas de baú de 1536×256). Corrigido de passagem um id inválido ("cultista") do `test_breakable_death_art.gd` que gerava 2 erros de script.
- Smoke das 9 fases `ok`; `controller_check` 94/0; `mobile_buttons_check` 146/0 (perfis regravados restaurados); `backlog_check` 0 P0.
- Capturas em janela real (`b002/capturas/`): serviços e mesas, eventos, câmara selada e aberta, pontos de evento, 8 NPCs, ruínas atrás do baú, Eco e abertura dos baús (fechado e 3 instantes).

## Não verificado

Fluidez, ritmo (5 fps) e sutileza dos idles em jogo contínuo, leitura da ruína animada e do Eco, e o peso da abertura dos baús: **o dono avalia**. Os deslocamentos de registro foram corrigidos por translação; se algum idle parecer "flutuar", o relatório permite refazer só aquele. Sem playtest, commit, push, build nem exportação.
