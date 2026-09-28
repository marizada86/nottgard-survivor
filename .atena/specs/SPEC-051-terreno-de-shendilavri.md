# SPEC-051 — Terreno de Shendilavri / Rivenheart

Status: **implementada e verificada** (2026-09-27).

## Questão canônica pendente

O dono aprovou a entrada de um único braço do Estige nas margens de
Shendilavri. A decisão canônica o limita a macroforma visual, sem fluxo,
empurrão, testes mentais ou qualquer regra ambiental; `illusions` continua a
única regra da camada.

## Resultado e reconciliação (2026-09-27)

O macroterreno determinístico de mármore, veio, pó de cristal, fundação,
margem e braço visual do Estige está ativo com seed 570. O dono aprovou a
candidata e o atlas derivado foi versionado como
`assets/tiles/shendilavri_ground_atlas_v1.png`, integrado somente aos
materiais terrestres; a margem e o Estige continuam procedurais e sem regra.
A suíte (`testes: 0 falha(s)`), a fumaça (`smoke: ok`) e a captura final
1280×720 passaram com o atlas ativo. A evidência está em
`EVID-081-spec-051-shendilavri-2026-09-27.md`; a aprovação canônica está no
`ASSET-APPROVAL-REGISTER-014-terreno-de-shendilavri-2026-09-27.md`.

## Intenção

Dar a Shendilavri identidade de salão abissal refinado de Rivenheart: mármore
violeta escuro, veios frios e poeira de cristal discreta, distinguindo-o de
Feng-tu e sem competir com os cristais, súcubos e ilusões jogáveis.

## Fontes e precedência

1. `vault/canon/PLAN-001-nottgard-survivors.md`, seção 7;
2. `data/stages.json`, estágio `shendilavri`;
3. `data/stage_rules.json`, regra `illusions`;
4. `PLAN-020-terreno-de-shendilavri-2026-09-27.md`.

## Escopo proposto

- Macroterreno estável de mármore, veio, pó de cristal, margem e braço visual
  do Estige.
- Candidata e, somente após aprovação explícita, atlas opaco 128×64 de quatro
  variantes 64×32 para os materiais terrestres.
- Cristais continuam props; ilusões continuam entidades de batalha.
- Testes de determinismo e isolamento de regra, suíte, fumaça e captura runtime
  1280×720.

## Não objetivos

- Criar regra para o Estige em Shendilavri; a água é visual e todos os riscos
  e comportamentos de Durao permanecem fora de escopo.
- Alterar Corte das Ilusões, inimigos, Malcanthet, ondas, duração, recompensas,
  colisão, eventos ou seed de batalha.

## Critérios de aceite propostos

1. Shendilavri é lido como salão refinado e hostil de Rivenheart, não como
   grade escura uniforme.
2. Cristais, ilusões, telegráfos, heróis, inimigos, itens e HUD permanecem
   legíveis em 1280×720.
3. A mesma seed reproduz o mesmo terreno sem deslocar RNG de batalha.
4. A regra `illusions` conserva o comportamento anterior e nenhuma regra do
   Estige é ativada.
5. O raster somente chega a `assets/` após aprovação humana, hash registrado e
   validação completa.
