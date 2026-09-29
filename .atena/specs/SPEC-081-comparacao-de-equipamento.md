# SPEC-081 — Comparação de equipamento (MEC-019)

Status: **implementada (2026-09-29); validação em playtest.**

Origem: pedido mais repetido dos playtests, 5 relatos: T02 notas 3, 5 e 9 e texto
livre ([[EVID-107-playtest-publico-t02-hiago-2026-09-29]]), resposta 2 de
[[EVID-091-playtest-higo-hiago-build-c-e-item-offer-2026-09-28]] e o print 004 de
[[EVID-108-playtest-publico-t03-dna-2026-09-29]]. Plano: [[PLAN-038-atualizacao-pos-playtests-t01-t02-t03-2026-09-29]].

## Decisão

Quem decide sobre um equipamento precisa ver **o que ganha e o que perde**,
não só os atributos do item novo.

## Escopo

1. **Oferta de item (equipar ou manter):** cada opção mostra a linha
   `Contra o atual: +2 CAM, -1 PV` (novo menos equipado) ou `Contra o novo: …`
   (equipado menos novo). O equipado usa os atributos **já escalados pelo nível**.
2. **Loja:** o item à venda traz `Substitui <item> Nv N` e `Troca: …` quando o slot
   está ocupado, ou `Slot livre (<slot>).` quando não está.
3. **Ferreiro:** a prévia mostra `Nv atual`, `Nv seguinte` e `Ganho: …` (BUG-015).
4. **Passar o mouse** sobre a opção mostra o item comparado (`tooltip`).
5. Sem mudança de números, regras ou economia.

## Implementação

- `Items.diff_mods`, `Items.compare_text`, `Items.scaled_mods`, `Items.upgrade_preview`
  (`core/items.gd`).
- `Battle.give_item` e `Battle._open_shop_event` (`core/battle.gd`) preenchem `desc`
  e `tooltip`; `ui/hud.gd` aplica `tooltip_text`.
- Teste: `tests/test_battle.gd` (diferença contra o equipado, tooltip, mods iguais).

## Aceite

- Um jogador novo diz, na tela de oferta, o que ganha e o que perde ao trocar.
- Nenhuma mudança em `hero.recalc()` ou nos valores de itens.

## Limites

- Comparação só por atributos de item; não compara armas concedidas por item.
- Valores inteiros de CA/CAM somam frações entre itens e são truncados no total
  (comportamento antigo, mantido).
