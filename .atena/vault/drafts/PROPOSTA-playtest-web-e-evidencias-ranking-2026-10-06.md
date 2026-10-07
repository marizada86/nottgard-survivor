---
id: DRAFT-PLAYTEST-RANKING-20261006
title: Playtest Web automatico e estatisticas importadas de evidencias Discord
created: 2026-10-06
status: APPROVED_LOCAL_SPEC_138
origin: guided-add
implementation_preceded_spec: false
request_classification: PLAN_CHANGE_REQUEST
active_plan_relation: PLAN_DEVIATION
approval_mode: per-plan
execution_order: AFTER_PLAN_067_MOBILE
deferred_request: DEV-003
---

# Playtest Web e evidencias para ranking

## Intencao e autorizacao observada

O dono substituiu a proposta de coleta automatica em ambas as plataformas: ele estruturara os pushes GitHub para atualizarem Web e Windows/Discord; testers podem escolher qualquer versao. Na Web, propor sincronizacao automatica das estatisticas. No Windows, estatisticas acompanham os arquivos de evidencia enviados pelo tester e so entram no ranking apos importacao. Estruturar botoes equivalentes a F4/F5/F6 e os dois caminhos de recebimento. Em 2026-10-06, o dono escolheu implementar depois do plano mobile. Isso autoriza o adiamento e esta preparacao, sem aprovar ainda a implementacao, a publicacao ou novos acessos remotos.

Classificacao: PLAN_CHANGE_REQUEST da proposta de leaderboard/coleta desta conversa; PLAN_DEVIATION em relacao ao PLAN-067 do jogo e ao PLAN-060 do site. O PLAN-067 permanece ativo; Durvall continua preservado no retorno B-002/S-005 ja registrado. O ponto de retorno do site permanece PLAN-060/S-005/B-002 pendente. Nao trocar os cursores nesta preparacao. Ao ativar este trabalho, registrar a suspensao/retorno do plano entao vigente nos dois projetos antes de implementar.

## Evidencia inspecionada

- [Estado do jogo](../../state/plan.yaml): PLAN-067/SPEC-134 mobile ativo por plano; PLAN-066 suspenso com retorno.
- [Atalhos e captura](../../../core/playtest.gd): F4 e exclusivo de QA interno; F5 grava relato; F6 captura viewport. Grava em evidencias/ ao lado do executavel e aceita txt/log/imagens; JSON avulso e ZIP nao fazem parte do contrato.
- [Perfis](../../../core/version.gd) e [presets](../../../export_presets.cfg): producao, public_playtest e qa_internal separados. Presets locais listam Windows; nao ha preset Web no arquivo inspecionado.
- [CI existente](../../../.github/workflows/build-release.yml): push na main executa testes, exporta Windows Desktop, substitui release latest e anuncia opcionalmente no Discord. Windows Desktop tem custom_features vazio; portanto o CI atual nao habilita os atalhos de evidencia na build release. Nome de release playtest nao habilita funcionalidades por si so.
- [Resultado](../../../core/battle.gd) e [finalizacao](../../../core/game.gd): tempo/abates/resultados existem, mas faltam historico completo da build e contrato de envio.
- [Testes de evidencias](../../../tests/test_playtest.gd): protegem txt/log/imagens e ausencia de exportador ZIP.
- D:/dev/marizverso.com/db/index.ts e db/schema.ts: SQLite/Drizzle e identidades de playtest; sem tabelas de runs/builds de jogo no schema inspecionado. Nao abrir banco real nesta preparacao.
- D:/dev/marizverso.com/services/discord/src/playtest-bot.ts e register-commands.ts: bot implementa aprovar/reprovar candidaturas; importacao de anexos ainda nao existe. Nao alegar que anexar arquivos a uma conversa ja atualiza o rank.
- Canon do site DEC-001-playtest-unificado.md: evidencia Windows txt/log/imagens enviada individualmente na task Discord; Marizverso guarda estado/revisao. DEC-002-contas-jogador-web.md: cadastro comum de jogadores adiado; manter acessos existentes.
- Documentacao primaria: https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_web.html ; https://docs.godotengine.org/en/stable/classes/class_javascriptbridge.html ; https://docs.discord.com/developers/interactions/application-commands . Web usa persistencia do navegador e ponte JavaScript; comandos Discord aceitam anexos.
- Backlog lido com tools/backlog_check.ps1: 0 P0, 4 P1 abertos, 7 P1 implementados aguardando playtest e 8 verificacoes manuais, sem alertas de organizacao. Nao fechar bugs com esta investigacao.

