# SPEC-084 — Bênção do Selo: recompensa ao interromper o ritual (MEC-026)

Status: **implementada (2026-09-29); números a validar em playtest.**

Origem: BUG-014, relatado por T01 e T02 (T02 o pôs como prioridade nº 1), contestado
por T03 ([[EVID-107-playtest-publico-t02-hiago-2026-09-29]], [[EVID-108-playtest-publico-t03-dna-2026-09-29]]).
Decisão D1 do dono em [[PLAN-038-atualizacao-pos-playtests-t01-t02-t03-2026-09-29]]: **dar recompensa**;
escolha em 2026-09-29: **bênção temporária**.

## Decisão

No ritual da névoa (Dagruve, regra `rituals`), ficar no selo até interromper já
impede os reforços; agora também concede a **Bênção do Selo** por 20 s:
**+20% dano, +15% velocidade, +1,0 de alcance de coleta** (`data/difficulty.json`, `ritual_blessing`).

## Implementação

- `Hero.temp_mods` e `Hero.temp_t` entram em `recalc()` enquanto `temp_t > 0`; expiram em `Hero.step` (`core/hero.gd`).
- `Battle._grant_ritual_blessing`, chamado quando o selo é interrompido (`core/battle.gd`); aviso na tela com os valores.
- Teste em `tests/test_battle.gd`: ritual interrompido dá `temp_t > 0` e sobe `dmg_pct`; depois de 26 s volta ao valor base.

## Limites

- Não muda a penalidade de deixar o ritual completar (5 reforços).
- Conceito de bênção temporária é novo; outros usos ficam para depois.
- Reforçar ou reduzir os números é ajuste de JSON.
