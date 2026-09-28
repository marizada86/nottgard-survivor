# SPEC-052 — Terreno de Goranthis

Status: **implementada e verificada** (2026-09-27).

## Resultado e reconciliação (2026-09-27)

O macroterreno determinístico de terraço, mármore pérola, musgo seco,
fundação, margem e queda visual do Estige está ativo com seed 597. O dono
aprovou a candidata e o atlas derivado foi versionado como
`assets/tiles/goranthis_ground_atlas_v1.png`, integrado somente aos materiais
terrestres; a margem e a queda continuam procedurais e sem regra. A suíte
(`testes: 0 falha(s)`), a fumaça (`smoke: ok`) e a captura final 1280×720
passaram com o atlas ativo. A evidência está em
`EVID-082-spec-052-goranthis-2026-09-27.md`; a aprovação canônica está no
`ASSET-APPROVAL-REGISTER-015-terreno-de-goranthis-2026-09-27.md`.

## Intenção

Dar a Goranthis uma identidade de falso paraíso de Socothbenoth: terraços
claros e nobres que contrastam com a queda impossível e periférica do Estige,
sem dificultar a leitura de santuários, ilusões e poças.

## Fontes e precedência

1. `vault/canon/PLAN-001-nottgard-survivors.md`, seção 7;
2. `data/stages.json`, estágio `goranthis`;
3. `data/stage_rules.json`, regras `sanctuary`, `illusions` e `puddles`;
4. referência externa de lore: o Estige entra em Goranthis por grande cachoeira;
5. `PLAN-021-terreno-de-goranthis-2026-09-27.md`.

## Escopo proposto

- Macroterreno estável de terraço, mármore pérola, musgo seco, margem e queda
  visual periférica do Estige.
- Candidata e, somente após aprovação explícita, atlas opaco 128×64 de quatro
  variantes 64×32 para os materiais terrestres.
- Cachoeiras preservadas como props e integradas à leitura da queda visual.
- Testes de determinismo e isolamento de regra, suíte, fumaça e captura runtime
  1280×720.

## Não objetivos

- Alterar `sanctuary`, `illusions`, `puddles`, inimigos, Socothbenoth, ondas,
  duração, recompensas, colisão, eventos ou seed de batalha.
- Criar comportamento do Estige: a queda proposta é visual, sem riscos ou
  mecânicas de Durao.

## Critérios de aceite propostos

1. Goranthis é lido como terraço paradisíaco e artificial, não como grade
   bege uniforme.
2. Cachoeiras, santuários, ilusões, poças, heróis, inimigos, itens e HUD
   permanecem legíveis em 1280×720.
3. A mesma seed reproduz o mesmo terreno sem deslocar RNG de batalha.
4. As três regras ambientais existentes conservam o comportamento anterior e
   nenhuma regra hídrica do Estige é ativada.
5. O raster somente chega a `assets/` após aprovação humana, hash registrado e
   validação completa.
