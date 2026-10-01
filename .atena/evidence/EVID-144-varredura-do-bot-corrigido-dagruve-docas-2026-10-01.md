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
