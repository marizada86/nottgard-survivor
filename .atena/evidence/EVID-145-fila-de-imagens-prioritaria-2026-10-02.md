# EVID-145 — Execução da fila de imagens prioritária

Data: 2026-10-02. Plano: [PLAN-053](../vault/drafts/PLAN-053-fila-de-imagens-2026-10-02.md).
Autorização: pedido do dono para executar prompts e adicionar imagens ao jogo. Ferramenta: imagegen integrado. Admissão local sob essa autorização; não atribui aprovação visual individual ao dono. Sem commit, push ou publicação.

## Assets integrados (21 PNGs)

| Prompt | Caminho final |
|---|---|
| ART-PROMPTS-039 | `assets/stages/docas_thumb.png` |
| FILA-009 T01 | `assets/ui/title/title_background.png` |
| FILA-010 C01 | `assets/stages/dagruve_fundo.png` |
| FILA-010 C02 | `assets/stages/docas_fundo.png` |
| FILA-010 C03 | `assets/decals/dagruve_estrada_trecho.png` |
| FILA-010 C04 | `assets/enemies/carroca_quebravel.png` |
| FILA-010 C05 | `assets/interactions/dagruve_selo_sacrificial.png` |
| FILA-010 C06 | `assets/interactions/dagruve_poco_oferendas.png` |
| FILA-010 C07 | `assets/decals/docas_cais_trecho.png` |
| FILA-010 C08 | `assets/props/docas_guindaste_01.png` |
| FILA-010 C09 | `assets/enemies/pilha_carga_quebravel.png` |
| FILA-010 C10 | `assets/interactions/docas_carga_solta.png` |
| FILA-010 C11 | `assets/interactions/docas_guincho_do_cais.png` |
| FILA-011 S01 | `assets/heroes/sylas_copia_isca.png` |
| FILA-011 S02 | `assets/vfx/sylas_explosao_sombria.png` |
| FILA-011 S03 | `assets/interactions/ampulheta.png` |
| FILA-011 S04 | `assets/interactions/doacao.png` |
| FILA-011 S05 | `assets/interactions/aposta.png` |
| FILA-012 U07 | `assets/vfx/vfx_subida_de_nivel.png` |
| FILA-012 U08 | `assets/vfx/vfx_evolucao_flare.png` |
| FILA-012 U09 | `assets/ui/evolucao_painel_moldura.png` |

Matrizes versionadas em `.atena/generated/art-candidates/`; originais do imagegen preservados em CODEX_HOME/generated_images. Dimensões, alfa e SHA256 no manifesto `../generated/PRIORITY-IMAGES-2026-10-02.json`.

## Integração

- Menu e título já leem os caminhos oficiais.
- Fundos desenhados atrás do mapa, escurecidos para preservar leitura da ação; não substituem terreno lógico.
- Estradas têm `span` e `size` por entrada, espelhamento no eixo y e o mesmo layout determinístico.
- Carroça (8 PV) e carga (8 PV) substituem dois destrutíveis, preservando 14/16 posições e loot com Sorte.
- Guindaste registrado no enum do editor e nas dimensões do cenário.
- Poço e oficina usam arte temática por nome, preservando fountain/ferreiro e seus comportamentos.
- Armadilhas mantêm telegrafia procedural sobre o asset.
- Isca usa sprite próprio com altura 64 px e alfa de runtime; explosão e subida de nível usam quatro quadros. Reduzir efeitos de impacto omite os novos flashes.
- Evolução preserva ícones, condições, pausa e skip; recebe moldura e flare de quatro quadros.

## Verificação

Suite existente: 0 falhas após completar cobertura de áudio e enum do guindaste. Smoke: nove fases. Capturas runtime em `../generated/priority-review/`: título, carroça, estrada, selo, poço, carga, guindaste, armadilha, oficina, cais, isca, explosão, eventos, subida de nível e painel de evolução. Painel recebeu mais margem após a primeira captura para afastar a instrução da borda.

Logs em `../generated/priority-tests.log`, `priority-smoke.log`, `priority-capture.log`. Godot reporta avisos de recursos em uso ao encerrar e falha ao acessar certificados no sandbox; as validações funcionais não substituem playtest.

