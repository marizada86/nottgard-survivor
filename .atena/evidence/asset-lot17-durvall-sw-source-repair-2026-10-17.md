# LOT17/v01 — Durvall SW em seis fontes individuais

2026-10-17, DRAFT, origin planned, implementation_preceded_spec false. [Proposta](../specs/SPEC-121-retomada-fila-imagens/asset-lot17-durvall-sw-source-repair-v01.md)6fontes/18chamadas máximas aprovada com “aprovado, continue” antes de gerar, modo per-plan. O aceite deLOT16 não foi usado para exceder o limite deP9: método e arquivos novos foram especificamente autorizados.

S-001: relidos plano/estado/add.yaml, referências verificadas porhash. Identidade/cena/canon002/fichaG-D1 estruturados no spec; nada promovidoCANON. RTK jáenabled. Backlog0P0,4P1abertos e18implementados aguardando playtest,0alertas.

S-002:13chamadas built-in imagegen, um PNG por pose,6selecionadas. SW00v01 acertou a proposta de braço/mão mas encheu ocanvas; SW00v02 reduz porte e é âncora. SW01..05v01 cresceram; v02 usa âncora para escala e segunda referência só para pernas. SW03v01 repetia contato inicial; v02 transfere contato oposto. SW04v02 voltou à passada inicial; v03 a partir deSW03v02 recupera apoio oposto, ainda com maior variação de contorno. SW04atingiu3tentativas; demais2cada. [Origens](../generated/asset-lot17-2026-10-17/generation-origins.json), [prompts exatos](../generated/asset-lot17-2026-10-17/prompts.md), [seleção](../generated/asset-lot17-2026-10-17/attempt-review.md).

Nativas/cópias preservadas byte a byte, sem fabricar poses por espelho/translação/recorte de tira ou editar pixels por script. P9defeituosa só consta como referência diagnóstica no snapshot, nunca como entrada de geração. Os seis PNGs novos permanecemDRAFT.

S-003: observação dos seis nativos, contato integral e leituras80 deSW00/SW03/SW04 favorece a hipótese anatômica: ombro/cotovelo/mão no lado direito da imagem frontal seguram a espada cruzada baixa àesquerda, outra mão vazia; face/corpoSW. Contatos0/3 distintos. Isso não é prova por métrica, aceite humano ou liberação daP9 antiga. Cadência/intermediários/retorno e proporção ao idle precisam de revisão. Sem render real/playtest.

Todas1254×1254;6clonesQA integrais e18leituras48/80/128. Zero contato alfa≥16 na banda4px, margens mínimas123..183px≥64px, núcleo modal253/resíduos de baixa opacidade. Bbox corealtura831..892px, topo234..241px; spreadbase60px/centroX48px/largura114px. Inclui cabelo/faixa/espada, não certifica pivô, corpo semântico ou ausência de patinar. Player não alinha ou normaliza para esconder variação. [Medidas](../generated/asset-lot17-2026-10-17/inspection.json).

S-004: [galeria](../generated/asset-lot17-2026-10-17/index.html), um playerloop6 com5/10FPS, pausa/replay/repeat/scrub e links para todasfontes. [Controlesoffline](../generated/asset-lot17-2026-10-17/player-check.json), [integridade/contrato](../generated/asset-lot17-2026-10-17/delivery-check.json):6selecionadas/13tentativas/6QA/3referências/18entradas hashadas,13prompts/18leituras. SimulaçãoDOM não certifica render/fluidez. [Handoff localClaude](../generated/asset-lot17-2026-10-17/ENTREGA-PARA-IMPLEMENTACAO.md), sem mensagem enviada.

Produção4/4 concluída, checkpoint OWNER_JOINT_VISUAL_REVIEW/PENDING, aceitar parcial por pose/revisão permitido. Retenções LOT17_ALPHA_PREPARATION, LOT17_REGISTRATION_SCALE_CADENCE_REVIEW e LOT17_SW04_REGISTRATION_AFTER_THREE_ATTEMPTS. Histórica LOT16_P9_LEFT_HAND_DIRECTION_CONFLICT preservada até substituição verificada/admitida em escopo posterior. Próximo objetivo: dono revisar seisrevisões porhash; depoisClaude preparar/implementar conforme autorização própria. Sem assets/código/dados oficiais, laboratório, runtime/CANON, alteraçãoFPS/velocidade, commit/push/export ou mensagem externa. BUG025/027/028/029 continuam abertos.

## Aceite posterior e commit autorizado

Dono respondeu “aprovado, commite” em2026-10-17. [Recibo](../generated/asset-lot17-2026-10-17/visual-acceptance.json) aceita as6revisões porhash como direção visualDRAFT, preservando retenções técnicas eP9histórica. Estado/galeria/manifesto e verificador atualizados para não apagar o aceite ao repetir checks. Commit local da frente pendente autorizado; sem push, implementação ou CANON. [Registro do commit](asset-lot15-17-local-commit-2026-10-17.md).
