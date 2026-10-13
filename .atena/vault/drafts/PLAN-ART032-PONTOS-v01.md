---
id: PLAN-ART032-PONTOS
revision: v01
card: ART-032
status: COMPLETED_VISUALLY_ACCEPTED_DRAFT
content_state: DRAFT
approval_mode: per-plan
---

# ART-032 — pontos de acontecimentos restantes

O dono autorizou **“atena, aprovado, commite e continue a Próxima frente proposta: os pontos de acontecimentos restantes de ART-032.”** A frente já identificada no fechamento do lote 02 contém as seis peças abaixo. A autorização é registrada como aprovação desta continuação limitada, com a modalidade per-plan preservada, sem repetir o gate já respondido. Classificação PLAN_CHANGE_REQUEST: novo plano lateral aprovado, preservando os lotes encerrados e a cadeia PLAN-071/revisão de heróis. Não acrescenta a Manifestação de Juiblex, que continua pendência específica.

O commit local dos lotes anteriores foi executado primeiro: `51b51f7369ae34eede997435e6eb52ea057daf25`. A autorização de commit não se estende automaticamente às novas fontes deste plano. Não há integração, normalização/admissão, promoção a CANON, push ou build neste escopo.

## Contrato das seis fontes DRAFT

| Ordem | Código / revisão | Identidade e contexto verificados | Proposta visual DRAFT / leitura |
|---:|---|---|---|
| 1 | PT02 trono de Zuggtmoy v01 | Ponto de entrega do pedido em Shedaklah; soberana fúngica e palácio documentados. Geometria do trono não descrita. | Trono vazio compacto de madeira escura/mycelium e cogumelos malva, câmera isométrica; 80/128 px. Sem figura da soberana. |
| 2 | PT03 arco de pedra v01 | Sessão 16: antigo portal sem vão de passagem, runas exigem fungo e limo mais essência. | Arco de pedra gasto com face central opaca/inativa, marcas abstratas discretas; 80/128 px. A solução geométrica é hipótese DRAFT, sem afirmar texto rúnico canônico. |
| 3 | PT04 massa de Thullgrime v01 | Sessão 17: massa de carne/gosma, casulo e olhos centrais; ritual a sustenta antes de despertar como receptáculo. | Monte dormente de gosma verde-oliva e tecido orgânico malva contido, casulo arredondado e poucos olhos; 80/128 px. Não é nova arte de chefe nem humanoide em ataque. |
| 4 | PT05 Coração de Limo v01 | Nome/contexto de item em SPEC-118 e `data/stage_events.json`, retirado do receptáculo para Zuggtmoy. Sessão 16 documenta núcleo verde, não este nome/forma de coração. | Núcleo ovoide gelatinoso verde com centro luminoso contido, sem coração humano ou órgão realista; 48/80 px. |
| 5 | PT06 esporo de Zuggtmoy v01 | Item do evento que une opostos; lore descreve fungo/cogumelo, não anatomia do esporo isolado. | Unidade fúngica malva: cápsula/puffball com base curta e lamelas legíveis, sem nuvem solta; 48/80 px. Forma experimental DRAFT. |
| 6 | PT07 limo de Juiblex v01 | Item do mesmo evento; Juiblex é pegajoso/filamentoso, ligado ao limo. | Gota/porção pequena de gel verde-oliva, com filamentos curtos e reflexos contidos; 48/80 px. Sem face, olhos, membros ou núcleo, distinta do PT05. |

Uma chamada built-in imagegen por peça, PNG estático quadrado solicitado 1024×1024 com alfa verdadeiro; registrar dimensões reais. Um objeto completo por imagem, motivo aproximadamente 65–70% do quadro, margem visível mínima 10% em todos os lados (alfa >8). Preservar bytes nativos, versões e origem/hashes em `.atena/generated/art032-pontos-2026-10-11/sources/`. Sem recorte/limpeza/redimensionamento do original. Correções por defeito limitadas a três versões, mantendo invariantes e histórico. As prévias recortam apenas em memória para leitura; não fixam tamanho runtime.

## Bíblia visual e referências

