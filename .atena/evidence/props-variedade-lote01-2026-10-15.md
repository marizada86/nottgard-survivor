# Oito variantes estáticas — PROPS-VARIEDADE-LOTE01/v01

Aceite posterior: **“atena aprovado, commite e continue”**. As oito fontes/prévias v01 foram promovidas a CANON_VISUAL_v01 como exibidas, com métricas e ressalvas preservadas; [recibo](../generated/props-variedade-lote01-2026-10-14/owner-approval.json) e [CANON](../vault/canon/ASSET-APPROVAL-PROPS-VARIEDADE-LOTE01-v01.md). Commit local autorizado para os assets aceitos e L02 previamente aceita ainda não commitada; sem push ou integração presumidos. Parágrafos DRAFT/aceite pendente abaixo descrevem a entrega anterior.

Pedido: "atena aprovado, faça um lote maior de imagens para eu aprovar". L02 v01 da entrega anterior aceita e promovida separadamente a CANON_VISUAL, com fonte e prévias identificadas por SHA256 em `.atena/generated/fila026-l02-2026-10-14/owner-approval.json` e canon/ASSET-APPROVAL-FILA026-L02-v01.md. Novo lote apenas autorizado para produção, sem aceite presumido. Novas fontes de props permanecem DRAFT. Datas: lote/caminhos iniciados sob sessão 2026-10-14, conclusão após atualização do contexto para2026-10-15; nomes dos caminhos preservados.

Preparação anterior às chamadas: production-props-variedade-lote01-v01.md (SPEC-121) e props-variedade-lote01-production.yaml. IN_PLAN: lote de variedade de cenário ART-012/PLAN-053, modo per-plan preservado. Não alegar oito peças obrigatórias ausentes: são novas variantes opcionais das famílias existentes. Conferência prévia evitou regenerar filas já concluídas; pendências templo/jaula/canoa de ART-032 não foram inventadas sem contrato suficiente. UI U05/U06 preserva dependência de MEC-004. Backlog_check no início: quatro bugs P1 abertos,16 implementados aguardando playtest, zero P0 e alerta histórico de ART-045 duplicado. RTK já habilitado.

Prontidão visual: identidade de personagem N/A, oito props estáticos sem lore/entidade nova. Bíblia ART-PROMPTS-007: pixel art densa, câmera isométrica três-quartos cerca de30graus, luz superior esquerda, alfa verdadeiro, sem chão/sombra separada, base inferior central, alvo de12% de margem. data/scenery.json, ART-012 e SPEC-115 fundamentam os tipos/reuso. Referências oficiais v01 vistas antes da produção: braseiro, livros, velas, ossos, barril, caixote, carga e rede. Papéis explicitados como câmera/material/paleta, mudando apenas arranjo/silhueta. jobs.json contém o contrato por candidata; fontes de referência copiadas integralmente ao pacote e verificadas por hash.

Execução: skill imagegen, ferramenta built-in, oito chamadas totais, uma por candidata, nenhum retry. Prompts integrais em `.atena/generated/props-variedade-lote01-2026-10-14/prompts/`; nativos em native-sources/PV01_v01.png a PV08_v01.png e cópias idênticas em art-candidates/props-variedade-lote01/. Retornos inspecionados individualmente; referências e PNGs anteriores preservados. Nenhum agente auxiliar ou dependência nova.

| Código | Variante | Observação visual |
|---|---|---|
| PV01 | Braseiro de Dagruve | Mais baixo/largo, três apoios, argola, carvões e chama curta; brasas soltas acima entram na altura da prévia. |
| PV02 | Livros de Dagruve | Três volumes, corda e pergaminho ao lado; sem escrita aparente. |
| PV03 | Velas de Dagruve | Cinco velas de alturas diferentes em bandeja de madeira/ferro. |
| PV04 | Ossos de Dagruve | Pilha baixa com crânio lateral e costelas, sem chão ou sangue. |
| PV05 | Barril das Docas | Mais largo, tampa fechada e corda na base; madeira úmida e aros de ferro. |
| PV06 | Caixote das Docas | Baixo/largo com reforços e corda; rachaduras visíveis na tampa precisam de avaliação de desgaste. |
| PV07 | Carga das Docas | Dois sacos e um rolo de tecido, sem loot adicional. |
| PV08 | Rede das Docas | Dobras e cordas variadas, boias e madeira/ferro da família original. |

Preparação em prepare_previews.gd: crop de alfa não zero, sem threshold/limpeza/retoque; escala proporcional nearest para256×256, maior dimensão224 e margem mínima16; amostras64/128; referências normalizadas pelo mesmo método e prancha de oito candidatas. Alfa original preservado, inclusive emissivos/partículas. Fonte não alterada. A normalização é para comparação visual, não valida escala física, colisão, âncora ou integração no mapa. Prancha final inspecionada.

Auditoria audit_delivery.py: oito nativos1254×1254, alfa com fundo0 e conteúdo visível, zero pixels alfa≥128 nas bordas externas, referências arquivadas idênticas e cópias das candidatas idênticas por hash. PNGs/prévias decodificáveis;42 referências locais da galeria válidas. Conferência técnica de entrega PASSED. Alvo de margem nativa12% não atendido em PV02/PV03/PV05/PV06/PV07/PV08, explicitamente sinalizado nas respectivas fichas. Não equivale a corte detectado ou falha escondida por retoque; fontes completas continuam disponíveis e métricas são preservadas no audit.json. Contrato visual completo e qualidade subjetiva aguardam dono.

L02: novo recibo de aceite confere hash da fonte e mantém prompt de teclado/controle/toque intacto; auditoria de L02 atualizada para CANON_VISUAL sem admissão. Recibos de produção anteriores continuam históricos; promoção de L02 não aprova as oito variantes novas.

Nove etapas encerradas; checkpoint OWNER_VISUAL_REVIEW. Entrega `.atena/generated/props-variedade-lote01-2026-10-14/index.html`, oito fontes, oito prompts, referências, prévias e audit.json. Próximo objetivo preparado: dono avaliar PV01–PV08, indicar códigos aceitos ou defeitos objetivos; só depois correção/admissão com escopo correspondente. Heróis permanecem em prioridade reduzida, sem geração de movimento. Sem runtime/novo teste de jogo, assets/ oficiais, data/, código de gameplay, CANON dos props, commit, push, merge ou exportação.
