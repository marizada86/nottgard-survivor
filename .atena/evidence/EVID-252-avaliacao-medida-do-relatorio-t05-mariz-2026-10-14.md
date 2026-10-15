---
id: "EVID-252"
title: "Avaliação medida do relatório do T05 (Mariz): sondas, capturas e leitura de dados"
created: "2026-10-14"
relations: ["[[EVID-250-relato-t05-mariz-v040-2026-10-14]]", "[[EVID-251-bug-044-e-bug-045-volume-e-tela-de-resultado-2026-10-14]]", "[[AVALIACAO-playtest-t05-mariz-v040-2026-10-14]]"]
cards: ["BUG-046", "BUG-012", "BAL-001", "MEC-031", "MEC-043"]
content_state: DRAFT
---

# EVID-252 — Avaliação medida do relatório do Mariz

Nenhum arquivo do jogo foi alterado nesta rodada (só ferramentas novas em `tools/` e capturas). Quatro sondas headless, duas capturas em janela real e leitura de dados. **Tudo é de uma build local do HEAD**, não da build que o Mariz jogou (0.4.0, `602cef5`); onde isso importa está dito.

## Ferramentas novas
| Ferramenta | O que faz |
|---|---|
| `tools/probe_boss_ttk.gd` | herói parado ao lado de cada chefe, com nível, armas e camada de meta dados; mede queda do chefe e vida perdida |
| `tools/probe_evolution_odds.gd` | só sobe de nível e escolhe ofertas; mede quantas runs evoluem a arma inicial (política aleatória e atenta) |
| `tools/probe_stuck_enemies.gd` | herói parado e imortal no centro; conta inimigos móveis parados por 6 s a mais de 4 tiles |
| `tools/capture_mariz_ui.tscn`, `tools/capture_mariz_hud.tscn` | fotografam a ficha C, a tela de resultado e os itens do painel do herói com o cursor por cima |

Capturas em `.atena/generated/mariz-playtest/` (30 PNG).

## 1. Volume (IN-077) e tela de resultado (IN-080)
Corrigidos no EVID-251. A captura `resultado16_720.png` confirma, em janela real, que com 16 conquistas o título e os botões ficam na tela e a lista rola.

## 2. 1º slot da ficha (IN-078): **não reproduzido**
Ficha C em 4 abas com o 1º slot em foco e o painel do herói da HUD com o cursor sobre retrato, 4 chips e 3 ícones de bênção: nenhum corte do lado esquerdo. O canvas é fixo em 1280×720 e a janela só escala, então 720p e 1080p saem iguais. **Hipóteses abertas:** (a) outro slot que eu não cobri (Catálogo, Quartel, Ficha em outra aba com mais itens que a grade); (b) o balão de dica de um ícone de bênção sob outra resolução ou escala do SO; (c) a build 0.4.0 antes de uma mudança posterior. Sem o Print 1 não dá para fechar.

## 3. Inimigos "presos" (IN-079): os que andam não prendem; os que ficam parados são `keep`
Herói parado e imortal no centro, mapa 60×60, 150 s por fase, duas sementes, 9 fases. Preso = inimigo móvel que não anda 0,15 tile em 6 s a mais de 4 tiles do herói.

| Fase | Presos (sem. 1 / sem. 2) | Quem |
|---|---|---|
| Dagruve | 9 / 12 | cultista_arqueiro, cultista_cajado |
| Docas | 0 / 0 | |
| Shedaklah | 10 / 12 | esporo_voador |
| Molor | 12 / 11 | cultista_thullgrime |
| Durao | 0 / 0 | |
| Feng-tu | 0 / 0 | |
| Shendilavri | 12 / 12 | sucubo |
| Goranthis | 12 / 12 | cultista_de_socothbenoth |
| Pilares | 8 / 9 | sucubo |

**Todos os "presos" são `move: "keep"`** (7 tipos em `data/enemies.json`): ficam a `keep` = 5 tiles do herói por projeto, atirando. Os 32 tipos `chase` ficaram em 0 em todas as fases e sementes. Leitura: o BUG-012 (perseguidores em obstáculos) segue corrigido neste cenário; o que o jogador vê como "preso" ou "parado" é muito provavelmente o atirador que mantém distância, sobretudo atrás de um prop. **Limite:** herói parado; obstáculos em torno do caminho de um herói que anda não foram cobertos.

