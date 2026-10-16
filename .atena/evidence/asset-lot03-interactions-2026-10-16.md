# ASSET-LOT03/v01 — produção de seis folhas de interações

2026-10-16. DRAFT v01, direção visual das seis sequências aceita pelo dono: "aprovado, deixe a implementação para o claude, continue a produção". [Recibo](../generated/asset-lot03-2026-10-16/visual-acceptance.json), hashes reconferidos. Dono autorizou "aprovado por plano" após proposta de seis animações/29 quadros. Execução IN_PLAN, seis chamadas imagegen, uma por sequência, sem retries. Fontes PNG com transparent_background=true e referências locais anexadas; [prompts exatos](../generated/asset-lot03-2026-10-16/prompts.md). Referências e hashes preservados, identidades/mini bíblia/contexto em [spec](../specs/SPEC-121-retomada-fila-imagens/asset-lot03-interactions-v01.md). Implementação com Claude, sem envio automático a outro chat.

S-001 a S-004 concluídas: contrato/referências, produção, inspeção/QA, galeria/manifestações/entrega. [Galeria conjunta](../generated/asset-lot03-2026-10-16/index.html), [manifesto](../generated/asset-lot03-2026-10-16/manifest.json), [inspeção pixel a pixel](../generated/asset-lot03-2026-10-16/inspection.json), [entrega local](../generated/asset-lot03-2026-10-16/ENTREGA-PARA-IMPLEMENTACAO.md).

| Sequência | Fonte/células nativas | Quadros | Variação inferior de contorno alfa≥128 |
|---|---|---:|---:|
| IA01 baú comum | 1536×1024 / 512×512 | 6 | 22 px |
| IA02 baú de chefe | 1536×1024 / 512×512 | 6 | 33 px |
| IA03 loja | 1254×1254 / 627×627 | 4 | 1 px |
| IA04 ferreiro | 1254×1254 / 627×627 | 4 | 8 px |
| IA05 curandeiro | 1254×1254 / 627×627 | 4 | 2 px |
| IA06 barril | 1536×1024 / 512×512 | 5 | 36 px |

São 29 células de conteúdo extraídas em sua geometria nativa, todas não vazias; zero pixels alfa≥16 nas faixas externas de 4 px das células. Não foi atribuído PASS completo de alinhamento ou material. IA06 sexta célula tem zero alfa≥16 e 1962 resíduos alfa1..15; não é totalmente alfa zero, e foi excluída da sequência. Fontes originais intactas. Hashes das células são distintos, o que só exclui cópias byte-idênticas, não prova qualidade ou fluidez de movimento.

Modal de alfa no conteúdo≥128 do primeiro quadro: 253 para as seis fontes. IA01/IA02/IA06 primeiro quadro não contém pixels estritamente alfa255; o conteúdo predominante continua próximo de opaco, não totalmente opaco conforme o alvo. Alfa/ruído exigem preparação cuidadosa e preservação de vapor/luz antes da admissão. Desvios de base e proporção/escala das fontes também ficam retidos para normalização; prévia bruta não os corrige. Não esconder esses defeitos ao pedir avaliação da direção visual.

Inspecionados os seis contatos PNG e board conjunto. Baús mostram abertura, NPCs têm pequenas mudanças de pose e barril termina como entulho. Padrões de mãos, ferramentas, base e props devem ser avaliados pelo dono na reprodução; não declarar anatomia ou continuidade perfeitas por automação. IA01 revela moedas somente nas poses finais; continuidade desse interior requer revisão. Frame4→1 dos idles pode ser julgado no reprodutor, ainda não aceito por humano.

Reprodutores HTML: pausa/reproduzir, reinício, scrub por quadro, FPS2/4/8/10/12 e repetição opcional; transições padrão mantêm último quadro e idles repetem. JS verificado por node --check. [Smoke offline](../generated/asset-lot03-2026-10-16/player-check.json) executou o player real com DOM mínimo e validou seis instâncias, 29 PNGs, links para fontes, 8FPS inicial, hold final, wrap dos idles, pausa, scrub, replay e temporização a2FPS. Não é inspeção de render real do navegador. Tentativa de abrir pelo adaptador CUA falhou na inicialização ("failed to write kernel assets ... os error 3"); nenhum estado de navegador foi observado, sem alegação de captura de tela. Contatos foram vistos via arquivos PNG. Nenhum playtest em jogo realizado.

Checkpoint OWNER_JOINT_SEQUENCE_ACCEPTANCE_RECORDED. Normalização/admissão/integração permanecem sob escopo da frente de Claude, conforme confirmação do dono; pendências técnicas preservadas. Próximo objetivo de produção: propor ASSET-LOT04 com seis quebráveis/30 poses. Conteúdo DRAFT; sem promoção canônica, mudança de assets oficiais/código/dados/dependências, commit/push/exportação. Links, caminhos, fontes e referências conferidos. Não rodar suíte de gameplay por ausência de mudança de runtime. Backlog consultado: 0P0, 4P1 sem implementação, 18 aguardando playtest, zero alertas; RTK já enabled.
