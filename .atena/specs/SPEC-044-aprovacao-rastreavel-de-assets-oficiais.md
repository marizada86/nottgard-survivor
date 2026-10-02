# SPEC-044 — Aprovação rastreável de assets oficiais

Status: **em execução — validação integral concluída; 231 decisões artísticas pendentes** (2026-09-27).

## Intenção

Estabelecer uma trilha confiável para decidir quais bytes são os assets
oficiais de *Nottgard Survivors*. A trilha separa integridade do arquivo,
proveniência, aptidão técnica, revisão visual e decisão humana; nenhum desses
estágios substitui outro.

Esta SPEC implementa o primeiro estágio operacional do PLAN-013 aprovado pelo
dono: inventário, verificação, pranchas de curadoria e registros de decisão.
Ela não escolhe arte em nome do dono e não troca arquivos finais.

## Fontes e precedência

1. PLAN-013 aprovado pelo dono em 2026-09-27;
2. decisão explícita futura do dono, por `asset_id` e lote;
3. `ASSET-PRODUCTION-MANIFEST-001.json`, os manifestos de animação e registros
   de prompt, como evidência histórica não conclusiva;
4. os arquivos realmente presentes sob `assets/`, como bytes a verificar;
5. SPEC-043 e suas evidências, para o estado visual já conhecido de Nyrelia e
   props abissais.

## Escopo

- Inventariar os 267 registros do manifesto de produção e relacioná-los aos
  manifestos/recibos de animação quando aplicável.
- Validar existência, SHA-256, dimensões, canal alfa, caminho final, candidato
  recuperável, versão declarada e estado de QA de cada registro.
- Produzir relatório de inconsistências e pranchas locais de revisão em lotes
  de até 20 assets, com cartões suficientes para uma decisão humana informada.
- Preparar o lote crítico: nove strips de Nyrelia, `rocha_01–03`,
  `pilar_abissal_01–03` e os placements ativos de Durao relacionados.
- Criar modelos de registro canônico de decisão e lock derivado, mas preencher
  itens como oficiais apenas após uma escolha explícita do dono.
- Registrar evidências, cobertura e exceções no workspace ADD.

## Não objetivos

- Gerar, redesenhar, normalizar, substituir, copiar ou sobrescrever PNGs.
- Acionar provedores remotos, gastar créditos, instalar dependências ou
  transferir referências locais.
- Mudar metadados históricos de produção, posições de cena, placements,
  props, rio Estige, renderer, colisões, gameplay, lore ou balanceamento.
- Declarar um asset como artisticamente aceito com base em `integrated`,
  `accepted`, `compiled`, hash válido ou teste automatizado.
- Publicar, fazer commit, push, merge ou compartilhar externamente.

## Contratos técnicos e de decisão

1. Um registro auditado recebe exatamente uma classificação de
   rastreabilidade: `verificável`, `candidato_ausente`, `caminho_simbólico`,
   `hash_divergente`, `final_ausente` ou `qa_bloqueado`.
2. Um registro só pode chegar a `approved` após o dono escolher expressamente
   o arquivo final atual ou uma candidata identificada por caminho e hash.
3. Todo item aprovado terá `asset_id`, família, caminho oficial, SHA-256,
   dimensões, informação de alfa, uso conhecido em runtime, data, motivo e
   referência de decisão.
4. O lock derivado contém apenas itens `approved` com bytes existentes, hash
   fechado e caminho não simbólico. Itens `hold`, `rejected` e `regenerate`
   nunca entram nele.
5. Um candidato diferente do arquivo final atual será mostrado em simulação
   antes da admissão. A substituição em `assets/` depende de confirmação
   específica posterior do dono.
6. Aprovação de um PNG e aprovação de um placement são decisões distintas.
   Um prop aprovado não pode ser aprovado para placement sobre água corrente ou
   rasa do Estige.

## Plano de voo

1. Ler manifestos, recibos e arquivos sem escrita; calcular a matriz de
   cobertura e explicar a diferença entre 267 registros e 266 PNGs esperados.
2. Para cada registro, comparar o hash declarado ao arquivo presente e
   identificar se a candidata nomeada é recuperável, simbólica ou ausente.
3. Gerar relatório de auditoria e uma tabela de decisões inicialmente vazia;
   manter manifestos e recibos históricos imutáveis.
4. Montar e inspecionar o lote crítico. Nyrelia será avaliada por tira, frames
   e captura de viewport; props por cartão e contexto de chão/água.
5. Apresentar o lote crítico ao dono com escolhas por asset: `approved`,
   `rejected`, `hold` ou `regenerate`. Nyrelia `attack`, `active` e `death`
   começam bloqueadas para aprovação; `rocha_01` e `rocha_03` começam
   bloqueadas especificamente na família `rocha`.
