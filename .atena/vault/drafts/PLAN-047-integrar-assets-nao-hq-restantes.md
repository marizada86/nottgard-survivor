# PLAN-047 - Integrar assets nao-HQ restantes

Status: implemented and verified locally; push pending (2026-09-30).
Spec: `[[SPEC-100-integracao-estruturas-e-decais-docas]]`.

## Flight plan

1. Preserve candidate files and build official 256x256 structure PNGs and
   256x128 Docas decal PNGs from the normalized outputs.
2. Configure one structure per stage with safe-ground placement, no collision,
   and y-sort; keep Docas decals out of the renderer.
3. Cover file integrity and runtime placement with tests; reconcile evidence.
4. Run the full Godot suite and review the exact staged file set.
5. Commit and push `codex/cultista-adaga-animation` only after checks pass.

## Guardrails

- Exclude every HQ/comic candidate and preserve unrelated working-tree edits.
- Do not alter terrain, blocker behavior, canonical lore, or raw art candidates.
- Stop if the placement search cannot prove dry ground and adequate clearance.

## Evidence

Pending: `[[EVID-127-integracao-assets-nao-hq-2026-09-30]]`.
