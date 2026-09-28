---
id: "SPEC-057"
title: "Save resiliente e ajuda de regras"
status: "executada e verificada; evidência EVID-087"
created: "2026-09-27"
relations:
  - "[[PLAN-028-save-resiliente-e-ajuda-de-regras-2026-09-27]]"
---

# SPEC-057 — Save resiliente e ajuda de regras

## Escopo

Implementar perfil local recuperável por temporário e backup, e uma ajuda de
regras por botão `?`, independente do guia F1 de playtest.

## Critérios de aceite

1. Save principal e backup são JSON-dicionários válidos após gravação.
2. Principal inválido recupera backup válido sem apagar o arquivo defeituoso.
3. Sandbox QA usa somente seu próprio caminho de perfil.
4. A ajuda pausa a run, não pede nome e não persiste dados.
5. Testes de armazenamento, sandbox e UI, suíte e smoke passam.

## Plano de voo aprovado

1. Extrair leitura validada, promoção temporária, backup e recuperação em
   `Game`, com testes de arquivos temporários controlados.
2. Acrescentar modal de regras e botões `?` no HUD/pausa, mantendo F1 inalterado.
3. Executar validações e registrar evidência/reconciliação.

## Não objetivos

Não há alteração de formato, balanceamento, progressão, rede, conta ou regras
de jogo; o texto apenas explica as regras já existentes.

## Reconciliação

Executada em 2026-09-27. A evidência EVID-087 registra testes de promoção,
backup, recuperação, preservação de corrupção, isolamento QA, texto de regras e
smoke das nove fases. O guia F1 de playtest foi preservado; a ajuda de jogador é
um fluxo separado, sem nome ou escrita em perfil.
