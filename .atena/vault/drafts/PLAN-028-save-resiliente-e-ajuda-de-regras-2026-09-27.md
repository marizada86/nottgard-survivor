---
id: "PLAN-028"
type: "plano-de-voo"
title: "Save resiliente e ajuda de regras no jogo"
status: "executado e verificado; evidência EVID-087"
created: "2026-09-27"
relations:
  - "[[PLAN-001-nottgard-survivors]]"
  - "[[SPEC-006-f5-meta-menu-conquistas-e-kit-playtest]]"
  - "[[SPEC-020-ferramentas-playtest-e-qa]]"
---

# PLAN-028 — Save resiliente e ajuda de regras no jogo

## Descoberta

O perfil persistente é gravado diretamente em `user://profile.json`. Uma
interrupção entre a abertura e o fim da escrita pode deixar o arquivo vazio ou
incompleto. Na inicialização, JSON inválido é interpretado silenciosamente como
perfil novo. Portanto, tanto uma gravação interrompida quanto corrupção externa
podem se apresentar ao playtester como perda de progresso.

Já existe o guia F1, mas ele é destinado à coleta de evidências de playtest,
solicita um nome na primeira abertura e fica em Opções. Ele não é uma ajuda
apropriada para explicar as regras durante uma run.

## Escopo proposto

1. Tornar a persistência do perfil recuperável:
   - serializar e validar o novo conteúdo antes de tocar no save atual;
   - gravar em arquivo temporário e validar esse arquivo;
   - manter a versão anterior válida em `profile.json.bak` antes de promover a
     nova versão;
   - ao iniciar, usar o save principal somente se for um JSON-dicionário válido;
     caso contrário, recuperar o backup válido, sem criar um perfil vazio em
     silêncio;
   - conservar o arquivo primário inválido para diagnóstico e expor uma mensagem
     clara de recuperação no jogo/log;
   - aplicar o mesmo mecanismo ao caminho isolado de QA, sem jamais escrever no
     perfil real durante o sandbox.
2. Criar uma ajuda de regras acessível por botão `?` durante a run e na pausa.
   Ela pausa o jogo, não pede nome, não escreve no perfil e explica: objetivo da
   run, movimento/mira/habilidade, ataques automáticos, level-up e rerrolagem,
   altares, regra ambiental, chefe, extração e portal/risco.
3. Preservar F1 como guia do playtester e manter a confirmação explícita de
   apagar progresso como está.

## Não objetivos

- Não migrar formato de perfil, alterar moedas, progresso, balanceamento ou
  regras de combate.
- Não restaurar dados que não existam em nenhum arquivo válido.
- Não coletar, enviar ou compartilhar saves.
- Não substituir o guia de playtest F1 nem seus fluxos de evidência.

## Critérios de aceite

1. Uma gravação normal deixa `profile.json` válido; a versão válida anterior
   permanece como backup recuperável.
2. Se o principal estiver truncado, vazio ou com JSON inválido e o backup for
   válido, o perfil carregado preserva o progresso do backup e o jogador recebe
   feedback de que houve recuperação.
3. Se os dois arquivos forem inválidos/ausentes, o jogo começa perfil novo mas
   registra o estado de forma explícita, sem sobrescrever os arquivos defeituosos
   durante o carregamento.
4. O sandbox QA continua sem alteração do hash/presença do save real.
5. O botão `?` abre e fecha uma ajuda legível, bloqueia a entrada da run enquanto
   visível e restaura corretamente pausa e foco; o conteúdo não pede nome nem
   grava dados.
6. Testes automatizados cobrem escrita válida, recuperação de backup e isolamento
   QA; a suíte e o smoke existentes continuam verdes.

## Plano de voo

1. Implementar helpers testáveis de serialização, leitura validada, escrita
   temporária, promoção e recuperação, preservando o caminho configurável do
   sandbox.
2. Adicionar testes com diretório temporário controlado para sucesso, principal
   corrompido, backup corrompido e ausência dos dois arquivos.
3. Adicionar o modal de regras e os botões `?` no HUD/pausa, mantendo o guia F1
   independente.
4. Executar suíte, smoke e uma verificação de abertura/fechamento da ajuda;
   registrar resultados em `.atena/evidence/` e reconciliar as specs afetadas.

## Riscos e decisão pendente

O backup preserva a última versão válida anterior: uma interrupção no instante
de salvar pode perder apenas a última alteração ainda não promovida, mas não todo
o perfil. A decisão proposta é priorizar essa garantia, sem introduzir nuvem,
conta ou dependências novas.
