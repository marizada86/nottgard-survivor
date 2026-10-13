# Revisão de extração dos heróis — 2026-10-11

Pedido: “atena continue a geração de imagens”. Classificação IN_PLAN na retomada operacional da fila aprovada; PLAN-071 preservado. PLAN-053/SPEC-121, etapa 7/7, DEV-024/v03, conteúdo DRAFT.

O caminho histórico da worktree 20f4 não existe nesta sessão. O snapshot local de 20 fontes é a entrada efetiva, com todos os SHA256 conferidos contra o manifesto. Não se recriou história nem se substituíram as primeiras tiragens selecionadas. A correção de passada cancelada continua cancelada.

Onze tiras inspecionadas visualmente. Projeção do alfa >8 orientou retângulos irregulares, em vez de uma grade uniforme presumida. AO02, AO05, AO06, AO08, ER02 e ER07 foram extraídas pelo Godot 4.7.2 em 30 quadros nativos. Todas as matrizes RGBA coincidem com os retângulos originais; concatenar os quadros recompõe cada fonte integralmente. Zero pixels descartados ou repintados; alfa baixo preservado. As extrações históricas foram verificadas por hash.

AO09, AO10, ER08, ER09 e ER10 não receberam derivados: os limites retangulares candidatos cruzam pixels significativos de efeitos ou poses. Isso impede afirmar separação segura por retângulos, mas não prova que uma máscara não retangular seja impossível. ER03 mantém sete poses candidatas e ER06 o corte de fonte no quadro 6. Não houve nova geração de herói, escala, pivô, promoção CANON ou admissão runtime.

Saídas: [auditoria](../generated/hero-normalization-2026-10-10/extraction-review-v01.json), [galeria](../generated/hero-normalization-2026-10-10/extraction-review.html), [estado](../state/hero-extraction-review-2026-10-11.yaml). O script Python apenas lê matrizes e escreve JSON/HTML; as imagens são extraídas em Godot. A execução do Godot confirmou 30 saídas; avisos sobre certificados e gravação de preferências fora do workspace não impediram os arquivos, conferidos independentemente.

Próximo objetivo dos heróis: referências de cabeça/pés para onze tiras extraíveis (cinco anteriores e seis novas), verificar limites de escala com efeitos, e avaliar máscaras das cinco retidas. A aprovação por plano continua vigente; aceite artístico e decisões ER03/ER06 precedem integração.

Nova geração independente disponível na fila: PLAN-065/SPEC-132 aprovado por plano em 2026-10-06; FILA-025 entregue e aceita. L01 é o primeiro passo executável da FILA-026. Gerar uma candidata DRAFT e parar no G1 antes das outras peças não atravessa os gates dos heróis. Referências do lettering são materiais/paleta, identidade de personagem N/A: logotipo sem entidade. Nenhum commit, push ou integração autorizado pelo pedido de continuação.
