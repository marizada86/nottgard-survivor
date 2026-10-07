---
id: EVID-177
title: Planejamento da experiência com controles Xbox e PlayStation
created: 2026-10-06
kind: planning
origin: guided-add
implementation_preceded_spec: false
spec: "../specs/SPEC-135-experiencia-controles-xbox-playstation-2026-10-06.md"
plan: "../vault/drafts/PLAN-068-experiencia-controles-xbox-playstation-2026-10-06.md"
state: "../state/plan-068-controles-xbox-playstation.yaml"
---

# Preparação do plano de controles físicos

O dono pediu a Atena para estruturar plano de otimização da experiência Xbox/PlayStation, incluindo ícones e funções e referências Vampire Survivors/Death Must Die. Ao classificar como PLAN_DEVIATION, escolheu: “Planejar agora e deixar a execução para depois do mobile (recomendado)”. Essa resposta autoriza registro e fila, não implementação nem alteração canônica.

## Constatações locais

- ADD 0.2 em .atena/add.yaml; diretórios obrigatórios presentes. RTK já tem decisão enabled, dispensando nova configuração. Nenhuma instalação/configuração global foi feita.
- Na inspeção inicial, PLAN-067/SPEC-134 estava ativo, aprovado per-plan, checkpoint B-001/S-001. Durante a validação documental, o trabalho compartilhado avançou para B-003/S-008-S-009, AWAITING_DEVICE_VALIDATION. Esse avanço externo foi preservado; não foi executado por este planejamento. Retorno a PLAN-066/Durvall e DEV-003 pós-mobile preservados. Não foi atribuída prioridade relativa para as pendências posteriores.
- INPUT-CONTROL-001, SPEC-096 e EVID-120 registram suporte inicial e validação física pendente. O canon atual aprova leste confirma/sul volta; mudar isso requer autorização explícita.
- core/game.gd:71–119 registra RB habilidade, X interação, Y alternar mira e extração, direcional para cima tanto movimento como run_speed, B ui_accept e A ui_cancel. São conflitos/risco de ergonomia identificados por inspeção, não bugs reproduzidos nesta fase.
- core/game.gd:43 e 156–168 usa zona morta 0,24 e vetor progressivo; preservar velocidade e tratamento isométrico na otimização.
- ui/run.gd:268 em diante roteia comandos pelo estado; extração tem prioridade sobre mira após conclusão da fase. Mudança proposta separa as funções e exige confirmação da extração pela pausa.
- ui/hud.gd contém slot com texto Q/RMB e foco inicial em ofertas/pausa/revive/resultado. core/playtest.gd descreve a convenção antiga em dois guias. Prompts dinâmicos não foram parte da SPEC-096.
- ui/hq_screen.gd:64 em diante trata teclado/mouse; navegação por controle precisa ser incluída e reinspecionada após mobile, que já está editando essa área.
- A árvore tem mudanças locais mobile/Durvall em código e documentos. Este pedido não autoriza descarte, reset, restauração global ou commit dessas alterações.
- tools/backlog_check.ps1 executado com seu conteúdo e raiz tools explicitamente resolvida, sem mudar política de execução: P0=0; P1 abertos=4 (BUG-025/027/028/029); P1 implementados aguardando playtest=7; verificações manuais=8; alertas de organização=0. Tentativas anteriores de execução encontraram restrição de script/contexto PSScriptRoot vazio; seus resumos inválidos foram descartados. O resumo acima é da execução bem-sucedida com raiz correta.
- Numeração livre conferida: SPEC-135, PLAN-068, EVID-177, MEC-050 e ART-037. DEV-004 não existia no estado central.

## Pesquisa externa pública

Consultas enviaram apenas nomes dos jogos e termos de controles; nenhum código, save, canon ou contexto sensível do projeto foi enviado. Fontes consultadas em 2026-10-06:

