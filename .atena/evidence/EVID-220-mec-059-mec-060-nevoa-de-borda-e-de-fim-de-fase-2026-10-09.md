---
id: "EVID-220"
title: "MEC-059 e MEC-060: névoa de borda e Maré de Névoa em todas as fases com próximo mapa"
created: "2026-10-09"
spec: "SPEC-158"
plan: "PLAN-084"
cards: ["MEC-059", "MEC-060"]
status: "implementado local; sem commit, push, build nem exportação; efeito sobre jogadores humanos não verificado"
---

# EVID-220 — Névoa punitiva (MEC-059, MEC-060)

Spec: [SPEC-158](../specs/SPEC-158-nevoa-de-borda-e-de-fim-de-fase.md). Pedido do dono em 2026-10-09 (jogadores acampam no canto do mapa), como desvio do PLAN-083 (DEV-019); aprovação por plano e padrões P1 a P5 confirmados pelo dono.

## O que mudou

| Arquivo | Mudança |
|---|---|
| `data/fog.json` (novo) | `edge` (faixa de 3 tiles, 2% a 6% da vida por segundo, rampa de 20 s, queda ao dobro, aviso a 6 tiles) e `postboss` (padrão da Maré de Dagruve; `advance_seconds_per_60_tiles` 28) |
| `core/battle.gd` | `_update_edge_fog` (exposição contínua, dano verdadeiro `borda_nevoa`, aviso uma vez por fase, vale o maior entre borda e Maré); `postboss_fog_pct_at_hero`; `_start_postboss_fog` usa o padrão e deixa `boss_presentations.json` sobrescrever; frente proporcional ao mapa; `_add_interaction` mantém tudo fora da faixa; interruptor de QA `NOTT_SEM_NEVOA=1` |
| `ui/edge_fog.gd` (novo), `ui/run.gd` | faixa de névoa desenhada no mundo (gradiente, sem arte nova), visível só perto da borda |
| `tests/test_fog_edge.gd` (novo) | dano, limites da faixa, dano verdadeiro, exposição, aviso, não-soma, 8 fases com Maré e Pilares sem, velocidade da frente, varredura dos interativos e do portal do chefe e dos pontos de segredo nas 9 fases |
| `tools/shot.gd`, `tools/bot_curva.gd` | flags `edge=` e `edge_exp=` na captura; o bot recua mais cedo e com mais força quando a faixa está ligada |

## Verificações

| Verificação | Resultado |
|---|---|
| `tests/run_all.gd` | `testes: 0 falha(s)` (a primeira rodada acusou 8 falhas em `test_battle.gd` que também apareciam com a faixa desligada; vinham do trabalho em andamento do PLAN-083 e sumiram quando ele fechou) |
| Mutação (`edge_band_tiles` = 0) | `test_fog_edge` falha em 12 verificações; restaurado, 0 |
| `tools/smoke.tscn` | `smoke: ok`, nove fases |
| `tools/kit_test.tscn` (com janela) | `kit: OK` |
| `tools/backlog_check.ps1` | sem alerta novo (o contador do README foi corrigido) |
| Capturas (`.atena/generated/nevoa-borda/capturas/`) | Durao a 2 tiles: vida 9681/9999 e aviso; Dagruve a 3,5 tiles: faixa visível e sem dano; Durao a 8 tiles: nada na tela |

## Bot por herói (S-009)

`tools/bot_curva.gd`, veterano, 10 heróis, 5 sementes, dt 0,08, 9 fases, lado 60. Controle com `NOTT_SEM_NEVOA=1`. Dados em `.atena/generated/nevoa-borda/bot/`.

| Cenário | Fases vencidas por corrida | Mortes em Dagruve (de 50) |
|---|---|---|
| Controle (sem as regras novas) | 0,94 | 26 |
| Com névoa, bot antigo (foge para as bordas) | 0,20 | 43 |
| Com névoa, bot que recua da faixa | 0,94 | 25 |

Leitura: a faixa pune quem vai para a borda e não altera o resultado de quem a evita. O [EVID-217](EVID-217-b005-bot-por-heroi-da-v0-5-0-2026-10-09.md) (outra sessão) viu a mesma queda e a atribuiu à borda; esta rodada fecha o ponto. O bot teletransporta para o portal após o chefe, então a Maré de fim de fase **não é medida** por ele.

## Limites e pendências

- **Não verificado por modelo:** se a punição inibe o canto e se a Maré dá tempo de chegar ao portal. Depende de playtest humano.
- Risco conhecido: nos primeiros minutos, com pouca vida, um jogador cercado que foge para a borda perde vida mais rápido (o bot antigo morreu em 43 s a 130 s). Se o playtest mostrar frustração, as alavancas estão em `data/fog.json` (`edge_band_tiles`, `start_dps_pct`, `ramp_seconds`), sem código.
- `tools/bot_curva.gd` mudou (comportamento do bot com a faixa ligada); com a faixa desligada ele é idêntico ao anterior.
- Medições anteriores ao PLAN-084 (EVID-208 e anteriores) não incluem a névoa.
- Commit, push, build e exportação não feitos; a árvore tem mudanças de outras sessões, então o commit precisa de `git add -p`.
