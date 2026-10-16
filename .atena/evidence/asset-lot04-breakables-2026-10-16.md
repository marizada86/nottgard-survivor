# ASSET-LOT04/v01 — seis quebráveis, 30 poses

2026-10-16. Conteúdo DRAFT. Escopo planejado aprovado per-plan com "aprovo", executado IN_PLAN. [Spec e bíblia/identidades](../specs/SPEC-121-retomada-fila-imagens/asset-lot04-breakables-v01.md). S-001 a S-004 concluídas; direção visual das seis revisões selecionadas aceita pelo dono com "aprovado, commite". [Recibo por revisão/hash](../generated/asset-lot04-2026-10-16/visual-acceptance.json). Implementação com Claude, sem envio automático a outro chat. Pendências técnicas preservadas; sem promoção canônica ou admissão.

[Galeria](../generated/asset-lot04-2026-10-16/index.html), [manifesto](../generated/asset-lot04-2026-10-16/manifest.json), [medições finais](../generated/asset-lot04-2026-10-16/inspection.json), [medições iniciais](../generated/asset-lot04-2026-10-16/inspection-v01.json), [prompts exatos](../generated/asset-lot04-2026-10-16/prompts.md), [entrega local](../generated/asset-lot04-2026-10-16/ENTREGA-PARA-IMPLEMENTACAO.md).

Onze chamadas imagegen: seis fontes v01, quatro correções v02 e caixote v03. Todas com referências locais e transparent_background=true. PNGs nativos preservados e versionados. QB02/QB03/QB05/QB06 v01 encostavam nas bordas; QB02/QB05/QB06 também contaminavam células adjacentes. QB02 v02 ainda tinha 65 pixels alfa≥16 na faixa de borda; terceira tentativa eliminou o contato. Nenhuma fonte foi corrigida silenciosamente por pós-processamento.

| Candidata selecionada | Quadros | Variação base alfa≥128 | Margem mínima alfa≥16 | Alfa1..15 na sexta célula |
|---|---:|---:|---:|---:|
| QB01 v01 | 5 | 36 px | 19 px | 447 |
| QB02 v03 | 5 | 37 px | 65 px | 33 |
| QB03 v02 | 5 | 65 px | 10 px | 213 |
| QB04 v01 | 5 | 40 px | 10 px | 1664 |
| QB05 v02 | 5 | 57 px | 15 px | 422 |
| QB06 v02 | 5 | 64 px | 24 px | 224 |

Todas selecionadas 1536×1024, grade3×2, células512×512. Trinta células de conteúdo extraídas sem alinhamento/normalização, cinco hashes distintos por fonte; isso não prova qualidade de movimento. Zero pixels alfa≥16 nas faixas externas de4px e nas células extras das selecionadas. Sextas células contêm resíduos baixos: não alegar alfa0 absoluto. Alfa modal do corpo do primeiro quadro é253 em todas; sólidos não atendem opacidade estritamente255. Margem-alvo48px não atingida em cinco fontes. Base do contorno inclui destroços, não ponto de apoio semântico. Fontes aptas à revisão de direção/poses com preparação técnica pendente; nenhuma admitida em runtime.

Inspeção visual do board/contatos: candelabro perde sustentação e apaga, caixote desaba em madeira/ferragem/corda, fungo rompe e cai, saco e casulo colapsam, urna termina em cacos com luz residual. Conferir continuidade, escala e ligação com estáticos na revisão humana; caixote v03 ocupa área menor da célula. Aparência/fluidez em jogo permanecem não verificadas. Referências readonly reconferidas por SHA256.

Player real executado em DOM mínimo offline: seis instâncias/30PNG, assinatura e caminhos locais, fontes selecionadas,8FPS inicial, hold final, pausa, scrub, reinício, temporização e repetição opcional. JS passou node --check. [Relatório](../generated/asset-lot04-2026-10-16/player-check.json). Não houve verificação do render real de navegador; prévia visual via contatos PNG. Nenhum playtest realizado e nenhuma suíte de gameplay necessária para produção sem alteração de runtime.

Checklist contratual: fontes/prompts/referências/grade/poses/hashes/galeria/entrega local registrados; pendências de alfa, margens, escala, base e redução explicitadas. Sem alteração de assets oficiais, código, dados, dependências ou cânone. PLAN-103 preservado. Backlog na abertura e antes do commit:0P0,4P1 sem implementação (BUG-025/027/028/029),18 aguardando playtest,0 alertas; RTK já enabled. Aceite visual concluído; normalização/admissão/integração pertencem à frente de Claude.

Commit local autorizado pelo dono com "aprovado, commite" em 2026-10-16: entregas pendentes LOT03 e LOT04, incluindo fontes nativas ignoradas pelo padrão geral de Git, recortes/galerias, specs, estados e evidências. Réplica Git local; push/exportação não autorizados. Não confundir aceite das fontes com conclusão da preparação técnica.
