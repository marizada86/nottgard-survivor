# SPEC-034 — Docas: prompts de terreno, introdução de chefe e Maré de Névoa

Status: aprovada para planejamento (2026-09-26). Execução visual requer a aprovação dos prompts finais.

## Intenção

Estabelecer o pacote de direção e prompts para as Docas, primeira etapa da progressão visual orientada pela cronologia de Nottgard, e definir a experiência visual da introdução de chefes e da pressão pós-chefe.

## Fontes e precedência

1. `D:\dev\nottgard\vault\04_Locais\Docas.md` e `03_NPCs\Willie.md`;
2. `.atena/vault/canon/PLAN-001-nottgard-survivors.md`;
3. cenas, dados e consumers atuais do jogo;
4. esta especificação para decisões de direção visual que não alterem o cânone.

## Escopo

- Terreno modular das Docas: chão, margens, docas, props portuários, props rituais e atmosfera;
- estética pixel art isométrica 2:1, fantasia gótica, legível em combate e com câmera fixa;
- prompts para sprites estáticos/móveis e para ilustrações 16:9 de introdução de chefe;
- sistema visual de introdução de chefe sem texto embutido na imagem;
- direção da Maré de Névoa após o chefe: aviso, avanço das bordas, contraste e escolha de extração/portal.

## Não objetivos

- alterar a ordem, o chefe, a narrativa ou os dados da fase existente;
- substituir o Sacerdote da Mente Derretida por Willie sem nova decisão aprovada;
- implementar a Maré de Névoa ou alterar CA/CAM nesta entrega de planejamento;
- usar névoa, gore ou pós-processamento que prejudiquem leitura de inimigos, projéteis, portal e telegráfos.

## Direção visual aprovada

- Docas como composição híbrida: porto comercial degradado, marcas de ritual e horror marítimo local, à noite;
- verde para influência ritualística/Ghaunadaur; azul-esverdeado salobro com reflexos violeta para ameaça marítima/Willie;
- gore físico plausível nos impactos; exagero reservado a críticos e magia de alto dano;
- sem texto, marca-d'água ou logotipo em arte gerada;
- referências traduzidas em atributos próprios: pixel art isométrica gótica, silhueta clara, volumes de fantasia sombria e alto contraste funcional.

## Contrato técnico de arte

- chão repetível sem objeto focal; bordas e props em PNG com alfa;
- sprites móveis primeiro em quatro direções, oito somente quando necessário à leitura;
- splash de chefe opaco em 640×360, ampliado 2× por nearest-neighbor para viewport 1280×720;
- nome, subtítulo, controles e telegráfos ficam na UI do jogo;
- toda candidata é inspecionada em escala real e dentro da fase antes de integração.

## Maré de Névoa — direção aprovada para futura implementação

1. Chefe derrotado: recompensa e escolhas permanecem sem dano por 8 s.
2. Aviso sonoro e visual antecede o primeiro avanço.
3. Névoa entra gradualmente das laterais; projéteis, inimigos, recompensas e portal permanecem distinguíveis.
4. Dentro da névoa, o dano inicial sugerido é 1% da vida máxima por segundo, escalando gradualmente até 3% após 20 s.
5. Extração preserva a recompensa; portal mantém a run e aumenta risco/recompensa.

## Decisão mecânica pendente

CA/CAM e esquiva serão reavaliados em spec própria. Esta spec não pressupõe que CA/CAM concedam imunidade à Maré de Névoa.

## Critérios de aceite para a futura execução visual

1. Cada família de terreno possui prompt, finalidade, formato, paleta e negativos claros.
2. As imagens das Docas expressam os fatos canônicos sem expor informação não estabelecida.
3. A introdução de chefe é reconhecível, dura pouco e volta ao combate com telegráfo legível.
4. A névoa pós-chefe preserva contraste e uma rota de decisão claramente visível.
5. Candidatas, seleção e validação ficam registradas no manifesto e nas evidências ADD.
