---
id: "EVID-131"
title: "Implementação das HQN-01 a HQN-10"
created: "2026-09-30"
status: "implementação e validação local concluídas"
relations:
  - "[[SPEC-100-integracao-hqn-01-a-10]]"
  - "[[EVID-130-admissao-arte-hqn-01-a-10-2026-09-30]]"
  - "[[PLAN-040-hqs-novas-highlights-do-vault-2026-09-29]]"
---

# EVID-131 — Implementação das HQN-01 a HQN-10

## Resultado

- As 40 imagens admitidas e seus metadados de importação foram adicionados a
  `assets/hq/`; os hashes e variantes estão registrados em EVID-130.
- O catálogo contém HQN-01 a HQN-14. HQN-01 a HQN-10 usam os gatilhos
  aprovados em SPEC-100; HQN-11 a HQN-14 mantêm o arco e os gatilhos existentes.
- O progresso dos marcos é salvo antes da leitura. Saves existentes sem
  `hqs_seen` migram com segurança e marcos anteriores não provocam reprodução
  automática retroativa.
- Leituras completas, mas não puladas, alimentam a conquista Cronista de
  Nottgard. O Diário respeita desbloqueios, permite replay e contabiliza somente
  a conclusão integral.
- O leitor mantém proporção sem distorção ou corte nos tamanhos verificados.

## Verificações

- `godot --headless --path . -s tests/run_all.gd`: **0 falhas**.
- `godot --headless --path . res://tools/smoke.tscn --quit-after 120`:
  **código de saída 0**.
- Os testes incluem catálogo/gatilhos, saves novos e antigos, desbloqueio do
  Diário, skip versus leitura completa, recompensa idempotente e apresentação
  das imagens em 1280×720 e 1920×1080.
- `git diff --check`: sem erros.

O ambiente emitiu avisos ao tentar gravar `user://logs/godot.log` e carregar o
repositório de certificados do sistema, além de avisos de recursos liberados ao
encerrar. Não afetaram o resultado da suíte nem o código de saída do smoke test.

## Commits locais

- Arte: `e03942f` — `Add approved HQN-01 to HQN-10 artwork`.
- Mecânica e reconciliação: será registrado após a criação do commit local.
- Não houve push, PR ou merge.
