---
id: EVID-176
title: Preparação do plano mobile por toque
created: 2026-10-06
kind: planning
origin: guided-add
implementation_preceded_spec: false
spec: "../specs/SPEC-134-controles-e-menus-mobile-2026-10-06.md"
plan: "../vault/drafts/PLAN-067-controles-e-menus-mobile-2026-10-06.md"
---

# Preparação do plano mobile por toque

O dono solicitou o plano após a recomendação de joystick flutuante, habilidade/interação em botões separados e menus por toque. Explicitou que o joystick seria somente para andar. Autorizou a preparação da proposta; execução, prioridade e nível de aprovação permanecem pendentes.

## Constatações locais

- .atena/add.yaml registra ADD 0.2, RTK habilitado, escrita de drafts permitida e gates independentes. O contrato de diretórios obrigatório está presente.
- .atena/state/plan.yaml e plan-066-corrida-durvall.yaml mantêm PLAN-066 no B-002/S-005, AWAITING_OWNER_PLAYTEST. Mobile é PLAN_DEVIATION; a minuta não suspende nem substitui Durvall.
- project.godot usa viewport 1280×720, canvas_items e GL Compatibility.
- core/game.gd registra movimento por controle e comandos hero_active, run_interact, run_pause, run_items, run_extract, run_speed e run_reroll.
- ui/run.gd:385–408 lê teclado, controle, movimento por clique mantido e mira manual por mouse/analógico. O perfil de toque precisa evitar conflito com mouse emulado e preservar mira automática.
- ui/ability_slot.gd é um Control visual de 60×60 com recarga e identificação Q/RMB. Precisará de área acionável por toque, sem depender apenas do slot visual.
- ui/hud.gd usa offer_details para detalhes e conecta escolhas diretamente aos botões. Seleção/confirmar será específica do perfil de toque.
- ui/title.gd já reconhece InputEventScreenTouch para o título; ui/hq_screen.gd ainda utiliza teclado e clique para navegação.
- export_presets.cfg oferece Windows Desktop, Windows Playtest Publico e Windows QA Interno. Nenhum preset nativo mobile foi confirmado; não houve inspeção ou instalação de SDK/JDK/templates nem teste em aparelho.
- tools/backlog_check.ps1: P0=0, P1 abertos=4 (BUG-025, BUG-027, BUG-028, BUG-029), P1 implementados aguardando playtest=7, verificações manuais pendentes=8, alertas de organização=0 antes da escrita.
- Numeração conferida no disco: próximos SPEC-134, PLAN-067, EVID-176, MEC-049 e ART-036, utilizados nesta proposta. IDs existentes foram preservados.

## Entrega de planejamento

SPEC-134, PLAN-067 e estado próprio registram três lotes, dez etapas, critérios de aceite, defaults, recuperação e gates. DEV-002 registra a decisão de rota pendente; MEC-049 e ART-036 registram a proposta no backlog. Modo unconfigured e execução não iniciada. Android é recomendação inicial; validação nativa depende de alvo, aparelho, ferramentas e autorizações próprias.

## Verificação documental

Verificação documental concluída: links locais da proposta resolvem; contrato ADD e referências de validação planejada existem; três lotes e dez etapas têm IDs únicos; estado permanece unconfigured, com execution_started=false e DEV-002 aguardando rota/aprovação; PLAN-066 conserva B-002 e AWAITING_OWNER_PLAYTEST. tools/backlog_check.ps1 terminou com zero alertas de organização e os mesmos totais de bugs; git diff --check passou. Nenhum arquivo de gameplay ou canon foi editado.

Conferência dos estados por leitura e assertivas estruturais; parsing YAML por biblioteca não foi realizado porque os runtimes consultados não oferecem o módulo, e nenhuma dependência foi instalada. Testes Godot não são evidência desta entrega de planejamento: gameplay não foi implementado ou executado neste pedido.

## Escolha do nível de aprovação

Em 2026-10-06, após a entrega da proposta e do seletor de nível, o dono respondeu 1, correspondente a per-plan. Modo reconciliado na spec, plano e estado próprio. Essa resposta não informa agora ou fila; rota DEV-002 e autorização para iniciar continuam pendentes. PLAN-066 permanece ativo no checkpoint B-002/S-005. Os registros unconfigured acima descrevem a preparação anterior à escolha.
