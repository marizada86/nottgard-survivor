# ASSET-APPROVAL-REGISTER-002 — Durvall e Brook

Status: **canônico — aprovado pelo dono** (2026-09-27).

## Decisão

O dono aprovou explicitamente: **“aprovar Durvall e Brook”**. A decisão torna
oficiais as nove sequências-fonte finais de cada herói, fixadas pelos hashes do
lock derivado. Não houve substituição de PNGs nem alteração de runtime.

## Assets oficiais deste lote

| Herói | Sequências aprovadas |
| --- | --- |
| Durvall | `idle`, `move_n`, `move_ne`, `move_e`, `move_se`, `move_s`, `attack`, `active`, `death` |
| Brook | `idle`, `move_n`, `move_ne`, `move_e`, `move_se`, `move_s`, `attack`, `active`, `death` |

Os caminhos de cada sequência seguem o contrato
`assets/animations/heroes/<hero_id>/<sequence>.png` e seus hashes, dimensões e
alfa estão fechados em `ASSET-OFFICIAL-LOCK-002.json`.

## Limites

- A aprovação cobre somente os 18 PNGs finais deste lote, não seus espelhos de
  runtime, placements, cenas, gameplay ou demais heróis.
- Os 15 assets do lote crítico anterior permanecem aprovados pelo
  `ASSET-APPROVAL-REGISTER-001` e são repetidos no lock cumulativo.
- Os demais registros de produção e sequências-fonte continuam sem status
  oficial até decisão humana própria.

## Evidência

- Pranchas revisadas: `SPEC-044-durvall-final-review.png` e
  `SPEC-044-brook-final-review.png`.
- Auditoria: `HERO-ANIMATION-AUDIT-001.json`.
- Decisão e verificação: `EVID-056` e `EVID-057`.
