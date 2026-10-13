# Rank de contribuições dos playtesters

Atualizado em **2026-10-10** (PLAN-096). Fonte: [INBOX](INBOX.md) (itens `IN-nnn`), [INTAKE](INTAKE.md) (códigos T01 a T04) e o estado dos cartões em [BUGS](BUGS.md), [MECANICAS](MECANICAS.md), [ARTE](ARTE.md) e [BALANCEAMENTO](BALANCEAMENTO.md). **Rascunho de pontuação proposto por Atena; ajuste os pesos a gosto** (o rank se recalcula pela tabela da seção 3).

Só conta o que chegou ao projeto e foi triado (pacote de `evidencias/`, questionário ou relato repassado). Conversa solta no Discord que não virou item não entra. O dono (T01, Higor) fica fora do rank, só como referência.

## 1. Rank

| # | Tester | Pontos | Itens triados | Aplicados | Destaque |
|--:|---|--:|--:|--:|---|
| 1 | **Daniel ("DNA", T03)** | **76** | 15 | 15 | Bloco de notas que prendia o jogo, C que não fechava a ficha e textos sobrepostos (BUG-034, 035, 036); pediu destaque para quests (hoje o questlog à direita); "mais coisas no mapa" que virou os segredos (MEC-039) |
| 2 | **Hiago ("Hiagola", T02)** | **68** | 13 | 13 | Inimigos presos em obstáculos (BUG-012) e prévia do ferreiro (BUG-015); loja mostrando o item equipado (MEC-019); escala física/mágica (MEC-018) |
| 3 | **Manzi ("manzera", T04)** | **58** | 13 | 13 | Ficha C em categorias (MEC-045), habilidade com ícone e recarga (MEC-043), opção de recusar bênção (MEC-046), arma base voltando como "NOVA" (BUG-037) |
| 4 | **Vitão** | **8** | 1 | 1 | Chefe e portal nascendo onde não dava para chegar (BUG-032, P0) |

Referência (fora do rank): Higor/T01, dono e dev, 26 itens triados em 3 sessões de playtest público e 1 de QA (IN-001 a IN-018, IN-041 a IN-048).

## 2. Como cada um pontuou

| Tester | Triados | Aplicados (×3) | Bug P0/P1 | Confirmado por outro | Questionário | Pacotes | **Total** |
|---|--:|--:|--:|--:|--:|--:|--:|
| Daniel | 15 | 45 | 6 (BUG-034, 035, 036) | 6 (BUG-013, BAL-001, BUG-003/IN-062) | 2 | 2 (1 pacote) | **76** |
| Hiago | 13 | 39 | 4 (BUG-012, BUG-015) | 6 (BUG-014, ART-009, BUG-012) | 2 | 4 (2 pacotes) | **68** |
| Manzi | 13 | 39 | 2 (BUG-037) | 4 (BAL-001, BUG-003/IN-067) | 0 | 0 | **58** |
| Vitão | 1 | 3 | 4 (BUG-032, P0) | 0 | 0 | 0 | **8** |

Itens descontados por serem repetição do mesmo relato: IN-039 e IN-072 (Daniel). IN-032 (Hiago, print sem nota) não pontua.

## 3. Tabela de pontos (v1, ajustável)

| Evento | Pontos |
|---|--:|
| Nota ou relato triado (um por item do INBOX, sem repetição) | 1 |
| Virou cartão **implementado** (bug corrigido, mecânica, arte ou número) | +3 |
| Cartão aberto, mas com plano ou arte já pedida (em andamento) | +1 |
| Bug **P1** achado | +2 |
| Bug **P0** achado | +4 |
| Achado confirmado por outro tester ou relato repetido (por item) | +2 |
| Questionário rápido respondido (por questionário) | +2 |
| Pacote de evidências com relato, log e prints (por pacote enviado direto) | +2 |

"Aplicado" quer dizer **implementado**, não **verificado em playtest**: os cartões de 0.4.0 ainda aguardam o próximo playtest para virar "verificado". Se algum voltar reaberto, os pontos de "aplicado" daquele item caem para "em andamento".

## 4. Detalhe por item

**Daniel (T03)** — EVID-108 (v0.2.x), relato verbal de 2026-10-03, EVID-200 (v0.3.3)

