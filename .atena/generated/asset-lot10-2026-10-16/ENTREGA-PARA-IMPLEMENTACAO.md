# ASSET-LOT10/v01 — entrega DRAFT

Sete folhas/28poses selecionadas em13tentativas. Aprovação do escopo por plano em2026-10-16, resposta “aprovado, continue”, registrada antes da primeira geração. Aceite visual das novas poses PENDING. [Galeria](index.html), [manifesto e hashes](manifest.json), [medidas](inspection.json), [prompts exatos](prompts.md), [referências](references.json).

| Código | Seleção | Menor margem alfa≥16 | Dispersão da base núcleo | Dispersão horizontal do centro bbox núcleo |
|---|---|---:|---:|---:|
| ES01 Pacto de Sangue |v02|33px|0px|13px|
| ES02 Relicário |v01|14px|0px|3,5px|
| ES03 Carroça Abandonada |v01|26px|0px|0,5px|
| ES04 Pedra do Eclipse |v03|72px|0px|4px|
| ES05 Eco |v02|174px|1px|3,5px|
| ES06 Câmara selada |v01|13px|0px|0px|
| ES07 Câmara aberta |v03|35px|0px|0,5px|

Fontes em `../animation-candidates/asset-lot10/`, todas2048×768,4×1, células512×768. Bytes nativos preservados, nenhuma limpeza/normalização ou alinhamento oculto. QA extrai células fixas; leituras48/80/128 recortam apenas bbox do primeiro quadro para avaliar leitura, sem fixar escala runtime.

ES01v01 e ES07v01 encostavam em divisões, substituídos. ES07v02 tinha deriva horizontal35px, reduzida para0,5px emv03. ES04v01/v02 tinham deriva cerca de21/20px, reduzida para4px emv03. ES05v01 foi substituído para melhorar registro. Diagnósticos anteriores em inspection-v01/v02/v03.json; prompts e todas as tentativas preservados. Nenhuma fonte ultrapassou três tentativas, orçamento máximo21.

Selecionadas sem alfa≥16 em banda4px. ES01/02/03/06/07 têm margens abaixo do alvo64px; precisam de folga na preparação. Corpos com moda alfa252/253 e resíduos alfa1–15 exigem avaliação de opacidade/limpeza; emissão legítima do Eco e luz não se mede pela mesma regra de solidez da pedra. Não descartar detalhes por cor apenas. ES01 tem registro horizontal residual13px; alinhar por estrutura rígida na preparação, sem usar o filamento como pivô. Bbox do núcleo inclui luz e não certifica pivô semântico. Nenhum dado comprova fluidez.

Identidades: laje/adaga/selo rígidos com filamento; relicário fechado com reflexos; carroça/carga imóveis com luz existente; aro de Eclipse pulsante; Eco com luz/partículas restritas; câmara selada com três selos intactos; câmara aberta com restos existentes. Sem novo sangue, personagens, lore, loot ou ativação. ES06/ES07 preservam família arquitetônica mas foram geradas separadamente: comparar escala/contorno/cor na preparação, não usá-las como interpolação de abertura. Rigidez fina e retorno4→1 exigem revisão humana. Identidade pessoal/figurino N/A nos sete objetos/efeitos.

Sete players testados por simulação DOM offline ([resultado](player-check.json)); não render real de navegador. [Integridade](delivery-check.json) verifica hashes/referências/caminhos e não certifica runtime. Sem teste Godot/playtest porque nenhum runtime foi alterado. Preparação/admissão/consumer/temporização/contraste e implementação com Claude em escopo próprio; nenhuma mensagem enviada. CANON e integração não autorizados por esta produção. Próximo checkpoint: aceite visual conjunto das sete revisões, permitindo aceite parcial. Sem novo commit/push/merge/exportação.

Aceite posterior2026-10-16: 'atena aprovado, continue'. Sete revisões selecionadas/28poses aceitas como direção visual DRAFT, recibo visual-acceptance.json no pacote. Supera PENDING visual anterior, preserva preparação/registro/pareamento e ausência de admissão/CANON. Implementação com Claude.
