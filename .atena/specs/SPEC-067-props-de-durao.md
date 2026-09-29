---
id: "SPEC-067"
title: "Props de cenário de Durao"
status: "executada e verificada"
created: "2026-09-28"
relations:
  - "[[ART-PROMPTS-024-cenario-e-quebraveis-por-bioma]]"
  - "[[SPEC-062-fila-de-geracao-externa-de-assets]]"
---

# SPEC-067 — Props de cenário de Durao

## Objetivo

Adicionar duas famílias novas de prop puramente decorativo a Durao (a jaula
e o rio de almas), além da família única já existente (`rocha`, de
ART-PROMPTS-007).

## Escopo

- Gerar e integrar `corrente_01`/`corrente_02` (corrente enferrujada solta /
  poste de prisão com grilhão) e `osso_01` (pilha de ossos), conforme
  prompts em [[ART-PROMPTS-024-cenario-e-quebraveis-por-bioma]] (linhas de
  Durao).
- PNGs RGBA até 256×256, mesmo contrato de ART-PROMPTS-007.
- Expor os tipos novos em `ui/prop.gd` e instanciar na cena de Durao.

## Não objetivos

- Não altera dados de combate, ondas, lore ou a fase em si.
- Não substitui a família `rocha` já existente.
- Não gera arte nesta spec — fica na fila de
  [[SPEC-062-fila-de-geracao-externa-de-assets]].

## Critérios de aceite

1. Três PNGs novos (`corrente_01`, `corrente_02`, `osso_01`) com dimensão
   consistente e transparência real.
2. Os tipos ficam disponíveis em `ui/prop.gd`.
3. Pelo menos uma instância de cada variante aparece na cena de Durao.
4. Testes de assets/props e suíte continuam verdes.

## Limites

- Execução (integração na cena) só acontece depois que a arte for gerada e
  admitida.

## Reconciliação

- As três artes aprovadas foram normalizadas para PNG RGBA 256×256 e admitidas
  em `assets/props/` em 2026-09-28.
- Os tipos estão expostos em `ui/prop.gd` e têm instâncias decorativas, sem
  colisão, em `ui/stages/durao.tscn`.
- A suíte automatizada e o smoke do jogo passaram; ver
  [[EVID-101-props-durao-candidatos-2026-09-28]].
