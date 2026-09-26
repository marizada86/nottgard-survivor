# EVID-013 — Gate de execução de prompts

Data: 2026-09-23

## Entregas

- Modelo de registro por chamada em
  `.atena/generated/PROMPT-EXECUTION-RECORD-TEMPLATE-001.json`.
- Diretório reservado para registros em `.atena/generated/prompt-execution/`.
- Auditoria executável em `tools/audit_prompt_execution.gd`.
- Teste de contrato em `tests/test_prompt_execution_contract.gd`.

## Contrato comprovado

Para todo registro em estado `compiled`, `generated`, `qa_failed` ou
`accepted`, a auditoria exige leitura registrada de `ART-PROMPTS-001`, leitura
do prompt específico, manifesto conferido e fontes verificadas. Estados com
candidata também exigem caminho, versão, horário e aprovação de envio remoto.
Um aceite exige os oito itens de QA e uma decisão fundamentada.

## Validação executada

1. `D:\Godot\Godot_v4.7.2-stable_win64.exe --headless --path . -s tests/run_all.gd`
   terminou com `testes: 0 falha(s)`.
2. `D:\Godot\Godot_v4.7.2-stable_win64.exe --headless --path . -s tools/audit_prompt_execution.gd`
   terminou com `audit-prompt-execution: 0 falha(s)` para a fila vazia.

Os avisos de `user://logs` e certificados do sistema não causaram falhas.

## Limite intencional

O gate não gera imagens nem envia referências. Antes de cada lote, ainda é
necessária a aprovação explícita que nomeie os `prompt_id`s e referências locais
autorizadas para transferência.