Estilo CANON [PLAN-001](../canon/PLAN-001-nottgard-survivors.md): fantasia sombria isométrica, pouca poluição e leitura acima de espetáculo. Bíblia de produção DRAFT v01: câmera elevada três-quartos orientada para baixo/direita; luz superior esquerda; pintura com clusters de pixel, materiais gastos, transparência real, uma silhueta principal legível. Props com altura/profundidade coerentes, sem chão/cenário/sombra projetada, rótulos, molduras, grid, sheet ou animação. Paleta escura de pedra cinza, madeira marrom, fungo malva e limo verde-oliva. Diferenciar forma além de cor: trono assento/encosto, arco estrutural, massa baixa com casulo, núcleo compacto, cápsula fúngica e porção amorfa. Texturas subordinadas à leitura; halos pequenos; evitar gorro/chibi/fotorrealismo/vetor, vísceras detalhadas e símbolos novos tratados como sagrados.

Referências locais inspecionadas: `assets/interactions/chest_closed.png` para câmera/pixel/material, nunca copiar baú; `assets/enemies/receptaculo_de_juiblex.png` e `assets/enemies/slime_de_juiblex.png` para gosma/cores/brilho, nunca importar pose humanoide. Papéis e SHA256 serão registrados nos jobs. As dez fontes aceitas dos lotes anteriores ficam preservadas, não servem de targets de edição.

Vault de Nottgard somente leitura: Zuggtmoy, Juiblex, Palácio de Zuggtmoy, Thullgrime, Receptáculo de Juiblex e Sessões 15/16/17. `data/stage_events.json` é autoridade mecânica; a diferença entre lore e adaptação do evento fica explícita. Não importar anatomia de franquias externas. Nottcard somente leitura, sem necessidade demonstrada de nova consulta para a geometria DRAFT dos props.

Identidade pessoal/figurino é N/A em PT02/PT03/PT05/PT06/PT07: objetos sem personagem humano. Afiliação/contexto material são relevantes e verificados. PT04 tem identidade biológica aplicável, massa do receptáculo em estado dormente; o casulo/olhos vêm da lore. Nenhuma posição em mapa é requisito para estas fontes isoladas; contexto textual de entrega/portal/interceptação/coleta é suficiente. Atena prepara inputs, audita e mantém a responsabilidade por futura integração; não há necessidade demonstrada de agente especialista delegado.

## Lacunas e impactos

BLOCKING: nenhuma para geração experimental DRAFT dentro da frente aprovada. RESOLVABLE: forma do trono, geometria inativa do arco, forma física do coração/esporo/limo e leitura pós-geração; propostas acima ficam sujeitas à revisão humana. DEFERRED: variação ativada, animação, tamanhos/pivôs finais, oclusão/contraste em biomas, runtime e playtest. A Manifestação de Juiblex segue fora desta frente.

Impacto: seis fontes e gate visual próprios; nenhum dado mecânico, arquitetura, dependência, permissão ou canon alterados. Recuperação: manter fontes/versionamentos/hashes e snapshot dos ativos/runtime, recibos dos dez aceites e cauda `active_plan:`. Um defeito técnico permite correção limitada, sem ampliar escopo; conflito de identidade relevante para e pede decisão. Nenhum teste de gameplay é necessário sem runtime modificado; auditoria técnica não demonstra experiência/diversão.

## Passos ordenados

| Posição | Passo | Objetivo, saída e verificação / aprovação |
|---:|---|---|
| 1/5 | S-001 prontidão e contrato | Lore, identidade/contexto, bíblia, refs/hashes, prompts, plano/estado e snapshot. Aprovação de continuação explicitamente registrada; zero lacunas BLOCKING. |
| 2/5 | S-002 produção PT02–PT07 | Gerar na ordem seis fontes nativas e registrar dimensões/alfa/origem/hash. Autorizado per-plan; correções limitadas ao contrato. |
| 3/5 | S-003 auditoria | Hash/cópia, RGBA/alfa, margem/recorte, contexto e inspeção das fontes e leitura 48/80/128px; comparar com contrato e relatar exceções. |
| 4/5 | S-004 galeria e evidência | Galeria HTML, prancha Godot, prompts/jobs/auditoria e roteiro de revisão; links/estado/snapshot/backlog/diff verificados. Não contornar bloqueio conhecido de file:// no navegador; não alegar QA browser. |
| 5/5 | S-005 revisão visual do dono | Aceite ou correção por código/revisão. Checkpoint humano obrigatório, não autoriza integração/CANON/commit/push. |

