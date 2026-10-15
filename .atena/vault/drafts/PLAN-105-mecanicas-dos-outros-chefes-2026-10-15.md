---
id: "PLAN-105"
title: "Mecânicas de chefe nos outros 6 mapas (rollout do piloto L5)"
created: "2026-10-15"
status: "APROVADO por lote em 2026-10-15; B-001 a B-003 aprovados (G-L5-1 a G-L5-3); B-004 implementado local (EVID-264), aguarda G-L5-4; falta o B-005"
content_state: DRAFT
request_classification: IN_PLAN   # M4a (chefes marcantes) do PLAN-103, decisão D6
relations: ["[[PLAN-103-demo-completa-e-polida-2026-10-14]]", "[[PROPOSTA-l5-mecanicas-de-chefe-2026-10-14]]", "[[EVID-257-l5-mecanicas-de-chefe-piloto-2026-10-15]]"]
spec_reservada: "SPEC-179"
---

# PLAN-105: mecânicas de chefe nos outros 6 mapas

## 1. Ponto de partida
- Piloto L5 (Sacerdote, Guardião Alado, Blogbog) **testado e aprovado pelo dono em 2026-10-15** (commits `b58f6f70` e `2ecc5b8d`).
- Já existe a base: `core/boss_mechanics.gd`, `data/boss_mechanics.json`, bloco `boss_mech` com interruptor por verbo, orçamento de caos (2 mecânicas nas ordens 0 a 2, 3 nas ordens 3 a 5, 4 nas ordens 6 a 8; **cresce com o mapa**, como o dono aprovou).
- Faltam 6 chefes: Zuggtmoy, Molydeus, Discípulo Pestilento, Malcanthet, Socothbenoth e A Síntese Abissal.
- Regras que continuam: aviso de pelo menos 1 s, interruptor por verbo, fase de 35% **troca** o conjunto (não empilha), caos moderado sem exagerar, e **mais um olhar além do Mariz** antes de fechar.

## 2. O que cada chefe ganha (rascunho para o dono aprovar)
Orçamento = quantas mecânicas podem estar ativas ao mesmo tempo (já no código). Semente temática = lore do Vault (somente leitura; sem tocar em "cânone do mestre").

| Chefe (fase, ordem) | Orçamento | Fase de 70% (assinatura) | Fase de 35% (troca) | Semente |
|---|---|---|---|---|
| **Zuggtmoy** (Shedaklah, 2) | 2 | **V2 Quadrantes de esporos** (3 de 4 quadrantes; deixam poça que corrói 8 s) | **V1 Cogumelos-mãe**: 3 cogumelos **curam o chefe** 2% por segundo até quebrarem | soberana fúngica, "400 servos por escolha" |
| **Molydeus** (Durao, 4) | 3 | **V6 Marca de sentença**: herói marcado 3 s; ao fim, jaula (prende 1,2 s) e dano no círculo | **V3 Varredura de correntes em 2 feixes** (180° entre si) | carcereiro; fraco a radiante e necrótico |
| **Discípulo Pestilento** (Feng-tu, 5) | 3 | **V2 Quadrantes de peste** + **V6 Marca da peste** (a explosão deixa poça) | **V4 Grito na mente** interrompível (mais pesado) + **V5** com 4 cultistas | líder do ritual de Lu Yueh |
| **Malcanthet** (Shendilavri, 6) | 4 | **V5 Ilusões** (4 ilusões de súcubo; chefe imune até caírem) + **V6 Marca** | **V4 Beijo da Rainha** interrompível + **V3** (o chifre perdido: varredura de um lado só) | rainha das súcubos, Rivenheart "quase toda ilusão" |
| **Socothbenoth** (Goranthis, 7) | 4 | **V2 Quadrantes** (3 de 4) + **V1** (2 âncoras de Juiblex que curam) | **V5** com 6 ilusões + **V4** | lorde usado como âncora por Juiblex |
| **A Síntese Abissal** (Pilares, 8) | 4 | **V1 Lodo** (3 poças-fonte que absorvem slimes e curam) + **V3** | **V4 Armadura do Psíquico**: se não interromper, o chefe ganha 40% de redução por 6 s + **V2** + **V6** | boss final: fusão de Durvall e a armadura de Astherion; presença de Ghaunadaur |

**Regra de leitura:** as mecânicas dos mapas 7 e 8 (Goranthis e Pilares) somam 2 verbos por fase porque o orçamento deles é 4. O Pilares é o modo infinito: o chefe nasce aos 300 s e a luta pode voltar; a mecânica reinicia com o chefe.

