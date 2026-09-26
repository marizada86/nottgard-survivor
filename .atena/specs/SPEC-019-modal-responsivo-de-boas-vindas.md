# SPEC-019 — Modal responsivo de boas-vindas

Status: aprovada (2026-09-22). Em execução.

## Escopo

- Converter o aviso inicial de agradecimento ao playtester em um modal explícito,
  com fundo escurecido e bloqueio de interação no Quartel enquanto estiver aberto.
- Ajustar o painel à área visível, permitindo rolagem vertical em telas baixas.
- Manter o campo de nome, o atalho Enter e o botão **Começar** sempre acessíveis.
- Exibir a validação de nome dentro do modal e devolver foco ao botão Jogar ao fechar.

## Não objetivos

- Alterar o conteúdo do kit de playtest, regras do jogo, save ou fluxo de
  exportação de evidências.
- Redesenhar o Quartel ou modificar sua resolução-base de 1280×720.

## Critérios de aceite

1. Na primeira abertura, o Quartel fica visivelmente indisponível sob o modal;
   o fluxo não parece um botão Jogar quebrado.
2. Sem nome, o modal apresenta erro junto ao campo e não fecha.
3. Com nome, **Começar** fecha o modal, remove a pausa e o foco retorna a Jogar
   quando essa tela estiver ativa.
4. O painel respeita as margens da área visível e seu conteúdo pode rolar
   verticalmente quando não couber.

## Plano de voo

1. Construir uma camada modal de tela inteira e mover o guia para ela.
2. Remover dimensões rígidas do conteúdo, aplicar limite por viewport e rolagem.
3. Ajustar validação, foco e restauração da pausa.
4. Executar a suíte disponível e inspecionar o fluxo em janelas de referência.

## Evidência e reconciliação

- Registrar os comandos de validação e resultados em `.atena/evidence/`.
- Atualizar este documento para `Executada` somente após os critérios serem
  comprovados ou exceções registradas.
- A verificação de geometria responsiva e a suíte automatizada estão registradas
  em `EVID-039-modal-atalhos-e-reconciliacao.md`; o smoke visual interativo
  continua necessário antes de encerrar a spec.
