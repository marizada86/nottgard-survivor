# ASSET-APPROVAL-REGISTER-012 — Atlas de terreno de Molor

Status: **canônico — aprovado pelo dono** (2026-09-27).

## Decisão

O dono aprovou explicitamente a candidata de piso de Molor com
**“aprovado”**. A candidata gerada foi derivada e admitida como atlas oficial
de terreno da fase.

## Asset oficial

- `assets/tiles/molor_ground_atlas_v1.png`
  - formato: PNG opaco, 128×64;
  - conteúdo: quatro variantes 64×32 de rocha de caverna, detrito mineralizado
    e resíduo oliva discreto;
  - SHA-256: `2FAF995505894D93EAB5D54AE7C0EF9E92CC36A377D53F609CACDE7B7F517C1D`;
  - consumidor: `ui/stages/molor.tscn`, somente para os materiais terrestres
    do macroterreno de Molor.

## Limites

O atlas não representa água nem altera regra ambiental. A passagem do Estige
por Molor continua indefinida e nenhuma mecânica de Durao foi introduzida.
Ondas, chefe, duração, colisão, recompensas e a regra `puddles` existente não
foram alterados.

## Evidência

- Direção, prompt e candidata: `ART-PROMPTS-019-terreno-de-molor.md`.
- Implementação e validação: `EVID-079-spec-048-molor-2026-09-27.md`.