## Pendências reais

- Molor: I01–I03 candidatas com halo externo, não admitidas; I01 atingiu três tentativas. Nenhum quadro dos ciclos foi gerado.
- VFX de combate: piloto A01–A06/B01–B06 gerado e integrado após aprovação explícita dos picos A03/B03. Próximo gate: C03 da FILA-021, Estocada Mística, v02 apresentada ao dono; demais C aguardam a resposta.
- U01–U06 ligados a MEC-002/003/004; mecânicas pendentes.
- Outros biomas e interações animadas continuam pendentes. A fila completa não está concluída.

## Reconciliação e build

HQN-01–14 já constam em `data/hqs.json`, com 56 imagens; todos os caminhos existem. EVID-128/EVID-133 documentam integração e prévia. A remessa histórica de HQs não foi regenerada.

Lote 1 reconciliado: os oito caminhos oficiais P01–P08 da FILA-001 existem, incluindo as duas névoas, dois baús, ímã e três NPCs. EVID-110 documenta admissão. Lote 2 já admitido conforme EVID-127; nenhuma nova geração foi necessária para essa remessa histórica.

Build local Windows: `build/image-priority/NottgardSurvivors.exe`, PCK embutido, identificação `38cbc95+` gravada por `tools/stamp_build.ps1` antes da exportação final. Inicialização headless por 90 frames terminou com código 0, sem falhas de carregamento ou script; avisos de certificados e recursos ao encerrar permanecem. A exportação completou savepack; o sandbox impediu gravar preferências pessoais do editor, sem impedir criar o executável. Logs `priority-export.log` e `priority-build-smoke.log`.

## Continuação — piloto de combate

O dono aprovou B03 e mandou continuar. Gerados os cinco quadros restantes do arco largo, preservando o traço aprovado. Os 12 quadros do piloto foram empacotados em dois atlas RGBA 1536×256, seis células de 256×256, com luminância convertida em alfa sem recortar o pivô. Matrizes preservadas. `tools/prepare_melee_vfx.gd` torna o processo reproduzível.

`core/melee_vfx.gd` aplica tinta de DivineVisuals, mistura aditiva, rotação no chão e compressão isométrica. Integração em `_swing` de `ui/run.gd`: cinco armas físicas usam corte médio; atordoante e receptáculo usam arco largo. Armas sem arte e efeitos reduzidos mantêm o polígono. Dano, alcance lógico, cone, RNG e colisão não mudam.

Suite: 0 falhas. `test_melee_vfx.gd` confere direção em oito ângulos contra Iso, exclusão de estocada/chicote e geometria/transparência dos atlas. Capturas conferidas nas sete cores e oito direções; a cena de QA confirmou que o efeito se libera ao fim de 0,2 s e que efeitos reduzidos usam Polygon2D. Smoke completo das nove fases: ok. Logs `priority-melee-tests.log`, `priority-melee-capture.log`, `priority-melee-smoke.log`; imagens `priority-review/melee_*.png`. Manifesto atualizado para 23 PNGs oficiais: 21 assets anteriores e dois atlas novos contendo os 12 quadros.

Nova build local: `build/image-priority-vfx/NottgardSurvivors.exe`, PCK embutido, identificação `0217b2f+`; inicialização por 90 frames concluída. Inclui o estado do workspace compartilhado no momento da exportação. Alterações paralelas de chão/heróis foram preservadas e não foram feitas por esta execução. Nenhum commit ou push executado aqui.

Molor: I02/I03 v02 tentadas para remover o halo pelo imagegen, sem sucesso. Matrizes preservadas e fora do runtime. Pedido ao dono para escolher limpeza técnica por Godot ou nova geração; nenhuma limpeza por código feita sem essa escolha.

### Continuação: Molor, Estocada e Chicote

O dono aprovou C03 v02, a limpeza técnica de alfa, as três identidades limpas de Molor e D03 v01. Os originais foram preservados. Estocada e Chicote têm seis quadros cada e atlas próprios no runtime; os quadros iniciais do Chicote foram corrigidos em v02 para crescerem até o pico. A Bolha de Slime recebeu seus 20 quadros e quatro strips em células 256×384, com transformação constante para o ciclo inteiro (escala 0,21814475; origem 522,5/1173; base 356). Prancha geral: `.atena/generated/priority-review/bolha_de_slime_all_states.png`. O corpo idle ocupa aproximadamente 180 px; o runtime preserva a altura visual de 62 px por escala do ator. Cultista e Blogbog ainda precisam dos demais ciclos. Verificação desta continuação em andamento; a build anterior não inclui estas alterações.

