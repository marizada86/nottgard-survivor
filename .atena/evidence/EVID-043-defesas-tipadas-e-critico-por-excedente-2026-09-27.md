# EVID-043 — Defesas tipadas e crítico por excedente

Data: 2026-09-27  
Especificação: `SPEC-035`  
Plano: `PLAN-010`

## Implementação

- CA/CAM acima de 10 agora concedem 3% de esquiva física/mística por ponto, até 30%.
- Esquiva tipada e genérica combinam multiplicativamente, com teto final de 45%.
- Precisão inimiga reduz somente a parcela tipada em 1 ponto percentual por bônus.
- Ataques preservam a escala-base de acerto por precisão; 1 natural erra e 20 natural acerta.
- Crítico exige acerto normal, exceto 20 natural, que continua crítico garantido.
- Excedente acima de 20 concede 3% de chance de crítico por ponto; teto final de 40%.
- Bônus e descrições de `crit_range`/`crit_step` foram migrados para `crit_overflow_bonus`/`crit_overflow_step`.

## Verificação

| Verificação | Resultado |
|---|---|
| `D:\Godot\godot.exe --headless --path . -s tests/run_all.gd` | Passou: `testes: 0 falha(s)` |
| Limiar CA 13 | Coberto: 9% de esquiva física |
| Limiar CA 20 + 10% genérico | Coberto: 37% combinado, abaixo do teto |
| Crítico por excedente | Coberto: total 22 resulta em 6% |
| Teto de crítico | Coberto: máximo de 40% |
| Smoke test | Bloqueado fora do escopo: `ui/run.gd` referencia `DivineVisuals`, identificador ausente no projeto atual |

## Reconciliação pendente

O smoke visual deve ser repetido depois que a integração preexistente de `DivineVisuals` for resolvida. Nenhuma alteração foi feita em `ui/run.gd` ou nessa integração.