## Escopo proposto

### Contrato comum da partida

Identificador persistente unico run_id; game_id; schema_version; build_id imutavel (commit completo fornecido pelo pipeline); game_version; balance_version; source web/windows; hero_id; seed; fase inicial/percurso; dificuldade; modificadores permanentes e configuracao; tempos ativo de simulacao e real; resultado final e motivo; contadores; snapshots e escolhas da build; origem/contaminacao QA e uso de velocidade acelerada. O registro inclui interrupcoes e derrotas, nao apenas recordes.

Guardar escolhas e alternativas oferecidas com instante e fase, niveis/evolucoes, equipamentos/afixos/raridades, bencaos, revives, dano efetivo por fonte, dano recebido, cura, progressao por fase e causa da morte. Limitar volume e contabilizar overkill separadamente para nao inflar dano efetivo. Seed com escolhas/entradas incompletas nao demonstra replay deterministico nem prova integridade.

Server atribui a identidade pelo acesso do tester; nao confia no nome, ID ou pontuacao declarados pelo cliente. Um mesmo run_id importado novamente nao duplica; payload divergente com o mesmo ID fica em revisao e nao substitui silenciosamente o anterior. Registrar recebido, incompleto, aceito e em revisao. Origem Web e Windows permanece visivel.

### Botoes de playtest

Propor tres botoes visiveis dentro do jogo, tambem em tela cheia e toque. Na Web, botoes sao o caminho principal e nao exibem F4/F5/F6 como atalhos; os comandos do navegador permanecem disponiveis. No Windows, os mesmos comandos mantem F4/F5/F6. A disposicao deve aproveitar a camada mobile do PLAN-067 sem editar esse trabalho enquanto ativo.

| Botao | Comportamento proposto |
|---|---|
| Playtest | Central com build/task, status de identificacao e fila de evidencias. Preservar navegador QA em area exclusiva do perfil interno; qualquer run iniciada por QA e inelegivel para ranking. Abrir painel durante combate pausa e fechar restaura o estado anterior. Windows: F4. |
| Relatar | Nota com contexto, build, task e run. Web guarda localmente e envia a fila autorizada; Windows grava relato.txt. Falha de envio nao apaga texto. Windows: F5. |
| Capturar | Print do viewport do jogo, vinculado a run/task e instante. Web guarda e envia pela fila autorizada; Windows grava PNG em imagens/. Captura nao pausa o combate; respeita bloqueios de modal e previne duplo acionamento. Windows: F6. |

Na Web, nao vincular F4/F5/F6 aos comandos de playtest nem depender de bloquear atalhos do navegador: F5 recarrega, F6 muda o foco, F4 foca a barra de endereco no Edge. preventDefault so cancela eventos cancelaveis entregues a pagina; nao garante captura em todas as condicoes. Nao capturar teclas ao digitar em formularios externos. Atalhos Web adicionais ficam opcionais e dependem de teste por navegador; nenhum e prometido como livre de conflitos nesta preparacao. Botoes funcionam sem teclado, restauram foco com seguranca, nao movimentam o heroi e nao ficam escondidos fora do fullscreen. Status: salvo localmente, pendente, enviando, recebido, erro/repetir. Downloads manuais txt/log/PNG individuais sao recuperacao por acao do usuario, sem ZIP. Nao prometer persistencia apos limpar dados, fechar navegacao privada ou antes do recibo do servidor.

Refinamento IN_PLAN da proposta DEV-003 em 2026-10-06, apos pergunta do dono sobre conflitos no navegador. Fontes primarias: https://support.google.com/chrome/answer/157179?hl=en ; https://learn.microsoft.com/en-us/deployedge/edge-learnmore-configurable-edge-commands ; https://developer.mozilla.org/en-US/docs/Web/API/Event/preventDefault . Sem alterar implementacao ou ordem depois do mobile.

### Caminho Web

Estatisticas enviadas automaticamente ao fim da run com fila persistente, retries limitados/backoff e confirmacao do servidor. Checkpoints resumidos permitem identificar tentativa interrompida; nao depender de envio na descarga da pagina. Perda de foco e pauses nao contam como sobrevivencia ativa.