Validação da continuação: `priority-chicote-molor-tests.log` registra zero falhas; `priority-chicote-molor-smoke.log` registra as nove fases e `smoke: ok`; `priority-molor-runtime.log` confirma escala, âncora, desbloqueio de ação e remoção após morte. Capturas `melee_chicote_themes.png` e `bolha_de_slime_runtime.png` inspecionadas. Manifesto atualizado para 29 PNGs. Build Windows local: `build/image-priority-molor/NottgardSurvivors.exe`, identificação `4510c64+`, SHA256 C872BFF0352F3B0663D04010DD560A76CA9019D3DFDA652AF0C88B13BCF759E6; exportada e inicialização headless conferida. Avisos do ambiente sobre certificados/editor_settings e recursos em uso no encerramento persistem. A build inclui a árvore compartilhada, inclusive alterações de outros chats; nenhum commit ou push foi feito nesta execução.

Prioridade atualizada: FILA-024 passa à frente dos próximos lotes por pedido do dono registrado no backlog. O lote do Cultista já disparado será preservado e conferido; W01 Kayron move_se iniciado com as duas referências do ART-PROMPTS-055. Blogbog e novos biomas ainda pendentes.

Cultista de Ghaunadaur: 20 quadros gerados. `attack_02_v01` rejeitado por troca de mão/corte do cajado; `attack_02_v02` selecionado. Quatro strips integrados em `assets/animations/enemies/cultista_thullgrime/`, transformação constante escala 0,21146245, origem 509/1476, base 356, altura idle ~302 px. Ilhas isoladas de até três pixels removidas no empacotamento autorizado. Pranchas por estado e geral disponíveis em `priority-review/cultista_thullgrime_*.png`. Runtime conferido em captura e em `priority-cultista-runtime.log`; suite `priority-cultista-tests.log`: zero falhas.

FILA-024 W01 Kayron: três candidatos preservados em `heroes-dimensoes/kayron/move_se_v01.png`–`v03.png`. Primeiro apresentou corte na última figura; v02/v03 mantêm as seis figuras completas, mas com halo exterior. Auditoria v03 (2048×768): 992403 pixels totalmente transparentes, 438030 com alfa >=251, 142431 parcialmente transparentes. Não integrado. Limite `max_retries: 3` em `.atena/add.yaml` alcançado; perguntado ao dono se estende às novas tiras dos heróis a limpeza de alfa por código já autorizada para Molor. Enquanto aguarda, W02 Korrak move_e em geração.

Build atualizada depois do Cultista: 402709704 bytes, identificação4510c64+, SHA256 A2FB114A9681EF36CE8420CE17CEF0DB80044C2866B4EA28AF0B9EDEFCCB2CE4. O hash anterior era da build antes de incluir o Cultista. Inicialização novamente conferida, suite zero falhas e smoke nove fases ok. Manifesto atual:33assets. BUG-025 permanece P1 aberto, sete outrosP1 aguardamplaytest e oito verificações manuais permanecem; não declarar a correção dos heróis concluída.

FILA-024 W02 Korrak: v01/v02 não tinham folga suficiente na grade; v03 usa figuras menores e completamente separadas. A matriz2171×724 foi segmentada em seis silhuetas pelo alfa existente e empacotada em1536×384 sem alteração de cores/alfa. Todas alturas267, base350, larguras221–234, margem mínima11px; massa0,9896–1,0348 do idle, seisquadros e zero bordas. `priority-korrak-acceptance.log`: zero falhas; `priority-korrak-equalize-report.log`: nenhuma alteração sugerida. Tira integrada em `assets/animations/heroes/korrak/move_e.png`, original anterior preservado em candidatos. O runtime compartilhado passou a usar caminhada procedural para Korrak; habilitada a tira validada só para direita, conservando as demais sete direções provisórias e a mão da arma. `priority-korrak-runtime.log` confirma seleção nas oito direções; captura `korrak_move_e_runtime.png` inspecionada. BUG-025 segue aberto para os demais itens. Manifesto34PNGsintegrados:33novos+1substituição. W01 Kayron não foi integrado; decisão sobre limpeza de alfa segue pendente.

