---
id: PLAN-067
title: Adaptação mobile com joystick exclusivo para andar
created: 2026-10-06
status: LOCAL_IMPLEMENTED_AWAITING_DEVICE_VALIDATION
approved: 2026-10-06
approval_basis: 'Dono escolheu 1 e confirmou sim, mobile agora.'
origin: guided-add
implementation_preceded_spec: false
request_classification: PLAN_DEVIATION
approval_mode: per-plan
approval_mode_selected: 2026-10-06
spec: "../../specs/SPEC-134-controles-e-menus-mobile-2026-10-06.md"
state: "../../state/plan-067-controles-e-menus-mobile.yaml"
---

# Adaptação mobile com joystick exclusivo para andar

Preparar uma versão jogável por toque em horizontal: joystick flutuante na área livre de qualquer lado somente para andar, mira automática, habilidade e interação à direita, pausa e inventário no topo. Menus terão seleção por toque, detalhes acessíveis e rolagem por arrasto. A [SPEC-134](../../specs/SPEC-134-controles-e-menus-mobile-2026-10-06.md) define comportamento, aceite, impactos e limites.

## Plano de voo

| Lote | Etapas estáveis | Entrega e checkpoint |
|---|---|---|
| B-001 Controles de combate | S-001 Mapear entradas, estados, mira dos dez heróis e linha de base desktop. S-002 Implementar joystick exclusivo para andar e propriedade dos dedos. S-003 Integrar habilidade, interação, pausa, inventário e extração com confirmação. S-004 Validar simultaneidade, limpeza de entradas e regressão. | Piloto local de combate com recarga, mira automática e teste por toque. Registrar evidência antes de avançar. |
| B-002 Menus por toque | S-005 Adaptar título, Quartel, opções, ajuda, seleção, HQs e resultado. S-006 Adaptar ficha, ofertas e estados de decisão com detalhes, seleção e confirmação no perfil de toque. S-007 Ajustar áreas de toque, rolagem, proporções e margens; validar fluxo local completo. | Fluxo do título ao resultado acessível por toque, com capturas dos três formatos. Registrar evidência e pendências antes de avançar. |
| B-003 Validação em celular | S-008 Identificar aparelho/OS e ferramentas disponíveis, executar suíte/smoke e preparar proposta concreta de exportação. S-009 Após autorização independente, gerar/instalar piloto local no alvo e realizar tentativa completa, casos raros e cenário carregado de 10 minutos. S-010 Comparar critérios, corrigir defeitos do escopo e reconciliar entrega e retomada. | Aceite no aparelho ou estado AWAITING_DEVICE_VALIDATION explícito. Simulação no PC não fecha o lote nativo. |

## Recomendações de aprovação

O dono escolheu **por plano** em 2026-10-06 ao responder 1 e aprovou a execução com "sim, mobile agora". O plano está aprovado para as etapas locais; gates independentes permanecem. Durvall foi suspenso no checkpoint B-002/S-005 com retorno preservado.

- **Por plano:** uma aprovação cobre as dez etapas locais do escopo; gates de exportação, instalação, dependências, permissões, canon e ações Git continuam independentes.
- **Por lote:** aprovar B-001 inicialmente; pausar antes de B-002 e B-003.
- **Por etapa:** aprovar S-001 inicialmente; pausar antes de cada S-XXX seguinte.

Selecionar modo não autoriza execução por si só: a resposta deve aprovar o escopo/checkpoint e dizer se o trabalho entra agora ou fica na fila.

## Relação com o plano ativo

O pedido foi PLAN_DEVIATION em relação a PLAN-066, que aguardava avaliação de Durvall em B-002/S-005. Após aprovação "sim, mobile agora", DEV-002 entrou em execução e PLAN-066 foi suspenso nesse checkpoint com retorno preservado. PLAN-067 é o plano ativo.

Recomendo executar mobile como trabalho separado e retornar a Durvall depois. Se aprovado para agora, suspender PLAN-066 de forma recuperável antes da primeira etapa, preservando [estado de Durvall](../../state/plan-066-corrida-durvall.yaml), [EVID-175](../../evidence/EVID-175-durvall-piloto-articulado-2026-10-06.md) e launcher atual. Se adiado, deixar DEV-002 pendente sem consumir aprovação de Durvall. PLAN-053 e DEV-001 continuam com seus estados anteriores.

## Validação e limites

Usar D:/Godot/godot.exe, perfil de teste descartável, tests/run_all.gd e tools/smoke.tscn. Acrescentar testes relevantes de entrada e estados, reaproveitando test_input_controls.gd, test_ability_hud.gd e test_options_menu.gd. Guardar capturas e resultados por lote; ausência de aparelho deixa aceite nativo pendente.

Alvo inicial recomendado: Android, a confirmar no checkpoint S-008. Exportação e instalação precisam de proposta e aprovação específicas; SDK, JDK, templates e permissões não estão autorizados por esta minuta. iOS, segundo joystick, mira manual por gesto e otimização que altere arquitetura ou gameplay ficam para propostas futuras.

## Recuperação e conclusão

Preservar os arquivos anteriores de cada lote e o trabalho já existente. Em falha, desligar a camada de toque e verificar o fluxo desktop sem descarte global da árvore. Limite de três tentativas para a mesma falha antes de reavaliar a solução.

Concluir somente após comparar todos os critérios com evidência real; diferenciar controles locais implementados de versão validada em celular. Atualizar backlog, estado e pendências; registrar a retomada aprovada de Durvall. Nenhum commit, merge, push ou publicação faz parte desta autorização de planejamento.

## Estado após execução local — 2026-10-06

B-001 e B-002 implementados: [combate](../../evidence/EVID-180-mobile-combate-local-2026-10-06.md) e [menus/layout](../../evidence/EVID-181-mobile-menus-local-2026-10-06.md). Suíte e integração zero falhas; smoke nove fases. Piloto local P067-v01 usa perfil separado, com launcher em generated/mobile-controls/v01. O teste não altera o save real.

B-003 parcial: S-008 tem inspeção e proposta prontas, mas aparelho/SO ainda não informados. Java/SDK inspecionados incompletos; [checkpoint Android](PLAN-067-checkpoint-android-2026-10-06.md) preparado para autorização independente. S-009 não executado; S-010 reconciliado apenas localmente. [EVID-182](../../evidence/EVID-182-mobile-checkpoint-nativo-2026-10-06.md) registra critérios 5–7/9 com pendências humanas/nativas. Estado AWAITING_DEVICE_VALIDATION, sem conclusão fictícia nem retorno prematuro a Durvall.


Atualização IN_PLAN após o piloto: joystick também à direita e teste dos botões solicitados pelo dono. Piloto P067-v02; 144 verificações sem falhas, suíte zero e smoke nove fases. [EVID-183](../../evidence/EVID-183-mobile-joystick-direita-e-botoes-2026-10-06.md). Gates e aceite em aparelho continuam pendentes.
