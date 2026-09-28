# SPEC-053 — Terreno dos Pilares

Status: **implementada e verificada** (2026-09-27).

## Resultado e reconciliação (2026-09-27)

O macroterreno determinístico de obsidiana, basalto fraturado, poeira astral e
fundação está ativo com seed 800. O dono aprovou a candidata e o atlas derivado
foi versionado como `assets/tiles/pilares_ground_atlas_v1.png`, integrado
somente aos materiais terrestres; a fundação continua procedural. A suíte
(`testes: 0 falha(s)`), a fumaça (`smoke: ok`) e a captura final 1280×720
passaram com o atlas ativo. A evidência está em
`EVID-083-spec-053-pilares-2026-09-27.md`; a aprovação canônica está no
`ASSET-APPROVAL-REGISTER-016-terreno-dos-pilares-2026-09-27.md`.

## Intenção

Dar aos Pilares uma identidade de platô final da Síntese Abissal: obsidiana
violeta-negra e basalto fraturado silenciosos, capazes de acolher os pilares
rúnicos e múltiplas regras rotativas sem comprometer a legibilidade.

## Fontes e precedência

1. `vault/canon/PLAN-001-nottgard-survivors.md`, seções 5 e 7;
2. `data/stages.json`, estágio `pilares`;
3. `data/stage_rules.json`, regra `rotation`;
4. `PLAN-022-terreno-dos-pilares-2026-09-27.md`.

## Escopo proposto

- Macroterreno estável de obsidiana, basalto fraturado, poeira astral e
  fundação abissal.
- Candidata e, somente após aprovação explícita, atlas opaco 128×64 de quatro
  variantes 64×32 para os materiais terrestres.
- Pilares continuam props e a regra `rotation` continua inteiramente de
  batalha.
- Testes de determinismo e isolamento de regra, suíte, fumaça e captura runtime
  1280×720.

## Não objetivos

- Criar Estige, rio, água ou regra ambiental permanente no platô.
- Alterar `rotation`, poças, corrente, raios, ilusões, Síntese Abissal,
  inimigos, ondas, duração, recompensas, colisão, eventos ou seed de batalha.

## Critérios de aceite propostos

1. Os Pilares são lidos como platô final abissal, não como grade escura
   uniforme.
2. Pilares, Síntese, telegráfos, heróis, inimigos, itens e HUD permanecem
   legíveis em 1280×720.
3. A mesma seed reproduz o mesmo terreno sem deslocar RNG de batalha.
4. A rotação de regras preserva o comportamento anterior e o piso não cria
   Estige ou corrente permanente.
5. O raster somente chega a `assets/` após aprovação humana, hash registrado e
   validação completa.
