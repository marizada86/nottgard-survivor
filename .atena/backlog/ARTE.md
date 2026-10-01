# ARTE & ÁUDIO — assets, templates, layouts, backgrounds, sons

## Regras

- Todo prompt respeita o **Sabor Nottgard**: divindade/bioma envolvido, paleta
  ([RESEARCH-003](../vault/research/RESEARCH-003-paleta-das-deidades-2026-09-27.md)),
  bestiário ([RESEARCH-001](../vault/research/RESEARCH-001-abismo-bestiario-visual-2026-09-21.md)),
  sem inventar lore. Sem história: a lore é só sabor.
- Itens abertos acumulam até fechar um **lote**. O lote sai como um único
  `ART-PROMPTS-NNN` (próximo livre: **044**) para o gerador de imagem.
- Candidatos ficam em `.atena/generated/` até admissão explícita do dono.

## Abertos

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
| ART-021 | animação | Animação no **padrão Zumbi** para os 47 inimigos que ainda são estáticos (perfis A/B/C, 20–26 quadros; métodos 1 e 2). Plano, orçamento (~1 070 quadros ou ~210 imagens) e ondas em [PLAN-041](../vault/drafts/PLAN-041-animacao-padrao-zumbi-para-inimigos-e-interacoes-2026-09-29.md) | por inimigo, bioma da fase | Zumbi ([EVID-104](../evidence/EVID-104-zumbi-admissao-2026-09-29.md)); dono, 2026-09-29 | D-A1 a D-A6 aprovadas (2026-09-29). [PLAN-048](../vault/drafts/PLAN-048-geracao-animacoes-mobs-onda-1-2026-09-30.md) e identidades I01–I08 ([ART-PROMPTS-032](../generated/ART-PROMPTS-032-mobs-onda-1-identidade.md), [EVID-127](../evidence/EVID-127-mobs-wave-1-gate-identidade-2026-09-30.md)) aprovados. **Admitido 2026-09-30:** 37 tiras de animação para 9 mobs da Onda 1, integradas e validadas sem falhas ([SPEC-111](../specs/SPEC-111-admissao-animacoes-mobs-onda-1.md), [EVID-138](../evidence/EVID-138-admissao-animacoes-mobs-onda-1-2026-09-30.md)). Durvall e Leoric permanecem candidatos. **Prompts por bioma prontos (2026-10-01, nada enviado):** Shedaklah [ART-PROMPTS-044](../generated/ART-PROMPTS-044-mobs-shedaklah.md), Molor 045, Durão 046, Feng Tu 047, Shendilavri 048, Goranthis 049, Pilares 050; filas CHATGPT-FILA-013 a 019; 702 quadros no total (Dagruve e Docas já estão animadas). [Histórico](#art-021) |
| ART-022 | animação | Interações: regerar **baú abrindo** (`chest_open`, solidez 43 %) e **altar** (39 %); baú de chefe com animação própria; idle de loja, ferreiro e curandeiro; 10 quebráveis com `death` (romper) | por interação | [PLAN-041](../vault/drafts/PLAN-041-animacao-padrao-zumbi-para-inimigos-e-interacoes-2026-09-29.md); acompanha ART-009 e ART-011 | depende da admissão do Lote 1 (ART-PROMPTS-025) |
| ART-018 | props/NPC | Asset da **Ampulheta** (evento que adianta o tempo do mapa). Hoje é um quadrado lilás com rótulo; PNG definitivo em `assets/interactions/ampulheta.png` | [[SPEC-085-jogar-mais-rapido-2x-e-ampulheta]] | acompanha MEC-010 ; ART-PROMPTS-042 pronto, fila CHATGPT-FILA-011 |
| ART-019 | props/NPC | Asset do **Altar da Doação** (evento). Hoje quadrado lilás com rótulo; PNG em `assets/interactions/doacao.png` | [[SPEC-087-fidelidade-e-eventos-de-risco]] | acompanha MEC-005 ; ART-PROMPTS-042 pronto, fila CHATGPT-FILA-011 |
| ART-020 | props/NPC | Asset da **Mesa de Aposta** (evento). PNG em `assets/interactions/aposta.png` | [[SPEC-087-fidelidade-e-eventos-de-risco]] | acompanha MEC-005 ; ART-PROMPTS-042 pronto, fila CHATGPT-FILA-011 |
| ART-024 | asset | **Miniatura de Docas** (`assets/stages/docas_thumb.png`): hoje a linha "2. Docas" do menu aparece sem imagem | Docas · cais, fenda e porão ritual | [EVID-139](../evidence/EVID-139-playtest-higor-qa-14b15e4-2026-10-01.md) IN-045 | ART-PROMPTS-039 pronto (`.atena/generated/`), aguarda geração da imagem |
| ART-025 | background | **Fundos das fases** melhorados e coerentes com o cenário e com os novos assets (piloto Dagruve + Docas) | Dagruve (névoa/culto) · Docas (cais) | [EVID-139](../evidence/EVID-139-playtest-higor-qa-14b15e4-2026-10-01.md) IN-047/048 | ART-PROMPTS-040 pronto; fila CHATGPT-FILA-010 (C01-C02), aguarda geração; destrava MEC-030 |
| ART-026 | props | Props temáticos do piloto: estradas, carroças, destrutíveis, objeto interativo e armadilha por bioma | Dagruve · Docas | [EVID-139](../evidence/EVID-139-playtest-higor-qa-14b15e4-2026-10-01.md) IN-047 | ART-PROMPTS-041 pronto; fila CHATGPT-FILA-010 (C03-C11), aguarda geração; destrava MEC-030 |
| ART-027 | sprite + VFX | Cópia-isca de Sylas (Passo pelas Sombras) e explosão sombria | Mask / sombra | [EVID-139](../evidence/EVID-139-playtest-higor-qa-14b15e4-2026-10-01.md) IN-043 | destrava MEC-029; **hoje usa o sprite do Sylas em roxo como provisório**; ART-PROMPTS-042 pronto, fila CHATGPT-FILA-011 (S01-S02) |

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
> | 3 | [CHATGPT-FILA-015](../generated/CHATGPT-FILA-015-mobs-durao.md) Durão | 126 | `molydeus_chefe` cobre também o `molydeus_menor` |
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
| B | 21 props decorativos (Shedaklah, Molor, Durão, Feng-tu, Shendilavri, Goranthis, Pilares) | EVID-099 a 102 e demais |
| C | 20 células de animação do Zumbi | EVID-103, EVID-104 |
| — | Regeneração de Nyrelia e Leoric | EVID-078, EVID-081 |
| — | Terrenos dos 7 biomas + Estige | SPEC-047 a 055 |

## Histórico dos cartões

Texto integral das células antes do enxugamento de 2026-09-30.

### ART-013
**Direção do dono (2026-09-29): HQs novas**, com o vault de Nottgard como fonte e as do Nottcard como inspiração; catálogo, gatilhos e conquistas em [PLAN-040](../vault/drafts/PLAN-040-hqs-novas-highlights-do-vault-2026-09-29.md), guia de estilo e piloto em [ART-PROMPTS-027](../generated/ART-PROMPTS-027-hqs-novas-guia-de-estilo-e-piloto.md). **Arte que já existe:** 3 HQs (10 quadros) do Nottcard importadas como candidatas em `.atena/generated/art-candidates/hq/` ([EVID-109](../evidence/EVID-109-importacao-das-hqs-do-nottcard-2026-09-29.md)); falta admissão e integração pela [SPEC-080](../specs/SPEC-080-hqs-de-transicao-do-nottcard.md) (decisões D1 a D5). HQs novas só se o dono pedir.

### ART-021
**Decisões D-A1 a D-A6 aprovadas (2026-09-29).** Piloto `cultista_adaga` preparado: [ART-PROMPTS-031](../generated/ART-PROMPTS-031-piloto-animacao-cultista-adaga.md), fila [CHATGPT-FILA-004](../generated/CHATGPT-FILA-004-piloto-cultista-adaga.md) (24 imagens, E01–E24). Integração em `ui/enemy_view.gd` é mecânica.
