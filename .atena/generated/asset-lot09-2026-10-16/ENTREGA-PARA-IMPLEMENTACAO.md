# ASSET-LOT09/v01 — fontes DRAFT

Sete fontes selecionadas,28poses, dez tentativas. Escopo aprovado por plano em2026-10-16 (“aprovado”), antes da primeira geração. Aceite visual PENDING. [Galeria](index.html), [manifesto/hashes](manifest.json), [medidas](inspection.json), [prompts](prompts.md), [referências](references.json).

| Código | Revisão | Dimensões nativas | Célula | Base núcleo: dispersão | Menor margem alfa≥16 |
|---|---|---|---|---:|---:|
| EP01 trono | v03 |2048×768|512×768|0px|44px|
| EP02 arco | v02 |1536×1024|384×1024|0px|20px|
| EP03 massa | v01 |2172×724|543×724|10px|10px|
| EP04 estrela | v01 |1536×1024|384×1024|2px|29px|
| EP05 coração | v01 |2172×724|543×724|0px|59px|
| EP06 esporo | v01 |2103×748|525/526×748|6px|31px|
| EP07 limo | v01 |2172×724|543×724|0px|49px|

Fontes em `../animation-candidates/asset-lot09/`, uma linha de quatro poses. EP06 tem limites inteiros floor(i×2103/4); não arredondar todas as células para mesma largura descartando coluna. QA conserva canvas/posição e proporção. Previews48/80/128 recortam somente bbox do primeiro quadro para avaliar leitura; não são ativos admitidos. Nenhum original foi limpo, recortado ou regravado.

EP01v01/v02 e EP02v01 encostavam nas divisões e foram substituídos; diagnósticos em inspection-v01.json/inspection-v02.json. Selecionados sem alfa≥16 nas bandas4px; isso não garante margem-alvo48px. EP01..04 e EP06 têm pelo menos um quadro abaixo da folga pedida: acrescentar canvas na preparação, sem cortar. Corpo com moda alfa253, resíduos alfa1–15 em todos; transparência externa real, porém limpeza/opacidade de sólidos ainda pendentes. Falloff da estrela é legítimo e exige critério distinto da pedra/madeira.

Identidades DRAFT dos estáticos existentes preservadas. Trono vazio, arco fechado/inativo, massa dormente, estrela guia e três coletáveis. Nenhuma lore ou mecânica nova. Figura humana/figurino N/A, massa com identidade biológica aplicável. Movimento é proposta de repouso: bordas fúngicas, casulo/gel e luz interna, sem ativação ou coleta. Conferir rigidez fina da madeira/pedra, posição dos olhos, intensidade, retorno4→1 e escala antes de integrar. Quatro hashes distintos por fonte não comprovam fluidez. EP03/EP06 precisam de atenção ao registro da base; pivô semântico não foi certificado.

Dois tipos de checagem: player-check.json verifica sete players/28quadros por simulação DOM offline; delivery-check.json verifica arquivos/hashes/links. Não houve render de navegador, teste Godot ou playtest. Preparação/admissão/consumer, normalização, contraste runtime e temporização cabem a Claude em escopo próprio. Sem envio a outro chat. Sem CANON, commit, push ou exportação. Próximo checkpoint: revisão visual conjunta das sete entradas, com aceite parcial por código/revisão permitido.

Aceite posterior2026-10-16: 'aprovado, continue'. Direção visual das sete revisões selecionadas/28poses aceita DRAFT; visual-acceptance.json no pacote. Supera PENDING visual anterior, preserva preparação/registro e ausência de admissão/CANON. Implementação com Claude.
