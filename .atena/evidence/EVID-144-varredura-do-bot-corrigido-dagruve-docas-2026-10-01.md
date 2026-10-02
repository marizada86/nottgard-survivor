# EVID-144 — Varredura completa com o bot corrigido (Dagruve e Docas)

Data: 2026-10-01 · build `2059e3e` (+ alteração local de `core/battle.gd` de outra sessão, não commitada) · `tools/overnight.ps1`, 348 min · 30 sementes por herói e fase, até 3 fases
Dados: `.atena/generated/overnight/2026-10-01_1250/` (RESUMO.md, bot-resumo.csv, logs; não versionado) · testes: 0 falhas
Substitui as medições de [EVID-142](EVID-142-varredura-do-bot-dagruve-docas-5-min-2026-10-01.md), truncadas pelo bot (ver [EVID-143](EVID-143-bot-travado-em-item-offer-e-chefe-das-docas-2026-10-01.md)). O bot continua sendo comparação entre heróis, não prova de dificuldade humana.

## Leitura principal: as runs são bimodais
Ou o herói morre cedo (nível ≤ 10) ou engrena e chega ao nível 30–50. A média de nível esconde isso; o que importa é **quantos morrem cedo** e **quantos passam do chefe**.

| Herói | Dagruve: morre < 150 s | Dagruve: vence o chefe | Dagruve: vence também as Docas | Docas direto: morre < 150 s | Docas direto: vence o chefe |
|---|---:|---:|---:|---:|---:|
| Korrak | 0 % | 100 % | 93 % | 0 % | 100 % |
| Maelor | 7 % | 93 % | 93 % | 13 % | 77 % |
| Bromnor | 0 % | 97 % | 93 % | 0 % | 83 % |
| Brook | 10 % | 77 % | 73 % | 23 % | 57 % |
| Nyrelia | 13 % | 60 % | 57 % | 60 % | 20 % |
| Sylas | 37 % | 60 % | 60 % | 43 % | 40 % |
| Zynara | 37 % | 47 % | 47 % | 60 % | 23 % |
| Leoric | 60 % | 33 % | 33 % | 57 % | 33 % |
| Durvall | 37 % | 30 % | 27 % | 63 % | 13 % |
| Kayron | 53 % | 30 % | 30 % | 63 % | 23 % |

(Nível mediano das runs que engrenam: 32 a 35 em Dagruve para quase todos; Zynara 16.)

## O que isso diz
1. **Três faixas claras:** Korrak, Maelor, Bromnor (quase sempre passam); Brook, Nyrelia, Sylas (passam 60–77 %); Zynara, Leoric, Durvall, Kayron (menos da metade). Pelo critério do dono (diversidade; fraco no começo e forte no fim é bem-vindo), o ponto a vigiar é a faixa de baixo e o começo de Dagruve, não a ordem em si.
2. **Quem sobrevive ao começo vira forte.** Os heróis do fundo, quando engrenam, chegam ao mesmo nível 30+ dos outros (Leoric, Durvall, Kayron, Sylas): o gargalo é **o primeiro minuto e meio**, não o fim da run. Isso combina com a ideia "fraco no começo, forte no fim", mas com 37 a 60 % de mortes antes de 2:30 é um começo punitivo demais.
3. **Nyrelia** (calibrada em BAL-014 com bot truncado) vai bem em Dagruve (60 %) e muito mal começando nas Docas (20 %, nível mediano 2): sem o nível acumulado em Dagruve ela não aguenta. É plausível para o jogo real, onde ninguém entra nas Docas no nível 1.
4. **Começar direto nas Docas** (`hp_mult` 1,35, tier 1) mata de 40 a 63 % dos heróis fracos em menos de 150 s. É o pior cenário (nível 1); o caminho real passa por Dagruve.
5. **Chefe das Docas:** com o ajuste de EVID-143, 73 a 93 % dos que vencem Dagruve também vencem as Docas, para os heróis do topo; sem ajuste em quem já chega fraco, como esperado.

