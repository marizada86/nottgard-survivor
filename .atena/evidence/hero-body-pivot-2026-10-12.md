# Erik e Arlindo — corpo/pivô, 2026-10-12

PLAN-053/SPEC-121 S-007 (posição 7/7 do plano maior), DEV-024/v03/body-pivot-v01. Continuação IN_PLAN **“atena, continuar a fila de assets”**, na rota de preparação já aprovada por plano. [Contrato anterior à transformação](../specs/SPEC-121-retomada-fila-imagens/hero-body-pivot-v01.md). Preparação SOURCES_LANDMARKS/PREPARE/AUDIT concluída (3/4); GALLERY_GATE atual (4/4), aceite humano pendente. Nada disso fecha todo o S-007 da fila.

Onze tiras candidatas v02, sessenta células 256×384, fontes e extrações originais preservadas. Godot 4.7.2 realizou limpeza de traços <=8/255 apenas no derivado, recorte, Lanczos proporcional, escala única por tira e encaixe baseado em cintura/sola. Python somente lê matrizes e grava JSON/HTML. O topo corporal de Erik foi refinado por regiões de cabelo que excluem chama/pomo, após inspeção das extrações; ensaio inicial e suas marcações preservados separadamente. Arlindo usa topo do chapéu. Marcadores anatômicos aproximados e revisão modelada não provam identidade/qualidade artística aceita por humanos.

Referência de altura: 290 px Arlindo, 300 px Erik conforme ART-PROMPTS-060; o 290 genérico para Erik no préflight histórico não foi aplicado. Corpo mediano aferido em raster com faixa anatômica; limite de variação 12 px. Base raster 367/368, ancoragem geométrica y=368; interpolação pode limpar o último pixel de contorno. Margens significativas >=10 px, sem alfa residual 1–8/255 no derivado. Atlas recompõe exatamente as sessenta células; fontes/RGB não foram repintados, não houve zoom por quadro, nem correção da passada cancelada.

| Tira | Corpo mediano px | Variação px | Resultado |
|---|---:|---:|---|
| AO02 | 290.0 | 2 | REVISÃO VISUAL |
| AO03 | 290.0 | 11 | REVISÃO VISUAL |
| AO04 | 290.0 | 14 | RETIDA: BODY_SPREAD_OVER_12_PX |
| AO05 | 290.0 | 6 | REVISÃO VISUAL |
| AO06 | 290.0 | 4 | REVISÃO VISUAL |
| AO07 | 290.0 | 13 | RETIDA: BODY_SPREAD_OVER_12_PX |
| AO08 | 176.5 | 1 | RETIDA: SIZE_CONFLICT_WITH_BODY_TARGET, BODY_MEDIAN_OUTSIDE_3_PERCENT |
| ER02 | 300.0 | 1 | REVISÃO VISUAL |
| ER04 | 301.0 | 5 | REVISÃO VISUAL |
| ER05 | 300.5 | 10 | REVISÃO VISUAL |
| ER07 | 300.5 | 10 | REVISÃO VISUAL |

Oito candidatas satisfazem os critérios técnicos medidos; aparência, massa, mão da tocha, continuidade de figurino/passada e leitura a 85 px permanecem critérios humanos. AO04 e AO07 excedem a variação corporal; não houve aceite automático de 14/13 px. AO08 não cabe com efeito/corpo na mesma célula mantendo o alvo: candidata diagnóstica mede 176,5 px versus 290. Continua retida; não cortar o efeito, esticar personagem, admitir redução ou ampliar célula silenciosamente. Recomendar decisão futura entre separar o efeito e redefinir canvas/contrato, com novo escopo antes de executar. Nenhuma nova geração ou tentativa de recuperar pixels ausentes.

ER03/ER06 e AO09/AO10/ER08/ER09/ER10 seguem retidas pelas decisões anteriores de contagem/corte/separação. Retratos não foram alterados. Corpo/pivô resolveu apenas a preparação das onze tiras extraíveis. A fila VFX antiga N03 foi verificada como histórica e superada: FILA-022 36/36, FILA-023 60/60 e FILA-027 20/20 no inventário local cf17d7c; não gerar supostas faltantes daquele cursor.

[Galeria com prévias animadas e células](../generated/hero-body-pivot-2026-10-12/index.html), [prancha v02](../generated/hero-body-pivot-2026-10-12/v02/body-pivot-board.png), [auditoria](../generated/hero-body-pivot-2026-10-12/audit.json), [manifesto/marcações](../generated/hero-body-pivot-2026-10-12/manifest.json), [registro Godot](../generated/hero-body-pivot-2026-10-12/v02/preparation.json). Todas as onze tiras finais v02 inspecionadas nativamente; links locais conferidos. Galeria HTML criada, sem afirmar execução/teste dos controles no navegador file:// bloqueado por política. Aviso preexistente de certificados do Godot não impediu a geração; não houve novo erro de script.

Auditoria estrutural passou: vinte fontes e sessenta extrações por hash, runtime/ativos anteriores por snapshot, HEAD e índice vazio preservados; cauda anterior de plan.yaml e retorno PLAN-071 preservados. Nenhuma edição de assets/, ui/, core/ ou data/, nenhuma integração/CANON/commit/push/export. Não repetir suíte do jogo: só candidatos locais e registros mudaram. Conteúdo DRAFT e aceite visual PENDING. Próximo objetivo: revisão concreta das oito candidatas; tratar conflitos/tiras restantes em checkpoint próprio.

## Aceite do dono

Em 2026-10-12: **“Aprovo visualmente as oito candidatas v02”**. Aceite exclusivamente de AO02/AO03/AO05/AO06/ER02/ER04/ER05/ER07 normalizadas v02; [recibo/hashes](../generated/hero-body-pivot-2026-10-12/visual-acceptance.json). Lote de preparação 4/4 concluído parcialmente aceito, conteúdo DRAFT mantido conforme pergunta. Não é promoção CANON ou integração. AO04/AO07/AO08 e as sete retidas anteriores não foram aceitas. Próximo trabalho independente previsto na rota existente: avaliar separação por máscaras das cinco ações; nada será regenerado ou admitido por este aceite.
