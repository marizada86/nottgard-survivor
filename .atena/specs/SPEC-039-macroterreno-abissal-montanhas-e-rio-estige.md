# SPEC-039 — Macroterreno Abissal, montanhas e Rio Estige

Status: **parcialmente supersedida** pelo PLAN-027/SPEC-055 (2026-09-27).
O sistema de macroterreno e a tradução de Lucidez/Esquecimento permanecem;
empurrão, Chamado, derrota temporal e exclusividade de Durão não são vigentes.

## Intenção

Substituir a aparência de “um único tile repetido” por uma composição de
terreno em camadas para os andares do Plano Abissal. O primeiro piloto será
em **Durao**: deserto pós-guerra de basalto e ferro oxidado, com o Rio Estige,
suas margens e formações rochosas. O piloto define o sistema que depois poderá
ser parametrizado por Shedaklah, Molor, Feng-tu, Shendilavri, Goranthis e
Pilares, sem reescrever a simulação isométrica. Em Durao, o Estige também
será uma regra ambiental de risco mental legível, não apenas um elemento
decorativo.

## Fontes e precedência

1. `.atena/vault/canon/PLAN-001-nottgard-survivors.md`, seções 1, 6, 7 e 10;
2. `RESEARCH-001-abismo-bestiario-visual-2026-09-21.md`, tabela de camadas;
3. `SPEC-037-terreno-modular-isometrico-dagruve-docas.md` e sua evidência;
4. `ui/ground.gd`, `ui/prop.gd`, `core/battle.gd` e as cenas de fase atuais;
5. esta SPEC, somente para composição visual e contratos técnicos que não
   alterem lore estabelecida.

## Fato operacional que esta SPEC corrige

Um atlas com variações muito próximas, escolhido tile a tile, ainda parece uma
superfície única. A identidade da fase deve vir primeiro de **macroformas** —
faixas, ilhas, margens, depressões e relevos — e apenas depois da variação de
textura dentro de cada material.

## Escopo

- Preservar a grade lógica 40×40, projeção 2:1 e seed estável.
- Criar um modelo determinístico de `TerrainLayout` por chunk/material, sem
  consumir o RNG da batalha, para escolher categorias de solo e regiões.
- Implementar em Durao um piloto completo com quatro categorias: planalto de
  basalto, cascalho/cinza, encosta rochosa e margem/Rio Estige.
- Compor montanhas e penhascos pelas bordas e ilhas do mapa como módulos de
  arte y-sorted; suas áreas bloqueantes vêm da malha lógica, não da imagem.
- Representar o Estige por regiões contínuas de margem, água rasa e corrente,
  com direção visual de fluxo, metadados de força e efeitos mentais limitados
  à run atual.
- Implementar a travessia do Estige em Durao: teste de lucidez baseado em
  Inteligência e CAM, esquecimento temporário ao sair e o Chamado do Estige
  sob exposição prolongada.
- Oferecer no Navegador QA cenários determinísticos para margem, corrente,
  penhasco, telegráfo sobre solo claro/escuro e entrada de chefe próxima ao
  rio.
- Definir contratos reutilizáveis de terreno para os demais andares abissais,
  sem produzir nem integrar sua arte final nesta entrega.

## Não objetivos

- Mudar colisão básica, projeção, hitboxes, ondas, progressão ou duração das
  fases, salvo o controle temporário e delimitado pelo Chamado do Estige.
- Migrar para `TileMapLayer`, editor de mapas ou mapa manual pintado.
- Declarar que o Reaper do Estige, Molydeus ou qualquer outro inimigo entra
  nesta fase; a SPEC trata somente do terreno.
- Inserir narrativa, símbolos, facções ou fatos canônicos novos.
- Gerar ou substituir assets finais sem uma aprovação de arte posterior.
- Alterar permanentemente a Inteligência base, o CAM, a ficha persistente ou
  a progressão do herói.
- Estender o Estige a outro andar: no cânone local atual, Durao é o único
  andar confirmado com o Rio Estige.

## Contrato de composição

### 1. Piso e materiais

- Cada célula de atlas é uma textura **retangular, opaca, 64×32**, pois o
  losango é a geometria desenhada pelo `Ground`; nunca usar uma imagem já
  recortada em losango dentro desse retângulo.
