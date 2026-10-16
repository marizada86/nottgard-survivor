# ASSET-LOT05/v01 — seis quebráveis, 30 poses

DRAFT. Origin planned; implementation_preceded_spec false. Continuação solicitada em 2026-10-16: "atena, vamos prosseguir". LOT03/LOT04 aceitos e commitados em cef5c0e5. Classificação PLAN_CHANGE_REQUEST da frente de produção: seis objetos explicitamente reservados para lote posterior no LOT04, sem extensão automática da aprovação anterior. PLAN-103 e checkpoints de outras frentes preservados. Modo per-plan já escolhido pelo dono nesta frente; novo escopo aprovado explicitamente com "aprovado, por plano" antes da geração em 2026-10-16.

## Contrato e referências

Seis folhas DRAFT de cinco poses (30 quadros), uma por objeto; uma galeria conjunta com reprodutores e aceite por código/revisão. Autoridade: [PLAN-041](../../vault/drafts/PLAN-041-animacao-padrao-zumbi-para-inimigos-e-interacoes-2026-09-29.md), perfil D; ART-022; [SPEC-063](../SPEC-063-objetos-quebraveis-e-rebalanceamento-de-pocao.md), [ART-PROMPTS-024](../../generated/ART-PROMPTS-024-cenario-e-quebraveis-por-bioma.md). Não repetir a contagem histórica de dez quebráveis como inventário atual: carroça e carga também existem nos dados atuais.

| Código | Referência estática readonly | Contexto |
|---|---|---|
| QB07 | assets/enemies/carroca_quebravel.png | Dagruve, carroça já avariada |
| QB08 | assets/enemies/pilha_carga_quebravel.png | Docas, carga empilhada |
| QB09 | assets/enemies/lanterna_de_papel_quebravel.png | Feng-tu, lanterna em poste |
| QB10 | assets/enemies/espelho_ilusorio_quebravel.png | Shendilavri, espelho vinho/prata |
| QB11 | assets/enemies/estatua_rachada_quebravel.png | Goranthis, escultura de mármore |
| QB12 | assets/enemies/relicario_instavel_quebravel.png | Pilares, relicário violeta flutuante |

Seis PNGs inspecionados visualmente, hashes e flags inerte/quebravel capturados em [snapshot](../../generated/asset-lot05-2026-10-16/references.json). Não existem death.png nos seis destinos esperados assets/animations/enemies/<id>/death.png; busca por IDs em generated/ e assets/animations não encontrou sequências anteriores. Reconfirmar antes de produzir caso outra frente avance. `ui/enemy_view.gd` e dados são contexto de integração, sem edição neste plano.

## Bíblia e identidade — DRAFT v01

Objetos são as entidades relevantes, portanto identidade é aplicável. Contexto textual: quebráveis isolados no mapa, imóveis até golpe, produção exclusiva dos desenhos de ruptura; sem alteração de dano, loot, colisão ou duração. Referências estáticas atuais prevalecem sobre descrições antigas de placeholders/fundos cromáticos. Preservar câmera isométrica, luz superior esquerda, pixel art densa e paleta/material existentes; transparência nativa, sólidos opacos, exterior sem cenário/sombra de chão. Primeiro quadro reproduz estado atual do objeto, mesmo já avariado; não restaurar objeto novo. Último quadro são restos assentados, sem desaparecimento mágico.