No piloto, usar a sessao de playtester ja aprovada do site para associar os dados, com verificacao no servidor e protecao das requisicoes. Nao conceder permissao administrativa pelo Discord. Jogar anonimamente continua permitido pela decisao vigente; runs anonimas nao entram no ranking identificado de playtesters. Nome digitado localmente e somente rotulo.

F5/F6 enviam para a task selecionada depois da autorizacao inicial explicita de coleta. Estatisticas e evidencias de feedback tem consentimento e status claros; nenhum upload antes dessa escolha. Registrar anexos e metadados sem publicar notas no ranking. Proposta a aprovar: permitir anexos Web privados no Marizverso, com retenção propria, como extensao especifica da DEC-001; arquivos Windows continuam no Discord. Save em nuvem fica fora.

### Caminho Windows/Discord

Ao final de cada run gravar evidencias/logs/estatisticas.log em JSON Lines, compativel com a extensao .log ja aceita; opcional resumo legivel em txt. Historico e registros finais sao escritos automaticamente, independentemente de F5/F6. Identificador da build e versao do schema acompanham cada registro. Arquivo nao inclui emails, tokens, caminhos locais ou nome do usuario do sistema. Estatisticas de builds antigas nunca mudam de versao por terem sido enviadas depois.

O tester envia o arquivo individualmente na task Discord usando um comando explicito de envio com anexo, proposto /playtest enviar. O bot verifica servidor, task, build e identidade vinculada de tester aprovado; importa pelo mesmo validador da Web e devolve recibo com runs aceitas/rejeitadas/pendentes. Arquivos soltos fora desse fluxo nao entram automaticamente. Reaproveitar operacao por comandos sem exigir leitura indiscriminada de mensagens. Notas/logs/prints podem continuar nas tasks, vinculados por run/task; capturas nao sao fonte de pontuacao.

Nao transmitir estatisticas pela rede a partir do executavel neste escopo. Checagem de formato, limites, conteudo e consistencia e deteccao de anomalias; hash ou assinatura embutida no jogo nao e antifraude. Rank de playtest, com revisao de resultados suspeitos; sem bloqueios automaticos de jogadores.

### Ranking e balanceamento

Uma fonte de resultados aceitos para o menu do jogo e o site. Rankings por pontuacao, sobrevivencia ativa e menor tempo de conclusao; filtros por heroi, percurso, dificuldade, balance_version, origem e perfil de progresso. Menor tempo somente entre conclusoes do mesmo percurso/condicoes; maior sobrevivencia por modo/percurso. Melhores entradas por jogador/categoria evitam ocupar todo o Top com um tester.

Default RESOLVABLE para pontos v1, sujeito a aprovacao: 1 por inimigo comum, 10 por elite, 100 por chefe, 500 por fase concluida uma unica vez. Categorias de inimigo mutuamente exclusivas, sem somar chefe/elite novamente como comum. Nao usar ouro, dano bruto ou tempo como bonus de pontos. Guardar score_version e componentes calculados no servidor. Pesos sao proposta inicial, nao medicao de equilibrio; calibracao posterior e outro checkpoint. Progressao mais longa e farm so sao comparados dentro do mesmo modo.

QA, bots, cenarios forjados, perfis internos e uso de aceleracao ficam fora do rank normal e disponiveis para diagnostico separado. A marca de inelegibilidade e persistente na run, mesmo depois de fechar F4 ou voltar a 1x. Builds antigas mantem historico e filtros, sem reset destrutivo.

Relatorio privado agrupa todas as tentativas registradas: melhor build por recorde e por consistencia, taxa de conclusao, curva de nivel/poder, tempo de chefe, mortes por fase, escolhas por oferta e desempenho de equipamentos/combinacoes. Exibir numero de runs e testers por grupo; nao inferir efeito causal de correlacao. Amostras Windows sao apenas as enviadas pelos testers e sofrem selecao: nao equivalem a todas as tentativas jogadas. Mostrar cobertura e origem; nao comparar taxas agregadas sem esse limite.

## Limite com o pipeline do dono

