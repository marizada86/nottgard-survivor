# Inventário de planos e specs (PLAN-087 B-003)

Gerado em 2026-10-09, só leitura. Nada foi apagado, movido ou renomeado. Dados brutos das specs em `specs.tsv` (mesma pasta).

## Resumo

| Item | Total | Entregue (só rastro) | Esperando arte, aparelho ou dono | Vivo agora |
|---|--:|--:|--:|--:|
| Planos em `.atena/state/` | 35 | 21 | 10 | 4 |
| Specs em `.atena/specs/` | 163 | 131 | 26 (abertas, aprovadas sem fechar ou rascunho) | 6 (marcadas "em execução") |

O que dá a sensação de bagunça: **21 planos e 131 specs já estão entregues** e continuam lado a lado com os 4 planos vivos; vários trazem status velho; e há números repetidos.

## Planos (`.atena/state/`)

**Vivos (4):** PLAN-083 (fechar a 0.4.0), PLAN-085 (seta de evento; falta commit e playtest), PLAN-086 (Arlindo e Erik; falta commit; arte própria é ART-045), PLAN-087 (este).

**Esperando arte, aparelho ou dono (10):**

| Plano | Espera |
|---|---|
| PLAN-053 imagens | fila de imagens (arte) |
| PLAN-057 movimentação | gerador de imagem (BUG-027) |
| PLAN-062 dinamismo | B-006, registro de arte e áudio |
| PLAN-065 lettering e cursor | B-003 depende de arte |
| PLAN-066 corrida do Durvall | playtest do dono |
| PLAN-067 controles mobile | aceite em celular |
| PLAN-068 controles Xbox/PlayStation | aceite com controle físico |
| PLAN-071 playtest e ranking | aceite nos clientes finais (plano suspenso; volta após o PLAN-083) |
| PLAN-073 consolidação do push | ativos do piloto |
| PLAN-082 pixels soltos (BUG-029) | escolha visual do dono (pausado, não adotado) |

**Entregues, só rastro (21)** — candidatos a arquivar: 056\*, 059, 060, 061, 063, 064\*, 066-passo-pelas-sombras, 067-bau-mimico, 068-bau-e-portal, 069, 070, 072, 074, 075, 076, 077, 078, 079, 080, 081, 084.
\* Status velho: o `plan-056` diz `AWAITING_OWNER_REVIEW`, mas o git registra "close PLAN-056 (SPEC-122 accepted)" (63b6394); o `plan-064` diz `IMPLEMENTED_PENDING_COMMIT`, mas o SPEC-131 está commitado (1ef33bf, 9663f25).

## Specs (`.atena/specs/`)

**Status velho a corrigir** (o conteúdo já avançou, o cabeçalho não):

| Spec | Diz | Deveria dizer |
|---|---|---|
| SPEC-148 | planejada (aguarda início) | publicada na 0.4.0 (EVID-209), refeita em 2026-10-09 |
| SPEC-149, 150, 151, 152 | em execução | implementada local, aguarda playtest (EVID-205, EVID-206; SPEC-152 no PLAN-081 B-006) |
| SPEC-157 | planejada (v0.5.0) | executada; **não há 0.5.0**, tudo virou 0.4.0 |
| SPEC-119 | rascunho para aprovação | substituída pela SPEC-152 (piloto) e SPEC-157 (demais fases) |
| SPEC-158, 154 | ativa | 158: implementada local; 154: pausada (variante C não agradou) |

**Número repetido:** duas specs `SPEC-116` (`chao-de-dagruve-assado-procedural` e `dopamina-tematica`). Seis planos também repetem número (066, 067, 068 com dois arquivos).

**Esperando arte (rascunho ou aprovada sem fechar):** SPEC-061, 062, 069, 070, 071, 097, 098, 101, 103, 106, 107, 108, 110, 123 e o resto da lista de animação e props. Não entram neste plano.

## Proposta (você escolhe; nada é feito sem sua aprovação)

| Opção | O que faz | Risco | Esforço |
|---|---|---|---|
| **A. Índice do que está vivo (recomendada)** | Cria `.atena/state/INDEX.md` com as quatro tabelas acima (vivos, esperando, entregues). Nada muda de lugar, nenhum link quebra. | Nenhum | Baixo |
| **B. Corrigir status velhos** | Ajusta o cabeçalho das specs e planos da tabela acima (13 arquivos, só texto). | Baixo | Baixo |
| **C. Arquivar os 21 planos entregues** | Move para `.atena/state/arquivo/` e atualiza os caminhos citados em `plan.yaml`, cartões e specs. | Médio (links) | Médio |
| **D. Renumerar SPEC-116 duplicada** | A mais recente (`dopamina-tematica`) ganha número novo e as referências são atualizadas. | Médio (links) | Médio |

Recomendação: **A + B agora**; **C e D só se o índice não bastar**, porque mover ou renumerar mexe em dezenas de links e não ajuda a achar o que está vivo.
