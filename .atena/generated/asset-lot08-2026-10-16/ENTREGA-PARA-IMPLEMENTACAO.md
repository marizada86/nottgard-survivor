# LOT08/v01 — entrega de fontes DRAFT

Produção aprovada por plano em 2026-10-16. Onze fontes selecionadas em doze tentativas, cinco entradas para revisão conjunta. Aceite visual PENDING. Implementação e preparação com Claude; nenhuma admissão em runtime ou promoção CANON realizada. [Galeria](index.html), [manifesto e hashes](manifest.json), [medidas](inspection.json), [prompts exatos](prompts.md), [referências](references.json).

| Entrada | Fontes selecionadas | Contexto |
|---|---|---|
| PR01 | PR01/v01 | Pavilhão vazio como candidato a destino de escolta; geometria experimental, não arquitetura canônica de Tou Um |
| PR02 | PR02/v01 | Jaula vazia com corrente; Vhaerith permanece entidade separada |
| PR03 | PR03/v01 | Canoa vazia de madeira; sem água, passageiro ou Reaper |
| GR | GR01/v01, GR02/v02, GR03/v01, GR04/v01 | Quatro quadros individuais de idle de Graz’zt |
| FJ | FJ01/v01, FJ02/v01, FJ03/v01, FJ04/v01 | Quatro fases individuais do jato para direita |

PNGs nativos em `../art-candidates/asset-lot08/`, todos1254×1254. GR02/v01 preservado como tentativa substituída por deriva de escala. GR01 ancora os demais GR; FJ01 ancora os demais FJ. Os quadros da galeria conservam o canvas inteiro e a posição original; somente previews80/128 usam bbox para leitura. Não são tiras prontas para consumer.

## Avaliação e preparação necessária

Nenhuma fonte selecionada toca as bandas externas de4px com alfa≥16. Isso não prova alfa limpo ou preparo concluído. Moda do alfa do corpo252/253 e resíduos de baixa opacidade pedem preparação; a chama admite falloff legítimo. Margens mínimas dos props62/45/99px ficaram abaixo do alvo12% (~150px): aceitar visualmente não dispensa adicionar folga na preparação. Os três props permanecem hipóteses DRAFT sem nova lore.

PR02 apresenta vazios transparentes e resíduos entre barras: a amostra interna314×314 registra5482 pixels alfa0 e14994 pixels alfa1–15. Não certifica todas as aberturas. Conferir limpeza e divisão frente/fundo, oclusão e escala junto ao sprite separado na implementação.

GR02/v02 corrigiu a escala da primeira tentativa: dispersão da base alfa≥128 passou de61px para1px. A espada aparece inteira nos quatro PNGs individuais. Anatomia fina, identidade, sutileza e retorno4→1 exigem revisão humana; a medida de base não demonstra fluidez. Não fazer recortes independentes que destruam registro.

FJ usa a revisão aprovada de origem interna. O alvo1024 virou fonte1254; alvo nominal proporcional156,75/627 não coincide com o proxy medido. Raiz visual proposta próxima de169/652; propostas por quadro em `emitter_annotations` no manifesto. São anotações do modelo apoiadas em bbox/centroide e inspeção, não pivôs semânticos certificados. Confirmar emissor e alinhar antes de empacotar. Variação dos centroides é aproximadamente2,65px horizontal/3,13px vertical; extremidade do núcleo varia39px. Variação da base do contorno18px descreve altura de chama, não movimento de emissor. Comprimento não é perfeitamente constante; não derivar alcance/dano da arte.

## Retenções e validação

FC02_ORIGIN (LOT06) e NE06_SWORD_CROSSING_COLUMNS (LOT07) permanecem no histórico. Estas fontes são substituições candidatas: só uma decisão posterior pode liberar a substituição e sua preparação. MEC-004 continua não implementada.

Dois players: pausa, replay, FPS, repetição e scrub verificados por simulação DOM offline ([resultado](player-check.json)); não houve render validado em navegador, teste Godot ou playtest. [Integridade da entrega](delivery-check.json) cobre arquivos/hashes/referências, sem certificar integração. Próximo checkpoint: revisão conjunta dos três props e dois ciclos. Nenhum novo commit, push, exportação ou envio externo autorizado neste lote.

Aceite posterior2026-10-16: direção visual das onze revisões selecionadas aceita pelo dono ('aprovado, continue'). Ver visual-acceptance.json. Supera o PENDING visual anterior; demais pendências preservadas.
