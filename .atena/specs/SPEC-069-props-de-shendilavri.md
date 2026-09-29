---
id: "SPEC-069"
title: "Props de cenário de Shendilavri"
status: "preparada — aguardando geração externa de arte"
created: "2026-09-28"
relations:
  - "[[ART-PROMPTS-024-cenario-e-quebraveis-por-bioma]]"
  - "[[SPEC-062-fila-de-geracao-externa-de-assets]]"
---

# SPEC-069 — Props de cenário de Shendilavri

## Objetivo

Adicionar três famílias novas de prop puramente decorativo a Shendilavri
(reino das súcubos, Rivenheart), além da família única já existente
(`cristal`, de ART-PROMPTS-007).

## Escopo

- Gerar e integrar `veu_01` (véu de seda pendurado), `taca_01` (taça
  derramada sobre mesa partida) e `espelho_ornado_01` (moldura de espelho
  vazia), conforme prompts em
  [[ART-PROMPTS-024-cenario-e-quebraveis-por-bioma]] (linhas de
  Shendilavri).
- PNGs RGBA até 256×256, mesmo contrato de ART-PROMPTS-007.
- Expor os tipos novos em `ui/prop.gd` e instanciar na cena de Shendilavri.

## Não objetivos

- Não altera dados de combate, ondas, lore ou a fase em si.
- Não substitui a família `cristal` já existente.
- Não gera arte nesta spec — fica na fila de
  [[SPEC-062-fila-de-geracao-externa-de-assets]].

## Critérios de aceite

1. Três PNGs novos (`veu_01`, `taca_01`, `espelho_ornado_01`) com dimensão
   consistente e transparência real.
2. Os tipos ficam disponíveis em `ui/prop.gd`.
3. Pelo menos uma instância de cada variante aparece na cena de Shendilavri.
4. Testes de assets/props e suíte continuam verdes.

## Limites

- Execução (integração na cena) só acontece depois que a arte for gerada e
  admitida.