S-001 concluído; S-002 atual, 1/5 concluído, três passos após o atual. Próximo objetivo: produzir seis fontes PT02–PT07 com estes inputs; saída esperada seis PNGs DRAFT preservados e registro de origem; execução já autorizada pela continuação explícita da frente proposta.

## Entrega S-004 — 2026-10-11

**4/5 passos concluídos; S-005 atual, zero passos após o atual.** Seis candidatas: **PT02 trono v02, PT03 arco v02, PT04 massa v02, PT05 Coração de Limo v01, PT06 esporo v02, PT07 limo v02**. Onze saídas nativas; cinco v01 preservadas e não selecionadas devido à margem abaixo de 10%. Correções limitaram-se ao enquadramento. Fontes reais 1254×1254, RGBA, alfa verdadeiro, bytes nativos intactos. Margens selecionadas 14,19%, 20,89%, 13,96%, 12,60%, 20,57%, 14,59%. PT02/PT05 preservam alfa 1/255 na borda, demais quatro têm borda vazia; sem clipping visível com alfa >8.

[Galeria](../../generated/art032-pontos-2026-10-11/index.html), [prancha completa](../../generated/art032-pontos-2026-10-11/review-reading.png), [auditoria](../../generated/art032-pontos-2026-10-11/audit.json), [evidência](../../evidence/art032-pontos-2026-10-11.md). Doze prévias Godot inspecionadas: props 80/128px, coletáveis 48/80px. Links/metadados conferidos; sem alegar QA no navegador. Runtime, fontes/recibos dos dois lotes anteriores e cauda PLAN-071 verificados por hash. Sem alterações de gameplay.

Próximo objetivo: dono avaliar trono vazio, face inativa do arco, casulo da massa e distinção dos três coletáveis, estilo/contraste/leitura; inputs são as seis revisões e a prancha, saída aceite identificado ou correções por código. **S-005 aguarda aceite visual humano.** Esse aceite não promove CANON nem autoriza admissão, integração, commit, push ou build. Após o fechamento, a Manifestação de Juiblex ou a preparação/admissão das fontes exige plano próprio. Texto de preparação acima preserva o estado anterior à produção.

## Fechamento S-005 — 2026-10-12

**5/5 passos concluídos; zero passos restantes.** O dono respondeu **“atena, aprovado”** ao checkpoint visual pendente das seis revisões: **PT02 trono de Zuggtmoy v02, PT03 arco de pedra v02, PT04 massa de Thullgrime v02, PT05 Coração de Limo v01, PT06 esporo de Zuggtmoy v02 e PT07 limo de Juiblex v02**. [Recibo por revisão/hash](../../generated/art032-pontos-2026-10-11/visual-acceptance.json). Leitura 80/128px nos props e 48/80px nos coletáveis, propostas geométricas DRAFT e nota de alfa residual 1/255 em PT02/PT05 estavam expostas no gate. Cinco fontes históricas v01 não foram aceitas. A prancha original registra a entrega antes do aceite e permanece intacta.

Todas as peças seguem **DRAFT visualmente aceitas**; nenhuma promoção a CANON, preparação/admissão, integração, novo commit, push ou build foi autorizada por esta resposta. Registros, estado, auditoria, galeria e backlog reconciliados; bytes das onze fontes, ativos/runtime, recibos/fontes anteriores e cadeia PLAN-071 preservados e verificados. Texto anterior mantém o histórico da produção/entrega.

Próximo objetivo preparado: plano futuro da arte própria da **Manifestação de Juiblex**, pendência específica ART-032, ou preparação/admissão das **dezesseis fontes DRAFT aceitas**. Inputs: lore/identidade de Juiblex, contexto SPEC-118, bíblia visual, arte do receptáculo para diferenciação e os três recibos de aceite existentes. Saída futura: escopo/prompts, prontidão e checks próprios, com gate visual posterior; execução do próximo plano ainda não aprovada. Este fechamento não altera o checkpoint preservado de PLAN-071.
