# LOT16/v01 — cinco direções restantes de Durvall

2026-10-17, DRAFT, origin planned, implementation_preceded_spec false. Pedido “atena, continue”. Continuação do escopo PLAN-103/B-002/D22 já registrado: depois do pilotoDurvallv03 aceito provisoriamente, produzirN/NE/W/SW/NW reais, semespelhos, depois reavaliar. [Spec delimitado antes da produção](../specs/SPEC-121-retomada-fila-imagens/asset-lot16-durvall-directions-v01.md), [estado](../state/asset-lot16-durvall-directions.yaml), modo per-batch do marcoB-002. Não inferir aceite das fontes novas.

S-001: inspecionados idle, gabarito3×2 e pilotoE v03; lidos fichaG-D1, canon002 e prompts existentes. Consultados retornos locais e checkoutprincipal somenteleitura: E/SE/S/attack presentes, os cinco nomes solicitados ausentes. FILA031 é reserva doM1 e estava fora do catálogo31arquivosCHATGPT-FILA auditado anteriormente. A reconciliação anterior era incompleta para o conjunto do projeto; corrigida sem descartar os17pacotes já aceitos. Nenhum arquivo do checkoutprincipal alterado/importado como cânone.

S-002:13chamadas built-in imagegen, uma folha por chamada, no máximo3por direção. Cinco selecionadas: P6/P7/P8/P10v01 eP9v02,30célulasQA. Nativas/cópias byteexatas, [origens e entradas](../generated/asset-lot16-2026-10-17/generation-origins.json) e [13prompts](../generated/asset-lot16-2026-10-17/prompts.md). Fontes emart-candidates/asset-lot16; retornos antigos intocados. Sem fabricação de poses por espelho/transformação nem limpeza de pixels por script.

S-003: cinco contatos e primeiras leituras80 vistos. Prévia inicial da ferramenta parecia mostrar halo; composição efetiva emchecker com alfa não mostra aquele fundo, avaliação corrigida. Não se afirma fundo opaco nas selecionadas. As versões de limpeza ampliaram/repetiram poses e não foram selecionadas. P7v03 muda mão/posição, P10v03 vemNE, ambas rejeitadas. [Seleção e ressalvas](../generated/asset-lot16-2026-10-17/attempt-review.md).

P9v01/v03 vieram com face/toes voltados àdireita, P9v02 segueSW mas aparenta trocar espada para mão direita. P9RETIDA: nenhuma versão atende simultaneamente facing+empunhadura após3tentativas. Não importar ou espelhar; exige decisão/correção artística em escopo posterior. Packing não corrige anatomia.

| Grupo/revisão | Canvas | Célula | Spreadbase núcleo | SpreadcentroX | Largura spread | Margem mínima |
|---|---|---|---:|---:|---:|---:|
|P6v01|1536×1024|512×512|32|28|18|32|
|P7v01|1536×1024|512×512|59|25|10|32|
|P8v01|1545×1018|515×509|14|34,5|21|25|
|P9v02|1536×1024|512×512|44|13|34|9|
|P10v01|1536×1024|512×512|71|37,5|19|25|

Valores empx nativos, bbox inclui espada/cabelo/roupa, não certifica pivô ou altura anatômica. Zero contato alfa≥16 em banda4px nas30células; núcleo modal252/253. P8não cumpre célulaquadrada nativa. Balanço/contatos distintos em várias poses, mas intermediários e retorno não têm cadência/fluidez certificados. Alvo330px solicitado não foi certificado como altura corporal semântica.90leituras porquadro48/80/128 e contatos integrais, sem alinhamento escondido. [Medidas](../generated/asset-lot16-2026-10-17/inspection.json).

S-004: [galeria](../generated/asset-lot16-2026-10-17/index.html), cinco playersloop6 com5/10FPS, pausa/replay/repeat/scrub, [controlesoffline](../generated/asset-lot16-2026-10-17/player-check.json), [integridade/contrato](../generated/asset-lot16-2026-10-17/delivery-check.json). Controles são simulaçãoDOM, não render/playtest. [HandofflocalClaude](../generated/asset-lot16-2026-10-17/ENTREGA-PARA-IMPLEMENTACAO.md), nenhuma mensagem enviada.

Produção4/4 encerrada com retenções, checkpoint OWNER_DURVALL_DIRECTIONS_REVIEW/PENDING. Aceite visual pode ser parcial por direção/revisão; retenções não se resolvem por aceitar direção. Reavaliar piloto v03 depois das direções, comoD22. Sem runtime/CANON, alteração deFPS/velocidade/código/dados, laboratório, commit/push/export. BUG025/027/028/029 e demais checkpointsPLAN103 preservados. Próxima execução depende do feedback visual e da decisão sobre P9.

## Aceite posterior

Dono aprovou a direcao visual em2026-10-17. [Recibo](../generated/asset-lot16-2026-10-17/visual-acceptance.json) aceita cinco revisoes porhash comoDRAFT, sem liberarP9 ou demais retencoes. Verificador preserva aceite emmanifesto/estado. [PropostaLOT17](../specs/SPEC-121-retomada-fila-imagens/asset-lot17-durvall-sw-source-repair-v01.md): seisPNGs individuais, metodo diferente apos limite3folhas, teto18chamadas, aprovacao especificaPENDING. Nenhuma fonteLOT17gerada, implementacao permaneceClaude.