- QB07: carroça de madeira escura já danificada, roda raiada grande à esquerda, tábuas laterais inclinadas, eixo/varais, cordas e sacos. O golpe amplia a quebra; roda/estrutura cedem e tábuas caem ao redor dos sacos, terminando em destroços reconhecíveis. Não adicionar cavalo, condutor, carroça intacta ou loot. Evitar espalhamento que exceda a célula.
- QB08: caixas escuras com ferragens, barris laterais, sacos claros, rolo verde e lona oliva rasgada presa por cordas. A pilha perde sustentação, caixas racham e materiais caem/assentam com continuidade; não fazer todos os recipientes desaparecerem nem inventar o conteúdo dos barris. Lona/corda continuam materiais físicos, sem fumaça.
- QB09: lanterna vermelha de papel nervurado, argola/pingente e poste escuro em L com amarras vermelhas. Papel rasga, suporte cede e lanterna cai com fragmentos do poste; terminar com papel/armação/madeira assentados. Sem fogo/explosão adicionados, inscrições, fantasma ou mudança para outro modelo de lanterna.
- QB10: espelho oval alto, moldura prateada com cristais vinho, pés curvos e reflexo cinza-vinho com silhueta de castelo já existente. Vidro fissura, moldura cede e os fragmentos caem; reflexo desaparece por fragmentação física do vidro, não por portal. Não criar figura refletida, demônio, ambiente novo ou efeito de teleporte. Preservar cristais e pés ao longo da ruptura.
- QB11: figura feminina esculpida em mármore marfim, drapeado clássico, ornamentos dourados, pedestal e grande fissura vertical avermelhada preexistente. Identidade é de escultura inerte: mesma face/cabelo/roupa/pose até quebra, sem animar como personagem vivo. Fissura se amplia, blocos de mármore caem e assentam com partes reconhecíveis do pedestal; sem sangue, anatomia orgânica ou gore, sem novo símbolo.
- QB12: relicário suspenso de pedra violeta-negra, pilares/aros dourados, telhado piramidal e pontas superior/inferior, runa rosa-violeta e arcos de energia existentes. Estrutura fissura e perde sustentação, fragmentos descem, terminando assentados e com brilho reduzido. Não inventar runa, entidade, recompensa ou explosão. Manter a identidade da runa existente, sem texto legível novo; energia sutil dentro da célula.

Sem lacunas BLOCKING de identidade/contexto para ensaio DRAFT. Aprovação de escopo recebida. Checkpoint atual: revisão visual conjunta das seis sequências. RESOLVABLE: enquadramento/grade, número de poses, alfa, margens, continuidade e base. DEFERRED: preparação final, pivôs/escala, redução, temporização, admissão por Claude e playtest humano.

## Etapas, recuperação e aceite

1. S-001 — inventário, inspeção das referências, bíblia e proposta: concluído. Saída seis identidades e snapshot com hashes. Escopo aprovado; produção e entrega técnica concluídas, revisão visual pendente.
2. S-002 — gerar seis fontes, uma chamada imagegen por sequência, cinco poses intacto→impacto/fissura→ruptura→queda→restos. Até três tentativas por objeto para defeitos objetivos, sem pedir aprovação por imagem. Alvo 1536×1024, grade invisível3×2, cinco células512×512 e sexta vazia. Aprendizado LOT04: pedir silhuetas menores, altura/largura aproximada320–360px, base localy420 e corredores de pelo menos48px; medir resultado real, sem prometer dimensões ou margem exatas. Preservar todas as tentativas em .atena/generated/animation-candidates/asset-lot05/.
3. S-003 — QA e contatos: medir dimensões/grade real, contar cinco poses, margens/bordas, alfa do corpo e resíduos, sexta célula, base e continuidade. Extrair células nativas sem correção oculta. Corrigir contatos com bordas dentro das tentativas; se persistirem, reter a peça e explicar. Não atribuir PASS de admissão a material translúcido ou base não preparada. Hash distinto não prova movimento correto.
4. S-004 — galeria conjunta, seis reprodutores com hold final, pausa/reinício/scrub/FPS/repetição opcional, manifesto/prompts/medidas/evidência/entrega local para Claude. Validar caminhos/hashes e lógica de controles; distinguir simulação DOM de render de navegador. Apresentar seis sequências para uma revisão conjunta, aceitação parcial permitida por código/revisão. Parar nesse gate visual.

Recuperação por fontes versionadas e retenção seletiva, sem tocar em originais. Ferramentas de QA LOT04 reutilizáveis em caminhos novos, sem modificar entregas aceitas. Candidatas com pendências de alfa/pivô/escala podem ser avaliadas como direção DRAFT, com limitações explícitas, sem equivaler à admissão. Nenhum playtest nesta produção, nem alegação de diversão/fluidez em jogo.

Fora do escopo: assets oficiais, código/dados, cânone/lore, novas dependências, commit, push, merge, publicação/exportação ou mensagem a Claude. Implementação permanece com Claude, conforme instrução persistente do dono. Arte estática de carroça quebrável não se confunde com o evento Carroça Abandonada da FILA-028.

Resultado 2026-10-16: S-001..S-004 concluídas; seis fontes selecionadas e30células de QA, oito tentativas preservadas. QB08/QB12 v02 corrigem enquadramento. Medidas e limitações em [evidência](../../evidence/asset-lot05-breakables-2026-10-16.md). Nenhuma admissão ou promoção canônica; pausa no checkpoint visual conjunto.
