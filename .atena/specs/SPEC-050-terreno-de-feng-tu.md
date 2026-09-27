# SPEC-050 — Terreno de Feng-tu

Status: **proposta — aguardando aprovação do plano** (2026-09-27).

## Intenção

Dar a Feng-tu uma identidade de pátio ritual de Tou Um: ardósia e basalto
azul-negro, cinza e fissuras discretas, capazes de sustentar os torii e a
regra de raios sem prejudicar telegráfos, heróis, inimigos ou itens.

## Fontes e precedência

1. `vault/canon/PLAN-001-nottgard-survivors.md`, seção 7;
2. `data/stages.json`, estágio `feng_tu`;
3. `data/stage_rules.json`, regra `strikes`;
4. `PLAN-019-terreno-de-feng-tu-2026-09-27.md`.

## Escopo proposto

- Macroterreno estável de laje, cinza ritual, fissura e borda de fundação.
- Candidata e, somente após aprovação explícita, atlas opaco 128×64 de quatro
  variantes 64×32 para os materiais terrestres.
- Torii e santuários preservados como props; relâmpagos permanecem telegráfos
  e regra de batalha já existentes.
- Testes de determinismo e isolamento de regra, suíte, fumaça e captura
  runtime 1280×720.

## Não objetivos

- Decidir ou implementar o Estige em Feng-tu: o canon atual não o coloca
  nesta camada e não será adicionada água ou mecânica de Durao.
- Alterar Julgamento de Tou Um, inimigos, Lu Yueh, ondas, duração, recompensas,
  colisão, eventos ou seed de batalha.

## Critérios de aceite propostos

1. Feng-tu é lido como pátio de templo ritual, não como grade escura uniforme.
2. Torii, santuários, raios, telegráfos, heróis, inimigos, itens e HUD são
   legíveis em 1280×720.
3. A mesma seed reproduz o mesmo terreno sem deslocar RNG de batalha.
4. A regra `strikes` conserva o comportamento anterior e nenhuma regra do
   Estige é ativada.
5. O raster somente chega a `assets/` após aprovação humana, hash registrado e
   validação completa.
