# SPEC-121 — Normalização/admissão da Ampulheta do Silêncio / v01

Estado: **proposta DRAFT, aprovação de execução pendente**, preparada2026-10-13 antes de implementação. PLAN_CHANGE_REQUEST na frente PLAN-053/S-007. [Fontes/proveniência](../../generated/ampulheta-review-2026-10-13/recovery.json), [aceite das quatro fases](../../generated/ampulheta-review-2026-10-13/visual-acceptance.json), [spec de revisão/bíblia](ampulheta-review-v01.md). Revisões exatas: M01v02,M02v03,M03v01,M04v01,M05v01,M06v01. Preserve-se M01 com exceção histórica≈14%do raio inicial; M03 aprovado historicamente. Novas fases aceitas permanecem DRAFT, sem CANON.

## Intenção, contexto e contrato existente

Aplicar somente à arma `ampulheta` (Ampulheta do Silêncio Eterno). A inspeção de `data/weapons.json` confirmou **kind=nova, dtype=magico, radius=4.0, stun=1.5, cd=5.0**. `Battle._fire` já emite o evento nova com weapon=ampulheta, pos/radius/dtype; `Run._nova_effect` usa anel simples quando não é Pulso radiante. Não há persistência de zona nessa arma. O nome da fonte histórica “zone of stillness” descreve a arte; não autoriza criar zona, congelar tempo ou alterar mecanismo.

Bíblia aplicável DRAFT: anel circular calmo, fino, ampulhetas e grãos finos, branco/cinza neutros, fundo preto das fontes, vista superior e projeção2:1 em combate. Identidade de personagem N/A (VFX abstrato). Referência de identidade M03v01 e fontes aceitas; manter exceção M01v02. Contexto: em torno do ponto do evento, tinta `DivineVisuals.impact_accent`, chão/câmera/UI atuais; sem cenário, texto ou lore novos. Animação cresce, atinge pico, afina e deixa resíduos. Legibilidade de motivos/grãos e conforto no jogo exigem feedback humano. Não afetar a interação de cenário também chamada ampulheta, habilidade de parar o tempo, outras novas mágicas, Pulso ou outras famílias.

## Escopo técnico proposto

Mesma preparação local aprovada no Pulso: fontes1254×1254 intactas; seis cópias normalizadas1024×1024 para auditoria e atlas1536×256, seis células256×256, redução Godot Lanczos direta por canvas com escala comum entre fases. Material aditivo, RGB branco/alfa=luminânciaRec709, piso<=2/255 zero apenas no derivado. Registrar filtros/transformações/medidas; verificar que não desapareçam grãos, ampulhetas ou M06. Sem nova geração, pintura, dependência ou compartilhamento remoto.

Pivô comum128/128 e raio do pico medido no atlas; calibrar a elipse do anel principal ao radius lógico usando Iso.TILE_W/H e fator sqrt(2)/2, tal como no Pulso, com medida própria desta fonte. Não usar raios decorativos como limite nem ajustar escala por fase. Preservar variação≈14%de M01 relativa ao pico. Cadência inicial seis fases one-shot em0,35s, duração da apresentação nova existente; sem estado persistente.

Novo destino `assets/vfx/ampulheta_silencio.png`; helper visual limitado `core/hourglass_vfx.gd`; ramo adicional em `ui/run.gd::_nova_effect`, somente type=nova, dtype=magico e weapon=ampulheta. Reusar o pipeline existente de frames/projeção/material quando possível sem refatoração geral. A apresentação do Pulso deve permanecer idêntica. Cache de frames, liberação após término, raio/posição/tinta/som existentes. Modo impacto reduzido, recurso ausente/inválido e eventos fora do escopo mantêm `_ring` atual. Sem ler RNG ou alterar `Battle`, tabelas, dano/atordoamento/cooldown/alcance, zones ou interações.

Arquivos limitados a esse atlas/helper, pequeno roteamento Run, testes focados e ferramentas/evidências em `.atena/generated/ampulheta-admission-2026-10-13/`. Se compartilhar pequena função com o helper do Pulso for necessário, documentar no S-002 e validar ausência de regressão; nenhum redesign de arquitetura. Backups verificáveis e lista de arquivos novos antes de escrever. Rollback restaura bytes de Run e helper existente, desfaz referências novas e conserva as fontes/história; sem reset Git/destruição. Preservar a arte integrada dos heróis.

