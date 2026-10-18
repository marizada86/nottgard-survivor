# EVID-275 — M1, S-011: lote 2 de heróis, costas e nordeste de Zynara e Leoric (LOT15), DRAFT

Data: 2026-10-18 · PLAN-103 / B-002 / SPEC-176 · Estado: DRAFT; sem promoção a CANON · Autorização: dono, "prossiga com a implementação" (2026-10-18). O aceite em jogo (gate visual do lote) é do dono.

## Escopo

LOT15 traz `move_n` e `move_ne` (costas) de Zynara, Leoric e Nyrelia, 6 quadros individuais de 1254×1254 por ciclo. Entram **Zynara e Leoric** (4 tiras). **Nyrelia (YN, YE) fica retida**: o pacote registra `LOT15_NYRELIA_REGISTRATION_AFTER_THREE_ATTEMPTS` (ciclo com salto depois de três tentativas); nada dela foi copiado nem ligado. As outras retenções do LOT15 (alfa, margem, registro e cadência) são trabalho de preparação e foram tratadas abaixo.

## Fontes e preparação

24 PNGs (ZN00 v02, ZN01..05; ZE00..02, ZE03 v02, ZE04 v02, ZE05; LN00..05; LE00..02, LE03 v02, LE04 v02, LE05, todos v01 salvo indicação) copiados para `.atena/generated/chatgpt-integration-2026-10-17/m1-lote2/fontes/` com SHA-256 conferido contra o recibo de aceite (24 de 24). Juntados em grades 3×2 (`tools/m1_compose_grid.gd`) e normalizados por `tools/m1_normalize_strip.gd` como no piloto do Durvall: uma escala por tira (0,38 a 0,39), altura-alvo = altura do idle do próprio herói (Zynara 368 px, Leoric 224 px), célula de 512×512 com os pés na linha da célula original + 64 (Zynara 440, Leoric 432; no jogo isso cai nos pés de 376 e 368 da célula 256×384), âncora pela cabeça. Nenhum pixel redesenhado; o ruído de alfa baixo fica fora porque só entra o componente principal.

| Tira | Altura por quadro (px) | Base (px, célula larga) | Nota |
|---|---|---|---|
| Zynara N | 366 a 369 | 438 a 440 | base estável (≤ 2 px) |
| Zynara NE | 359 a 372 | 433 a 440 | |
| Leoric N | 216 a 224 | 424 a 432 | 4 de 6 quadros no ar (3 a 8 px) |
| Leoric NE | 222 a 226 | 426 a 432 | |

## Ligação

`ui/hero_view.gd`: `WIDE_CELL_STRIPS` ganha `zynara` e `leoric` (só `move_n` e `move_ne`); `idle`, `move`, `move_e/se/s`, `attack`, `active` e `death` seguem na célula 256×384, e o NW continua o espelho do NE (como antes). `tests/test_animation_assets.gd`: dimensões das 4 tiras e a dívida de base de `leoric/move_n` (mediana de 361 contra 368 por causa dos quadros no ar), junto com a do Durvall. Arquivos anteriores em `m1-lote2/backup/`.

## Verificação

- Importação sem erro; `tests/run_all.gd` **0 falhas**; smoke das 9 fases `ok`; `controller_check` 94/0; `mobile_buttons_check` 146/0.
- Captura no `HeroView` do jogo (`m1-lote2/capturas/`): N e NE tocam as tiras novas (6 quadros, sem `flip_h`), o resto das direções segue como antes; sem rosto nas costas.

## Não verificado

Fluidez, sensação e o patinar só pelo seu olho. Os alvos do ART-056 (spread ≤ 12 px, centro ≤ 9 px, largura ≤ 16 %) foram conferidos pela altura e base por quadro, não por uma auditoria completa dos números finais. O NW de Zynara e Leoric é o NE espelhado (a mão do objeto troca de lado), como antes. BUG-025, 027, 028 e 029 seguem abertos. Sem commit, push, build nem exportação.

## Próximo

Ainda sem costas novas: Nyrelia (retida) e os outros heróis; as direções E, SE e S de Zynara e Leoric seguem as tiras antigas.
