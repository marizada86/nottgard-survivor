---
id: "SPEC-066"
title: "Props de cenário de Molor"
status: "preparada — aguardando geração externa de arte"
created: "2026-09-28"
relations:
  - "[[ART-PROMPTS-024-cenario-e-quebraveis-por-bioma]]"
  - "[[SPEC-062-fila-de-geracao-externa-de-assets]]"
---

# SPEC-066 — Props de cenário de Molor

## Objetivo

Adicionar duas famílias novas de prop puramente decorativo a Molor (caverna
de bolhas), além da família única já existente (`bolha`, de
ART-PROMPTS-007).

## Escopo

- Gerar e integrar `estalactite_01`/`estalactite_02` (estalactite viscosa
  pingando) e `resina_01` (poça de resina ácida solidificada), conforme
  prompts em [[ART-PROMPTS-024-cenario-e-quebraveis-por-bioma]] (linhas de
  Molor).
- PNGs RGBA até 256×256, mesmo contrato de ART-PROMPTS-007.
- Expor os tipos novos em `ui/prop.gd` e instanciar na cena de Molor.

## Não objetivos

- Não altera dados de combate, ondas, lore ou a fase em si.
- Não substitui a família `bolha` já existente.
- Não gera arte nesta spec — fica na fila de
  [[SPEC-062-fila-de-geracao-externa-de-assets]].

## Critérios de aceite

1. Três PNGs novos (`estalactite_01`, `estalactite_02`, `resina_01`) com
   dimensão consistente e transparência real.
2. Os tipos ficam disponíveis em `ui/prop.gd`.
3. Pelo menos uma instância de cada variante aparece na cena de Molor.
4. Testes de assets/props e suíte continuam verdes.

## Limites

- Execução (integração na cena) só acontece depois que a arte for gerada e
  admitida.
