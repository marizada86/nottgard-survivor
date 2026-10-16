# EVID-267 — Admissão do logotipo LN01 v02 (PLAN-109 / SPEC-184 / ART-049)

Data: 2026-10-16 · Estado: DRAFT (preparação visual v02 aceita pelo dono; sem promoção a CANON) · Desvio: DEV-044 (PLAN-103 suspenso e retomado).

## O que entrou

- Origem: `claude-logo-handoff-v01.zip` (worktree Codex `31a7`), extraído em pasta nova; arte `LN01_runtime_candidate_v02.png`, 699×176 RGBA, SHA-256 `7aeec54d…f7523a7f09`, igual ao `visual-acceptance.json`.
- Destino `assets/ui/title/logo.png`: hash anterior `5d5214fb…4eecb5` conferido contra `runtime_before_sha256`; backup em `.atena/generated/logo-ln01-2026-10-16/backup/`. Raster não alterado.
- Código do jogo: nenhuma mudança. `ui/title.gd` não tem sequência `logo_NN.png` e usa a peça com KEEP_ASPECT_CENTERED na faixa y24..200; 699 px por proporção (`data/lettering.json` trata 1100×176 como máximo).
- Ferramenta nova: `tools/capture_title.gd/.tscn`.

## Verificação

- Importação headless sem erro; `tests/run_all.gd`: **0 falhas**.
- Captura do título real a 1280×720 (`capturas/titulo_1280x720.png`): logo NOTTGARD / ABYSS MEGADUNGEON visível, sem deformação, sem "SURVIVORS"; "Clique para jogar" intacto.

## Não verificado

Legibilidade em celular e a avaliação final de olho (pontas, contraste, subtítulo de ~18 px) são do dono. Sem commit, push, build nem exportação. Os pacotes `.exe`/zip e o `game_id` seguem com o nome antigo (decisão da SPEC-181).
