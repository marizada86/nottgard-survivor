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

## Tipos de atualização: Minor-update e Major-update

Decisão do dono (2026-09-30). Toda versão publicada é de um dos dois tipos, e o tipo
define o número, o que entra e o que se entrega aos testers.

| | **Minor-update** | **Major-update** |
|---|---|---|
| Serve para | Manter a build saudável entre playtests | A grande atualização, depois de coletar o relatório dos testers |
| Conteúdo | Bugfixes gerais, balanceamentos pequenos (só números em JSON), ajustes pequenos de texto/UI/arte | Mecânicas novas, eventos, sistemas, telas, conteúdo e arte grande; junta correções e ajustes que vieram junto |
| Número | Último dígito: `0.2.0` → `0.2.1` → `0.2.2` | Dígito do meio: `0.2.x` → `0.3.0` (volta o último a zero) |
| Origem | Bug do [BUGS](BUGS.md), cartão pequeno do [BALANCEAMENTO](BALANCEAMENTO.md) ou de [ARTE](ARTE.md) | Relatório dos testers triado (INTAKE) e plano `PLAN-nnn` aprovado |
| Entrega aos testers | Notas curtas no aviso do Discord (lista de 3 a 8 linhas). **Sem PDF, sem questionário novo** | **Changelog em PDF** + questionário rápido novo |
| Não pode conter | Mecânica nova, regra nova, mudança de dificuldade global | — |
| Risco | Baixo: `git revert` isolado por commit | Médio/alto: um commit por mecânica (regra acima) |

**Como decidir o tipo:** se o tester precisa **aprender algo novo** para jogar (tecla, tela,
regra, evento), é **major**. Se ele só percebe "isso parou de dar problema" ou "está um
pouco mais fácil/difícil", é **minor**. Se um minor crescer até exigir explicação, vira major.

**Fluxo do major:** relatório dos testers → INTAKE → triagem → `PLAN` → implementação por
trilha (bugs → arte → mecânicas → balanceamento) → suíte + smoke + bot → versão em
`core/version.gd` e `export_presets.cfg` → **changelog PDF** (guia e modelo em
[changelogs/README.md](changelogs/README.md)) → push → aviso aos testers.

**Fluxo do minor:** bug ou ajuste → commit → suíte + smoke → versão (último dígito) →
push → aviso curto. Sem plano novo, sem PDF. A tabela de conteúdo da versão ganha uma
linha em "Histórico" (abaixo).

## Estados de uma versão

`planejada → em preparação → publicada (playtest) → avaliada`

Avaliada = as EVID dos testers foram triadas. Só então os cartões "aguardando
playtest" viram verificados ou reabertos.

## Versão 0.2.1 — publicada (playtest)

Pedido direto do dono em 2026-10-01 ("atualize a build de playtester para v0.2.1 com as novas atualizações"). **Fora da regra de minor-update:** esta versão traz mecânicas novas (Maré do Abismo, falas, números de dano), então os testers precisam aprender coisas novas; não há PDF nem questionário novo, só as notas abaixo. `0.2.1` em `core/version.gd` e `export_presets.cfg`.

### O que testar (notas curtas para o aviso)

- Retratos dos heróis no menu e no painel de itens agora aparecem inteiros (antes cortavam).
- Heróis e inimigos encostam os pés na sombra (antes flutuavam alguns pixels).
- Eventos do mapa (loja, ferreiro, curandeiro, aposta, doação, ampulheta, altar, fonte, ritual, portal) ficaram maiores; baús mantêm o tamanho.
- Dopamina (MEC-031): estouro ao matar, pausa curta em crítico e abate de elite ou chefe, tom da coleta subindo em sequência, números de dano por tipo com soma de acertos rápidos, brilho e nome do loot por raridade. Opção **Reduzir efeitos de impacto** em Opções.
- **Maré do Abismo:** abates em sequência (10, 25, 50, 100, 200) dão aviso e +2% de XP por 5 s (máx. +10%). Três conquistas novas por abates seguidos sem dano.
- **Alma e história (MEC-032):** epígrafe de cada fase, contexto de chefe, textos temáticos dos eventos e **falas dos heróis** (balão na entrada, no chefe e com pouca vida; desligável em Opções).
- Questionário para os testers: [QUESTIONARIO Rápido - 004](questionarios/QUESTIONARIO%20R%C3%A1pido%20-%20004.pdf) (mapa em [QUESTIONARIO-004](questionarios/QUESTIONARIO-004-v0.2.1.md)).
- Cenário (MEC-030, 033, 034, 035): destrutíveis com loot e Sorte, armadilhas de cenário e layout por zonas em Dagruve e Docas; arte de estradas ainda provisória.

