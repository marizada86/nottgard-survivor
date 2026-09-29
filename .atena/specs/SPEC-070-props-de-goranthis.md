---
id: "SPEC-070"
title: "Props de cenário de Goranthis"
status: "preparada — aguardando geração externa de arte"
created: "2026-09-28"
relations:
  - "[[ART-PROMPTS-024-cenario-e-quebraveis-por-bioma]]"
  - "[[SPEC-062-fila-de-geracao-externa-de-assets]]"
---

# SPEC-070 — Props de cenário de Goranthis

## Objetivo

Adicionar três famílias novas de prop puramente decorativo a Goranthis (o
verdadeiro Paraíso), além da família única já existente (`cachoeira`, de
ART-PROMPTS-007).

## Escopo

- Gerar e integrar `coluna_01` (coluna de mármore rachada com musgo),
  `flor_01` (touceira com pétala corrompida) e `taca_dourada_01` (taça
  cerimonial tombada), conforme prompts em
  [[ART-PROMPTS-024-cenario-e-quebraveis-por-bioma]] (linhas de Goranthis).
- PNGs RGBA até 256×256, mesmo contrato de ART-PROMPTS-007.
- Expor os tipos novos em `ui/prop.gd` e instanciar na cena de Goranthis.

## Não objetivos

- Não altera dados de combate, ondas, lore ou a fase em si.
- Não substitui a família `cachoeira` já existente.
- Não gera arte nesta spec — fica na fila de
  [[SPEC-062-fila-de-geracao-externa-de-assets]].

## Critérios de aceite

1. Três PNGs novos (`coluna_01`, `flor_01`, `taca_dourada_01`) com dimensão
   consistente e transparência real.
2. Os tipos ficam disponíveis em `ui/prop.gd`.
3. Pelo menos uma instância de cada variante aparece na cena de Goranthis.
4. Testes de assets/props e suíte continuam verdes.

## Limites

- Execução (integração na cena) só acontece depois que a arte for gerada e
  admitida.
