---
id: "SPEC-161"
title: "Fechar e organizar a 0.4.0 (trilha sem assets nem movimentação)"
status: "EXECUTADA em 2026-10-09 (PLAN-087, EVID-222 e EVID-223)"
origin: planned
implementation_preceded_spec: false
request_classification: PLAN_DEVIATION
created: "2026-10-09"
relations: ["[[SPEC-157-segredos-nas-outras-fases-v0-5-0]]", "[[SPEC-160-arlindo-orlando-e-erik-blackthorn-jogaveis]]"]
cards: ["BAL-027", "BUG-025", "BUG-027", "BUG-028", "BUG-029"]
---

# SPEC-161 — Fechar e organizar a 0.4.0

Pedido do dono (2026-10-09): "qual o plano recomendado que não dependa ou envolva os assets/movimentação"; depois, aprovação **por plano** com as recomendações da Atena. Contexto: o dono está "ficando perdido" com a quantidade de planos e specs acumulados.

## Fora do escopo (decisão explícita)

BUG-025, BUG-027, BUG-028, BUG-029; PLAN-053 (fila de imagens); PLAN-082; ART-045 (arte própria de Arlindo e Erik); aceite em aparelho do PLAN-071; qualquer arquivo em `assets/`.

## Lotes

- **B-001 Fechar o PLAN-083:** conferir os documentos da 0.4.0 refeita, preparar o commit (S-023), EVID final e reconciliação do `plan.yaml` (S-024); retorno ao PLAN-071.
- **B-002 Triagem do que está pendente:** mapear as mudanças não commitadas por plano e por arquivo (inclusive arquivos que misturam planos, como `core/battle.gd`), corrigir colisões de ID (dois EVID-219), propor grupos de commit.
- **B-003 Inventário de planos e specs:** só leitura; classificar cada plano em `.atena/state/` e cada SPEC; propor o que arquivar. Nada é apagado nem movido sem aprovação.
- **B-004 Balanceamento do Arlindo (BAL-027):** só números em JSON, só se a leitura do bot sustentar; mudanças de números de herói pedem a decisão do dono (a EVID-219 deixou aberta).
- **B-005 Roteiro de playtest consolidado da 0.4.0 refeita:** o que testar, build, procedimento e critérios. O julgamento de sensação é do dono.

## Portões (independentes do nível de aprovação)

Commits só com aprovação explícita (por grupo); push, exportação e aviso aos testers à parte; mudanças de outras sessões preservadas; nenhuma dependência nova; nada em `assets/`; nada de canone do mestre.

## Critérios de aceite

1. PLAN-083 fechado e `plan.yaml` com retorno ao PLAN-071 (ou commit pendente declarado com a razão).
2. Mapa de pendências por plano, sem arquivos órfãos sem dono; IDs duplicados resolvidos.
3. Proposta de limpeza com contagem, sem remoção.
4. Decisão sobre o BAL-027 registrada (ajuste medido ou "manter" com a razão).
5. Roteiro de playtest entregue.
6. Suíte `0 falha(s)` e `backlog_check` ao final de qualquer mudança em código ou dados.
