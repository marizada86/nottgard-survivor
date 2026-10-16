# ASSET-LOT04 — seis quebráveis / 30 poses

DRAFT. Produção autorizada por plano em 16/10/2026 ("aprovo"). Direção visual das seis candidatas abaixo aceita pelo dono em 16/10/2026: "aprovado, commite". [Recibo](visual-acceptance.json). Preparação técnica permanece pendente. Implementação atribuída a Claude; entrega local, sem envio a outro chat e sem admissão em runtime.

| Código | Referência | Fonte selecionada | Quadros |
|---|---|---|---:|
| QB01 | candelabro_quebravel | [v01](../animation-candidates/asset-lot04/QB01_v01.png) | 5 |
| QB02 | caixote_quebravel | [v03](../animation-candidates/asset-lot04/QB02_v03.png) | 5 |
| QB03 | arbusto_quebravel | [v02](../animation-candidates/asset-lot04/QB03_v02.png) | 5 |
| QB04 | saco_de_esporos_quebravel | [v01](../animation-candidates/asset-lot04/QB04_v01.png) | 5 |
| QB05 | casulo_viscoso_quebravel | [v02](../animation-candidates/asset-lot04/QB05_v02.png) | 5 |
| QB06 | urna_funeraria_quebravel | [v02](../animation-candidates/asset-lot04/QB06_v02.png) | 5 |

Todas as fontes selecionadas: 1536×1024, grade 3×2, células nativas 512×512. Ordem esquerda→direita, linha superior→inferior; excluir a sexta célula. `frames/` contém recortes exatos de QA, sem correção de pixels, pivô ou escala. Não são tiras finais. [Galeria](index.html), [manifesto](manifest.json), [medições](inspection.json), [prompts exatos](prompts.md), [checagem do player](player-check.json).

## Preparação necessária

- As revisões corrigiram contato com a grade: zero pixels alfa≥16 nas faixas externas de 4 px das 36 células selecionadas. Isso não garante a margem-alvo de 48 px: fontes continuam com folga menor e escalas diferentes. Não impor redução global antes de medir legibilidade no tamanho de jogo.
- A sexta célula não possui alfa≥16, mas contém resíduos alfa1..15. Não é totalmente transparente. Excluir da animação, sem inventar desaparecimento.
- Corpo sólido tem alfa modal próximo de 255, não estritamente 255. Limpar resíduos e preparar opacidade com cuidado, preservando fogo, veios luminosos, bordas e aberturas. Nenhuma normalização foi aplicada às fontes.
- Variação da base do contorno alfa≥128: QB01 36 px; QB02 37 px; QB03 65 px; QB04 40 px; QB05 57 px; QB06 64 px. Inclui destroços e queda intencional; não equivale a pivô semântico. Anotar contato do objeto e alinhar sem recentralizar fragmentos separadamente.
- Conferir a ligação estático→primeiro quadro e a continuidade de peças entre poses. Caixote v03 ficou menor na célula que os demais; revisar escala. QB01 termina com velas apagadas; QB03 preserva identidade fúngica; QB04 mantém bolsas internas; QB05 mantém rochas; QB06 termina em cacos com luz residual. Não acrescentar criaturas, loot, dano ou lore.

Destinos esperados, a confirmar na frente de admissão: `assets/animations/enemies/<id>/death.png`, perfil D de cinco quadros do PLAN-041. Confirmar consumer `ui/enemy_view.gd`, tamanho de célula final, pivô, importação, duração e estado final antes de integrar. Não substituir os estáticos automaticamente. Versões anteriores permanecem preservadas; não usar QB02 v01/v02 nem QB03/QB05/QB06 v01 como fontes finais por contato/contaminação da grade.

Os controles 2/4/8/10/12 FPS são de inspeção. As seis rupturas mantêm o último quadro, repetição opcional para comparação. Lógica e caminhos verificados em simulação DOM offline; render do navegador não verificado. Contatos PNG inspecionados. Aceite de direção visual, preparação técnica, admissão e playtest são estados distintos. Nenhum teste em jogo realizado; explicar escopo/procedimento/critérios antes do playtest futuro.
