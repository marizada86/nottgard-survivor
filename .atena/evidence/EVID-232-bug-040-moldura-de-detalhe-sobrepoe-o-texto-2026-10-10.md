# EVID-232 — BUG-040: texto sobre a moldura de detalhe e moldura deformada (2026-10-10)

**Origem:** dono, print da aba Diário do Quartel ("Uma Noite Sem Fim / 4 quadros"): texto sobre a faixa dourada e moldura achatada.
**Desvio:** DEV-029 (PLAN_DEVIATION do PLAN-071; rota "fazer agora e voltar"). Classificação: Direct Execution dentro do desvio aprovado ("atena, 1.").

## Causa
`assets/ui/ficha/ficha_moldura_detalhe.png` (512×128) tem 10 px transparentes em volta, faixa da borda de 10 a 21 px (22 px visíveis) e estrelas nos cantos até x≈29 / y≈33. O `UiKit.style_text` usava recorte 16 px e margem de texto 18 px:
- o recorte de 16 px corta a faixa e as estrelas; a parte que cai na zona central é esticada na vertical (moldura "comprimida");
- a margem de 18 px fica 4 px dentro da faixa (texto sobre a moldura).

## Correção
- `SheetArt.detail(padding, tint)`: recorte `DETAIL_SLICE = 34` (cobre as estrelas) e margem `DETAIL_PADDING = 26` (4 px além da borda visível).
- `UiKit.style_text` e `UiKit.detail_frame` passam a usá-lo. A ficha C (`character_sheet.gd`, três usos com recorte 16) **não** foi tocada.
- `tests/test_ui_kit.gd`: recorte ≥ 34 e margem ≥ 22 para `normal`, `focus` e `detail_frame`.

## Verificação
- Capturas 1280×720 antes/depois: `.atena/generated/dev-029/antes/` e `.atena/generated/dev-029/capturas/` (Jogar, Diário, Códex etc.).
- Suite: `testes: 0 falha(s)`; `kit: OK`; `smoke: ok`.
- Mutações: recorte 16 → 3 falhas; margem 18 → 2 falhas (mais o total); valores restaurados.
- Save real: `user://profile.json` com o mesmo carimbo antes e depois.

## Pendências / honestidade
- Aguarda playtest do dono (aparência é subjetiva); nenhuma métrica prova que ficou bonito.
- Margem maior reduz a área útil do texto: o `StageInfo` da aba Jogar mostra uma linha a menos (rola como antes).
- A ficha C segue com recorte 16 (estrelas esticadas nos três usos); decisão do dono se entra no mesmo ajuste.
- Em `HqInfo` o `[b]` do título não aparece em negrito (fonte sem variante); fora do escopo.