O dono estruturara pushes/builds/publicacao. Esta entrega define um contrato de integracao, nao executa esse trabalho implicitamente: Web e Windows levam o mesmo commit/build_id, score_version, schema_version e balance_version; perfis de playtest precisam estar habilitados na exportacao correta; manifest de build informa destinos e capacidades. Site e Discord so anunciam como disponivel cada destino que passou seus checks. Site recebe build nova na proxima abertura/recarga, sem interromper run ativa; payloads antigos continuam aceitos conforme janela definida. Registrar falha parcial entre destinos, sem anunciar falsamente sincronizacao.

O CI inspecionado exporta Windows Desktop de producao. Recomendar ao dono exportar Windows Playtest Publico para F5/F6 e a nova central, com QA interno segregado. Preset Web/shell e atualizacao segura precisam existir no pipeline que o dono preparara; nao pressupor sua conclusao. App/publicacao do site e bot continuam sob gates separados; este plano local nao autoriza push, deploy ou registro remoto de comandos.

## Nao objetivos

Implementar o pipeline/publicacao anunciado pelo dono; publicar site ou Discord; registrar comandos remotos; instalar dependencias; configurar credenciais/permissoes; migrar banco real; liberar QA para rank; cadastro geral de jogadores; save em nuvem; alterar balanceamento de combate; regenerar arte; retomar mobile/Durvall nesta entrega; antivirus/antifraude completo; ZIPs ou videos; coleta silenciosa; alteracao dos cargos existentes; commit, push e merge.

## Impactos e recuperacao

Jogo: core/playtest.gd, finalizacao/contador da run, adaptador Web e Windows, controles/presets de playtest e testes. Site: novas rotas de coleta, banco de estatisticas, anexos Web privados, administracao/leaderboard e bot de importacao. Mudancas de arquitetura/retencao ficam explicitas para aprovacao. Preservar alteracoes preexistentes e integrar somente apos mobile.

Recovery: feature flag de coleta/central; deixar evidencias Windows e gameplay disponiveis sem rede; API rejeita novas entradas sem apagar dados antigos; importacao e idempotente. Schema evolui por migracao aditiva testada em banco sintetico. Backups consistentes e recuperacao sao requisitos antes de qualquer migracao real, em checkpoint independente. Nao usar reset global ou rollback de banco com dados novos.

## Gaps

- RESOLVABLE: usar testers aprovados existentes; .log estruturado; comando explicito com anexo; fila Web; nova central F4 com QA restrito; rank de playtest; proposta de pontos v1 e filtros. Aprovacao do escopo confirma ou ajusta esses defaults.
- RESOLVABLE: propor notas/prints Web privados com retencao de 90 dias e agregados/runs sem anexos por 12 meses, com exclusao a pedido e politica para revogacao; validar essa politica antes de coletar remotamente. Nao aplicar limpeza na preparacao.
- BLOCKING para execucao local: escolher nivel de aprovacao e confirmar escopo dos primeiros lotes. Documento permanece rascunho e unconfigured ate resposta; selecao de nivel nao substitui aprovacao do escopo/checkpoint.
- DEFERRED para B-003/B-004: verificar estado real da sessao de testers/servico publicado, armazenamento de anexos, limites/recuperacao, migracao e credenciais concretas sem ler/imprimir segredos. Validacao local usa banco e identidades sinteticos. Se mudar materialmente a solucao proposta, revisar antes do lote.
- DEFERRED para B-006: contrato final do pipeline do dono e preset/shell Web. Sem artefato Web correspondente, validar apenas contrato local e nao declarar integracao end-to-end concluida.
- DEFERRED: contas gerais, sincronizacao de saves, antifraude avancado e ampliacao do rank fora de playtest.

## Plano de voo proposto

| Lote | Etapas | Entrega |
|---|---|---|
| B-001 | S-001 contrato; S-002 coletor/arquivo Windows | Schema, fixtures, score/eligibilidade, run_id e estatisticas.log |
| B-002 | S-003 central F4; S-004 relato/captura Web | Botoes, foco/toque/fullscreen, armazenamento e fila local |
| B-003 | S-005 coleta/site; S-006 anexos/recibos | Rotas autenticadas, persistencia e reenvio; somente banco sintetico |
| B-004 | S-007 importacao Discord | Parser de anexo e identidade; simular comandos sem registro remoto |
| B-005 | S-008 ranking; S-009 relatorios | Menu/site, builds e painel privado com amostras e cobertura |
| B-006 | S-010 integracao; S-011 reconciliacao | Builds fornecidas pelo dono, QA Web/Windows, evidencia e plano de ativacao |

