# Backlog por trilha — Nottgard Survivors

Criado em 2026-09-29 (PLAN-037). Esta pasta é uma **camada por cima** do ADD:
specs, evidências, planos e canon continuam onde estão, com os mesmos nomes
(os `[[wikilinks]]` dependem disso). Aqui só vive a **fila de trabalho**.

| Arquivo | Trilha | Prefixo |
|---|---|---|
| [INBOX.md](INBOX.md) | Tudo que chega e ainda não foi classificado | `IN-nnn` |
| [INTAKE.md](INTAKE.md) | Procedimento para assimilar evidência de um novo jogador | — |
| [ARTE.md](ARTE.md) | Arte **e áudio**: assets, templates, layouts, backgrounds, prompts, sons | `ART-nnn` |
| [MECANICAS.md](MECANICAS.md) | O que muda o comportamento do jogo | `MEC-nnn` |
| [BUGS.md](BUGS.md) | Defeitos e dívida de verificação | `BUG-nnn` |
| [BALANCEAMENTO.md](BALANCEAMENTO.md) | Equilíbrio: heróis, armas, itens, inimigos, economia e dificuldade | `BAL-nnn` |
| [FERRAMENTAS.md](FERRAMENTAS.md) | Ferramentas e build: kit de evidência, CI, scripts, exportação | `TOOL-nnn` |
| [RELEASES.md](RELEASES.md) | Quadro de versões de playtest (**Minor** e **Major**): conteúdo, "o que testar", checklist | — |
| [changelogs/](changelogs/README.md) | Changelog em PDF dos **Major-update** para os testers, com guia e modelo | — |

## Fluxo

```
evidência / playtest / ideia → INBOX → triagem → ARTE | MECANICAS | BUGS | BALANCEAMENTO
                                                      ↓
                                     lote → spec (SPEC-nnn) → EVID-nnn → fechado
```

## Ciclo de vida de um cartão

`aberto → em spec → IMPLEMENTADO → aguardando playtest → verificado (fechado)`

- Ao implementar, escrever no cartão **IMPLEMENTADO AAAA-MM-DD** e o que falta
  (ex.: "aguarda run real"). O `tools/backlog_check.ps1` reconhece essa marca.
- **Regra do dono (2026-09-29):** o lote de bugs é fechado no **próximo
  playtest com a versão nova**; bug implementado que **não for mencionado de novo
  é dado como corrigido**. Se voltar a aparecer, o cartão reabre.
- Só a versão com **hash de commit** (TOOL-001) permite saber se o relato veio
  de uma build que já tinha a correção.

Todo item aponta para a **origem** (`EVID`/`PLAN`) e, depois de aberta, para a
**spec**. Item fechado sai da tabela "Abertos" e vai para "Fechados" com o link
da evidência — nunca é apagado.

## Regra de fronteira

- Só muda a **aparência ou o som** (sprite, ícone, layout, cor, tamanho de
  texto, fundo) → **Arte**.
- Muda o **comportamento** (regras, drops, eventos, itens, controles, telas com
  função nova) → **Mecânicas**.
- Mecânica que precisa de arte gera um `ART-nnn` ligado a ela (coluna
  "Depende de"). As duas trilhas nunca se descolam.
- Só **números** de conteúdo que já existe (dano, PV, custo, taxa de drop, frequência,
  curva de dificuldade) → **Balanceamento**. Regra ou sistema novo continua sendo
  Mecânica; um relato pode gerar cartões nas duas, ligados entre si.
- Defeito em algo que já deveria funcionar → **Bugs**, mesmo que a correção seja
  de arte (ex.: sprite transparente).

## Regras por trilha

Cada trilha guarda as próprias regras no topo do seu arquivo; aqui só o mapa:

| Trilha | Onde estão as regras | Em uma linha |
|---|---|---|
| Arte & Áudio | [ARTE.md](ARTE.md) | Sabor Nottgard, lote único `ART-PROMPTS-NNN`, candidatos em `.atena/generated/` até admissão |
| Mecânicas | [MECANICAS.md](MECANICAS.md) | Sem limite por versão; uma spec, um teste e um commit por mecânica |
| Bugs | [BUGS.md](BUGS.md) | P0 na hora; P1/P2 acumulam; lote fecha no próximo playtest; **Minor-fix** sem spec nem EVID |
| Balanceamento | [BALANCEAMENTO.md](BALANCEAMENTO.md) | Um cartão por entidade e sintoma; duas fontes para decidir; uma alavanca por vez |
| Ferramentas | [FERRAMENTAS.md](FERRAMENTAS.md) | Kit de evidência, CI, scripts e export; build de playtest sempre com `stamp_build.ps1` |
| Perguntas aos testers | [INBOX.md](INBOX.md) | Dúvidas não bloqueiam; entram no questionário seguinte |

## Ordem de lançamento

1. Bug-fix → 2. Arte & Áudio → 3. Mecânicas → 4. Balanceamento — cada um em commit
separado (uma mecânica por commit; números por entidade). Balanceamento vem por
último para calibrar o conteúdo final da versão, com o bot rodando nele. A versão de playtest junta tudo (ver [RELEASES.md](RELEASES.md)).

## Numeração

Próximos livres (2026-10-05, conferido no disco por Atena após SPEC-125, EVID-162, PLAN-059 e a entrada do T04; SPEC-079 fica
**reservada** à camada de decais do Lote 2; SPEC-080 é a das HQs): `SPEC-130`, `EVID-166`,
`PLAN-063`, `ART-PROMPTS-057`, `ART-036`, `MEC-048`, `BUG-030`, `BAL-021`, `IN-058`, `TOOL-005`, jogador `T05`. `tools/backlog_check.ps1` confere se esta linha está atrasada.

**Colisões históricas** (não renomear; usar o nome completo do arquivo ao
citar): SPEC-047/048/049/050/054/055 têm dois arquivos cada; EVID-018, 077, 079,
080, 087, 088, 098, 099 idem; PLAN-016, 023, 035, 041 idem. Daqui pra frente, antes
de criar qualquer número novo, confira o próximo livre acima e atualize-o.