- Cada material tem de seis a oito variações discretas; quatro variantes de
  cor quase idênticas não contam como variedade suficiente.
- A seleção combina `stage_id`, coordenada, seed visual e material, mas nunca
  o RNG de combate.
- Materiais aparecem em manchas de 6×6 a 12×12 células, com transições e
  detalhes em baixa frequência. Nenhum atlas isolado define o mapa inteiro.

### 2. Relevo e montanhas

- Montanhas são módulos de `base`, `parede`, `topo`, `pedra solta` e
  `espigão`, agrupados por silhueta; não são tiles de chão.
- O terreno bloqueante ocupa uma forma lógica simples. A arte pode exceder
  essa forma para criar altura, sombra e oclusão sem prender o jogador de modo
  invisível.
- Concentrar relevo nos 20–30% externos da arena e em poucas ilhas internas;
  deixar rotas amplas para kiting, elites, baús, portal e chefe.
- Decais de encosta — poeira, fissuras, correntes quebradas e cascalho — não
  têm colisão nem escondem telégrafos.

### 3. Rio Estige

- O rio é uma faixa de região contínua, nunca uma sequência aleatória de
  tiles. Ele tem margem seca, raso e corrente central visualmente distintos.
- A margem usa basalto, cinza e ferro oxidado; o raso recebe reflexos de azul
  de almas; a corrente central é quase preta, com trilhas de almas contidas e
  animação lenta na direção do fluxo.
- Apenas 6–12 segmentos de corrente recebem animação de fluxo; não animar cada
  tile de água.
- Zonas, projéteis, itens e telegráfos desenham acima da água com contraste
  suficiente. A corrente não pode ocultar uma área de dano.

## Política aprovada do Estige em Durao

- O raso e o leito central são atravessáveis, sem empurrão nem parede invisível.
- Ao entrar na região de água, e a cada segundo completo de exposição, o
  herói executa um **Teste de Lucidez**: `d20 + modificador de Inteligência +
  max(0, CAM - 10)` contra uma CD que aumenta com a exposição. A sequência de
  CDs começa em 11 e sobe em um por teste, até 16.
- Uma falha adiciona uma perda de lucidez de um ponto, válida somente na run.
  Ela reduz a Inteligência efetiva para testes e efeitos do Estige, nunca a
  Inteligência base da ficha, e tem piso em **1**, não em 0.
- Ao deixar a água após pelo menos dois segundos de contato, o herói recebe
  **Esquecimento do Estige** por `min(segundos completos de exposição, 6)`
  segundos. É uma condição de medo: o herói não pode se aproximar do rio e
  sua leitura visual deve mostrar claramente a duração.
- A exposição zera ao sair da água e recuperar o controle; perda de lucidez e
  condições temporárias expiram ao fim da run.

## Direção reutilizável por andar

| Andar | Macroformas de chão | Relevo e detalhes |
| --- | --- | --- |
| Shedaklah | Ilhas de fungo, lodo e pântano | Cogumelos baixos, raízes, poças viscosas; separar visualmente fungo de slime. |
| Molor | Cavernas de detrito, lixo e bolsões de slime | Paredes orgânicas, canos quebrados, parasitas; fungo é secundário. |
| Durao | Planaltos de basalto, cinza e Estige | Penhascos áridos, ferro oxidado, jaula como prop local. |
| Feng-tu | Lajes quebradas e névoa baixa | Ruínas locais e marcos de peregrinação; evitar estética oriental genérica. |
| Shendilavri | Pedra luxuosa degradada e jardins falsos | Muros, fontes ilusórias e luxo corrompido, sem sobrecarregar a arena. |
| Goranthis | Solo belo que se corrompe por regiões | Cachoeira/encostas e matéria orgânica apenas onde a corrupção avança. |
| Pilares | Fragmentos controlados dos materiais anteriores | Mesclar linguagens já aprovadas; não inventar uma nona identidade visual. |

## Plano de voo

1. Medir a repetição atual do `Ground` e registrar a composição de Durao em
   um piloto 40×40 com seed fixa.
2. Criar `TerrainLayout` mínimo com categorias de material, máscaras em chunks
   e consulta determinística; manter o fallback atual quando o layout faltar.
