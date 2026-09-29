# RELEASES — quadro de versões de playtest

Cada versão é um **pacote de conteúdo para testar**. Decisão do dono
(2026-09-29): playtesters se empolgam mais quando a build traz **variedade de
conteúdo para experimentar**, então uma versão de playtest pode juntar várias
mecânicas, arte e correções. Isso substitui o limite antigo de "2 mecânicas por
lote" (ver [README](README.md)).

O que continua valendo, para poder desfazer sem perder o resto:
- uma spec, um teste e **um commit por mecânica** (nunca misturar com arte ou bug-fix);
- o bot de balanceamento quando a mecânica mexe em números;
- todo item novo entra na lista "O que testar" da versão (abaixo), que também
  alimenta o próximo questionário.

## Estados de uma versão

`planejada → em preparação → publicada (playtest) → avaliada`

Avaliada = as EVID dos testers foram triadas. Só então os cartões "aguardando
playtest" viram verificados ou reabertos.

## Versão 0.2.0 — em preparação

Origem: [PLAN-038](../vault/drafts/PLAN-038-atualizacao-pos-playtests-t01-t02-t03-2026-09-29.md)
(0.1.1 e 0.2.0 viraram uma versão só) e [PLAN-039](../vault/drafts/PLAN-039-roteiro-run-qa-para-versao-0-1-1-2026-09-29.md)
(roteiro da run QA). Ainda `0.1.0` em `core/version.gd` e `export_presets.cfg`.

| Trilha | Conteúdo | Cartão / spec | Estado |
|---|---|---|---|
| Bugs | Espelho de Shendilavri fora do mapa; inimigos presos em objetos; props flutuando; prévia do ferreiro | BUG-011, 012, 013, 015 | implementado, aguarda playtest |
| Bugs | Regra do ritual | BUG-014 → MEC-026 | implementado, aguarda playtest |
| Mecânicas | Comparação de equipamento (loja, forja, oferta) | MEC-019 · SPEC-081 | implementado |
| Mecânicas | Loja e ferreiro mostram todas as opções | MEC-023 · SPEC-082 | implementado |
| Mecânicas | Abertura de fase mais cheia | MEC-024 · SPEC-083 | implementado |
| Mecânicas | Bênção do Selo ao interromper o ritual | MEC-026 · SPEC-084 | implementado |
| Mecânicas | Velocidade 2x em mapas vencidos e evento Ampulheta | MEC-010 · SPEC-085 | implementado |
| Mecânicas | Faixa de dano, dica de evolução, Baú do Chefe, quebráveis, fontes, névoa e INT do Estige | MEC-007, 008, 013, 017, 018, 020, 022 · SPEC-086 | implementado |
| Mecânicas | Fidelidade do item (3 recusas sobem o nível) e eventos Altar da Doação e Mesa de Aposta | MEC-021, 005 · SPEC-087 | implementado |
| Mecânicas | Meta ampliado (5 aprimoramentos, 10 níveis em Força e Vitalidade) e +1 PV por nível a partir do 15 | MEC-014, 015 · SPEC-088 | implementado |
| Mecânicas | Conquistas novas, aprimoramentos travados por conquista e biografias do vault | MEC-016 · SPEC-089 | implementado |
| Mecânicas | IA de cerco: perseguidores flanqueiam | MEC-011 · SPEC-090 | implementado |
| Mecânicas | Mini-cinemática de evolução de arma | MEC-009 · SPEC-091 | implementado (procedural) |
| Mecânicas | Mapas maiores: 60×60 em todas as fases (props escalados, terreno esticado) | MEC-012 · SPEC-093 | implementado |
| Arte | Cor de raridade, rótulos de loja/ferreiro/curandeiro, ímã provisório, texto de "redução" | ART-009, 015, 016, 017 | implementado (provisório onde indicado) |
| Balanceamento | Ajustes de números pós-playtest: névoa, quebráveis, fontes, baú do chefe, abertura de fase | BAL-001, 004, 005, 006, 007 · SPEC-083, 086 | implementado, aguarda playtest |
| Ferramentas | Hash do commit no rodapé, no log e nas notas | TOOL-001 | implementado |

### O que testar (texto para os testers)

1. Abrir loja e ferreiro sem moeda suficiente: todas as opções aparecem?
2. Trocar equipamento: dá para ver o que se ganha e o que se perde?
3. Interromper um ritual: apareceu a bênção? Valeu a pena?
4. Os primeiros minutos de cada fase estão mais movimentados? Ficou difícil demais?
5. Inimigos contornam objetos, sem ficar presos? Props encostam no chão?
6. Cores de raridade ficaram claras nas ofertas?
7. Mapas já vencidos: a tecla T (2x) e o evento Ampulheta ajudam a jogar mais rápido?
8. Altar da Doação e Mesa de Aposta: entendeu o risco? Valeu a pena?
9. Os inimigos chegam de vários lados? Isso ficou interessante ou injusto?
10. Ao evoluir uma arma, a tela de evolução explica como foi? Dá para pular?
11. Quer comprar algo no meta? Novos aprimoramentos, conquistas e biografias: motivam a jogar mais?
12. A fase tardia (Shendilavri em diante) continuou melhorando o herói?
13. Os mapas ficaram maiores: acabou a sensação de apertado ou ficaram vazios demais? Inimigos demoram muito a chegar?

### Fechar a versão (checklist)

- [ ] Suíte, smoke e (se houver mudança de dados) bot verdes
- [ ] Roteiro do PLAN-039 rodado em run real; resultado vira EVID
- [ ] `VERSION` em `core/version.gd` e `file_version`/`product_version` em `export_presets.cfg` atualizados no mesmo commit
- [ ] Esta tabela revisada, com commits
- [ ] `tools/backlog_check.ps1` sem alertas novos
- [ ] Push na `main` (CI grava o commit da build e publica o `latest`)
- [ ] Aviso aos testers com a lista "O que testar" e o [questionário](questionarios/)

## Histórico

| Versão | Publicada | Commit da build | Avaliada em |
|---|---|---|---|
| 0.1.0 | 2026-09-29 (playtest T01, T02, T03) | não registrado (builds anteriores ao TOOL-001) | EVID-106, 107, 108 |
