---
id: "EVID-254"
title: "L2: campo vivo com o chefe, PV do chefe com o poder do herói, corrosão da poça e da névoa"
created: "2026-10-14"
relations: ["[[EVID-250-relato-t05-mariz-v040-2026-10-14]]", "[[EVID-252-avaliacao-medida-do-relatorio-t05-mariz-2026-10-14]]", "[[EVID-253-l1-evolucao-troca-de-item-e-guardiao-2026-10-14]]", "[[AVALIACAO-playtest-t05-mariz-v040-2026-10-14]]"]
cards: ["IN-091", "IN-093", "IN-087", "IN-090", "BAL-001", "BAL-004", "BAL-028"]
content_state: DRAFT
---

# EVID-254 — Lote L2 (aprovado pelo dono em 2026-10-14, com testes, sem commit)

Origem: [EVID-252](EVID-252-avaliacao-medida-do-relatorio-t05-mariz-2026-10-14.md) §4.2 e §7. Tudo o que o L2 faz fica **atrás de um interruptor**: `l2.enabled` em `data/difficulty.json`. Com `false` o jogo volta exatamente à regra anterior (foi como medi o "antes").

## O que mudou
| Item | Regra nova | Parâmetros (`data/difficulty.json` → `l2`) | Código |
|---|---|---|---|
| Campo vivo | Com o chefe vivo, as ondas da **segunda metade da fase** (as com `t1` ≥ 60% da duração) continuam a **40%** do ritmo e do teto de cada uma, respeitando o teto da fase. Antes: 1 inimigo da 1ª onda a cada 3,5 s | `field.rate` 0,4 | `core/battle.gd` `_director`, `boss_field_rate` |
| PV do chefe | `PV × (1 + min(0,8; 0,04 × (nível − 6) + 0,35 × dmg_pct))`. Um herói de nível 6 ou menos, sem bônus de dano, encontra o PV de antes | `boss_power` | `boss_power_factor`, ponto de nascimento do chefe |
| Poça | Além de `2 + tier`, tira **1,5% do PV máximo** por tique (0,9 s) e **suspende a regeneração passiva** enquanto estiver nela (e por 0,6 s depois) | `corrosion.puddle_pct_max_hp`, `corrosion.linger` | zona `puddle`, `_corroded_t` |
| Névoa de borda | Suspende a regeneração passiva na faixa de borda; a rampa final sobe de 9% para **12%** do PV por segundo (início continua 3%) | `corrosion.edge_max_dps_pct` | `_update_edge_fog` |

Poção, bênção ativa, roubo de vida e cura de itens **não** são suspensos.

## Verificação
- **Testes:** `tests/test_l2_boss_field_and_corrosion.gd` (campo com e sem L2, PV do chefe novato × forte × teto, poça com e sem regeneração, borda no máximo e regeneração suspensa). `tests/test_fog_edge.gd` e a contagem de `tests/test_abyss_marks.gd` passam a medir a **regra base** (L2 desligado durante o teste): a poça de 1,5% do PV máximo matava o herói de 999999 PV do teste de densidade. Suíte completa: **0 falhas**.
- **Interruptor:** `tools/bot_curva.gd` ganhou o 8º argumento (`0` desliga o L2) e `tools/probe_boss_ttk.gd` o 6º.

### Herói parado ao lado do chefe, nível 12, armas nível 4 (sonda, `probe_boss_ttk`)
| Camada de meta | Fase | PV do chefe antes → depois | Resultado antes | Resultado depois |
|---|---|---|---|---|
| dano +200%, PV +100, CA +6 | Dagruve | 260 → **468** | cai em 11,2 s, herói com 65% mín. | cai em **17,6 s**, herói com **37%** mín. |
| dano +200%, PV +100, CA +6 | Docas | 816 → 1469 | herói morre em 10,8 s | herói morre em 16,4 s |
| dano +100%, PV +60, CA +4 | Dagruve | 260 → 413 | herói morre em 16,5 s | herói morre em 15,7 s |
| dano +100%, PV +60, CA +4 | Goranthis | 7800 → 12402 | herói morre em 4,0 s | herói morre em 4,0 s |

Leitura: o primeiro chefe passa a custar **mais tempo e mais vida** a quem é forte (era o relato), e nos chefes tardios o herói parado já morria em segundos antes e continua morrendo.

### `bot_curva` antes e depois (lado 60, dt 0,08, 9 fases, 4 heróis × 6 sementes, metas 0 e 1)
Tabela completa em `.atena/generated/mariz-playtest/bot/resumo-l2.md`; CSV por herói na mesma pasta.

| | Fases alcançadas por execução (média) |
|---|---|
| meta 0, antes → depois | 1,71 → 1,88 |
| meta 1, antes → depois | 1,79 → 1,83 |

| Dagruve (a fase com amostra) | antes | depois |
|---|---|---|
| passou, meta 0 / meta 1 | 42% / 54% | 42% / 54% |
| morreu, meta 0 / meta 1 | 58% / 46% | 58% / 46% |
| chefe caiu em, meta 0 | 574 s (n 10) | **886 s** (n 10) |
| chefe caiu em, meta 1 | 513 s (n 13) | **836 s** (n 13) |

**Leitura honesta**
- **Não pune o bot:** a taxa de passar ou morrer não mudou na Dagruve e as fases alcançadas ficaram iguais ou subiram. As fases 3 em diante têm 1 a 8 execuções por célula, ou seja, **sem poder estatístico**; o `bot_curva` morre cedo (nível 3 a 5) e quase não chega a elas.
- **A luta do chefe fica mais longa para o bot:** 574 → 886 s na Dagruve. O PV do chefe não explica (o bot está abaixo do nível 6, fator 1,0); a causa é o campo vivo: mais inimigos disputando o alvo e a atenção do bot. Esse tempo absoluto é artefato do bot, que luta mal; **o sinal é a variação (+50%)**.
- **A régua do veterano (BAL-028) não foi refeita** com 12 heróis e 15 sementes (EVID-225); isso custa horas. Esta rodada serve de alarme, não de aceite.

## Pendências e riscos
- **Subjetivo (humano):** sentir a luta do primeiro chefe com build forte (deveria durar uns 15 a 20 s e custar vida) e com build fraca (não deveria virar maratona). Se o campo vivo pesar, o botão é `field.rate` (0,4 → 0,3).
- A **poça** agora também castiga quem tem muito PV (1,5% do máximo). Combina com o pedido do Mariz; vale conferir bênçãos que dão "poça amiga" (continuam curando, não tomam dano).
- A **borda a 12%** com regeneração suspensa pode ser dura no modo de descida com Marcas; rodar a rodada de 12 heróis antes de qualquer release (EVID-225 é a base).
- Nada commitado; `core/battle.gd` e `data/difficulty.json` convivem com mudanças não commitadas de outras sessões.
