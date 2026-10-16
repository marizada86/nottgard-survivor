# FILA030-PREPARATION/v01

Estado: DRAFT. Origem: planned; implementation_preceded_spec: false.
Pedido: "atena continue", 2026-10-15. Classificação: IN_PLAN para planejar o próximo objetivo registrado em FILA030-GENERATION/v01; execução da nova preparação requer aprovação deste escopo.
Modo proposto mantido: per-plan, conforme escolha do dono nesta frente. Não repetir seleção de nível; confirmar somente o novo escopo.

## Entradas e prontidão

Autoridade visual: [ART-PROMPTS-063 r1](../../generated/ART-PROMPTS-063-nevoa-de-borda-e-frente-da-mare.md), com [aceite visual das fontes v01 e hashes](../../generated/fila030-review-2026-10-15/visual-acceptance.json).
Fontes: [NB01 v01](../../generated/art-candidates/nevoa-mundo/NB01_v01.png), 2172×724; [NB02 v01](../../generated/art-candidates/nevoa-mundo/NB02_v01.png), 2097×750. Aceite da direção visual não é aprovação técnica, promoção canônica ou admissão em runtime. Commit das fontes e registros: 2c91741a.
Mini bíblia: pixel art com dither; névoa rasteira horizontal NB01 e frente conectada com crista NB02; base densa, alto vazio, branco/cinza convertido para alfa. Tonalidade fica no consumer. Identidade de entidade N/A: texturas ambientais sem personagem. Cena textual: perigo nas bordas do mundo e Maré pós-chefe; preservar leitura de combate. Referências locais, sem anexos ou lore nova. Fontes e derivadas permanecem DRAFT.

BLOCKING visual: nenhuma lacuna para este ensaio de preparação. Checkpoint obrigatório: aprovação do novo escopo antes de produzir derivadas.
RESOLVABLE: avaliar achatamento, emenda e perda de detalhe nas prévias; ajustar parâmetros limitadamente, mantendo fontes intactas.
DEFERRED: admissão em assets, consumers, desempenho/renderização em jogo, playtest humano, cânone e publicação.

## Escopo proposto

Produzir apenas duas derivadas técnicas versionadas em `.atena/generated/fila030-preparation-2026-10-15/v01/`, com script reproduzível, manifesto, métricas e galeria. Usar runtime e bibliotecas já disponíveis, sem instalar dependências. Não regenerar a direção visual nem substituir fontes.

- NB01: saída 1536×384. Ajustar dimensão com nearest-neighbor, preservar perfil rasteiro; converter luminância Rec.709 para alfa com RGB constante branco-acinzentado. Descartar somente ruído de fundo até 2/255, registrando limiar. Alto de 128 px transparente. Suavizar costura somente nas laterais com banda inicial de até 64 px, média simétrica com peso decrescente; exigir colunas de alfa externas idênticas. Nunca emendar topo com base.
- NB02: saída 1280×360. Mapear o conteúdo da névoa para a região abaixo do quarto superior (90 px vazios), mantendo crista inteira e base no fundo; registrar caixa de conteúdo e transformação exata, sem cortar volutas. Converter alfa pela mesma luminância e limpar ruído até 2/255. Atenuar pontas na faixa externa de 8% da largura até alfa zero nas colunas extremas. Não impor repetição horizontal a esta peça.
- Prévia de cada derivada sobre fundo escuro, claro e quadriculado; NB01 repetida 3×1 e 3×3 para inspeção (somente repetição horizontal é requisito); NB02 a 80 e 360 px de profundidade. Comparar direção da fonte e derivada lado a lado.

## Etapas e critérios

1. S-001 — entradas/contrato/retorno: concluída por leitura e proposta. Ferramenta existente `tools/prepare_pending_fog_texture.gd` conferida; não executar diretamente porque também costura verticalmente e usa outra fonte.
2. S-002 — preparar duas derivadas, script e manifesto. Confirmar hashes originais antes/depois; saída somente em generated/evidence e registros desta frente.
3. S-003 — conferir PNGs RGBA8, dimensões exatas, RGB constante, faixa superior alfa zero, lados NB01 idênticos e lados NB02 alfa zero; validar links e inspecionar todas as prévias. Métricas não substituem aceite visual. Se a preparação alterar demais a aparência, reter como candidata com defeito documentado; não aprovar automaticamente.
4. S-004 — apresentar galeria e registrar evidência/estado; parar no gate humano das derivadas v01. Sem aprovação implícita por resultado técnico.

Plano termina no pedido de aceite das derivadas. Próximo objetivo, só após esse gate: propor escopo separado de admissão e integração na SPEC-158.

## Limites e recuperação

Sem alterações em assets oficiais, ui/, core/, data/ ou configuração do jogo. Sem nova geração de imagens, dependências, commit, push, merge, exportação ou cânone. Recuperação: preservar todas as fontes e criar nova revisão das derivadas, sem sobrescrever saídas existentes.
Retorno PLAN-103: B-004/R3_PROPOSAL_AWAITING_G-M3-3; checkpoints paralelos B-002/S-008 e B-003 preservados. Preparação não reabre a geração já concluída nem substitui o plano ativo.
Backlog consultado em 2026-10-15: 0 P0, 4 P1 sem implementação, 18 P1 aguardando playtest, 0 alertas. RTK enabled já registrado.
