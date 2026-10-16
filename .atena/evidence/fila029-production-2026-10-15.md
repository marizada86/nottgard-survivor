# FILA029-PRODUCTION/v01 — B01

Estado: DRAFT, fonte B01 v03 aceita visualmente. Aprovação do plano: dono respondeu "prossiga atena" à proposta explícita de uma B01 em modo per-plan. Aceite da direção visual: "aprovado, faça lotes maiores para aprovação", em 2026-10-15, com [recibo](../generated/fila029-production-2026-10-15/visual-acceptance.json). Pedido classificado IN_PLAN durante a execução; implementação a cargo de Claude, conforme instrução do dono. Nenhum envio automático a outro chat.

S-001 a S-004 concluídas. Três referências existentes inspecionadas, papéis/hashes registrados; nenhuma lacuna visual relevante. Família de aço da aba prevalece sobre o dourado das referências secundárias, conforme prompt específico. Identidade de entidade N/A: peça de UI. Cena textual do Quartel, mini bíblia e autoridade em [spec](../specs/SPEC-121-retomada-fila-imagens/fila029-production-v01.md).

Produção com imagegen integrada, três chamadas: v01 inicial, v02 corrigindo contato das pontas com bordas, v03 reduzindo variação do preenchimento interior. Prompts completos em [prompts.md](../generated/fila029-production-2026-10-15/prompts.md). Três PNGs originais preservados em art-candidates/botao-acao; nenhuma normalização final realizada.

| Revisão | Nativa | Contorno detectado | Contato com bordas | Variação central de luminância |
|---|---|---|---|---|
| v01 | 2172×724 | 2172×375 | 12 pixels | 19,79/255 (7,76%) |
| v02 | 2172×724 | 2047×345 | zero | 21,93/255 (8,60%) |
| v03 | 2172×724 | 2046×346 | zero | 3,28/255 (1,29%) |

Região medida: x20..80%, y30..70% da caixa detectada por classificação magenta ampla. [Inspeção e SHA-256](../generated/fila029-production-2026-10-15/inspection.json). v03 não atende literalmente ao pedido de RGB 27..33 (máximo de luminância 36,21), mas a variação medida atende ao teto de 6% da escala completa no centro amostrado integralmente. Sem alegação de uniformidade de todo o interior, corte pixel-exato ou ausência de halo fino. Margem lateral da v03 de cerca de 62 px, abaixo dos 4% pedidos na edição, porém sem contato com bordas. Proporção do contorno ~5,91:1, divergente da final 5:1; preparação/admissão permanece pendente.

[Galeria](../generated/fila029-production-2026-10-15/index.html) e [entrega local para Claude](../generated/fila029-production-2026-10-15/ENTREGA-PARA-IMPLEMENTACAO.md). Prévias da v03 inspecionadas: recorte diagnóstico preservando proporção (320×54) e ajuste a 320×64. São imagens de QA com magenta, sem alfa definitivo nem nove fatias. Não são implementação ou aceite em escala real no jogo.

Checkpoint: OWNER_SOURCE_ACCEPTANCE_RECORDED. Implementador deve confirmar plano de normalização/admissão e cumprir testes em jogo. Gate humano do Quartel desktop/mobile permanece pendente. Próximas revisões visuais agrupadas em lotes maiores conforme pedido do dono; padrão operacional de 6 a 8 peças prontas por família, sem alterar os níveis de aprovação dos planos nem gerar variações artificiais. Sem promoção canônica ou runtime, sem alterações em assets oficiais/código/dados, sem commit/push/exportação. Referências preservadas, links/arquivos/hashes verificados. Suíte do jogo não executada por ausência de alteração de runtime. Backlog consultado: 0 P0, 4 P1 sem implementação, 18 P1 aguardando playtest, 0 alertas.
