# EVID-080 — Atalho F4 para o Navegador QA

Data: 2026-09-27  
Spec: `../specs/SPEC-050-atalho-f4-navegador-qa.md`

## Resultado

- `F4` é reconhecido como atalho alternativo do Navegador QA.
- `Ctrl+O+P` permanece reconhecido.
- O ponto de entrada já existente continua exigindo perfil QA Interno e nenhuma interface com foco; nenhum atalho novo foi exposto aos perfis público ou de produção.
- O guia mostra `F4 Navegador QA` somente quando o perfil QA está ativo.

## Validação automatizada

Comando executado:

```text
D:\Godot\godot.exe --headless --path . -s tests/run_all.gd
```

Resultado: `testes: 0 falha(s)`.

O Godot também registrou avisos preexistentes do ambiente headless sobre o arquivo de log em `user://logs/godot.log` e a store de certificados; eles não afetaram a execução da suíte.
