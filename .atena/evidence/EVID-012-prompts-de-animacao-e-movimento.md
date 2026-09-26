# EVID-012 — Prompts de animação e movimento sudoeste

Data: 2026-09-23

## Entregas

- `ART-PROMPTS-016-animacoes-dos-herois.md`: 108 prompts novos para Brook,
  Maelor, Sylas, Kayron, Korrak, Leoric, Nyrelia, Zynara e Bromnor.
- `HERO-ANIMATION-PROMPT-MANIFEST-001.json`: 10 heróis × 12 sequências = 120;
  108 novas e 12 de Durvall reaproveitadas de `ART-PROMPTS-014` e `015`.
- `tests/test_hero_animation_prompt_manifest.gd`: auditoria de manifesto,
  cobertura e IDs de prompt.
- `Hero.movement_input()` e regressão em `test_animation_assets.gd` para a rota
  `A+S → (-1, 1) → movimento em tela → move_sw`.

## Validação executada

1. `D:\Godot\Godot_v4.7.2-stable_win64.exe --headless --path . -s tests/run_all.gd`
   terminou com `testes: 0 falha(s)`.
2. `D:\Godot\Godot_v4.7.2-stable_win64.exe --headless --path . res://tools/smoke.tscn`
   abriu Dagruve, Shedaklah, Molor, Durao, Feng-tu, Shendilavri, Goranthis e
   Pilares em `running`, com inimigos; resultado `smoke: ok`.

Os avisos de `user://logs`, certificados do sistema e objetos vivos ao encerrar
o smoke são externos ao contrato desta entrega e não produziram falha de teste.

## Limitação conhecida

O ambiente não forneceu uma janela nativa do jogo para inspeção visual manual.
Logo, a regressão automatizada prova o mapeamento de entrada, o deslocamento
projetado e a seleção de `move_sw`, mas não declara uma inspeção humana da
qualidade visual da faixa. Nenhum PNG foi gerado, enviado ou substituído.
