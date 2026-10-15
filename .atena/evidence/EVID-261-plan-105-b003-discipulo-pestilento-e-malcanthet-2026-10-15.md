---
id: "EVID-261"
title: "PLAN-105 B-003: mecânicas do Discípulo Pestilento (Feng-tu) e de Malcanthet (Shendilavri)"
created: "2026-10-15"
relations: ["[[PLAN-105-mecanicas-dos-outros-chefes-2026-10-15]]", "[[EVID-260-plan-105-b002-zuggtmoy-e-molydeus-2026-10-15]]", "[[EVID-259-plan-105-b001-verbos-novos-das-mecanicas-de-chefe-2026-10-15]]"]
content_state: DRAFT
---

# EVID-261 — PLAN-105, lote B-003 (aprovação por lote; gate G-L5-2 aprovado em 2026-10-15; sem commit)

## O que mudou
| Chefe (ordem, orçamento) | Fase de 70% | Fase de 35% (troca o conjunto) |
|---|---|---|
| **Discípulo Pestilento** (Feng-tu, 5, orçamento 3) | **Quadrantes de peste** (2 acesos, 2d6, poça) **e Marca da peste** (segue 2 s, trava 1 s, 2d6, poça), até 2 ao mesmo tempo; `skip` das poças soltas antigas | **Grito na mente** interrompível (3d8, a cada 15 s) **e 4 Cultistas da Peste** com o chefe imune até caírem; `skip` do anel antigo de 16 projéteis |
| **Malcanthet** (Shendilavri, 6, orçamento 4) | **4 Ilusões da Rainha** (30 PV, chefe imune até caírem) **e Marca** (2d6); `skip` do invocar antigo de 6 ilusões | **Beijo da Rainha** interrompível (3d6) **e varredura de um lado só** (o chifre perdido, 2d6, 2,8 s); `skip` do invocar de 3 súcubos |

Código: o verbo de imunidade ganhou `hp` e `name` dos servos (ilusões de 1 PV deixariam a imunidade de 1 s). O resto é dado em `data/boss_mechanics.json`.

## Verificação
- `tests/test_l5_b003_bosses.gd`: orçamentos (3 e 4); substituição das ações antigas (poças, anel, invocares); quadrantes e marca juntos sem estourar o orçamento; 4 cultistas nomeados e chefe imune; 4 ilusões de 30 PV; conjuração e varredura de 1 feixe. **4 mutações** (sem `skip` do anel, ilusão sem `hp`, 2 feixes, sem marca) falham no ponto certo; restaurado, passa. Suíte completa: **0 falhas**.
- Capturas em janela real (`tools/capture_l5_b003.tscn`, `.atena/generated/mariz-playtest/l5_b003_*.png`).

## Medição (`tools/probe_boss_fight.gd`, herói que se desvia, curado a cada passo, 6 sementes, teto de 300 s)
**Ajustes da própria sonda neste lote** (`bot-b003/`): os dois chefes **mantêm distância** (`move: keep`) e a sonda de corpo a corpo quase nunca os acertava; as ondas do L2 durante o chefe enchiam a tela de inimigos e a mira automática não chegava ao chefe (`sem_campo`); as lutas tardias passam de 300 s (`pv_do_chefe` fixado em 2500). A tabela vale **só** para a leitura da mecânica; use **armas à distância** (Kayron).

| Camada | Chefe | Lutas terminadas | Duração média | Dano médio recebido |
|---|---|---|---|---|
| 1 (dano +100%, PV +60, CA +4) | Discípulo | 1/6 → **0/6** | 298 s → 293 s | 241 → **293** |
| 1 | Malcanthet | 6/6 → **3/6** | 125 s → 157 s | 238 → 241 |
| 2 (dano +200%, PV +100, CA +6) | Discípulo | 6/6 → **5/6** | 152 s → **254 s** | 166 → **510** |
| 2 | Malcanthet | 6/6 → **6/6** | 82 s → 121 s | 141 → **224** |

**Leitura honesta**
- **Malcanthet** ficou no ponto: a luta dura ~50% mais e custa ~60% mais vida (camada 2); na camada 1 cai de 6/6 para 3/6.
- **Discípulo** ficou **duro**: o dano recebido triplica (166 → 510) e a luta dura 67% mais. Se pesar: o `cd` da marca de 14 para 18 s, os `lit` dos quadrantes de 2 para 1, ou o `dice` do Grito de `3d8` para `2d8`.
- Como no B-002, o desvio da sonda é fraco; trate o número como **teto de ameaça**. 6 execuções por célula, herói sintético, sem a régua de 12 heróis.
- `bot_curva` não serve para estes mapas (o herói de nível 1 morre antes do chefe), como no EVID-260.

## Gate G-L5-3 (seu)
Jogar Feng-tu e Shendilavri até o chefe e dizer:
1. **Discípulo:** quadrantes e marca ao mesmo tempo (orçamento 3) são claros? O Grito na mente com 4 cultistas é demais para o mapa 6?
2. **Malcanthet:** as ilusões de 30 PV deixam o chefe imune por tempo certo? O Beijo da Rainha e a varredura de um lado só ficam legíveis com 4 mecânicas permitidas?
3. **Caos:** o orçamento 4 em Shendilavri está "caótico na medida"?

## Pendências
- B-004 (Socothbenoth e A Síntese Abissal) só com o seu gate.
- Arte e som próprios dos servos e das ilusões: ART-049 (arte provisória de ilusão do mapa).
- Sem commit (B-001, B-002 e B-003 acumulam).
