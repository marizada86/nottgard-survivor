---
id: "PLAN-042"
title: "Trilha de Balanceamento no backlog"
status: "aplicado em 2026-09-29"
created: "2026-09-29"
relations:
  - "[[PLAN-037-organizacao-do-trabalho-em-tres-trilhas-2026-09-29]]"
  - "[[PLAN-041-ajustes-de-organizacao-release-rico-e-build-id-2026-09-29]]"
  - "[[SPEC-086-ajustes-pos-playtest-numeros-e-clareza]]"
---

# PLAN-042 — Trilha de Balanceamento

## Pedido do dono (2026-09-29)

Criar uma trilha **Balanceamento** ao lado de Bugs, Arte e Mecânicas para guardar
todos os problemas de equilíbrio (heróis, itens, inimigos, economia...), de modo
que a melhor solução surja depois de reunir toda a informação.

## O que foi feito

- `.atena/backlog/BALANCEAMENTO.md` (`BAL-nnn`): fronteira com as outras trilhas,
  campos do cartão (entidade, sintoma, evidências, alavanca, hipótese, medição,
  decisão), critério de decisão, uso do bot (`tools/bot.gd`), painel de heróis e
  tabela de decididos.
- Semeadura com o que já existia espalhado em Mecânicas: BAL-001 a 007
  (dificuldade inicial, progressão tardia, economia, névoa, quebráveis, fontes,
  baú do chefe). Os cartões `MEC` correspondentes ganharam ponteiro para o `BAL`.
- Regras no README, no INTAKE (triagem), no RELEASES e no `add.yaml`; ordem de
  lançamento agora **Bugs → Arte → Mecânicas → Balanceamento**; `backlog_check.ps1`
  reconhece o prefixo `BAL`.

## Decisões de método

- **Números vão para BAL; regra ou sistema novo continua em MEC.** Um relato pode
  gerar cartão nas duas, ligados na coluna "Ligado a".
- Decidir com **duas fontes independentes** (ou jogador + bot); relato único fica em
  observação, exceto P0.
- Uma alavanca por vez por entidade, anotando antes → depois.
- Balanceamento por último na versão, para calibrar o conteúdo final.

## Pendências

- **Linha de base do bot por herói** ainda não existe. Não foi medida agora porque há
  ajustes de `data/difficulty.json` em andamento não commitados (mediria uma versão
  no meio da mudança). Fazer logo após esse commit.
- Painel de heróis, armas, itens e inimigos vai se preenchendo conforme chegam relatos.

## Limites

- Nenhum número do jogo foi alterado; só organização e documentação.
- Colisão de numeração: já existia outro `PLAN-041` (animação padrão do Zumbi).
  Este plano usa o `042`; a colisão foi registrada no README do backlog.
