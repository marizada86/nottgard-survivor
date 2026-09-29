---
id: "SPEC-074"
title: "Correção do vazamento do sandbox QA (rótulo qa.cenario desatualizado)"
status: "executada — suíte e smoke verdes; checagem manual interativa do dono pendente"
created: "2026-09-28"
relations:
  - "[[PLAN-034-pendencias-restantes-2026-09-28]]"
  - "[[EVID-088-qa-leoric-dagruve-2026-09-27]]"
  - "[[SPEC-020-ferramentas-playtest-e-qa]]"
---

# SPEC-074 — Correção do vazamento do sandbox QA

## Origem

Item 4 do [[PLAN-034-pendencias-restantes-2026-09-28]]: o campo `qa.cenario`
do manifesto de evidência ficava desatualizado depois que o playtester
navegava pelo Navegador QA e continuava jogando normalmente
([[EVID-088-qa-leoric-dagruve-2026-09-27]]). O dono já havia decidido
"corrigir" na entrevista de alinhamento; a discovery abaixo mostra que o
problema é maior do que o rótulo.

## Discovery

- `Game.qa_sandbox` e `Game.qa_launch` só são limpos por uma ação explícita:
  `Playtest._end_qa()` ([`core/playtest.gd:366`](../../core/playtest.gd)),
  que chama `Game.end_qa_sandbox()`.
- Existem apenas 3 chamadas de `Game.goto_menu()` no projeto. Duas já vêm
  acompanhadas de `begin_qa_sandbox`/`end_qa_sandbox` dentro do próprio
  overlay do Navegador QA (`_launch_qa_menu()` e `_end_qa()`). A terceira é o
  botão "voltar ao menu" do HUD, usado durante pausa e nas telas de
  derrota/vitória (`hud.menu_pressed.connect(Game.goto_menu)`,
  [`ui/run.gd:45`](../../ui/run.gd)) — essa **não** encerra o sandbox.
- Enquanto `qa_sandbox` permanece `true`, `begin_qa_sandbox()` já redirecionou
  `_save_path` para `user://qa-sandbox/<sessão>/profile.json` e `profile`
  para uma cópia em memória (`core/game.gd:169-190`). `Game.start_run()` (o
  "Jogar" normal do menu) não toca em `qa_sandbox` nem `qa_launch`
  (`core/game.gd:250`).
- Consequência: sair de um cenário QA pelo botão do HUD (em vez do botão
  "encerrar sandbox" do próprio Navegador QA) deixa `qa_sandbox` preso em
  `true`. Uma run normal jogada em seguida pelo menu herda seed/preparação do
  `qa_launch` antigo (`ui/run.gd:35,53-54,89`) e tem seu resultado salvo no
  `profile.json` do sandbox, não no save real — sem aviso nenhum ao
  jogador/playtester. O rótulo `qa.cenario` errado registrado em
  `Playtest.context()` ([`core/playtest.gd:518`](../../core/playtest.gd)) é
  sintoma desse estado, não a causa isolada.
