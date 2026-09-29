---
id: "PLAN-037"
title: "Organização do trabalho em três trilhas (Arte & Áudio, Mecânicas, Bugs)"
status: "aprovado pelo dono em 2026-09-29; backlogs semeados"
created: "2026-09-29"
relations:
  - "[[PLAN-034-pendencias-restantes-2026-09-28]]"
  - "[[PLAN-033-checklist-consolidado-pre-playtest-2026-09-28]]"
  - "[[PLAN-036-playtest-primeira-vez-guia-autossuficiente-2026-09-29]]"
---

# PLAN-037 — Organização do trabalho em três trilhas

## Contexto

Em 2026-09-29 `.atena/` tinha 624 arquivos organizados por **tipo de
documento** (specs, evidências, planos, canon). Pendências e bugs estavam
espalhados por PLAN-029 a 036 e por notas de QA; não havia um lugar único para
"o que está aberto". O dono propôs dividir as próximas atualizações por **tipo
de trabalho**.

## Decisões do dono (2026-09-29)

1. Três trilhas: **Arte** (assets, templates, layouts, backgrounds, prompts),
   **Mecânicas** (o que afeta a gameplay) e **Bug-fix** (acumular e corrigir em
   lote, com lembrete da Atena).
2. **Áudio entra junto com Arte** (trilha "Arte & Áudio").
3. **Limite de 2 mecânicas por lote de lançamento.**
4. A estrutura é uma camada por cima do ADD: nenhum arquivo existente é movido
   ou renomeado (os `[[wikilinks]]` dependem dos nomes atuais).

## Entregue

- `.atena/backlog/` com `README.md`, `INBOX.md`, `ARTE.md`, `MECANICAS.md` e
  `BUGS.md`, semeados apenas com o que estava aberto.
- Tabela de colisões históricas de numeração e "próximos livres" no README.
- Política de lotes registrada em `.atena/add.yaml` (bloco `backlog`).

## Regras

| Trilha | Regra |
|---|---|
| Arte & Áudio | Itens acumulam até fechar um lote; o lote sai em um único `ART-PROMPTS-NNN` (próximo: 025), com checklist de Sabor Nottgard. Candidatos ficam em `.atena/generated/` até admissão explícita. |
| Mecânicas | Máx. 2 por lote; spec própria, teste em `tests/`, bot de balanceamento se mexer em números; risco baixo/médio/alto; nunca no mesmo commit de arte ou bug-fix; só abre com o lote de bugs anterior fechado. |
| Bugs | P0 corrige na hora; P1/P2 acumulam. Fecha o lote antes de export de playtest, antes de mecânica nova, ou ao acumular 5 ou mais P1. |

Ordem de lançamento: **Bug-fix → Arte & Áudio → Mecânicas**, um commit por
trilha.

## Rotina da Atena

- No início de cada sessão e antes de export ou commit: ler `BUGS.md` e informar
  P0/P1 abertos e há quanto tempo.
- Toda evidência ou nota nova entra no `INBOX.md` e é triada para uma trilha.
- Ao criar SPEC, EVID, PLAN ou ART-PROMPTS, atualizar os "próximos livres" do
  README do backlog.

## Achados da semeadura

- Nenhum defeito **confirmado** aberto; há dívida de verificação manual das
  SPEC-059, 060, 063, 064, 072, 073, 074 e 075 (BUG-003 a 010).
- Zumbi v01 sem captura em run real (BUG-001); auditoria de opacidade do
  Sacerdote da Mente Derretida pendente (BUG-002).
- Cinco mecânicas abertas (MEC-001 a 005) e sete itens de arte/áudio (ART-001 a
  007), com itens marcados "a confirmar".

## Lotes sugeridos

- Bugs: rodar o roteiro do PLAN-033 antes de exportar novo playtest.
- Mecânicas: M1 = MEC-001 + MEC-002 (baixo risco); M2 = MEC-004 + MEC-005 só
  depois dos dados do playtest público; MEC-003 em M3.
- Arte: A1 = ART-002 + ART-003 + ART-007 (layout e legibilidade de UI).

## Limites

- Este plano não abre spec nem altera arquivos de jogo.
- Nenhum commit foi feito; `git.local_commits` segue sob aprovação explícita.