Build final desta continuação, após W02: `build/image-priority-molor/NottgardSurvivors.exe`, 403753752 bytes, identificação4510c64+, SHA256 A55E3C7EFA5F2590C2376DBC1D9814300759CD4CD8E58785549DA16CA0B5E352. Exportação concluída, inicialização headless com espera explícita até encerramento, código0. `priority-korrak-final-tests.log`: zero falhas. A hash A2FB... acima corresponde à versão anterior, antes da substituição W02. A build contém Estocada, Chicote, Bolha, Cultista e Korrak move_e corrigido. Próxima pendência prioritária: W01 Kayron, aguardando escolha do dono sobre limpeza de alfa por código; demais itens da FILA-024 e o restante da fila permanecem incompletos.

Continuação de 2026-10-02: W03 (move_se_v02) e W05 (move_s_v01) integrados após auditoria: seis quadros, 267 px de altura, base 350, sem bordas, massa 0,965–1,027 e 0,886–0,944 × idle respectivamente. Capturas no jogo conferidas. Runtime usa E/SE/S; outras direções continuam provisórias. W04 v01/v02 rejeitados visualmente por halo marrom mesmo com métricas geométricas válidas; v03 em geração. Prompts: bloco comum ART-PROMPTS-055, direção visual explícita, alternância de seis passos e transparência limpa; v02 W04 pediu extração do fundo, v03 regeneração com referência limpa de W05. Originais preservados.

W04 v03 corrigiu a transparência no gerador; massa 0,791–0,856 × idle, altura267/base350 em seis quadros, aceite sem falhas, integrado. W06/W07 Bromnor v01: altura241/base364; massa0,975–1,049 e0,944–1,019; W08 Sylas v01: altura304/base376; massa0,845–0,930. Todas sem cortes, capturas no jogo inspecionadas, originais preservados. Manifesto agora40 PNGs (33 novos +7 substituições). Testes de animação e VFX:0 falhas. Suite completa do workspace compartilhado:11 falhas em test_level_design.gd sobre props de durao; sem falhas de animação. HEAD alterado por outro chat para18d504f; mudanças compartilhadas preservadas. W15 reauditorado: três tiras ainda têm1–2 falhas de base de2–3px, sem cortes; não dar como encerrado ainda. W09–W11 iniciados pela prioridade P2. W01 continua aguardando escolha sobre limpeza de alfa.

W09–W11 integrados (cinco tiras v01): Kayron N/S altura316/base376/massa0,994–1,062; Sylas S304/376/massa1,036–1,054; Brook N/NE259/368/massa0,788–0,926. Todos6quadros, sem bordas, alfa original preservado no empacotamento. Manifesto45PNGs; prompts exatos desse lote em heroes-walk-prompts-2026-10-02.json. W12–W14 em geração. Testes/capturas gerais do lote ainda serão atualizados.

W12 Durvall NE v01 e W13 Nyrelia E v02 integrados; Durvall E v01 perdeu espada em um quadro, v02 juntou duas silhuetas, v03 em geração. Nyrelia v01 sobrepunha roupas; v02 compacta passou, massa0,810–0,855. W14 Maelor NE/E/SE/S v01 integrados, altura299/base364, massa0,733–0,963; N v01 rejeitado por massa0,673–0,728, v02 em geração. W15 Bromnor N/NE: arte atual recuperável, grade/base corrigidas sem redesenhar, altura241/base364, massa1,034–1,148, integradas. S recuperou a métrica, mas revisão visual identificou fragmento de braço vizinho; candidato empacotado não integrado, nova tira em geração. Manifesto53PNGs, incluindo duas correções técnicas de tiras existentes. A01–A06 em geração, uma chamada por tira, referência idle e ação original, escala constante e VFX compactos; originais preservados.

