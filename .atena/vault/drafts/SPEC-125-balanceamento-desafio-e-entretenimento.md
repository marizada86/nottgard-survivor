---
id: SPEC-125
title: Balanceamento de desafio e entretenimento sobre a base 0.3.1 (inimigos, curva de poder, chefes, heróis)
status: implemented-uncommitted
origin: pedido-do-dono-2026-10-05
card: BAL-018
plan: PLAN-059 (por plano; aprovada pelo dono em 2026-10-05)
---

# SPEC-125 (rascunho)

## Pedido (dono, 2026-10-05)
Mais desafio e entretenimento tendo em vista as atualizações recentes (SPEC-122, SPEC-124). Os testers ainda vão opinar; armas, magias e equipamentos novos ficam para specs futuras (MEC-042). Focos escolhidos: densidade e dano dos inimigos, curva de poder do jogador, chefes e picos de tensão, equilíbrio entre heróis.

## Base de partida
Commit `63b6394` (SPEC-122 aceita, SPEC-124 com `enemy_speed_mult` 1,2). Nenhum playtest humano da base ainda. O bot é alarme, não juiz; humano decide.

## Pontos abertos herdados (EVID-156)
Docas fácil (3 % de morte), Feng-tu 6 %, calibração só com bot veterano (metas E1 são do novato), RNG do bot não semeado.

## Lotes propostos (um conjunto de alavancas por lote; antes→depois anotado)
> Ordem ajustada em 2026-10-05 após a EVID-160 (mesmo escopo): heróis do filtro de Dagruve primeiro, para que o ajuste das fases não seja confundido pela fraqueza deles. Lotes: B-001 linha de base; B-002 heróis; B-003 inimigos por fase; B-004 chefes; B-005 curva de poder; B-006 fechamento.
- B-001 Linha de base (sem mudar o jogo): semear o RNG de `tools/bot_curva.gd` (ferramenta, não jogo); rodar bot novato e veterano, 10 heróis, mesmas sementes, fases 1 a 9; EVID com morte por fase, nível, PV mínimo, tempo de chefe.
- B-002 Inimigos por fase: densidade e dano em `data/stages.json` e `data/difficulty.json` (inclui Docas e Feng-tu), rumo à rampa-alvo.
- B-003 Chefes e picos: `data/boss_phases.json`, `stage_events.json`, elites; medir tempo de chefe e PV mínimo.
- B-004 Heróis: nivelar o conjunto fora da faixa (BAL-013, 014, 015) em `data/heroes.json`; fraco no começo e forte no fim é aceito pelo dono, o excesso não.
- B-005 Curva de poder: ritmo de armas, passivas e itens (`weapons.json`, `upgrades.json`, `passives.json`), se B-001 a B-004 mostrarem poder em excesso.
- B-006 Bot final, EVID, atualização do BAL-018 e da lista "O que testar" do próximo playtest.

## Critérios de aceite (propostos)
- Mortes do bot novato por fase dentro da rampa-alvo (a confirmar abaixo), medidas com RNG semeado e as mesmas sementes antes e depois.
- Nenhum herói fora da faixa acordada de nível médio e de morte inicial em Dagruve.
- Testes verdes (`tests/run_all.gd`) e `audit_projeto.gd` com 0 erros.
- Cada alteração registra valor antes→depois; uma alavanca por entidade por vez.

## Fora do escopo
Conteúdo novo (armas, magias, equipamentos), arte, bugs de movimentação (BUG-028, BUG-029), push e release.

## Pendências BLOCKING
- Rampa-alvo de morte por fase (manter E1 ou subir).
- Nível de aprovação (por plano, lote ou etapa).
- Aprovar a SPEC (alterar balanceamento exige aprovação do dono).

## Decisões do dono (2026-10-05)
- Rampa-alvo (bot novato): **subir um degrau** — Dagruve/Docas 30 a 40 %, meio 45 a 55 %, finais 55 a 65 % de morte.
- Aprovação **por plano**: uma aprovação cobre B-001 a B-006. Push, merge e release seguem exigindo aprovação à parte.
- SPEC aprovada como escrita.

## Resultado (2026-10-05, sem commit)
B-001 (EVID-160), B-002 sem mudança (EVID-161), B-003 aplicado em `data/stages.json` (EVID-162), B-004 e B-005 sem mudança por falta de dados, B-006 fechamento. Dagruve e heróis intactos. Testes 0 falhas, auditoria 0 erros. Aceite parcial: Docas a Durao próximos da rampa; fases finais e chefes dependem de playtest.
