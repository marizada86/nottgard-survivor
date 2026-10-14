# L-001 — admissão conjunta de cinco sequências / v01

PLAN-053/SPEC-121 S-007, PLAN_CHANGE_REQUEST limitada à admissão das30fontes visualmente aceitas do L-001. Preparada antes da execução; modo unconfigured, não executável até seleção explícita. Sem nova geração, dependência, promoção CANON ou Git. PLAN-071/B-006/S-011 preservado.

## Entradas e prontidão

[Manifesto e30hashes](../../generated/assets-batch-review-2026-10-13/manifest.json), [aceite visual](../../generated/assets-batch-review-2026-10-13/visual-acceptance.json), [bíblia/revisão](assets-batch-review-v01.md). Dono aceitou25fases DRAFT; cinco gates históricos preservados. Selecionados E01/E02v02, demaisEv01, Fv01, H102v02, H201v02 e demaisH1/H2/H3v01. Autoridade ART-PROMPTS052/054 rev2026-10-01; originais, correções rejeitadas e evidências históricas intactos. Identidade de personagem N/A: efeitos abstratos, sem corpo/retrato; herói/arma identifica o uso. Contexto: combate isométrico, efeitos de chão em branco/cinza recebendo tinta aditiva, margem segura, continuidade e leitura96px conforme aceite. Preservar motivos de raios, fogo, rasgo, estrelas de Brook e sinais de mais de Maelor.

## Escopo concreto e comportamento

Normalizar30nativos para cópias1024 e gerar **cinco atlas1536×256**, seis células256cada. Destinos propostos assets/vfx/melee_arco_radiante.png, melee_arco_fogo.png, durvall_ruptura_sombria.png, brook_guarda_de_lliira.png, maelor_comunhao.png. Godot faz a transformação técnica, alfaRec709/whiteRGB e piso<=2/255 somente em derivados. Fontes nativas preservadas. Pivô/escala únicos por sequência, calibrados geometricamente contra gates/forma e alcance visual; nenhuma compensação por quadro ou reconstrução artística. Sem mudança de cone lógico, dano, alcance, RNG, cooldown ou status.

**Corpo a corpo:** ampliar core/melee_vfx.gd com três formas e dispatch explícito por arma/dtype/evento swing: arco radiante somente golpe_do_juizo e martelo_da_gloria, dtype radiante; arco de fogo somente machado_de_xargath, dtype fogo; ruptura somente ruptura_sombria, dtype fisico. Durvall já emite swing com esse ID via Battle.use_active, sem modificar Battle. Não usar icon_like como autorização; excluir Esmagar Defesas, outras armas/habilidades/inimigos. Preservar rotinas de C/D e físicos existentes. Seis quadros30fps (0,2s), projeção de chão MeleeVfx.projection, altura visual18px e cor theme.primary atuais. Calibrar alcance visual pelo event.range, sem esticar cone individual para igualar motivo artístico220/200° ao cone de colisão. Ring genérico do evento active de Durvall e áudio/ação do herói permanecem; não tocar ruptura duas vezes.

**Brook:** somente active com hero_id=brook e ability_id=guarda_de_lliira. Iniciar ciclo de seis quadros12fps quando a ativação existente for aceita. Anel acompanha Iso.to_screen(battle.hero.pos), projeção elíptica de chão, raio visual1,0tile (referência estética, sem hitbox). Encerrar ao consumir a carga ou active_guard_t chegar a zero; duração máxima segue Battle (4s atuais), sem timer ou carga novos na simulação. Um único visual de guarda por run; reativação substitui o anterior. Centro vazio e estrelas fixas preservados. Cor theme.aura_accent capturada na ativação.

**Maelor:** somente active com hero_id=maelor e ability_id=comunhao. Battle atual faz cura/marca instantâneas e não tem campo de cura persistente. Exibir **um ciclo de seis quadros10fps por0,6s**, somente feedback de ativação; acompanhar herói durante esse intervalo, raio visual do evento existente (3,2tile atual), theme.aura_accent na ativação. Não repetir cura ou manter aura durante cooldown. Um único efeito, substituído se outra ativação válida ocorrer. Isso é decisão de apresentação dentro deste plano, não implementação de cura contínua.

Helpers limitados: core/hero_active_vfx.gd para recursos/calibração/allowlist e ui/hero_active_vfx.gd para lifecycle da guarda/aura; ui/run.gd conecta active e apresentação, sem criar framework genérico. Reusar convenções locais de cache SpriteFrames e projeção. Os dois efeitos acompanham pausa do jogo e battle.state; desaparecem em dead/won/runfree. Brook também remove por carga consumida; Maelor expira somente em tempo de jogo running. Mudar reduzido remove atlas ativo. Tetos: no máximo um Brook e um Maelor por run, sem estado por inimigo ou alteração de simulação.

**Fallback:** reduzido ou recurso ausente/inválido conserva polígono/ring procedural anterior. Validar dimensões antes de suprimir fallback; ausência de um atlas não pode suprimir outra família. Alternância para reduzido não deixa loop preso. Em futuras ativações sem textura mantém ring0,3s atual. Preservar todos os hooks/efeitos de projéteis, Pulso/Ampulheta, demais heróis/armas, tintas divinas e feedback de dano.

## Impacto, recuperação e limites

