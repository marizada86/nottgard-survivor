# Integração dos pacotes de arte do ChatGPT (PLAN-110 / SPEC-185)

Relatórios de preparação, backups dos arquivos substituídos e capturas de cada lote (B-001 a B-003). Evidências: EVID-268 a EVID-272.

As fontes brutas (`b001/fontes`, `b002/breakables`, `b002/idles`, `b003/juiblex`, `b003/mimico`, `b003/totem`, cerca de 125 MB) foram copiadas do pacote do Codex com SHA-256 conferido, mas **não entram no git**. Estão preservadas na branch `codex/art-production-lot12-14-2026-10-17` (commit `89a83520`, `.atena/generated/art-candidates/animation-candidates/asset-lotNN/` e `.../botao-acao`, `asset-lot02`, `fila030-preparation-2026-10-15/v01`), com os hashes nos manifestos de cada lote. Para refazer uma preparação, copie as fontes de volta para as mesmas pastas e rode a ferramenta correspondente: `tools/prepare_ui_art.gd`, `prepare_breakable_deaths.gd`, `prepare_idle_strips.gd`, `prepare_actor_strips.gd`.

## M1, lote 2 (Zynara e Leoric, LOT15)

`m1-lote2/fontes` (24 PNGs de 1254 px do LOT15, hashes no recibo `visual-acceptance.json` do pacote) e `m1-lote2/grades` (grades 3×2 montadas por `tools/m1_compose_grid.gd`) também ficam fora do git; as fontes estão na mesma branch do Codex (`.atena/generated/art-candidates/asset-lot15/`). Para refazer: grade com `m1_compose_grid.gd` e `m1_normalize_strip.gd --grid=3x2` com altura do idle do herói e base = pés + 64, célula 512×512 (ver EVID-275).
