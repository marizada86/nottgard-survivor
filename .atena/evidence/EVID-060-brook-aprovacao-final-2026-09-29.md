# EVID-060 — Aprovação final de Brook

Data: 2026-09-29.

## Aprovação humana

Após revisar a prancha
`asset-review-boards/SPEC-076-brook-final-review.png`, o dono respondeu
**“aprovado”**. A decisão conclui o gate artístico final da SPEC-076.

## Reconciliação aplicada

- `ASSET-APPROVAL-REGISTER-017-brook-regenerado-2026-09-29.md` torna oficiais
  os nove strips regenerados de Brook.
- `ASSET-OFFICIAL-LOCK-012.json` deriva do lock cumulativo 011, preserva suas
  126 entradas e substitui somente os nove hashes de `brook.*` pelos bytes
  atuais do runtime.
- O registro de prompts foi promovido a `official` e a SPEC-076 foi encerrada.
- A aprovação e o lock anteriores de Durvall permanecem intactos; a revisão
  anterior de Brook foi preservada como evidência histórica.

## Verificação

- A auditoria de animações foi regenerada depois da integração e contém os
  hashes atuais dos nove caminhos de Brook.
- `verify_official_asset_lock.ps1` conferiu as **126 entradas** de
  `ASSET-OFFICIAL-LOCK-012.json` contra os bytes atuais, sem divergências.
- Na integração dos assets, `godot --headless --path . -s tests/run_all.gd`
  retornou **0 falhas**. Uma repetição posterior encontrou erros de compilação
  já presentes em `core/game.gd` e `core/playtest.gd`, fora do escopo de Brook;
  o executor ainda reportou zero falhas. Essa exceção não altera os bytes ou o
  contrato das animações e deve ser tratada no trabalho responsável por esses
  arquivos.
- A revisão humana confirmou a identidade halfling, cabelo/barba brancos,
  armadura escura, maça de espinhos e as ações de movimentação, ataque,
  guarda e morte.
