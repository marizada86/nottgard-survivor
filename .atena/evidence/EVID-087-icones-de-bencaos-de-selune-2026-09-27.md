---
id: "EVID-087"
type: "evidence"
title: "Integração dos ícones de bênção de Selûne"
status: "passed"
created: "2026-09-27"
relations:
  - "[[SPEC-058-candidatas-de-bencaos-de-selune]]"
  - "[[SPEC-056-sobreposicao-visual-das-divindades]]"
---

# EVID-087 — Ícones de bênção de Selûne

## Resultado

As duas lacunas de ícone das bênçãos de Selûne foram preenchidas após aprovação
visual explícita do dono. Não houve alteração de lore, dados, regras, cenas ou
código.

| ID | Candidata aprovada | Arquivo oficial | SHA-256 |
|---|---|---|---|
| `selune_luar` | `.atena/generated/art-candidates/icons/boons/selune_luar_v01.png` | `assets/icons/boons/selune_luar.png` | `ace8e78cac1ab546217318a734840a774593aa7ff0236f1bc601da1d12146d50` |
| `selune_guia` | `.atena/generated/art-candidates/icons/boons/selune_guia_v01.png` | `assets/icons/boons/selune_guia.png` | `514658fbd2a62df6b5289e991b04ec9dc3cac3a2476980f6a2a07c906d6121af` |

## Validação

| Verificação | Resultado |
|---|---|
| Dimensões | ambos 128×128 |
| Alfa e margem | alfa transparente presente; nenhuma borda opaca |
| `tools/validate_generated_assets.ps1` | passou: 269/269 arquivos, 239 com alfa, 8 aliases, zero warnings e zero errors |
| `Godot_v4.7.2-stable_win64.exe --headless --path . -s tests/run_all.gd` | passou: `testes: 0 falha(s)` |

O modo headless preservou os avisos já conhecidos de log em `user://`,
certificados do sistema e recursos de renderização no encerramento. O processo
terminou com código zero e não houve falha de asset ou teste.

## Reconciliação operacional

- `data/boons.json` agora possui arquivo resolvível para todas as 14 bênçãos.
- `.atena/generated/ASSET-PRODUCTION-MANIFEST-001.json` registra 269 entradas,
  incluindo as duas integrações selecionadas e seus hashes.
- As candidatas permanecem no cofre ADD como rastreio da decisão; os PNGs
  oficiais pertencem a `assets/icons/boons/`.
