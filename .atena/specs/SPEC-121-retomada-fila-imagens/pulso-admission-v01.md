# SPEC-121 — Normalização e admissão do Pulso Radiante / v01

Estado: **proposta DRAFT, execução pendente**. Preparada em2026-10-13 antes de implementação. PLAN-053/S-007; PLAN_CHANGE_REQUEST limitada à admissão do efeito existente. [Revisão/recuperação](../../generated/pulso-resume-2026-10-13/recovery.json) e [aceite visual das cinco fases](../../generated/pulso-resume-2026-10-13/visual-acceptance.json) são as entradas. N03v01 continua coberto pelo registro030; cinco novas fases aceitas permanecem DRAFT. Nenhuma promoção CANON.

## Escopo e bíblia visual

Seis fontes aceitas N01v03,N02v02,N03v01,N04v01,N05v01,N06v01, RGB1254×1254, com hashes fechados. Visual neutro branco/cinza, círculo fino em vista superior, banda interna e raios externos, centrado na tela; crescimento/pico/afinamento/fragmentação/resíduos. Contexto de cena: efeito de chão em combate isométrico2:1, cores existentes de DivineVisuals, câmera e UI atuais. Identidade de personagem N/A: efeito abstrato, sem entidade figurativa. Fonte de identidade: N03v01 histórico aprovado; linguagem, referências e limites da [bíblia da retomada](pulso-resume-v01.md). Legibilidade a96px foi revisada pelo dono; legibilidade no jogo e fluidez runtime continuam pendentes. Sem imagem, lore ou habilidade nova.

Somente as seis armas `nova` previstas no ART-PROMPTS-053: Sentença de Lliira, Julgamento da Glória, Descarga Estelar, Chuva de Estrelas, Vela Sagrada e Sopro de Estrela. IDs existentes: `sentenca_de_lliira`, `julgamento_da_gloria`, `descarga_estelar`, `chuva_de_estrelas`, `vela_sagrada`, `sopro_de_estrela`. Inspeção local encontrou evento `nova` com pos/radius/dtype/weapon em `Battle._fire_nova`, consumido no `ui/run.gd`, que hoje desenha `_ring(...,0.35)`. Não expandir para habilidades, outras novas, zonas, projéteis, inimigos ou VFX das demais filas.

## Proposta técnica

S-001 produzirá, por Godot local, seis cópias normalizadas1024×1024 para auditoria e um atlas runtime1536×256 (seis células256×256), mantendo canvas/pivô comum e escala proporcional constante entre fases. Originais preservados byte a byte. Uma redução uniforme por tela, sem ajustar tamanho de cada quadro independentemente; nenhuma pintura ou fonte nova. Cadência inicial: seis fases em0,35s, one-shot, mesma duração do anel atual; ajuste subjetivo posterior requer feedback.

Converter RGB em luz neutra conforme pipeline existente MeleeVfx: RGB branco e alfa=luminância Rec.709 (`0.2126R+0.7152G+0.0722B`), material aditivo e tinta existente `impact_accent`. Evitar RGB=luminância com alfa=luminância (isso quadraria a luz). No derivado apenas, piso de fundo até2/255 vira alfa0; demais amostras preservam luminância proporcional. Conferir especialmente N06 para não apagar resíduos perceptíveis. Não modificar nenhuma fonte. Registrar interpolação, medidas e toda transformação.

Pivô do canvas será o mesmo para todos os quadros; medir círculo do pico e centro, comparar com proxy histórico429/1254 de raio luminoso. Calibrar raio lógico no anel principal do pico, não nos raios decorativos externos. Projeção isométrica2:1 deve corresponder à elipse de `Iso.to_screen` para o mesmo radius (sem alterar radius do evento). Documentar calibração exata usando inspeção/métrica; não presumir centro fotométrico como pivô geométrico exato. Se houver deslocamento visível, cortes ou diferença artística, parar antes da admissão e apresentar o derivado.

S-002 instalará `assets/vfx/pulso_radiante.png`, helper visual limitado `core/radiant_pulse_vfx.gd` e chamada no ramo nova de `ui/run.gd`. Aplicar só com dtype=radiante e weapon em allowlist das seis armas. Preservar `_ring` para demais eventos e como fallback quando recurso indisponível. Em impacto reduzido, manter o anel simples existente, sem adicionar flash. Usar o mesmo nó fx/posição/ordem de desenho das novas atuais, material aditivo, cache de frames e liberação no fim da animação. Sem ler RNG ou mudar dano/colisão/alcance/cooldown, nem duplicar visual ou som.

