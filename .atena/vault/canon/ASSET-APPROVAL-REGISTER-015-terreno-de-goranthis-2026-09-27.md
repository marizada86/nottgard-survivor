# ASSET-APPROVAL-REGISTER-015 — Atlas de terreno de Goranthis

Status: **canônico — aprovado pelo dono** (2026-09-27).

## Decisão

O dono aprovou explicitamente a candidata de piso de Goranthis com
**“aprovado”**. A candidata gerada foi derivada e admitida como atlas oficial
de terreno da fase.

## Asset oficial

- `assets/tiles/goranthis_ground_atlas_v1.png`
  - formato: PNG opaco, 128×64;
  - conteúdo: quatro variantes 64×32 de calcário gasto, mármore pérola e musgo
    seco discreto;
  - SHA-256: `1D73C07E5795AD47A3D85A10145558639F27B5C1A69C7E1C3CEE3D3FB8CE991E`;
  - consumidor: `ui/stages/goranthis.tscn`, somente para os materiais
    terrestres do falso paraíso.

## Limites

O atlas não representa água nem altera regra ambiental. A queda do Estige de
Goranthis permanece procedural, periférica e exclusivamente visual.
`sanctuary`, `illusions` e `puddles` continuam as regras da camada; ondas,
chefe, duração, colisão e recompensas não foram alterados.

## Evidência

- Direção, prompt e candidata: `ART-PROMPTS-022-terreno-de-goranthis.md`.
- Implementação e validação: `EVID-082-spec-052-goranthis-2026-09-27.md`.
