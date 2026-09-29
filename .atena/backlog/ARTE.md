# ARTE & ÁUDIO — assets, templates, layouts, backgrounds, sons

Cada item acumula até fechar um lote. O lote vira **um** `ART-PROMPTS-NNN`
(próximo livre: 025). Todo prompt segue o **Sabor Nottgard**: divindade e bioma
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
| ART-009 | props/NPC | Assets do curandeiro e do ferreiro (a loja também, se faltar) | a definir | [EVID-106](../evidence/EVID-106-playtest-publico-t01-higor-2026-09-29.md) IN-003 | — |
| ART-010 | VFX + áudio | Impacto ao subir de nível: efeitos visuais e sonoros, ref. Castlevania Symphony of the Night | a definir | [EVID-106](../evidence/EVID-106-playtest-publico-t01-higor-2026-09-29.md) IN-006 | acompanha MEC-008 |
| ART-011 | asset | Baú de Chefe (visual distinto dos baús comuns) | a definir por chefe/divindade | [EVID-106](../evidence/EVID-106-playtest-publico-t01-higor-2026-09-29.md) IN-013 | destrava MEC-013 |
| ART-012 | ambientação | Nova camada de cenário por bioma: casas/ruínas, grama, areia, caminhos de pedra, trilhas; remeter a acontecimentos da lore; reaproveitar assets existentes. T01 pede recomendações (refs de jogo do projeto) | por bioma, lote grande | [EVID-106](../evidence/EVID-106-playtest-publico-t01-higor-2026-09-29.md) IN-010, IN-018 | relaciona-se a BUG-013 |
| ART-013 | cutscene/HQ | HQ de acontecimentos da história de Nottgard como pequena cutscene de imagens (reaproveitar as histórias do card game "Nottcard") | história de Nottgard | [EVID-106](../evidence/EVID-106-playtest-publico-t01-higor-2026-09-29.md) IN-016 | destrava MEC-015, MEC-016 |
| ART-014 | VFX/UI | Visual da mini-cinemática de evolução de arma | a definir | [EVID-106](../evidence/EVID-106-playtest-publico-t01-higor-2026-09-29.md) IN-008 | destrava MEC-009 |

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
