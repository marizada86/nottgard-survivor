---
id: "PLAN-038"
title: "Atualização do jogo com base nos playtests T01, T02 e T03"
status: "aprovado pelo dono em 2026-09-29 (D1 a D4 = recomendações); Etapa 1 implementada, Etapa 0 e Etapa 2 em andamento"
created: "2026-09-29"
relations:
  - "[[EVID-106-playtest-publico-t01-higor-2026-09-29]]"
  - "[[EVID-107-playtest-publico-t02-hiago-2026-09-29]]"
  - "[[EVID-108-playtest-publico-t03-dna-2026-09-29]]"
  - "[[PLAN-033-checklist-consolidado-pre-playtest-2026-09-28]]"
  - "[[PLAN-037-organizacao-do-trabalho-em-tres-trilhas-2026-09-29]]"
---

# PLAN-038 — Atualização pós-playtests (T01, T02, T03)

## Objetivo

Sair da versão `0.1.0` (Playtest Público) para uma versão que **corrija o que
três jogadores confirmaram**, **deixe a interface honesta** (o jogador entende
o que escolhe) e só então **mude regras**. Segue a ordem do PLAN-037:
**Bug-fix → Arte & Áudio → Mecânicas**, um commit por trilha, no máximo 2
mecânicas por lote de lançamento.

## Base de evidência (3 jogadores, ~4 h de jogo, 0 crash)

| Fato | Fonte |
|---|---|
| Nenhum erro ou aviso nos logs; sessões de 56 min a 1 h 30 | EVID-106/107/108 |
| **Confirmado por 2 ou mais jogadores:** BUG-012 (3 de 3), BUG-013 (3 de 3, 3 biomas), ART-009 (T01 + T02) | EVID-107/108 |
| **Confirmado por print + código:** BUG-015, MEC-023, ART-016 | EVID-107/108 |
| **Contestado:** BUG-014, MEC-012, ART-010 (um jogador discorda) | EVID-108 |
| **Pedido mais repetido:** MEC-019, comparação de equipamento (5 relatos) | EVID-091/107 |
| **Prioridade acumulada nº 1:** pergunta 9, jogar mais rápido em mapas vencidos (MEC-010) | EVID-107/108 |
| Dificuldade: T03 quer mais mobs, mais dano e menos PV no início; T02 aparece com PV baixo em Dagruve | EVID-107/108 |

Limite honesto: os três jogadores conhecem jogos do gênero, e dois deles têm
relação com o dev. Serve para priorizar, não para decidir design final.

## Decisões do dono (aprovadas em 2026-09-29: seguir todas as recomendações)

| # | Decisão | Recomendação da Atena |
|---|---|---|
| **D1** | **Regra do ritual (BUG-014):** (a) dar recompensa ao interromper; (b) manter como está e explicar melhor na tela; (c) adiar | **(a)**, mas **fora** do lote de bugs: muda regra e mexe em dificuldade. Reclassificar para `MEC-026` e testar junto de MEC-024 com o bot. Na `v0.1.1` só melhorar o texto do aviso |
| **D2** | **Quantas versões:** uma só (`0.2.0`) ou duas (`0.1.1` de correção e `0.2.0` de mecânicas) | **Duas.** A `0.1.1` sai cedo, valida as correções com Hiago e DNA e não carrega risco de balanceamento |
| **D3** | **Dificuldade (MEC-024):** DNA respondeu "mais mobs, mais dano e menos PV". Aceitar os três ou começar por um | Começar só por **mais mobs** no início (menos invasivo), medir com o bot por herói, e só então mexer em dano/PV |
| **D4** | **Geração de imagens da `0.1.1`:** liberar o lote `ART-PROMPTS-025` (props de loja/ferreiro/curandeiro e ímã de XP) | Liberar. Se não der para gerar a tempo, a `0.1.1` sai sem os assets e eles vão para a `0.2.0` |

## Versão `0.1.1` — "Correção e clareza"

### Etapa 0 — Portão de verificação (antes de tudo)

Regra do backlog: não abrir mecânica e não exportar playtest com dívida de
verificação. Uma **única run QA** com o roteiro do PLAN-033 cobre
BUG-001, 003, 004, 005, 006, 007, 008, 009, 010 (e a auditoria do BUG-002).
Cada falha vira `BUG-nnn` novo. **Saída:** tabela de "passou/falhou" no EVID
seguinte (`EVID-110`). Sem isso, a Etapa 1 corre risco de consertar em cima de
algo já quebrado.

