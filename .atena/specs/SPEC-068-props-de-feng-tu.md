---
id: "SPEC-068"
title: "Props de cenário de Feng-tu"
status: "preparada — aguardando geração externa de arte"
created: "2026-09-28"
relations:
  - "[[ART-PROMPTS-024-cenario-e-quebraveis-por-bioma]]"
  - "[[SPEC-062-fila-de-geracao-externa-de-assets]]"
---

# SPEC-068 — Props de cenário de Feng-tu

## Objetivo

Adicionar duas famílias novas de prop puramente decorativo a Feng-tu
(templo de Tou Um), além da família única já existente (`torii`, de
ART-PROMPTS-007).

## Escopo

- Gerar e integrar `lanterna_01`/`lanterna_02` (poste de lanterna de papel,
  intacta e rasgada) e `sino_01` (sino de templo), conforme prompts em
  [[ART-PROMPTS-024-cenario-e-quebraveis-por-bioma]] (linhas de Feng-tu).
- PNGs RGBA até 256×256, mesmo contrato de ART-PROMPTS-007.
- Expor os tipos novos em `ui/prop.gd` e instanciar na cena de Feng-tu.

## Não objetivos

- Não altera dados de combate, ondas, lore ou a fase em si.
- Não substitui a família `torii` já existente.
- Não gera arte nesta spec — fica na fila de
  [[SPEC-062-fila-de-geracao-externa-de-assets]].

## Critérios de aceite

1. Três PNGs novos (`lanterna_01`, `lanterna_02`, `sino_01`) com dimensão
   consistente e transparência real.
2. Os tipos ficam disponíveis em `ui/prop.gd`.
3. Pelo menos uma instância de cada variante aparece na cena de Feng-tu.
4. Testes de assets/props e suíte continuam verdes.

## Limites

- Execução (integração na cena) só acontece depois que a arte for gerada e
  admitida.
