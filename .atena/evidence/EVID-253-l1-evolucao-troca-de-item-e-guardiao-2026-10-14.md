---
id: "EVID-253"
title: "L1: evolução alcançável e visível, troca de item com ordem fixa e Guardião Alado maior"
created: "2026-10-14"
relations: ["[[EVID-250-relato-t05-mariz-v040-2026-10-14]]", "[[EVID-252-avaliacao-medida-do-relatorio-t05-mariz-2026-10-14]]", "[[AVALIACAO-playtest-t05-mariz-v040-2026-10-14]]"]
cards: ["MEC-070", "IN-084", "IN-092", "IN-095"]
content_state: DRAFT
---

# EVID-253 — Lote L1 (aprovado pelo dono em 2026-10-14, por plano, sem commit)

Origem: relatório do T05 (Mariz) e avaliação em [EVID-252](EVID-252-avaliacao-medida-do-relatorio-t05-mariz-2026-10-14.md). Aprovação do dono: "evolução com a passiva exigida fora do teto de 5 (opção A) mais aviso na HUD (C), ordem fixa e veredito na troca de item, e Guardião Alado maior com abertura".

## O que mudou
| Item | Mudança | Arquivos |
|---|---|---|
| IN-095 A | A passiva que falta para evoluir uma arma **no nível máximo** entra na oferta mesmo com os 5 espaços de passiva cheios (peso 9, papel "synergy"; a descrição diz "não ocupa espaço de passiva"). Com a arma fora do nível máximo o teto de 5 segue valendo | `core/battle.gd` (`_build_offer`, `evolution_passives_needed`) |
| IN-095 C | A lista de armas da HUD diz o que falta só no nível máximo: "Espada Sombria Nv 5 · falta Cota de Malha" (ou "falta Força 14", ou "pronta para evoluir"). Ao subir a arma ao nível máximo sem a passiva, um aviso explica | `core/battle.gd` (`evolve_status`, ramo `weapon_up`), `ui/hud.gd` |
| IN-084 | Troca de item em ordem **fixa**: "Manter [atual]" é a opção 1 e "Equipar [novo]" a 2, sempre. O foco inicial vai para a melhor pelo veredito (`offer_focus`); empate, o atual. Os selos ▲/▼ já existiam | `core/battle.gd` (`give_item`, `offer_focus`), `ui/hud.gd` |
| IN-092 | Guardião Alado (verdadeiro): escala 1,3 → 1,9 e raio 0,45 → 0,55 (era o menor dos 11 chefes; agora fica entre Sacerdote 1,6 e Molydeus 1,9) | `data/enemies.json` |

## Consequências a conhecer
- As teclas 1 e 2 e o índice do `choose()` na troca de item **mudaram de sentido** (1 = manter, 2 = equipar). Testes e ferramentas que assumiam "novo = 0" foram ajustados: `tests/test_battle.gd` (4 trechos), `tools/bot.gd` e `tools/bot_curva.gd` (empate equipa o novo, como antes), `tools/bal_bencaos.gd`, `tools/perf_probe.gd`, `tools/mobile_buttons_check.gd`.
- A abertura do Guardião Alado **segue só com texto** (título e subtítulo; `image` vazio em `data/boss_presentations.json`). A imagem é arte nova e não foi gerada; ficou como pedido de arte (cartão ART-049 a abrir) e os outros 7 chefes continuam sem apresentação.
- `core/battle.gd` e `ui/hud.gd` já tinham mudanças não commitadas de outras sessões (M2); as deste lote são aditivas.

## Verificação
- Teste novo `tests/test_l1_evolution_and_item_order.gd`: passiva da evolução entra com os 5 espaços cheios; não fura o teto com a arma abaixo do nível máximo; texto da HUD; aviso ao chegar ao nível máximo; ordem fixa e foco no melhor e no pior; escala do Guardião não é a menor.
- **Mutação:** sem o ramo da evolução, com a ordem invertida e com a escala 1,3, o teste falha em 4 pontos; restaurado, passa.
- Suíte completa: **0 falhas**.
- Capturas em janela real (`tools/capture_l1.tscn`): `.atena/generated/mariz-playtest/l1_hud_arma_nivel_maximo.png` (a HUD mostra "Espada Sombria Nv 5 · falta Cota de Malha") e `l1_troca_item_melhor.png` (Manter ▼3 primeiro, Equipar ▲3 depois, foco dourado no melhor).

## Não verificado
- Quanto isso muda a taxa de evolução. Rodar `tools/probe_evolution_odds.gd` depois: ele ainda **não** conhece a passiva fora do teto; a sonda escolhe só entre as ofertas, então os números dela devem subir (alvo da avaliação: 60% ou mais até o nível 20 na política aleatória).
- Humano: ler a lista de armas da HUD em jogo, achar a nova ordem natural, ver o Guardião maior no mapa.
