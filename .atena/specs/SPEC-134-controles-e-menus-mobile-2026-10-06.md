---
id: SPEC-134
title: Controles e menus por toque para mobile
created: 2026-10-06
status: LOCAL_IMPLEMENTED_AWAITING_DEVICE_VALIDATION
approved: 2026-10-06
approval_basis: 'Dono escolheu 1 e confirmou sim, mobile agora.'
origin: guided-add
implementation_preceded_spec: false
request_classification: PLAN_DEVIATION
approval_mode: per-plan
approval_mode_selected: 2026-10-06
plan: "../vault/drafts/PLAN-067-controles-e-menus-mobile-2026-10-06.md"
evidence: "../evidence/EVID-176-planejamento-mobile-2026-10-06.md"
---

# Controles e menus por toque para mobile

Tornar Nottgard Survivors jogável por toque, do título ao resultado de uma tentativa, em tela horizontal. O joystick flutuante serve exclusivamente para andar. A mira é automática no perfil de toque; habilidade ativa e interação usam botões independentes. A entrega preserva teclado, mouse e controle físico.

## Origem e evidência

O dono pediu recomendações para mobile, esclareceu que o joystick seria somente para andar e solicitou um plano em 2026-10-06. O esclarecimento define o escopo desta proposta; não é aprovação de execução.

O [contrato de controle físico](../vault/canon/INPUT-CONTROL-001-joystick-2026-09-29.md) já prevê movimento analógico, habilidade, interação, pausa, inventário e comandos contextuais. As [opções existentes](../vault/canon/MENU-OPTIONS-001-accessibilidade-audio-video-2026-09-29.md) organizam preferências do Quartel. Ambos continuam como referências; a extensão para toque depende da aprovação deste plano antes de eventual reconciliação canônica.

A inspeção local constatou: viewport 1280×720 com canvas_items; movimento por teclado, controle e clique mantido em ui/run.gd; habilidade hero_active ligada a Q/RMB/RB em core/game.gd; slot visual de 60×60 com recarga em ui/ability_slot.gd; detalhes de ofertas ligados a offer_details em ui/hud.gd; avanço de HQ por teclado e mouse em ui/hq_screen.gd. export_presets.cfg contém apenas três presets Windows. Ver [evidência de planejamento](../evidence/EVID-176-planejamento-mobile-2026-10-06.md).

## Escopo e comportamento

| Elemento | Comportamento proposto |
|---|---|
| Joystick flutuante | Surge no ponto de toque na área livre de combate, à esquerda ou à direita, fora de botões e painéis. A origem fica fixa durante esse toque. Arrastar define somente deslocamento; soltar ou cancelar zera o vetor. Pequena zona morta e alcance limitado evitam tremor. Ajuste IN_PLAN solicitado e autorizado pelo dono após o piloto em 2026-10-06. |
| Movimento | Reutiliza a regra de deslocamento atual e a conversão isométrica. Diagonais não ficam mais rápidas. O mesmo dedo mantém o comando mesmo ao atravessar a borda visual do joystick. |
| Mira | Automática durante controle por toque. Joystick de movimento não aponta armas nem habilidades. Preserva comportamento desktop/controle e não sobrescreve a preferência salva do jogador. |
| Habilidade | Botão grande inferior direito, com ícone, estado pronto e recarga atuais. Um toque dispara uma vez se disponível, usando a direção escolhida pelo sistema de mira automática. Manter o dedo não repete a ativação. |
| Interação | Botão independente ao lado da habilidade, visível quando houver alvo válido. Rótulo contextual como Comprar, Conversar ou Ativar; reaproveita elegibilidade e prioridade dos alvos existentes. |
| Pausa e inventário | Botões no topo, com área de toque confortável. Inventário e telas de decisão pausam o combate conforme suas regras; abrir ou fechar uma tela exige novo toque para voltar a andar. |
| Extração e abandono | Comandos disponíveis nos estados válidos atuais, com confirmação explícita para evitar encerramento acidental. Cancelar restaura a tela anterior sem executar a ação. |
| Ofertas | No perfil de toque, tocar uma carta seleciona e mostra os detalhes; Confirmar aplica uma única escolha. Rerrolagem, recusa, equipar/vender e compras mantêm custos, opções e consequências existentes. |
| Outros comandos | Velocidade contextual, reviver/recusar, ajuda, seleção de herói/fase, opções, HQs, resultado e repetir tentativa recebem caminhos por toque. Não oferecer alternância de mira manual no perfil inicial de toque. |
| Listas e informações | Arrastar rola sem selecionar ou comprar ao soltar. Botão Informações abre detalhes sem hover ou Shift; Voltar/Fechar fica acessível em painéis e HQs. |

