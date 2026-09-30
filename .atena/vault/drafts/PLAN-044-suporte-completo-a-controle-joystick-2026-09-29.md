# PLAN-044 — Suporte completo a controle joystick

**Estado:** rascunho para aprovação de intenção e plano de voo  
**Data:** 2026-09-29  
**Método:** Atena Driven Development (ADD)

## Intenção proposta

Permitir jogar *Nottgard Survivors* do início ao fim com um único controle
compatível com Godot (XInput/DirectInput), mantendo teclado e mouse ativos e
sem alterar combate, progressão ou interfaces que não precisem de adaptação.

## Descoberta

- A tela de título já inicia com `InputEventJoypadButton`.
- A habilidade ativa já é a ação `hero_active`, ligada a `RB` além de `Q` e
  botão direito do mouse.
- Movimento ainda lê somente WASD/setas; a mira manual é derivada somente da
  posição do mouse.
- As ações de partida são teclas diretas: pausa, mira, interação, extração,
  inventário, velocidade, escolha e rerrolagem.
- Parte dos diálogos recebe foco de teclado, mas não há contrato explícito de
  foco, confirmação e retorno por controle em todas as telas.
- O perfil já persiste configurações com migração compatível, portanto pode
  hospedar preferências de controle caso sejam necessárias.

## Mapa de controle proposto

| Contexto | Controle |
|---|---|
| Movimento | Analógico esquerdo e direcional digital |
| Mira manual | Analógico direito; sem direção ativa, preserva a última mira válida |
| Habilidade ativa | RB (mantém o vínculo existente) |
| Interagir | X / botão oeste |
| Pausar / voltar / fechar painel | Menu/Start; B / botão sul como retorno quando seguro |
| Alternar mira automática/manual | Y / botão norte |
| Inventário | View/Back |
| Extrair após chefe | botão norte enquanto o prompt de extração estiver ativo |
| Velocidade 2× | direcional para cima, somente onde `T`/`F` já é válido |
| Escolhas, lojas e telas | direcional/analógico esquerdo navega; A / botão leste confirma; B / botão sul volta ou fecha |
| Rerrolar | LB, exclusivamente durante uma oferta que permita rerrolagem |

**Convenção adotada no rascunho:** nomes leste/oeste/norte/sul descrevem a
posição física, para não depender da rotulagem A/B/X/Y de cada plataforma.

## Escopo limitado

1. Criar ações semânticas de entrada para movimento, mira e comandos da run,
   registrando teclado/mouse e joystick juntos, sem duplicar verificações de
   botões físicos nas telas.
2. Ler o analógico esquerdo com zona morta e normalização para movimento em
   espaço de tela, preservando a prioridade atual teclado → mouse; o controle
   entra antes do mouse quando houver movimento no analógico/direcional.
3. Quando a mira estiver em modo manual, ler o analógico direito e atualizar
   `aim_dir`/`aim_pos`; no modo automático, o jogo conserva seu comportamento
   atual e o analógico direito não muda o alvo.
4. Converter pausa, mira, interação, extração, inventário, velocidade,
   escolha e rerrolagem para ações semânticas, respeitando os estados em que
   cada uma já é permitida.
5. Garantir navegação por foco em título, menu, opções, seleção de herói/fase,
   ofertas, altar, loja, equipar/vender, reviver, pausa, inventário, resultado
   e modais de guia. Definir foco inicial e retorno ao abrir/fechar cada modal.
6. Atualizar dicas visíveis e o guia de playtest para mostrar os equivalentes
   do controle sem remover as teclas existentes.
7. Acrescentar testes unitários para mapeamento, zona morta, prioridade de
   dispositivo, comandos por estado e foco de telas; rodar suíte e smoke.
8. Fazer uma validação manual com um controle conectado, registrando a matriz
   de fluxos cobertos em evidência ADD.

## Fora de escopo

- Remapeamento pelo jogador, perfis por controle, vibração, suporte a múltiplos
  jogadores ou telemetria do dispositivo.
- Alterar balanceamento, regras de mira automática, combate ou comportamento
  de teclado/mouse.
- Fazer o mouse desaparecer ou trocar ícones dinamicamente conforme o último
  dispositivo usado.

## Critérios de aceite

1. Com um controle conectado, é possível chegar da tela de título a uma run,
   escolher ofertas e completar/encerrar a tentativa sem teclado ou mouse.
2. Movimento analógico é suave, para na zona morta e não causa deriva.
3. Em mira manual, o analógico direito orienta a mira; em automática, não
   altera a lógica de auto-ataque existente.
4. Cada comando só produz efeito no estado onde seu equivalente atual por
   teclado é permitido; não há escolhas ou ações acidentais em painéis.
5. Toda tela modal abre com foco utilizável e devolve foco a um controle
   previsível ao fechar; A confirma e B volta/fecha quando isso não descarta
   progresso nem executa uma ação irreversível.
6. Teclado e mouse mantêm os comportamentos atuais; a suíte, smoke e a
   verificação manual passam.

## Impactos previstos

- `core/game.gd`: registro central das ações e eventos de joystick.
- `ui/run.gd` e `ui/hud.gd`: leitura das ações e regras por estado.
- `ui/menu.gd`, `ui/title.gd`, cenas `.tscn` e possivelmente
  `tools/build_scenes.gd`: foco e navegação de interface.
- `core/playtest.gd`: texto do guia.
- `tests/`: contratos de entrada e fluxos de UI.
- `.atena/specs/` e `.atena/evidence/`: SPEC aprovada, evidência e
  reconciliação após a execução.

## Plano de voo proposto

1. Confirmar o mapa de controle e as duas decisões de UX abaixo.
2. Criar uma SPEC limitada com o contrato de ações, prioridades e matriz de
   telas; promover a intenção ao cânone somente após aprovação explícita.
3. Implementar o núcleo de ações e cobertura de testes de entrada.
4. Integrar movimento/mira e, em seguida, os comandos da run por estado.
5. Auditar e completar foco/navegação de cada tela e modal.
6. Atualizar textos de ajuda, executar testes e smoke, fazer teste manual com
   controle e registrar evidência/reconciliação.

## Decisões que exigem aprovação

1. Aprovar o mapa proposto, especialmente **analógico direito para mira
   manual** e os botões de contexto para extração, velocidade e rerrolagem.
2. Definir se a primeira entrega inclui **preferências persistidas** de zona
   morta/sensibilidade ou se usa valores internos testados (recomendação:
   valores internos nesta entrega; remapeamento e ajustes ficam para depois).
3. Confirmar se "jogável só no controle" deve abranger também o **bloco de
   notas QA**, que pede digitação. Recomendação: não nesta entrega; o fluxo de
   jogo fica completo, mas a anotação textual continua sendo uma ferramenta de
   playtest com teclado.

## Riscos e verificações

- Diferenças de rótulo e layout entre controles: validar por posição e por
  `JOY_BUTTON_*`, não por texto A/B/X/Y.
- Conflito entre foco de UI e comandos da run: consumir ações ao interagir com
  modais e testar cada estado pausado.
- Deriva de analógicos: manter zona morta explícita e testes de limiar.
- Regressão de mouse/mira: repetir os cenários de `SPEC-072` e os modos Auto e
  Mouse existentes.

## Próximo portão ADD

Este rascunho não altera o cânone nem o código. Após sua aprovação das três
decisões acima, ele será convertido em uma SPEC com plano de voo aprovado para
execução em piloto guardado.