### Etapa 1 — Lote de bugs (commit 1)

| Ordem | Cartão | O que fazer | Esforço | Teste |
|---|---|---|---|---|
| 1 | **BUG-015** (P1) | Prévia do ferreiro e da loja deve mostrar os mods **já escalados** (+15 % por nível, `Items.level_scale`); tratar o arredondamento de inteiros pequenos (`Hero.cam()` faz `int()`), por exemplo somando antes de truncar ou exibindo décimos. Revisitar a "escala" das armas (`cd -0.6`, `mark +0.1`) para o texto trazer unidade | baixo | `tests/`: prévia Nv+1 ≠ atual; CAM +1 com nível 2 e 3 |
| 2 | **BUG-012** (P1) | Inimigos que encostam em objeto devem **deslizar** (mover pelo eixo livre) e voltar a perseguir; medir em Durão, Docas e Dagruve | médio | teste de movimento com obstáculo; bot sem regressão de tempo de run |
| 3 | **BUG-013** (P2, 3 biomas) | Achar quais props flutuam (sombra descolada; ver print 003 de EVID-108) e corrigir âncora/offset/sombra. Relaciona-se com SPEC-041 e SPEC-042. **Não** é ambientação nova (isso é ART-012) | médio | auditoria de âncora por prop; captura antes/depois |
| 4 | **BUG-011** (P1) | Espelho de Shendilavri dentro da área andável e interagível | baixo | teste: todo objeto interativo dentro da área andável |
| 5 | Novos da Etapa 0 | Conforme o resultado da run QA | — | — |

**Fora do lote:** BUG-014 (aguarda D1), BUG-013 de ambientação (ART-012).
**Critério de saída:** suíte e smoke verdes, `BUGS.md` sem P1 confirmado aberto.

### Etapa 2 — Lote de arte e UI (commit 2)

| Cartão | O que fazer | Origem da geração |
|---|---|---|
| **ART-016** | Cor de raridade nas ofertas de item, loja e forja. **Tirar o verde fixo** do item novo (`ui/hud.gd`), que hoje empurra a troca de raro por comum | só código/UI |
| **ART-017** | Trocar "redução" por "redução de dano" e revisar os demais rótulos de atributo | só texto |
| **ART-009** | Assets distintos para **loja, ferreiro e curandeiro** no mapa (hoje "algo apareceu no mapa") | `ART-PROMPTS-025` |
| **ART-015** | Ímã de XP mais evidente (pickup e efeito) | `ART-PROMPTS-025` |
| Texto do ritual | Deixar claro na tela o que acontece ao interromper (aviso já existe; só melhora o texto) | só texto |

Regras: cada prompt cita divindade/bioma, paleta (RESEARCH-003) e bestiário
(RESEARCH-001), sem lore inventada. Candidatos ficam em `.atena/generated/`
até admissão explícita; não entra asset sem aprovação do dono. **Adiados de
propósito:** ART-010 (contestado), ART-011 (depende de MEC-013), ART-012 (lote
grande), ART-013/014 (dependem de mecânicas).

### Etapa 3 — Fecho e export `0.1.1`

1. Atualizar `core/version.gd` e as seis linhas de `export_presets.cfg`
   (`file_version`, `product_version`) para `0.1.1`.
2. Suíte + smoke + rodada curta do bot por herói (Brook, Bromnor, Kayron).
3. Export do build de playtest e envio a **Hiago e DNA** com um roteiro de 15
   minutos para conferir só: prévia do ferreiro, inimigos deslizando, props no
   chão, cor da raridade. Sem questionário novo.
4. Commits separados: `fix:` (Etapa 1), `feat(arte):` (Etapa 2), `chore:`
   (versão). **Sem commit sem aprovação do dono.**

## Versão `0.2.0` — "Decisões mais claras" (só depois da `0.1.1` fechada)

Lote **M1** (2 mecânicas, mesma tela, sem mexer em números):

| Cartão | Mecânica | Risco |
|---|---|---|
| **MEC-019** | Comparação de equipamento na loja, forja e oferta de item: slot ocupado marcado, diferença de atributos (ganha/perde) e detalhe ao passar o mouse. Absorve MEC-006. **Pedido mais repetido (5 relatos)** | médio |
| **MEC-023** | Loja e ferreiro mostram **todas** as opções (as sem moeda esmaecidas, com preço) e explicam quando não há nada a comprar/melhorar | baixo |

