---
id: "EVID-137"
title: "Lote inicial de candidatos de animação de Leoric"
created: "2026-09-30"
relations:
  - "[[SPEC-110-pacote-integral-animacoes-leoric]]"
  - "[[PLAN-049-animacoes-integrais-dos-herois-2026-09-30]]"
  - "[[EVID-133-inventario-visual-herois-2026-09-30]]"
---

# EVID-137 — Lote inicial de candidatos de animação de Leoric

## Resultado

Após aprovação explícita do dono, o ImageGen integrado produziu o lote de prova
da SPEC-110. O manifesto
`generated/leoric-animation-package/v01/review-manifest.md` registra as cinco
referências transferidas, os quatro candidatos selecionados, prompts, hashes e
checagens técnicas.

As quatro pranchas selecionadas têm `1536×1024`, grade adequada à proposta e
alfa 0 nos pontos de teste `(0,0)` e no espaço central entre células. A
identidade visual de Leoric permanece reconhecível nas pranchas corporais e o
efeito de Constelação está separado do personagem.

## Limites verificados

- Não houve escrita em `assets/`, `data/`, `ui/` ou `core/`.
- Não houve normalização de prancha em tira, reimportação Godot, alteração de
  runtime, teste de gameplay, integração ou admissão oficial.
- Duas primeiras tentativas fora de `1536×1024` foram preservadas como
  candidatas não selecionadas; as correções v02 foram usadas somente para
  `move_e` e Constelação.

## Próximo gate

A revisão artística do dono por prancha decide se alguma candidata pode avançar
para normalização. Não há autorização para modificar os assets oficiais.
