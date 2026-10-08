---
id: "EVID-204"
title: "PLAN-081 B-003: arte provisória (ícones de bênção por divindade)"
created: "2026-10-08"
plan: "PLAN-081"
spec: "SPEC-148"
cards: ["ART-038", "ART-039", "ART-040", "MEC-047"]
status: "S-008 feito localmente; S-009 adiado para B-004 e B-006; sem commit"
---

# EVID-204 — Arte provisória (B-003)

## O que existe de arte (lido em 2026-10-08)

- **Lettering e cursor (ART-039, ART-040):** só o esqueleto de código (`ui/lettering.gd`, `ui/cursor_skin.gd`, `data/lettering.json`, `data/cursor.json`). Não há PNG em `assets/ui/lettering/` nem em `assets/ui/cursor/`; o jogo continua com o visual e o cursor do sistema. Nada a integrar sem arte gerada e aprovada pelo dono.
- **Ícones de bênção (ART-038):** 14 PNGs em `assets/icons/boons/` para 30 bênçãos. Faltam 16, entre elas as novas `lliira_juramento` e `tou_um_caminho`.

## S-008 — fallback de ícone por divindade

`BoonKinds.icon_path(bn)` e `BoonKinds.icon_path_for_id(id)` (`core/boon_kinds.gd`): usam o ícone próprio; sem ele, o ícone de outra bênção da mesma divindade; sem nenhum, devolvem o caminho próprio (inexistente) e a UI continua caindo na letra, como antes. Ligado nos três pontos que montavam o caminho na mão: `ui/character_sheet.gd` (`_boon_entry`), `ui/hero_panel.gd` (`_boon_icon`) e `ui/hud.gd` (oferta de bênção).

| Divindade | Ícone provisório |
|---|---|
| Ghaunadaur, Helion, Lliira, Mask, Selûne, Sendrinah, Shar, Tou Um | ícone de outra bênção da mesma divindade |
| Juiblex, Lu Yueh, Zuggtmoy | letra inicial (nenhuma tem ícone) |

Um ícone repetido por divindade é provisório e vai para a caixa "Isto é provisório" do changelog. Quando a arte da ART-038 for aprovada, o PNG próprio passa a valer sozinho (o fallback só age na falta).

## Testes

- `tests/test_boon_icons.gd` (novo): ícone próprio é preservado; sem ele, as divindades com ícone devolvem um caminho existente e diferente do próprio; sem ícone na divindade, mantém o próprio; `lliira_juramento` e `tou_um_caminho` têm ícone provisório; id desconhecido devolve o próprio.
- **Mutação:** com o laço de fallback desligado, o teste dá **22 falhas**; com o código, **0**.
- `test_character_sheet` e `test_hero_panel` isolados: 0 falhas. Suíte completa na árvore de trabalho: `testes: 0 falha(s)`.

## S-009 — ícones provisórios do Eco e do NPC de magia

**Adiado para B-004 e B-006.** Nenhuma das duas entidades existe ainda; o ícone depende das specs (SPEC-149 e SPEC-152). Elas já nascem com a regra do plano: reutilizar arte existente ou vetor local, sem gerar imagem. A SPEC-148 não muda; só a ordem do passo.

## Pendente

Commit (aprovação explícita): `core/boon_kinds.gd`, `ui/character_sheet.gd`, `ui/hero_panel.gd`, `ui/hud.gd`, `tests/test_boon_icons.gd` e este EVID, num commit de arte; documentos de estado em outro.
