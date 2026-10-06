# ARTE & ÁUDIO — assets, templates, layouts, backgrounds, sons

## Regras

- Todo prompt respeita o **Sabor Nottgard**: divindade/bioma envolvido, paleta
  ([RESEARCH-003](../vault/research/RESEARCH-003-paleta-das-deidades-2026-09-27.md)),
  bestiário ([RESEARCH-001](../vault/research/RESEARCH-001-abismo-bestiario-visual-2026-09-21.md)),
  sem inventar lore. Sem história: a lore é só sabor.
- Itens abertos acumulam até fechar um **lote**. O lote sai como um único
  `ART-PROMPTS-NNN` (próximo livre: **056**) para o gerador de imagem.
- Candidatos ficam em `.atena/generated/` até admissão explícita do dono.

## Abertos

### PRIORIDADE ALTA — tiras de heróis (2026-10-02)

Fila [CHATGPT-FILA-024](../generated/CHATGPT-FILA-024-regerar-tiras-dos-herois.md) / [ART-PROMPTS-055](../generated/ART-PROMPTS-055-regerar-caminhadas-e-acoes-dos-herois.md): regerar tiras com defeito de dimensão (BUG-025). Passa na frente das demais.

### Execução local de 2026-10-02

Pedido do dono: executar os prompts e adicionar as imagens ao jogo. FILA-024 W01–W15 e A01–A10 corrigidos e integrados após auditoria. Últimas correções: Kayron SE v04 e Korrak active v04, com alfa do gerador preservado. Progresso rastreado em [PLAN-053](../vault/drafts/PLAN-053-fila-de-imagens-2026-10-02.md).

- ART-024: miniatura de Docas gerada e integrada.
- FILA-009 T01: fundo de título gerado e integrado.
- ART-025/026, FILA-010 C01–C11: fundos e nove props gerados e integrados ao piloto; capturas runtime conferidas (estrada, cais, carroça, carga, guindaste, selo, armadilha, poço e oficina).
- ART-027, FILA-011 S01–S02: isca e explosão em quatro quadros geradas e integradas; primeira isca rejeitada por corte e halo, segunda utilizada.
- ART-021: as três identidades limpas de Molor foram aprovadas pelo dono. Bolha de Slime, Cultista e Blogbog: 66 quadros e 13 ciclos integrados. Limpeza técnica de alfa autorizada, originais preservados.
- FILA-011 S03–S05: ampulheta, doação e aposta geradas e integradas.
- FILA-012 U07–U09: subida de nível, flare e moldura de evolução gerados e integrados; U01–U06 continuam condicionados às mecânicas pendentes.
- HQs reconciliadas: `data/hqs.json` já registra HQN-01–14, com 56 PNGs existentes e nenhum caminho ausente. EVID-128 e EVID-133 documentam integração e prévia. Não regenerar a FILA-002 por causa do estado histórico abaixo.
- FILA-020: A03 v02 e B03 aprovados pelo dono; os 12 quadros foram gerados e integrados em dois atlas. Sete cores, oito direções, duração e efeitos reduzidos conferidos. Build em `build/image-priority-vfx/NottgardSurvivors.exe`; suite com 0 falhas.
- FILA-021: C03 v02 e D03 v01 aprovados; Estocada e Chicote completos e integrados, seis quadros por efeito. Sete cores e duração capturadas.
- Total atual: 159 PNGs no manifesto. Molor, Shedaklah, Durão e Feng Tu completos. Feng Tu:6atores126quadros/25tiras. Build image-priority-feng-tu-complete8307924+ validada. Shendilavri:2de5pilotos gerados; quota até2026-10-05 12:43:35BRT; retomaI03 antesgatevisual. Evidência: [EVID-145](../evidence/EVID-145-fila-de-imagens-prioritaria-2026-10-02.md).

As tabelas históricas abaixo preservam a prioridade anterior; esta seção registra o estado mais recente e evita gerar novamente os itens acima. Admissão local feita sob o pedido de 2026-10-02, sem atribuir aprovação visual individual ao dono.

