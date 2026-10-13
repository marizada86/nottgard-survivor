# AO04/AO07 — revisão específica, 2026-10-13

Continuação IN_PLAN de PLAN-053 solicitada por “atena, continue”. As quatro wide v01 foram aceitas anteriormente; doze tiras/64 quadros DRAFT permanecem aceitos. Preparada proposta PLAN_CHANGE_REQUEST limitada à exceção 14/13 px de variação nas candidatas AO04/AO07 v02 existentes. Modalidade per-plan preservada. S-001 concluída, S-002 atual pendente, S-003 posterior condicionado ao aceite: 1/3 concluída, posição 2/3, uma etapa depois da atual.

[Especificação](../specs/SPEC-121-retomada-fila-imagens/hero-spread-exception-v01.md), [galeria](../generated/hero-spread-review-2026-10-13/index.html), [medidas/hashes](../generated/hero-spread-review-2026-10-13/review.json), [estado](../state/hero-spread-exception.yaml).

As duas tiras completas foram inspecionadas nativamente. Verificação independente leu os rasters: doze células recompõem dois atlas, medianas 290 px, variações 14/13 px contra limite 12, escala única/tira, margem >=10, base raster a no máximo um pixel de 368, sem resíduo alfa 1–8. Fontes e extrações/candidatas verificadas por hash; os hashes das doze tiras aceitas permanecem iguais. HEAD e índice vazio preservados. Inspeção modelada e pequena medida não substituem aceite humano do movimento.

Python somente leu matrizes e produziu JSON/HTML. Nenhum PNG, fonte, runtime, recibo histórico ou Git alterado. Links locais da galeria conferidos, controles do navegador não executados devido ao bloqueio conhecido de file://; não se afirma teste de interação nem playtest. Fonte/visual bible/identidade/cena mantêm a autoridade e estados do contrato body/pivot anterior; nada promovido a CANON.

Próximo objetivo: decisão explícita sobre o aceite visual com exceção. Após aprovação, registrar os dois hashes e doze quadros em recibo novo e inventário 14/76, mantendo as falhas técnicas originais e exceção declaradas. Se recusada, preservar as duas retidas e definir outra rota antes de qualquer alteração. AO09/AO10/ER03/ER06 continuam pendentes; sem integração, commit, push ou exportação.

Backlog no início da sessão: zero P0; P1 abertos BUG-025/027/028/029; quatorze P1 implementados aguardando playtest; zero alertas de organização.

## Aceite e fechamento

Em 2026-10-13 o dono respondeu exatamente **“Aprovo as duas v02 com exceção de 14/13 px (recomendado)”**. Aceite de AO04/AO07 v02 e exceção limitada de 14/13 px registrados no [recibo](../generated/hero-spread-review-2026-10-13/visual-acceptance.json). O limite global de 12 px e as medidas/falhas originais continuam explícitos; conteúdo DRAFT, nenhuma promoção CANON. Plano 3/3 concluído.

[Inventário atualizado](../generated/hero-spread-review-2026-10-13/accepted-hero-inventory.json): quatorze tiras/76 quadros. Restam AO09/AO10/ER03/ER06. Inventário histórico 12/64 e recibos anteriores preservados por hash; fontes, atlas e doze células reconferidos. Galeria atualizada com aceite e links dos dois novos registros, sem afirmar execução no navegador. Nenhuma admissão, raster novo, alteração de runtime ou operação Git. Próximo objetivo: avaliar os corredores de AO09/AO10 e preparar decisão concreta para ER03/ER06 antes da admissão; novas alterações ainda não autorizadas por este recibo.