Caminhadas W02–W15 concluídas. Últimas selecionadas: Durvall E v03(espada inteira, massa1,087–1,181), Maelor N v02(massa0,795–0,822), Bromnor S v01(massa0,900–0,937). A04 Bromnor active v01 admitido:241/base364/massa1,036–1,063. Manifesto57PNGs, incluindo2reempacotamentos técnicos de BromnorN/NE. Demais ações em correção de largura/halo; nada com defeito foi integrado. Korrak N existente reauditorado:0falhas, altura261–269/base350/massa1,099–1,148; não foi regenerado. W01 continua fora do runtime. Capturas e validação final desse lote em andamento.

## Fechamento do lote de heróis — 2026-10-02

W02–W15 integrados e A01/A03–A10 integrados: 13 tiras de ação ao todo (5 ataques de quatro quadros, 8 ativas de seis quadros). A02 Korrak active permanece na arte anterior: v01/v02 inválidas e v03 com apenas três grupos de alfa por sobreposição entre seis figuras; nenhuma delas admitida. W01 Kayron move_se permanece candidato por halo e aguarda a decisão de limpeza de alfa já apresentada ao dono. Não aplicar a autorização de limpeza de Molor aos heróis.

Manifesto acumulado: 69 PNGs = 33 novos fora dos heróis + 36 tiras de heróis substituídas/corrigidas, das quais duas são reempacotamentos técnicos de Bromnor N/NE. Neste prosseguimento foram admitidas 35 tiras, pois Korrak E já estava admitido anteriormente. Geração pelo imagegen integrado, originais e versões rejeitadas preservados. Prompts exatos recentes: heroes-walk-prompts-2026-10-02.json, heroes-walk-prompts-correcoes-2026-10-02.json e heroes-action-prompts-2026-10-02.json.

Ações selecionadas: Zynara attack v02; Sylas active v02; Bromnor attack v02/active v01; Durvall attack/active v02; Brook attack v03/active v02; Leoric attack v02/active v01; Kayron, Maelor e Nyrelia active v01. Quando a arma sobe acima da cabeça, o empacotamento usa pontos cabeça/sola anotados para preservar a altura do corpo: Bromnor 219 px (o idle completo tem 241 px por causa do martelo), Durvall 231 px e Brook 259 px. Não confundir extensão da arma com altura do personagem. RGB/alfa originais preservados; nenhuma limpeza de alfa por código nos heróis.

Validação: aceite de cada candidata sem falhas; focused Animation queue: 0; suite completa: 0 falhas (as 11 falhas anteriores de Durão desapareceram após a atualização do workspace compartilhado); smoke das nove fases: ok; relatório read-only de equalização vazio; runtime Korrak E/SE/S/NE confirmado, quatro direções provisórias preservadas; capturas de todas as tiras novas efetuadas, amostras de caminhadas e ataques inspecionadas no jogo; git diff --check sem erros. Aviso ambiental de certificados do Godot não interrompeu os processos.

Build local: build/image-priority-heroes/NottgardSurvivors.exe, identificador 942fbe8+, 403909160 bytes, SHA256 F953F829C9E2E4CE56B7941FEFB6A63609CDE97582492E1BAFEA12D922B65C89. Exportação e inicialização do executável terminaram com código 0. Inclui os 69 arquivos do manifesto. Alterações de outros chats preservadas; sem commit/push desta execução. FILA-024 permanece parcial pelas duas pendências citadas; restante da fila global ainda aberto.

