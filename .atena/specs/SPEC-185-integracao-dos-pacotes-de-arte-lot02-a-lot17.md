---
id: "SPEC-185"
title: "Integração dos pacotes de arte do ChatGPT (LOT02 a LOT17, FILA029/030/032)"
status: "IMPLEMENTADA localmente em 2026-10-18 (B-001 a B-003); B-004 (heróis) devolvido ao PLAN-103 (EVID-272)"
origin: planned
implementation_preceded_spec: false
request_classification: PLAN_DEVIATION   # PLAN-103 em B-002/S-008; dono: "fazer agora e voltar" e "por plano" em 2026-10-17
created: "2026-10-17"
revision: "r1 (2026-10-17)"
relations: ["[[PLAN-103]]", "[[PLAN-107]]", "[[ART-033]]", "[[BUG-027]]", "[[SPEC-121]]"]
content_state: DRAFT   # pacotes DRAFT com aceite visual de direção; admissão no runtime é este escopo; sem promoção a CANON
---

# SPEC-185 — Integração dos pacotes de arte (LOT02 a LOT17)

## Origem

Branch `codex/art-production-lot12-14-2026-10-17` (worktree Codex `abde`, commit `89a83520`; publicada em `origin`).
Entrega única: `.atena/generated/asset-production-handoff-2026-10-17/ENTREGA-PARA-CLAUDE.md` (19 pacotes DRAFT, ~190 PNGs de fonte,
~390 quadros de QA, 0 divergência de hash segundo o relatório do Codex). A branch **não é mesclada**: `plan.yaml` dela diverge em 973 linhas.
Os arquivos necessários são copiados de lá, com SHA-256 conferido contra os manifestos, como nas integrações anteriores.

## Regras

- Escopo executável e backup por lote; nenhuma retenção técnica é liberada por outra versão ter aceite visual.
- Raster só muda em preparação técnica (alfa, recorte, grade, escala) documentada; direção, silhueta e paleta ficam como aceitas.
  Derivadas que mudem a direção pedem aceite do dono.
- Cada lote: inventário do consumidor, importação, suíte, smoke das nove fases e captura em janela real.
- Mudança de arquitetura, dependência, CANON, build e exportação continuam fora; commit e push só com ordem própria.
- Outras sessões: preservar intocado. FILA031 não existe como arquivo (reserva do M1 do Durvall).

## Ordem aprovada (rota: fazer agora e voltar; aprovação: por plano)

| Lote | Pacotes | Observação |
|---|---|---|
| B-001 UI | FILA029 (botão JOGAR B01 v03), LOT02 (UI01 a UI04, PR01), FILA030 (névoa preparada) | barra de progresso mantém os 4 px (SPEC-163); layout não cresce por conta própria |
| B-002 Interações e cenário | LOT03 a LOT12 | retenções LOT06/07/11; LOT08 e LOT12 propõem substituições a comparar |
| B-003 Chefes e atores | LOT13 (Juiblex), LOT14 (Mímico e Turíbulo) | corrigir registro e escala antes de importar |
| B-004 Heróis | LOT15 a LOT17 (costas e oito direções, Durvall) | depende do PLAN-103/M1 e BUG-027; P9 retida; não fecha o BUG-027 |
| FILA032 | Logotipo | já admitido pelo PLAN-109 (EVID-267); só conferir se a branch traz revisão diferente |

Parada obrigatória: qualquer retenção técnica sem decisão, ou fonte que exija nova geração. Playtest humano segue pendente (roteiro antes de cada um).
