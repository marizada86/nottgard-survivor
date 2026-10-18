# Integração dos pacotes de arte do ChatGPT (PLAN-110 / SPEC-185)

Relatórios de preparação, backups dos arquivos substituídos e capturas de cada lote (B-001 a B-003). Evidências: EVID-268 a EVID-272.

As fontes brutas (`b001/fontes`, `b002/breakables`, `b002/idles`, `b003/juiblex`, `b003/mimico`, `b003/totem`, cerca de 125 MB) foram copiadas do pacote do Codex com SHA-256 conferido, mas **não entram no git**. Estão preservadas na branch `codex/art-production-lot12-14-2026-10-17` (commit `89a83520`, `.atena/generated/art-candidates/animation-candidates/asset-lotNN/` e `.../botao-acao`, `asset-lot02`, `fila030-preparation-2026-10-15/v01`), com os hashes nos manifestos de cada lote. Para refazer uma preparação, copie as fontes de volta para as mesmas pastas e rode a ferramenta correspondente: `tools/prepare_ui_art.gd`, `prepare_breakable_deaths.gd`, `prepare_idle_strips.gd`, `prepare_actor_strips.gd`.
