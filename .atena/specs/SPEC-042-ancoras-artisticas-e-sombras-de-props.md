# SPEC-042 — Âncoras artísticas e sombras de props

Status: **implementada e verificada** (2026-09-27).

## Intenção

Eliminar a leitura de props flutuando no piso isométrico. Cada variante de
arte passa a ter um ponto de apoio artístico explícito e uma política de
sombra compatível com a própria arte. A correção é estritamente visual:
posições lógicas, colisões, `block_radius`, y-sort, ondas e navegação
permanecem inalterados.

## Diagnóstico

A captura de Durao em 2026-09-27 mostra que o critério da SPEC-041 — última
linha com alfa — não representa sempre o pé percebido do objeto. Pixels
isolados, brilho, detritos e sombra já desenhada no PNG podem ficar abaixo da
base estrutural. Além disso, a elipse de sombra genérica é desenhada para
todo PNG, mesmo para assets que já trazem sombra ou base escura. A segunda
sombra, separada da arte, reforça a impressão de suspensão.

## Fontes e precedência

1. Declaração do dono em 2026-09-27: props devem encostar no chão, sem
   flutuar;
2. Captura fornecida pelo dono em 2026-09-27, com rochas e pilares abissais
   como exemplos de falha;
3. SPEC-041 e EVID-050, que identificam a solução automática anterior e sua
   limitação perceptiva;
4. Contratos de y-sort e bloqueio lógico das SPEC-037 e SPEC-039.

## Escopo

- Criar metadados visuais por **asset e variante**, contendo:
  - `contact_anchor`: ponto `(x, y)` do pé artístico em pixels de origem;
  - `shadow_mode`: `embedded`, `dynamic` ou `none`;
  - `shadow_anchor` e dimensões apenas quando `shadow_mode` for `dynamic`;
  - ajuste visual documentado quando indispensável.
- Renderizar cada PNG de modo que seu `contact_anchor` coincida com o ponto
  lógico de solo do `Node2D`.
- Desabilitar a sombra elíptica genérica para assets com `shadow_mode =
  embedded` e para assets sem sombra intencional.
- Aplicar inicialmente a rochas e pilares abissais; depois, às variantes de
  caixote, carga, barril, rede, braseiro e demais props raster presentes nas
  três fases de validação.
- Manter formas procedurais e módulos de penhasco no contrato atual, usando
  sombra dinâmica apenas quando não houver arte raster com base própria.
- Adicionar modo QA de ancoragem que mostre, sob comando, cruz do contato,
  área/sombra dinâmica e ponto lógico de solo, sem aparecer no jogo normal.

## Não objetivos

- Editar, recortar ou sobrescrever PNGs de origem.
- Mover props nas cenas, mudar coordenadas isométricas ou recalcular layouts.
- Alterar `block_radius`, colisores, layers, máscaras, y-sort ou regras de
  batalha.
- Redesenhar o terreno, o Estige gelatinoso, inimigos ou personagens.
- Forçar assets explicitamente levitantes a usar âncora de solo; eles devem
  declarar uma exceção visual, nunca reutilizar a regra de props apoiados.

## Contrato técnico

1. A origem lógica do `Prop` continua sendo o contato de gameplay no chão.
2. Para um PNG com `contact_anchor`, o retângulo de desenho é deslocado para
   que esse ponto — após escala — fique exatamente na origem local, mais um
   override visual documentado.
3. A seleção por variante é determinística: o renderer consulta os metadados
   do caminho de asset efetivamente escolhido, sem depender apenas do `kind`.
4. `embedded` nunca desenha a elipse dinâmica; `none` não desenha sombra;
   `dynamic` desenha uma única sombra no `shadow_anchor` definido.
5. Ausência de metadado é falha visível no QA e usa fallback temporário
   conservador, registrado para completar antes da aprovação final.
6. A leitura de imagem, se existir como fallback, fica em cache e não ocorre
   dentro de `_draw()` a cada quadro.
