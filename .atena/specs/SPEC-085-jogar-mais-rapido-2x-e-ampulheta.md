# SPEC-085 — Jogar mais rápido: 2x e Ampulheta (MEC-010)

Status: **implementada (2026-09-29); validação em playtest.**

Origem: prioridade nº 1 acumulada do questionário 002 (pergunta 9, 3 de 3) e T01 notas 3 e 8
([[EVID-106-playtest-publico-t01-higor-2026-09-29]], [[EVID-107-playtest-publico-t02-hiago-2026-09-29]],
[[EVID-108-playtest-publico-t03-dna-2026-09-29]]). Decisões do dono (2026-09-29):
**2x mais evento**; 2x **acelera tudo e só vale em fase já vencida**; **não mexer no tempo entre mapas** agora.
Plano: [[PLAN-038-atualizacao-pos-playtests-t01-t02-t03-2026-09-29]].

## 1. Velocidade 2x

- Tecla **T** liga e desliga. Só funciona em mapa que o perfil já venceu
  (`Game.profile.data.cleared`); em mapa novo avisa "O 2x libera depois de vencer este mapa."
- A simulação inteira roda duas vezes por quadro (`ui/run.gd`): heróis, inimigos, recargas e spawns.
  Recompensa e regras iguais.
- O HUD mostra `[2x]` ao lado do nome da fase.
- `Battle.can_speed_2x`, `speed_scale` e `toggle_speed` (`core/battle.gd`).

## 2. Ampulheta (evento)

- Nova interação `ampulheta` (E), peso 1 nos eventos aleatórios de **todas as fases**.
- Adianta o relógio do mapa em **60 s** (nunca passa de 5 s antes do chefe) e **despeja de uma vez**
  os spawns que seriam gerados nesse intervalo, no máximo 18. Elites cujo horário passou surgem no
  ciclo seguinte (parte da punição, como T01 sugeriu).
- Depois de o chefe surgir, não faz efeito e não é consumida.
- Custo natural: menos tempo no mapa significa menos abates, moedas e itens.
- Dados em `data/difficulty.json` (`hourglass`): `skip_seconds`, `burst_max`.

## Testes

`tests/test_battle.gd`: 2x recusado em fase nova e liberado em fase vencida; a ampulheta adianta 60 s e
aumenta os inimigos; não age com o chefe presente.

## Pendências e limites

- Ainda **sem arte** para a ampulheta (quadrado lilás com rótulo, provisório): **ART-018**.
  Basta um PNG em `assets/interactions/ampulheta.png`.
- Não mexe no tempo entre mapas nem permite escolher o mapa de partida.
- A ajuda `?` e o guia do playtest (`core/playtest.gd`) ainda não citam a tecla **T** nem a ampulheta;
  o README já cita. Atualizar quando esse arquivo estiver livre.
- Não medido com o bot (ele não usa 2x nem ampulheta).
