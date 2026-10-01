---
id: "SPEC-104"
title: "Pausa no F4 e prévia direta de quadrinhos no Navegador QA"
status: "concluída — execução e verificação locais"
created: "2026-09-30"
relations:
  - "[[SPEC-050-atalho-f4-navegador-qa]]"
  - "[[SPEC-020-ferramentas-playtest-e-qa]]"
  - "[[SPEC-100-integracao-hqn-01-a-10]]"
  - "[[EVID-133-validacao-f4-previa-direta-hqs-2026-09-30]]"
---

# SPEC-104 — Pausa no F4 e prévia direta de quadrinhos no Navegador QA

## Descoberta

- O Navegador QA já abre pelo F4 em QA Interno. Hoje o atalho apenas alterna a
  visibilidade do painel; a simulação não é pausada.
- Enquanto aberto, F4 só é reconhecido sem controle de interface em foco, o que
  pode impedir o fechamento pelo próprio atalho depois de selecionar uma opção.
- O seletor existente escolhe fase, estado-alvo e evento, mas não oferece HQs.
- `data/hqs.json` contém HQN-01 a HQN-14. HQN-03 e HQN-04 estão associadas a
  marcos diferentes da mesma fase; HQN-01 e HQN-11 a HQN-14 não têm fase
  correspondente, pois usam gatilho de primeira run ou conquistas.
- O leitor `ui/hq_screen.tscn` já funciona como overlay pausado. O fluxo normal
  registra conclusão e recompensa em `ui/run.gd`; a prévia QA deve evitar esse
  caminho de persistência.

## Interpretação e escopo

Estender somente o Navegador QA de QA Interno para que F4 pause a simulação com
segurança e permita pré-visualizar qualquer quadrinho sem iniciar outra fase ou
alterar progresso. A seleção de fase serve como filtro/prioridade para as HQs
ligadas àquela fase; todas as HQN-01 a HQN-14 continuam acessíveis.

Ao abrir o navegador, guardar o estado de pausa anterior e pausar a árvore. A
interface QA permanece interativa. Fechar pelo botão, Esc ou F4 restaura o estado
anterior, inclusive se a partida já estava pausada. Com o painel QA aberto, F4
deve fechá-lo mesmo quando um controle do próprio painel tem foco; a proteção de
foco existente continua valendo para abrir o navegador a partir do jogo.

Adicionar "Quadrinho" como destino QA. Essa opção apresenta um seletor de HQ
com ID e título, priorizando as HQs associadas à fase escolhida. Shedaklah deve
mostrar tanto HQN-03 (entrada) quanto HQN-04 (vitória). HQN-01 e HQN-11 a HQN-14
ficam na lista geral de todas as HQs, e a lista completa permite pré-visualizar
qualquer uma independentemente do filtro de fase.

Abrir a seleção no leitor existente, por cima da tela pausada. Ao fechar o
leitor, retornar ao Navegador QA ainda pausado, preservando a seleção para
facilitar a revisão de outro quadrinho. A prévia não marca HQ como vista, não
concede conquistas/moedas, não grava save nem dispara gatilhos da campanha.

## Não objetivos

- Não expor o Navegador QA fora do perfil QA Interno.
- Não mudar a pausa normal de Esc/Start nem o comportamento dos destinos de run
  e eventos já existentes no Navegador QA.
- Não alterar textos, imagens, ordem ou gatilhos canônicos das HQs.
- Não alterar o save real, progresso, `hqs_seen`, conquistas ou recompensas ao
  abrir a prévia.
- Não adicionar dependências, permissões, commits remotos, push ou publicação.

## Critérios de aceite

1. Em QA Interno, abrir o F4 congela a simulação e mantém o Navegador QA
   utilizável; em outros perfis, o F4 continua sem abrir o navegador.
2. Fechar com botão, Esc ou F4 restaura exatamente o estado de pausa anterior.
   F4 fecha o painel mesmo com foco num seletor do Navegador QA.
3. "Quadrinho" aparece como destino QA; a seleção de fase prioriza as HQs
   correspondentes e todas as HQN-01 a HQN-14 permanecem acessíveis.
4. A prévia usa o leitor de HQ existente. Ao concluir ou pular, retorna ao
   navegador pausado e permite abrir outra HQ sem trocar a cena atual.
5. A prévia não altera save, `hqs_seen`, contagem/recompensas de conquistas ou
   marcos de campanha, tanto ao concluir quanto ao pular.
6. Testes cobrem pausa e restauração idempotentes, foco do atalho, filtro/lista
   completa, HQs duplas de Shedaklah, retorno do leitor e ausência de efeitos no
   perfil. Suíte completa e smoke test passam.
7. O F4 e a prévia permanecem restritos a QA Interno; playtest público e
   produção não recebem acesso ao Navegador QA.

## Impactos

- `core/playtest.gd`: pausa/restauração do Navegador QA, seleção de quadrinhos,
  filtro por fase e abertura/retorno do leitor.
- `core/version.gd`: predicado de perfil QA testável e guarda do Navegador QA.
- Guia do kit de playtest: anunciar F4 apenas nas builds QA Interno.
- `ui/hq_screen.tscn`: reutilizado sem alteração; a prévia não entra no fluxo de
  persistência da run.
- `tests/test_playtest.gd` e testes dedicados ao fluxo de HQ QA: cobrir interação
  e isolamento de perfil.
- Dados canônicos em `data/hqs.json`, gatilhos normais e save não devem mudar.

## Plano de voo

1. Após aprovação deste plano, atualizar o F4 para pausar ao abrir e restaurar
   o estado anterior ao fechar; manter o Navegador QA operável durante a pausa.
2. Adicionar destino "Quadrinho" e seletor dinâmico de HQ, priorizando os
   quadrinhos ligados à fase selecionada e mantendo a opção para todas as
   HQN-01 a HQN-14.
3. Exibir a HQ selecionada sobre a tela atual usando o leitor existente; fechar
   o leitor retorna ao navegador pausado. Manter a prévia isolada de save,
   conquistas, leituras e gatilhos de campanha.
4. Testar abertura/fechamento com foco e estados de pausa distintos, mapeamento
   de fases e HQs, leitura completa/skip, save antes/depois; executar suíte e
   smoke test.
5. Revisar links, escopo e critérios; registrar evidência e reconciliar a SPEC.
   Commit local de uma mecânica somente após a aprovação da execução. Sem push,
   PR ou merge sem autorização específica.

## Evidência e reconciliação

Implementação e validação local concluídas em 2026-09-30. EVID-133 registra os
testes, cenários de pausa, mapeamento fase/HQ e revisão de que a prévia não
escreve no perfil. O commit local desta mecânica será
`Pause F4 and add QA comic preview`.
