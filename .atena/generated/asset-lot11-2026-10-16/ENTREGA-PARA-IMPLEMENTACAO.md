# ASSET-LOT11/v01 — entrega DRAFT com retenções

Oito entradas/32poses de QA em15tentativas. Escopo aprovado per-plan em2026-10-16 (“aprovado, continue”), registrado antes de gerar. Aceite visual PENDING. [Galeria](index.html), [manifesto](manifest.json), [medidas](inspection.json), [prompts](prompts.md), [referências](references.json), [origens/copias exatas](generation-origins.json).

| Código / fase | Seleção | Margem mínima alfa≥16 | Base núcleo: dispersão | Centro bbox núcleo horizontal: dispersão | Situação |
|---|---|---:|---:|---:|---|
| RU01 Dagruve |v01|4px|1px|1px|Revisão de direção, folga muito curta|
| RU02 Docas |v01|19px|0px|0px|Revisão de direção|
| RU03 Shedaklah |v01|53px|0px|2,5px|Revisão de direção|
| RU04 Molor |v01|32px|0px|0,5px|Revisão de direção|
| RU05 Durao |v03|5px|1px|41px|RETIDO por deriva após três tentativas|
| RU06 Feng-tu |v02|47px|5px|0,5px|Revisão de direção, base a preparar|
| RU07 Shendilavri |v03|13px|0px|39,5px|RETIDO por deriva após três tentativas|
| RU08 Goranthis |v01|0px|0px|32,5px|RETIDO:145pixels alfa≥16 na banda4px e deriva, três tentativas esgotadas|

Fontes selecionadas todas2048×768,4×1, células512×768, em `../animation-candidates/asset-lot11/`. RU06v01 não selecionada mede2046×768; não atribuir largura2048 a todas as tentativas. Históricos inspection-v01/v02/v03.json. RU08v02/v03 pioraram contato e deriva; v01 escolhida para revisão por menor contaminação, sem liberar a retenção. Todas15tentativas preservadas; nenhuma fonte excedeu três versões, orçamento total24.

RU05v02/v03 eliminaram contato mas deriva41px persistiu; RU07v02/v03 eliminaram contato mas deriva41/39,5px persistiu. RU08: contato145/660/697pixels e deriva32,5/45,5/67,5px nas três versões. Não admitir recortes RU08, podem conter pedaços de outro quadro. Os outros sete ciclos têm zero contato na banda4px; dois deles ainda retidos por registro. As outras cinco entradas não têm retenção material registrada além das pendências de preparação, sem significar prontidão de runtime.

Todas as entradas ficam abaixo da margem solicitada64px em pelo menos um quadro; adicionar folga na preparação. Alfa de sólidos/resíduos e registro precisam de avaliação; luz/névoa legítimas não seguem a mesma regra de solidez da pedra. Bbox do núcleo inclui efeito/tecido: proxy não certifica pivô semântico ou rigidez fina. Conferir arquitetura, base e retorno4→1 antes de integrar; quatro hashes diferentes não provam animação/fluidez.

Contextos/identidades: capela Dagruve com névoa/luz, galpão Docas com toldo/lanterna, arco fúngico Shedaklah com esporos, gruta Molor com reflexos de slime, acampamento Durao com tecido/fogueira apagada, templo arruinado Feng-tu com estrela caída e tecido, arcos Shendilavri com cortinas, salão Goranthis com fitas/luz. Nenhuma figura, lore, nova fase ou regra introduzida. Identidade pessoal N/A para ambientes/props; materiais e identidade arquitetônica aplicáveis. Referências estáticas registradas CANON_PREPARATION_VISUAL_ONLY não promovem estas novas poses a CANON.

Quadros de QA conservam células/posição/proporção nativas; leituras48/80/128 recortam somente bbox do primeiro quadro para leitura, sem limpar ou alinhar fonte. [Player-check](player-check.json) verifica oito players/32arquivos por simulação DOM offline; sem render de navegador. [Integridade](delivery-check.json) não é PASS global de arte/runtime. Não houve teste Godot/playtest, assets oficiais/código/dados inalterados.

Próximo checkpoint: revisão visual conjunta, aceite parcial permitido. Retenções RU05/RU07/RU08 não serão liberadas automaticamente por aceite de direção. Preparação/admissão/consumer e implementação com Claude em escopo próprio. Novo método/orçamento para peças retidas exige plano e autorização; não gerar mais dentro deste limite. Sem mensagem a outro chat, CANON, commit/push/merge/exportação nesta produção.

Aceite posterior2026-10-16: 'aprovado, commit e continue'. Direção visual das oito revisões selecionadas/32poses de QA aceita DRAFT; recibo visual-acceptance.json no pacote. Supera PENDING visual anterior, preservando as três retenções técnicas RU05/RU07/RU08 e demais notas de preparação. Sem admissão/CANON. Commit local das entregas pendentes LOT10/LOT11 autorizado; sem push/exportação.