O joystick controla somente seu dedo proprietário. Outros dedos acionam habilidade e interação sem roubar ou reposicionar a origem. Toques que começam sobre interfaces pertencem à interface. Abrir um modal, pausar, perder foco, ir para segundo plano, trocar de cena ou receber cancelamento limpa os comandos de combate; ao retornar o jogo permanece pausado quando aplicável.

O perfil de toque impede que eventos de mouse emulados provoquem andar até o cursor, mira manual ou dupla ativação. A compatibilidade dos menus com mouse emulado pode ser mantida, desde que o combate distinga a origem da entrada. Usar identificação dos dedos e recursos nativos de Godot, sem novo plugin.

## Layout e acessibilidade

Tela horizontal, joystick flutuante na área livre inferior de qualquer lado, habilidade/interação inferiores à direita e pausa/inventário no topo. O ajuste pedido pelo dono elimina a restrição lateral; não cria segundo joystick nem desloca os botões. Reservar margens para recortes, câmera e navegação do sistema. Ancorar controles à área utilizável, sem esticar o mundo ou o herói para preencher proporções diferentes.

Default para o piloto: joystick com raio de 72 pixels lógicos e zona morta de 15% desse raio; botão de habilidade de 88×88 na referência 1280×720. São parâmetros iniciais de ergonomia, ajustáveis no lote B-001. Dimensionar a área efetiva de toque para pelo menos 48 dp equivalentes no aparelho escolhido; a escala do canvas precisa ser considerada, portanto 48 pixels do projeto não comprovam esse aceite. Texto legível, separação entre botões e estado de recarga distinguível também sem depender somente de cor.

Avaliar layouts 16:9, 20:9 e 4:3 em horizontal, com recortes simulados. Prioridade de legibilidade: PV, XP, objetivo e habilidade. Informações secundárias podem ter versão compacta no perfil de toque, preservando acesso completo pela ficha.

## Não objetivos

Novas habilidades, segundo joystick, mira manual por gesto, modo vertical, rebalanceamento, mudança de velocidade base, novos assets gerados, redesign artístico geral, instalação de SDK/JDK/templates/plugins, permissões Android, credenciais, distribuição em lojas, publicação, deploy, commits, merge ou push. iOS fica adiado para um plano de exportação e validação próprio. Defeitos de arte dos heróis permanecem nos planos e bugs atuais.

## Impactos e recuperação

Risco alto por introduzir outra forma de jogar, principalmente disputa de dedos, mouse emulado, modais e confirmações de compra. Alterações previstas: camada local de entrada por toque, ui/run.gd, ui/hud.gd, ui/ability_slot.gd, menus, ficha, ofertas e HQs quando necessário. project.godot pode receber apenas ajustes de entrada/layout aprovados, preservando parâmetros de combate. Identificar arquivos adicionais na etapa S-001 antes de editá-los; mudanças materiais de arquitetura exigem aprovação específica.

Usar configuração separada de entrada para toque com override local de teste no PC; não modificar saves reais nem migrar o perfil para implementar o piloto. Recuperação por lote: preservar estado anterior dos arquivos tocados e evidência, desligar a camada de toque e verificar teclado/mouse/controle. Não usar reset ou descarte global da árvore; há trabalho de Durvall em andamento.

## Critérios de aceite

1. Joystick aparece apenas no combate e na região livre definida; controla somente andar em todas as direções. Soltar/cancelar elimina deslocamento até o próximo ciclo de física, sem alterar a velocidade ou aumentar velocidade diagonal.
2. Andar com um dedo e usar habilidade/interação com outro funciona; nenhum dedo troca a origem do joystick. Habilidade respeita recarga e dispara no máximo uma vez por toque.
3. Toques nos botões, cartas e listas não movimentam o herói; arrastar uma lista não confirma uma escolha. Toque não altera a mira automática nem gera comando duplicado por mouse emulado.
4. Pausa, inventário, decisão, perda de foco e mudança de cena limpam entradas. Fechar modal não reaproveita o toque antigo para andar ou ativar habilidade.
5. É possível iniciar uma tentativa, interagir, comprar/equipar/vender, escolher melhoria/bênção, rerrolar quando permitido, consultar ficha, assistir/fechar HQ, reviver/recusar, extrair/abandonar com confirmação e navegar no resultado usando somente toque. Cobrir estados raros com cenários locais além da tentativa completa.
6. Texto e comandos ficam legíveis e acessíveis em 16:9, 20:9 e 4:3 horizontais; botões não sobrepõem recortes ou navegação do sistema. Aceite de conforto depende do playtest no aparelho.
7. Teclado, mouse e controle físico passam nas verificações de regressão; comportamento desktop das ofertas e preferência de mira são preservados.
8. Testes de entrada cobrem isolamento dos dedos, soltura/cancelamento, mouse emulado, transições de modal e escolha única. Suíte completa e smoke local passam com Godot em D:/Godot/godot.exe.
9. Aceite mobile final: tentativa completa e cenário carregado de pelo menos 10 minutos no aparelho acordado, com build ID, modelo, SO, resolução, FPS e tempos de quadro registrados. Alvo inicial proposto: ao menos 95% dos quadros em até 33,3 ms durante combate, sem congelamento observável de entrada, crashes ou perda de progresso. Registrar aquecimento e consumo quando mensuráveis. Resultado abaixo do alvo exige proposta própria de otimização, sem alteração silenciosa de gameplay.

