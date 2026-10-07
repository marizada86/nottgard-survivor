# EVID-196 — Marcas do Abismo, B-001 (núcleo de combate)

Plano: PLAN-074 · Spec: SPEC-141 · Cartão: MEC-040 · Data: 2026-10-07 · Lote: B-001 (S-001, S-002, S-003). **Sem commit.**

## O que mudou
- `data/abyss_marks.json` (novo) e `core/abyss_marks.gd` (novo, funções puras).
- `core/battle.gd`: `abyss_marks`/`abyss_level`/`abyss_start_stage` e multiplicadores pré-calculados (`_mk_*`) a partir de `ctx.abyss_marks`.
  - **Horda:** `cap`, taxa (`every ÷ mult`) e `max` das ondas; a horda de evento também escala.
  - **Fúria:** `_stage_dmg_mult` (golpe e área; poça e névoa não).
  - **Carapaça:** PV em `_spawn` (chefe incluso; `quebravel` fora).
  - **Pressa:** velocidade em `_spawn` (chefes fora).
  - **Fome:** `_heal_amount` em `_heal_hero` e novo `_add_hp` nos três pontos que somavam PV direto (cura da nova, roubo de vida, "Provisões" do nível). Recuperação ao descer pelo portal passa por `_heal_hero` e **conta como cura** (reduzida pela Fome).
  - **Moeda:** `_reward_multiplier_for` × (1 + 0,10 × nível); `result()` ganha `abyss_level`, `abyss_marks`, `abyss_start_stage`.
- `tests/test_abyss_marks.gd` (novo).

## Verificações
| Verificação | Resultado |
|---|---|
| `tests/test_abyss_marks.gd` | 0 falhas |
| Suíte inteira (`tests/run_all.gd`) | 0 falhas (avisos de RID/ObjectDB ao sair já existiam) |
| **Marcas desligadas = run idêntica ao HEAD** | Mesmo fingerprint (RNG, nascimentos, inimigos vivos, PV, abates, multiplicador de moeda) em Dagruve, Shedaklah e Molor, 600 passos, semente 11, comparando `core/battle.gd` de HEAD com o novo em cópias do projeto |
| Densidade (Horda), herói imortal e sem armas, 70 s simulados, semente 7 — nascidos | Dagruve 46 / 51 / 61 / 72 (níveis 0 a 3); Shedaklah 36 / 43 / 47 / 54; Molor 35 / 42 / 48 / 61. Nível 3 = +50 % a +74 % (abaixo do nominal 60 % só onde `max` da onda limita) |
| Cobertura da Fome | teste varre `core/battle.gd` e falha se houver outro ponto de PV direto além de `_heal_hero` e `_add_hp` |

## Notas
- A Fome (nível 3) deixa 25 % da cura; a barreira por excesso (`overheal_shield`) é calculada depois, sobre o excesso do valor já reduzido.
- Não tocados: `data/abilities.json` e `data/weapons.json` (alterações de outra sessão), `ui/`, `core/profile.gd`, `core/game.gd`.
- Pendente (B-002 em diante): perfil e liberação, recompensa e conquistas, interface, bot, validação final.

## Nota de numeração
Este registro foi aberto como EVID-191 e renumerado duas vezes em 2026-10-07: EVID-191 → EVID-193 (a economia de ouro já usava a 191) → EVID-196 (ela também ficou com a 193). Os links e referências foram atualizados.
