# ASSET-APPROVAL-REGISTER-013 — Atlas de terreno de Feng-tu

Status: **canônico — aprovado pelo dono** (2026-09-27).

## Decisão

O dono aprovou explicitamente a candidata de piso de Feng-tu com
**“aprovado”**. A candidata gerada foi derivada e admitida como atlas oficial
de terreno da fase.

## Asset oficial

- `assets/tiles/feng_tu_ground_atlas_v1.png`
  - formato: PNG opaco, 128×64;
  - conteúdo: quatro variantes 64×32 de ardósia azul-negra, basalto, cinza
    ritual discreta e fissuras;
  - SHA-256: `C5FF57BC4A1B6829A46FD95A9E7CDBDBC7EFDDAB8740A5B2CA64AE8EAE7A3886`;
  - consumidor: `ui/stages/feng_tu.tscn`, somente para os materiais
    terrestres do pátio ritual.

## Limites

O atlas não representa água nem altera a regra ambiental. O Estige não foi
adicionado a Feng-tu; Julgamento de Tou Um e seus raios permanecem inalterados.
Ondas, chefe, duração, colisão e recompensas não foram alterados.

## Evidência

- Direção, prompt e candidata: `ART-PROMPTS-020-terreno-de-feng-tu.md`.
- Implementação e validação: `EVID-080-spec-050-feng-tu-2026-09-27.md`.
