# ASSET-LOT17/v01 — proposta de correção da corrida SW de Durvall

DRAFT, origin planned, implementation_preceded_spec false. PLAN_CHANGE_REQUEST: trocar a folha3×2 deP9 por seis fontes individuais para resolver empunhadura e direção simultaneamente. Pedido “atena, aprovado, continue” aceita visualmente LOT16; não inventar que esse aceite libera a retenção deP9 ou autoriza ultrapassar suas3tentativas. Esta é proposta concreta, produçãoPENDING_SCOPE_APPROVAL. Modo per-plan já escolhido na frente de produção, preservado; checkpoints do marcoM1 continuam independentes.

## Motivo e impacto

[LOT16](../../generated/asset-lot16-2026-10-17/index.html) encerrou13chamadas: P9v01/v03 ficam orientadas para a direita; v02 atendeSW mas aparenta trocar espada para a mão direita. As3tentativas por folha foram esgotadas. [Aceite exato das cinco revisões](../../generated/asset-lot16-2026-10-17/visual-acceptance.json) é direção visualDRAFT com retenções. Nova proposta não é quarta tentativa oculta da mesma folha: muda o método, gera6arquivos e precisa de aprovação específica do escopo/orçamento.

Proposta: SW00..SW05v01, um PNG por pose, seis desenhos no total. Teto18chamadas, máximo3por arquivo; uso de orçamento só após aprovação. As5fontesLOT16 e13tentativas são preservadas, nenhuma substituição automática. Sem produzir outros heróis, direções ou estados. Implementação permanece com Claude. Preferível resolver o conflito deP9 antes de ampliar o método aos outros heróis doL1.

## Bíblia/identidade/cena DRAFT v01

Identidade aplicável: Durvall Gellad, drow cinza-azulado, cabelo branco longo solto, orelhas pontudas avermelhadas, armadura negra laminada com ombreiras deespinhos, faixa vinho, botas escuras, pendente azul existente no peito, espada azul-gelo na MÃO ANATÔMICA ESQUERDA. [Ficha G-D1](../../vault/drafts/FICHAS-DE-IDENTIDADE-herois-m1-2026-10-14.md), [canon002](../../vault/canon/ASSET-APPROVAL-REGISTER-002-durvall-brook-2026-09-27.md) e idle local são autoridade de identidade. Não usar a folhaP9defeituosa como autoridade de mão. Referências já vistas na retomadaLOT16; reconferir hash antes de gerar. [Snapshots da proposta](../../generated/asset-lot17-proposal-2026-10-17/references.json).

Sudoeste é caminhada diagonal PARA BAIXO E ESQUERDA, três-quartos FRONTAL, nariz/peito/pontas das botas orientados àesquerda. O braço da espada deve ser rastreável ao ombro anatômico esquerdo, próximo do lado direito da imagem nesta vista frontal: mão no centro/direita do tronco e lâmina cruzando baixa para a esquerda, sem trocar braço só para acompanhar a direção. Outra mão vazia. Não fazer espelho de corridaE/SE. Se a anatomia da referência0 não for clara, corrigir antes de ancorar as demais; não declarar sucesso com base na ponta da espada apenas.

Cena textual: deslocamento nos mapas existentes, sem cenário no PNG. Pixel pintado detalhado, câmera elevada isométrica/três-quartos, luz superior esquerda sobre superfícies, mesmas proporções/roupa/acessórios. Nada de lore nova, colar ou símbolo novo, aura independente, chão, sombra projetada ou texto. Fora do contorno alfa real; borda luminosa da lâmina contida.

Solicitar1024quadrado por fonte, corpo aproximadamente660px com apoio em840px, margem livre≥64px e espada inteira, preservando escala e registro da primeira candidata válida. É a mesma escala relativa330/512 do piloto, não mudança do porte em runtime. Dimensão nativa pode divergir e deve ser medida. Prévia mantém canvas integral sem normalização escondida; nenhuma transformação para fabricar pose. Primeiro SW00 ancora identidade/câmera/registro dos demais, mas permaneceDRAFT para aceite conjunto antes de integração.

