# INPUT-CONTROL-001 — Controle joystick

**Aprovado pelo dono:** 2026-09-29  
**Origem:** `[[PLAN-044-suporte-completo-a-controle-joystick-2026-09-29]]`

**Revisão aprovada pelo dono:** 2026-10-06, PLAN-068 / SPEC-135, por plano.
Entrega local validada em [EVID-184](../../evidence/EVID-184-controles-xbox-playstation-local-2026-10-06.md); aceite físico por modelo/transporte pendente.

Nottgard Survivors deve ser jogável do título ao resultado da tentativa com um
único controle compatível com Godot, sem retirar teclado ou mouse.

- Movimento: analógico esquerdo e direcional digital.
- Mira manual: analógico direito; mira automática preserva seu comportamento.
- Habilidade ativa: RB/R1; interagir: X/□; menu/pausa: Menu/Options; ficha:
  View/Share/Create; alternar mira: Y/△. A habilidade permanece específica do herói.
- Padrão: A/× confirma e B/○ volta ou fecha somente quando seguro.
  Legado: B/○ confirma e A/× volta, com as mesmas proteções de contexto.
- Extração elegível e velocidade são opções da pausa. Extração e abandono
  exigem confirmação. Direcional não altera velocidade; Y/△ não extrai.
- Rerrolagem: LB/L1 somente na oferta elegível. RS/R3 alterna detalhes.
- Abas da ficha/detalhes e Quartel: LB/L1 anterior, RB/R1 próxima.
  Dentro dos detalhes estes comandos são fixos e têm prioridade sobre
  rerrolagem e habilidade, inclusive sobre uma oferta de fundo. Consumir o
  evento e exigir nova pressão ao voltar; manter quatro categorias e contador.

Os prompts seguem método intencional de entrada, preset e binding efetivo;
incluem ícones Xbox, DS4, DualSense ou fallback genérico. A escolha visual
manual não altera funções. Hardware apresentado por emulação como XInput
não permite afirmar seu modelo físico; oferecer override.

Zona morta inicial 0,24, ajustável entre 0,10 e 0,40 separadamente para movimento
e mira, sem alterar velocidade máxima. Preferências opcionais persistidas no
perfil local. Remapeamento limitado a habilidade, interação, mira, ficha,
rerrolagem e detalhes; rejeitar conflitos simultâneos e preservar confirmar,
voltar, pausa e botões do sistema. Movimento/eixos continuam fixos.

Usar um controle ativo por sessão; outro dispositivo não soma vetores nem
confirma escolhas. Desconexão/perda de foco limpa entrada e pausa. Reconectar
não retoma automaticamente: selecionar e continuar explicitamente. Garantir
foco visível, rolagem e retorno; pressão mantida não atravessa telas ou modais.

A primeira entrega de 2026-09-29 usava leste confirma, norte extrai e direcional
para cima altera velocidade; a revisão aprovada substitui essas convenções.
Não inclui vibração, multiplayer, remapeamento de eixos/gatilhos, exportação
para consoles nem digitação do bloco de notas QA. Aceite físico Xbox, DS4 e
DualSense deve ser registrado individualmente; testes sintetizados não o substituem.