6. Só depois de uma decisão do dono, registrar o lote escolhido no vault
   canônico e gerar o lock derivado correspondente. Caso seja selecionada uma
   candidata diferente, mostrar antes o plano de admissão sem escrita.
7. Repetir os lotes restantes por prioridade de uso: outros heróis/animações,
   props por estágio, inimigos, ícones de combate/itens, retratos, telas e
   backgrounds.
8. Verificar a cobertura, os hashes, os links de decisão e o lock; rodar os
   testes de integridade e smokes pertinentes apenas como validação técnica
   complementar.

## Critérios de aceite

1. Os 267 registros estão enumerados, classificados e vinculados ao arquivo
   final presente ou a uma exceção explícita; a discrepância de contagem está
   explicada ou permanece documentada como bloqueio.
2. As pranchas exibem, para cada item revisável, o arquivo final, candidata
   disponível, versão, hash curto, metadados técnicos e uso em runtime.
3. O lote crítico pode ser decidido pelo dono sem inferência de seleção
   histórica, e suas decisões não são registradas antecipadamente como fatos
   canônicos.
4. Nenhum item sem aprovação humana aparece como oficial ou no lock.
5. Nyrelia não promove ações ilegíveis, `rocha_01`/`rocha_03` não promovem a
   família `rocha`, e nenhum placement no Estige é aceito pelo fluxo.
6. Registros históricos permanecem preservados; os relatórios, recibos e
   locks são aditivos e possuem links consistentes.
7. Testes/smokes aplicáveis passam sem que seu resultado seja usado como prova
   de aprovação artística.

## Impactos previstos

- Novos relatórios, pranchas e recibos em `.atena/evidence/` e
  `.atena/generated/`.
- Um registro canônico e um lock derivado somente após decisões humanas por
  lote.
- Possível SPEC futura para admissão de uma candidata ou regeneração de asset
  rejeitado; esta SPEC não abrange tal alteração.
- Nenhuma nova dependência, serviço, permissão ou alteração de gameplay.

## Evidência planejada

- Relatório de cobertura e classificação de rastreabilidade dos 267 registros.
- Verificação de hash e metadados do arquivo final por registro.
- Pranchas do lote crítico e capturas de viewport de Nyrelia/props.
- Tabela de decisões assinada por referência à conversa do dono.
- Lock derivado, quando houver itens aprovados, e resultado de sua verificação.
- Saídas da suíte e dos smokes aplicáveis.

## Gate de execução

Esta SPEC exige aprovação explícita do dono antes de gerar relatórios,
pranchas, hashes e estruturas de registro. Essa aprovação não autoriza
substituição de bytes, reclassificação semântica, alterações de cena nem a
aprovação artística automática de qualquer asset.

## Reconciliação prevista

Ao final, o estado operacional diferenciará claramente: `integrated`,
`audited`, `approved`, `rejected`, `hold` e `regenerate`. A reconciliação só
marcará uma família como oficialmente fechada quando cada decisão tiver hash,
evidência e referência humana verificáveis.

## Execucao parcial

- `ASSET-AUDIT-001.json` confirmou os 267 registros de producao: todos os
  arquivos finais existem e conferem com o hash declarado; a diferenca de um
  registro frente aos 266 PNGs esperados permanece registrada para
  reconciliacao, sem ser ocultada.
- `HERO-ANIMATION-AUDIT-001.json` cobre as 90 sequencias-fonte de herois;
  elas possuem arquivo final, candidata recuperavel e contrato de frames
  compativel, mas ainda nao possuem lock oficial nem aceite artistico.
- As pranchas do lote critico e o modelo de decisao foram gerados. Nenhum PNG,
  placement, manifesto historico ou registro canonico foi alterado.
- A suite de testes terminou com zero falhas e o smoke concluiu as nove fases.
  A SPEC aguarda a decisao humana antes de criar registros oficiais ou seguir
  para o proximo lote.

## Reconciliação do lote crítico

- O dono aprovou explicitamente os 15 arquivos finais de Nyrelia e props
  abissais como oficiais, inclusive os arquivos que a revisão de QA havia
  marcado com ressalvas.
- `ASSET-APPROVAL-REGISTER-001-lote-critico-2026-09-27.md` tornou a decisão
  canônica e `ASSET-OFFICIAL-LOCK-001.json` fixou os seus hashes atuais.
- A verificação independente do lock encontrou 15 entradas e zero divergências
  de SHA-256 em relação aos bytes no projeto.
- Nenhum PNG, placement ou código foi alterado. A proibição de props sobre o
  Estige continua em vigor; a oficialidade de um arquivo não aprova seu uso em
  uma posição de cena.
- As 90 sequências-fonte de heróis agora estão oficializadas. Os 231 registros
  de produção fora dos props já aprovados seguem pendentes de revisão humana;
  portanto, a SPEC permanece em execução.

## Reconciliação do lote Durvall e Brook