## 3. Verbos e parâmetros que faltam construir (B-001)
| # | Item | Observação |
|---|---|---|
| N1 | **V6 Marca** | marca no herói por 3 s com anel e contagem; ao fim: círculo (raio 3) com dano; opções `jail` (prende 1,2 s) e `puddle` (deixa poça). Máx. 1 por vez (regra do orçamento) |
| N2 | **V1 com cura** (`heal_pct_s`) | o turíbulo ou cogumelo cura o chefe em vez de blindar; o código de blindagem já existe |
| N3 | **V3 com 2 feixes** (`beams`, `gap_deg`) e feixe único espelhado | parâmetros na varredura |
| N4 | **V2 com `lit`** (quantos quadrantes acendem) e `puddle` | hoje fixo em 2 |
| N5 | **V4 com efeito** (`effect: heavy|armor`) | `armor` dá 40% de redução por 6 s se não interromper |
| N6 | **V5 com `n` e `id` por chefe** | já parametrizado; só dados |
| N7 | **Pilares do cenário bloqueiam a varredura** | proposta original (V3), ficou fora do piloto; **opcional** (a decidir) |

## 4. Lotes (cada um com testes, captura e `bot_curva` antes e depois)
| Lote | Conteúdo | Gate do dono |
|---|---|---|
| **B-001** | N1 a N6 (verbos e parâmetros); nenhum chefe novo; testes por verbo e interruptores | G-L5-1: aprovar os verbos novos e o comportamento da Marca |
| **B-002** | Zuggtmoy e Molydeus (orçamentos 2 e 3) | G-L5-2: jogar os dois |
| **B-003** | Discípulo Pestilento e Malcanthet (orçamentos 3 e 4) | G-L5-3 |
| **B-004** | Socothbenoth e A Síntese Abissal (orçamento 4 e boss final) | G-L5-4 |
| **B-005** | Equilíbrio do conjunto: régua de 12 heróis (EVID-225) com o piloto atento, botões, e revisão do caos | G-L5-5: aceite de equilíbrio |

**Fora do plano (precisam de decisão e geração):** arte e som próprios do turíbulo, do cogumelo-mãe e das âncoras (ART-049 e seguintes), e imagens de abertura dos chefes sem apresentação (7 de 9).

## 5. Como cada lote é verificado
- Teste novo por verbo e por chefe: assinatura só na fase certa, orçamento, interruptor, limpeza ao morrer o chefe.
- Mutações nas regras novas (como no piloto).
- Captura em janela real de cada mecânica.
- `bot_curva`: L5 desligado, bot cego e bot atento, para ver quem ignora as mecânicas e quem reage. **Não substitui o jogador.**
- Registro em EVID e commit local por lote (com a sua aprovação).

## 6. Decisões que preciso de você
1. **Nível de aprovação para este plano:** (1) por plano, (2) por lote ou (3) por etapa. Recomendo **por lote** (5 gates acima).
2. **O que o piloto pediu de ajuste?** Se houver (tempo da conjuração, escudo do turíbulo, enrage), eu ajusto no B-001.
3. **Os 6 desenhos da seção 2** valem como estão, ou troca algum verbo?
4. **N7 (pilar bloqueia a varredura)** entra? Dá profundidade, mas exige marcar pilares do cenário em 9 mapas.
5. **Quem joga cada gate:** você sozinho, ou o Mariz mais Daniel ou Hiago, como combinado?
6. **A Síntese Abissal é o chefe final:** quer que ela tenha mais caos do que o teto de 4 (um pico de mecânicas), ou mantém a regra?

## 7. Aprovação registrada (2026-10-15)
- **Nível de aprovação: `per-batch` (por lote).** Cada lote B-001 a B-005 pede a sua aprovação antes de começar; commit e push seguem pedindo aprovação à parte.
- **Desenhos da seção 2:** valem como estão (decisão do dono).
- **Decisões abertas da seção 6, assumidas até nova ordem:** (2) sem ajustes do piloto; (4) N7 (pilar bloqueia a varredura) **fora** do B-001; (5) gates jogados pelo dono; (6) Síntese Abissal segue o teto de 4 mecânicas.
- **Estado:** B-001 implementado local em 2026-10-15, evidência [EVID-259](../evidence/EVID-259-plan-105-b001-verbos-novos-das-mecanicas-de-chefe-2026-10-15.md); aguarda o gate G-L5-1 antes do B-002.

- **B-001:** gate G-L5-1 aprovado em 2026-10-15.
- **B-002:** Zuggtmoy e Molydeus implementados local em 2026-10-15, evidência [EVID-260](../evidence/EVID-260-plan-105-b002-zuggtmoy-e-molydeus-2026-10-15.md); aguarda o gate G-L5-2. Ajustes que o lote exigiu: teto de cura dos totens, mira automática que prefere totens e servos, interruptor por chefe (`off_bosses`).

- **B-002:** gate G-L5-2 aprovado em 2026-10-15.
- **B-003:** Discípulo Pestilento e Malcanthet implementados local em 2026-10-15, evidência [EVID-261](../evidence/EVID-261-plan-105-b003-discipulo-pestilento-e-malcanthet-2026-10-15.md); aguarda o gate G-L5-3.

- **B-003:** gate G-L5-3 aprovado em 2026-10-15.
- **B-004:** Socothbenoth e A Síntese Abissal implementados local em 2026-10-15, evidência [EVID-264](../evidence/EVID-264-plan-105-b004-socothbenoth-e-sintese-abissal-2026-10-15.md); aguarda o gate G-L5-4. Os 9 chefes têm mecânicas. Ajustes do lote: enrage com início próprio por chefe; Síntese sem a Marca em 35