Cada uma com spec própria (`SPEC-081`, `SPEC-082`), teste em `tests/`, e
**nenhuma no mesmo commit de arte ou bug**. Depende de ART-016 e ART-017
(já entregues na `0.1.1`).

Critério de aceite da `0.2.0`: um jogador novo consegue dizer, na tela de
oferta, **o que ganha e o que perde** ao trocar; nenhum caso de oferta de item
mostra o item novo em destaque enganoso.

## Depois (não entra nas versões acima)

| Lote | Conteúdo | Por que espera |
|---|---|---|
| **M2** (`0.3.0`) | MEC-024 (dificuldade e mobs no início) + MEC-026 (regra do ritual, se D1 = a) | Muda balanceamento; exige rodada do bot **por herói** e mais jogadores. Dificuldade é o pedido mais delicado: os sinais divergem entre T02 e T03 |
| **M3** | MEC-010 (2x em mapas vencidos, evento de tempo, menos espera entre mapas) | **Prioridade nº 1 do questionário**, mas risco alto (mexe no ritmo do jogo). Merece spec própria e uma versão só dela |
| Baixo risco, quando sobrar espaço | MEC-020 (fontes), MEC-022 (INT do Estige com prazo), MEC-007 (quebráveis) | Só números em JSON; nunca dois lotes juntos por causa do limite de 2 |
| Contestados | MEC-012 (mapas), ART-010 (level-up) | 1 discorda; pedir mais amostra antes de gastar |
| Grandes | ART-012, ART-013, MEC-015, MEC-016 | Dependem de conteúdo novo e de recomendações da Atena |

## Riscos

1. **Regressão do bot ao mexer em movimento (BUG-012).** Mitigação: comparar
   tempo de run e abates antes e depois em três heróis.
2. **Dívida de verificação escondendo bug antigo.** Mitigação: Etapa 0 obrigatória.
3. **Geração de imagens atrasar a `0.1.1`.** Mitigação: D4; a versão sai sem
   os assets e eles seguem para a `0.2.0`.
4. **Amostra pequena e enviesada.** Mitigação: só corrigir o que tem 2 ou mais
   jogadores ou prova em print/código; o resto fica em backlog.
5. **Dificuldade divergente entre heróis** (Kayron sem dano, Brook e Bromnor
   com PV baixo no começo). Mitigação: M2 só com dados do bot por herói.

## Andamento (2026-09-29)

| Etapa | Situação |
|---|---|
| 0 — run QA | **Pendente, depende do dono** (jogo interativo). Roteiro pronto em [[PLAN-039-roteiro-run-qa-para-versao-0-1-1-2026-09-29]] |
| 1 — BUG-015, 012, 013, 011 | **Implementado**, suíte e smoke verdes, sem commit. Falta verificar em run real (ver BUGS.md). O portão da Etapa 0 vale para **fechar o lote e exportar**, não para começar correções já confirmadas |
| 1 — descobertas | BUG-012 tinha causa dupla: restrição do Estige aplicada aos inimigos + obstáculo redondo sem contorno. BUG-013: 29 fichas de props com contato acima da base; 17 corrigidas, 12 planos aguardam olho humano |
| 2 — arte/UI | **Implementado** o que é código: ART-016 (cor de raridade), ART-017 ("redução de dano"), rótulo e cor provisórios de loja/ferreiro/curandeiro e ferradura provisória do ímã. **Prompts das imagens já existem** (ART-PROMPTS-025 e 026, criados em paralelo); falta o dono gerar, aprovar e admitir |
| 3 — versão 0.1.1 | Depois da Etapa 0 |

## Ordem de execução e portões

```
Etapa 0  run QA (PLAN-033)          → EVID-110
   ↓ portão: sem P0; falhas viram BUG
Etapa 1  lote de bugs               → commit 1
   ↓ portão: suíte + smoke verdes
Etapa 2  lote de arte/UI            → commit 2   (depende de D4 para as imagens)
   ↓
Etapa 3  versão 0.1.1, export       → re-teste curto com Hiago e DNA
   ↓ portão: lote de bugs fechado
0.2.0    M1 = MEC-019 + MEC-023     → specs 076 e 077, commit 3
```

## Limites

- Este plano **não** altera arquivos do jogo, não abre spec e não faz commit.
- Numeração usada: `PLAN-038`. Reservados: `EVID-110` (run QA), `SPEC-081` e
  `SPEC-082` (M1), `ART-PROMPTS-025`, `MEC-026` (se D1 = a).
