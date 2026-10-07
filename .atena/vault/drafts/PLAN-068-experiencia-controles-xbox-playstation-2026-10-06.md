---
id: PLAN-068
title: Experiência com controles Xbox e PlayStation
created: 2026-10-06
status: LOCAL_VALIDATED_HARDWARE_PENDING
approved: 2026-10-06
origin: guided-add
implementation_preceded_spec: false
request_classification: PLAN_DEVIATION
approval_mode: per-plan
execution_order: AFTER_PLAN_067_MOBILE
spec: "../../specs/SPEC-135-experiencia-controles-xbox-playstation-2026-10-06.md"
state: "../../state/plan-068-controles-xbox-playstation.yaml"
evidence: "../../evidence/EVID-177-planejamento-controles-xbox-playstation-2026-10-06.md"
---

# Plano de voo: controles Xbox e PlayStation

Entrega: jornada confortável com controle no Windows, mapa sem colisões, ícones por família/binding, navegação completa e preferências de entrada. A [SPEC-135](../../specs/SPEC-135-experiencia-controles-xbox-playstation-2026-10-06.md) define escopo, mapa, fontes, critérios, defaults e gates.

Rota autorizada pelo dono em 2026-10-06: planejar agora; implementar depois do mobile. PLAN-067 permanece ativo e seu retorno a Durvall é preservado. DEV-003 já aguarda o fim do mobile; este plano não ganha prioridade sobre os compromissos anteriores sem decisão do dono.

## Aprovação

Modo aprovado: **per-plan**, em 2026-10-06. O dono respondeu “aprovado, por plano” ao escopo apresentado, incluindo a revisão de INPUT-CONTROL-001, e acrescentou: dentro dos detalhes, abas com R1/L1 no PlayStation e RB/LB no Xbox. Essa correção é IN_PLAN; não amplia o escopo nem reinicia aprovação. L1/LB seleciona a aba anterior, R1/RB a próxima, com ícones correspondentes e prioridade sobre rerrolagem/habilidade enquanto o painel estiver aberto. [Referência do dono](../../evidence/PLAN-068-referencia-abas-detalhes-2026-10-06.png).

- per-plan: uma aprovação cobre os quatro lotes locais, respeitando ativação após mobile e gates independentes.
- per-batch: checkpoint antes de B-001, B-002, B-003 e B-004; resultados concretos do lote anterior subsidiam o próximo.
- per-step: checkpoint antes de cada S-001 a S-012; nenhuma etapa pendente é atravessada.

A aprovação não antecipa a execução: a fila permanece pós-mobile. Hardware indisponível mantém aceite físico pendente. A revisão canônica descrita no escopo está autorizada para reconciliação após implementação validada; arquitetura material fora do escopo, dependências/permissões e Git/publicação mantêm aprovação independente.

## Lotes e etapas estáveis

| Lote | Etapa | Trabalho e entrega | Validação / saída |
|---|---|---|---|
| B-001 — Funções e ergonomia | S-001 | Reinspecionar estado após mobile; inventariar ações/telas/dispositivos e preservar baseline por arquivo. Resolver fila antes de ativar. | Matriz de contextos, conflitos e recuperação; revisão local identificada. |
| B-001 | S-002 | Implementar Padrão/Legado e exclusividade contextual; retirar velocidade do direcional e extração de Y/△; garantir entrada única nos modais. | Eventos reais: sem dupla confirmação, compras acidentais ou comando de movimento alterando velocidade. |
| B-001 | S-003 | Controle ativo, limpeza de entrada, desconexão/foco e ajuste de zona morta sem mudar gameplay. | Repouso, reconexão, dois dispositivos, pausa e dez habilidades respeitam contexto/recarga. |
| B-002 — Ícones e instruções | S-004 | Criar catálogo vetorial local Xbox/DS4/DualSense/Genérico, formas/legendas e tabela de prompts baseada em ação/binding. | Catálogo e exemplos em 24/32 px, sem confusão X/× e sem dependência de cor. |
| B-002 | S-005 | Integrar família automática/override e atualização pelo método intencional; prompts no HUD, slot, interação e ofertas. | Remapeamento/preset atualizam prompts; drift/mouse emulado não trocam família. |
| B-002 | S-006 | Atualizar pausa, ficha, menu, HQ, resultado e guia; capturar telas nos dois tamanhos. | Capturas sem cortes, rótulos correspondentes e comandos contextuais. |
| B-003 — Jornada e ajustes | S-007 | Completar foco, abas, grids, listas, sliders e HQ; nos detalhes L1/LB anterior e R1/RB próxima, ícones por família e consumo pela camada superior; foco inicial/de retorno e repetição somente de navegação. | Quatro abas da referência navegáveis; trocar aba não rerrola oferta nem ativa habilidade; matriz sem armadilha de foco ou vazamento ao combate. |
| B-003 | S-008 | Completar fluxos econômicos e de run: detalhes, rerrolar, reviver, extração/abandono/recusa com confirmação. | Jornada completa e cenários raros; uma ação de consequência por pressionamento. |
| B-003 | S-009 | Preferências locais de preset, família, dispositivo e zona morta; remapeamento de botões limitado, Cancelar/Restaurar. | Persistência/reinício e perfil antigo; rejeição de conflitos, atualização de prompts e recuperação sempre acessível. |
| B-004 — Validação e reconciliação | S-010 | Executar testes, smoke e regressão de teclado/mouse/mobile em perfil descartável. | Godot instalado; resultados por critério e limitações preexistentes separadas. |
| B-004 | S-011 | Playtest físico por modelo/USB/Bluetooth disponível: título a resultado, 10 min de combate, pausa, compras e reconexão. | Evidência com modelo, transporte, revisão/build, conforto e falhas; sem hardware, AWAITING_HARDWARE_PLAYTEST. |
| B-004 | S-012 | Reconciliar evidências, backlog, estado, canon autorizado e cobertura real; devolver checkpoint de retorno acordado. | Critérios locais/físicos separados; pendências por modelo visíveis; nenhum aceite ou commit fabricado. |

Não estimar duração em dias antes de terminar mobile e conhecer a matriz de hardware. Ordem técnica: B-001 → B-002 → B-003 → B-004. Mudanças que excedam escopo geram análise de impacto e checkpoint próprio.

## Evidência, recuperação e retorno

Saída de execução proposta: .atena/generated/controller-experience/v01/, com recovery/, captures/ e reports/. Nenhum artefato de runtime foi criado nesta fase. Produzir evidência por lote e ligar aos doze critérios da SPEC-135. Rever bugs abertos no início, antes de exportar e antes de eventual commit autorizado.

Preservar alterações mobile/Durvall e recuperar apenas arquivos/deltas do lote, nunca toda a árvore. PLAN-067 não é suspenso agora. Antes de ativar, ler plan.yaml novamente; registrar plano anterior, checkpoint, decisão de fila e retorno. Se houver mudanças materiais desde a proposta, atualizar impacto e solicitar aprovação da revisão. Permanecem adiados vibração, eixos/gatilhos remapeáveis e validação física Web/mobile.

## Ativação e entrega local — 2026-10-06

O dono pediu “vamos lá” após a entrega local mobile em 503ccec, autorizando iniciar o plano já aprovado por plano. As declarações acima sobre planejamento e fila descrevem a preparação anterior. O checkpoint nativo mobile foi suspenso com retorno persistido; Durvall e DEV-003 preservados. Entrega local P068-v01 validada; aceite físico Xbox/DS4/DualSense pendente. [EVID-184](../../evidence/EVID-184-controles-xbox-playstation-local-2026-10-06.md).
