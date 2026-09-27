# ASSET-APPROVAL-REGISTER-001 — Lote crítico de Nyrelia e props abissais

Status: **canônico — aprovado pelo dono** (2026-09-27).

## Decisão

O dono determinou: **“aprovar como oficiais”** os 15 arquivos que compõem o
lote crítico apresentado pela SPEC-044. A decisão recai sobre os bytes finais
e hashes registrados no lock derivado; ela não substitui PNGs nem altera o
runtime.

## Assets oficiais deste lote

| Família | Asset | Arquivo oficial |
| --- | --- | --- |
| Animações de Nyrelia | `nyrelia.idle` | `assets/animations/heroes/nyrelia/idle.png` |
| Animações de Nyrelia | `nyrelia.move_n` | `assets/animations/heroes/nyrelia/move_n.png` |
| Animações de Nyrelia | `nyrelia.move_ne` | `assets/animations/heroes/nyrelia/move_ne.png` |
| Animações de Nyrelia | `nyrelia.move_e` | `assets/animations/heroes/nyrelia/move_e.png` |
| Animações de Nyrelia | `nyrelia.move_se` | `assets/animations/heroes/nyrelia/move_se.png` |
| Animações de Nyrelia | `nyrelia.move_s` | `assets/animations/heroes/nyrelia/move_s.png` |
| Animações de Nyrelia | `nyrelia.attack` | `assets/animations/heroes/nyrelia/attack.png` |
| Animações de Nyrelia | `nyrelia.active` | `assets/animations/heroes/nyrelia/active.png` |
| Animações de Nyrelia | `nyrelia.death` | `assets/animations/heroes/nyrelia/death.png` |
| Props abissais | `rocha_01` | `assets/props/rocha_01.png` |
| Props abissais | `rocha_02` | `assets/props/rocha_02.png` |
| Props abissais | `rocha_03` | `assets/props/rocha_03.png` |
| Props abissais | `pilar_abissal_01` | `assets/props/pilar_abissal_01.png` |
| Props abissais | `pilar_abissal_02` | `assets/props/pilar_abissal_02.png` |
| Props abissais | `pilar_abissal_03` | `assets/props/pilar_abissal_03.png` |

## Exceções e limites preservados

- A aprovação é uma decisão de oficialidade dos arquivos finais, tomada pelo
  dono apesar das ressalvas de revisão visual registradas na EVID-054.
- A aprovação não afirma que `attack`, `active` e `death` de Nyrelia sejam
  visualmente completos, nem que `rocha_01` e `rocha_03` tenham semântica de
  rocha. Essas observações permanecem fatos de QA, não impedimentos à decisão
  canônica atual.
- A decisão não aprova qualquer placement: props continuam proibidos no rio
  Estige, em água corrente ou rasa. A remoção/realocação permanece trabalho de
  cena separado.
- Os demais registros de produção e animação continuam fora deste lote; eles
  não se tornam oficiais por implicação.

## Integridade e evidência

- Lock de bytes: `.atena/generated/asset-audit/ASSET-OFFICIAL-LOCK-001.json`.
- Auditorias: `ASSET-AUDIT-001.json` e `HERO-ANIMATION-AUDIT-001.json`.
- Pranchas: `SPEC-044-nyrelia-final-review.png` e
  `SPEC-044-props-abissais-final-review.png`.
- Evidência de execução e decisão: `EVID-054` e `EVID-055`.
