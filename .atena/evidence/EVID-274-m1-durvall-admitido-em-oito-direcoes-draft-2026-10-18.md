# EVID-274 — M1, S-010: Durvall admitido em `assets/` com 8 direções reais (DRAFT)

Data: 2026-10-18 · PLAN-103 / B-002 / SPEC-176 · Estado: DRAFT; sem promoção a CANON · Autorização: dono, "prossiga com a implementação" (2026-10-18), sobre a candidata da EVID-273. O aceite visual em jogo (G-D4) continua sendo do dono.

## O que mudou

- **Arte:** as 9 tiras da candidata v03 entram em `assets/animations/heroes/durvall/` (`move_e`, `move_se`, `move_s`, `move_n`, `move_ne`, `move_w`, `move_sw`, `move_nw`, `attack`), em células de 512×512 (6 quadros; ataque 4). Os arquivos anteriores estão em `.atena/generated/chatgpt-integration-2026-10-17/m1-durvall/backup/` (`*_antes.png`). `idle`, `move`, `active` e `death` seguem como eram (256×384).
- **`ui/hero_view.gd`:** `strip_cell` e as tabelas `WIDE_CELL_STRIPS` (células de 512 px só para essas tiras) e `REAL_WEST_WALK` (W, SW e NW com tira própria, **sem espelho**: a espada não é simétrica). A célula larga tem os pés na linha 440, que cai no mesmo ponto dos pés em 376 da célula 256×384, então o deslocamento e a escala do sprite não mudam. O laboratório (`--walk-candidate`) continua funcionando.
- **`tests/test_animation_assets.gd`:** dimensões novas das 9 tiras; `_walk_metrics` mede na célula da tira e leva a base ao equivalente de 256×384. Dívidas conhecidas registradas, como o arquivo já previa: massa de `durvall/move_e` e `move_se` fora de ±30 % do idle (espada e passada longa) e base de `durvall/move_ne` (3 dos 6 quadros no ar puxam a mediana 13 px). Só podem encolher: ao regerar a tira, remova a entrada.

## Atenção para o seu olho

- **`move_sw` vem do LOT17** (candidata a substituir a P9, que segue retida), não da P9; o traço e a iluminação diferem um pouco das outras direções. Se não servir, volte o `move_sw_antes.png` do backup (o jogo volta a espelhar o SE) ou peça nova geração.
- O ciclo de corrida mantém quadros no ar (NE e NW: pé 14 a 22 px acima da base), como o contrato de prompt previa.
- Ritmo: 10 fps (G-D2). O reforço procedural da passada continua só no laboratório.

## Verificação

- Importação sem erro; `tests/run_all.gd` **0 falhas** (depois de ajustar o teste como acima); smoke das 9 fases `ok`; `controller_check` 94/0; `mobile_buttons_check` 146/0.
- Captura no `HeroView` do jogo, sem laboratório (`m1-durvall/capturas/`): as 8 direções escolhem `move_e`, `move_se`, `move_s`, `move_sw`, `move_w`, `move_nw`, `move_n`, `move_ne`, com 6 quadros cada; SW, W e NW são reais e sem `flip_h`; o ataque toca nas 8 vistas.

## Não verificado

Fluidez, sensação e o patinar (BUG-028) só pelo seu olho, jogando de verdade. BUG-025, 027, 028 e 029 seguem abertos; nenhum é fechado por esta integração. Sem commit, push, build nem exportação.

## Próximo (M1)

Lote 2 de heróis (3 a 4, com gate visual seu): LOT15 traz as costas de seis heróis (36 revisões), ainda com registro e escala a preparar contra o ART-056; **Nyrelia 03/04 está retida**.
