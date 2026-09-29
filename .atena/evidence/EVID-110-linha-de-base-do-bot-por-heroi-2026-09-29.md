# EVID-110 — Linha de base do bot por herói (build 0.2.0), 2026-09-29

Primeira rodada da trilha [[PLAN-042-trilha-de-balanceamento-2026-09-29]] depois que os ajustes de
`data/difficulty.json` foram commitados (commit `7a183da`, versão 0.2.0). Saída bruta em
[EVID-110-linha-de-base-do-bot-por-heroi-2026-09-29/](EVID-110-linha-de-base-do-bot-por-heroi-2026-09-29/).

Comando: `godot --headless --path . -s tools/bot.gd -- <herói> 5 dagruve 0.08 8` (5 sementes por herói, começo em
Dagruve). O bot joga com kite e escolhas heurísticas; **serve para comparar heróis e versões, não para dizer o que
um humano sentiria** (os jogadores dos playtests foram muito além do bot).

## Resultado (build 0.2.0: abertura de fase, flanqueio, Bênção do Selo, PV por nível, etc.)

| Herói | Nível médio | Pior run | Chegou a Docas |
|---|---:|---:|---:|
| Maelor | 14,4 | 9 | 1 de 5 |
| Korrak Nammat | 14,4 | 9 | 1 de 5 |
| Bromnor Martelo da Luz | 11,6 | 7 | 1 de 5 |
| Kayron Lioran | 10,2 | 1 | 0 de 5 |
| Sylas Malafaia | 9,6 | 4 | 0 de 5 |
| Leoric | 7,6 | 3 | 0 de 5 |
| Brook França | 7,0 | 3 | 0 de 5 |
| Nyrelia | 6,0 | 2 | 0 de 5 |
| Durvall | 5,8 | 3 | 0 de 5 |
| **Zynara Vellen** | **1,0** | **1** | **0 de 5** |

## Variante: sem abertura de fase e sem flanqueio (`cap_bonus`, `n_mult`, `max_mult`, `every_mult` neutros; `flank.share 0`)

| Herói | Nível médio (atual) | Nível médio (variante) |
|---|---:|---:|
| Brook França | 7,0 | 7,0 |
| Durvall | 5,8 | 5,4 |
| Nyrelia | 6,0 | 7,6 |
| Zynara Vellen | 1,0 | 2,4 |

## Leitura

- **A abertura e o flanqueio não explicam** a fraqueza de Brook e Durvall (iguais ou melhores com eles) e só
  parcialmente a de Nyrelia. Diferenças de 1 a 2 níveis com 5 sementes ficam dentro do ruído.
- **Zynara é fraca em qualquer configuração** (nível 1 a 2 em todas as runs): o problema é o herói, não a
  dificuldade nova. Nyrelia é a segunda mais frágil.
- Heróis de corpo a corpo com PV alto (Korrak, Bromnor) e Maelor aguentam melhor, o que é o esperado da tabela de
  atributos e PV base (`data/heroes.json`).
- Sem relato humano de Zynara e Nyrelia (nenhum tester as usou), então **fica em observação**, não em decisão
  (regra da trilha: uma fonte só, o bot).

## Limites

- 5 sementes por herói; o bot é ruidoso. Repetir com mais sementes antes de mexer em números.
- Só Dagruve inicial; não mede fases avançadas.
