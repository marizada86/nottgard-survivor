# EVID-097 — Execução da SPEC-073 (nível de equipamento e super-upgrade)

Data: 2026-09-28
SPEC: [[SPEC-073-nivel-de-equipamento-e-super-upgrade]]
PLAN: [[PLAN-034-pendencias-restantes-2026-09-28]] (Fase C, item 1 de 2)

## Alterações realizadas

- `data/items.json`: cada uma das 13 bases (5 armas, 4 armaduras, 2
  amuletos, 2 anéis) ganhou um campo `"super"` — bônus fixo aplicado no
  nível máximo. Cota de Malha usa exatamente o exemplo do backlog original
  (`{"ca": 1, "forca": 2}`).
- `core/items.gd`:
  - `Items.roll()` agora inclui `"level": 1` no item retornado.
  - Novas constantes `MAX_LEVEL = 3` e `LEVEL_SCALE_STEP = 0.15`.
  - `Items.super_mods(item)`: busca o bônus fixo da base do item (`{}` para
    itens sem `base`, ou seja, únicos).
  - `Items.level_scale(item)`: multiplicador `1.0 + 0.15 * (level - 1)`
    aplicado aos mods do item ao agregar.
- `core/hero.gd`: `Hero.recalc()` agora escala os mods de cada item
  equipado pelo nível (via `add_mods(..., times)`, sem mutar o dicionário
  `mods` original do item) e soma o `super` da base quando
  `level >= Items.MAX_LEVEL`.
- `core/battle.gd`: `_open_shop_event("ferreiro")` ganhou uma segunda
  categoria de oferta — para cada item equipado com `base` definido e
  `level < MAX_LEVEL`, uma opção de subir 1 nível por preço crescente,
  reaproveitando a descrição via `Items.mods_text()`. `choose()` ganhou o
  tipo `shop_item_up`, que incrementa `item.level`, deduz `hero.gold` e
  chama `hero.recalc()` (necessário aqui porque, ao contrário do nível de
  arma, o nível de item afeta `Hero.mods` diretamente).
- `ui/hud.gd`: o painel de itens (`C`) agora mostra o nível do item
  equipado (`Nv X/3`, com aviso quando já está no máximo); ícone e cor de
  destaque adicionados para a nova oferta do ferreiro.
- `tests/test_battle.gd`: bloco novo (9f) cobrindo: item no nível 1 sem
  regressão de mods, upgrade de nível 1→2 escalando os mods corretamente,
  upgrade final aplicando o super-upgrade da base, item no nível máximo
  saindo da oferta do ferreiro, e itens únicos nunca aparecendo na oferta
  de upgrade.

Nenhuma mudança na fórmula de venda, na geração de itens, no sistema de
armas/evolução ou em itens únicos além de excluí-los explicitamente desta
oferta.

## Verificações executadas

| Comando | Resultado |
|---|---|
| `Godot_v4.7.2-stable_win64.exe --headless --path . -s tests/run_all.gd` | `testes: 0 falha(s)` |
| `Godot_v4.7.2-stable_win64.exe --headless --path . res://tools/smoke.tscn` | `smoke: ok` nas 8 fases |

Suíte e smoke passaram já na primeira execução.

## Exceção de validação

Sem checagem manual interativa (ver o painel `C` mostrando o nível do item,
negociar com o ferreiro e confirmar o super-upgrade visualmente numa run
real) nesta sessão. Nível máximo (3) e o multiplicador por nível (15%) são
estimativas de execução, explicitamente deixadas revisáveis pela spec.
