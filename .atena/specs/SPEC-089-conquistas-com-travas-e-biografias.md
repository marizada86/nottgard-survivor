# SPEC-089 — Conquistas com travas e biografias (MEC-016)

Status: **implementada (2026-09-29); validação em playtest.**

Origem: T01 S3-N4 ("mais conquistas com recompensas balanceadas; travar mecânicas por conquista, ex.: melhoria
Mão Cheia; biografias dos personagens"), em [[EVID-106-playtest-publico-t01-higor-2026-09-29]]. Proposta aprovada
pelo dono em 2026-09-29. **Fonte de toda a história: o vault de Nottgard** (`F:\dev\nottgard-vault`,
`02_Personagens` e `03_NPCs`); nenhuma lore nova. Plano: [[PLAN-038-atualizacao-pos-playtests-t01-t02-t03-2026-09-29]].
Relacionada a [[PLAN-040-hqs-novas-highlights-do-vault-2026-09-29]] e [[SPEC-080-hqs-de-transicao-do-nottcard]],
que propõem outras conquistas (Cronista de Nottgard etc.) e o Diário: **os dois conjuntos somam**, sem tocar nas
mesmas linhas de \`data/achievements.json\` se o outro só acrescentar.

## Conquistas novas (16, total 34)

| Conquista | Condição | Recompensa |
|---|---|---|
| **Mão Cheia** | Nível 30 numa run | Libera o aprimoramento Mão Cheia |
| **Bolso Fundo** | Derrotar 3 chefes numa run | Libera o aprimoramento Bolso Fundo |
| **Segunda Chance** | Derrotar o chefe de Feng-tu | Libera o aprimoramento Segunda Chance |
| **Mestre do Ritual** | Interromper 10 rituais (total) | +5% dano, +0,3 coleta |
| **Jogador de Risco** | Ganhar 5 apostas (total) | +5% moedas |
| **Fiel ao Equipamento** | Subir 3 itens por fidelidade (total) | +1 CA |
| **Biografia: <herói>** (×10) | Vencer uma fase com o herói | Biografia do vault no Quartel |

## Travas

`data/upgrades.json` ganha o campo `requires` (id de conquista). `Profile.upgrade_locked_by` trava a compra
(`buy_upgrade` recusa) e o menu mostra `Bloqueado. Conquista: …`. **Quem já comprou continua com o nível que tem.**

## Biografias

`data/hero_bios.json` traz um texto curto por herói, derivado só do que as fichas do vault registram (prólogo,
"Em poucas palavras" e sessões de cada personagem). Aparece na tela de herói do Quartel: bloqueada ("vença uma
fase com este herói") ou aberta. `Profile.hero_bio_unlocked`.

## Estatísticas novas

`rituals_total`, `bets_won_total`, `loyalty_total` e `heroes_cleared` no perfil (tolerantes a saves antigos);
`Battle.stats` e `Battle.result` carregam `rituals`, `bets_won` e `loyalty`.

## Testes

`tests/test_profile.gd`: conquistas concedidas pelas estatísticas, travas, biografia só do herói que venceu,
todo herói tem biografia; teste antigo de Segunda Chance ajustado à trava.

## Limites

- As biografias podem citar eventos posteriores do vault (ex.: Bromnor, Leoric); revisar com o dono se algum
  texto revelar demais para quem ainda não jogou a campanha.
- Não há loja de biografias nem HQ nesta spec (ver SPEC-080).
- Valores de recompensa são pequenos de propósito.
