---
id: "EVID-087"
title: "Save resiliente e ajuda de regras"
date: "2026-09-27"
relations:
  - "[[SPEC-057-save-resiliente-e-ajuda-de-regras]]"
  - "[[PLAN-028-save-resiliente-e-ajuda-de-regras-2026-09-27]]"
---

# EVID-087 — Save resiliente e ajuda de regras

## Resultado

O perfil agora é serializado em temporário e validado antes de substituir o
principal. Antes da promoção, a versão válida atual é gravada atomica e
validamente como `profile.json.bak`. Se o principal for inválido no carregamento,
o backup válido é usado e o menu informa a recuperação. Nenhum arquivo
defeituoso é apagado durante o carregamento; no próximo save bem-sucedido, o
principal inválido é movido para um nome `*.corrupt` antes da promoção.

O `?` do HUD e o botão correspondente da pausa abrem **Como jogar**. O modal
pausa a run, não mostra campo de nome e não chama `Game.save()`. O F1 permanece
o guia de playtest e seu fluxo de evidências não foi alterado.

## Cobertura adicionada

`tests/test_save_resilience.gd` verifica, em diretório temporário local ao
projeto:

1. primeira gravação e promoção da segunda versão;
2. backup da versão anterior;
3. recuperação de JSON principal corrompido;
4. preservação do arquivo corrompido ao salvar de novo;
5. comportamento sem escrita quando principal e backup são inválidos;
6. gravação no caminho isolado sem alteração da assinatura do save real.

`tests/test_playtest.gd` também confirma que o texto da ajuda contém objetivo e
progresso, sem solicitar nome.

## Validação executada

| Verificação | Resultado |
| --- | --- |
| `Godot_v4.7.2-stable_win64.exe --headless --path . -s tests/run_all.gd` | 0 falhas |
| `Godot_v4.7.2-stable_win64.exe --headless --path . res://tools/smoke.tscn` | menu e as 9 fases abriram; `smoke: ok` |
| revisão de diff (`git diff --check`) | sem erros de espaço |

O ambiente de automação não permite que o motor crie `user://logs/godot.log` e
não expõe o repositório de certificados do Windows. São avisos externos ao
projeto; a suíte e o smoke concluíram com sucesso.

## Revisão independente de escopo

- Persistência: não houve mudança no formato de `Profile`, moedas, desbloqueios
  ou regras de recompensa.
- QA: `Game` continua usando `_save_path`; portanto a mesma rotina só toca
  `user://qa-sandbox/<sessão>/profile.json` durante sandbox.
- Ajuda: o fluxo `rules` fecha sem ler ou escrever nome/perfil; o fluxo F1
  continua sendo `playtest`.
- Nenhuma dependência, serviço remoto, publicação ou alteração canônica foi
  introduzida.
