# FILA030-GENERATION/v01

Estado: DRAFT. Origem: planned; implementation_preceded_spec: false.
Pedido: continuar produção da fila de arte; dono escolheu a opção 2 (FILA-030), em 2026-10-15.
Classificação: PLAN_DEVIATION, rota DO_NOW_AND_RETURN ao PLAN-103.

## Contrato e autoridade visual

Autoridade específica: [ART-PROMPTS-063 r1](../../generated/ART-PROMPTS-063-nevoa-de-borda-e-frente-da-mare.md).
Fila: [CHATGPT-FILA-030](../../generated/CHATGPT-FILA-030-nevoa-de-borda-e-frente-da-mare.md), cujo cabeçalho registra geração aprovada e zero peças geradas.
Contexto: [SPEC-158](../SPEC-158-nevoa-de-borda-e-de-fim-de-fase.md) e [SPEC-034](../SPEC-034-docas-prompts-introducao-chefes-e-mare-de-nevoa.md).
Convenção de luminância: [ART-PROMPTS-025](../../generated/ART-PROMPTS-025-lote-1-nevoa-bau-de-chefe-imas-e-npcs.md).
Intenção canônica preservada: fantasia gótica isométrica e combate legível; nenhuma alteração de lore, mecânica ou cânone.

Mini bíblia aplicável DRAFT r1: névoa em pixel art, dither controlado e densidade em degraus; branco/cinza sobre preto puro; alto vazio e base densa; sem cenário, texto, objetos ou criaturas. NB01 é uma faixa rasteira da borda do mundo, sem coluna alta nem foco dominante, repetível horizontalmente. NB02 é uma única frente conectada da Maré, com crista legível e pontas que somem. Tonalidade e movimento pertencem ao jogo. Identidade de personagem/entidade: N/A, são texturas ambientais sem entidade. Cena: sobreposição nas bordas do mapa ou avanço pós-chefe; leitura de inimigos, projéteis e portal deve ser preservada. Referências textuais locais, sem anexos nem novas fontes externas. Novas fontes e derivadas permanecem DRAFT até decisão explícita.

## Escopo executável após seleção do modo

Uma chamada imagegen por peça, com os prompts de ART-PROMPTS-063 r1. Salvar fontes versionadas em `.atena/generated/art-candidates/nevoa-mundo/`; nunca sobrescrever candidatas. Até três tentativas por peça, cada repetição vinculada a defeito objetivo. Preservar o PNG original. Produzir inspeção visual e evidência local; preparação definitiva, alfa por luminância e admissão dependem da escolha visual do dono conforme o contrato existente.

NB01: formato final pretendido 1536×384; conferir repetição horizontal 3×1 e leitura a 1/4 da escala. NB02: formato final pretendido 1280×360; conferir contorno a 80 e 360 px de profundidade. Registrar dimensões nativas e divergências, sem declarar dimensões pretendidas como dimensões produzidas. Avaliação em jogo fica pendente para futura admissão/playtest humano.

## Etapas e lotes estáveis

1. S-001: conferir entradas, prontidão visual, escopo e retorno. Concluída por leitura local; nenhuma candidata existente encontrada.
2. S-002 / B-001: gerar, salvar e inspecionar NB01; saída candidata e evidência; gate de modo antes da execução.
3. S-003 / B-002: gerar, salvar e inspecionar NB02; saída candidata e evidência.
4. S-004 / B-003: apresentar as duas, validar links/arquivos e registrar checkpoint de seleção visual do dono; preparar objetivo seguinte de admissão sem executá-lo.

Se per-plan: S-002 a S-004 autorizadas em conjunto. Se per-batch: pedir aprovação de cada próximo lote após o primeiro autorizado. Se per-step: pausar antes de cada próxima etapa. Aceite visual permanece gate separado em todos os modos.

Modo selecionado: per-plan, resposta do dono "por plano", em 2026-10-15; execução S-002 a S-004 autorizada.
BLOCKING: nenhuma lacuna visual ou de modo. Aceite visual do dono é checkpoint posterior à apresentação.
RESOLVABLE: proporção nativa do gerador e eventual costura, verificadas na inspeção.
DEFERRED: alfa/preparação definitiva, admissão, código e playtest humano.

## Limites, recuperação e retorno

Sem integração em assets, mudanças de código, novas dependências, promoção canônica, commit, push, exportação ou publicação. Recuperação: descartar/reter apenas novas candidatas e evidência versionadas, preservando os assets existentes.
Retorno preservado: PLAN-103 B-004/R3_PROPOSAL_AWAITING_G-M3-3 (estado específico); B-002/S-008 aguarda P6–P10 do dono; B-003 aguarda revisão visual. O resumo central ainda aponta B-002/S-008; divergência registrada sem reescrever checkpoints de outras frentes.
Backlog no início desta retomada: 0 P0, 4 P1 sem implementação, 18 P1 aguardando playtest, 0 alertas de organização. RTK já decidido enabled em add.yaml.