7. Guias QA são exclusivos da sessão de teste e não influenciam captura de
   jogo, colisão ou ordenação.

## Plano de voo

1. Inventariar todos os PNGs usados por `Prop`, separando base/sombra embutida,
   base sem sombra, sombra intencional e casos levitantes.
2. Medir e registrar `contact_anchor` das três variantes de rocha e pilar
   abissal; preparar uma captura de foco em Durao para confirmar o critério
   antes de expandir a tabela.
3. Definir o formato local dos metadados e implementar sua consulta por caminho
   de asset, preservando o fallback da SPEC-041 somente para assets ainda não
   catalogados.
4. Ajustar o renderer para usar âncora artística e política de sombra única;
   não tocar em transformações lógicas dos nós de cena.
5. Implementar o modo QA com guias de âncora, sombra e origem lógica; testar
   herói e inimigo em frente e atrás de props baixos e altos.
6. Catalogar e validar caixotes, carga, barris, redes, braseiros e demais
   variantes usadas em Dagruve e Docas.
7. Capturar Dagruve, Docas e Durao em 1280×720, comparar com a referência de
   falha, executar suíte/smoke e registrar evidência ADD.

## Critérios de aceite

1. Rochas e pilares abissais da cena de Durao aparentam estar apoiados no
   chão, sem elipse destacada sob a base, em 1280×720.
2. Nenhum prop catalogado apresenta sombra dupla ou faixa de piso entre sua
   base estrutural e o contato, tolerância máxima de dois pixels.
3. Caixotes, carga, barris, redes e braseiros permanecem apoiados em Dagruve
   e Docas, cada um com sua política de sombra apropriada.
4. O QA mostra que âncora, sombra e origem lógica coincidem; o QA desligado
   não altera a imagem normal.
5. Herói, inimigos, itens e telégrafos preservam a ordem diante/atrás dos
   props, e as colisões/resultados da fase não se modificam.
6. Suíte, smoke de todas as fases e capturas de Dagruve, Docas e Durao passam
   antes da reconciliação.

## Impactos previstos

- `ui/prop.gd` e, somente se necessário para props procedurais,
  `ui/terrain_features.gd`;
- nova tabela local de metadados visuais de props;
- Navegador QA/renderer de guias, testes determinísticos e evidência visual.

Nenhuma dependência, migração de asset, mudança de cânone ou alteração de
dados de combate é prevista.

## Plano de aprovação

A aprovação desta SPEC autoriza somente a implementação local delimitada
acima. Qualquer necessidade de editar os PNGs de origem, mover nós de cena,
alterar colisões ou ampliar o escopo para outro sistema exige nova aprovação.

## Reconciliação da execução

- `data/prop_visuals.json` registra âncora normalizada, política de sombra,
  deslocamento e dimensões para cada variante de rocha, pilar abissal e dos
  props usados por Dagruve e Docas.
- `ui/prop.gd` passa a posicionar o PNG pelo `contact_anchor` artístico em
  vez de depender exclusivamente da última linha com alfa. Para PNGs, a
  elipse genérica foi substituída por uma única sombra proporcional ao asset;
  docas, margens, redes e ossos não recebem sombra artificial.
- O alvo QA `prop_grounding` exibe cruz verde para o contato lógico e contorno
  amarelo para a sombra, sem alterar a imagem de uma run normal.
- Não foram movidos nós de cena nem alterados `block_radius`, colisores,
  y-sort, terreno ou PNGs de origem.
- Testes determinísticos cobrem a transformação da âncora, integridade da
  tabela visual, política de sombra e isolamento do guia QA. Suíte e smoke
  passaram.
- Capturas em Dagruve, Docas, Durao e Pilares confirmam que rochas e pilares
  deixam de exibir a sombra oval destacada que causava a impressão de flutuar.

Evidência: `EVID-051-spec-042-ancoras-artisticas-2026-09-27.md` e capturas
`SPEC-042-*-ancoras-2026-09-27.png` em `.atena/evidence/`.
