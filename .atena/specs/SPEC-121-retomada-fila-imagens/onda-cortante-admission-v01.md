# Onda Cortante — normalização e admissão / v01

Estado: proposta DRAFT, execução pendente; modo unconfigured. PLAN-053/SPEC-121, PLAN_CHANGE_REQUEST limitada à admissão visual desta família. Preparada antes de implementação. Entradas: [fontes/hashes](../../generated/onda-cortante-review-2026-10-13/recovery.json), [aceite visual](../../generated/onda-cortante-review-2026-10-13/visual-acceptance.json) e [bíblia/revisão](onda-cortante-review-v01.md). R01v02 aprovado historicamente; R02/R03/R04/R06/R07/R08v01 e R05v02 aceitos DRAFT. Nenhuma promoção CANON.

## Escopo e prontidão visual

Oito fontes RGB1254×1254, quatro voos em loop e quatro impactos. Identidade de personagem N/A: VFX abstrato compartilhado por Lâmina Trovejante e Tempestade. Bíblia ART-PROMPTS-053/FILA022 e R01v02 são as referências; aceite atual fecha sete demais fases. Crescente fino que avança para direita com pontas para esquerda e raios angulares pequenos junto à borda direita. Impacto compactoR05v02, picoR06, fragmentosR07 e resíduosR08, sem lâmina inteira no impacto. Vista superior plana, branco/cinza sobre preto para receber tinta em jogo; sem personagem, arma, texto, cenário, lore ou áudio novos. Contexto: projétil elevado16px em combate isométrico; rotação pela direção projetada, sem achatamento de zona de chão.

Somente owner=hero, kind=bolt, dtype=magico e arma em `lamina_trovejante`, `tempestade`. Excluir Lâmina de Sombra, outros mágicos/ícones compartilhados, inimigos e habilidades. Preservar raio lógico0,4, dano/RNG/status/colisão, alcance10/12, velocidade13/15, pierce3/6, count1/4, spread e cooldowns efetivos, inclusive níveis e modificadores. Nenhum gameplay novo.

## Proposta técnica e calibração

Godot local produzirá oito cópias1024×1024 para auditoria e dois atlas1024×256 (quatro células256×256): `assets/vfx/onda_cortante_voo.png` e `assets/vfx/onda_cortante_impacto.png`. Redução uniforme do canvas nativo1254→256, sem redimensionar/recentrar fases individualmente, redesenhar ou recortar pontas/raios. RGB branco/alfa luminânciaRec709; piso<=2/255zero somente no derivado; material aditivo. Não aplicar luminância em RGB e alfa simultaneamente. Preservar fontes byte a byte; registrar filtro, hashes, margens e resíduosR08.

Defaults recomendados: voo12fps, loop quatro quadros≈0,333s; impacto quatro fases0,24s. Calibrar altura principal do crescente≈18px, ignorando raios decorativos externos para essa medida; impacto principal do pico≈12px de raio. A silhueta é uma lâmina e requer calibração própria, em vez de usar raio de núcleo/anel dos orbes. Manter proporções e finura aceitas; legibilidade real dessa escala será inspecionada e testada, não presumida.

Pivô inicial do canvas(128,128); S-001 medirá a silhueta principal de R01 e o corpo de R06 para definir uma origem e escala fixas por animação. Permitido um único offset por animação para alinhar referência geométrica com a posição projetada do projétil/alvo, sem alterar pixels; não usar centro fotométrico como pivô geométrico nem corrigir quadro individualmente. Registrar método e dimensões finais. Se continuidade/finura exigirem mudança artística ou ajustes individuais, parar e apresentar derivado antes da admissão. Q/R não compartilham desenho ou calibração apenas por terem dtype=magico.

## Integração limitada

Helper novo `core/cutting_wave_vfx.gd` e terceira seleção explícita de família na camada existente `ui/radiant_orb_layer.gd`. Reusar utilitários/cache por caminho/projeção/cadência de RadiantOrbVfx sem editar helpers/atlases radiantes ou arcanos. Sem renomear arquivos/UIDs, framework novo ou nó/ID/estado por projétil. Preservar orçamento combinado **32 impactos** entre as três famílias; mesma pausa/expiração/remoção com a run.

Hooks em overlay/run e metadados weapon/kind de hit já existem; **não alterar `core/battle.gd`, `ui/run.gd`, `ui/overlay.gd` ou data** neste plano. Somente hits primários qualificados, inclusive perfuração real, mostram impacto; miss/expiração/saída do mapa/hits secundários não geram novo atlas. Preservar snapshot `visual_theme.primary` no voo e `impact_accent` no hit, posição elevada16px, ordem/dano/áudio/partículas existentes e independência do limite de números de dano.

Ausência/atlas inválido mantém círculo/rastro procedural anterior. Reduzir efeitos conserva apresentação simples e ausência de novo flash. Despacho por arma/dtype deve impedir troca entre Onda/Arcano/Radiante. Não aumentar orçamento visual nem perder eventos de simulação quando o teto visual for alcançado. Pulso/Ampulheta e demais famílias ficam intactos.

## Etapas, caminhos e recuperação