| ID | Tipo | Item | Sabor Nottgard (preencher no lote) | Origem | Dependência |
|---|---|---|---|---|---|
| ART-001 | verificação | Captura runtime do Zumbi v01 em janela interativa (só a prancha foi vista) | Dagruve · Zumbi | [EVID-104](../evidence/EVID-104-zumbi-admissao-2026-09-29.md) | acompanha BUG-001 |
| ART-002 | layout | Barra de progresso da fase no HUD | a definir | EVID-088 nota 3 | destrava MEC-002; ART-PROMPTS-043 pronto, fila CHATGPT-FILA-012 (U01-U02) |
| ART-003 | layout | Catálogo de itens do menu Esc: cartas desbloqueadas, silhueta escura para bloqueadas | a definir | EVID-088 nota 2 | destrava MEC-003; ART-PROMPTS-043 pronto, fila CHATGPT-FILA-012 (U03-U04) |
| ART-004 | ícone + VFX | Item de dano temporário (chama/lança-chamas) | a definir (divindade de fogo?) | PLAN-030 item 5 | destrava MEC-004; ART-PROMPTS-043 pronto, fila CHATGPT-FILA-012 (U05-U06) |
| ART-005 | props + ícones | Um visual por novo evento aleatório | a definir | EVID-091 resposta 10 | destrava MEC-005 |
| ART-006 | áudio | *A confirmar:* sons de loja, ferreiro, curandeiro, quebráveis (só `quebravel` consta no `audio_manifest.json`) e sinergia | — | `data/audio_manifest.json` | SPEC-064, 075 |
| ART-007 | UI | *A confirmar:* números de dano maiores e mais claros, referência Vampire Survivors / Death Must Die. SPEC-033 só colorou por afinidade divina | — | EVID-088 nota 5 | — |
| ART-008 | asset | Asset visual da névoa (hoje inexistente) | Névoa · Docas / Abismo, ver SPEC-034 | [EVID-106](../evidence/EVID-106-playtest-publico-t01-higor-2026-09-29.md) IN-002 | acompanha MEC-017 |
| ART-009 | props/NPC | Assets do curandeiro e do ferreiro (a loja também, se faltar) | a definir | [EVID-106](../evidence/EVID-106-playtest-publico-t01-higor-2026-09-29.md) IN-003; T02 N4 + texto livre: eventos de loja, ferreiro e curandeiro **indistinguíveis** no mapa (**2 relatos**) | —; **INTEGRADO 2026-09-29:** PNGs oficiais admitidos (EVID-110 do lote 1) e exibidos em `ui/overlay.gd`; o quadrado colorido provisório só resta para doação, aposta e ampulheta (ART-018 a 020)|
| ART-010 | VFX + áudio | Impacto ao subir de nível: efeitos visuais e sonoros, ref. Castlevania Symphony of the Night | a definir | [EVID-106](../evidence/EVID-106-playtest-publico-t01-higor-2026-09-29.md) IN-006; T02 Q7 concorda; T03 Q7 **discorda** | acompanha MEC-008; ART-PROMPTS-043 pronto, fila CHATGPT-FILA-012 (U07) |
| ART-011 | asset | Baú de Chefe (visual distinto dos baús comuns) | a definir por chefe/divindade | [EVID-106](../evidence/EVID-106-playtest-publico-t01-higor-2026-09-29.md) IN-013; T02 Q10 concorda; T03 Q10 concorda | destrava MEC-013 |
| ART-012 | ambientação | Nova camada de cenário por bioma: casas/ruínas, grama, areia, caminhos de pedra, trilhas; remeter a acontecimentos da lore; reaproveitar assets existentes. T01 pede recomendações (refs de jogo do projeto) | por bioma, lote grande | [EVID-106](../evidence/EVID-106-playtest-publico-t01-higor-2026-09-29.md) IN-010, IN-018; T02 Q12 "em parte"; T03 Q12 "em parte" | relaciona-se a BUG-013 |
| ART-013 | cutscene/HQ | **HQs novas** (direção do dono, 2026-09-29): catálogo em [PLAN-040](../vault/drafts/PLAN-040-hqs-novas-highlights-do-vault-2026-09-29.md), estilo e piloto em [ART-PROMPTS-027](../generated/ART-PROMPTS-027-hqs-novas-guia-de-estilo-e-piloto.md). 3 HQs do Nottcard são candidatas ([EVID-109](../evidence/EVID-109-importacao-das-hqs-do-nottcard-2026-09-29.md)); falta admissão e integração pela [SPEC-080](../specs/SPEC-080-hqs-de-transicao-do-nottcard.md). [Histórico](#art-013) | história de Nottgard | [EVID-106](../evidence/EVID-106-playtest-publico-t01-higor-2026-09-29.md) IN-016 | destrava MEC-015, MEC-016 |
| ART-014 | VFX/UI | Visual da mini-cinemática de evolução de arma | a definir; **Provisório 2026-09-29:** painel procedural em código (SPEC-091); falta visual e som próprios | [EVID-106](../evidence/EVID-106-playtest-publico-t01-higor-2026-09-29.md) IN-008 | destrava MEC-009; ART-PROMPTS-043 pronto, fila CHATGPT-FILA-012 (U08-U09) |
| ART-015 | asset/VFX | Ímã de experiência mais evidente (asset do pickup e/ou efeito ao atrair os cristais) | [EVID-107](../evidence/EVID-107-playtest-publico-t02-hiago-2026-09-29.md) IN-026 | —; **INTEGRADO 2026-09-29:** `assets/pickups/magnet.png` oficial, maior (32 px) e com brilho pulsante; a ferradura provisória foi removida|
| ART-016 | UI/cor | **Cor de raridade** nas ofertas de item, loja e forja (comum, mágico, raro, único). Hoje a oferta pinta de verde o item **novo** sem olhar a raridade (`ui/hud.gd`) e empurra a troca de um raro por um comum (print 004) | [EVID-108](../evidence/EVID-108-playtest-publico-t03-dna-2026-09-29.md) IN-036 | acompanha MEC-019; **IMPLEMENTADO 2026-09-29** (`ui/hud.gd`: cor pela raridade, sem verde fixo; aguarda run real, PLAN-039) |
| ART-017 | UI/texto | Explicar "+1 redução" (é redução de dano recebido) e os demais rótulos de atributo em ofertas e ficha | [EVID-108](../evidence/EVID-108-playtest-publico-t03-dna-2026-09-29.md) IN-038 | acompanha MEC-019; **IMPLEMENTADO 2026-09-29** parcial: "redução de dano". CA/CAM/coleta seguem abreviados; aguarda run real |
| ART-021 | animação | Animação no **padrão Zumbi** para os 47 inimigos que ainda são estáticos (perfis A/B/C, 20–26 quadros; métodos 1 e 2). Plano, orçamento (~1 070 quadros ou ~210 imagens) e ondas em [PLAN-041](../vault/drafts/PLAN-041-animacao-padrao-zumbi-para-inimigos-e-interacoes-2026-09-29.md) | por inimigo, bioma da fase | Zumbi ([EVID-104](../evidence/EVID-104-zumbi-admissao-2026-09-29.md)); dono, 2026-09-29 | D-A1 a D-A6 aprovadas (2026-09-29). [PLAN-048](../vault/drafts/PLAN-048-geracao-animacoes-mobs-onda-1-2026-09-30.md) e identidades I01–I08 ([ART-PROMPTS-032](../generated/ART-PROMPTS-032-mobs-onda-1-identidade.md), [EVID-127](../evidence/EVID-127-mobs-wave-1-gate-identidade-2026-09-30.md)) aprovados. **Admitido 2026-09-30:** 37 tiras de animação para 9 mobs da Onda 1, integradas e validadas sem falhas ([SPEC-111](../specs/SPEC-111-admissao-animacoes-mobs-onda-1.md), [EVID-138](../evidence/EVID-138-admissao-animacoes-mobs-onda-1-2026-09-30.md)). Durvall e Leoric permanecem candidatos. **Prompts por bioma prontos (2026-10-01, nada enviado):** Shedaklah [ART-PROMPTS-044](../generated/ART-PROMPTS-044-mobs-shedaklah.md), Molor 045, Durao 046, Feng Tu 047, Shendilavri 048, Goranthis 049, Pilares 050; filas CHATGPT-FILA-013 a 019; 702 quadros no total (Dagruve e Docas já estão animadas). [Histórico](#art-021) |
| ART-022 | animação | Interações: regerar **baú abrindo** (`chest_open`, solidez 43 %) e **altar** (39 %); baú de chefe com animação própria; idle de loja, ferreiro e curandeiro; 10 quebráveis com `death` (romper) | por interação | [PLAN-041](../vault/drafts/PLAN-041-animacao-padrao-zumbi-para-inimigos-e-interacoes-2026-09-29.md); acompanha ART-009 e ART-011 | depende da admissão do Lote 1 (ART-PROMPTS-025) |
| ART-018 | props/NPC | Asset da **Ampulheta** (evento que adianta o tempo do mapa). Hoje é um quadrado lilás com rótulo; PNG definitivo em `assets/interactions/ampulheta.png` | [[SPEC-085-jogar-mais-rapido-2x-e-ampulheta]] | acompanha MEC-010 ; ART-PROMPTS-042 pronto, fila CHATGPT-FILA-011 |
| ART-019 | props/NPC | Asset do **Altar da Doação** (evento). Hoje quadrado lilás com rótulo; PNG em `assets/interactions/doacao.png` | [[SPEC-087-fidelidade-e-eventos-de-risco]] | acompanha MEC-005 ; ART-PROMPTS-042 pronto, fila CHATGPT-FILA-011 |
| ART-020 | props/NPC | Asset da **Mesa de Aposta** (evento). PNG em `assets/interactions/aposta.png` | [[SPEC-087-fidelidade-e-eventos-de-risco]] | acompanha MEC-005 ; ART-PROMPTS-042 pronto, fila CHATGPT-FILA-011 |
| ART-024 | asset | **Miniatura de Docas** (`assets/stages/docas_thumb.png`): hoje a linha "2. Docas" do menu aparece sem imagem | Docas · cais, fenda e porão ritual | [EVID-139](../evidence/EVID-139-playtest-higor-qa-14b15e4-2026-10-01.md) IN-045 | ART-PROMPTS-039 pronto (`.atena/generated/`), aguarda geração da imagem |
| ART-025 | background | **Fundos das fases** melhorados e coerentes com o cenário e com os novos assets (piloto Dagruve + Docas) | Dagruve (névoa/culto) · Docas (cais) | [EVID-139](../evidence/EVID-139-playtest-higor-qa-14b15e4-2026-10-01.md) IN-047/048 | ART-PROMPTS-040 pronto; fila CHATGPT-FILA-010 (C01-C02), aguarda geração; destrava MEC-030 |
| ART-026 | props | Props temáticos do piloto: estradas, carroças, destrutíveis, objeto interativo e armadilha por bioma | Dagruve · Docas | [EVID-139](../evidence/EVID-139-playtest-higor-qa-14b15e4-2026-10-01.md) IN-047 | ART-PROMPTS-041 pronto; fila CHATGPT-FILA-010 (C03-C11), aguarda geração; destrava MEC-030 |
| ART-027 | sprite + VFX | Cópia-isca de Sylas (Passo pelas Sombras) e explosão sombria | Mask / sombra | [EVID-139](../evidence/EVID-139-playtest-higor-qa-14b15e4-2026-10-01.md) IN-043 | destrava MEC-029; **hoje usa o sprite do Sylas em roxo como provisório**; ART-PROMPTS-042 pronto, fila CHATGPT-FILA-011 (S01-S02) |
| ART-028 | VFX | **Golpes corpo a corpo** das 12 armas: kit de 6 quadros, arte neutra, tinta em runtime. Hoje é um cone translúcido de 0,16 s (`_swing` em `ui/run.gd`) | kit físico + exceções radiante, fogo e mágico | dono, 2026-10-01 ([PLAN-051](../vault/drafts/PLAN-051-vfx-de-ataques-e-magias-2026-10-01.md)) | **piloto pronto:** [ART-PROMPTS-051](../generated/ART-PROMPTS-051-piloto-vfx-corpo-a-corpo-fisico.md), fila [CHATGPT-FILA-020](../generated/CHATGPT-FILA-020-piloto-vfx-corpo-a-corpo-fisico.md) (12 imagens, nada enviado); as exceções (estocada, chicote, arcos radiante e de fogo) estão em [ART-PROMPTS-052](../generated/ART-PROMPTS-052-vfx-corpo-a-corpo-excecoes.md), fila [CHATGPT-FILA-021](../generated/CHATGPT-FILA-021-vfx-corpo-a-corpo-excecoes.md) (24 imagens); a integração em `ui/run.gd` é mecânica |
| ART-029 | VFX | **Projéteis e magias**: 8 projéteis (voo 4 + impacto 4) e 7 explosões (hoje só um anel `Line2D`) | orbe radiante, orbe arcano, trovão, anel radiante, ampulheta | dono, 2026-10-01 (PLAN-051) | prompts prontos: [ART-PROMPTS-053](../generated/ART-PROMPTS-053-vfx-projeteis-e-explosoes.md), fila [CHATGPT-FILA-022](../generated/CHATGPT-FILA-022-vfx-projeteis-e-explosoes.md) (36 imagens, nada enviado); só depois do piloto ART-028 |
| ART-030 | VFX | **Habilidades dos 10 heróis** (corte, guarda, aura de cura, dash, overdrive, golpe no chão, estrelas, charme, tempo parado, guarda-nova): hoje sem visual próprio | por herói e divindade | dono, 2026-10-01 (PLAN-051) | prompts prontos: [ART-PROMPTS-054](../generated/ART-PROMPTS-054-vfx-habilidades-dos-herois.md), fila [CHATGPT-FILA-023](../generated/CHATGPT-FILA-023-vfx-habilidades-dos-herois.md) (60 imagens, nada enviado); só depois do piloto; zonas e golpes de inimigos ficam fora até o dono pedir |
| ART-031 | sprite + animação | **Refazer o Korrak** (prioridade baixa, adiado em 2026-10-03): idle e tiras de caminhada têm figurinos diferentes (idle ereto, armadura aparente; caminhada curvada, pele de fera nos ombros) e a troca parece pulo; as tiras antigas (commit `0217b2f`) têm machado cortado nas bordas e as regeneradas (FILA-024) são menores e alaranjadas. Refazer idle, caminhada, ataque e habilidade no mesmo figurino e proporção, e só então reavaliar o espelhamento para oeste. Comparativo em `.atena/generated/ground-review/korrak_antigo_vs_novo.png` | Korrak | dono, 2026-10-03; BUG-021, BUG-025; `tools/korrak_walk_probe.tscn` mede a caminhada | sem prioridade; hoje anda só com as tiras (código revertido, commit 31b30e0) |
| ART-032 | sprite + ícone | **NPCs e pontos dos acontecimentos (SPEC-118)**: João Barbosa, desertor, vítima enfeitiçada, Irmã Radiante (Nyxara/Vaelis), Graz'zt (aliado), Reaper barqueiro, Vhaerith na jaula, mercador de Rivenheart; pontos: trono de Zuggtmoy, arco de pedra, massa de Thullgrime, Estrela do Norte, Coração de Limo, esporo e limo; arte própria da Manifestação de Juiblex (hoje usa a do receptáculo). Hoje: figura e losango provisórios | por bioma | MEC-038 (2026-10-03) | aberto |
| ART-033 | animação | **Costas ao andar para cima** (move_n e move_ne) de Zynara, Leoric e Nyrelia: 6 tiras novas, costas inventadas a partir da frente (decisão de design do dono) | heróis jogáveis | BUG-027 (2026-10-04); [ART-PROMPTS-056](../generated/ART-PROMPTS-056-costas-ao-andar-para-cima-zynara-leoric-nyrelia.md) | prompts prontos; aguarda gerador |
| ART-034 | ícone/UI | **Ícones das habilidades ativas (Q/RMB)** dos 10 heróis, com variante de recarga (para MEC-043) | habilidades dos heróis | Manzi (T04), IN-053 | **Provável dispensado:** os 10 ícones já existem em `assets/icons/abilities/` (EVID-163); só gerar arte nova se o dono achar os ícones fracos |
| ART-035 | UI/prompts | **Prompts e arte para embelezar a ficha `C`** (molduras, categorias, ícones de seção; MEC-045) | ficha de personagem | Manzi (T04), IN-055; pedido explícito de criar prompts | prompts a escrever **depois** da aprovação do layout ([[SPEC-130-ficha-c-em-abas-grade-e-detalhe]]) |

> **Fila consolidada para o ChatGPT:**
> [CHATGPT-FILA-001](../generated/CHATGPT-FILA-001-prompts-prontos.md) reúne os
> 39 prompts prontos (Lotes 1 e 2 e piloto de HQ). **Em andamento**: já enviados
> ao ChatGPT pelo dono.
>
> **Remessa separada — HQs, Ondas 1 e 2:**
> [CHATGPT-FILA-002](../generated/CHATGPT-FILA-002-hqs-ondas-1-e-2.md) (52 prompts,
> numeração H01–H52, origem em
> [ART-PROMPTS-028](../generated/ART-PROMPTS-028-hqs-onda-1.md) e
> [ART-PROMPTS-029](../generated/ART-PROMPTS-029-hqs-onda-2.md)). Ainda não
> enviada; não tem relação com os pedidos em andamento da FILA-001.
>
> **Remessa opcional — HQs, Trilha C:**
> [CHATGPT-FILA-003](../generated/CHATGPT-FILA-003-hqs-trilha-c.md) (16 prompts,
> C01–C16, origem em
> [ART-PROMPTS-030](../generated/ART-PROMPTS-030-hqs-trilha-c.md)). Só vale
> gerar se o MEC-015 (venda de HQs) for aprovado.
>
> **Remessas novas (2026-10-01), por prioridade de envio:**
>
> | # | Fila | Itens | Por quê |
> |---|---|---|---|
> | 1 | ART-024, [ART-PROMPTS-039](../generated/ART-PROMPTS-039-miniatura-das-docas.md) (sem fila própria) | 1 | falha visível no menu; precisa existir antes de C02 |
> | 2 | [CHATGPT-FILA-009](../generated/CHATGPT-FILA-009-fundo-da-tela-de-titulo.md) | 1 (T01) | primeira tela que o jogador vê; barata |
> | 3 | [CHATGPT-FILA-010](../generated/CHATGPT-FILA-010-piloto-cenario-dagruve-docas.md) | 11 (C01–C11) | destrava MEC-030/033/034/035; enviar C03–C11 (props) antes de C01–C02 (fundos) |
> | 4 | [CHATGPT-FILA-011](../generated/CHATGPT-FILA-011-isca-sylas-e-eventos.md) | 5 (S01–S05) | troca provisórios de MEC-029 e dos eventos |
> | 5 | [CHATGPT-FILA-012](../generated/CHATGPT-FILA-012-ui-e-vfx-pendentes.md) | 9 (U01–U09) | polimento; depende de mecânicas já feitas |
>
> Filas 004 a 008 (piloto do cultista e mobs da onda 1) seguem em andamento pelo [PLAN-048](../vault/drafts/PLAN-048-geracao-animacoes-mobs-onda-1-2026-09-30.md). Nenhuma das novas foi enviada.
>
> **Ordem de envio das filas de mobs por bioma (ART-021, Atena, 2026-10-01):** um bioma por vez, com gate de identidade (só os `idle_00`, aprovar, depois o resto) e admissão pelo rito da SPEC-111 antes de abrir o seguinte. Alternativa: trocar 1 e 2 para seguir a ordem de jogo.
>
> | # | Fila | Quadros | Por quê |
> |---|---|---:|---|
> | 1 | [CHATGPT-FILA-014](../generated/CHATGPT-FILA-014-mobs-molor.md) Molor | 66 | menor lote com chefe; valida a receita num bioma novo |
> | 2 | [CHATGPT-FILA-013](../generated/CHATGPT-FILA-013-mobs-shedaklah.md) Shedaklah | 166 | maior reuso (limo, receptáculo e pudim aparecem em Molor, Goranthis e Pilares) |
> | 3 | [CHATGPT-FILA-015](../generated/CHATGPT-FILA-015-mobs-durao.md) Durao | 126 | `molydeus_chefe` cobre também o `molydeus_menor` |
> | 4 | [CHATGPT-FILA-016](../generated/CHATGPT-FILA-016-mobs-feng-tu.md) Feng Tu | 126 | `cultista_ghaunadaur` reaproveitado em Shendilavri e Pilares |
> | 5 | [CHATGPT-FILA-017](../generated/CHATGPT-FILA-017-mobs-shendilavri.md) Shendilavri | 106 | `sucubo` cobre a ilusão; `master_of_cruelties` aparece em Pilares |
> | 6 | [CHATGPT-FILA-018](../generated/CHATGPT-FILA-018-mobs-goranthis.md) Goranthis | 86 | `death_tyrant` e guardião aparecem em Pilares |
> | 7 | [CHATGPT-FILA-019](../generated/CHATGPT-FILA-019-mobs-pilares.md) Pilares | 26 | só a Síntese Abissal, chefe final; o resto já vem dos lotes anteriores |
>
> Roda depois, ou em paralelo, das filas de cenário (ART-024, 026, 025), que travam jogo ou bug visível.

## Lote 1 — prompts prontos (2026-09-29)

ART-008, ART-009, ART-011 e ART-015 têm prompts em
[ART-PROMPTS-025](../generated/ART-PROMPTS-025-lote-1-nevoa-bau-de-chefe-imas-e-npcs.md)
(8 imagens), na fila da SPEC-062. Continuam abertos até o dono gerar, aprovar e
admitir. O efeito de atração do ímã (ART-015) é procedural e fica fora do
prompt.

## Lote 2 — prompts prontos (2026-09-29)

ART-012 (camada de cenário por bioma) tem prompts e a recomendação pedida em
IN-010/IN-018 em
[ART-PROMPTS-026](../generated/ART-PROMPTS-026-lote-2-camada-de-cenario-por-bioma.md):
27 imagens (estrutura, remendo de solo e trilha para cada um dos 9 biomas),
com piloto em Dagruve. **Admissão trava em BUG-013** (props flutuando) e numa
spec de integração da camada de decais (SPEC-079), que ainda não existe.

## Prioridade de assets (Atena, 2026-10-01)

Critério: o que destrava jogo já implementado ou bug visível vem primeiro; depois o que o dono pediu no último playtest; arte presa a mecânica ainda não decidida vai por último.

| # | Cartão | Por quê | Fila |
|---|---|---|---|
| 1 | ART-024 miniatura de Docas | 1 imagem, falha visível no menu | ART-PROMPTS-039 (sem fila; gerar antes do C02) |
| 2 | ART-026 props do piloto | destrava MEC-030/033/034/035 | CHATGPT-FILA-010 C03–C11 (ver ordem das filas acima; título T01 entra antes) |
| 3 | ART-025 fundos Dagruve e Docas | coerência do piloto; ancora as zonas de `scenery.json` | CHATGPT-FILA-010 C01–C02 |
| 4 | ART-027 cópia-isca e explosão de Sylas | MEC-029 roda com provisório roxo | CHATGPT-FILA-011 S01–S02 |
| 5 | ART-021/022 animações de mobs e interações | em andamento (ondas 1 a 3) | CHATGPT-FILA-005 a 008 |
| 6 | ART-008, 009, 011 (lote 1: névoa, NPCs, baú de chefe) | prompts prontos; só falta gerar | ART-PROMPTS-025 |
| 7 | ART-018, 019, 020 (ampulheta, doação, aposta) | hoje quadrados lilás | CHATGPT-FILA-011 S03–S05 |
| 8 | ART-013 HQs | vale quando houver tempo de playtest narrativo | FILA-002 e 003 |
| 9 | ART-002, 003, 004, 010, 014 (UI/VFX) | prompts prontos; ART-007 e ART-006 não são imagem | CHATGPT-FILA-012 |
| — | ART-004, 005, 006, 012 | presos a decisão de mecânica, a confirmar ou já integrados | — |

## Sugestão de lote (Atena)

**Lote A1** = ART-002 + ART-003 + ART-007 (tudo que é layout/legibilidade de
UI), gerado junto; ART-004/005 ficam presos às mecânicas que os pedem, para não
gerar arte de algo que pode ser cortado. ART-006 (áudio) pode ir junto de
qualquer lote, pois não depende de decisão de design.

## Fechados (fila do [PLAN-035](../vault/drafts/PLAN-035-geracao-de-assets-pendentes-2026-09-28.md))

| Lote | Entregável | Evidência |
|---|---|---|
| A | 7 quebráveis definitivos, um por bioma | EVID-098 |
| B | 21 props decorativos (Shedaklah, Molor, Durao, Feng-tu, Shendilavri, Goranthis, Pilares) | EVID-099 a 102 e demais |
| C | 20 células de animação do Zumbi | EVID-103, EVID-104 |
| — | Regeneração de Nyrelia e Leoric | EVID-078, EVID-081 |
| — | Terrenos dos 7 biomas + Estige | SPEC-047 a 055 |

## Histórico dos cartões

Texto integral das células antes do enxugamento de 2026-09-30.

### ART-013
**Direção do dono (2026-09-29): HQs novas**, com o vault de Nottgard como fonte e as do Nottcard como inspiração; catálogo, gatilhos e conquistas em [PLAN-040](../vault/drafts/PLAN-040-hqs-novas-highlights-do-vault-2026-09-29.md), guia de estilo e piloto em [ART-PROMPTS-027](../generated/ART-PROMPTS-027-hqs-novas-guia-de-estilo-e-piloto.md). **Arte que já existe:** 3 HQs (10 quadros) do Nottcard importadas como candidatas em `.atena/generated/art-candidates/hq/` ([EVID-109](../evidence/EVID-109-importacao-das-hqs-do-nottcard-2026-09-29.md)); falta admissão e integração pela [SPEC-080](../specs/SPEC-080-hqs-de-transicao-do-nottcard.md) (decisões D1 a D5). HQs novas só se o dono pedir.

### ART-021
**Decisões D-A1 a D-A6 aprovadas (2026-09-29).** Piloto `cultista_adaga` preparado: [ART-PROMPTS-031](../generated/ART-PROMPTS-031-piloto-animacao-cultista-adaga.md), fila [CHATGPT-FILA-004](../generated/CHATGPT-FILA-004-piloto-cultista-adaga.md) (24 imagens, E01–E24). Integração em `ui/enemy_view.gd` é mecânica.

2026-10-03: Servo, Cogumelo e Esporo integrados (60 quadros / 12 tiras), manifesto 88 PNGs. Suite zero falhas; smoke nove fases ok. Limo: sete novos quadros preservados (idle_01–03, move_00–03), mais idle_00 aprovado; faltam 12 quadros. Gerador bloqueado por HTTP 429 usage_limit_reached; liberação prevista 03/10/2026 10:19:52 America/Sao_Paulo. Pudim, Gargula, Receptaculo e Zuggtmoy aguardam 82 quadros; retomada total 94 prompts em shedaklah-resume-after-limit-2026-10-03.json. Nenhum ciclo incompleto foi admitido.

2026-10-03 retomada: liberação confirmada às 10h27; Limo de Juiblex concluído e integrado (20 quadros/4 tiras), total Shedaklah 80 quadros/16 tiras, manifesto 92 PNGs. Correções do gerador: move01/02 v02, death01/05 v02. Prancha e captura runtime conferidas; testes focados zero falhas, escala/base, ataque e morte corretos. Próximo: Pudim Negro; 82 novos quadros para quatro alvos restantes. Build anterior ainda contém 88 assets.

2026-10-03: Pudim Negro concluído e integrado (20 quadros/4 tiras; body109/base356). Correções pelo gerador: move00 v02 para orientação, idle03/move03/death00 v02 para paleta. Alfa nativo preservado. Testes focados zero falhas, runtime e captura conferidos. Shedaklah: cinco alvos completos, 100 quadros/20 tiras; manifesto 96 PNGs. Próximo Gárgula; faltam 63 novos quadros em Gárgula/Receptáculo/Zuggtmoy.



2026-10-04 — Durão concluído localmente (PLAN-053/SPEC-121 S-006). Molydeus26 quadros/5 tiras admitidos: move00v02 mantém cabeça aprovada; death03v02 e death05v02 preservam direção de queda, encerrando com olhos fechados. Special02/03 usam escala uniforme1,25 para continuidade física, sem alterar RGB/alfa; escolhas em frame-selection.json e transforms em strips/packing.json. Fontes selecionadas sem cortes; solidez mínima0,957. Chefe body_height101/feet356, menor usa source_id=molydeus_chefe sem PNG duplicado; escalas reais1,9/1,6 verificadas. A habilidade aoe existente toca special do chefe. Captura real priority-review/molydeus_chefe_runtime.png inspecionada. Durão6 atores novos/126quadros/25tiras, mais menor reutilizado; manifesto134 assets/hashes válidos. Suite0 falhas, smoke9 fases, queue0, runtime chefe+menor0, export0, EXE60frames0. Build8307924+ em build/image-priority-durao-complete/NottgardSurvivors.exe,415238352bytes,SHA2562EB63495BD5F805DEB815E04397DAD29C4C9AE8560DDB4DB0B111A2A29829673. Validação duraocompleta registrada em durao-complete-build-validation-2026-10-04.json. Build inclui mudanças de balanceamento da sessão paralela sob revisão separada. BUG-025 e playtest humano permanecem pendentes; sem commit/push. Estado central PLAN-056 preservado; cursor próprio PLAN-053. Próximo checkpoint: seis pilotos de Feng Tu antes de ciclos.

2026-10-04: S-006 aguardando GATE-FENGTU-IDENTITIES-V02. Seis identidades corrigidas prontas na prancha feng-tu_identities_v02.png, sem cortes, solidez0,956–0,979; Lu Yueh seis braços e Discípulo três conforme arte estática, decisão humana pendente. Nenhum ciclo Feng Tu iniciado. Durão integrado e build completa validada; PLAN-053 escopo per-plan aprovado, gate visual independente PENDING. Estado central PLAN-056 preservado.

2026-10-04 — Build Larva validada: build/image-priority-feng-tu-larva/NottgardSurvivors.exe,8307924+,415768784bytes,SHA2562300E059814BF1065A587851B003EE7C8F772A384432CD2258EBB51652F8DF1D. Suite0falhas,smoke9fases,queue0,hash138/138,export0,EXEheadless60frames0; feng-tu-larva-build-validation-2026-10-04.json. Contém mudanças locais de balanceamento sob revisão separada, sem aprovação fictícia. Build Durão completa preservada. Acólito em geração, sem admissão prematura. BUG025/027/playtest humano pendentes.