## Efeito nos cartões
- **BAL-013 (Kayron) e BAL-014 (Nyrelia/Zynara/Durvall):** refeitos com este dado. Kayron e Durvall são os mais frágeis (30 % de vitória em Dagruve); Zynara melhorou (47 %), Nyrelia está no meio (60 %).
- **BAL-015 (mortes no início):** confirmado como o principal problema; alvo proposto: nenhum herói acima de 30 % de morte antes de 2:30, preservando a diferença de estilo.

## Ajuste de Leoric e Kayron (BAL-015, parte 1) — 2026-10-01
Dagruve, 30 sementes por teste, bot corrigido. Meta: morte antes de 2:30 em torno de 30 %, sem aproximar o herói do Korrak. Cada herói recebeu alavancas próprias, sem uniformizar.

| Herói | Mudança | Morre < 150 s | Vence o chefe |
|---|---|---:|---:|
| Leoric (antes) | 24 PV, CA 0 | 60 % | 33 % |
| **Leoric (depois)** | **30 PV, CA 2** (passiva intacta) | **30 %** | **63 %** |
| Kayron (antes) | 28 PV, CA 1, recarga −10 % | 53 % | 30 % |
| Kayron, teste 1 | 32 PV, +10 % de dano | 56 % | 36 % |
| Kayron, teste 2 | 36 PV, CA 2, +20 % de dano | 40 % | 53 % |
| **Kayron (depois)** | **36 PV, CA 2, +20 % de dano, recarga −18 %** | **33 %** | **40 %** |

Leitura: o erro estatístico com 30 sementes é de ~8 pontos, então Kayron fica "no entorno de 35–40 %" para morte inicial. O perfil resultante: Leoric (controle, resistente) passa de 60 % dos casos; Kayron (canhão de vidro rápido) fica arriscado, abaixo do meio da tabela, por desenho. A passiva de Kayron passou de "−10 % de recarga e +15 % de área" para "−18 % de recarga, +15 % de área e +20 % de dano".
Testes: 0 falhas. Falta confirmar em playtest humano. Restam Durvall, Sylas e Zynara (37 %).

## Ajuste de Durvall, Sylas e Zynara (BAL-015, parte 2) — 2026-10-01
Mesma configuração (Dagruve, 30 sementes, bot corrigido).

| Herói | Mudança | Morre < 150 s | Vence o chefe |
|---|---|---:|---:|
| Durvall (antes) | 30 PV, +15 % de dano abaixo de 50 % de PV | 37 % | 30 % |
| **Durvall (depois)** | **36 PV, +25 % de dano abaixo de 50 % de PV** | **20 %** | **46 %** |
| Sylas (antes) | 26 PV, CA 0 | 37 % | 60 % |
| Sylas, teste 1 | 32 PV, CA 1 | 40 % | 56 % |
| **Sylas (depois)** | **32 PV, CA 1, +20 % de dano na passiva** | **23 %** | **73 %** |
| Zynara (antes) | 26 PV, CA 0 | 37 % | 47 % |
| **Zynara (depois)** | **32 PV, CA 1** | **23 %** | **66 %** |

Leitura: para Sylas, vida e armadura não resolviam (o problema era matar rápido); o dano resolveu. Durvall mantém o tema (luta melhor ferido). Com 30 sementes o erro é de ~8 pontos, então 20–23 % significa "bem abaixo de 30 %". Estado final (morte inicial / vitória em Dagruve): Korrak 0/100, Bromnor 0/97, Maelor 7/93, Brook 10/77, Nyrelia 13/60, **Sylas 23/73, Zynara 23/66, Durvall 20/46, Leoric 30/63, Kayron 33/40**. A ordem e as diferenças de estilo permanecem; o piso subiu. Testes: 0 falhas. Falta playtest humano.
