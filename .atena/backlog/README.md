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

## Fluxo

```
evidência / playtest / ideia → INBOX → triagem → ARTE | MECANICAS | BUGS
                                                      ↓
                                     lote → spec (SPEC-nnn) → EVID-nnn → fechado
```

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
- Defeito em algo que já deveria funcionar → **Bugs**, mesmo que a correção seja
  de arte (ex.: sprite transparente).

## Regras por trilha

### Arte & Áudio
- Todo prompt respeita o **Sabor Nottgard**: divindade/bioma envolvido, paleta
  ([RESEARCH-003](../vault/research/RESEARCH-003-paleta-das-deidades-2026-09-27.md)),
  bestiário ([RESEARCH-001](../vault/research/RESEARCH-001-abismo-bestiario-visual-2026-09-21.md)),
  sem inventar lore. Sem história: a lore é só sabor.
- Itens abertos acumulam até fechar um **lote**. O lote sai como um único
  `ART-PROMPTS-NNN` (próximo livre: **030**) para o gerador de imagem.
- Candidatos ficam em `.atena/generated/` até admissão explícita do dono.

### Mecânicas
- **Máximo de 2 mecânicas por lote de lançamento.**
- Cada mecânica: spec própria, teste em `tests/`, rodada do bot de balanceamento
  quando mexer em números, e nível de risco:
  **baixo** (só números em JSON) · **médio** · **alto** (nova forma de jogar).
- Mecânica nunca entra no mesmo commit que arte ou bug-fix (isola `git revert`).
- Só abre spec de mecânica com o **lote de bugs anterior fechado** e a
  verificação manual pendente feita.

### Bugs
- **P0** (crash, save corrompido, impede jogar): corrige na hora, não espera lote.
- **P1** (quebra uma função, tem contorno) e **P2** (cosmético): acumulam.
- Fecha o lote de bugs quando: (a) antes de exportar build de playtest, (b)
  antes de abrir mecânica nova, ou (c) ao acumular 5 ou mais P1.
- **Lembrete da Atena:** no início de cada sessão e antes de export/commit ela
  informa quantos P0/P1 estão abertos e há quanto tempo.

## Ordem de lançamento

1. Bug-fix → 2. Arte & Áudio → 3. Mecânicas — cada um em commit separado.

## Numeração

Próximos livres (2026-09-29, após EVID-108): `SPEC-081` (SPEC-079 fica
**reservada** à camada de decais do Lote 2; SPEC-080 é a das HQs), `EVID-110`,
`PLAN-041`, `ART-PROMPTS-030`, `ART-018`, `MEC-026`, `BUG-016`, `IN-040`, jogador `T04`.

**Colisões históricas** (não renomear; usar o nome completo do arquivo ao
citar): SPEC-047/048/049/050/054/055 têm dois arquivos cada; EVID-018, 077, 079,
080, 087, 088, 098, 099 idem; PLAN-016, 023, 035 idem. Daqui pra frente, antes
de criar qualquer número novo, confira o próximo livre acima e atualize-o.
