# SPEC-011 — Fase 1: prompts de arte

Status: **aprovada em 2026-09-21 — executada e verificada**

## Objetivo

Criar `ART-PROMPTS-001..010` sem gerar imagens, alterar gameplay ou modificar o vault canônico.

## Escopo

- consolidar direção, transparência, perspectiva, iluminação, escala e nomes;
- redigir prompts autocontidos no padrão de `nottcard-ai`;
- mapear cada prompt para um arquivo final e suas candidatas;
- incluir fontes de lore, referências, dependências, checklist e registro;
- cobrir primeiro as 44 lacunas já consumidas;
- manter assets ainda não integrados em lotes separados;
- registrar dúvidas sem resolvê-las por inferência.

## Não escopo

- chamadas ao ImageGen ou criação/processamento de PNGs;
- novos inimigos em `data/enemies.json`;
- renomear IDs ou alterar encontros, chefes, roteiro e cânone;
- animação quadro a quadro.

## Critérios de aceite

1. As 39 lacunas de inimigo e 5 de retrato aparecem exatamente uma vez no índice.
2. Todo prompt informa ID, uso, caminhos, dimensões, fundo, enquadramento, referências, lore e aceite.
3. Os prompts são autocontidos e mantêm o bloco de estilo aprovado.
4. Dependências têm ordem explícita: base antes de ilusão, elite ou variante.
5. Nenhum prompt introduz lore não aprovada.
6. Lotes futuros não são confundidos com arquivos que o jogo já carrega.
7. Uma revisão cruza prompts, JSON, vault e matriz e registra divergências.

## Plano de voo

1. Congelar as decisões do gate de `ASSET-MATRIX-001`.
2. Criar `ART-PROMPTS-001` e revisar o piloto sem gerar imagens.
3. Criar 002–006, cobrindo as 44 lacunas imediatas.
4. Auditar unicidade, caminhos, dependências e lore.
5. Criar 007–010 para os lotes futuros.
6. Registrar `.atena/evidence/EVID-005-prompts-de-arte.md`.
7. Pedir aprovação separada para a geração.

## Gate de execução

Esta spec só autoriza redação de prompts após aprovação explícita. Mesmo aprovada, não autoriza gerar imagens.
