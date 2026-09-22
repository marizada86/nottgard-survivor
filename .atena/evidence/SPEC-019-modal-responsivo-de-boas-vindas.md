# Evidência — SPEC-019

Data: 2026-09-22

## Alteração

- `core/playtest.gd`: guia inicial convertido em modal de tela inteira com
  bloqueio de entrada, fundo escurecido, painel limitado pela área visível,
  rolagem vertical, erro local de nome e restauração de foco no botão Jogar.
- `tools/kit_test.gd`: acrescentadas verificações para abertura modal,
  margens, validação de nome vazio e retorno do controle.

## Verificação realizada

- `git diff --check`: sem erros de espaço em branco.

## Verificação pendente

Este ambiente não possui o executável `godot`/`godot4` disponível no PATH;
portanto a execução de `tools/kit_test.tscn` e a inspeção visual nas
resoluções de referência permanecem pendentes. Executar com Godot 4.7.2:

```text
godot --path . res://tools/kit_test.tscn
```

e conferir manualmente 1280×720, 1024×768, 1366×768 e tela cheia antes de
marcar a spec como executada.
