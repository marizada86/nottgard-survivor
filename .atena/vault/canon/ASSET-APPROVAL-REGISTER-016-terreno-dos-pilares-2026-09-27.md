# ASSET-APPROVAL-REGISTER-016 — Atlas de terreno dos Pilares

Status: **canônico — aprovado pelo dono** (2026-09-27).

## Decisão

O dono aprovou explicitamente a candidata de piso dos Pilares com
**“aprovada”**. A candidata gerada foi derivada e admitida como atlas oficial
de terreno da fase.

## Asset oficial

- `assets/tiles/pilares_ground_atlas_v1.png`
  - formato: PNG opaco, 128×64;
  - conteúdo: quatro variantes 64×32 de obsidiana violeta-negra, basalto
    fraturado e poeira astral discreta;
  - SHA-256: `9D6AD54A74E12353D87B0BDCFE93D06314E87763EC05329E5F1BAF5530C1BD4E`;
  - consumidor: `ui/stages/pilares.tscn`, somente para os materiais terrestres
    do platô final.

## Limites

O atlas não representa água nem altera regra ambiental. Não existe Estige ou
corrente permanente nos Pilares; `rotation` e suas regras internas continuam
inalteradas. Ondas, Síntese Abissal, duração, colisão e recompensas não foram
alteradas.

## Evidência

- Direção, prompt e candidata: `ART-PROMPTS-023-terreno-dos-pilares.md`.
- Implementação e validação: `EVID-083-spec-053-pilares-2026-09-27.md`.
