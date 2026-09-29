# EVID-099 — Execução da SPEC-075 (sinergias combinadas)

Data: 2026-09-28
SPEC: [[SPEC-075-sinergias-combinadas-arma-acessorio-magia]]
PLAN: [[PLAN-035-sinergias-combinadas-arma-acessorio-magia-2026-09-28]]

## Alterações realizadas

- `data/weapons.json`: as 8 armas evoluídas ganharam uma chave `"synergy":
  {"item_base", "name", "bonus_per_depth"}` — ver tabela da SPEC-075 para os
  8 combos (Muralha do Receptáculo, Fúria Sem Fim, Sentença Ampliada, Círculo
  Crescente, Luz Perene, Manto Estelar, Cera Abissal, Vendaval Constante).
- `core/hero.gd`: novo campo `synergies := {}` (id da arma evoluída → `true`)
  e `descent_depth := 0`. `Hero.recalc()` agora soma, para cada sinergia
  ativa, `bonus_per_depth * max(1, descent_depth)` — o bônus já vale a
  partir da ativação (mínimo ×1) e cresce a cada camada descida, sem teto.
- `core/battle.gd`:
  - `_build_offer()`: nova entrada de oferta `"synergy_activate"` para cada
    arma cujo id evoluído tenha `synergy` definida, ainda não ativada, com o
    acessório certo equipado no nível máximo (`_has_maxed_accessory`, nova
    função auxiliar).
  - `choose()`: novo tipo `"synergy_activate"`, marca
    `hero.synergies[id] = true` e chama `hero.recalc()`.
  - `enter_next_stage()`: agora sincroniza `hero.descent_depth` com
    `descent_depth` e chama `hero.recalc()` a cada descida, para que o bônus
    de sinergia escale imediatamente, sem esperar o próximo level-up.
- `ui/hud.gd`: painel de itens (`C`) agora lista sinergias ativas com o nome
  e o bônus atual (já multiplicado pela profundidade corrente).
- `tests/test_battle.gd`: bloco novo (10b) cobrindo: oferta não aparece sem
  o acessório certo nem com ele abaixo do nível máximo; item único nunca
  satisfaz a condição; oferta aparece com as 3 condições simultâneas;
  escolher ativa e soma o bônus mínimo (×1); não é oferecida de novo;
  perder o acessório depois de ativada não desativa a sinergia; descer duas
  camadas sincroniza `Hero.descent_depth` e escala o bônus de ×1 para ×2.

## Desvio da spec

A SPEC-075 ilustrava `synergy` aninhado dentro do bloco `evolve` da arma
**pré**-evolução (`"evolve": {"passive": ..., "into": ..., "synergy":
{...}}`). Na implementação, isso não funciona: ao evoluir, `Battle.choose()`
**substitui** o objeto `Weapon` por um novo cujo `def` é o dicionário da arma
**evoluída** (`core/battle.gd`, tipo `"evolve"`) — o dicionário da arma
pré-evolução, com seu `evolve.synergy`, deixa de ser acessível a partir de
`hero.weapons`. A `synergy` foi colocada como chave de topo no próprio
dicionário da arma evoluída (ex. em `espada_do_receptaculo`, não em
`espada_sombria`), que é o `id` que de fato persiste em `hero.weapons` depois
da escolha. O contrato (8 combos, condições, escala por profundidade) é
exatamente o aprovado — só o local do dado no JSON mudou.

## Verificações executadas

| Comando | Resultado |
|---|---|
| `Godot_v4.7.2-stable_win64.exe --headless --path . -s tests/run_all.gd` | `testes: 0 falha(s)` |
| `Godot_v4.7.2-stable_win64.exe --headless --path . res://tools/smoke.tscn` | `smoke: ok` nas 8 fases |

Suíte e smoke passaram após uma correção no próprio teste (ordem de captura
do valor de CA de referência antes da escala por profundidade).

## Exceção de validação

Sem checagem manual interativa (ver a oferta "SINERGIA: ..." aparecendo na
tela de level-up, o painel `C` listando a sinergia ativa e o bônus crescendo
visualmente ao descer de fase numa run real) nesta sessão. Nomes e valores de
`bonus_per_depth` são estimativas de execução, explicitamente deixadas
revisáveis pela spec conforme os próximos playtests.