Runtime permitido: cinco novos PNG/imports, core/melee_vfx.gd, core/hero_active_vfx.gd/UID, ui/hero_active_vfx.gd/UID, ui/run.gd, teste focado/UID. Artefatos sob .atena/generated/assets-l001-admission-2026-10-13/ e registros ADD/backlog. **core/battle.gd, data e helpers/atlases/camadas/testes existentes dos orbes/Pulso/Ampulheta protegidos por hash.** Apenas MeleeVfx/run podem mudar dentre código preexistente. Não alterar ui/overlay.gd, árvores de heróis ou áudio. Se surgir necessidade fora da lista, analisar impacto/checkpoint antes de agir. Nenhuma arquitetura material nova: dois helpers locais reutilizam apresentação existente.

Antes de modificar: hashes/backups verificáveis dos destinos preexistentes e estado; inventário de novos arquivos. Recuperação restaura bytes desses dois scripts e remove referências novas, preservando fontes e aceites; nenhum reset Git. Mudança artística ou ajuste por quadro necessário interrompe só a família afetada e volta ao gate visual, sem refazer ou aprovar silenciosamente as demais.

## Etapas e checks

1. S-001 / B-001: verificar30fontes/aceites, backups; normalizados/cincoatlas; auditar alfa/bordas, motivos/resíduos, pivôs e escalas fixos. Prévias técnicas e relatório PASS antes de instalar.
2. S-002 / B-002: admitir três formas corpo a corpo, dispatch estrito, calibração/projeção; C/D/físicos preservados, duração0,2s e oito direções.
3. S-003 / B-002: admitir guarda Brook e feedback Maelor com lifecycle acima, seguir herói/pausa/carga/fimrun/reduzido; fallback sem alterar Battle/data.
4. S-004 / B-003: teste focado significativo, suíte completa, smoke9fases; capturas reais das três armas e três ativações, seis fases por sequência, oito direções dos cortes, duas tintas, movimento de Brook/Maelor, guarda consumida/expirada, Maelor um ciclo sem nova cura, pause/reduzido/textura ausente/inválida/cleanup. Regressão C/D/físicos, três famílias de projéteis, Pulso/Ampulheta e outros heróis. Comparação determinística do estado de Battle antes/depois da apresentação (RNG/dano/HP/estado/cargas/eventos iguais); hashes de áreas protegidas. APPDATA/save QA isolados.
5. S-005 / B-003: contrato/links/hashes/evidências/estado reconciliados, build0.4.0+l001 identificado e roteiro/atalhos de playtest local. Sem exportar. Técnico5/5 pode concluir; feedback humano runtime permanece pendente.

Modalidades oferecidas: per-plan aprova S001–S005 integralmente; per-batch usa B001/B002/B003 estáveis; per-step pausa antes de cada S001…S005. Modo atual **unconfigured**. Aceite visual autorizou preparar esta proposta, não normalizar/admitir.

## Prontidão e aceite humano

BLOCKING: escolha de modo/aprovação deste escopo. RESOLVABLE emS001: calibração geométrica; emS002/003: dispatch/lifecycle/fallback. Defaults recomendados30fps cortes,12fps Brook enquanto guarda real,10fps/0,6s Maelor, raioBrook1tile. DEFERRED: conforto/leitura/ritmo humanos,42quadros dos demais heróis, bugs025/027/028/029 e playtests anteriores sem relato. Não há outro bloqueio principal conhecido.

Antes do playtest informar build/escopo/objetivo/procedimento. Proposta de roteiro: três armas em Dagruve, Durvall/Brook/Maelor com ativações reais; oito direções/pisos claros e escuros; Brook mover, bloquear e esperar4s; Maelor conferir feedback breve e ausência de cura contínua; tinta alternativa/reduzido e regressões. Observar brilho, legibilidade do rasgo/raios/chamas/estrelas/mais, sobreposição, cadência e alinhamento. Feedback esperado arma/herói/modo/cor/direção e aceitável ou problema. Atena verifica consistência; dono avalia sensação/dificuldade/diversão. Não afirmar playtest humano por métricas.

## Autorização

Dono selecionou1Porplano para o escopo integralv01. Modo per-plan aprovado; referências anteriores a unconfigured descrevem a proposta histórica. [Recibo](../../generated/assets-l001-admission-2026-10-13/authorization.json). BLOCKING de aprovação resolvido.

## Resultado

Técnico5/5 entregue conforme per-plan aprovado:30fontes/cincoatlas, suíte0falhas/smoke9,131capturas e snapshots de simulação PASS. Brook segue guarda real; Maelor ciclo0,6s sem cura contínua. Só MeleeVfx/run mudaram dentre runtimepreexistente. [Evidência](../../evidence/assets-l001-admission-2026-10-13.md), [roteiro](../../generated/assets-l001-admission-2026-10-13/PLAYTEST.md). Feedback humano runtime pendente; sem CANON/Git/exportação.

Dono respondeu “atena commit e proximo”: entrega local aceita, procedimento humano não relatado, commit local L001 e continuação da revisãoL002 autorizados. Runtime final/hash das30fontes reverificados, sem nova alteração de implementação; checks prévios continuam válidos. Sem CANON/push/merge/exportação. Recibo `.atena/generated/assets-l001-admission-2026-10-13/owner-delivery-and-commit-authorization.json`.