- O dono aprovou as 18 sequências-fonte finais de Durvall e Brook.
- `ASSET-APPROVAL-REGISTER-002-durvall-brook-2026-09-27.md` registra a
  decisão canônica e `ASSET-OFFICIAL-LOCK-002.json` é o lock cumulativo atual.
- A verificação independente confirmou 33 entradas oficiais no lock e zero
  divergências de SHA-256 contra os arquivos no projeto.
- A aprovação não modificou PNGs, cenas, runtime, placements ou regras de
  gameplay. Os demais lotes continuam pendentes de decisão humana.

## Reconciliação do lote Maelor e Sylas

- O dono aprovou as 18 sequências-fonte finais de Maelor e Sylas.
- `ASSET-APPROVAL-REGISTER-003-maelor-sylas-2026-09-27.md` registra a decisão
  canônica e `ASSET-OFFICIAL-LOCK-003.json` é o lock cumulativo atual.
- A verificação independente confirmou 51 entradas oficiais e zero divergências
  de SHA-256 contra os arquivos no projeto.
- Nenhum PNG, cena, placement ou código foi alterado; a SPEC segue para o
  próximo lote pendente.

## Reconciliação do lote Kayron e Leoric

- O dono aprovou as 18 sequências-fonte finais de Kayron e Leoric, mantendo a
  ressalva perceptiva de Leoric registrada no aceite canônico.
- `ASSET-APPROVAL-REGISTER-004-kayron-leoric-2026-09-27.md` registra a decisão
  e `ASSET-OFFICIAL-LOCK-004.json` é o lock cumulativo atual.
- A verificação independente confirmou 69 entradas oficiais e zero divergências
  de SHA-256 contra os arquivos no projeto.

## Reconciliação do lote Zynara e Bromnor

- O dono aprovou as 18 sequências-fonte finais de Zynara e Bromnor.
- `ASSET-APPROVAL-REGISTER-005-zynara-bromnor-2026-09-27.md` registra a decisão
  e `ASSET-OFFICIAL-LOCK-005.json` é o lock cumulativo atual.
- A verificação independente confirmou 87 entradas oficiais e zero divergências
  de SHA-256 contra os arquivos no projeto.

## Reconciliação do lote Korrak

- O dono aprovou as nove sequências-fonte finais de Korrak, encerrando a
  curadoria das 90 sequências declaradas no manifesto de heróis.
- `ASSET-APPROVAL-REGISTER-006-korrak-2026-09-27.md` registra a decisão e
  `ASSET-OFFICIAL-LOCK-006.json` é o lock cumulativo atual.
- A verificação independente confirmou 96 entradas oficiais e zero divergências
  de SHA-256 contra os arquivos no projeto.

## Reconciliação dos props terrestres de Dagruve

- O dono aprovou nove props: braseiros, caixotes e iluminação.
- `ASSET-APPROVAL-REGISTER-007-props-dagruve-2026-09-27.md` registra a decisão
  e `ASSET-OFFICIAL-LOCK-007.json` é o lock cumulativo atual.
- A verificação independente confirmou 105 entradas oficiais e zero
  divergências de SHA-256 contra os arquivos no projeto.
- A decisão não aprovou placements em água; a regra do Estige permanece ativa.

## Reconciliação de barris, livros e redes

- O dono aprovou nove props adicionais de Dagruve.
- `ASSET-APPROVAL-REGISTER-008-barris-livros-redes-2026-09-27.md` registra a
  decisão e `ASSET-OFFICIAL-LOCK-008.json` é o lock cumulativo atual.
- A verificação independente confirmou 114 entradas oficiais e zero
  divergências de SHA-256 contra os arquivos no projeto.

## Reconciliação de carga, doca, margem e ossos

- O dono aprovou 12 props adicionais, com a restrição canônica de solo/borda
  seca para margem e detritos de doca.
- `ASSET-APPROVAL-REGISTER-009-carga-doca-margem-ossos-2026-09-27.md` registra
  a decisão e `ASSET-OFFICIAL-LOCK-009.json` é o lock cumulativo atual.
- A verificação independente confirmou 126 entradas oficiais e zero
  divergências de SHA-256 contra os arquivos no projeto.

## Reconciliação da validação integral

- `EVID-072-spec-044-validacao-total-2026-09-27.md` registra a repetição da
  auditoria de produção (267 registros), da auditoria de animações (90
  sequências), da conferência do lock oficial atual (126 entradas) e da
  inspeção visual das 21 pranchas dos 231 PNGs pendentes.
- Os hashes atuais conferem, os contratos de frames são compatíveis e a suíte
  e o smoke passaram. As lacunas de metadados de oito ícones foram mantidas
  como ressalvas históricas, sem alterar o manifesto.
- A validação não é aprovação artística: os 231 registros de produção seguem
  fora do lock até decisão humana explícita por lote. A proibição de objetos
  no rio Estige continua sem exceções.
