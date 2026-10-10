# EVID-234 — BUG-041: borda do item selecionado cortada na ficha C (2026-10-10)

**Origem:** dono, print da aba Armas da ficha C: "borda do item selecionado está cortando".
**Desvio:** DEV-032 (PLAN_DEVIATION do PLAN-071); pedido de correção explícito, rota "fazer agora e voltar".

## Causa
`SheetSlot` desenha o anel de foco em `rect.grow(2)` com linha de 3 px, ou seja, ~3,5 px para fora do slot. A grade ficava direto dentro do `ScrollContainer` da ficha, que recorta o que passa do seu retângulo: o primeiro slot de cada linha perdia o lado esquerdo do anel (e o último da grade, o de baixo).

## Correção
- `ui/character_sheet.gd`: a grade (`_content`) fica num `MarginContainer` com folga `SLOT_FOCUS_ROOM = 6` dentro do `ScrollContainer`. A ficha encolhe 12 px de largura útil por aba; nenhum slot mudou de linha nas capturas.
- `ui/sheet_slot.gd`: `FOCUS_RING_GROW` e `FOCUS_RING_WIDTH` viraram constantes (o teste usa as mesmas).
- `tests/test_character_sheet.gd`: a grade tem pai de margem dentro do scroll e margens ≥ folga do anel (dez heróis).
- `tools/capture_character_sheet.gd`: opção `--dir=` para não sobrescrever as capturas da SPEC-130.

## Verificação
- Capturas 1280×720 antes/depois: `.atena/generated/dev-032/antes/` e `.atena/generated/dev-032/depois/` (aba Armas, herói cheio: anel completo nos quatro lados).
- Suite 0 falhas; smoke ok; `mobile_buttons_check` 146/0; `controller_check` 90/0; mutação (`SLOT_FOCUS_ROOM = 0`) → falha; valor restaurado.

## Pendências
- Aguarda playtest do dono (mouse, controle e toque; rolar com foco no último slot).
- Só conferi a aba Armas em captura; as outras abas usam a mesma grade e o mesmo contêiner.
