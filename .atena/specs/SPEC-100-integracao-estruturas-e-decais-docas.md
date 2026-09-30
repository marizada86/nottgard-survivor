# SPEC-100 - Integracao das estruturas e dos decais de Docas

Status: complete; verified and pushed (2026-09-30).

## Scope

- Admit the nine normalized biome structures into `assets/props/` and show one
  as a non-blocking, y-sorted scenery accent in each corresponding stage.
- Place each structure on dry, unblocked ground, clear of the hero start and
  existing blockers. Keep structures outside the gameplay blocker list.
- Admit the two normalized Docas ground decals into `assets/decals/` and point
  their manifest entries at the official files. Keep their renderer disabled
  for Docas until a dry dock anchor is supported by the terrain layout.
- Preserve the normalized and raw candidates under `.atena/generated/`.
- Add coverage for alpha, file admission, placement safety, and the disabled
  Docas preview. Reconcile ART-PROMPTS-026 and SPEC-082.

## Non-goals

- HQ/comic assets, new lore, terrain-layout changes, collision changes,
  balancing, and any generated candidate rework.
- Changing the existing sixteen admitted decals or the established cultista
  animation integration.

## Acceptance criteria

1. Nine structures and two Docas decals are present in official asset paths
   with transparency preserved; source candidates are unchanged.
2. Every stage has exactly one structure at dry ground, away from the start and
   existing blockers; it is y-sorted and does not add a blocker.
3. Docas decal files are official and loadable, but `placements("docas", seed)`
   remains empty.
4. The full Godot test suite passes and the changed scope is independently
   reviewed before a feature-branch push.

## Plan of flight

1. Resize normalized candidates deterministically into official asset paths.
2. Add stage structure metadata and safe, non-blocking runtime placement.
3. Redirect Docas decal manifest entries without enabling their renderer.
4. Add/update tests, run the suite, and inspect the resulting asset boundaries.
5. Record evidence, reconcile affected ADD records, commit scoped files, and
   push the approved feature branch.

## Impacts and risks

- Runtime changes are visual-only; terrain and collision data remain unchanged.
- The structure position search must fail closed if no safe tile is found.
- Docas decals remain unused pending a future dry-anchor change.

## Evidence

- See `EVID-127-integracao-assets-nao-hq-2026-09-30.md` for verification and
  the pushed branch revision.

## Reconciliation

All four acceptance criteria passed. The nine structures render as non-blocking
y-sorted props with tested safe placement; the two Docas decals are officially
admitted while their preview remains disabled. HQ/comic assets were excluded.
See EVID-127 for checks and push details.
