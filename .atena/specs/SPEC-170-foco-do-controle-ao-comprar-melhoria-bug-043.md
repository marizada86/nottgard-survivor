---
id: "SPEC-170"
title: "Foco do controle ao comprar melhoria no Quartel (BUG-043)"
status: "IMPLEMENTADA LOCAL em 2026-10-10 (PLAN-097, EVID-239); aguarda playtest"
origin: planned
implementation_preceded_spec: false
request_classification: PLAN_DEVIATION
created: "2026-10-10"
relations: ["[[SPEC-166-nova-ui-lote-2-quartel-selecao-e-titulo-mec-003]]"]
cards: ["BUG-043", "IN-073"]
---

# SPEC-170 — Foco do controle ao comprar melhoria

Origem: relato do Hiago (T02) repassado pelo dono em 2026-10-10: "ao comprar um upgrade em melhorias, jogando no controle o input desaparece e não consegue comprar mais nada até apertar R1/RB ou L1/LB".

## Hoje (lido em 2026-10-10)
- `Menu._fill_upgrades()` (`ui/menu.gd`) é chamado por `_refresh_all()` a cada compra e dá `queue_free()` em **todas** as linhas, inclusive o botão que tinha o foco; os botões novos nascem sem foco.
- Sem foco, direcional e A não fazem nada. Trocar de aba com LB/RB chama `_focus_tab()` (`tab_changed`), que reatribui o foco: é a única saída, como o relato descreve.
- Mouse e toque não dependem de foco e não eram afetados. A aba Marcas (`AbyssPanel`) não destrói nós e não tem o problema.

## Comportamento novo
1. Antes de refazer as linhas, o menu guarda o `id` da melhoria cujo botão tem o foco (`meta upgrade_id` do botão).
2. As linhas velhas saem da árvore na hora (`remove_child` + `queue_free`), sem duplicar linhas no mesmo quadro.
3. Depois (deferido, com o layout pronto), o foco volta ao botão da **mesma** melhoria; a rolagem da lista é preservada.
4. Se esse botão ficou desabilitado (nível máximo ou moedas insuficientes), o foco vai ao **próximo** botão habilitado da lista, depois ao anterior e, por fim, ao primeiro foco da aba (`_focus_tab`).
5. Nada muda quando o foco estava fora da lista de melhorias, na estrutura das linhas (rótulo + botão) nem nas regras de compra.

## Fora do escopo
Dados, balanceamento, arte, as demais abas e a ordem de foco entre os botões (vizinhos automáticos do Godot).

## Aceite
1. No controle, comprar uma melhoria mantém o foco num botão de melhoria habilitado, e uma segunda compra com A funciona sem trocar de aba (`controller_check`).
2. Quando a melhoria focada chega ao máximo, o foco vai a outro botão habilitado, e a lista não guarda linhas velhas (`tests/test_quartel.gd`).
3. Mutação: sem a restauração, as verificações `melhorias_foco_apos_compra` e `melhorias_segunda_compra` falham.
4. Suíte, smoke, `kit_test`, `mobile_buttons_check` e `controller_check` sem falhas.
5. Subjetivo (o foco cair onde o jogador espera depois de comprar) pendente de playtest no controle.
