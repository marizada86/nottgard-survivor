---
id: "EVID-124"
title: "Piloto do cultista de adaga — candidatas geradas"
date: "2026-09-29"
relations:
  - "[[SPEC-097-geracao-das-imagens-de-arte-pendentes]]"
  - "[[PLAN-045-piloto-animacao-cultista-adaga-2026-09-29]]"
  - "[[ART-PROMPTS-031-piloto-animacao-cultista-adaga]]"
  - "[[IMAGEGEN-LOG-001-piloto-cultista-2026-09-29]]"
---

# EVID-124 — Candidatas geradas

## Resultado

O plano aprovado gerou as 24 candidatas do piloto usando o gerador ImageGen
nativo. E01 foi aprovado pelo dono em 2026-09-29; em 2026-09-30 o dono aprovou
as demais candidatas nas cinco pranchas: idle, move, attack, death e strips.
Ver aprovação, versões alfa e comparação dos métodos em
[[EVID-125-piloto-cultista-aprovacao-alfa-comparacao-2026-09-30]].

## Inventário e verificação

- Caminho-base: `.atena/generated/art-candidates/enemy-pilot/cultista_adaga/`.
- E01–E20: 20 PNGs retrato, cada um com 1024×1536.
- E21–E24: 4 PNGs de tiras horizontais; E21 mede 2048×768 e E22–E24 medem
  2172×724.
- Os 24 caminhos do `CANDIDATES-MANIFEST-002` existem.
- Todas as imagens têm fundo ciano opaco e não têm canal alfa; a remoção do
  fundo é etapa posterior de processamento e aprovação.
- Pranchas de revisão: `review/review_idle.png`, `review/review_move.png`,
  `review/review_attack.png`, `review/review_death.png` e
  `review/review_strips.png`.
- Prompts e referências usados: `[[IMAGEGEN-LOG-001-piloto-cultista-2026-09-29]]`.

## Estado após aprovação

A aprovação dos 24 arquivos e o teste de extração das tiras estão reconciliados
em [[EVID-125-piloto-cultista-aprovacao-alfa-comparacao-2026-09-30]]. Qualquer
admissão em `assets/` permanece fora desta evidência e exige o gate de seleção
previsto no prompt de origem.