## Versão 0.2.0 — Major-update, publicada (playtest)

Changelog para os testers (PDF, de 0.1.0 para 0.2.0): [CHANGELOG 0.2.0](changelogs/CHANGELOG%200.2.0%20-%20Nottgard%20Survivors.pdf)
(fonte em [HTML](changelogs/CHANGELOG-0.2.0.html)). Também entraram na build `latest`, depois do primeiro
push: suporte a joystick (SPEC-096), tela de título nova, skin de Leoric, animações do cultista de adaga
(SPEC-099) e estruturas por bioma (SPEC-100); o changelog já os cobre.

Origem: [PLAN-038](../vault/drafts/PLAN-038-atualizacao-pos-playtests-t01-t02-t03-2026-09-29.md)
(0.1.1 e 0.2.0 viraram uma versão só) e [PLAN-039](../vault/drafts/PLAN-039-roteiro-run-qa-para-versao-0-1-1-2026-09-29.md)
(roteiro da run QA, dispensado pelo dono: os bugs serão validados no próprio playtest). `0.2.0` em `core/version.gd` e `export_presets.cfg`. Publicada pelo CI no release `latest` (Playtest v0.2.0); o commit da build fica registrado no título do release.

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
| Mecânicas | Ofertas em cartão resumido: detalhes no hover ou com Shift (item, loja, ferreiro, nível, altar) | MEC-027 · SPEC-094 | implementado |
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
14. As ofertas (item, loja, ferreiro, nível, altar) ficaram mais fáceis de entender? O hover e o Shift (segurar) mostram o que faltava?

### Fechar a versão (checklist)

- [x] Suíte, smoke e (se houver mudança de dados) bot verdes
- [ ] Roteiro do PLAN-039 rodado em run real; resultado vira EVID *(dispensado pelo dono em 2026-09-29; validar no playtest)*
- [x] `VERSION` em `core/version.gd` e `file_version`/`product_version` em `export_presets.cfg` atualizados no mesmo commit
- [x] Esta tabela revisada, com commits
- [x] `tools/backlog_check.ps1` sem alertas novos
- [x] Push na `main` (CI grava o commit da build e publica o `latest`)
- [x] Changelog em PDF para os testers (2026-09-30)
- [ ] Aviso aos testers com o changelog em PDF, a lista "O que testar" e o [questionário rápido 003](questionarios/QUESTIONARIO%20R%C3%A1pido%20-%20003.pdf) (mapa pergunta → cartão em [QUESTIONARIO-003](questionarios/QUESTIONARIO-003-verificacao-v0.2.0.md))

## Histórico

| Versão | Tipo | Publicada | Commit da build | Avaliada em |
|---|---|---|---|---|
| 0.2.1 | Atualização de playtest (pedido do dono; traz mecânicas) | 2026-10-01 (release `latest`, Playtest v0.2.1) | ver título do release | — (aguardando testers) |
| 0.2.0 | Major | 2026-09-29 (release `latest`, Playtest v0.2.0) | `adc9ae6` (tag `latest` em 2026-09-30; primeira publicação: `fce670d`; republicada a cada push na `main`) | — (aguardando testers) |
| 0.1.0 | Major (primeira) | 2026-09-29 (playtest T01, T02, T03) | não registrado (builds anteriores ao TOOL-001) | EVID-106, 107, 108 |
