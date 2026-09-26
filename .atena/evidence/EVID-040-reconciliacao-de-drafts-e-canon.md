# EVID-040 - Reconciliacao de drafts e canon

Data: 2026-09-26
Status: concluida com pendencias explicitadas

## Escopo

Reconciliar o estado documental da producao visual, das animacoes de herois e
das ferramentas de playtest sem promover para canon planos historicos, fatos
nao comprovados ou execucoes ainda em validacao manual.

## Inventario observado

O inventario local de finais PNG registra a cobertura da base atual:

| Categoria | Quantidade |
|---|---:|
| Animacoes de herois | 106 |
| Sprites-base de herois | 10 |
| Retratos | 10 |
| Inimigos | 49 |
| Pisos | 8 |
| Props | 54 |
| Interacoes | 8 |
| Icones | 113 |
| Thumbnails de fases | 8 |

O `ASSET-PRODUCTION-MANIFEST-001.json` marca os assets de sua cobertura como
`integrated`. O conteudo operacional do manifesto continua derivado: ele nao
altera lore, identidade de personagens ou regras de jogo.

## Estado dos drafts

| Registro | Estado reconciliado |
|---|---|
| PLAN-002 | plano historico; sua visao de pipeline foi absorvida pelos artefatos e pelo contrato canonico, sem promover o texto inteiro a canon |
| PLAN-003 | plano historico executado; a cobertura atual e mantida no manifesto, nao no draft |
| PLAN-004 | rota logica comprovada; smoke visual nativo permanece como excecao aberta |
| PLAN-005 | fundacao de auditoria e registros implementada parcialmente; o criterio de 108 registros ainda nao foi satisfeito |
| PLAN-006 | tentativa corretiva de Brook encerrada sem integracao por falha de alfa |
| PLAN-007 Brook | quatro fontes integradas e verificadas automaticamente; smoke visual interativo pendente |
| PLAN-007 Bromnor | concluido e reconciliado anteriormente por EVID-034 e EVID-035 |

## Registros de animacao

Foram encontrados 27 arquivos `HERO-*.json` em
`.atena/generated/prompt-execution/`: 13 `integrated`, 10 `accepted`, 2
`qa_failed` e 2 `compiled`. Portanto, a regra de rastreabilidade esta adotada,
mas a meta historica de 108 registros de PLAN-005 nao pode ser declarada
concluida. Os estados conhecidos que exigem acompanhamento sao
`HERO-brook-move_e` em `qa_failed` e os dois registros `compiled`.

## Canon promovido

O canon recebeu somente o contrato duravel de producao visual: identidade por
ID estavel, separacao entre candidatas e finais, QA tecnico antes de integrar,
aprovacao humana e evidencia vinculada. A regra de espelhamento direcional ja
constava do canon e foi preservada.

## Validacao e pendencias

- `EVID-039-modal-atalhos-e-reconciliacao.md` registra a validacao automatizada
  da modal, atalhos e fluxo QA.
- A suite Godot correspondente terminou sem falhas na execucao registrada.
- Ainda e necessaria uma sessao de playtest visual para a modal, os atalhos,
  o Navegador QA e o movimento em janela nativa.
- SPEC-020 continua aberta ate que existam evidencias integradas de ZIP,
  limites, falha de disco e todos os cenarios QA previstos.
