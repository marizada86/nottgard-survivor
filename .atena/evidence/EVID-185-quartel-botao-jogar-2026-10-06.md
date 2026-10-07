---
id: EVID-185
title: Botão Jogar acessível no Quartel
created: 2026-10-06
kind: owner-feedback-correction
origin: guided-add
implementation_preceded_spec: false
spec: "../specs/SPEC-135-experiencia-controles-xbox-playstation-2026-10-06.md"
state: "../state/plan-068-controles-xbox-playstation.yaml"
---

# Correção local P068-v02 — BUG-030

O dono informou “atena no menu inicial falta o botão jogar, não consegui iniciar uma tentativa” e esclareceu: **Quartel com heróis e fases**. Classificação **IN_PLAN**, S-007/S-010 revalidados dentro da aprovação per-plan de PLAN-068. Checkpoint físico B-004/S-011 e retornos mobile/Durvall preservados. Nenhum commit, exportação ou publicação.

## Resultado e limites

O botão existia dentro da coluna de fases; a captura anterior 1280×720 o mostrava. A causa exata no monitor/build usado pelo dono não foi confirmada. A correção elimina a dependência do botão em relação ao tamanho dessa coluna: **JOGAR** agora é filho direto do menu, ancorado no rodapé, com área própria reservada abaixo das listas. Aparece somente na aba Jogar e respeita a área segura mobile. O ícone acompanha família e confirmação Padrão/Legado. Direcional continua Herói → Fase → Jogar. Gerador da cena também atualizado.

## Validação

- [21 verificações de acesso](../generated/controller-experience/v02/menu-start-report.json), zero falhas: botão inteiro em 1280×720, 1600×900, 1920×1080, 1024×768, 1280×600 e 960×540; conteúdo excedente de 900 px não desloca o botão; abas ocultam/restauram; direcional alcança; A no Padrão e B no Legado iniciam tentativas; clique e mouse emulado de toque iniciam; perfil real preservado. [Execução com renderização](../generated/controller-experience/v02/menu-start.log), [headless](../generated/controller-experience/v02/menu-start-headless.log).
- [90 verificações de controle](../generated/controller-experience/v02/integration-report.json), zero falhas: jornada e contextos existentes preservados, incluindo quatro famílias e abas LB/L1 e RB/R1. [Log](../generated/controller-experience/v02/integration.log).
- [144 verificações mobile](../generated/controller-experience/v02/mobile-buttons-report.json), zero falhas. Relatório mobile anterior restaurado exatamente do snapshot anterior à regressão; nenhum aceite nativo inventado. [Log](../generated/controller-experience/v02/mobile-buttons.log).
- [Suíte completa](../generated/controller-experience/v02/suite.log): zero falhas.
- Capturas de todas as seis dimensões; inspeção visual em [720p](../generated/controller-experience/v02/quartel_1280x720.png) e [janela mais baixa](../generated/controller-experience/v02/quartel_1280x600.png) confirma botão separado e legível.

Godot 4.7.2 local. Eventos sintetizados e perfis descartáveis. O teste de toque verifica o mouse emulado usado pela UI; o dispositivo mobile físico continua pendente. Capturas adaptam o ícone ao último método de entrada; movimento real do mouse durante redimensionamento pode mostrar versão sem ícone. A verificação de ícone ocorre após comando deliberado do controle. A primeira versão do verificador usou nome vazio e abriu o guia de boas-vindas; a fixture foi corrigida para representar o piloto nomeado. Os testes finais acima passaram.

Avisos de encerramento já existentes ficam nos logs (suíte: 3 RIDs, 30 objetos, 5 recursos; integração/acesso: 4 objetos e 2 recursos; mobile: 6 objetos e 3 recursos). Captura apresenta indisponibilidade do cache de shaders no ambiente restrito. Nenhuma permissão alterada.

## Entrega e retorno

[Abrir piloto P068-v02](../generated/controller-experience/v02/Abrir-teste-Xbox.cmd), [guia](../generated/controller-experience/v02/Como-testar-Xbox.md), [manifesto](../generated/controller-experience/v02/pilot-manifest.json), [validação documental](../generated/controller-experience/v02/delivery-validation.json). O perfil piloto v01 é reutilizado para preservar preferências/progresso do dono. Recuperação desta mudança em [recovery](../generated/controller-experience/v02/recovery/); fontes v01 e evidência EVID-184 permanecem históricas. BUG-030 implementado localmente, **reteste Xbox pendente**. S-011 continua aberto; DS4/DualSense não testados fisicamente.
