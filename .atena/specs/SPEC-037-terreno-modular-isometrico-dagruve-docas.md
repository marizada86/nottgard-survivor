# SPEC-037 — Terreno modular isométrico: Dagruve e Docas

Status: **implementada e verificada** (2026-09-27).

## Intenção

Substituir o uso de uma imagem inteira repetida por fase por terreno modular
isométrico, compatível com a simulação plana atual. O objetivo é dar identidade
visual distinta a Dagruve e Docas sem tornar o chão ruído visual, acoplar
colisão à arte ou exigir mapas grandes pintados à mão.

## Fontes e precedência

1. `.atena/vault/canon/PLAN-001-nottgard-survivors.md`, seções 10 e 20;
2. `SPEC-036-dagruve-docas-e-cenarios-qa.md`;
3. `ui/ground.gd`, `ui/prop.gd`, `ui/stages/dagruve.tscn` e
   `ui/stages/docas.tscn`;
4. os fatos canônicos de Dagruve e Docas no vault local;
5. esta SPEC para decisões de composição e implementação visual que não
   alterem a lore.

## Escopo

- Manter o plano lógico atual de 40×40 e a projeção isométrica 2:1.
- Evoluir `ui/ground.gd` para ler um atlas de losangos de 64×32 px e escolher
  a variação de modo determinístico por coordenada e seed visual.
- Produzir primeiro um piloto de grade 8×8, usando quatro a seis variações de
  piso por fase; só então escalar para a fase completa.
- Criar camadas visuais não bloqueantes para detalhes de terreno e manter os
  props bloqueantes como nós independentes.
- Definir contratos de arte e leitura para Dagruve e Docas.
- Capturar e avaliar o piloto em viewport 1280×720 antes da integração final.

## Não objetivos

- Trocar o sistema de colisão, o plano de simulação ou a projeção isométrica.
- Migrar para `TileMapLayer`/navegação, criar um editor de mapas ou gerar um
  mapa-pintura inteiro.
- Criar ou aprovar assets finais nesta entrega de especificação.
- Inserir símbolos, narrativa, facções ou fatos canônicos não estabelecidos.
- Alterar telegráfos, eventos, chefes ou a regra de progresso das fases.

## Contrato de terreno

### Piso base

- Cada atlas contém de 4 a 6 losangos opacos de 64×32 px, sem margem de
  apresentação, texto ou objeto alto.
- Todas as variações devem encaixar nas quatro bordas e repetir sem emenda
  visível em uma grade 8×8.
- A escolha de variante é puramente visual: usa coordenada, ID da fase e seed
  estável; nunca usa o RNG de combate.
- Uma variante de baixa frequência pode carregar detalhe leve, mas nenhuma
  deve virar ponto focal ou esconder inimigo, projétil ou item.

### Detalhes e limites

- Decais baixos — manchas, fissuras, poças rasas, musgo, ferrugem e marcas
  rituais abstratas — ficam em camada decorativa sem colisão.
- Margens, água, estacas, caixas, estantes e elementos altos são props; apenas
  os props com bloqueio participam da lista de colisores.
- Telegráfos e zonas de perigo ficam acima de chão e decais, com contraste
  preservado em qualquer variante do atlas.

## Direção por fase

### Dagruve

Calçamento urbano escuro e irregular, pedra rachada, desgaste de bairro pobre,
névoa em tons violeta-esverdeados e marcas rituais raras. O foco é o distrito,
não um cais: madeira, redes, água e margens marítimas não dominam a composição.

### Docas

Pedra úmida e tábuas gastas, juntas salgadas, água marítima quase preta e
ferrugem discreta. Margens e estruturas de cais entram como props modulares,
com luz fria e poucos pontos âmbar. Livros e sinais do porão aparecem em áreas
locais, sem transformar todo o piso em cenário ritual.

## Plano de voo

1. Inventariar a forma e a resolução dos pisos existentes, com backup antes de
   qualquer substituição de asset.
2. Formalizar o formato do atlas e implementar a leitura de variantes no
   `Ground`, preservando o fallback atual por cor quando o atlas estiver ausente.
3. Montar uma cena piloto isolada de 8×8 para Dagruve e outra para Docas,
   utilizando somente candidatos ou placeholders reversíveis.
4. Avaliar repetição, contraste, custo de desenho e leitura de um telegráfo,
   elite, projétil, item e portal.
5. Corrigir o atlas ou a regra de seleção no máximo três vezes por problema
   objetivo; não gerar arte adicional sem revisão humana.
6. Aplicar os atlas aprovados às duas cenas, mantendo decais e props em
   camadas próprias.
7. Executar testes, smoke, capturas e reconciliação do manifesto/evidência.

## Resultado da execução

- `ui/ground.gd` agora entende atlas modular 64×32, limita com segurança o
  número de variantes à imagem real e escolhe a variação por fase, coordenada
  e seed visual. Nenhuma chamada ao RNG da batalha foi adicionada.
- Os atlas finais `dagruve_ground_atlas_v3.png` e
  `docas_ground_atlas_v3.png` têm 128×64 px (quatro variantes 64×32), são
  opacos e foram vinculados apenas às duas cenas novas, preservando
  `dagruve_ground.png`.
- `tools/terrain_pilot.tscn` materializa duas grades 8×8 usando os atlas
  finais; as capturas de viewport 1280×720 validam distinção e leitura.
- As pranchas geradas continuam em `.atena/generated/art-candidates/terrain/`
  como referência de direção; as versões v1 e v2 foram rejeitadas por
  composição incompatível com a projeção de chão.

## Critérios de aceite

1. A grade piloto 8×8 não apresenta costuras, bordas de apresentação ou padrão
   repetitivo evidente.
2. Dagruve e Docas são reconhecíveis uma da outra apenas por piso, decais e
   props, sem depender de texto na tela.
3. Inimigos, itens, projéteis, telegráfos e portal continuam legíveis em
   1280×720.
4. A escolha de variante é reproduzível e não altera RNG, combate, colisão ou
   resultado da run.
5. O fallback por cor mantém uma fase jogável se um atlas não for encontrado.
6. A suíte de testes e o smoke passam; capturas vinculam os atlas selecionados
   ao resultado do piloto.

## Evidência e reconciliação

- Manifesto: caminho, versão, prompt e origem de cada atlas ou decal.
- Capturas: Dagruve e Docas em grade 8×8, combate, telegráfo e portal.
- Medição: custo de desenho ou observação de frame-time no piloto.
- Reconciliação: consumidores de `ground.gd`, cenas de fase, manifesto de arte
  e `SPEC-036` revisados antes de concluir.

Evidência técnica: `../evidence/EVID-046-terreno-modular-piloto-2026-09-27.md`.
