# EVID-045 — Dagruve, Docas e Navegador de Cenários QA

Data: 2026-09-27  
Especificação: `SPEC-036-dagruve-docas-e-cenarios-qa.md`

## Resultado

- Dagruve e Docas são fases distintas e sequenciais: `dagruve -> docas -> shedaklah`.
- Dagruve dura 480 s e mantém o Sacerdote da Mente Derretida como chefe.
- Docas dura 600 s e usa o Guardião Alado Verdadeiro como chefe, com fases em
  70% e 35%.
- O save que já contém Dagruve em `cleared` recebe Docas desbloqueada de modo
  idempotente.
- Eventos declarados em `data/stage_events.json` emitem aviso e resultado pela
  simulação, com telegráfo visual consumido por `ui/run.gd`.
- O Navegador QA da build de desenvolvimento recebe nível, arma extra, item,
  passiva, seed e evento. O cenário de evento inicia cinco segundos antes do
  gatilho; o cenário de entrada de chefe também usa essa antecedência.

## Verificação

1. `Godot_v4.7.2-stable_win64.exe --headless --path . -s tests/run_all.gd`
   concluiu com `testes: 0 falha(s)`.
2. `Godot_v4.7.2-stable_win64.exe --headless --path . res://tools/smoke.tscn`
   carregou Dagruve, Docas e as fases restantes; terminou com `smoke: ok`.
3. Os testes cobrem a rota de portais, as regras de cada fase, o Guardião como
   chefe, migração do save, aplicação da build QA e o aviso pré-evento.

## Exceções

O motor em modo headless informou que não conseguiu abrir o log em `user://`
e ler o repositório de certificados do Windows. Nenhum dos avisos afetou os
testes ou o smoke. A confirmação visual manual das apresentações e dos sinais
ambientais permanece adequada para a próxima sessão de playtest com viewport.

## Reconciliação

`SPEC-007` e `SPEC-034` permanecem como histórico. A separação das fases e a
alocação de chefes são regidas pelo cânone na seção 20 de `PLAN-001` e pela
`SPEC-036`.