- [poncle — Vampire Survivors](https://poncle.itch.io/vampire-survivors): descrição oficial de jogabilidade minimalista e suporte a controle. Página da demo antiga, não manual das versões atuais.
- [Realm Archive — opções de mira/ataque e remapeamento](https://steamcommunity.com/app/2334730/discussions/0/5264192561414473032/?l=english): respostas do desenvolvedor em junho de 2023. Diferenciar fala do desenvolvedor de sugestões de jogadores.
- [Realm Archive — Gamepad Aim+Attack](https://steamcommunity.com/app/2334730/discussions/0/3954784199576545356/?ctp=2): resposta do desenvolvedor em novembro de 2023 descrevendo analógico direito e opção de ataque; referência histórica.
- [Godot — controles](https://docs.godotengine.org/en/stable/tutorials/inputs/controllers_gamepads_joysticks.html) e [Input](https://docs.godotengine.org/en/stable/classes/class_input.html): identificação, zonas mortas, diferenças de entrada e foco. Confirmar APIs da instalação durante execução.

Não foi feito playtest dos jogos de referência nem confirmado diagrama oficial atual. Não apresentar o mapa proposto de Nottgard como reprodução exata desses jogos. Fontes comunitárias encontradas na pesquisa não sustentam bindings do plano.

## Resultado de planejamento

SPEC-135, PLAN-068 e estado próprio preparados com quatro lotes/doze etapas, mapa Padrão/Legado, catálogo de ícones local, navegação, remapeamento limitado, dispositivo ativo, zona morta, recuperação e doze critérios de aceite. DEV-004 e backlog registram fila após mobile; modo unconfigured e execução não iniciada. Canon e código do jogo não foram modificados por esta preparação.

Hardware é checkpoint posterior: Xbox/DS4/DualSense continuam NOT_TESTED; USB/Bluetooth devem ser registrados por modelo, sem transformar teste sintético em aceite físico. Vibração, gatilhos adaptativos, eixos remapeáveis e validação física Web/mobile permanecem adiados.

## Validação desta entrega

Verificação documental concluída em 2026-10-06: contrato ADD presente, links locais dos quatro registros resolvidos, IDs sem colisão, quatro lotes/doze etapas consistentes, modo unconfigured e execution_started=false. PLAN-067 permanece ativo no checkpoint atualizado B-003/S-008-S-009; retorno a Durvall e DEV-003 preservados. Relatório reproduzível em [validação documental](PLAN-068-validacao-documental-2026-10-06.json). A checagem cobre estrutura/campos e referências; não usa parser YAML completo.

Backlog após o registro: zero alertas de organização; permanecem quatro P1 abertos, sete implementados aguardando playtest e oito verificações manuais. git diff --check passou. A numeração compartilhada avançou posteriormente para EVID-183 após as evidências mobile EVID-180/181/182; esse avanço foi preservado. Não houve implementação, teste Godot ou playtest físico nesta preparação. Testes e smoke estão planejados para B-004.

## Aprovação e ajuste do dono — 2026-10-06

O dono escreveu: “atena dentro de detalhes a mudança de abas deve acontecer com R1/L1 para PlayStation e RB/LB para xbox. (imagem de referencia) aprovado, por plano.” Classificação do esclarecimento/aprovação: IN_PLAN no PLAN-068; a origem do plano continua PLAN_DEVIATION em relação ao mobile ativo.

Registrado per-plan para todo o escopo local apresentado, incluindo a revisão canônica descrita na pergunta de aprovação anterior. Execução permanece adiada após mobile, sem troca do plano ativo. Canon será reconciliado após implementação validada; não foi alterado neste registro.

Imagem inspecionada e preservada como [referência de abas](PLAN-068-referencia-abas-detalhes-2026-10-06.png). Ela mostra Armas e feitiços, Equipamento, Passivas e bênçãos, Sinergias e bônus, com Q/LB à esquerda e E/RB à direita. É evidência visual, não instrução independente: a solicitação textual do dono define L1/LB anterior e R1/RB próxima. SPEC, S-007, critérios de aceite, estado e backlog foram atualizados. A camada de detalhes consome os botões, sem rerrolar oferta de fundo ou ativar habilidade; ícones seguem a família do controle.

Validação documental após aprovação: relatório atualizado confere per-plan, fila pós-mobile, doze etapas, referência visual e mapa das abas. Nenhuma execução ou validação física foi atribuída a essa aprovação.

Execução posterior autorizada por “vamos lá”, após entrega local mobile: [EVID-184](EVID-184-controles-xbox-playstation-local-2026-10-06.md). Este registro e sua prova de planejamento permanecem históricos; o validador agora encaminha o estado em execução à prova da entrega, sem regravar o relatório anterior. Aceite físico permanece pendente.