Arquivos permitidos: atlas acima; `core/radiant_pulse_vfx.gd`; `ui/run.gd`; teste focado e ferramentas de preparação/captura sob `.atena/generated/pulso-admission-2026-10-13/`; registros operacionais. Código de gameplay (`core/battle.gd`), tabelas/data, demais assets e heróis ficam protegidos por hash. Fazer backup verificável de tudo que for substituído; destinos novos registrados como novos. Rollback restaura os bytes anteriores e retira referências novas sem reset Git/destruição de arquivos históricos. Sem novas dependências, geração remota, áudio, commit, push, merge, exportação ou publicação.

## Etapas e checkpoints

1. **S-001 / B-001 — Derivados e prévia.** Entrada: seis fontes/aceites/hashes. Saída: cópias normalizadas, atlas DRAFT, métricas de luz/centro/raio/margens e prévia comparativa. Checks: fontes intactas, todas as fases presentes, sem deslocamento/corte/perda significativa dos resíduos. Não substituir asset antes de PASS.
2. **S-002 / B-002 — Admissão visual local.** Entrada: derivados aprovados tecnicamente e plano autorizado. Saída: helper/cache e roteamento das seis armas; fallback e impacto reduzido preservados. Checks: scope allowlist, projection/radius/duration, nenhuma mudança de gameplay. Se derivado alterar aparência além das transformações autorizadas, novo gate visual antes da cópia.
3. **S-003 / B-003 — Verificação.** Teste focado de roteamento, projeção, região/contagens, cadência/liberação, fallback e impacto reduzido; suíte completa e smoke9fases. Capturas de cada fase em Dagruve, tinta divina e tamanho real; disparo pelos eventos de cada uma das seis armas. APPDATA/profile QA isolados; não usar progresso real. Comparar com raio/pos de evento e fonte.
4. **S-004 / B-003 — Entrega e playtest preparado.** Evidência, hashes, links, estado e critérios reconciliados; roteiro e identificação de build local. Sem exportação. Entrega técnica pode fechar4/4; aceite subjetivo runtime fica pendente do dono, sem afirmar diversão por checks.

Modo: **unconfigured**, não executável. Opções per-plan, per-batch (B-001/B-002/B-003) e per-step (S-001…S-004). Aceite das fontes permitiu preparar esta proposta; não aprovou essas transformações, helper ou escrita em assets.

## Prontidão, aceite e playtest

**BLOCKING:** aprovação do escopo/modo deste plano, necessária para normalização e admissão visual. **RESOLVABLE em S-001:** raio/pivô e teste dos resíduos/ruído após redução; defaults recomendados256×256/material aditivo/duração0,35s/fundo<=2/255. **DEFERRED:** feedback de ritmo/intensidade/legibilidade em jogo, outras famílias VFX, playtests dos heróis/ART032, bugs globais e Git/publicação. O helper visual é uma adaptação pequena ao renderer existente, explicitamente incluída na aprovação solicitada; não inaugura um subsistema de gameplay.

Aceite técnico: fontes/retornos preservados, seis células válidas, efeito centrado e sem retângulo de fundo ou cortes, raio projetado correto, nenhuma cor/flash inesperado, novos eventos somente no escopo, liberação ao terminar, suíte/smoke sem regressão. Não fechar BUG-025/027/028/029 por esta entrega.

Antes do playtest humano, informar build/escopo e objetivo. Procedimento proposto: projeto local0.4.0+pulso-admission-v01 em Dagruve, perfil QA, testar Sentença de Lliira e uma nova de raio maior; observar as seis fases, centro nos pés, alcance visual, tinta e brilho em chão claro/escuro; repetir com impacto reduzido. Critério técnico: sem cortes/deslocamento/fundo retangular ou queda do efeito; critério humano: pulso legível, confortável e com ritmo aceitável. Feedback esperado: arma/raio/cor, aceitável ou fase problemática, captura quando possível. Atena verifica funcionamento; dono avalia sensação. Playtest ainda não realizado.

## Autorização — 2026-10-13

Dono escolheu **“1. Por plano — uma aprovação para todo o escopo planejado.”** Modo per-plan e escopo integral aprovados. Pendências de aprovação acima descrevem a proposta anterior; nenhum BLOCKING de aprovação permanece. [Recibo](../../generated/pulso-admission-2026-10-13/authorization.json).

## Resultado

Quatro etapas técnicas concluídas; [evidência](../../evidence/pulso-admission-2026-10-13.md). Pulso admitido localmente DRAFT. Cadência/material/calibração conformes à proposta; aceite humano em jogo pendente.
