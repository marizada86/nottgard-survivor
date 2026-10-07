---
id: EVID-186
title: Confirmar mapa direciona para Jogar
created: 2026-10-06
kind: owner-feedback-correction
origin: guided-add
implementation_preceded_spec: false
spec: "../specs/SPEC-135-experiencia-controles-xbox-playstation-2026-10-06.md"
state: "../state/plan-068-controles-xbox-playstation.yaml"
---

# P068-v03 — confirmação da fase

Pedido do dono: “Atena ao apertar A/X no mapa, automaticamente ser direcionado para jogar resolve o problema”. Classificação **IN_PLAN**, ajuste de S-007/S-010 aprovado pelo pedido e pelo nível per-plan existente. O checkpoint B-004/S-011 e retornos mobile/Durvall continuam preservados.

Com a lista de fases em foco, **A no Xbox / × no PlayStation** direciona o foco para **JOGAR**. A confirmação atual é consumida; o botão mantido fica bloqueado até ser solto. Uma nova confirmação inicia a tentativa. O preset Legado respeita B/○. Uma fase bloqueada mantém o foco na lista e não inicia a tentativa. A rota por direcional, clique e toque emulado permanece disponível.

[38 verificações por eventos sintetizados](../generated/controller-experience/v03/menu-start-report.json), zero falhas: Xbox, PS4 e PS5 por override visual, Legado, primeira confirmação muda foco sem iniciar, comando mantido/repetido não inicia, segunda confirmação inicia, fase bloqueada não encaminha, seis dimensões, clique, toque emulado e preservação do perfil real. [Log](../generated/controller-experience/v03/menu-start.log). [Suíte completa](../generated/controller-experience/v03/suite.log): zero falhas. Regressão anterior de 90 controles e 144 mobile registrada em [EVID-185](EVID-185-quartel-botao-jogar-2026-10-06.md); esses números não são novas execuções deste ajuste. Layout visual do rodapé não mudou.

Logs conservam avisos de encerramento: acesso, 2 objetos e 1 recurso; suíte, 3 RIDs, 30 objetos e 5 recursos. Testes sintéticos não representam aceite físico. Xbox do dono aguarda reteste; DualShock 4 e DualSense físicos não testados.

Durante a reconciliação/validação, outra tarefa autorizada ativou **PLAN-070 / FILA-025** no estado central e preservou `suspension.ficha_c_return` para PLAN-068/B-004/S-011. A leitura inicial desta correção ainda mostrava PLAN-068 ativo. PLAN-070 foi preservado; esta entrega apenas registra o ajuste já executado e valida o checkpoint próprio do controle e seu retorno. O plano de controles não foi reativado por esta correção.

[Abrir piloto P068-v03](../generated/controller-experience/v03/Abrir-teste-Xbox.cmd), [guia](../generated/controller-experience/v03/Como-testar-Xbox.md), [manifesto](../generated/controller-experience/v03/pilot-manifest.json), [validação](../generated/controller-experience/v03/delivery-validation.json). Preferências/progresso do perfil piloto v01 preservados. [Recuperação](../generated/controller-experience/v03/recovery/). Nenhum commit, exportação ou publicação.
