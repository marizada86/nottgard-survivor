# ASSET-LOT07/v01 — nove idles / 36 poses

DRAFT. Nove fontes autorizadas per-plan com "aprovado" em16/10/2026. Direção visual das nove revisões aceita em16/10/2026 com "aprovado, commite e continue". [Recibo](visual-acceptance.json). Retenção NE06 e pendências técnicas preservadas. Implementação com Claude; entrega local, sem mensagem a outro chat, admissão ou promoção canônica.

| Código | Fonte selecionada | Dimensão / células em4×1 | Base do contorno alfa≥128 | Margem mínima alfa≥16 |
|---|---|---|---:|---:|
| NE01 João | [v01](../animation-candidates/asset-lot07/NE01_v01.png) |1536×1024 /384×1024|0px|7px|
| NE02 desertor | [v02](../animation-candidates/asset-lot07/NE02_v02.png) |1536×1024 /384×1024|1px|18px|
| NE03 vítima | [v02](../animation-candidates/asset-lot07/NE03_v02.png) |1536×1024 /384×1024|0px|37px|
| NE04 Nyxara | [v01](../animation-candidates/asset-lot07/NE04_v01.png) |2172×724 /543×724|1px|23px|
| NE05 Vaelis | [v02](../animation-candidates/asset-lot07/NE05_v02.png) |1536×1024 /384×1024|0px|24px|
| NE06 Graz’zt **RETIDO** | [v03](../animation-candidates/asset-lot07/NE06_v03.png) |2172×724 /543×724|0px|0px|
| NE07 Reaper | [v02](../animation-candidates/asset-lot07/NE07_v02.png) |2169×725 /larguras542,542,542,543|0px|112px|
| NE08 Vhaerith | [v01](../animation-candidates/asset-lot07/NE08_v01.png) |2170×725 /larguras542,543,542,543|1px|9px|
| NE09 mercador | [v01](../animation-candidates/asset-lot07/NE09_v01.png) |2170×725 /larguras542,543,542,543|0px|48px|

Quatro poses em uma linha, leitura esquerda→direita. `frames/` são36recortes brutos, limites exatos em [inspection.json](inspection.json); fontes de largura não divisível por4 usam partição inteira pelos limites floor(i×largura/4). Não impor512px, não esticar células nem presumir que todas têm a mesma geometria. [Galeria](index.html), [manifesto](manifest.json), [prompts exatos](prompts.md), [referências](references.json), [checagem do player](player-check.json).

## Retenções e preparação

**NE06 retido por corte/contaminação da espada:** v01/v02 excedem colunas; v03 ainda tem170pixels alfa≥16 na faixa externa de4px das células. Limite de três tentativas atingido. Recortes podem conter trecho de lâmina da pose vizinha e perder a ponta; servem para diagnóstico, não admissão. Não declarar que é corrigível apenas com normalização se faltarem pixels. Verificar fonte integral e decidir reparo visual autorizado ou nova produção em outro escopo.

NE02/NE03/NE05/NE07 v02 removeram contato com grade; manter v01 somente como histórico. Nas outras oito selecionadas, zero pixels alfa≥16 nas faixas externas4px, porém só Reaper e mercador atingem margem-alvo48px. Vhaerith tem9px de folga, não corte medido. A estimativa visual inicial de contato no topo não foi confirmada pela medição. João também tem folga curta7px. Confirmar canvas/pivô antes de reduzir.

Modal do núcleo alfa≥128 do primeiro quadro253 em todas, não estritamente255. Há resíduos alfa baixo fora da silhueta; preparar sólidos/bordas preservando cabelo/tecido/detalhes. Fontes nativas não foram alteradas. Métrica de base0–1px indica estabilidade inferior do contorno, não invariância de corpo/rosto/mãos, nem aprovação de fluidez. Coordenada horizontal, escala e proporções do corpo precisam de revisão fina e registro contra os estáticos.

Conferir cajado/mãos/sandálias de João; capuz/ombreira do desertor; mão no peito e postura da vítima; espada/cabelo de Nyxara; trança/armadura/mãos vazias de Vaelis; anatomia/lâmina de Graz’zt; vara inteira/pegada/rosto oculto de Reaper; cabelo/orelhas de Vhaerith; mão/bolsa/ornamentos do mercador. Referência do NPC é autoridade de aparência DRAFT existente; não acrescentar lore/equipamento ou usar canon externo. Em Reaper preservar a pegada realmente desenhada, não inventar segunda mão segurando a vara por interpretação do texto.

Previews80/128px são derivados somente do primeiro quadro, bbox alfa≥16, proporção preservada e redimensionamento nearest; não são novas fontes ou tamanho runtime definitivo. NE06 nessas prévias permanece diagnóstico contaminado. Player usa células retangulares com object-fit contain; oito fontes e uma retenção visualmente explícita.9players/36PNG e controles testados em DOM offline, não render de navegador.

Consumidores/destinos de idles dos NPCs/eventos devem ser confirmados na frente de Claude; não substituir os estáticos automaticamente, nem converter idles em caminhada/ataque de aliados. Confirmar registro, tamanho final, duração e importação antes da admissão. Sem alteração de mecânica/quest/recompensa.8FPS padrão e opções2/4/8/10/12 são de inspeção. Aceite visual das fontes registrado; animação em jogo pendente; nenhum playtest ou alegação de diversão. Commit local autorizado em16/10/2026; push/exportação não autorizados.
