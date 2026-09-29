# EVID-060 — Opções de áudio e vídeo

Data: 2026-09-29

## Entrega

- Aba Opções organizada em Áudio, Vídeo, Jogabilidade e Ações, com rolagem
  para preservar a usabilidade na menor resolução suportada.
- Sliders para mestre, música, efeitos e ambiência; mutes por canal preservam
  os valores dos sliders no perfil.
- Modos Janela, Sem borda e Tela cheia, e resoluções 1280×720, 1600×900 e
  1920×1080 persistidos no perfil.
- Perfis legados migram `fullscreen` para `window_mode` sem mudar a intenção
  anterior.
- O gerador de cenas reproduz a estrutura da cena editada.

## Verificações

- `git diff --check`: aprovado, sem erros de whitespace.
- `tests/test_profile.gd`: carrega no runner e cobre defaults e migração de
  perfis de janela/tela cheia.
- `tests/test_options_menu.gd`: carrega e instancia `ui/menu.tscn`, e confirma
  os três mutes, modo de exibição e resolução.
- A suíte reportou `testes: 0 falha(s)`.

## Exceção de validação

O inicializador ainda registra um erro de parse preexistente em
`core/playtest.gd` (`ALLOWED_EVIDENCE_EXTENSIONS` não é expressão constante),
mais erros derivados em `test_playtest.gd`. Essas alterações pertencem ao
trabalho paralelo presente antes desta SPEC e não foram modificadas. Por isso,
a execução visual completa do jogo não pôde ser certificada neste checkout,
apesar dos testes focados e da inspeção de cena terem concluído.