## Retomada autorizada pelo dono — 2026-10-02
Pedido “atena continuar”: nova tentativa com referências limpas existentes. W01 Kayron move_se v04 e A02 Korrak active v04 passaram: seis silhuetas separadas, alfa do gerador preservado, sem limpeza por código. Kayron316/base376/massa0,923–0,989; Korrak267/base350/massa0,890–0,958; sem cortes. Integrados, backups preservados, capturas runtime inspecionadas. FILA-024 concluída localmente sob autorização geral; não atribuir aprovação visual individual ao dono. Manifesto71PNGs. Exceção conhecida de massa Kayron retirada do teste. Próximo item da prioridade original: completar os25quadros restantes de Blogbog (identidade já aprovada), uma chamada por quadro conforme ART-PROMPTS-045.
## Molor concluído nesta retomada
Blogbog: 26 quadros selecionados (idle4, move6, attack4, death6, special6), uma chamada imagegen por quadro, originais preservados. Death03–05 e special03–04 corrigidos em v02 após revisão. Limpeza técnica de alfa restrita a Molor conforme autorização anterior; normalização da altura de idle/move e origem dos pés por quadro. Transformação comum0,20380952; corpo parado247,83px arredondado248 no runtime; base356. Cinco strips integrados. Special ligado à habilidade summon. Teste runtime passou (escala, base, loops, término de attack/special e remoção após morte); prancha geral e captura em priority-review/blogbog_all_states.png e blogbog_runtime.png. Prompts exatos em blogbog-prompts-2026-10-02.json. Manifesto76PNGs. Total Molor66quadros/13ciclos. Próxima etapa prioritária: oito identidades de Shedaklah, com revisão do dono antes dos ciclos.

Validação final de Molor: tests/run_all.gd com0falhas (resume-molor-all-tests.log), smoke nas nove fases passou (resume-molor-smoke.log), exportação e inicialização da build com código0. Build local build/image-priority-molor-complete/NottgardSurvivors.exe,405731440bytes, identificador dbf235c+, inclui76PNGs do manifesto. Falha anterior de célula duplicada em Goranthis não reapareceu após alterações paralelas do workspace; não foi alterada por esta execução. Sem commit/push.
SHA256 da build Molor: F7705305CCF59266C6F31FA62C7732DC27124BED0BA29ECCFC256041F5AB3805.
Shedaklah: oito identidades v01 geradas e preservadas, uma chamada por alvo. Correções de halo e margem pelo próprio imagegen em andamento; nenhum ciclo disparado e nenhum asset de Shedaklah integrado. Sem extensão automática da autorização de limpeza técnica de Molor.
Conferência final do manifesto: reconciliados os hashes/dimensões dos dois decals de estrada/cais reprojetados anteriormente, preservando previous_sha256. Os arquivos não foram alterados nesta conferência; build contém as versões atuais. Testes focados de animação:0falhas, incluindo os cinco estados de Blogbog.

Shedaklah: v03 selecionadas para revisão das oito identidades, cada uma1254×1254. Halo amplo de v01/v02 ausente na prancha v03; alfa nativo preservado integralmente, com valores parciais nos contornos. Auditoria251+ sem corte nas oito silhuetas; margens técnicas serão equalizadas no empacotamento. Prancha shedaklah_identities_v03.png e logs resume-shed-review-v03.log/resume-shed-alpha-all-v03.log. Prompts exatos initial/correction_v02/correction_v03 em shedaklah-identity-prompts-2026-10-02.json (24chamadas/8alvos). Gate de identidade da FILA-013 aguardando resposta,158quadros restantes não disparados, nenhum asset de Shedaklah no runtime.
Dono aprovou as oito identidades v03 de Shedaklah e autorizou prosseguir; gate I01–I08 registrado. Execução dos ciclos iniciada pelo Servo de Zuggtmoy, conforme ordem da FILA-013.
Servo de Zuggtmoy: 20 quadros completos e quatro tiras integradas. Correções nativas do gerador retiraram halos dos quatro pilotos; attack_01 v02 corrigiu a mão da lança. Alfa/RGB preservados no empacotamento; célula256×384, pés356, body_height110, transformação comum0,09094809. Auditoria de solidez das quatro tiras: mínimo0,963; sem corte visível. Pranchas e captura runtime inspecionadas. Importação0, Animation queue0falhas, escala/base/loops/término de ataque/remoção após morte OK. Manifesto80PNGs. Cogumelo Fúngico:19quadros iniciados após concluir o Servo. Build Molor anterior permanece com76PNGs; ainda não contém o Servo.
Validação adicional do Servo: suite completa tests/run_all.gd terminou com código0 e0falhas (shedaklah-servo-all-tests.log). Captura reenquadrada para manter todos os quadros completos na janela; reviewed servo_de_zuggtmoy_runtime.png. git diff --check dos arquivos runtime/testes sem erros.
Cogumelo Fúngico concluído20quadros/4tiras e integrado. Death03 v02, death04 v03 e death05 v03 selecionados após correção de colapso e tamanho; originais preservados. Corpo188px/base356, célula256×384, alfa nativo. Auditoria packed mínimo0,960; import0, Animation queue0falhas, runtime escala/âncora/loops/término de ataque/limpeza após morte OK. Prancha geral e captura runtime inspecionadas. Manifesto84PNGs. Esporo Voador é o próximo alvo autorizado; build anterior ainda76PNGs.
2026-10-03: Esporo Voador concluído20quadros/4tiras e integrado. Move01 v02, attack00–03 v02 e death04–05 v02 corrigiram orientação e colapso. Alfa nativo preservado. Idle normalizado189px, body_height190/base356; move mantém variação de altura das asas sem ampliar a esfera. Packerfit0,16617984; quatro tiras com solidez mínima0,958. Import0, Animation queue0falhas, escala/âncora/loops/término ataque/remoção morte OK. Prancha e captura no cenário conferidas. Manifesto88PNGs. Limo de Juiblex em geração,19quadros; demais quatro alvos ainda não disparados. Build anterior Molor permanece76PNGs. HEAD compartilhado57be050, alterações paralelas preservadas.
## 2026-10-03 — Shedaklah parcial pronta e limite de geração

