# PLAN-100 / B-002 — resultado (DRAFT, 2026-10-13)

SPEC-173 r2, MEC-066. Fonte dos titulos em Opcoes -> TELA -> Fonte dos titulos. Padrao: Cinzel Decorative (inalterado).
> **Atualização (2026-10-13, depois do fechamento):** o dono escolheu a IM Fell English como padrão dos títulos; a Cinzel virou opção. Ver EVID-242, seção 5.

## Download aprovado e feito (2026-10-13, "aprovo o download, pode baixar")
Origem: `raw.githubusercontent.com/google/fonts/main/ofl/...` (OFL). Em `assets/fonts/`:
AlmendraDisplay-Regular.ttf (39 264 B), UncialAntiqua-Regular.ttf (63 404 B), PirataOne-Regular.ttf (56 316 B), IMFeENrm28P.ttf (194 992 B),
OFL-AlmendraDisplay.txt, OFL-UncialAntiqua.txt, OFL-PirataOne.txt, OFL-IMFellEnglish.txt. Tamanhos conferem com os informados.

## Entregue (local, sem commit)
- `ui/ui_fonts.gd` (resolvedor, so candidatas com arquivo, fallback para Cinzel), ligado em `Lettering.style` e `ui/title.gd`; opcao no `OptionsPanel`; `Game.set_ui_font`; `settings.ui_font`.
- Escopo: so titulos e lettering. Corpo (Alegreya), botoes e numeros nao mudam.
- Compensacao por fonte (`size`, `outline`, `embolden`): a Almendra Display ficou ilegivel com o contorno do lettering; engrossada com embolden 0.9 e contorno 0.5 (capturas antes/depois na pasta de capturas).
- `tests/test_ui_fonts.gd`, `tools/capture_ui_fonts.*`; capturas em `.atena/generated/plan-100/capturas-fontes/` (Quartel, abas 0 e 1, 5 fontes).

## Verificacao
- Cobertura de glifos: as 4 candidatas cobrem o alfabeto portugues, pontuacao e algarismos. Excecao registrada: "À" maiusculo (Almendra nao tem; nao aparece em texto algum do jogo; o fallback cobre).
- `tests/run_all.gd`: 0 falhas.

## Pendente (subjetivo, do dono)
- Qual fonte combina com o jogo; se alguma deve virar padrao. Nada muda de padrao sem esse retorno.
- Capturas so do Quartel; HUD de partida, pausa e banners de arte nao mudam de fonte (banners sao imagem).