## 4. Chefes
### 4.1 Estrutura (dados)
- 11 chefes (9 de fase + 2 extras de acontecimento), **só 6 verbos de habilidade** em todo o jogo: `aoe`, `ring`, `summon`, `charge`, `puddle`, `shoot`. Cada chefe é uma combinação deles com recargas diferentes (ex.: Sacerdote de Dagruve = aoe@4,5 + summon@12 + ring@9; Síntese = aoe@3 + summon@9 + ring@5 + charge@6 + puddle@2,5).
- `data/boss_phases.json`: **toda fase de chefe tem as mesmas duas fases (70% e 35%)**, feitas dos mesmos verbos: `summon`, `hazard`, `ring`, `strikes`, `enrage`.
- `data/boss_presentations.json` só tem **2 de 9 chefes** (Sacerdote e Guardião Alado); o Guardião está **sem imagem de abertura**. Os outros 7 entram só com o aviso "X surge!" (`_start_boss_intro` retorna se a apresentação é vazia).
- `scale` dos chefes: Guardião Alado **1,3 (o menor de todos)**; Sacerdote 1,6; Zuggtmoy 1,7; Blogbog 1,8; Síntese 2,2. O sprite é escalado por esse número (`ui/enemy_view.gd:213`).

### 4.2 O campo esvazia quando o chefe chega
Em `data/stages.json`, `t1` da última onda é igual a `duration` em todas as fases normais, e o chefe nasce em `time >= duration`. Depois disso o diretor só faz um "pinga-pinga" (`core/battle.gd:3225`): **1 inimigo da primeira onda a cada 3,5 s**, se houver espaço. Na Dagruve é um zumbi. Isso bate com o relato "poucos monstros simultâneos... consegui derrotá-lo parado". Além disso o chefe nasce com `minute` 0 e `(1.0 + 0.3 * tier() * 0.0)`: o escalonamento por fase está **zerado no código**; o PV do chefe é fixo (260 na Dagruve) e não acompanha o poder do herói.

### 4.3 Herói parado ao lado do chefe (sonda, sem Marcas)
Durvall, `target_state: boss`, 3 armas de nível 2 a 5, nível 6 a 20, sem equipamento nem passivas. O herói começa com 38 a 44 PV (a vida quase não cresce com o nível antes do nível 15).

| Camada de meta | Resultado parado |
|---|---|
| nenhuma | **morre em 2 a 12 s em todas as fases** (Dagruve 9 a 12 s; Socothbenoth, de Goranthis, 3,6 s) |
| dano +100%, PV +60, CA +4 | morre em 4 a 17 s em todas |
| dano +200%, PV +100, CA +6 | **só o Sacerdote de Dagruve cai (11,2 s, herói com 65% da vida mínima)**; as outras 7 matam o herói em 4 a 13 s |

PV dos chefes na sonda (já com afixos e `hp_mult` da fase): Docas 816, Shedaklah 936, Molor 1472, Durao 2560, Feng-tu 3600, Shendilavri 5000, Goranthis 7800. **Leitura:** "ganhar parado" **não** é propriedade geral da luta: um herói sem defesa perde. O chefe de Dagruve é o único que um herói forte derruba parado, e isso bate com o relato (1º chefe). O resto do relato ("poucos monstros, sem mecânica própria") vem de 4.1 e 4.2. **Limite:** o herói da sonda não tem equipamento, cura nem regeneração; o do Mariz (nível 28, 62 PV, regeneração 2, 2477 abates) tinha, e não o conhecemos.

## 5. Progressão: a arma inicial pode não evoluir nunca
Fatos de dados: **14 passivas, 5 espaços** (`owned_p < 5`, `core/battle.gd:2694`); a evolução da arma exige nível 5 **e** ter a passiva certa (`core/battle.gd:2666`); a passiva exigida da arma inicial muda por herói (Durvall: Cota de Malha; Brook: Carisma; Maelor: Constituição; Kayron: Inteligência). A passiva só entra na oferta se ainda couber nos 5 espaços.

Sonda (150 sementes por herói, 25 níveis, sem combate):

| Herói (arma → passiva exigida) | Política | Evoluiu até nv15 | até nv20 | até nv25 | Nunca evoluiu (nv25) | …dos quais com 5 espaços cheios sem a passiva |
|---|---|--:|--:|--:|--:|--:|
| Durvall (Espada Sombria → Cota de Malha) | aleatória | 0% | 1% | 3% | 97% | 63% |
| Durvall | atenta | 7% | 23% | 43% | 57% | 25% |
| Brook (Sentença de Lliira → Carisma) | aleatória | 0% | 1% | 3% | 97% | 67% |
| Brook | atenta | 4% | 16% | 27% | 73% | 39% |
| Maelor (Raio de Luz → Constituição) | aleatória | 0% | 2% | 5% | 95% | 49% |
| Maelor | atenta | 5% | 24% | 43% | 57% | 35% |
| Kayron (Descarga Estelar → Inteligência) | aleatória | 0% | 0% | 1% | 99% | 77% |
| Kayron | atenta | 0% | 9% | 21% | 79% | 59% |

