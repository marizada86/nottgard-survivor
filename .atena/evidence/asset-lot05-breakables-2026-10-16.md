# ASSET-LOT05/v01 — seis quebráveis / 30 poses

2026-10-16. DRAFT. Escopo planejado aprovado per-plan: "aprovado, por plano". Execução IN_PLAN. [Spec/bíblia/identidades](../specs/SPEC-121-retomada-fila-imagens/asset-lot05-breakables-v01.md), [estado](../state/asset-lot05-breakables.yaml). S-001..S-004 concluídas para entrega de candidatas, checkpoint OWNER_JOINT_SEQUENCE_REVIEW pendente. Implementação com Claude, sem envio automático a outro chat. PLAN-103 e outras frentes preservados.

[Galeria/reprodutores](../generated/asset-lot05-2026-10-16/index.html), [manifesto](../generated/asset-lot05-2026-10-16/manifest.json), [inspeção final](../generated/asset-lot05-2026-10-16/inspection.json), [inspeção inicial](../generated/asset-lot05-2026-10-16/inspection-v01.json), [prompts exatos](../generated/asset-lot05-2026-10-16/prompts.md), [entrega local](../generated/asset-lot05-2026-10-16/ENTREGA-PARA-IMPLEMENTACAO.md).

Oito chamadas imagegen: seis v01, correções QB08/QB12 v02. transparent_background=true, referência local específica em cada chamada. PNGs nativos copiados e preservados sem pós-processamento; frames/ são clones das células nativas para QA. Fontes e seis referências readonly verificadas por SHA256; inexistência de death nos seis destinos esperados reconfirmada antes da geração. Identidades estruturadas antes de produzir; nenhum gap BLOCKING textual. RTK já enabled, sem instalação.

| Selecionada | Quadros | Variação base alfa≥128 | Margem mínima alfa≥16 | Resíduos alfa1..15 na célula extra |
|---|---:|---:|---:|---:|
| QB07 carroça v01 | 5 | 37px | 18px | 1586 |
| QB08 carga v02 | 5 | 43px | 80px | 29 |
| QB09 lanterna v01 | 5 | 35px | 27px | 402 |
| QB10 espelho v01 | 5 | 42px | 4px | 1290 |
| QB11 estátua v01 | 5 | 32px | 13px | 62 |
| QB12 relicário v02 | 5 | 81px | 9px | 378 |

Todas1536×1024,3×2,células512×512. Trinta recortes com conteúdo e cinco hashes distintos por sequência; não é prova de movimento correto. Sexta célula excluída, sem alfa≥16, mas com resíduos baixos — não é absolutamente alfa0. Nas selecionadas, zero pixels alfa≥16 nas faixas externas de4px. QB08 v01 tinha64 pixels nessa faixa. QB12 v01 tinha483 e256 pixels de núcleo alfa≥128 na célula extra, por pontas cruzando a linha. Revisões corrigiram o contato/contaminação; todas as tentativas permanecem disponíveis. Só QB08 atinge margem-alvo48px. Sem PASS de admissão para as demais: margens e escala requerem preparação explícita.

Modal de alfa do núcleo do primeiro quadro253 em todas, não estritamente255. Resíduos fora do corpo e opacidade dos sólidos precisam de tratamento com preservação de vidro/luz/bordas. Nenhuma limpeza aplicada nesta entrega. Variação inferior do contorno não é pivô semântico; inclui queda e destroços, especialmente relicário suspenso. Prévia bruta conserva saltos para avaliação, sem alinhamento oculto.

Board final inspecionado visualmente: carroça já avariada colapsa; carga mantém barris/sacos/lona; lanterna cai com parte do poste ainda em pé; espelho conserva reflexo existente em fragmentos; estátua quebra como escultura e mantém vermelho em fissuras dos restos; relicário perde sustentação e brilho. Avaliar intensidade final da fissura da estátua e reflexo residual do espelho no aceite; nenhuma criatura, lore, loot ou novo efeito de gameplay incluído. Continuidade fina/fluidez/legibilidade em jogo não verificadas por humano.

JS passou node --check. Player real executado em DOM mínimo offline: seis instâncias,30PNG com assinatura/caminhos válidos, links para versões selecionadas,8FPS inicial, hold terminal, pausa, scrub, reinício,temporização2FPS e repetição opcional. [Relatório](../generated/asset-lot05-2026-10-16/player-check.json). Simulação offline não verifica render real de navegador; não alegar screenshot/render conferido. Nenhum playtest em jogo realizado, sem teste de gameplay para produção sem alteração de runtime.

Próximo objetivo: dono avaliar direção/poses do conjunto pela galeria; saída aceite ou retenção por código/revisão. Normalização/admissão ficam com Claude em sua frente autorizada. Conteúdo DRAFT, sem promoção canônica, alteração de assets oficiais/código/dados/dependências ou commit/push/exportação. Backlog consultado na abertura:0P0,4P1 sem implementação(BUG-025/027/028/029),18 aguardando playtest,0 alertas. Links/contrato/caminhos/hashes conferidos antes da entrega; pendências acima preservadas.

Atualização 2026-10-16: dono aprovou as seis revisões com 'aprovado, pode seguir para os proximos'. Hashes das seis fontes reconferidos; [recibo](../generated/asset-lot05-2026-10-16/visual-acceptance.json). Checkpoint visual concluído, DRAFT preservado; preparação técnica e playtest não dispensados. Próximo trabalho: inventário para proposta LOT06, sem regenerar FILA022/023 já produzidas. Sem autorização nova de commit/push.
