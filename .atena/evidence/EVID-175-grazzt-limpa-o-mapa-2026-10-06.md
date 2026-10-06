---
id: "EVID-175"
title: "MEC-051: Graz'zt limpa o mapa"
created: "2026-10-06"
relations: ["[[SPEC-136-grazzt-limpa-o-mapa]]"]
cards: ["MEC-051"]
---

# EVID-175

## Mudança
`core/battle.gd` (`wipe_map`), `core/happenings.gd` (`_apply_reward`), `data/stage_events.json` (evento `o_nome_tres_vezes`), `tests/test_happenings.gd`. Detalhes na SPEC-136.

## Verificação
- `tests/run_all.gd`: **0 falhas**. Teste novo `_check_grazzt_wipe`: comuns e destrutível morrem; chefe, elite com afixo, elite com baú e inimigo de objetivo sobrevivem; abates contam; Graz'zt continua aliado; custa 1/3 das moedas; evento visual emitido.
- Mutação: sem `"wipe": true` no dado, o teste acusa 5 falhas (confirma que mede a limpeza).
- Bot (`tools/bot.gd -- durvall 2 goranthis 0.06 2`): sem erro de script; as 2 sementes morreram aos 15 e 32 s, **não chegaram ao evento (520 s)**.

## Limite da medição
Não vista em janela de jogo: o visual da limpeza reaproveita `decoy_blast` (anel e explosão de sombra), sem arte própria. Orbs de XP/ouro em massa e subidas de nível seguidas não foram medidos.

## Pendência
Aguarda playtest do Manzi; commit local só com aprovação (um commit só para esta mecânica, separado do BUG-032).