O dono aprovou I01–I08 v03 e autorizou prosseguir. Servo de Zuggtmoy, Cogumelo Fúngico e Esporo Voador concluídos: 60 quadros, 12 tiras integradas com alfa nativo preservado. Corpo/base no runtime: Servo 110/356, Cogumelo 188/356, Esporo 190/356. Pranchas por estado e capturas runtime conferidas. Cogumelo death03–05 e Esporo move01/attack00–03/death04–05 corrigidos pelo gerador; versões anteriores preservadas. Nenhuma aprovação humana dos ciclos foi inventada.

Manifesto PRIORITY-IMAGES: 88 assets, hashes conferidos. Suite completa zero falhas; smoke nove cenários ok; exportação e abertura da build exit 0. Aviso já conhecido do certificado raiz do Windows não impediu execução. Diff sem erros de whitespace.

Build local: build/image-priority-shedaklah-partial/NottgardSurvivors.exe; id 57be050+; 407550728 bytes; SHA256 33A0DDB59A6AA083A6F1C198DB5D205CBCD85A9E176A5FC7A020FC9534591530. Arquivo de validação: shedaklah-partial-build-validation-2026-10-03.json.

Limo de Juiblex: idle_00 v03 aprovado e sete novos quadros gerados (idle_01–03, move_00–03) preservados como candidatos; ciclos incompletos não integrados. Doze chamadas restantes rejeitadas pelo imagegen HTTP429 usage_limit_reached. Liberação informada pelo serviço: 2026-10-03 10:19:52 America/Sao_Paulo. Sem tentativas adicionais ou substituição por outro gerador. Próximos 94 prompts de Shedaklah preservados em shedaklah-resume-after-limit-2026-10-03.json: 12 do Limo e 79 de Pudim, Gárgula, Receptáculo e Zuggtmoy. Biomas seguintes aguardam conclusão desta prioridade. BUG-025 ainda requer conferência humana em uma partida real; validação técnica não equivale a playtest humano.

2026-10-03 retomada: liberação confirmada às 10h27; Limo de Juiblex concluído e integrado (20 quadros/4 tiras), total Shedaklah 80 quadros/16 tiras, manifesto 92 PNGs. Correções do gerador: move01/02 v02, death01/05 v02. Prancha e captura runtime conferidas; testes focados zero falhas, escala/base, ataque e morte corretos. Próximo: Pudim Negro; 82 novos quadros para quatro alvos restantes. Build anterior ainda contém 88 assets.

2026-10-03: Pudim Negro concluído e integrado (20 quadros/4 tiras; body109/base356). Correções pelo gerador: move00 v02 para orientação, idle03/move03/death00 v02 para paleta. Alfa nativo preservado. Testes focados zero falhas, runtime e captura conferidos. Shedaklah: cinco alvos completos, 100 quadros/20 tiras; manifesto 96 PNGs. Próximo Gárgula; faltam 63 novos quadros em Gárgula/Receptáculo/Zuggtmoy.
