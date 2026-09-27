# SPEC-047 — Terreno de Shedaklah e dois braços do Estige

Status: **implementada e verificada** (2026-09-27).

## Intenção

Implementar Shedaklah como pântano fúngico entre dois braços lentos do Rio
Estige. A composição precisa distinguir a pressão de Zuggtmoy (fungo, micélio,
solo úmido) da contaminação de Juiblex (crostas e poças locais), sem tornar o
andar uma extensão visual ou mecânica de Durao.

## Fontes e precedência

1. `vault/canon/PLAN-001-nottgard-survivors.md`, seção 21;
2. `vault/research/RESEARCH-001-abismo-bestiario-visual-2026-09-21.md`;
3. `SPEC-039-macroterreno-abissal-montanhas-e-rio-estige.md` e `SPEC-040-estige-gelatinoso-e-elites-de-juiblex.md`;
4. a aprovação explícita do dono em 2026-09-27: “junte isso ao plano e vamos fazê-lo”.

## Escopo

- Definir dois braços contínuos do Estige nas bordas esquerda e direita de
  Shedaklah, com margem orgânica e sem fluxo visual rápido.
- Compor o centro por solo fúngico, micélio e crostas de ooze em macroregiões
  determinísticas, sem consumir RNG de batalha.
- Manter o Estige de Shedaklah somente visual: sem água atravessável, empurrão,
  Teste de Lucidez, Chamado, derrota ou Imbuído por Juiblex.
- Criar e registrar uma candidata de textura de piso; ela não integra
  `assets/` antes de aprovação humana.
- Cobrir a geometria e a ausência de acoplamento a Durao por testes.

## Não objetivos

- Mudar colisão, ondas, inimigos, chefe, duração, loot, eventos ou regra
  `puddles` da fase.
- Substituir ou enfraquecer o Estige gelatinoso, imóvel e mentalmente perigoso
  de Durao.
- Criar uma nova regra de travessia ou fato narrativo além do cânone aprovado.

## Contrato visual

- O piso é escuro e discreto: terra compactada ameixa, micélio violeta-pálido e
  pedra úmida; verde-oliva é raro e nunca neon.
- O Estige é quase preto, calmo e contido pelas margens. Sua presença é lida
  como dois cursos de borda, não como uma faixa central que corte a arena.
- Props de cogumelo continuam y-sorted e independentes do terreno. Telégrafos,
  inimigos, itens, projéteis e portal rendem acima de solo, decais e água.

## Critérios de aceite

1. Os dois braços são determinísticos e contínuos nas bordas opostas; o centro
   do mapa não é água.
2. O layout não ativa nenhuma função hídrica de Durao em Shedaklah.
3. Fungo, micélio, ooze e Estige são distinguíveis em captura 1280×720 sem
   texto de UI, e os elementos de combate continuam legíveis.
4. A candidata tem origem, prompt e caminho rastreáveis; a integração final só
   ocorre após uma aprovação humana explícita.
5. Suíte, smoke, captura e reconciliação ADD passam sem regressão.

## Plano de voo

1. Registrar o fato canônico aprovado e a relação com as SPECs de Durao.
2. Implementar os materiais e dois cursos de borda em `TerrainLayout` e na
   cena de Shedaklah.
3. Gerar, inspecionar e arquivar a candidata de textura fora de `assets/`.
4. Adicionar testes determinísticos e executar captura, smoke e suíte.
5. Registrar evidência; apresentar a candidata ao dono para decidir sua
   promoção a atlas final.

## Resultado parcial e reconciliação (2026-09-27)

- `TerrainLayout` passou a compor dois braços contínuos nas bordas opostas de
  Shedaklah, junto a solo fúngico, micélio e crosta de ooze em macroregiões
  estáveis. As consultas que ativam água e efeitos do Estige continuam restritas
  a Durao.
- `ui/stages/shedaklah.tscn` usa o layout regional com seed 222. A captura de
  runtime confirma a arena central ampla e os dois cursos de borda sem reduzir
  a leitura de herói, inimigos, itens ou HUD.
- A candidata raster `shedaklah-ground-source-v1.png` foi gerada e inspecionada
  pelo fluxo interno de imagem. Ela está preservada em material de trabalho e
  ainda não é consumida por uma cena nem por `assets/`.
- `tests/test_terrain.gd`, a suíte headless e a fumaça passam. A captura e o
  hash da candidata estão em `EVID-077-spec-047-shedaklah-estige-2026-09-27.md`.
- O dono aprovou a candidata em 2026-09-27. O atlas final derivado foi
  versionado como `assets/tiles/shedaklah_ground_atlas_v1.png` e integrado
  somente aos materiais de solo, micélio e crosta de ooze; Estige e margens
  continuam procedurais e legíveis.

## Impactos

- `core/terrain_layout.gd`, `ui/ground.gd`, `ui/stages/shedaklah.tscn` e
  `tests/test_terrain.gd`.
- Candidata: `.atena/generated/art-candidates/terrain/shedaklah-ground-source-v1.png`.
- Não há asset de produção novo nesta entrega sem a aprovação de arte.
