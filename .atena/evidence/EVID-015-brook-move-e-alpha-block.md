# EVID-015 - Brook move_e alpha block

Date: 2026-09-24
Prompt: `HERO-brook-move_e`

## Result

- v01 failed: pointed elf ears, opaque gradient background, and inconsistent
  foot baseline.
- v02 fixed Brook's ears and retained the required rightward six-frame motion,
  but still returned an opaque dark gradient.
- Deterministic removal was inspected at thresholds 6, 8, and 10. Threshold 6
  keeps the armor but leaves enough residual background to prevent a clean
  reframe. Thresholds 8 and 10 remove dark armor details.

The record remains `qa_failed`; no file was written to `assets/`. One final
generation candidate remains and must use a materially different alpha
strategy.

## Final candidate

The approved v03 used a flat `#00FF00` chroma-key strategy, but the generator
ignored that backdrop and returned the same opaque gradient. It also restored
pointed elf ears despite the explicit dwarf rule. The three-candidate limit is
now exhausted. No file was integrated.

## Ear correction exception

PLAN-006 was approved as a non-destructive identity-only exception. The derived
`move_e_v02_earfix_v01.png` gives Brook short, rounded dwarf ears in all six
frames while preserving the rest of the walk sheet. Its threshold-6 alpha
derivative retains a colored outline halo; threshold 7 damages dark armor.
The identity correction passed, but the asset remains blocked on alpha quality.

The user visually approved the ear-correction source on 2026-09-24. This
approval covers Brook's dwarf-ear identity and preserved design only; alpha and
integration remain separate technical gates.
