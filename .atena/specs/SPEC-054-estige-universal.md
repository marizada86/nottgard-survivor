# SPEC-054 — Contrato universal do Estige

Status: supersedida pelo PLAN-027 e SPEC-055 em 2026-09-27; histórico preservado  
Data: 2026-09-27

## Objetivo

Fazer com que os nove andares jogáveis ofereçam uma zona acessível do Estige
com o mesmo comportamento mecânico de Durao, preservando as regras próprias de
cada mapa.

## Fontes de intenção

1. `.atena/vault/canon/PLAN-001-contrato-lore-2026-09-26.md`, seções 6 e 7 e
   decisões posteriores sobre macroterreno;
2. `.atena/specs/SPEC-039-macroterreno-durval.md`;
3. `.atena/specs/SPEC-040-estige-gelatinoso-durval.md`;
4. `data/stage_rules.json` e os layouts de terreno vigentes;
5. `.atena/vault/drafts/PLAN-023-estige-universal-2026-09-27.md`.

## Escopo

- Um contrato compartilhado `styx_gelatinous` para os nove andares.
- Zonas navegáveis, determinísticas e legíveis do Estige em cada layout.
- Paridade de Teste de Lucidez, Esquecimento, Chamado, derrota por exposição,
  raros imbuídos e telemetria.
- HUD, descrição do mapa e automação de QA suficientes para evidenciar o
  comportamento.

## Não objetivos

- Redesenhar os mapas fora das zonas do Estige.
- Unificar lodo, voo, escrita, cachoeira ou rotação como se fossem Estige.
- Alterar balanceamento de inimigos, chefes, ondas, itens ou recompensas.
- Introduzir dependências, permissões ou publicação externa.

## Critérios de aceitação

1. Os nove andares possuem uma zona do Estige acessível em jogo normal.
2. Cada zona usa o mesmo contrato de Durao: atravessável, imóvel, Teste de
   Lucidez INT/CAM, Esquecimento temporário, Chamado, derrota por exposição e
   raros imbuídos; nunca empurra o jogador.
3. Estado, temporizadores, RNG, efeitos e derrota do Estige têm uma única
   implementação compartilhada.
4. As regras ambientais específicas de cada andar continuam funcionando.
5. Nenhuma zona nova bloqueia spawn, portal, telegráficos, arena de chefe ou
   rota essencial.
6. A suíte automatizada inclui uma matriz de paridade para os nove andares e
   passa sem falhas; smoke e capturas representativas também passam.
7. Evidências, registros de ativos e fatos canônicos afetados são reconciliados
   após a validação.

## Evidência planejada

- testes automatizados do contrato e da matriz por andar;
- smoke do jogo;
- capturas de cada zona e de seus estados principais;
- registro de hashes somente se algum ativo for realmente alterado;
- documento de reconciliação canônica e operacional.

## Plano de voo

Executar as sete etapas do PLAN-023, nesta ordem, com revisão independente de
paridade antes da conclusão.
