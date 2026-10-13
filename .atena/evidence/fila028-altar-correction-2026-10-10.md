# AL01-CORR/v01 — candidata DRAFT tecnicamente verificada

## Commit local autorizado em 2026-10-11

Pedido do dono: “aprovado, commit”. Escopo operacional IN_PLAN: arquivar correção AL01-CORR/v01 aceita a 900 ms, pacote de produção/auditoria/galeria, inventário das 34 preparações e registros ADD/CANON. Commit local autorizado na branch codex/assets-preparation-2026-10-10; sem push, merge ou integração. Autorização posterior à produção e ao aceite; nomes dos pacotes de 2026-10-10 preservados. Checks de hashes/links/contrato e backlog repetidos antes do commit. Backlog: P0=0, quatro P1 abertos BUG-025/027/028/029, quatorze implementados aguardando playtest, zero alertas. As afirmações anteriores de commit não autorizado descrevem os checkpoints anteriores a este pedido.

## Aceite visual posterior

Dono aprovou “Aprovo com ciclo de 900 ms”. Correção AL01-CORR/v01/AL01_loop_v03 (tira e seis frames) promovida a CANON de preparação visual, ciclo 900 ms/frame 150 ms, conforme [registro CANON](../vault/canon/ASSET-APPROVAL-FILA028-ALTAR-CORRECTION-v01.md) e [hashes aceitos](../generated/fila028-altar-correction-2026-10-10/approved-altar.json). Os relatos DRAFT/revisão pendente abaixo são históricos da entrega; aceite atual resolve aparência/ritmo da correção identificada. Imagens/fontes não modificadas; 74 hashes protegidos e seis frames/tira revalidados.

Inventário atual: [34 preparações aceitas](../generated/fila028-acceptance-2026-10-10/approved-prepared-assets.json), somando as 33 anteriores e AL01 corrigido. Loop antigo permanece DRAFT retido/histórico, sem dispensa da falha de invariância. Galeria reconciliada. Aprovação não autoriza integração, commit ou push. Próxima pendência operacional preparada: retorno dos heróis S-007/ORIGINAL-GENERATIONS/NORMALIZATION-EXTRACTION-11, sujeito à leitura do estado persistente correspondente; PLAN-071 preservado.

Autoridade de execução: dono, “Aprovo a correção do altar”, modalidade per-plan preservada, cinco etapas executadas. [Spec](../specs/SPEC-121-retomada-fila-imagens/altar-correction-v01.md), [estado](../state/fila028-altar-correction.yaml), [galeria](../generated/fila028-altar-correction-2026-10-10/index.html), [auditoria](../generated/fila028-altar-correction-2026-10-10/audit.json), [parâmetros](../generated/fila028-altar-correction-2026-10-10/parameters.json), [entradas protegidas](../generated/fila028-altar-correction-2026-10-10/inputs.json).

Fonte de identidade CANON AL01 v02, primeiro quadro da preparação retida como entrada DRAFT autorizada; candidata AL01_loop_v03 é derivada DRAFT da correção AL01-CORR/v01, não nova fonte CANON. Não promove ou substitui AL01 v02. Outras 33 derivadas CANON de preparação mantidas intactas.

## Resultados das cinco etapas

S-001 BASE_MASKS: hash anterior de 74 arquivos (34 fontes, 34 derivadas anteriores, seis frames antigos), base 192×192 isolada com Godot 4.7.2, regiões de quatro chamas/brasas marcadas e refinadas por cor quente. Preview com verde para fogo e azul para envelope de movimento inspecionado contra a base ampliada. Máscara de corpo inclui todos os pixels opacos fora do fogo; máscaras de fogo/corpo/área permitida são disjuntas onde necessário. Identidade personagem N/A; altar objeto isométrico, pedra/pano/bacia/metal/velas físicas excluídos dos efeitos. Não houve redesenho de cenário, símbolos ou lore.

