# EVID-245 — Fonte do corpo do jogo: EB Garamond (2026-10-14)

**Origem:** dono, "considerar também virar a fonte padrão para o jogo, temos que trocá-la" (2026-10-13); depois "aprovo a EB Garamond, pode aplicar" (2026-10-14).
**Ligação:** SPEC-173 r4 / MEC-069; continua o PLAN-100 (fechado); conteúdo DRAFT até o playtest.
**Estado medido:** HEAD `cdbce21` + árvore de trabalho; Godot 4.7.2.

## 1. Avaliação
IM Fell English no corpo: clima certo, mas algarismos irregulares sem `lnum` ("Moedas: 1172" lê "I172", "01:35", "[2/10]") e layout deslocado. Três candidatas com algarismos alinhados foram baixadas (download aprovado em 2026-10-13) e comparadas com a Alegreya Sans: Spectral (linhas mais altas, empurra botões), Cardo (compacta, mais larga) e **EB Garamond** (mesma altura de linha da Alegreya, a lista de Melhorias cabe igual).

## 2. Aplicado (local)
- `ui/theme.tres`: `default_font` passa a ser uma `FontVariation` sobre `EBGaramond-Variable.ttf`, com `AlegreyaSans-Regular.ttf` de fallback de glifo; `default_font_size` 20.
- `assets/fonts/EBGaramond-Variable.ttf` (851 176 B) e `OFL-EBGaramond.txt`. Spectral e Cardo foram removidas (não escolhidas; nunca commitadas).
- `tests/test_body_font.gd` (tema, fallback, cobertura de glifos, tamanho, tema do projeto).
- Títulos e lettering continuam na IM Fell English (MEC-066). Números de dano e rótulos do mundo seguem a fonte do tema.

## 3. Verificação
| Verificação | Resultado |
|---|---|
| `tests/run_all.gd` | 0 falhas |
| smoke (9 fases) | ok |
| `controller_check` | 94/0 |
| `mobile_buttons_check` | 146/0 |

Achado: com tamanho 21 o teste de avisos do topo (`test_playtest_fixes`: epígrafe e aviso curto) deu 126 px contra o teto 120; o tamanho voltou a 20 e passou.
Capturas conferidas (locais, `.atena/generated/plan-100/capturas-corpo3/`): Quartel (Jogar, Melhorias, Diário), HUD em partida e ficha C (4 abas).

## 4. Pendências
- Subjetivo, do dono: se a EB Garamond combina com o jogo e se o tamanho está confortável na HUD e nos botões.
- Textos que usam a fonte de fallback do motor (Nv/quantidade nos slots da ficha, rótulos desenhados com `draw_string`) não mudam.
- Commit local feito em separado (MEC-069); push e exportação não autorizados.