Fases: SW00contato com perna direita àfrente; SW01passagem/recuo; SW02passagem alta; SW03contato oposto com pernas trocadas; SW04passagem oposta; SW05alta/retorno. Balanço contido de braços/cabelo/faixa, mesma mão da espada e câmera nas6poses. Duas poses decontato devem ser realmente diferentes; não animar só roupa ou deslizar sem passo.

## Etapas, checks e recuperação

1. S-001 proposta/prontidão: diagnóstico, inputs, identidade/cena, escopo e orçamento. BLOCKING único: aprovação desta mudança de método e6fontes/18chamadas máximas. Escolha de nível per-plan já registrada; não repetir entrevista.
2. S-002 gerar6PNGs via built-in imagegen, um por chamada, salvar nativas e cópias versionadas em `.atena/generated/art-candidates/asset-lot17/`, prompts e referências por chamada. Corrigir mão/facing/espada/pose objetivamente, até3tentativas por arquivo; reter quando não convergir. Nenhuma CLI, dependência ou edição de pixels por script.
3. S-003 QA: rastrear braço esquerdo em todas6poses, facingSW, arma inteira, identidade, alternância0/3, intermediários/retorno, alfa/margem/banda4px, escala/registro e leitura48/80/128. Bbox é proxy, não prova anatomia ou fluidez. Clones de QA/contatos integrais permitidos, sem normalização que esconda deriva. Não prometer ausência de patinar.
4. S-004 galeria conjunta em `.atena/generated/asset-lot17-2026-10-17/`, playerloop6 com5/10FPS, pausa/replay/repeat/scrub, manifesto/origens/prompts/hashes/evidência e handoff localClaude. Verificar controles offline e links, sem confundir com render/playtest. Parar no aceite humano dos seis arquivos por revisão/hash.

RESOLVABLE após aprovação: consistência da mão/direção, escala, alfa e registro; DEFERRED: packing/célula512, preparação de importação, laboratório e código, runtime e playtest. Aprovar esta proposta autoriza produçãoDRAFT, não CANON/admissão/commit/push/export/mensagem externa. P9continua retida até uma substituição ser verificada e explicitamente admitida em escopo posterior. Rejeição parcial não descarta fontes anteriores. PLAN103 e outros lotes preservados.

Aprovação explícita2026-10-17: dono respondeu “aprovado, continue” à proposta6PNGs/18chamadas/per-plan. Escopo e método autorizados antes da primeira geração; supera PENDING_SCOPE_APPROVAL histórico acima. S-001 concluída, S-002 executável. Não é aceite visual das fontes novas ou autorização de integração.

Resultado2026-10-17:4/4etapas deprodução/revisão local,6selecionadas em13chamadas, SW04v03 e demaisv02. Todas1254square, margem mínima123px e zero banda4px. Observação do modelo favorece braço esquerdo/facingSW e contatos alternados, mas registro/escala/cadência e alfa permanecem pendentes; SW04chega a3tentativas. [Galeria](../../generated/asset-lot17-2026-10-17/index.html), [manifesto](../../generated/asset-lot17-2026-10-17/manifest.json), [evidência](../../evidence/asset-lot17-durvall-sw-source-repair-2026-10-17.md). Checkpoint OWNER_JOINT_VISUAL_REVIEW/PENDING. P9antiga não foi liberada, fontes novasDRAFT sem integração/CANON.

Aceite posterior2026-10-17: “aprovado, commite” aceita direção visual das seisrevisões e autoriza commit local. [Recibo exato](../../generated/asset-lot17-2026-10-17/visual-acceptance.json). Supera PENDING visual acima, preservandoDRAFT, todasretenções eP9histórica. [Spec decommit local](asset-lot15-17-local-commit-v01.md); sem push ou implementação.
