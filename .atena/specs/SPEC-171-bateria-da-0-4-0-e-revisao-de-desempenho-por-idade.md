---
id: "SPEC-171"
title: "Bateria de testes do release candidate 0.4.0 e revisão de desempenho do código mais antigo"
status: "IMPLEMENTADA LOCAL em 2026-10-10 (PLAN-098, EVID-240); aguarda playtest"
origin: planned
implementation_preceded_spec: false
request_classification: PLAN_DEVIATION
created: "2026-10-10"
relations: ["[[SPEC-170-foco-do-controle-ao-comprar-melhoria-bug-043]]", "[[SPEC-169-lancamento-oficial-da-v0-4-0]]"]
cards: ["TOOL-006"]
---

# SPEC-171 — Bateria da 0.4.0 e revisão de desempenho por idade

Origem: pedido do dono em 2026-10-10: "vamos fazer uma bateria de testes para essa atualização e revisar o que não foi otimizado desde o início do projeto, priorizar o que for mais antigo".

## Decisões do dono (2026-10-10)
| # | Decisão |
|---|---|
| D1 | Rota: fazer agora e voltar ao PLAN-071 (DEV-038). |
| D2 | "Essa atualização" = o release candidate 0.4.0 inteiro (HEAD + árvore de trabalho atual). |
| D3 | Otimização: medir primeiro, aplicar só o que for seguro. |
| D4 | Aprovação por plano. |

## Evidência de partida (lida em 2026-10-10)
- Projeto de 21/09 a 10/10 (391 commits). Mais antigos e mais quentes: `core/battle.gd` (3.327 linhas, `step` por quadro com grade espacial, 59 consultas a `Data.table`, 23 laços sobre inimigos), `ui/ground.gd`, `ui/prop.gd`, `core/sfx.gd`, `core/game.gd`, `core/iso.gd`, `core/data.gd` (cache por nome).
- Nenhuma medição de desempenho no repositório. Bateria existente: 80 testes de suíte, `smoke`, `controller_check`, `mobile_buttons_check`, `kit_test`, `audit_projeto`, `backlog_check` e o bot (`tools/bot.gd`).

## Escopo
1. **Bateria:** rodar tudo o que existe; somar o que falta (bot determinístico em todas as fases e heróis, varredura de erros e avisos de script nos logs, auditoria do projeto, comparação com checkout limpo do HEAD).
2. **Medição:** `tools/perf_probe.gd` mede, por fase e semente fixa, o custo por `step` e por sub-rotina de `Battle`, e a contagem de nós/órfãos; ranking por idade do código e por custo.
3. **Otimização segura:** só mudanças que **preservam o resultado** (mesma semente, mesmo estado final e mesmos eventos antes e depois), com ganho medido e suíte sem falhas.

## Regras de segurança do plano (por plano)
- Não altera números de balanceamento, dados (`data/*.json`), arte, áudio, dependências nem a versão.
- Toda otimização aplicada exige: hash do estado final por semente igual antes/depois, suíte 0 falhas, ganho medido registrado.
- Achado que exija mudar comportamento, dado ou balanceamento é **listado e não aplicado**.
- Sem commit, push, exportação nem aviso aos testers.

## Aceite
1. Relatório da bateria com cada verificação, resultado e comando; falhas e avisos listados sem esconder nada.
2. Ranking de desempenho com números, por idade do arquivo e por custo.
3. Cada otimização aplicada com antes/depois de tempo e de hash de estado.
4. Subjetivo (fluidez percebida em máquina real) pendente de playtest do dono.