"Atenta" = prioriza a evolução, a passiva exigida e subir a arma inicial. **No print do Mariz (nível 28)** a Espada Sombria está no Nv 5 e as passivas visíveis são Alcance 5, Regeneração 2, Botas Leves 5, Constituição 1 e uma quinta cortada: **sem Cota de Malha e com 5 espaços**, a evolução estava bloqueada para sempre. Ela evoluiu outra arma (Tempestade ★, que pede Botas Leves).

**Habilidade ativa (Q/RMB):** `data/abilities.json` tem 1 definição fixa por herói; o único modificador é a recarga (`cd_pct`, piso de 3 s). Não há nível, evolução nem oferta de aprimoramento no level-up.

**Limite:** a sonda não inclui baús, forja nem itens que dão armas ou passivas; é a progressão pelo level-up, que é o que o relato descreve.

## 6. Combate e feedback
- Número de dano: fonte **14 px** (acerto) e **22 px** (crítico) numa tela de 1280×720, nasce a 0,82× e dura 0,6 s (`ui/run.gd:725`, `:929`); acertos seguidos no mesmo alvo **se fundem**; teto de 14 na tela.
- Som do acerto: `combat.impact` e `combat.critical` tocam a **-14 dB** (`ui/run.gd:718`). Parada de acerto só no crítico (0,04 s).
- Análise dos 350 WAV (centroide, graves, RMS): `combat` 54 arquivos de 0,22 a 0,72 s com RMS entre -14,8 e -14,1 dBFS; `player` 24 com -14,5 a -14,1; `enemy` 153 com -14,2 a -14,1; `weapon` 60 todos com 0,34 s. **Toda a família sai do arquivo no mesmo nível (~-14 dBFS)**; a hierarquia é só o `volume_db` do manifesto. Só `boss` (59 arquivos, 1,25 s, -10,7 dBFS) é diferente. Crítico e golpe normal têm o mesmo RMS (-14,3 e -14,5). Em resumo: dinâmica plana e caudas curtas e iguais. Isso é consistente com o relato "mais cômico do que impactante", **mas não prova a percepção**: ouvir é do dono.
- O pico de 44 a 51 rótulos "-0" da névoa de borda (F-1, EVID-249) atrapalhava a leitura do número na Dagruve e nas bordas; já corrigido no M2 (não commitado).

## 7. Perigos de área, névoa e iluminação
- **Poça:** dano **fixo de `2 + tier` a cada 0,9 s** (`core/battle.gd:950`), sem escala com minuto, nível ou PV máximo: de 2,2 a ~10 PV/s no tier 7, contra 38 PV no início e 62 PV no nível 28 com regeneração 2. Cresce em importância relativa só no começo, que é o que o Mariz descreve.
- **Névoa de borda:** 3% a 9% do PV máximo por segundo, rampa de 20 s, banda de 3 tiles (`data/fog.json`); a regeneração e a cura contrabalançam; o jogador nem precisa chegar lá.
- **Maré pós-chefe:** existe (2% a 6%, anda 28 s a cada 60 tiles), mas só depois do chefe.
- **Iluminação:** a proposta R5-C (atmosfera por bioma) e R5-D (gradação e vinheta) do M2 já cobrem o pedido; aguardam o gate G-M2-3.

## 8. Itens e interface
- A troca de item sempre lista **"Equipar [novo]" primeiro e "Manter [atual]" depois**, qualquer que seja o veredito (`core/battle.gd:2512-2530`); o selo (melhor/pior) existe mas não decide a ordem nem o foco. O relato é literal.
- "Mensagem ao coletar objeto": três candidatos no código, sem print para decidir: o painel de 1 opção "Equipar X" (BUG-031, pausa e espera clique), o aviso de loot colorido por raridade e a fala do herói.
- **Avisos no topo central:** o questlog foi para a direita já na 0.4.0 (MEC-064); o que resta no topo são avisos de acontecimento e a barra do chefe.

## 9. Elites e inimigos comuns
- **2 comportamentos de movimento em 40 tipos**: `chase` (32) e `keep` (7).
- Por fase, de 2 a 4 dos 4 a 7 tipos de onda **só perseguem, sem nenhuma habilidade** (Dagruve 4 de 7; Durao 4 de 5; Shendilavri 4 de 5).
- Afixos de elite: Dagruve e Docas só têm `veloz`, `resistente`, `mortal`, `avaro` (todos de número); os de comportamento (`explosivo`, `vampirico`, `invocador`, `escudeiro`) entram na 3ª fase. Só 6 tipos `elite_only` têm habilidade própria; as elites de Dagruve (criatura_corrompida, cultista_cajado) não.
- O Tentáculo do Kraken **tem** golpe (`aoe` d10, raio 1,5, 0,9 s de aviso, alcance 6, recarga 3 s); o jogador não o percebe como ataque.

## Pendências humanas (não verificáveis aqui)
Som (comédia, peso), sensação do número de dano, leitura da tela de resultado em monitor real, se a 1ª evolução bloqueada incomoda mais que a dificuldade, e o Print 1.
