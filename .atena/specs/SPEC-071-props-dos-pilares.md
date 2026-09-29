---
id: "SPEC-071"
title: "Props de cenário dos Pilares"
status: "preparada — aguardando geração externa de arte"
created: "2026-09-28"
relations:
  - "[[ART-PROMPTS-024-cenario-e-quebraveis-por-bioma]]"
  - "[[SPEC-062-fila-de-geracao-externa-de-assets]]"
---

# SPEC-071 — Props de cenário dos Pilares

## Objetivo

Adicionar três famílias novas de prop puramente decorativo aos Pilares
(modo infinito), além da família única já existente (`pilar_abissal`, de
ART-PROMPTS-007).

## Escopo

- Gerar e integrar `fragmento_01` (fragmento de pilar flutuante),
  `runa_01` (placa de runa instável) e `nucleo_01` (núcleo cristalino
  pulsante), conforme prompts em
  [[ART-PROMPTS-024-cenario-e-quebraveis-por-bioma]] (linhas dos Pilares).
- PNGs RGBA até 256×256, mesmo contrato de ART-PROMPTS-007.
- Expor os tipos novos em `ui/prop.gd` e instanciar na cena dos Pilares.

## Não objetivos

- Não altera dados de combate, ondas, lore, a rotação de regras ou a fase em
  si.
- Não substitui a família `pilar_abissal` já existente.
- Não gera arte nesta spec — fica na fila de
  [[SPEC-062-fila-de-geracao-externa-de-assets]].

## Critérios de aceite

1. Três PNGs novos (`fragmento_01`, `runa_01`, `nucleo_01`) com dimensão
   consistente e transparência real.
2. Os tipos ficam disponíveis em `ui/prop.gd`.
3. Pelo menos uma instância de cada variante aparece na cena dos Pilares.
4. Testes de assets/props e suíte continuam verdes.

## Limites

- Execução (integração na cena) só acontece depois que a arte for gerada e
  admitida.