S-002 EFFECT_FRAMES: seis fases periódicas derivadas do mesmo frame, brilho sutil no fogo/brasas. Chama direita desloca até um pixel no envelope livre; as outras três usam fallback de brilho sem deformação, pois separar/mover seus pixels poderia exigir reconstruir corpo ou borda da chama não classificada. Uma classificação conservadora preferiu preservação. Alfa de corpo não modificado. O efeito é pulsação/flicker limitado, não uma animação ampla de forma das quatro chamas.

S-003 PACK: seis frames RGBA 192×192 e [tira RGBA 1152×192](../generated/fila028-altar-correction-2026-10-10/normalized/AL01_loop_v03.png), ordem 0–5, persistidos apenas no novo pacote. Base, oito máscaras (cinco específicas, fogo, corpo, área permitida), parâmetros e previews preservados. Fontes/derivadas antigas não sobrescritas.

S-004 AUDIT: todos os doze checks passaram. 14.278 pixels de corpo iguais à base, RGB/alfa, e todos alfa 255 em cada um dos seis frames. Zero diferenças fora da máscara permitida, fundos externos transparentes, bbox/âncora invariáveis, seis frames distintos, montagem idêntica aos frames, movimento máximo e passos cíclicos de um pixel. 74 hashes protegidos conferidos após processamento. Auditoria Python somente lê pixels e escreve JSON/HTML; Godot produz todos os pixels.

Transições RGBA L1 na área de efeito 0→1,1→2,2→3,3→4,4→5,5→0: 5056,36512,40909,6729,37235,39601. Wrap dentro do limite conservador 1,25× maior delta não-wrap. Variação alta em passos com deslocamento horizontal de um pixel, baixa quando só brilho muda. Estes números são comparação técnica, não prova de suavidade subjetiva. Corpo não varia em nenhuma transição; última fase não precisa ser cópia da primeira.

S-005 GALLERY: seis frames, fonte CANON, base fixa, loop anterior retido, correção, máscaras e três fundos. Browser local via skill computer-use: imagens carregadas, controles 1200 ms/600 ms/900 ms, pausa e retomada testados; CSS relatou duração 0,6 s e paused durante a pausa, restaurado 900 ms/running ao entregar. Screenshots inspecionadas e [captura local](../generated/fila028-altar-correction-2026-10-10/gallery-review.png) salva. Servidor de preview restrito a 127.0.0.1:8765, sem publicação externa; HTML permanece artefato local independente do servidor. Links do HTML/CSS e registros conferidos.

## Contrato e próximo checkpoint

TECHNICALLY_VERIFIED_DRAFT_OWNER_REVIEW_PENDING. Contrato de invariância/opacidade da máscara completa passa; a classificação das regiões de fogo/corpo é visual e foi inspecionada, enquanto a comparação cobre todos os seus pixels. Ainda depende do dono aceitar materiais/identidade/quatro velas, aspecto de chama da pulsação e cadência confortável, incluindo último→primeiro. Preview recomendado 900 ms, alternativas 600/1200 ms disponíveis. Sem integração, playtest, promoção CANON, commit ou push.

Checkpoint OWNER-ALTAR-REVIEW. Próximo objetivo: dono avaliar AL01-CORR/v01/AL01_loop_v03; entradas galeria/máscaras/frames/contrato; saída aceite identificado ou correções pontuais. Aprovação de execução do plano não é aceite visual. Altar anterior permanece retido, PLAN-071 e retorno dos heróis S-007/ORIGINAL-GENERATIONS/NORMALIZATION-EXTRACTION-11 preservados.

Backlog no início: P0=0, quatro P1 abertos BUG-025/027/028/029, quatorze correções aguardando playtest, zero alertas. Godot emitiu os mesmos avisos de certificado local e salvamento negado de preferências AppData; saídas do pacote verificadas, sem permissão nova/escrita externa de preferências. Processamento executado com ferramenta já instalada, sem IA/dependências novas.
