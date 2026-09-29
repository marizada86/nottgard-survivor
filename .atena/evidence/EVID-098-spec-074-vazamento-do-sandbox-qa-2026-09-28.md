# EVID-098 — Execução da SPEC-074 (vazamento do sandbox QA)

Data: 2026-09-28
SPEC: [[SPEC-074-correcao-do-vazamento-do-sandbox-qa]]
PLAN: [[PLAN-034-pendencias-restantes-2026-09-28]] (item 4)

## Alterações realizadas

- `ui/run.gd`: `hud.menu_pressed` deixou de conectar direto em
  `Game.goto_menu`. Passa a conectar em `_return_to_menu()`, novo método que:
  se `Game.qa_sandbox` estiver ativo, chama `Game.end_qa_sandbox()` e mostra
  o mesmo aviso já usado no overlay do Navegador QA ("Sandbox encerrado;
  save real preservado/ALTERADO — verifique") via `Playtest.toast(...)`;
  depois chama `Game.goto_menu()` normalmente. Para uma run normal
  (`qa_sandbox == false`), o método é um passthrough direto — nenhuma
  mudança de comportamento para o jogador comum.
- `tests/test_qa_sandbox.gd`: novo bloco `_assert_end_qa_sandbox_clears_leak`
  que instancia `GameScript.new()`, força o estado que antes ficava presa
  (`qa_sandbox = true`, `qa_launch` com um cenário antigo, `_save_path`
  apontando para o sandbox) e confirma que `Game.end_qa_sandbox()` — a mesma
  chamada usada por `_return_to_menu()` — zera `qa_sandbox`, limpa
  `qa_launch` e devolve `_save_path` ao save real; também confirma que
  chamar `end_qa_sandbox()` sem sandbox ativo é um no-op que reporta
  "inalterado".

Nenhuma mudança no catálogo de cenários QA, no overlay do Navegador QA
(`_launch_qa_menu()`/`_end_qa()` continuam iguais) nem no formato do save,
manifesto de evidência ou `qa/scenario.json`.

## Verificações executadas

| Comando | Resultado |
|---|---|
| `Godot_v4.7.2-stable_win64.exe --headless --path . -s tests/run_all.gd` | `testes: 0 falha(s)` |
| `Godot_v4.7.2-stable_win64.exe --headless --path . res://tools/smoke.tscn` | `smoke: ok` nas 8 fases |

Suíte e smoke passaram já na primeira execução.

## Exceção de validação

O teste novo cobre a lógica de `Game.end_qa_sandbox()` isoladamente (sem
depender da árvore de cena). Ele não exercita `_return_to_menu()` em si nem
a conexão real do sinal `hud.menu_pressed`, porque isso exige o perfil de
build QA Interno (`Version.qa_enabled()`, que resolve para produção em
execução headless) e uma run real dentro de `ui/run.tscn` — mesma limitação
já registrada para entrada de mouse na SPEC-072. Checagem manual pendente do
dono: abrir uma run pelo Navegador QA, sair pelo botão "voltar ao menu" do
HUD (não pelo botão do overlay), e confirmar que uma run normal jogada em
seguida grava no save real (toast "Sandbox encerrado" aparece; painel de
itens/moedas reflete a run normal ao voltar ao Quartel).
