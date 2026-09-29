# SPEC-083 — Abertura de fase mais cheia (MEC-024)

Status: **implementada (2026-09-29); números a validar com o bot e em playtest.**

Origem: T03 notas 3 e 5 e texto livre ([[EVID-108-playtest-publico-t03-dna-2026-09-29]]):
"aumentar a quantidade de mobs e a dificuldade no início; esse tipo de jogo fica
mais fácil ao evoluir". Escolha do dono (2026-09-29): **só mais mobs nos primeiros
minutos**; dano dos inimigos e PV dos heróis **não** mudam. Plano: [[PLAN-038-atualizacao-pos-playtests-t01-t02-t03-2026-09-29]].

## Decisão

Cada fase começa mais povoada e a pressão volta ao normal sozinha. Dados em
`data/difficulty.json` (`opening`), sem número fixo no código.

## Regra

`opening_factor()` vale **1.0** até `hold_seconds` (90 s), decai linear até **0**
em `fade_seconds` (240 s) e fica 0 depois. Enquanto for > 0, o diretor de ondas usa:

| Campo | Efeito (no auge) |
|---|---|
| `cap_bonus` 6 | teto de inimigos vivos +6 |
| `n_mult` 1.25 | inimigos por onda ×1,25 (arredonda para cima) |
| `max_mult` 1.2 | máximo simultâneo de cada tipo ×1,2 |
| `every_mult` 0.85 | intervalo entre ondas ×0,85 |

Vale para **todas as fases** (cada uma reinicia o relógio). Chefes, elites, dano e PV inalterados.

## Implementação

- `Battle.opening_factor` e `Battle._director` (`core/battle.gd`); `data/difficulty.json`.
- Testes em `tests/test_battle.gd`: fator 1,0 / 0,5 / 0, e mais inimigos com o bônus do que sem.

## Medição com o bot (Brook, Bromnor, Kayron, Durvall; 6 sementes cada; começo em Dagruve)

| Configuração | Nível médio | Runs que vencem Dagruve e chegam a Docas |
|---|---:|---:|
| Sem abertura (antes) | 8,8 | 7 de 24 |
| **Abertura suave (esta spec)** | 8,7 | 1 de 24 |
| Abertura forte (cap +12, n ×1,5, max ×1,4, intervalo ×0,75) | 6,8 | 1 de 24 |

A forte foi descartada: Kayron caiu de nível 11,5 para 4,8. A suave mantém o nível médio, mas o
bot vence Dagruve bem menos. O bot é um kiter simples e muito ruidoso (24 runs por linha); os
jogadores humanos dos playtests foram muito além (Hiago venceu todas as fases). **Tratar como
sinal de direção, não como veredito**; a validação real é o playtest.

## Riscos e limites

- Heróis frágeis no começo (Hiago com PV 10/42 em Dagruve) podem sofrer mais. Medir com o bot por herói antes de mexer nos números.
- Pedidos futuros do DNA (mais dano, menos PV do herói) **não** estão neste lote.
