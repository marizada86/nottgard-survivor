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
| [RELEASES.md](RELEASES.md) | Quadro de versões de playtest: conteúdo, "o que testar", checklist | — |

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

### Arte & Áudio
- Todo prompt respeita o **Sabor Nottgard**: divindade/bioma envolvido, paleta
  ([RESEARCH-003](../vault/research/RESEARCH-003-paleta-das-deidades-2026-09-27.md)),
  bestiário ([RESEARCH-001](../vault/research/RESEARCH-001-abismo-bestiario-visual-2026-09-21.md)),
  sem inventar lore. Sem história: a lore é só sabor.
- Itens abertos acumulam até fechar um **lote**. O lote sai como um único
  `ART-PROMPTS-NNN` (próximo livre: **032**) para o gerador de imagem.
- Candidatos ficam em `.atena/generated/` até admissão explícita do dono.

### Mecânicas
- **Sem limite de mecânicas por versão de playtest** (decisão do dono,
  2026-09-29: builds com mais conteúdo empolgam os testers). O que vale é **uma
  spec, um teste e um commit por mecânica** e a lista "O que testar" em
  [RELEASES.md](RELEASES.md). O antigo limite de 2 fica como sugestão de prudência
  para mecânicas de risco **alto**.
- Cada mecânica: spec própria, teste em `tests/`, rodada do bot de balanceamento
  quando mexer em números, e nível de risco:
  **baixo** (só números em JSON) · **médio** · **alto** (nova forma de jogar).
- Mecânica nunca entra no mesmo commit que arte ou bug-fix (isola `git revert`).
- O portão "bugs fechados antes de mecânica" está **dispensado**: a verificação
  acontece no próximo playtest (ver ciclo de vida acima).

### Bugs
- **P0** (crash, save corrompido, impede jogar): corrige na hora, não espera lote.
- **P1** (quebra uma função, tem contorno) e **P2** (cosmético): acumulam.
- O lote de bugs fecha no **próximo playtest com versão nova** (regra do dono).
  O gatilho de 5 ou mais P1 continua servindo de **aviso**, não de bloqueio.
- Verificação manual pendente (BUG-003 a 010) não conta como defeito: é dívida
  a pagar no playtest.
- **Lembrete da Atena:** no início de cada sessão e antes de export/commit ela
  informa quantos P0/P1 estão abertos, rodando
  `powershell -ExecutionPolicy Bypass -File tools/backlog_check.ps1`. Um hook de
  início de sessão (`.claude/settings.json`) roda a versão curta sozinho.

### Balanceamento
- Um cartão por entidade e sintoma (herói forte demais, item fraco, economia sobrando...),
  acumulando relatos por tester, medições do bot e leitura dos dados.
- Decide-se com **duas fontes independentes** (ou jogador + bot); relato único fica em
  observação. Sinais que divergem por herói pedem o bot por herói antes de mexer em
  número global.
- Uma alavanca por vez por entidade, anotando **antes → depois** no cartão.
- Medição: `tools/bot.gd` (comando em [BALANCEAMENTO.md](BALANCEAMENTO.md)).

### Ferramentas e build
- Tudo que não é arte, mecânica nem bug (kit de evidência, CI, scripts, export)
  vai em [FERRAMENTAS.md](FERRAMENTAS.md).
- Build de playtest sempre com `tools/stamp_build.ps1` (o CI já faz) para gravar o
  commit no rodapé, no log e nas notas.

### Perguntas para os testers
- Dúvidas sobre um relato **não bloqueiam** nada: ficam em "Perguntas para o
  próximo playtest" no [INBOX](INBOX.md) e entram no questionário seguinte.

## Ordem de lançamento

1. Bug-fix → 2. Arte & Áudio → 3. Mecânicas → 4. Balanceamento — cada um em commit
separado (uma mecânica por commit; números por entidade). Balanceamento vem por
último para calibrar o conteúdo final da versão, com o bot rodando nele. A versão de playtest junta tudo (ver [RELEASES.md](RELEASES.md)).

## Numeração

Próximos livres (2026-09-29, após EVID-112): `SPEC-095` (SPEC-079 fica
**reservada** à camada de decais do Lote 2; SPEC-080 é a das HQs), `EVID-113`,
`PLAN-044`, `ART-PROMPTS-032`, `ART-023`, `MEC-028`, `BUG-016`, `BAL-010`, `IN-040`, `TOOL-004`, jogador `T04`. `tools/backlog_check.ps1` confere se esta linha está atrasada.

**Colisões históricas** (não renomear; usar o nome completo do arquivo ao
citar): SPEC-047/048/049/050/054/055 têm dois arquivos cada; EVID-018, 077, 079,
080, 087, 088, 098, 099 idem; PLAN-016, 023, 035, 041 idem. Daqui pra frente, antes
de criar qualquer número novo, confira o próximo livre acima e atualize-o.
