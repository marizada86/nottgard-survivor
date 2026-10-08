---
id: "EVID-203"
title: "PLAN-081 B-002 S-006: roteiro de reteste em run real"
created: "2026-10-08"
plan: "PLAN-081"
spec: "SPEC-148"
status: "roteiro pronto; reteste dispensado pelo dono em 2026-10-08; as linhas viram O que testar na 0.4.0"
---

# EVID-203 — Roteiro de reteste em run real (S-006)

Suíte, smoke e `kit_test` já passam no `HEAD` `5953d44` (EVID-202). Falta o olho humano em uma run. Uma partida de Dagruve (5 min) com qualquer herói cobre quase tudo. Marque cada linha: **OK**, **FALHOU** (vira BUG-038 em diante) ou **não visto** (vai para "O que testar" da 0.4.0).

| # | Cartão | O que fazer | Esperado | Resultado |
|---|---|---|---|---|
| 1 | BUG-033 | No Quartel, com controle (se tiver): escolher herói e fase e apertar Jogar | O foco chega ao Jogar e a run começa | |
| 2 | BUG-003 | Na run, abrir a ficha com `C`, rolar, fechar com `C` e com `Esc` | Abre, rola, fecha pelas duas teclas (BUG-034 corrigiu o `C`) | |
| 3 | BUG-004 | Pegar um item com o slot ocupado e escolher vender | Moeda creditada e item some | |
| 4 | BUG-005 | Quebrar objetos do cenário | Soltam loot; poção só de elite | |
| 5 | BUG-006 | Abrir loja, ferreiro e curandeiro e sair sem comprar | Preços visíveis; "Sair" sem custo | |
| 6 | BUG-007 | Segurar o botão esquerdo para andar; clicar em painel | Anda ao segurar; clicar em painel não move | |
| 7 | BUG-008 | Melhorar um equipamento no ferreiro (e uma duplicata) | Prévia do nível seguinte mostra mods escalados | |
| 8 | BUG-009 | Usar o botão de menu do HUD (só em build QA) | Encerra o sandbox QA | |
| 9 | BUG-010 | Juntar arma + acessório + magia de uma sinergia | Bônus da sinergia aparece e vale | |

Notas:
- Se a máquina não tiver controle, a linha 1 vira "não visto".
- Bugs que o dono já viu corrigidos no jogo podem ser marcados direto, sem refazer.
- Nada aqui altera código; qualquer FALHOU abre cartão novo e não bloqueia o resto do plano sem decisão do dono.
