# EVID-079 — Piloto gerado de Leoric

Data: 2026-09-27  
SPEC: `SPEC-049-preparacao-da-regeneracao-do-piloto-de-leoric.md`

## Proveniência

O dono autorizou a geração. O método foi ImageGen integrado, sem transferência
de referências locais. Os prompts exigiram Leoric como gnomo adulto — chapéu
largo escuro, barba grisalha, manto verde-musgo, constelações douradas e foco
azul — em pixel art isométrica, corpo preenchido e fundo RGBA transparente.

## Candidatos

| Strip | Caminho | SHA-256 |
| --- | --- | --- |
| idle | `.atena/generated/leoric-regeneration/v01/strips/idle.png` | `17e9d79f2e69abe3d41d82eef696c8f866cfb5106baafb3a865bcafb8181a09b` |
| move_se | `.atena/generated/leoric-regeneration/v01/strips/move_se.png` | `dab89a595f5c2431ad91bbed0ba2a4b85ce041101be40c4974ec599f20646228` |
| attack | `.atena/generated/leoric-regeneration/v01/strips/attack.png` | `9c37289463a0efa42bcf8b4a44ab4c02067cbef1ea5367f04b37259f38e2d538` |

## Validação

- A prancha `.atena/evidence/SPEC-049-leoric-pilot-v01.png` mostra os 14
  frames em escala real com chapéu, barba, corpo e manto legíveis.
- Todos os frames têm RGBA, margem lateral de pelo menos 8 px e conteúdo com
  alfa >= 0,10 terminando em y=367. Os candidatos que começaram acima da base
  foram alinhados localmente antes dessa validação.
- Nenhum arquivo sob `assets/animations/heroes/leoric/`, lock ou registro
  canônico foi alterado.

Conclusão: o piloto é tecnicamente elegível e aguarda seleção artística do
dono antes da expansão ou admissão.
