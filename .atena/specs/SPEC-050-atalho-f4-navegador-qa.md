# SPEC-050 — Atalho F4 para o Navegador QA

Status: implementado e validado automaticamente (2026-09-27).

## Escopo

- Adicionar `F4` como alternativa ao acorde `Ctrl+O+P` para abrir o Navegador QA.
- Preservar o acorde existente.
- Restringir ambos ao perfil **QA Interno** e manter a proteção contra foco em campo de texto.

## Não objetivos

- Não expor o Navegador QA ao playtest público ou à produção.
- Não alterar cenários, save, controles de jogo ou exportação.

## Critérios de aceite

1. Em QA Interno, `F4` abre/fecha o Navegador QA quando nenhum controle da interface tem foco.
2. `Ctrl+O+P` continua funcional nas mesmas condições.
3. Em playtest público e produção, `F4` não aciona o Navegador QA.
4. A suíte automatizada cobre os dois atalhos.

## Impactos

- `core/playtest.gd`: reconhecimento e guia de teclas QA.
- `tests/test_playtest.gd`: cobertura de `F4`.
- `SPEC-020`: contrato de atalhos atualizado.

## Plano de voo

1. Reconhecer `F4` no predicado de atalho QA, sem remover o acorde anterior.
2. Atualizar o guia e a cobertura automatizada.
3. Executar a suíte de testes, registrar evidência e reconciliar este spec.

## Evidência e reconciliação

- Evidência: `../evidence/EVID-080-atalho-f4-navegador-qa-2026-09-27.md`.
- O acesso permanece limitado pelo perfil QA e pela ausência de foco em controles da interface; o playtest público e a produção não receberam novo acesso.
