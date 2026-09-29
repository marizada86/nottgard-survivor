# ARTE & ÁUDIO — assets, templates, layouts, backgrounds, sons

Cada item acumula até fechar um lote. O lote vira **um** `ART-PROMPTS-NNN`
(próximo livre: 030). Todo prompt segue o **Sabor Nottgard**: divindade e bioma
envolvidos, paleta (RESEARCH-003), bestiário (RESEARCH-001), sem lore inventada.

## Abertos

| ID | Tipo | Item | Sabor Nottgard (preencher no lote) | Origem | Dependência |
|---|---|---|---|---|---|
| ART-001 | verificação | Captura runtime do Zumbi v01 em janela interativa (só a prancha foi vista) | Dagruve · Zumbi | [EVID-104](../evidence/EVID-104-zumbi-admissao-2026-09-29.md) | acompanha BUG-001 |
| ART-002 | layout | Barra de progresso da fase no HUD | a definir | EVID-088 nota 3 | destrava MEC-002 |
| ART-003 | layout | Catálogo de itens do menu Esc: cartas desbloqueadas, silhueta escura para bloqueadas | a definir | EVID-088 nota 2 | destrava MEC-003 |
| ART-004 | ícone + VFX | Item de dano temporário (chama/lança-chamas) | a definir (divindade de fogo?) | PLAN-030 item 5 | destrava MEC-004 |
| ART-005 | props + ícones | Um visual por novo evento aleatório | a definir | EVID-091 resposta 10 | destrava MEC-005 |
| ART-006 | áudio | *A confirmar:* sons de loja, ferreiro, curandeiro, quebráveis (só `quebravel` consta no `audio_manifest.json`) e sinergia | — | `data/audio_manifest.json` | SPEC-064, 075 |
| ART-007 | UI | *A confirmar:* números de dano maiores e mais claros, referência Vampire Survivors / Death Must Die. SPEC-033 só colorou por afinidade divina | — | EVID-088 nota 5 | — |
| ART-008 | asset | Asset visual da névoa (hoje inexistente) | Névoa · Docas / Abismo, ver SPEC-034 | [EVID-106](../evidence/EVID-106-playtest-publico-t01-higor-2026-09-29.md) IN-002 | acompanha MEC-017 |
| ART-009 | props/NPC | Assets do curandeiro e do ferreiro (a loja também, se faltar) | a definir | [EVID-106](../evidence/EVID-106-playtest-publico-t01-higor-2026-09-29.md) IN-003; T02 N4 + texto livre: eventos de loja, ferreiro e curandeiro **indistinguíveis** no mapa (**2 relatos**) | —; **Provisório no jogo (2026-09-29):** loja/ferreiro/curandeiro agora têm cor e rótulo (`ui/overlay.gd`); o PNG definitivo entra em `assets/interactions/<tipo>.png` e é exibido sozinho. Prompts em ART-PROMPTS-025 |
| ART-010 | VFX + áudio | Impacto ao subir de nível: efeitos visuais e sonoros, ref. Castlevania Symphony of the Night | a definir | [EVID-106](../evidence/EVID-106-playtest-publico-t01-higor-2026-09-29.md) IN-006; T02 Q7 concorda; T03 Q7 **discorda** | acompanha MEC-008 |
| ART-011 | asset | Baú de Chefe (visual distinto dos baús comuns) | a definir por chefe/divindade | [EVID-106](../evidence/EVID-106-playtest-publico-t01-higor-2026-09-29.md) IN-013; T02 Q10 concorda; T03 Q10 concorda | destrava MEC-013 |
| ART-012 | ambientação | Nova camada de cenário por bioma: casas/ruínas, grama, areia, caminhos de pedra, trilhas; remeter a acontecimentos da lore; reaproveitar assets existentes. T01 pede recomendações (refs de jogo do projeto) | por bioma, lote grande | [EVID-106](../evidence/EVID-106-playtest-publico-t01-higor-2026-09-29.md) IN-010, IN-018; T02 Q12 "em parte"; T03 Q12 "em parte" | relaciona-se a BUG-013 |
| ART-013 | cutscene/HQ | **Direção do dono (2026-09-29): HQs novas**, com o vault de Nottgard como fonte e as do Nottcard como inspiração; catálogo, gatilhos e conquistas em [PLAN-040](../vault/drafts/PLAN-040-hqs-novas-highlights-do-vault-2026-09-29.md), guia de estilo e piloto em [ART-PROMPTS-027](../generated/ART-PROMPTS-027-hqs-novas-guia-de-estilo-e-piloto.md). **Arte que já existe:** 3 HQs (10 quadros) do Nottcard importadas como candidatas em `.atena/generated/art-candidates/hq/` ([EVID-109](../evidence/EVID-109-importacao-das-hqs-do-nottcard-2026-09-29.md)); falta admissão e integração pela [SPEC-080](../specs/SPEC-080-hqs-de-transicao-do-nottcard.md) (decisões D1 a D5). HQs novas só se o dono pedir | história de Nottgard | [EVID-106](../evidence/EVID-106-playtest-publico-t01-higor-2026-09-29.md) IN-016 | destrava MEC-015, MEC-016 |
| ART-014 | VFX/UI | Visual da mini-cinemática de evolução de arma | a definir | [EVID-106](../evidence/EVID-106-playtest-publico-t01-higor-2026-09-29.md) IN-008 | destrava MEC-009 |
| ART-015 | asset/VFX | Ímã de experiência mais evidente (asset do pickup e/ou efeito ao atrair os cristais) | [EVID-107](../evidence/EVID-107-playtest-publico-t02-hiago-2026-09-29.md) IN-026 | —; **Provisório no jogo (2026-09-29):** ferradura vermelha pulsante desenhada em código; PNG definitivo em `assets/pickups/magnet.png` |
| ART-016 | UI/cor | **Cor de raridade** nas ofertas de item, loja e forja (comum, mágico, raro, único). Hoje a oferta pinta de verde o item **novo** sem olhar a raridade (`ui/hud.gd`) e empurra a troca de um raro por um comum (print 004) | [EVID-108](../evidence/EVID-108-playtest-publico-t03-dna-2026-09-29.md) IN-036 | acompanha MEC-019; **IMPLEMENTADO 2026-09-29** (`ui/hud.gd`: cor pela raridade, sem verde fixo; aguarda run real, PLAN-039) |
| ART-017 | UI/texto | Explicar "+1 redução" (é redução de dano recebido) e os demais rótulos de atributo em ofertas e ficha | [EVID-108](../evidence/EVID-108-playtest-publico-t03-dna-2026-09-29.md) IN-038 | acompanha MEC-019; **IMPLEMENTADO 2026-09-29** parcial: "redução de dano". CA/CAM/coleta seguem abreviados; aguarda run real |

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
