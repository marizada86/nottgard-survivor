---
id: SPEC-138
title: Playtest Web e estatisticas Discord para ranking
created: 2026-10-06
origin: guided-add
implementation_preceded_spec: false
status: APPROVED_LOCAL
approval_mode: per-plan
plan_id: PLAN-071
---

# Playtest e ranking

O [escopo completo](../vault/drafts/PROPOSTA-playtest-web-e-evidencias-ranking-2026-10-06.md), incluindo nao objetivos, impactos, defaults, recuperacao, gaps, plano de voo, validacao e dez criterios de aceite, integra esta spec. Web usa botoes Playtest/Relatar/Capturar; F4/F5/F6 somente Windows.

Dono pediu iniciar a implementacao e selecionou "Por plano — executar todo o escopo local aprovado" em 2026-10-06, antes do codigo. B-001 a B-006 locais aprovados. Mobile entregue localmente e commitado; teste nativo ainda pendente. Zero gaps BLOCKING locais; credenciais, banco real, pipeline do dono, publicacao e registro remoto de comandos ficam DEFERRED, com gates independentes.

[Estado executavel](../state/plan-071-playtest-ranking.yaml). Evidencias em .atena/evidence e artefatos em .atena/generated/playtest-ranking/v01/. Site recebe quatro documentos proprios antes de sua implementacao. Usar banco sintetico. Preservar combate, saves, trabalhos de arte e controles; nao executar publicação, push, merge ou commit.

Entrega local em [EVID-187](../evidence/EVID-187-playtest-ranking-local-2026-10-06.md); critérios de clientes finais ainda pendentes estão enumerados na evidência.

Recuperacao: desligar recursos de coleta sem apagar filas; schema aditivo; snapshot do estado anterior. Comparar criterios com evidencias reais, distinguir entrega local de integracao publicada e reconciliar fatos ao concluir.
