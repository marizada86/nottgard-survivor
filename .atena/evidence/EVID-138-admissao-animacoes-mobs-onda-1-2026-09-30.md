---
id: "EVID-138"
title: "Admissão das animações aprovadas dos mobs da Onda 1"
date: "2026-09-30"
relations:
  - "[[SPEC-111-admissao-animacoes-mobs-onda-1]]"
  - "[[PLAN-048-geracao-animacoes-mobs-onda-1-2026-09-30]]"
  - "[[CANDIDATES-MANIFEST-003]]"
  - "[[EVID-128-lote-a-animacoes-mobs-onda-1-2026-09-30]]"
  - "[[EVID-133-lote-b-mobs-onda-1-2026-09-30]]"
  - "[[EVID-134-lote-c-mobs-onda-1-2026-09-30]]"
  - "[[EVID-136-ciclo-guardiao-copia-2026-09-30]]"
---

# EVID-138 — Admissão das animações aprovadas dos mobs da Onda 1

## Escopo admitido

O pedido explícito do dono consolidou os ciclos aprovados da Onda 1. O
compositor `tools/build_wave_one_enemy_strips.ps1` tomou apenas os quadros
selecionados pelo `CANDIDATES-MANIFEST-003`, criou cópias candidatas locais e
promoveu 37 tiras para `assets/animations/enemies/`:

| Perfil | Inimigos | Estados por inimigo | Tiras |
|---|---|---|---:|
| A | slime_corrosivo, cultista_arqueiro, cultista_cajado, notivago, criatura_corrompida, arch_hag | idle, move, attack, death | 24 |
| C | tentaculo_kraken | idle, attack, death | 3 |
| B | guardiao_verdadeiro, guardiao_copia | idle, move, attack, special, death | 10 |

Os seis perfis A/C usam células 256×384. Os dois guardiões usam 320×480. Cada
tira é horizontal e preserva diretamente os pixels, a ordem e as versões
selecionadas dos quadros; os overrides v02 de slime, arqueiro, tentáculo e
guardião verdadeiro foram aplicados. Para `guardiao_copia`, `idle_00`,
`attack_02` e `death_05` vieram dos três pilotos aprovados; os demais quadros
vieram do ciclo variante aprovado.

## Integração e verificação

- `ui/enemy_view.gd` passou a registrar os nove inimigos e seus estados. Perfis
  móveis espelham somente a animação de movimento; ataque, morte e `special`
  usam orientação-base.
- `tests/test_animation_assets.gd` valida existência, importação, dimensão,
  alfa, contagem de frames e reprodução runtime de ataque, morte, movimento e
  `special` quando disponível.
- Godot 4.7.2 executou `--import` e reimportou os 37 PNGs.
- `godot --headless --path . -s tests/run_all.gd` finalizou com `testes: 0
  falha(s)`.
- `git diff --check` não reportou erro de whitespace.
- Inspeção visual independente de `slime_corrosivo/move` e
  `guardiao_copia/special` confirmou ordem legível, transparência e ausência de
  corte nas células compostas.

## Limites preservados

Não foram alterados os PNGs estáticos, IA, dados, atributos, combate, SFX ou
balanceamento. Pranchas de prova de Durvall e Leoric continuam em
`.atena/generated/` e não foram normalizadas nem admitidas.
