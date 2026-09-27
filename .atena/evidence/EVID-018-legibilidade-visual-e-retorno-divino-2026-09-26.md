# EVID-018 — Legibilidade visual e retorno divino

Status: verificação estática concluída; verificação em runtime pendente.

## Implementado

- Painel F5 limitado ao viewport com margem de 24 px e rolagem para o editor.
- Dagruve reduzida de 64 para 30 props visíveis; props ocultos não entram em
  `blockers`.
- Interações nascidas durante a run recebem telegráfico, queda, impacto e uma
  janela de 0,65 s antes de poderem ser usadas.
- Paleta divina centralizada; Selûne adicionada com duas bênçãos; Kayron e
  Maelor recebem patronos iniciais. Dano e aura usam a última afinidade; aura
  só começa após altar.
- Câmera configurada em zoom 1,15.

## Verificações executadas

- Todos os JSONs em `data/` foram desserializados com sucesso.
- `git diff --check` não reportou erro de whitespace.
- Contagem estática: 30 props visíveis em Dagruve; 2 bênçãos de Selûne.

## Exceção

`godot --headless --path . -s res://tests/run_all.gd` não pôde ser executado:
o executável Godot não está disponível no PATH deste ambiente. Assim, os testes
novos e o QA visual em runtime continuam pendentes e não são declarados como
aprovados.
