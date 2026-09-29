---
id: "SPEC-065"
title: "Props de cenário de Shedaklah"
status: "preparada — aguardando geração externa de arte"
created: "2026-09-28"
relations:
  - "[[ART-PROMPTS-024-cenario-e-quebraveis-por-bioma]]"
  - "[[SPEC-062-fila-de-geracao-externa-de-assets]]"
---

# SPEC-065 — Props de cenário de Shedaklah

## Objetivo

Adicionar duas famílias novas de prop puramente decorativo a Shedaklah
(fungo/slime), reforçando o tema além da família única já existente
(`cogumelo`, de ART-PROMPTS-007).

## Escopo

- Gerar e integrar `esporo_01`/`esporo_02` (cacho de vagens de esporo) e
  `lodo_01` (poça de lodo fúngico elevada), conforme prompts em
  [[ART-PROMPTS-024-cenario-e-quebraveis-por-bioma]] (bloco "props de
  cenário", linhas de Shedaklah).
- PNGs RGBA até 256×256, mesmo contrato de ART-PROMPTS-007.
- Expor os tipos novos em `ui/prop.gd` (`@export_enum`) e instanciar em
  `ui/stages/shedaklah.tscn` (ou scene equivalente).

## Não objetivos

- Não altera dados de combate, ondas, lore ou a fase em si.
- Não substitui a família `cogumelo` já existente — soma-se a ela.
- Não gera arte nesta spec (sem ferramenta de geração nesta sessão) — fica
  na fila de [[SPEC-062-fila-de-geracao-externa-de-assets]] até o dono gerar
  externamente.

## Critérios de aceite

1. Três PNGs novos (`esporo_01`, `esporo_02`, `lodo_01`) com dimensão
   consistente e transparência real.
2. Os tipos ficam disponíveis em `ui/prop.gd`.
3. Pelo menos uma instância de cada variante aparece na cena de Shedaklah.
4. Testes de assets/props e suíte continuam verdes.

## Limites

- Execução (integração na cena) só acontece depois que a arte for gerada e
  admitida — esta spec não bloqueia nem antecipa isso.
