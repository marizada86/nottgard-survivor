---
id: "SPEC-179"
title: "UI, onboarding e clareza: marco M3 da demo (PLAN-103)"
status: "DRAFT r2 em 2026-10-15: R1 e R2 (dicas de primeira vez + Q/RMB) feitas; R3 a propor"
origin: planned
implementation_preceded_spec: false
request_classification: IN_PLAN
created: "2026-10-15"
revision: "r1 (2026-10-15)"
relations: ["[[PLAN-103-demo-completa-e-polida-2026-10-14]]", "[[SPEC-165-sistema-de-ui-e-menu-de-pausa-mec-003]]", "[[SPEC-177-game-feel-e-apresentacao-marco-m2-do-plan-103]]", "[[EVID-262-m3-r1-inventario-dos-primeiros-minutos-2026-10-15]]"]
cards: ["MEC-003"]
content_state: DRAFT
---

# SPEC-179 — UI, onboarding e clareza (M3)

Origem: PLAN-103, lote B-004. Proposta em `vault/drafts/PROPOSTA-m3-ui-onboarding-e-clareza-2026-10-15.md`. Aprovado pelo dono em 2026-10-15: R1 e R2. Aceite do marco: um jogador novo explica sozinho level-up, bênção, extrair/descer e questlog (verificação humana, R5).

## Rodadas
| Rodada | Conteúdo | Estado |
|---|---|---|
| R1 | Inventário dos primeiros minutos | **feita** (EVID-262) |
| R2 | Dicas de primeira vez (7), opção Ligadas/Desligadas, teto 1 a cada 90 s e 7 no total, sem chefe nem vida < 30% | **feita** (EVID-263; aprovada em G-M3-2, com o Q/RMB) |
| R3 | Ofertas e HUD da run no padrão UiKit (R3a ofertas, R3b decisão do portal, R3c reviver, R3d HUD) | proposta pronta, aguarda G-M3-3 (`vault/drafts/PROPOSTA-m3-r3-ofertas-e-hud-da-run-2026-10-15.md`) |
| R4 | Promoção da direção visual DRAFT → CANON | com o dono |
| R5 | Teste com jogador novo | com o dono |

## R2 — desenho (para aprovação)
- **Dados:** `data/onboarding_hints.json` com `id`, `trigger`, `text` (até 90 caracteres) e ordem; o texto usa `{interact}` e `{pause}` para a tecla do controle em uso (`Game.controls.prompt`).
- **Estado:** `profile.data.settings.hints_seen` (conjunto de ids) e `settings.hints` (`on` ou `off`, padrão `on`); migração para perfis antigos; "Rever dicas" limpa o conjunto.
- **Exibição:** pela camada de avisos já legível (`Hud.toast`, M2 F-11), com o teto e as guardas de luta e vida baixa; nada novo na tela.
- **Gatilhos:** eventos que a `Battle` já emite (chefe vencido e portal aberto, `interaction` do ritual, `streak`, `item_offer`, primeiro interativo, primeira missão no Questlog, altar aberto).
- **Testes:** teto por intervalo e total, guarda de chefe e vida, persistência entre runs, migração, opção desligada, texto até 90 caracteres e marcadores resolvidos.
- **Fora do escopo:** tutorial interativo, tela nova, imagem nova, mudar regra de jogo.

## Lacunas
| Tipo | Item | Padrão recomendado |
|---|---|---|
| BLOCKING | Aprovação dos 7 textos e gatilhos da R2 | Usar os da tabela do R1 (todos conferidos no código) |
| RESOLVABLE | Quais dicas entram (D1 a D7) | Todas, na ordem do R1; D1 é a mais importante |
| DEFERRED | Tutorial guiado na primeira run | Pós-demo, se o teste do R5 mostrar necessidade |

## R2 (gate G-M3-2, 2026-10-15): implementada
As 7 dicas aprovadas e o rótulo Q/RMB legível em piso claro. Desvio documentado: a dica D1 usa a tecla real de extrair (X) em vez de Esc, para coincidir com o aviso do portal (EVID-263). Proposta pendente: o rodapé "[Esc] Pausa → Extrair" passar a "[X] Extrair". Próxima: R3 (ofertas e HUD da run no padrão UiKit), que pede proposta de layout antes de código.
