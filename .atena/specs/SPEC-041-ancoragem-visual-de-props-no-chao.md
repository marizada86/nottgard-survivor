# SPEC-041 — Ancoragem visual de props no chão

Status: **implementada e verificada** (2026-09-27).

## Intenção

Fazer com que todo objeto de cenário pareça tocar o chão isométrico. A
correção é exclusivamente visual: posições lógicas, colisões, y-sort e
composição das fases permanecem estáveis. Ela corrige tanto PNGs de props
quanto formas procedurais de penhascos e props sem arte raster.

## Diagnóstico

`ui/prop.gd` desenha a textura ancorando a borda inferior do retângulo do
arquivo em `y = 0`. Esse método não considera transparência inferior ou
espaço de composição dentro do PNG; a base visível pode ficar acima do ponto
de colisão e da sombra. Mover cada nó de cena apenas deslocaria o problema e
poderia separar arte e bloqueio lógico.

## Fontes e precedência

1. Declaração do dono em 2026-09-27: objetos do cenário devem encostar no
   chão, sem flutuar;
2. `ui/prop.gd`, `ui/terrain_features.gd` e cenas em `ui/stages/`;
3. `SPEC-039-macroterreno-abissal-montanhas-e-rio-estige.md`, contrato de
   y-sort, penhascos e bloqueio lógico.

## Escopo

- Calcular e aplicar um ponto de contato visual para cada textura de prop.
- Usar a borda inferior do conteúdo visível da imagem como base automática,
  em cache por caminho de asset.
- Expor `visual_ground_offset` opcional por prop para ajustes de assets com
  sombra embutida, transparência intencional ou objetos deliberadamente no ar.
- Reancorar sombra e desenho ao mesmo ponto local `y = 0`.
- Corrigir as formas procedurais de `ui/prop.gd` e
  `ui/terrain_features.gd` para que nenhuma parte estrutural fique abaixo da
  base de contato, salvo sombra/decal sem colisão.
- Criar cenários QA e testes para prop baixo, prop alto, penhasco e prop junto
  ao Estige gelatinoso.

## Não objetivos

- Mover nós de prop nas cenas, recalcular coordenadas isométricas ou alterar
  `block_radius`/colisões.
- Editar, recortar ou sobrescrever os PNGs de origem.
- Alterar alturas artísticas, paleta, materiais, comportamento de combate ou
  y-sort dos atores.
- Forçar objetos que são explicitamente levitantes a tocar o chão; eles usam
  uma exceção declarada, nunca uma falha de âncora.

## Contrato técnico

1. O ponto lógico do `Node2D` continua sendo o centro do contato no solo.
2. Para PNGs, a implementação lê uma vez a área útil de alfa da imagem e
   calcula a borda inferior visível em pixels. Ao desenhar com escala, desloca
   o retângulo para que essa borda coincida com `y = 0`.
3. O cálculo fica em cache por caminho do asset; `_draw()` não pode ler a
   imagem a cada frame.
4. `visual_ground_offset` é aplicado depois da base automática, em pixels de
   tela. O padrão é zero; valores diferentes precisam de comentário no nó ou
   de registro no QA.
5. Sombra elíptica, decal de contato e base visível usam a mesma origem. A
   sombra pode ultrapassar a base, mas não vira parte do bloqueio.
6. Formas procedurais têm geometria de contato em `y = 0`; a arte sobe a partir
   dela. Penhascos continuam no grupo y-sorted e sua malha lógica continua a
   fonte de bloqueio.

## Plano de voo

1. Inventariar os props raster e medir base útil, transparência inferior e
   sombra embutida das três variantes de cada tipo.
2. Implementar o cache de base automática e `visual_ground_offset` em
   `ui/prop.gd`; validar primeiro em rocha, pilar, caixote e carga.
3. Alinhar sombra, fallback procedural e módulos de penhasco ao contrato de
   contato sem tocar em posições/colliders de cenas.
4. Adicionar ao Navegador QA cenários de contato em piso seco, margem do
   Estige e água gelatinosa; incluir herói e inimigo para avaliar o y-sort.
5. Escrever testes determinísticos da conversão pixel→escala→base e de que
   offsets visuais não mudam `block_radius` nem posição lógica.
6. Capturar Dagruve, Docas e Durao em 1280×720, rodar suíte/smoke e registrar
   evidência ADD.

## Critérios de aceite

1. Em 1280×720, rochas, pilares, caixotes, carga e penhascos aparentam tocar
   o piso; não há faixa de fundo visível entre base e sombra.
2. A tolerância entre a borda visível e o ponto de contato é de no máximo dois
   pixels de tela, exceto em overrides documentados.
3. Colisões, posições dos props, seed, ondas e resultado de batalha não mudam.
4. Herói, inimigos, itens e telégrafos continuam legíveis e corretamente
   ordenados diante e atrás de props baixos/altos.
5. Props junto ao Estige gelatinoso permanecem ancorados e não parecem boiar
   sobre a água.
6. Suíte, smoke e capturas das três fases passam antes da reconciliação.

## Impactos previstos

- `ui/prop.gd`, `ui/terrain_features.gd`, cenas QA, testes de props/terreno e
  evidência visual.
- Nenhuma dependência, migração de asset ou alteração de cânone é necessária.

## Reconciliação da execução

- `ui/prop.gd` passou a usar a borda inferior da área alfa útil do PNG como
  ponto de contato, com cache por caminho de textura. A sombra, a arte raster
  e os fallbacks procedurais compartilham essa origem.
- `visual_ground_offset` permite o ajuste localizado de um asset sem alterar
  `position`, `block_radius`, colisões ou y-sort. Nenhum override foi
  necessário nos cenários verificados.
- `ui/terrain_features.gd` recebeu o mesmo deslocamento visual opcional para
  que penhascos e seus detalhes permaneçam coesos com a base no solo.
- O Navegador QA inclui `Props: contato visual` (`prop_grounding`) para abrir
  qualquer fase e inspecionar base, sombra e sobreposição de atores.
- Os testes determinísticos cobrem base cheia, transparência inferior, offset
  visual e preservação de `block_radius`; a suíte passou sem falhas.
- O smoke percorreu todas as fases com êxito. As capturas de Dagruve, Docas e
  Durao confirmam contato visual e ordem de profundidade, inclusive na margem
  do Estige gelatinoso.

Evidência: `EVID-050-spec-041-ancoragem-de-props-2026-09-27.md` e
`SPEC-041-*-props-2026-09-27.png` em `.atena/evidence/`.