Ordem aprovada: depois do PLAN-067. Niveis oferecidos: per-plan, per-batch (recomendado), per-step. IDs de spec/plan executaveis serao reservados ao aprovar, evitando colisao com trabalho paralelo. Site tera spec.md, plan.md, tasks.md e acceptance.md segundo seu contrato, antes da implementacao nesse projeto. Gates de publicacao, banco real, credenciais e comandos remotos permanecem independentes.

## Aceite e validacao planejada

1. Mesmo fixture de run pela Web e pelo .log Windows produz resultado, build e pontos iguais; duplicata nao duplica rank; conflito nao sobrescreve.
2. Arquivo Windows finaliza vitoria/derrota/extracao e conserva interrompidas; stat nao depende de nota ou print. Save real intacto.
3. Botoes Web funcionam em janela, fullscreen e toque; pausar/restaurar correto. F4/F5/F6 nao disparam comandos de playtest na Web; F5 continua sendo recarga normal do navegador, com fila ja persistida recuperavel quando disponivel. Testar foco, digitacao e atalhos em Chrome, Edge e Firefox. No Windows, F4/F5/F6 continuam operando os comandos. Sem cliques duplicados ou movimento indevido.
4. Simular offline, timeout e falha de servidor: nota/print/stat continuam pendentes; sucesso so depois de recibo; reenvio limitado e sem duplicata. Navegacao privada tem limite comunicado sem promessa de persistencia.
5. Visitante, candidato pendente, tester revogado e identidade forjada nao recebem acesso de coleta/rank/admin; tester aprovado consegue enviar; identidade Discord precisa corresponder a vinculo do site. Tokens ausentes em logs e arquivos.
6. Anexo invalido, grande, truncado, schema desconhecido, task/build incorretos e dados nao finitos sao rejeitados com recibo; URL/anexo nao permite buscar destinos arbitrarios do servidor. Sem abrir DB de producao.
7. Rank ignora QA/bot/aceleracao e distingue runs incompletas, versoes e percursos. Tela inicial tem Top e recorde do jogador; detalhes da build e filtros funcionam.
8. Relatorio usa derrotas e incompletas com denominadores explicitos; mostra runs/testers/origem/cobertura e nao mistura dados sinteticos com humanos.
9. Suíte Godot apropriada + runner e smoke com D:/Godot/godot.exe; testes de site/bot com DB sintetico, tipagem e build local; QA real de navegador/Windows no checkpoint B-006. Nao foram executados testes de implementacao nesta preparacao.
10. Validar contrato ADD, links e estados; comparar cada criterio com evidencia real; reconciliar fatos operacionais e alteracoes canonicas aprovadas. Publicacao/ativacao remota somente por aprovacao propria depois de revisar resultado local.

## Reconciliacao atual

Somente investigacao e rascunho, com DEV-003 adiado pelo dono. Nenhuma implementacao, upload de evidencia, dependencia, alteracao canonica, migracao ou publicacao realizada. Divergencias CI/perfis e coleta Web foram constatadas por leitura, nao por execucao dos artefatos publicados. Plano mobile ativo preservado.

Verificacao documental em 2026-10-06: contrato ADD completo, todos os links locais do rascunho existentes, YAML do estado e front matter parseados com js-yaml ja instalado no site; DEV-003 unico e PENDING_AFTER_PLAN_067; PLAN-067 permanece ativo. Nenhuma dependencia instalada. O alias Python do sistema estava indisponivel e o Python empacotado nao possui PyYAML; validacao de links usou o runtime empacotado, e YAML usou a biblioteca existente. Nao declarar testes de gameplay, browser ou importacao a partir destas verificacoes.

## Reconciliação de execução — 2026-10-06

O texto de preparação acima conserva o estado anterior e não é uma nova solicitação de aprovação. Depois da preparação, o dono pediu iniciar e aprovou todos os lotes locais por plano. SPEC-138 e o espelho SPEC-015 estavam aprovados antes da implementação. Zero gaps BLOCKING locais. Entrega e limites em [EVID-187](../../evidence/EVID-187-playtest-ranking-local-2026-10-06.md); estado executável registra B-006/S-011 entregue localmente e homologação final pendente. Pontos de retorno dos planos posteriores ao mobile preservados. Pipeline, credenciais, banco real, comandos e publicação continuam em gates próprios.
