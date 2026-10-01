---
id: "SPEC-112"
title: "Normalização de linha de base e bordas das tiras dos heróis"
status: "executada em 2026-10-01; aguarda playtest"
created: "2026-10-01"
relations:
  - "[[SPEC-101-polimento-proporcoes-movimento-herois]]"
  - "[[SPEC-102-piloto-runtime-escala-direcional-durvall]]"
  - "[[EVID-139-playtest-higor-qa-14b15e4-2026-10-01]]"
  - "[[EVID-140-normalizacao-base-e-bordas-dos-herois-2026-10-01]]"
---

# SPEC-112 — Normalização de linha de base e bordas (BUG-021, caminho 2)

## Intenção
Corrigir só o que é objetivo nas tiras de `assets/animations/heroes/`: base dos pés
alinhada à do `idle` do mesmo herói e nenhum quadro tocando a borda da célula 256×384.

## Não objetivos
- **Não** igualar a altura entre tiras. A escala de cada tira veio do encaixe de
  `normalize_animation_grid_fit.gd` (caixa 232×360); sem os originais e só pela caixa de alfa
  não dá para recuperar o tamanho real do corpo (mesma causa da reprovação da SPEC-102).
  Isso fica para o caminho 1 (medir o corpo) ou regeneração.

## Método — `tools/normalize_hero_baseline_edges.gd`
- Alvo de base por herói: mediana da base do `idle` (máx. 376).
- Por tira: **uma** escala (só reduz, mínimo ~0,977) e **um** deslocamento, calculados pela
  caixa de todos os quadros com margem de 3 px. Movimento interno preservado.
- Só grava tiras com base fora do alvo (> 2 px) ou quadro na borda. Padrão é relatório; `--write` grava.
- Reversão: `git checkout -- assets/animations/heroes`.

## Aceite
`edge_frames` = 0 em todo o elenco; `tests/run_all.gd` sem falhas; pares antes/depois sem corte.