## Gaps e checkpoints

| Gap | Classe | Resolução |
|---|---|---|
| Aprovação para executar e posição em relação a Durvall | Resolvida | Dono escolheu per-plan e confirmou sim, mobile agora em 2026-10-06. PLAN-066 suspenso no checkpoint B-002/S-005 com retorno preservado. |
| Plataforma inicial | RESOLVABLE | Recomendar Android para o primeiro piloto nativo. A implementação local de toque é independente da exportação; confirmar alvo antes do teste nativo. |
| Aparelho e ferramentas para exportação | DEFERRED com bloqueio do checkpoint nativo | Identificar em S-008. Sem aparelho ou toolchain suficiente, entregar evidência local e marcar AWAITING_DEVICE_VALIDATION; não declarar jogabilidade mobile validada. |
| Dimensões e sensibilidade | RESOLVABLE | Defaults acima, ajuste de ergonomia com evidência em B-001/B-003 sem mudar velocidade de gameplay. |
| Orientação das habilidades na mira automática | RESOLVABLE | Verificar todos os dez heróis em S-001/S-004; corrigir encaminhamento de entrada, preservando regras das habilidades. Se exigir redesenho de habilidade, abrir decisão específica. |
| Exportação, instalação e permissões | Gate independente | Antes do artefato nativo: mostrar preset, destino, identificador e permissões propostas e obter aprovação explícita. Instalação de ferramentas, instalação no aparelho e envio externo também requerem autorização. |

BLOCKING técnicos para o plano local: nenhum. A aprovação do plano local não autoriza as operações externas, dependências ou checkpoint nativo sem suas condições. Simulação no PC é evidência de entrada/layout, não substitui multitouch, desempenho e conforto em celular.

## Plano de voo e validação

Executar os lotes e etapas do [PLAN-067](../vault/drafts/PLAN-067-controles-e-menus-mobile-2026-10-06.md), com checkpoint registrado no [estado proposto](../state/plan-067-controles-e-menus-mobile.yaml). Usar perfil descartável e saída em .atena/generated/mobile-controls/v01/ durante a execução. Registrar evidência por lote, resultados por critério, capturas de layouts, limitações e aprovação do dono. Aplicar testes de comportamento, não testes que apenas repitam a estrutura do código.

Referência técnica: [TouchScreenButton](https://docs.godotengine.org/en/stable/classes/class_touchscreenbutton.html) suporta botões simultâneos; [InputEventScreenTouch](https://docs.godotengine.org/en/stable/classes/class_inputeventscreentouch.html) identifica cada dedo. Menus continuam com controles de interface adequados à navegação e rolagem.

## Reconciliação

Correção solicitada pelo dono após o piloto, IN_PLAN: joystick na arena livre dos dois lados, mantendo movimento exclusivo e prioridade da interface. Piloto P067-v02; 144 verificações funcionais de botões/controles sem falhas. [EVID-183](../evidence/EVID-183-mobile-joystick-direita-e-botoes-2026-10-06.md) registra reprodução, encaminhamento/duplicação, suíte e smoke. Aceite em aparelho continua pendente.

2026-10-06: B-001/B-002 implementados e verificados localmente; suíte e integração zero falhas, smoke nove fases e capturas 16:9/20:9/4:3. [EVID-180](../evidence/EVID-180-mobile-combate-local-2026-10-06.md), [EVID-181](../evidence/EVID-181-mobile-menus-local-2026-10-06.md) e [EVID-182](../evidence/EVID-182-mobile-checkpoint-nativo-2026-10-06.md) distinguem aceite local e critérios ainda pendentes. B-003 aguarda aparelho e gates nativos; o plano não está concluído. Nenhum APK, instalação, canon ou commit foi realizado. Durvall continua suspenso com retorno preservado.

Na preparação: registrar proposta, solicitação pendente DEV-002 e backlog, preservando PLAN-066 ativo e suas aprovações. Na aprovação para fazer agora: persistir suspensão recuperável de PLAN-066 no B-002/S-005, com launcher e evidência atuais; ativar PLAN-067 no modo/checkpoint escolhido. Se ficar na fila, manter DEV-002 pendente e o plano atual.

Ao encerrar execução: reconciliar MEC-049 e ART-036 com resultados reais, estado por lote e critérios aceitos; registrar pendências nativas, gates de exportação e retorno ao plano anterior. Eventual canon de controles mobile só será escrito com aprovação explícita. Nunca registrar implementação, aceite visual ou teste em aparelho antes de ocorrerem.
