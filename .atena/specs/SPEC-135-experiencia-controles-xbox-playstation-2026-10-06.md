---
id: SPEC-135
title: Experiência com controles Xbox e PlayStation
created: 2026-10-06
status: LOCAL_VALIDATED_HARDWARE_PENDING
approved: 2026-10-06
approval_basis: 'Dono: abas de detalhes com R1/L1 e RB/LB, imagem de referencia; aprovado, por plano.'
origin: guided-add
implementation_preceded_spec: false
request_classification: PLAN_DEVIATION
approval_mode: per-plan
execution_order: AFTER_PLAN_067_MOBILE
deferred_request: DEV-004
plan: "../vault/drafts/PLAN-068-experiencia-controles-xbox-playstation-2026-10-06.md"
state: "../state/plan-068-controles-xbox-playstation.yaml"
evidence: "../evidence/EVID-177-planejamento-controles-xbox-playstation-2026-10-06.md"
---

# Experiência com controles Xbox e PlayStation

## Intenção e escopo

Tornar a jornada do título ao resultado confortável e compreensível usando um controle Xbox, DualShock 4 ou DualSense no Windows: ações consistentes, ícones corretos, foco visível, navegação completa, ajustes locais e recuperação de desconexão. Preservar teclado, mouse, controles mobile e regras de combate. O pedido é de planejamento, não de implementação.

O dono escolheu em 2026-10-06: planejar agora e deixar a execução para depois do mobile. PLAN-067 permanece ativo; o retorno a Durvall e DEV-003 continuam registrados. A posição entre as solicitações posteriores ao mobile não foi decidida. Ao terminar mobile, resolver a fila com o dono antes de ativar este plano.

Referências locais: [contrato de controle aprovado](../vault/canon/INPUT-CONTROL-001-joystick-2026-09-29.md), [opções do Quartel](../vault/canon/MENU-OPTIONS-001-accessibilidade-audio-video-2026-09-29.md), [SPEC-096](SPEC-096-suporte-completo-a-controle-joystick.md), [EVID-120](../evidence/EVID-120-suporte-controle-joystick-2026-09-29.md) e [plano mobile](SPEC-134-controles-e-menus-mobile-2026-10-06.md). A automação anterior não comprova validação com hardware físico.

## Referências pesquisadas e adaptação