## Etapas e aprovação

1. **S-001 / B-001 — Derivados e auditoria.** Entrada: seis fontes/recibos/hashes. Saída: cópias1024, atlas256×256 e prévia DRAFT. Conferir fonte intacta, centro/base/raio, margens, seis fases, motivos/grãos/resíduos e exceção M01. Parar antes da admissão se houver perda artística além da redução/conversão autorizadas.
2. **S-002 / B-002 — Admissão local.** Entrada S-001 PASS e plano autorizado. Saída: atlas/helper e roteamento somente ampulheta. Checks de escopo, duração, posição/raio/tinta/cache/liberação, fallbacks e Pulso preservado. Alteração artística ou ampliação de escopo exige novo gate.
3. **S-003 / B-003 — Verificação.** Teste focado de allowlist/dtype/tipo, atlas/alpha/resíduos, geometria, cadência, término e fallbacks; regressão do Pulso, suíte completa, smoke9fases. Capturas de seis fases e tintas em Dagruve a tamanho real; disparo pelo evento real de Weapon.make("ampulheta")/Battle._fire, impacto reduzido e ausência/atlas inválido. APPDATA/progresso QA isolados.
4. **S-004 / B-003 — Evidência e playtest.** Reconciliar contrato, hashes, links, resultado e backup; identificação de build/roteiro/launcher local sem exportar. Entrega técnica4/4 não prova conforto ou diversão. Próximo checkpoint: dono avaliar legibilidade dos grãos/motivos, intensidade e ritmo; manter esse aceite pendente até feedback.

Modo **unconfigured**, plano não executável. Opções per-plan, per-batch (B-001/B-002/B-003), per-step (S-001…S-004). O aceite das fases autorizou preparar a proposta, não normalizar, integrar ou promover CANON. Sem commit, push, merge, exportação, publicação, dependências ou nova imagem.

## Prontidão e aceite

**BLOCKING:** aprovação do escopo/modo acima. **RESOLVABLE no S-001:** raio/pivô e legibilidade de grãos/M06 após redução; defaults recomendados células256/duração0,35s/aditivo/piso<=2/255. **DEFERRED:** feedback artístico no jogo, outros VFX/playtests anteriores, bugs e Git. Nenhuma decisão nova de mecânica é necessária: arma nova instantânea confirmada no código.

Aceite técnico: seis frames íntegros, sem retângulo de fundo/corte/deslocamento visível, raio calibrado, tinta correta, duração/liberação/fallbacks e nenhuma alteração do Pulso/gameplay. Aceite subjetivo: efeito calmo, legível e confortável em combate, a confirmar pelo dono. Não fechar BUG-025/027/028/029.

Antes do playtest, informar build/projeto0.4.0+ampulheta-admission-v01, Dagruve, perfil QA com arma ampulheta. Objetivo: avaliar anel/motivos/grãos no tamanho real. Procedimento: caminhar30–60s por áreas claras/escuras, esperar inimigo dentro do alcance para disparar nova, observar seis fases/raio4,0/centro nos pés e repetição; comparar com impacto reduzido. Observar corte/fundo retangular/deslocamento, desaparecimento abrupto e brilho incômodo. Feedback esperado: aceitável ou fase/cor/raio com problema e captura se possível. Atena verifica funcionamento; dono julga sensação. Playtest não realizado nesta proposta.

## Autorização de execução — 2026-10-13

Dono: **“1. Por plano — uma aprovação para todo o escopo planejado.”** Modo per-plan e escopo integral aprovados. Pendências de aprovação na proposta acima são anteriores ao aceite; zero BLOCKING de aprovação agora. [Recibo](../../generated/ampulheta-admission-2026-10-13/authorization.json).

## Resultado

Quatro etapas técnicas concluídas; [evidência](../../evidence/ampulheta-admission-2026-10-13.md). Ampulheta admitida localmente DRAFT; Pulso preservado. Feedback subjetivo em jogo pendente.
