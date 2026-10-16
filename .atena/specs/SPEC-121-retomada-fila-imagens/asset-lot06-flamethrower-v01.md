# ASSET-LOT06/v01 — ART-004, ícone e jato de chamas

DRAFT. origin planned; implementation_preceded_spec false. Pedido 2026-10-16: "aprovado, pode seguir para os proximos". Aceite visual LOT05 registrado separadamente, sem autorização nova de commit. Classificação PLAN_CHANGE_REQUEST para novo escopo após LOT05; modo per-plan preservado, aprovação específica deste conteúdo pendente. PLAN-103, heróis M1 e frentes de integração preservados.

## Inventário e motivo da seleção

[CHATGPT-FILA-012](../../generated/CHATGPT-FILA-012-ui-e-vfx-pendentes.md), U05/U06, e [ART-PROMPTS-043](../../generated/ART-PROMPTS-043-ui-e-vfx-pendentes.md), ART-004. U01..U04 já têm fontes aceitas LOT02, U07..U09 geradas/integradas; não duplicar. LOT03..LOT05 cobrem a produção recente das interações/quebráveis selecionados. Registros mais recentes do PLAN-053 recuperam FILA02236/36 e FILA02360/60, portanto contagens históricas de VFX faltantes não justificam regeneração. Busca pelos nomes lanca_chamas/lancachamas/jato_de_chamas/flamethrower em assets/ e generated/ não encontrou imagens existentes; reconfirmar antes da geração. Busca nominal não prova inexistência de todo arquivo renomeado.

ART-004 continua aberto e MEC-004 (consumível temporário) ainda não implementado em [backlog](../../backlog/MECANICAS.md). LOT02 o excluiu por isso. Este novo plano propõe conscientemente somente ensaio visual DRAFT antecipado a partir dos prompts existentes; não decide mecânica, duração, dano, divindade ou admissão. Aprovação do LOT06 autoriza essa antecipação, sem mudar a condição de MEC-004.

## Escopo e bíblia — DRAFT v01

Duas fontes, cinco desenhos totais, uma galeria conjunta:

| Código | Origem | Saída |
|---|---|---|
| FC01 | U05 item_lanca_chamas_icone | Um ícone quadrado, objeto completo em diagonal |
| FC02 | U06 vfx_jato_de_chamas | Folha2×2 de quatro quadros em loop apontando à direita |

Identidade FC01: equipamento genérico de cultista descrito no prompt histórico, tubo de metal escuro, reservatório de óleo, correias de couro, bico com pequena chama âmbar/laranja. Sem mãos, personagem, nome próprio, texto ou símbolo divino. Não acrescentar mecanismo/lore. Referência de estilo inspecionada: assets/icons/items/adaga.png; usar apenas linguagem de metal/pixel art, sem transformar o lança-chamas em adaga.

Identidade de personagem/entidade FC02: N/A, efeito isolado sem ator. Contexto textual: jato emitido pelo bico do equipamento, visão de cima/lateral plana funcional, direção direita fixa; não representar inimigo, arma, chão ou cenário na folha. Núcleo amarelo claro, miolo laranja, bordas vermelho-escuras, brasas contidas; sem atribuição a uma deidade, como ART-PROMPTS-043 já recomenda. Luz pode ter alfa variável; não impor corpo alfa255 ao brilho de um VFX.

Sequência FC02 conforme U06: chama fina e brilhante → língua longa/faíscas → jato largo com redemoinho → pontas se desfazendo em brasas e retorno ao primeiro. Mesmo comprimento máximo e mesma origem, sem passear câmera ou bico. FC01 objeto inteiro com margens de segurança. FC02 origem no meio da borda esquerda de cada célula, conforme contrato original: contato nessa borda é intencional, não confundir com corte acidental da ponta ou contato nas demais bordas. Não alterar o pivô para o centro silenciosamente. Registrar limites/folgas reais e conferir se um quadro contamina o vizinho.

Adaptação proposta explícita aos prompts: transparência nativa em vez do fundo magenta antigo para ambos, preservando chamas e falloff; sem chaveamento posterior oculto. Alvos nativos não garantidos: FC01 quadrado1024; FC02 quadrado1024, células512, grade2×2 invisível. Aprovando este escopo, dono aceita essa adaptação de produção DRAFT, sem alteração de cânone. Pixel art sombria compatível com os ícones existentes; nenhum render fotorrealista.

BLOCKING de decisão de entrada: aprovação deste escopo com antecipação visual e transparência nativa. Nenhuma lacuna textual restante para o ensaio após aprovação. RESOLVABLE: enquadramento, grade, quatro fases distintas, comprimento, origem, alfa, loop e leitura reduzida. DEFERRED: associação divina, design/admissão MEC-004, duração/dano/alcance/colisão, pivô final, redução e implementação por Claude. Esses itens impedem tratar o ensaio como produto integrado, sem impedir produção DRAFT autorizada.

## Etapas e checkpoints

1. S-001 inventário, âncora visual e proposta: concluído. Snapshot/hash da referência antes de produzir; nenhuma geração iniciada. Próximo objetivo FC01/FC02, depende de aprovação do novo plano.
2. S-002 produção: uma chamada imagegen FC01, uma FC02, até três tentativas por fonte para defeitos objetivos; guardar PNGs nativos versionados em .atena/generated/art-candidates/asset-lot06/. Usar FC01 como apoio de paleta para FC02 se necessário, sem inserir o objeto na folha. Preservar fontes/referência.
3. S-003 QA: conferir objeto completo/identidade, geometria real, quatro fases de chama, origem esquerda, pontas contidas, alfa nativo, resíduos/células e retorno do loop. Contatos e recortes de QA sem transformação oculta; registrar medidas e falhas, sem PASS de runtime. Não confundir hashes distintos com qualidade do loop. Prévia reduzida de ícone32/48/64px e efeito para revisão, deixando clara a diferença entre legibilidade examinada e aceite humano.
4. S-004 entrega: galeria conjunta do ícone e quatro quadros com player/controles, manifesto/prompts/hashes, evidência e entrega local para Claude. Validar links, fontes e controles; separar DOM offline de render de navegador. Parar na revisão visual do dono, aceite parcial FC01/FC02 permitido. Implementação permanece com Claude em sua frente, sem envio de mensagem a outro chat.

Conteúdo DRAFT, sem promoção canônica. Sem assets oficiais/código/dados, instalação/dependências, implementação MEC-004, commit/push/merge/publicação/exportação. Recuperação por revisões preservadas e retenção seletiva. Sem playtest nem alegação de diversão. Lote tem duas fontes porque são as duas entradas comprovadamente pendentes desta família; não completar seis com variantes sem necessidade.

Proposta v01 substituída ANTES da geração pelo [escopo ampliado v02](asset-lot06-expanded-v02.md), aprovado explicitamente pelo dono em 2026-10-16. Usar o estado v02 para continuidade.
