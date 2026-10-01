---
id: "EVID-133"
title: "Validação da pausa F4 e prévia direta de HQs"
created: "2026-09-30"
status: "implementação e validação local concluídas"
relations:
  - "[[SPEC-104-pausa-f4-e-previa-direta-de-hqs]]"
  - "[[SPEC-050-atalho-f4-navegador-qa]]"
  - "[[SPEC-100-integracao-hqn-01-a-10]]"
---

# EVID-133 — Validação da pausa F4 e prévia direta de HQs

## Resultado

- F4 abre o Navegador QA pausando a árvore e registra se o jogo já estava
  pausado. Fechar por F4, Esc ou botão restaura esse estado; o atalho pode fechar
  o painel mesmo com um controle QA em foco.
- O acesso ao navegador continua restrito a QA Interno, conforme SPEC-020 e
  SPEC-050; o perfil de playtest público mantém apenas as ferramentas de
  evidência autorizadas.
- O destino "Quadrinho (prévia)" lista HQN-01 a HQN-14. HQs ligadas à fase
  selecionada aparecem primeiro; Shedaklah prioriza HQN-03 e HQN-04, na ordem
  dos marcos. As HQs de abertura e conquista seguem disponíveis na lista geral.
- A prévia abre `ui/hq_screen.tscn` sobre a tela atual. Fechar ou concluir volta
  ao navegador pausado. Esse caminho não chama o fluxo de gravação da run, não
  marca `hqs_seen`, não concede recompensa e não muda o save ou os marcos.
- O guia informa que F4 pausa e dá acesso à prévia de HQ somente em QA Interno;
  o playtest público não anuncia esse atalho.

## Verificações

- `godot --headless --path . -s tests/run_all.gd`: **0 falhas**. Cobertura inclui
  regra de foco do F4, estado de pausa anterior, destino quadrinho, prioridade
  de Docas/Shedaklah e disponibilidade das 14 HQs.
- `godot --headless --path . res://tools/smoke.tscn --quit-after 120`:
  **código de saída 0**. A cena principal e os controles do Navegador QA foram
  instanciados no smoke.
- `git diff --check`: sem erros.
- Revisão do caminho de prévia confirmou que ele não acessa `Game.profile`,
  `Game.save()` nem as rotinas de marcos/conquistas.

O ambiente Godot reporta falha ao escrever `user://logs/godot.log` e ao ler o
repositório de certificados do sistema, além de avisos de recursos residuais ao
encerrar. Não houve falhas na suíte nem no smoke. A interação por teclado numa
janela gráfica não foi executada neste ambiente headless.

## Commit local

Incluído no commit local `Pause F4 and add QA comic preview`. Sem push, PR ou
merge.