1. **S-001 / B-001 — Derivados e prévia.** Revalidar aceites/hashes e fazer backups/proteção de runtime. Produzir normalizados/atlas e relatório de alfa/bordas/resíduos/silhueta/pivôs/escalas; comparar voo e impacto, conferir pontas/raios e loop. Sem instalar antes de PASS técnico.
2. **S-002 / B-002 — Admissão local.** Instalar dois atlas/helper e selecionar a terceira família na camada. Checks de allowlist/dtype, direções, calibração/tintas/cadência, fallback/reduzido, pausa/limpeza e teto combinado32; dois orbes preservados.
3. **S-003 / B-003 — Verificação.** Teste focado, suíte completa e smoke9fases. Capturas das duas armas em disparos/hits reais: oito direções, voo de quatro fases/retorno e impacto de quatro, duas tintas, quatro projéteis da Tempestade, pierce/misses/críticos, expiração, ausência/invalidade de recurso, reduzido/pausa/limpeza. Cena com as três famílias confirma despacho/tintas/calibração e orçamento compartilhado. Regressão dos orbes/Pulso/Ampulheta; hashes de Battle/data/run/overlay/helpers/atlases existentes iguais. APPDATA/save QA isolados.
4. **S-004 / B-003 — Entrega e playtest preparado.** Contrato, links, hashes, estados e evidências reconciliados; build local identificado, roteiro/atalhos QA sem exportação. Técnico pode concluir4/4; conforto/leitura/ritmo em runtime permanece pendente até relato do dono.

Arquivos permitidos: dois atlas/imports; helper CuttingWaveVfx/UID; `ui/radiant_orb_layer.gd`; teste focado/UID, ferramentas/artifacts sob `.atena/generated/onda-cortante-admission-2026-10-13/`; registros ADD/backlog. Demais runtime protegidos por hash, incluindo Battle, data, run/overlay, helpers/atlases/testes dos orbes, Pulso/Ampulheta e heróis. Se surgir necessidade fora do escopo, analisar impacto/checkpoint antes de executar. Backups verificáveis antes de sobrescrever; novos destinos inventariados. Recuperação restaura bytes da camada e remove novas referências sem reset Git nem apagar fontes históricas. Sem dependências, geração/pintura nova, CANON, commit/push/merge, publicação ou exportação.

Modo **unconfigured**, não executável: escolher per-plan; per-batch com B-001/B-002/B-003; ou per-step com S-001…S-004. Aceite visual autorizou preparar esta proposta, não transformar ou integrar as imagens.

## Prontidão e aceite

BLOCKING: aprovação do escopo/modo. RESOLVABLE: calibração da silhueta/finura/pivô e preservação de raios/resíduos em S-001, terceiro despacho em S-002. Defaults18px/12fps/0,24s recomendados. DEFERRED: legibilidade/intensidade/ritmo humanos, playtests anteriores sem relato, demais filas e bugs025/027/028/029. PLAN071/B006/S011 preservado. Nenhuma outra pendência principal conhecida impede iniciar após aprovação.

Aceite técnico: fontes intactas, dois atlas válidos sem cortes/retângulo de fundo, crescente orientado corretamente/impacto centrado pela calibração registrada, duas armas somente, fins de vida limpos e demais famílias preservadas; fallback/reduzido/teto/pausa/limpeza e suíte/smoke PASS. Aceite subjetivo depende do dono.

Antes de cada playtest humano, informar build/escopo/objetivo/procedimento. Roteiro a preparar: projeto local0.4.0+onda-cortante-admission-v01 em Dagruve, perfil QA; Lâmina Trovejante e Tempestade, oito direções e chão claro/escuro, tinta alternativa e modo reduzido; comparar as três famílias juntas. Observar pontas/raios/silhueta, estabilidade do voo, leitura entre acerto e projétil que perfura, conforto do pico e ritmo. Feedback esperado: arma/modo/cor/direção e aceitável ou problema por fase/voo/impacto. Atena verifica consistência; dono avalia sensação/dificuldade/diversão. Playtest não realizado por esta proposta.

## Autorização

Dono escolheu “1. Por plano — uma aprovação para todo o escopo planejado. (Recomendado)”. Escopo v01 integral aprovado, modo per-plan; trechos anteriores de proposta/unconfigured são históricos. [Recibo](../../generated/onda-cortante-admission-2026-10-13/authorization.json). Sem BLOCKING de aprovação.

## Resultado

Admissão DRAFT local técnica4/4 entregue no escopo per-plan aprovado: duas armas/dois atlas, suíte0falhas/smoke9fases,69capturas e paridade32cenários/2880passos PASS. Somente camada compartilhada mudou dentre runtime preexistente; fontes e demais famílias intactas por hash. [Evidência](../../evidence/onda-cortante-admission-2026-10-13.md), [roteiro](../../generated/onda-cortante-admission-2026-10-13/PLAYTEST.md). Feedback humano runtime pendente; sem CANON/Git/exportação.

2026-10-13 — Dono respondeu “atena aprovado, commit”: entrega local aceita, procedimento humano não relatado; DRAFT mantido. Commit local das três famílias pendentes autorizado; sem autorização de push/merge/exportação. Hashes do runtime final e fontes reverificados; checks anteriores permanecem válidos, sem nova alteração de implementação. Recibo: `.atena/generated/onda-cortante-admission-2026-10-13/owner-delivery-and-commit-authorization.json`.
