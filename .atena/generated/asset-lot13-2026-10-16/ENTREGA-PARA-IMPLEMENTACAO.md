# LOT13/v01 — entrega DRAFT para Claude

Produção aprovada por plano em 2026-10-16 (“atena, aprovado continue”), finalizada em 2026-10-17. Direção visual dos movimentos aceita explicitamente em2026-10-17: “atena, aprovado, proximo”. O aceite anterior MJ01/v03 autoriza identidade, não estes novos estados. Nenhuma fonte nova admitida no jogo.

[Galeria](index.html), [manifesto](manifest.json), [medidas](inspection.json), [referências](references.json), [prompts gerais](prompts.md), [prompts special](special-prompts.md), [origens](generation-origins.json), [integridade](delivery-check.json), [controles](player-check.json).

## Inventário e uso previsto

26 PNGs individuais 1254×1254: JI00/v02 + JI01..03/v01; JM00..05, JA00..03, JD00..05, JS00..05, todos/v01. 27 tentativas (JI00/v01 substituída por enquadramento). Fontes nativas copiadas byte a byte, clones apenas para QA. Leituras 48/80/128 por pose disponíveis na pasta desta entrega; contatos preservam canvas integral.

| Estado | Quadros | Prévia |
|---|---:|---|
| JI repouso |4|loop|
| JM movimento |6|loop|
| JA ataque |4|uma vez, recuperação final|
| JD morte |6|uma vez, gel inerte final|
| JS especial |6|uma vez, recuperação final|

O especial não define trigger, raio, dano, invocação ou consumer. Respeitar dados existentes; mudanças de mecânica não fazem parte desta produção. Nada foi enviado a outro chat.

## QA e retenções para preparação

Nenhum pixel alfa≥16 na banda externa4px das26fontes. Margem mínima126px,10,0%, em JD04; JD05 tem146px,11,6%; ambas abaixo do alvo12%. Demais ≥156px. Sem substituição silenciosa ou correção raster.

| Estado | Variação base do núcleo px | Variação centro x bbox px | Variação largura px |
|---|---:|---:|---:|
| JI |9|3|58|
| JM |26|26|77|
| JA |39|30|84|
| JD |70|33|174|
| JS |27|24,5|146|

BBox alfa≥128 é proxy de contorno, inclui filamentos móveis e expansão de gel; não é pivô semântico. Na morte, altura536/517/355/354/341/266px decresce, mas base984/1035/965/1024/1014/1012px exige registro. Não confundir queda de altura deliberada com licença para deriva de posição.

Retenções técnicas: LOT13_ALPHA_PREPARATION (todos), LOT13_REGISTRATION_REVIEW (cinco estados, maior risco em movimento/morte/especial), LOT13_JD04_JD05_MARGIN_TARGET. Retenção significa preparação não liberada, não veto ao exame de direção. Alfa modal252–253, poucos pixels255 e resíduos1..15 persistem. Limpar contaminação e verificar corpo opaco, vazios, detalhes castanhos e filamentos sem destruir identidade. Pivô/canvas/escala/redução/packing/temporização e transições para idle dependem de preparação e aprovação de implementação. Nada disso foi aplicado aos originais.

Inspeção visual de contatos, fontes e leituras mostra variações de pose, extensão/recolhimento no ataque, colapso e pulso especial. Métricas e hashes não comprovam continuidade; humano deve avaliar player e aceitar por estado/revisão. Revisar especialmente loop JM05→JM00, mudança de largura e JS05→JI00. Players passam pausa/replay/FPS/scrub/repeat/hold em simulação DOM offline, não render real.

Retenções históricas RU05_HORIZONTAL_DRIFT, RU07_HORIZONTAL_DRIFT, RU08_COLUMN_CONTACT_AND_DRIFT permanecem independentes. Estático ativo MJ01/v03, runtime, dados e CANON preservados.

## Próximo checkpoint

Aceite visual conjunto das cinco sequências, podendo aceitar parcialmente pelos códigos/revisões acima. Implementação pertence a Claude em escopo posterior; antes, resolver retenções de preparação e confirmar ANIMATED/paths vigentes. Nenhum playtest foi realizado. Nenhum commit, push, exportação, integração ou publicação nesta etapa.


Aceite posterior: [recibo exato por hash](visual-acceptance.json),26revisões aceitas DRAFT em2026-10-17. Supera o checkpoint visual pendente acima; retenções técnicas e históricas preservadas. Sem admissão, promoção CANON ou implementação.
