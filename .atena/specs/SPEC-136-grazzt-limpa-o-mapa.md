---
id: SPEC-136
title: Graz'zt limpa o mapa (evento "O nome dito três vezes")
status: implemented-pending-playtest (aprovada por plano pelo dono em 2026-10-06)
origin: playtester Manzi, 2026-10-06 ("Graz'zt tem pouco dano, não ajuda em nada") + ideia do dono
cards: MEC-051
risk: médio (efeito de limpeza em massa; só ocorre no pacto opcional de Goranthis, que custa 1/3 das moedas)
plan: PLAN-069 (por plano; side-plan, não é o active_plan)
---

# SPEC-136

## Pedido
Graz'zt luta ao lado do herói por 25 s (500 PV, 3d10) e não faz diferença. Ideia do dono: ao pedir a ajuda de Graz'zt, limpar o local inteiro, matando tudo e destruindo os destrutíveis, exceto chefe e elites.

## Decisões do dono (2026-10-06)
| # | Decisão |
|---|---|
| D1 | Aprovação por plano. |
| D2 | **Drops normais:** as mortes da limpeza passam por `_kill` (XP, ouro, loot de destrutíveis, contagem de abates). |
| D3 | Graz'zt segue lutando 25 s depois da limpeza, sem mudar PV nem dano (3d10). |
| D4 | Custo (1/3 das moedas), horário (520 s) e uso único do evento ficam como estão. |

## Causa do "pouco dano"
O aliado soldado ataca um alvo por vez e some em 25 s; não muda uma luta com dezenas de inimigos.

## Mudança
- `core/battle.gd` `wipe_map()`: mata todo inimigo (incluindo destrutíveis) **exceto** chefe, elite (`affix`, `drops_chest`, flag `elite_only`) e inimigo ligado a objetivo de acontecimento (`event_tag`); zera `split_id` antes de matar (a limpeza não gera filhotes); emite o evento visual `decoy_blast` (raio 10) e devolve quantos morreram.
- `core/happenings.gd` `_apply_reward`: efeito `"wipe": true` chama `wipe_map()` antes de criar os aliados.
- `data/stage_events.json`: efeito do pacto de Graz'zt ganha `"wipe": true` e a descrição da escolha passa a dizer que ele varre o mapa.

## Aceite
- A1: comuns e destrutíveis morrem; chefe, elite (afixo ou baú), `event_tag` sobrevivem.
- A2: as mortes contam como abates normais; Graz'zt segue como aliado; o pacto cobre 1/3 das moedas; o evento visual é emitido.
- A3: suíte sem falhas; bot sem erro de script.

## Pontos para o playtest
- Quantidade de orbs de XP/ouro de uma vez (desempenho e subidas de nível seguidas).
- Se o poder do pacto compensa o 1/3 das moedas; ajustar custo ou horário em BAL se precisar.
- O Anel de Graz'zt (`aneis_de_grazzt`, só +15% de dano e acerto) não invoca nada; a SPEC-118 prevê Graz'zt na luta contra Socothbenoth com o anel. Fora desta spec.