| Item | Tema | Cartão | Situação |
|---|---|---|---|
| IN-033 | Ferreiro só mostra "Sair" sem motivo | MEC-023 | implementado |
| IN-034 | Objetos flutuando (confirmado por T01) | BUG-013 | implementado |
| IN-035, IN-037 | Mais mobs e mais dificuldade no começo | MEC-024 | implementado |
| IN-036 | Cores de raridade e destaque do item novo | ART-016 | implementado |
| IN-038 | "+1 redução" de quê? | ART-017 | implementado |
| IN-049 | Jogo fácil demais (+1 relato do Manzi) | BAL-001, BAL-016, MEC-040 | implementado (aguarda playtest) |
| IN-050, IN-051 | Mapa maior com coisas escondidas e referências à história | MEC-012, MEC-039, MEC-032 | implementado (aguarda playtest) |
| IN-066 | Bloco de notas deixa o jogo interativo | BUG-035 (P1) | implementado (aguarda playtest) |
| IN-067 | C não fecha a ficha | BUG-034 (P1), BUG-003 | implementado (aguarda playtest) |
| IN-068 | Ranking da tela inicial não atualiza | MEC-057 | implementado (o resto aguarda o PLAN-071) |
| IN-069 | Textos sobrepostos no centro | BUG-036 (P1), BUG-042 | implementado (aguarda playtest) |
| IN-070, IN-071 | Quests e itens de quest com destaque | MEC-055, MEC-064 | implementado (aguarda playtest) |

**Hiago (T02)** — EVID-107 e questionário 002

| Item | Tema | Cartão | Situação |
|---|---|---|---|
| IN-019 | Recompensa ao interromper ritual (2º relato) | BUG-014 → MEC-026 | implementado (aguarda playtest; T03 discorda) |
| IN-020, IN-029 | Escala física/mágica e dano mín./máx. | MEC-018 | implementado |
| IN-021, IN-023, IN-027 | Loja: slot equipado, item trocado, comparação | MEC-019 | implementado |
| IN-022 | Eventos aleatórios sem asset distinto (2º relato) | ART-009 | integrado |
| IN-024 | Fontes menos frequentes | MEC-020 | implementado |
| IN-025 | Manter item 3x sobe nível (ambíguo) | MEC-021 | implementado |
| IN-026 | Ímã de XP mais evidente | ART-015 | integrado |
| IN-028 | Nv 2 de equipamento sem melhoria | BUG-015 (P1) | implementado |
| IN-030 | Mobs presos em obstáculos, Durao (2º relato) | BUG-012 (P1) | implementado |
| IN-031 | Perda de INT do Estige dura 5 min | MEC-022 | implementado |

**Manzi (T04)** — EVID-163 (v0.3.0) e EVID-199 (v0.3.2), relatos repassados pelo dono

| Item | Tema | Cartão | Situação |
|---|---|---|---|
| IN-053 | Habilidade sem ícone nem recarga | MEC-043 | implementado |
| IN-054 | C devia mostrar o que a habilidade faz | MEC-044 | implementado |
| IN-055, IN-058 | Ficha C com informação demais; CA e CAM pouco claros | MEC-045, ART-035 | implementado |
| IN-056 | Bênção sem opção de recusar; mais bênçãos | MEC-046 (MEC-047 em andamento) | implementado |
| IN-057 | v0.3.0 muito fácil (+1 relato do Daniel) | BAL-001 (BAL-018 em andamento) | implementado |
| IN-059, IN-060 | Evoluções e próximos níveis das armas | MEC-053 | implementado (sem Ctrl, decisão do dono) |
| IN-061 | Nome antes do valor nos bônus | MEC-054 | implementado |
| IN-062 | C não abre durante ofertas | já corrigido no HEAD | corrigido |
| IN-063 | Arma base volta como "NOVA" | BUG-037 (P1) | implementado (aguarda playtest) |
| IN-064 | Debuff do lago na HUD | MEC-056 | implementado (aguarda playtest) |
| IN-065 | Baú cai logo ao trocar de mapa | BAL-024 | implementado (aguarda playtest) |

**Vitão** — BUG-032 (playtest de 2026-10-06): baú do chefe e portal nasceram sem alcance; implementado, aguarda playtest.

## 5. Limites e perguntas abertas

- **T04 (Manzi) e parte do T03 (Daniel) são relatos de segunda mão**, escritos pelo dono; não têm pacote de `evidencias/` e por isso não ganham pontos de pacote.
- Vitão só aparece em BUG-032; se houve outras notas dele fora do INBOX, faltam aqui.
- Só há registro do questionário 002 (Hiago e Daniel); não encontrei respostas dos questionários 003 a 007 nos EVID. Se existirem fora do repositório, o rank sobe quando entrarem.
- A 0.4.0 ainda não foi avisada aos testers; as respostas a ela entram na próxima atualização.
- Dúvidas pendentes que podem mudar pontos: IN-060 (era Shift em vez de Ctrl?), IN-064 (em qual fase estava o lago?), IN-025 e IN-032 (Hiago).
