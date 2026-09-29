# SPEC-092 — Arma inicial de Zynara passa a causar dano (BAL-008)

Status: **implementada (2026-09-29); validação em playtest.**

Origem: linha de base do bot ([[EVID-110-linha-de-base-do-bot-por-heroi-2026-09-29]]) mostrou Zynara com nível médio
**1,0** em 5 sementes, a pior dos 10 heróis, mesmo sem a abertura de fase e o flanqueio (2,4). O dono pediu para olhar
o kit; a causa está nos dados.

## Diagnóstico

A **Ampulheta do Silêncio Eterno**, arma inicial de Zynara (`data/weapons.json`), tinha `dice: ""`: só aplicava
atordoamento (1,5 s) a cada 12 s e **nunca causava dano**. Zynara só podia matar com armas pegas em level-ups; nível 1
era o teto porque ela não derrubava nenhum inimigo. Dois fatos independentes (bot e leitura dos dados) apontam o mesmo
defeito, então a regra de duas fontes do [[BALANCEAMENTO]] está cumprida.

## Mudança (só dados)

| Campo | Antes | Depois |
|---|---|---|
| `dice` | `""` (sem dano) | `2d6` (escala com INT) |
| `cd` | 12 s | 5,5 s (igual à Descarga Estelar de Kayron) |
| nível 3 (`levels`) | recarga −2,0 | recarga −1,0 (piso 3,5 s; evita ficar forte demais com atordoamento em área) |

O atordoamento e o raio ficam como estavam. A mesma arma é concedida pelo item único "Ampulheta do Silêncio Eterno":
esse item também passa a causar dano.

## Medição (bot, começo em Dagruve)

| Configuração | Sementes | Nível médio |
|---|---:|---:|
| Antes | 5 | 1,0 |
| Só `dice 2d6`, `cd 9` | 8 | 3,4 |
| **`dice 2d6`, `cd 5,5` (adotada)** | 10 | **5,0** |

Zynara passa a ficar na faixa de Durvall (5,8) e Nyrelia (6,0), em vez de isolada no fundo. Amostra pequena e
ruidosa; validar em playtest com Zynara (nenhum tester a usou).

## Não mudou

Nyrelia (Dominar Pessoa, 1d4 a cada 4,5 s) ficou como estava: a variante testada não melhorou o bot (4,6 contra 6,0,
dentro do ruído) e não há relato humano (BAL-009 continua em observação).