- Isso já era o comportamento pretendido por [[SPEC-020-ferramentas-playtest-e-qa]]
  ("sair do cenário descarta a sessão sandbox, salvo o rascunho de
  evidência") — só nunca foi implementado para a saída via HUD, apenas para a
  saída explícita pelo overlay.
- Escopo confirmado com o dono: o fix ataca o vazamento do sandbox (não só o
  rótulo), mas mantém a ordem já combinada no PLAN-034 — não pula a frente do
  questionário de playtest, por afetar somente o build QA interno.

## Escopo

1. Em `ui/run.gd`, o callback conectado a `hud.menu_pressed` deixa de chamar
   `Game.goto_menu` diretamente. Passa a chamar um pequeno wrapper que:
   - se `Game.qa_sandbox` estiver ativo, chama `Game.end_qa_sandbox()` e
     mostra o mesmo aviso já usado em `_end_qa()` ("sandbox encerrado; save
     real preservado/ALTERADO — verifique");
   - em seguida chama `Game.goto_menu()` normalmente.
2. Quando `Game.qa_sandbox` já é `false` (run normal), o wrapper é um
   passthrough direto para `Game.goto_menu()` — nenhuma mudança de
   comportamento para o jogador comum.
3. Como consequência, `Playtest.context()` deixa de anexar o bloco `qa` (ou
   anexa refletindo o estado real, vazio) em qualquer nota tirada depois do
   retorno ao menu, porque `Game.qa_sandbox` não fica mais preso em `true`.

## Não objetivos

- Não altera o catálogo de cenários QA, o Navegador QA, nem os fluxos
  `_launch_qa_menu()`/`_end_qa()` do overlay — ambos continuam existindo e
  funcionando como hoje; o fix cobre só o caminho de saída que faltava.
- Não adiciona nenhum aviso ou mecânica nova visível para o jogador fora do
  perfil QA Interno (`Version.qa_enabled()` já restringe essas mecânicas).
- Não muda o formato do save, do manifesto de evidência ou do `qa/scenario.json`
  exportado no ZIP — só corrige quando `Game.qa_sandbox`/`qa_launch` são
  encerrados.

## Critérios de aceite

1. Sair de uma run lançada pelo Navegador QA (`Game.start_qa_run`) pelo botão
   "voltar ao menu" do HUD encerra o sandbox: `Game.qa_sandbox == false`,
   `Game.qa_launch` vazio, `_save_path` volta a `SAVE_PATH` após o retorno ao
   menu.
2. Uma run normal iniciada pelo menu ("Jogar") logo depois usa seed
   aleatória de verdade (não herda `qa_launch` antigo), não recebe
   `battle.qa_prepare(...)` nem `set_grounding_guide(...)`, e `Game.save()`
   grava no save real — o hash do save real muda de acordo com o resultado
   dessa run.
3. Uma nota tirada nessa run normal não inclui mais um `qa.cenario`
   desatualizado no manifesto de evidência.
4. Sair pelo botão "encerrar sandbox" do próprio Navegador QA
   (`_end_qa()`) continua funcionando exatamente como hoje, sem toast
   duplicado.
5. O fluxo `_launch_qa_menu()` (abrir o Quartel dentro do sandbox QA, cenário
   `qa.menu.<aba>`) continua intacto — não é afetado por essa mudança, pois
   não passa pelo caminho do HUD.
6. Suíte (`tests/run_all.gd`) e smoke (`tools/smoke.tscn`) continuam verdes;
   um teste novo cobre "sair via HUD encerra o sandbox" chamando o mesmo
   wrapper usado pela conexão do sinal, sem depender de clique real de UI.

## Plano de voo proposto

1. Extrair o wrapper descrito no Escopo em `ui/run.gd` e conectar
   `hud.menu_pressed` a ele em vez de `Game.goto_menu` diretamente.
2. Estender `tests/test_qa_sandbox.gd` (ou criar caso novo) simulando
   `Game.start_qa_run(...)` seguido da chamada do wrapper, checando
   `Game.qa_sandbox == false` e `Game.qa_launch.is_empty()` depois.
3. Rodar suíte e smoke.
4. Registrar evidência com o hash do save real antes/depois de: (a) uma run
   QA encerrada pelo HUD, (b) uma run normal jogada em seguida — provando que
   a run normal grava no arquivo certo e não no sandbox.

## Limites

- Execução só começa após aprovação explícita desta spec pelo dono.
- O restante do PLAN-034 (questionário de playtest) segue a ordem já
  combinada — esta spec não pula a fila.

## Reconciliação

- O dono aprovou esta SPEC em 2026-09-28.
- Executada em 2026-09-28: `ui/run.gd` agora encerra o sandbox QA ao sair
  pelo botão "voltar ao menu" do HUD, igual à saída explícita pelo overlay
  do Navegador QA. Evidência completa em
  [[EVID-098-spec-074-vazamento-do-sandbox-qa-2026-09-28]].
- `tests/run_all.gd`: `testes: 0 falha(s)` (bloco novo cobrindo
  `Game.end_qa_sandbox()` limpando `qa_sandbox`/`qa_launch`/`_save_path`).
  Smoke (`tools/smoke.tscn`): `ok` nas 8 fases.
- Exceção: sem checagem manual interativa do caminho real (build QA Interno,
  Navegador QA, botão do HUD) nesta sessão — ver EVID-098.
