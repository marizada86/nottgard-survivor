# Orbe Arcano — normalização e admissão / v01

Estado: proposta DRAFT, execução pendente; modo unconfigured. PLAN-053/SPEC-121, PLAN_CHANGE_REQUEST limitada à admissão desta família existente. Preparada antes da implementação. Entradas: [recuperação/hashes](../../generated/orbe-arcano-review-2026-10-13/recovery.json), [aceite das sete fases](../../generated/orbe-arcano-review-2026-10-13/visual-acceptance.json), [bíblia/revisão](orbe-arcano-review-v01.md). Q01v03 mantém aprovação histórica do registro028; Q02–Q08v01 aceitos DRAFT. Sem promoção CANON.

## Escopo e referência visual

Oito fontes RGB1254×1254 aceitas, quatro fases de voo em loop e quatro de impacto. Núcleo compacto, anel fino/glifos circulares e cauda esfumaçada à esquerda para voo à direita; Q06 pico e Q07/Q08 fragmentação/resíduos. Vista superior plana, branco/cinza sobre preto; tinta vem do runtime. Identidade de personagem N/A: VFX abstrato compartilhado. Contexto de cena: combate isométrico, altura visual16px sobre posição projetada; ângulo da direção projetada, sem achatar o orbe como zona de chão. Bíblia ART-PROMPTS-053/FILA022, Q01v03 e aceite atual são as autoridades. Não produzir personagem, texto, lore, cenário, áudio ou habilidade novos.

Somente owner=hero, kind=bolt, dtype=magico, arma em `raio_enfraquecedor`, `dominar_pessoa`, `cajado_dos_desejos`. `dominio_da_vontade`, `memoria_alterada`, Onda Cortante e demais projéteis ficam fora da allowlist mesmo que compartilhem dtype/ícone. Preservar dano/RNG/colisão/raio, contagem/spread, velocidade/alcance, perfuração, weaken/stun, cooldown, áudio e todos os eventos.

## Proposta técnica e impacto

Godot local produzirá oito cópias1024×1024 para auditoria e dois atlas1024×256 (quatro células256×256): `assets/vfx/orbe_arcano_voo.png` e `assets/vfx/orbe_arcano_impacto.png`. Redução uniforme nativo1254→256, sem pintar, recortar ou redimensionar fases individualmente. Derivados em RGBbranco/alfa=luminânciaRec709, fundo<=2/255zero, material aditivo. Não aplicar luminância novamente em RGB. Preservar as fontes byte a byte, registrar filtro/hashes e resíduosQ08.

Defaults recomendados: voo12fps (quatro quadros em≈0,333s), impacto quatro fases0,24s. Calibrar raio do anel principal de voo≈5px e do anel principal de pico≈12px; núcleo e cauda mantêm proporções das fontes. A cauda arcana é mais longa/esfumaçada que a radiante; não encurtar nem recortar silenciosamente para igualar o rastro procedural14px. Registrar extensão luminosa resultante antes de instalar e conferir conforto em captura/playtest.

Pivô fixo comum por animação, sem correção por quadro. O anel do voo parece levemente à direita do centro do canvas aprovado; ponto inicial de medição em256px é aproximadamente(135,128), não uma coordenada já validada. Impacto começa com referência(128,128). S-001 medirá o anel geométrico, não o centro fotométrico; poderá definir uma única origem/offset por animação para pôr o anel na posição projetada do projétil/alvo, sem alterar pixels. Uma escala constante por animação. Dispersão fotométrica histórica≈2,84% não implica deslocamento do anel nem autoriza reposicionar cada quadro. Se alinhamento exigir ajustes individuais ou houver oscilação/corte/perda visual relevante, parar e apresentar derivado antes da admissão.

Reutilizar a camada aditiva já instalada `ui/radiant_orb_layer.gd`, com seleção explícita de família radiante/arcana e helper novo `core/arcane_orb_vfx.gd`. Sem renomear arquivos/UIDs nem criar um framework novo. Helper arcano pode reaproveitar utilitários existentes de validação de atlas, cache por caminho, projeção e cadência; paths/allowlist/calibração próprios. Preservar bytes dos atlas e helper RadiantOrbVfx; camada compartilhada não pode mudar seu roteamento, pivô, escala, cadência ou tintas. Uma camada para os voos e impactos, sem nó/ID/estado novo por projétil; teto combinado32impactos, sem aumentar o orçamento aceito do renderer.

`ui/overlay.gd` e `ui/run.gd` já delegam à camada; mantê-los intactos se a seleção de família couber na camada/helper, como proposto. `Battle` já fornece weapon/kind no hit primário: **nenhuma edição em core/battle.gd ou data** neste plano. Não criar impacto por miss/expiração/saída do mapa/hit secundário. Cada hit primário qualificado usa posição do alvo elevada16px e snapshot `visual_theme.impact_accent`; voo usa `visual_theme.primary`. Não duplicar partículas/áudio ou condicionar impacto ao teto de números de dano.

Recurso ausente/atlas inválido mantém apresentação procedural atual; Reduzir efeitos de impacto mantém círculo/rastro simples e sem novo flash. Pausas suspendem relógio/idade; impactos expiram, camada é liberada na transição de cena; mistura de famílias respeita teto32 sem perder eventos da simulação. Preservar Pulso, Ampulheta e demais efeitos.