| Referência | Evidência verificável | Aplicação proposta em Nottgard |
|---|---|---|
| Vampire Survivors | A [página do desenvolvedor poncle](https://poncle.itch.io/vampire-survivors) descreve jogabilidade minimalista e suporte a controle. A [apresentação da equipe na GDC 2023](https://media.gdcvault.com/gdc2023/Slides/SurvivingVampireSurvivors_Molloy_Beth.pdf), localizada na pesquisa, lista controles simples; não foi feita análise completa do PDF. | Priorizar movimento e escolhas; conservar ataques automáticos existentes e oferecer uma jornada com mira automática sem exigir analógico direito. Essa aplicação é recomendação de design. |
| Death Must Die | [Realm Archive, respostas de junho de 2023](https://steamcommunity.com/app/2334730/discussions/0/5264192561414473032/?l=english), documenta opções de ataque alternável, mira automática e remapeamento. [Resposta do desenvolvedor de novembro de 2023](https://steamcommunity.com/app/2334730/discussions/0/3954784199576545356/?ctp=2) descreve ataque direcionado pelo analógico direito e alternativa nas opções. São registros históricos, não prova do layout atual. | Conservar mira manual pelo analógico direito como escolha explícita; facilitar consulta de detalhes e ajustes. Não importar o ataque manual, a penalidade de movimento nem criar dash universal. |

Não foi verificado um diagrama oficial atual dos botões dos dois jogos. O mapa abaixo é uma proposta própria para as ações existentes de Nottgard. A convenção sul confirma/leste volta é recomendada neste plano, sem atribuí-la como mapa comprovado de ambos os jogos.

## Mapa proposto — preset Padrão

| Função/contexto | Xbox | PlayStation | Regra |
|---|---|---|---|
| Andar | Analógico esquerdo ou direcional | Analógico esquerdo ou direcional | Intensidade progressiva; mesma velocidade máxima e transformação isométrica atuais; sem aceleração diagonal. |
| Navegar telas | Analógico esquerdo ou direcional | Analógico esquerdo ou direcional | Foco visível, ordem previsível e rolagem para manter seleção em tela. |
| Confirmar / avançar HQ | A | × (cruz) | Somente a ação selecionada; confirmação de oferta requer novo pressionamento após abrir. |
| Voltar / fechar | B | ○ (círculo) | Fecha somente telas seguras; nunca abandona, vende ou recusa recompensa por consequência implícita. |
| Interagir no combate | X | □ (quadrado) | Texto contextual, alvo elegível e prioridade atuais. |
| Alternar mira automática/manual | Y | △ (triângulo) | Não extrai. Preserva preferência salva; nova preferência segue o default atual. |
| Mira manual | Analógico direito | Analógico direito | Apenas no modo manual; repouso conserva última direção válida. Não altera movimento. |
| Habilidade ativa do herói | RB | R1 | Uma ativação por pressionamento, recarga e orientação conforme regras atuais. |
| Rerrolar oferta | LB | L1 | Apenas quando permitido; custo/estoque visíveis e seleção restaurada após rerrolagem. |
| Detalhes/comparação | Clique do analógico direito (RS) | R3 | Alternância para ler sem manter botão pressionado; sem dependência de hover. |
| Pausa | Menu/Start | Options | Pausa, retoma ou fecha a camada adequada; não atravessa um modal. |
| Ficha/inventário | View/Back | Share (DS4) / Create (DualSense) | Usar botão central equivalente a Back reconhecido pelo Godot; ícone depende do modelo detectado. Ficha também acessível pela pausa. |
| Trocar abas do Quartel/ficha e painel de detalhes | LB anterior / RB próxima | L1 anterior / R1 próxima | A camada de detalhes tem prioridade, inclusive quando aberta sobre uma oferta; não rerrola nem ativa habilidade. |
| Velocidade e extração | Opções na pausa | Opções na pausa | Velocidade sai do direcional; extração aparece só em estado elegível e exige confirmação. |

LT/L2, RT/R2 e clique do analógico esquerdo ficam sem função no preset inicial. Botão Xbox/PS pertence ao sistema; não capturar. Touchpad do PlayStation não é requisito: eventual atalho exige verificação do driver e ícone correspondente, ficando adiado. Habilidade ativa permanece específica do herói, mesmo quando envolve deslocamento.

Preset Legado conserva B/○ confirma e A/× volta para quem já aprendeu a convenção aprovada; inclui as mesmas proteções de contexto, desconexão e confirmação segura. As colisões direcional/velocidade e mira/extração são corrigidas em ambos os presets. Preferência explícita persistida não é substituída por detecção de hardware; informar a nova convenção ao selecionar Padrão pela primeira vez.

## Ícones e comunicação

Criar pequenos assets vetoriais locais ou desenhos nativos de UI, com tabela semântica de ações para botões. Não usar imagens dos jogos de referência. Xbox: A/B/X/Y, LB/RB, LS/RS, Menu/View; PlayStation: ×/○/□/△, L1/R1, L3/R3, Options, Share/Create; incluir analógicos e direcional, com indicação da operação de clique quando aplicável.

Os prompts vêm da ação e do binding efetivo, incluindo preset e remapeamento. Ícone sempre acompanhado de função curta (ex.: “R1 Habilidade”, “□ Comprar”). Evitar confusão entre X do Xbox e × do PlayStation; usar forma, legenda e contraste, sem depender somente de cor. Default 24 px lógicos, versão 32 px no guia, alinhados ao tema; validar em 1280×720 e 1920×1080, janela e tela cheia.

Atualizar HUD, slot de habilidade hoje rotulado Q/RMB, interação, ofertas, rerrolagem, ficha, pausa, HQ, menu, resultado e guia. Mostrar somente comandos válidos naquele contexto, com motivo da indisponibilidade quando útil. No perfil de toque, continuar mostrando comandos por toque; a integração pós-mobile deve definir o último método intencional de entrada sem sobrescrever preferências de mira.

Detectar família por nome/GUID/informações disponíveis no Godot. Oferecer escolha visual Automático/Xbox/PlayStation DS4/PlayStation DualSense/Genérico, independente do preset funcional. Quando emulação apresentar PlayStation como Xbox, não prometer identificar o hardware real: override visual resolve a ambiguidade. Dispositivo desconhecido usa botões por posição e legenda legível.

Trocar prompts apenas com entrada intencional: eixo fora da zona morta e atividade real de teclado/mouse. Ruído de analógico e mouse emulado não alternam ícones nem roubam foco. Escolher controle ativo por ação intencional, sem presumir índice zero. Durante a run, mudança de controle passa pela pausa/seleção explícita; o segundo controle não soma vetores nem aciona compras.

## Navegação, segurança e ajustes

Todo painel recebe foco inicial útil, exclui controles invisíveis/desabilitados, mantém seleção visível e devolve foco ao elemento anterior ao fechar. Revisar título, herói/fase, opções, ficha em abas, ajuda, HQs, lojas/ferreiro/curandeiro, loot, melhorias/bênçãos, altar/doação/aposta, reviver e resultado. Nas HQs, A/× avança, B/○ fecha quando permitido; nenhum deles ativa a tela que reaparece.

**Ajuste aprovado pelo dono em 2026-10-06 — abas dentro dos detalhes:** L1 no PlayStation e LB no Xbox selecionam a aba anterior; R1 e RB selecionam a próxima. Aplicar às categorias mostradas na [referência enviada pelo dono](../evidence/PLAN-068-referencia-abas-detalhes-2026-10-06.png): Armas e feitiços, Equipamento, Passivas e bênçãos, Sinergias e bônus. Exibir o ícone correto junto à indicação anterior/próxima e manter destaque/contador da aba atual. Um pressionamento troca uma aba; preservar a regra existente nos limites. Os comandos de aba são fixos nesse contexto, independentemente do remapeamento de combate. Enquanto detalhes estiver aberto, consumir L1/LB e R1/RB nessa camada, impedindo rerrolagem na oferta de fundo e habilidade no combate. Fechar detalhes devolve foco e exige novo pressionamento para acionar a tela anterior. Os atalhos de teclado existentes continuam seguindo seu perfil de entrada.

O mesmo pressionamento não atravessa telas: consumir evento pela camada superior e exigir soltura antes de aceitar em modal recém-aberto. Repetição de navegação: atraso inicial proposto 0,35 s e intervalo 0,12 s, apenas para mover foco/lista. Confirmar, habilidade, compras e rerrolagem não repetem por manutenção do botão. Ao abrir um painel de compra, foco inicial permite inspecionar sem executar; vendas, recusa de loot, abandono e extração exigem confirmação conforme consequência e regra existente.

Ao desconectar o controle ativo ou perder foco, limpar entradas e pausar a run. Reconexão não retoma automaticamente, não muda bindings e exige retomada explícita. Se outro controle continuar conectado, ele não assume a sessão silenciosamente. Teclado/mouse podem recuperar a pausa.

Adicionar seção Controles nas opções existentes, sem redesign global: preset Padrão/Legado, família visual, controle ativo, zona morta separada para movimento e mira, e remapeamento dos botões de combate/ofertas (habilidade, interação, alternar mira, rerrolagem, detalhes e ficha). Movimento/eixos continuam fixos neste piloto; confirmar/voltar seguem o preset; pausa permanece como caminho de recuperação. Bloquear conflitos simultâneos e permitir reutilização em contextos mutuamente exclusivos. Captura exige novo pressionamento, tem Cancelar e Restaurar padrões e nunca aceita botão do sistema. Após remapear, atualizar ajuda e ícones imediatamente.

Zona morta inicial conserva 0,24; ajuste proposto 0,10–0,40 em passos de 0,01. Oferecer leitura visual de repouso para calibrar, sem mudar velocidade máxima. Preferências são campos opcionais compatíveis com saves existentes, testados em perfil descartável; não migrar ou regravar saves reais durante validação. Sensibilidade angular/curva personalizada fica adiada: a mira atual é direcional, e um controle genérico de “sensibilidade” sem efeito claro seria enganoso.

## Não objetivos

Novas armas ou dash, mudanças de habilidades, balanceamento, velocidade base, multiplayer, suporte a consoles/exportação Xbox ou PlayStation, Steam Input SDK, DS4Windows, drivers/plugins/dependências novas, remapeamento de eixos/gatilhos, controles adaptativos especializados, vibração/haptics/gatilhos adaptativos, publicação, commits, merge ou push. Web/mobile com controle físico será extensão com matriz própria; preservar regressão mobile aprovada, sem declarar compatibilidade de hardware em plataformas não testadas. Lore e fontes externas do vault permanecem somente leitura.

## Impactos e recuperação

Risco alto de regressão de contexto/foco e médio de reconhecimento de dispositivos. Áreas previstas: core/game.gd e preferências locais; ui/run.gd, ui/hud.gd, ui/ability_slot.gd, ui/menu.gd, ui/title.gd, ui/hq_screen.gd, ficha/painéis e core/playtest.gd; assets de UI e testes pertinentes. Revalidar arquivos após mobile e registrar inventário real em S-001. Helpers pequenos para prompts/controle ativo podem ser locais; refatoração material da arquitetura é gate separado.

Antes de cada lote, preservar somente arquivos a tocar e sua revisão/hash em .atena/generated/controller-experience/v01/recovery/. A árvore já contém mudanças mobile e Durvall: não usar reset, checkout global nem apagar trabalho alheio. Recuperar apenas o delta do lote, conferir divergências e pedir decisão se houver edições concorrentes. Antes de executar, repetir inspeção mobile para integrar mudanças recém-concluídas.

O canon hoje determina leste confirma/sul volta, direcional para cima altera velocidade e norte alterna mira/extrai. O dono aprovou o escopo por plano em 2026-10-06, em resposta ao pedido explícito de aprovação incluindo essa revisão canônica, e acrescentou o ajuste de abas nos detalhes. A autorização cobre a revisão descrita e sua reconciliação após implementação validada; nenhum canon é alterado nesta preparação. Demais regras de combate e de opções permanecem.

## Critérios de aceite

1. Jornada completa somente com controle, do título ao resultado e nova tentativa; cenários raros cobertos separadamente. Nenhuma tela de jogo exige mouse, hover ou tecla. Digitação do bloco de notas QA continua fora do aceite.
2. Padrão e Legado respeitam confirmar/voltar em todas as telas; manter confirmar ao abrir oferta/modal não compra nem aceita duas vezes. Cancelar confirmação não gera efeito econômico.
3. Direcional move/navega sem mudar velocidade; Y/△ só alterna mira; extração é ação explícita na pausa, visível apenas quando elegível e confirmada antes de executar.
4. Movimento não deriva dentro da zona morta e mantém norma limitada; analógico direito só controla mira manual; habilidade dispara uma vez por pressionamento e respeita recarga para os dez heróis.
5. Prompts correspondem ao controle/preset/binding efetivo em todos os contextos; cada função visível tem ícone ou fallback textual. Nenhum prompt Q/RMB permanece isolado quando controle é método ativo.
6. Xbox, DS4 e DualSense têm legendas próprias, override funciona sob emulação e genérico não inventa identificação. Entrada em repouso por 60 s não muda família visual, seleção ou movimentação.
7. Abas, grades, listas, sliders, rolagem, ajuda e HQ têm foco visível e caminho de retorno; zero armadilhas de foco na matriz de telas. Nos detalhes, L1/LB seleciona a aba anterior e R1/RB a próxima, com ícones por família, destaque e contador atualizados. Testar as quatro categorias, inclusive detalhes aberto sobre oferta: nenhuma troca de aba rerrola, ativa habilidade ou atravessa o painel ao fechar. Repetição de navegação funciona sem repetir ações de consequência.
8. Desconectar/reconectar durante movimento, habilidade, oferta e pausa limpa comandos e mantém pausa até retomada; segundo controle não soma movimento nem confirma escolhas. Perda de foco não recebe comandos.
9. Ajustes persistem após reiniciar em perfil descartável; defaults funcionam sem novos campos; remapeamento rejeita conflitos e atualiza prompts; Cancelar/Restaurar não bloqueiam recuperação.
10. Suíte completa, smoke das nove fases e regressão de teclado/mouse/mobile passam no Godot instalado. Comparar com linha de base pós-mobile; registrar falhas preexistentes sem rotulá-las como novas nem ocultá-las.
11. Capturas de HUD, oferta, ficha, pausa e opções comprovam legibilidade e ausência de cortes nos dois tamanhos. Ícones distinguíveis por forma/legenda sem cor.
12. Aceite físico: ao menos uma tentativa completa e 10 minutos de combate por família Xbox e PlayStation, mais matriz USB/Bluetooth conforme equipamentos disponíveis. Registrar modelo, SO, transporte, identificação percebida pelo Godot, preset, build/revisão local e resultados. DS4 e DualSense ficam individualmente pendentes até testados; emulação, testes sintéticos e um único modelo não comprovam os demais.

## Gaps, defaults e gates

| Gap | Classe | Tratamento |
|---|---|---|
| Rota em relação ao mobile | RESOLVIDO | Preparar agora; execução depois de PLAN-067, sem suspender mobile. |
| Ordem entre Durvall, DEV-003 e este plano após mobile | DEFERRED; bloqueia ativação | Preservar compromissos existentes e pedir priorização no checkpoint de retorno. |
| Aprovação e nível | RESOLVIDO | Dono aprovou por plano em 2026-10-06, incluindo o ajuste de abas dos detalhes e o escopo apresentado com revisão canônica. A execução continua após mobile e decisão de fila. |
| Convenção e mapa inicial | RESOLVABLE | Padrão recomendado acima, Legado disponível; extração/velocidade na pausa, sem colisões. |
| Origem dos ícones | RESOLVABLE | Desenhos vetoriais locais/nativos; sem download de packs ou dependência externa. |
| Reconhecimento de família sob emulação | RESOLVABLE | Override visual independente da função e fallback genérico; não prometer identificação infalível. |
| Modelos/transporte disponíveis | DEFERRED; bloqueia aceite físico correspondente | Levantar em S-011; sem hardware, estado AWAITING_HARDWARE_PLAYTEST com cobertura por modelo visível. |
| Layout exato atual das referências | DEFERRED | Não copiar bindings não verificados. Fontes históricas e princípios bastam ao plano próprio; diagrama comparativo literal seria pesquisa adicional. |
| Vibração, gatilhos e eixos remapeáveis | DEFERRED | Próximo plano após comprovação de ergonomia básica. |

BLOCKING técnicos para o escopo local aprovado: nenhum. Ativação após mobile e hardware são checkpoints explicitamente pendentes, não fatos consumados. Dependências, permissões, arquitetura material, publicação e Git mantêm gates independentes.

## Plano de voo e validação

Executar quatro lotes e doze etapas do [PLAN-068](../vault/drafts/PLAN-068-experiencia-controles-xbox-playstation-2026-10-06.md). Ferramentas previstas: D:/Godot/godot.exe, tests/run_all.gd, tools/smoke.tscn e tools/backlog_check.ps1. Criar testes que verifiquem consequências reais de eventos, transição entre telas, dupla confirmação, isolamento de dispositivo e remapeamento; ampliar test_input_controls.gd e testes de UI/perfil pertinentes. Alterar expectativas da convenção antiga somente após aprovação explícita.

Referência técnica: [Godot — controles e zonas mortas](https://docs.godotengine.org/en/stable/tutorials/inputs/controllers_gamepads_joysticks.html) e [Input — identificação e conexões](https://docs.godotengine.org/en/stable/classes/class_input.html). Usar APIs disponíveis na instalação local; documentação stable pode evoluir.

## Evidência e reconciliação

Preparação registra SPEC-135/PLAN-068/EVID-177, estado não executável, DEV-004 e MEC-050/ART-037. Ao aprovar, registrar mensagem exata, nível e checkpoint, mantendo a fila pós-mobile. Ao ativar, recuperar estado central atualizado e resolver ordem/retorno; não substituir plano em execução implicitamente.

Por lote, registrar resultados, capturas e cobertura de critérios. Ao concluir, reconciliar backlog e estado com limitações reais e, com autorização expressa para a revisão, atualizar INPUT-CONTROL-001 e fatos das opções, sem apagar histórico de SPEC-096/EVID-120. Aceite local e físico ficam separados. Commits locais continuam dependentes de autorização e separação das trilhas; não criar commit na fase de planejamento.

## Ativação e entrega local — 2026-10-06

O dono pediu “vamos lá” após a entrega local mobile em 503ccec, autorizando iniciar o plano já aprovado por plano. As declarações acima sobre planejamento e fila descrevem a preparação anterior. O checkpoint nativo mobile foi suspenso com retorno persistido; Durvall e DEV-003 preservados. Entrega local P068-v01 validada; aceite físico Xbox/DS4/DualSense pendente. [EVID-184](../evidence/EVID-184-controles-xbox-playstation-local-2026-10-06.md).

## Correção dentro do plano — 2026-10-06

Relato do dono no Quartel classificado IN_PLAN: botão Jogar fixo e revalidação da entrada na tentativa. Entrega P068-v02; [EVID-185](../evidence/EVID-185-quartel-botao-jogar-2026-10-06.md). Aceite físico e retornos preservados.
