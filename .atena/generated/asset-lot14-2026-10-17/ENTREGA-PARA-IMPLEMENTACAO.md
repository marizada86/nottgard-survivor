# LOT14/v01 — entrega DRAFT para Claude

Produção contextual aprovada em2026-10-17: “atena continue a fila de assets”, após proposta concreta de29PNGs/seis estados, modo per-plan e revisão conjunta sem gate intermediário idle00. Referências implementadas fixam identidade, não presumem aceite dos movimentos. Aceite visual desta entrega PENDING. Nenhuma admissão no runtime.

[Galeria](index.html), [manifesto](manifest.json), [medidas](inspection.json), [prompts](prompts.md), [referências](references.json), [origens](generation-origins.json), [integridade](delivery-check.json), [controles](player-check.json), [seleção](attempt-review.md).

29PNGs individuais1254×1254,36tentativas (máximo87, até3por arquivo). Selecionadas MM01/MM05/MD03/TD03/TD04v02, demaisv01. Não usar automaticamente a maior revisão: TD03/v03 foi rejeitada por reconstruir base/restos e perder continuidade. Fontes nativas copiadas byte a byte; QA usa canvas integral. Originais e revisões não receberam limpeza/alinhamento por script.

| Grupo | Quadros | Prévia | Base núcleo px | Centro x bbox px | Largura núcleo px |
|---|---:|---|---:|---:|---:|
| MI repouso Mímico |4|loop|4|3|12|
| MM caminhada |6|loop|33|43|78|
| MA mordida |4|uma vez/recupera|33|38|95|
| MD morte |6|uma vez/hold|10|11|152|
| TI repouso Turíbulo |4|loop|1|2|3|
| TD ruptura |5|uma vez/hold|24|7|92|

Valores são amplitudes por grupo em alfa≥128, não pivôs semânticos. MM05v02 reduz variação de base do movimento53→33px; MD03v02 reduz largura variável da morte231→152px e melhora margem68→122px. Parte dessa largura é abertura deliberada das patas, mas não há liberação de escala rígida. A morte do Mímico reduz altura749/682/593/521/519/517px e termina com boca fechada/olhos escuros/patas dobradas. Não converter corpo no baú de recompensa (SPEC-134 já gera isso separadamente).

TD tem altura743/572/585/593/595px: perda inicial, seguida de crescimento do suporte/registro que impede PASS de continuidade geométrica. Chamas se apagam atéTD03; últimos dois mostram três restos de velas deitados. TD02v02 perde parte da construção quebrada e não resolve geometria; TD03v03 melhora suporte mas reergue/reorganiza restos, por isso não selecionadas. Limite de três tentativas de TD03 respeitado; TD permanece retido, sem regeneração silenciosa além desse limite.

Retenções:
- LOT14_ALPHA_PREPARATION: resíduos1..15 e alfa modal253 nos materiais; verificar corpo opaco, manter transparência legítima das chamas, limpar contaminação.
- LOT14_MARGIN_TARGET:28/29fontes abaixo do alvo12%; mínimo99px(7,9%), máximo159px(12,7%). Nenhum contato alfa≥16 na banda externa4px.
- LOT14_REGISTRATION_SCALE_REVIEW: pivô/escala/apoio nos cinco estados não rígidos e rigidez fina de TI. MA01 oculta pata traseira; avaliar como oclusão ou corrigir antes de admitir.
- LOT14_TD_BASE_GROWTH_AFTER_THREE_ATTEMPTS: ruptura tecnicamente retida. Aceite de direção não a libera.

TI mantém estrutura visualmente estável nos contatos (base1px/centro2px/largura3px), mas pequenas diferenças de textura exigem revisão; não alegar identidade pixel a pixel. Patas e língua do Mímico devem permanecer coerentes em redução. Leituras48/80/128 por fonte estão no pacote. Parar/reiniciar/ajustar FPS e scrub ajudam inspeção; controles passaram DOM offline, não render real. Não há avaliação humana de fluidez ou playtest.

Preparação/pivô/packing/redução/temporização/consumer de morte/flip e integração com Claude em escopo posterior. Turíbulo speed0, sem move/attack/special; Mímico segue mordida e quatro patas existentes. Sem alterar dano, cura/proteção, drop ou mecânica. Bíblia/contexto e hashes na spec; vault/Nottcard preservados.

Retenções históricas LOT11 e LOT13 permanecem independentes. Sem runtime, promoção CANON, commit/push/exportação desta produção ou mensagem a outro chat. Próximo checkpoint: revisão visual conjunta das seis sequências por código/revisão, aceitação parcial possível.


Aceite posterior2026-10-17: “aprovado, commit e continue”. [Recibo](visual-acceptance.json) cobre29revisões/seis estados DRAFT; supera PENDING visual anterior. Retenções técnicas/históricas, especialmente rupturaTD, preservadas; sem admissão runtime ou promoção CANON. Commit local autorizado, sem novo push.