## Etapas e recuperação

1. **S-001 / B-001 — Derivados e calibração.** Revalidar fontes/aceites, snapshot de hashes/backups; produzir normalizados e dois atlas, métricas de alfa/bordas/resíduos/anel/pivô/escala/cauda e prévia comparativa. Confirmar as oito fases e continuidade sem cortes; não instalar antes de PASS técnico.
2. **S-002 / B-002 — Admissão local.** Instalar atlas/helper arcano e selecionar família na camada existente. Checks: allowlist/dtype, direções/pivôs, escala/cadência/tintas, fallback/reduzido, pausa/limpeza e teto32 compartilhado; Radiante continua igual.
3. **S-003 / B-003 — Validação.** Teste focado, suíte completa e smoke9fases; capturas das três armas em eventos reais, oito direções, quatro fases de voo/retorno e quatro de impacto, duas tintas, multitiro do Cajado, weaken/stun, críticos/misses, recursos ausentes/inválidos, reduzido/pausa/fim de vida. Cena com ambas as famílias confirma despacho correto, tintas/posições e orçamento combinado. Confirmar hashes de Battle/data e de Radiante/Pulso/Ampulheta; regressões em runtime. APPDATA/save QA isolados; não usar progresso real.
4. **S-004 / B-003 — Entrega/playtest preparado.** Evidências/contrato/links/hashes/estado reconciliados; identificação de build local, roteiro e atalhos QA sem exportação. Técnico pode fechar4/4; feedback humano de legibilidade/conforto/ritmo em runtime permanece pendente.

Arquivos permitidos: dois atlas/imports, helper arcano/UID, `ui/radiant_orb_layer.gd`, teste focado/UID, ferramentas/artefatos sob `.atena/generated/orbe-arcano-admission-2026-10-13/` e registros ADD/backlog. Demais arquivos runtime protegidos por hash, incluindo core/battle.gd, data, ui/run.gd, ui/overlay.gd e helper/atlases radiantes. Se surgir necessidade fora desses caminhos, analisar impacto e checkpoint antes de executar. Backups verificáveis antes de sobrescrever; novos destinos inventariados. Recuperação restaura bytes anteriores e desfaz novas referências sem reset Git ou apagar fontes históricas. Sem dependência, geração/pintura nova, CANON, commit/push/merge, publicação ou exportação.

Modo **unconfigured**, não executável. Selecionar per-plan, per-batch (B-001/B-002/B-003) ou per-step (S-001…S-004). Aceite visual das fontes autorizou preparar esta proposta, não executar transformações ou integração.

## Prontidão e aceite

BLOCKING: aprovação do escopo/modo. RESOLVABLE: calibração de anel/pivô e preservação da cauda/glifos/resíduos em S-001, seleção de família em S-002. Defaults acima recomendados. DEFERRED: conforto/leitura/ritmo em jogo, playtests anteriores sem relato, demais famílias e bugs025/027/028/029. PLAN071 B006/S011 preservado. Não há outra pendência principal conhecida que impeça iniciar após aprovação.

Aceite técnico: oito fontes intactas, dois atlas válidos sem retângulo de fundo/cortes, anel centrado na posição lógica segundo calibração registrada, três armas estritamente selecionadas, glifos/cauda preservados, fallbacks/reduzido/pausa/limpeza e teto compartilhado corretos, nenhum efeito novo em outras armas, simulação intacta e checks PASS. Critérios subjetivos exigem avaliação do dono.

Antes de cada playtest humano, informar build/escopo/objetivo e procedimento. Roteiro a preparar: projeto local0.4.0+orbe-arcano-admission-v01 em Dagruve, perfil QA; Raio Enfraquecedor, Dominar Pessoa e Cajado dos Desejos, oito direções e pisos claros/escuros, tinta alternativa e modo reduzido. Observar orientação e estabilidade do anel, leitura dos glifos/cauda, conforto do impacto e distinção do Radiante em cena mista. Feedback esperado: arma/modo/cor/direção, aceitável ou problema em fase/voo/impacto. Atena verifica funcionamento; dono avalia sensação/diversão. Nenhum playtest humano realizado por esta proposta.

## Autorização

Dono escolheu “1. Por plano — uma aprovação para todo o escopo planejado. (Recomendado)”. Escopo v01 integral aprovado, modo per-plan; trechos anteriores de proposta/unconfigured são históricos. [Recibo](../../generated/orbe-arcano-admission-2026-10-13/authorization.json). Sem BLOCKING de aprovação.

## Resultado

Admissão local DRAFT entregue,4/4técnico no escopo per-plan aprovado. Dois atlas/três armas; suíte0falhas/smoke9fases,24capturas Arcano/misto+23de regressão Radiante. Battle/data/run/overlay e recursos radiantes intactos por hash; só a camada compartilhada mudou entre arquivos runtime preexistentes. [Evidência](../../evidence/orbe-arcano-admission-2026-10-13.md), [roteiro/atalhos](../../generated/orbe-arcano-admission-2026-10-13/PLAYTEST.md). Feedback humano runtime pendente; sem CANON ou Git.
