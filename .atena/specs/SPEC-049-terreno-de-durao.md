# SPEC-049 — Atualização visual do terreno de Durao

Status: **superada — não executar** (2026-09-27).

> O dono confirmou que Durao já foi concluído e solicitou o próximo mapa,
> Feng-tu. Esta especificação não deve gerar trabalho de execução.

## Intenção

Elevar Durao ao padrão visual modular dos mapas recentes sem reabrir o piloto
de macroterreno ou a regra ambiental já validada. A leitura é de uma jaula
abissal pós-guerra: basalto escuro, cinza, rachaduras e ferrugem apagada em
contraste com o Estige gelatinoso e imóvel.

## Fontes e precedência

1. `vault/canon/PLAN-001-nottgard-survivors.md`, seções 7 e 21;
2. `SPEC-039-macroterreno-abissal-montanhas-e-rio-estige.md`;
3. `SPEC-040-estige-gelatinoso-imovel.md`;
4. `data/stages.json`, estágio `durao`;
5. `PLAN-018-terreno-de-durao-2026-09-27.md`.

## Escopo proposto

- Candidata e, somente após aprovação, atlas opaco 128×64 com quatro variantes
  64×32 para o piso seco de Durao.
- Vínculo modular restrito a basalto, cinza e encostas terrestres.
- Estige, água rasa, margens, penhascos e props permanecem procedurais.
- Testes de compatibilidade do terreno, suíte, fumaça e captura 1280×720.

## Não objetivos

- Alterar o Estige: ele permanece gelatinoso, imóvel e atravessável, com os
  riscos mentais já existentes e sem força de empurrão.
- Alterar lore, inimigos, Molydeus, ondas, duração, recompensas, colisão ou
  sementes de batalha.
- Criar arte de Feng-tu ou modificar qualquer outro mapa.

## Critérios de aceite propostos

1. O piso de Durao deixa de parecer uma única losanga repetida e mantém a
   leitura de arena seca e hostil.
2. Herói, inimigos, itens, telegráfos, HUD, margens e penhascos permanecem
   legíveis em 1280×720.
3. O comportamento do Estige gelatinoso é idêntico antes e depois da troca.
4. A mesma seed preserva a mesma composição e a suíte/fumaça passam.
5. Nenhum raster é promovido sem aprovação humana explícita e registro de hash.
