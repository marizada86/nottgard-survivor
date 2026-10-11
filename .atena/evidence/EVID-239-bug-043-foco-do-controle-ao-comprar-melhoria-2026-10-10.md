# EVID-239 — BUG-043: o foco do controle sumia ao comprar uma melhoria (2026-10-10)

**Origem:** relato do Hiago (T02), repassado pelo dono: "ao comprar um upgrade em melhorias, jogando no controle o input desaparece e não consegue comprar mais nada até apertar R1/RB ou L1/LB".
**Desvio:** DEV-037 (PLAN_DEVIATION do PLAN-071); rota "fazer agora e voltar"; por plano (PLAN-097, SPEC-170).

## Causa
`Menu._fill_upgrades()` é chamado por `_refresh_all()` a cada compra e destruía todas as linhas, inclusive o botão focado, sem devolver o foco a nenhum botão novo. Sem foco, direcional e A não fazem nada; LB/RB trocam de aba e `tab_changed` chama `_focus_tab()`, que reatribui o foco, o que bate com o relato. Mouse e toque não dependem de foco.

## Mudança
- `ui/menu.gd`: `_fill_upgrades()` guarda o id da melhoria focada (`meta upgrade_id` do botão) e a rolagem, tira as linhas velhas da árvore na hora e chama `_restore_upgrade_focus()` (deferido): mesma melhoria; se ficou desabilitada, o próximo botão habilitado, depois o anterior, depois `_focus_tab()`.
- `tools/controller_check.gd`: quatro verificações novas (`melhorias_foco_inicial`, `melhorias_compra_no_controle`, `melhorias_foco_apos_compra`, `melhorias_segunda_compra`); o perfil de teste volta ao estado anterior depois.
- `tests/test_quartel.gd`: id focado reconhecido, melhoria no máximo, sem linhas velhas, foco vai ao botão vizinho.

## Verificação
| Verificação | Resultado |
|---|---|
| `controller_check --headless` antes da correção (restauração desligada) | **reproduziu o bug:** `melhorias_foco_apos_compra` e `melhorias_segunda_compra` FALHAM; 94 verificações, 2 falhas |
| `controller_check --headless` com a correção | **94/0** |
| Suíte completa | 0 falhas; mutação em `_restore_upgrade_focus` (sem `grab_focus`): `test_quartel` falha |
| `mobile_buttons_check` | 146/0 |
| Smoke das 9 fases | ok |
| `kit_test` (com janela) | OK |

## Pendências e limites
1. Subjetivo (o foco cair onde o jogador espera, sem pular a rolagem) aguarda playtest num controle real; a verificação usa eventos sintéticos de joystick.
2. `tools/controller_check.gd` regravou `.atena/generated/controller-experience/v02/integration-report.json` (agora com 94 verificações, 0 falhas).
3. O rank de contribuições (`CONTRIBUICOES-PLAYTESTERS.md`) **não** foi alterado: o item entra como `IN-073` (Hiago), e a pontuação fica com o dono.
4. Sem commit, push, exportação nem aviso aos testers.