3. Desenhar os quatro materiais de Durao e as transições de baixa frequência,
   usando placeholders/decais reversíveis primeiro.
4. Criar kit de penhasco e aplicar somente a geometria lógica bloqueante
   aprovada, com y-sort e sombras testadas contra atores.
5. Compor o Estige em faixa, adicionar fluxo visual, empurrão regional e a
   política aprovada de lucidez, esquecimento e Chamado do Estige.
6. Adicionar cenários QA para margem, corrente, penhasco, telegráfo, item,
   portal, chefe próximo ao rio e cada limiar de exposição mental.
7. Capturar Durao em 1280×720, executar testes/smoke e comparar a execução
   com os critérios abaixo.
8. Só após a revisão do piloto, criar SPECs de arte e parametrização para os
   demais andares do Abismo.

## Critérios de aceite

1. Durao deixa de parecer preenchido por um único tile: planalto, cascalho,
   margem e rio são reconhecíveis sem texto de UI.
2. Não há costuras, losangos internos, lacunas ou padrões de grade evidentes
   no piloto 40×40.
3. Montanhas criam silhueta e limites claros, mas preservam uma rota ampla
   para combate e não bloqueiam o jogador por arte sem colisão lógica.
4. O Estige mostra margem, raso e corrente de forma inequívoca; o empurrão,
   cada Teste de Lucidez, o Esquecimento, o aviso aos sete segundos, o Chamado
   aos dez e a derrota aos doze são determinísticos e cobertos por teste.
5. Herói, inimigos, elite, item, portal e telegráfos continuam legíveis em
   1280×720 sobre todos os materiais e água.
6. A seed reproduz o mesmo layout visual; RNG, colisão base e resultado de
   batalha permanecem inalterados fora da regra ambiental aprovada do rio.
7. Testes, smoke, capturas, manifesto de assets e evidência ADD são
   reconciliados antes de concluir.

## Impactos previstos

- Consumidores: `ui/ground.gd`, cenas de fase, `ui/prop.gd`, renderização de
  zonas, `core/battle.gd`, Navegador QA e testes de terreno.
- Dados novos prováveis: definição de layout/material por fase, regra
  ambiental regional do Estige, exposição por herói e condição temporária de
  Esquecimento/Chamado.
- Assets futuros: atlas de materiais planos, bordas/margens, decais e kit de
  penhasco; cada lote terá candidato, origem, versão, inspeção e aprovação.

## Evidência esperada

- Seed, arquivo de layout e captura do piloto completo de Durao.
- Capturas para margem, corrente, penhasco, telegráfo, item, portal e chefe.
- Testes determinísticos de material/layout, empurrão regional do rio, Teste
  de Lucidez, piso de Inteligência efetiva, Esquecimento, aviso, Chamado e
  derrota por exposição prolongada.
- Manifesto com caminhos, versões, prompts/origens e consumidores de cada
  asset selecionado.

## Reconciliação da execução

- `core/terrain_layout.gd` entrega o piloto determinístico de Durao: planalto,
  cinza, encostas, margem, raso e corrente em uma faixa contínua. O fallback
  das demais fases foi preservado.
- `ui/ground.gd` compõe as macroformas sem atlas novo; a corrente central tem
  poucos traços animados e a água rasa recebe sinais estáticos de fluxo.
  `ui/terrain_features.gd` cria os penhascos como módulos no grupo y-sorted e
  a mesma malha bloqueia o herói, sem colisão baseada na imagem.
- `core/battle.gd` substitui o empurrão global de Durao por regra regional e
  aplica Teste de Lucidez com RNG própria, Esquecimento, aviso, Chamado e
  derrota nos limiares aprovados. Nenhum atributo persistente é mutado.
- O Navegador QA cobre margem, corrente, penhasco, telégrafo, item, portal,
  chefe e os quatro estados mentais do Estige. Os cenários existentes de
  outras fases permanecem disponíveis.
- Não houve produção de raster final nem nova dependência: o piloto usa
  desenho procedural reversível, conforme o não objetivo de arte final.
- Evidência: `EVID-048-spec-039-durao-estige-2026-09-27.md` e
  `SPEC-039-durao-piloto-2026-09-27.png`.
