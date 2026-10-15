---
id: "EVID-255"
title: "L3: número de dano em faixas, pausa de acerto em elite e chefe, dinâmica de som sem arquivo novo"
created: "2026-10-14"
relations: ["[[EVID-250-relato-t05-mariz-v040-2026-10-14]]", "[[EVID-252-avaliacao-medida-do-relatorio-t05-mariz-2026-10-14]]", "[[EVID-254-l2-campo-vivo-pv-do-chefe-poca-e-nevoa-2026-10-14]]", "[[SPEC-177-game-feel-e-apresentacao-marco-m2-do-plan-103]]"]
cards: ["IN-088", "IN-096", "MEC-031"]
content_state: DRAFT
---

# EVID-255 — Lote L3 (aprovado pelo dono em 2026-10-14, com testes, sem commit)

Origem: [EVID-252](EVID-252-avaliacao-medida-do-relatorio-t05-mariz-2026-10-14.md) §6: número de 14 px, som do acerto a -14 dB para tudo, pausa só no crítico. **Não usa arquivo de som novo** (o F-4/F-5 segue recusado).

## Regra nova (`core/damage_feedback.gd`, funções puras)
**Faixa do golpe (0 a 3):**
- *Comum:* a fração do PV não diz nada (morre em poucos golpes), então só o **crítico** sobe a faixa (mínimo 2).
- *Elite e chefe:* fração do PV máximo do alvo, ≥ 3% faixa 1, ≥ 8% faixa 2, ≥ 15% faixa 3; crítico soma 1 (mínimo 2).

| Faixa | Número | Volume do acerto | Tom | Pausa |
|---|---|---|---|---|
| 0 | 14 px (como antes) | -14 dB (como antes) | 1,00 | nenhuma |
| 1 | 18 px | -12 dB | 0,96 | nenhuma |
| 2 | 24 px | -10 dB | 0,90 | 0,03 s em elite/chefe |
| 3 | 30 px | -8 dB | 0,84 | 0,05 s em elite/chefe |

Crítico: +2 px, +1 dB; chefe +1 dB; teto -7 dB. Crítico em elite e chefe: pausa 0,05 s (0,06 s na faixa 3); crítico em comum segue com 0,04 s como antes. Todas as pausas passam pelo teto de 0,15 s e por "Impacto reduzido".

**Também:** número em faixa ≥ 2 ganha contorno maior e "pop" de crítico; golpes seguidos no mesmo elite/chefe se fundem só por **150 ms** (comum 350 ms) e a soma pode subir de faixa; **queda de elite** soa mais grave (`combat.critical` a -10 dB, tom 0,8) e **queda de chefe** ganha uma camada grave (`combat.explosion` a -10 dB, tom 0,75).

## Arquivos
`core/damage_feedback.gd` (novo), `core/battle.gd` (evento `hit` leva `tier` e `frac`), `ui/run.gd` (consome o evento, funde, toca, pausa; `_float_text` ganhou `outline_px`).

## Verificação
- `tests/test_l3_damage_feedback.gd`: faixas por tipo e fração, tamanho monótono, volume e tom monótonos, teto, pausa e o evento `hit` com `tier` e `frac`. Suíte completa: **0 falhas**.
- Captura em janela real (`tools/capture_l3.tscn`): `.atena/generated/mariz-playtest/l3_numeros_em_faixas.png` com 7 acertos sintéticos (comum 7, comum crítico 15, elite 2%, 5%, 10%, 20% e chefe crítico 12%): os números crescem de forma legível, de 7 px a 140 com a faixa.

## O que **não** entrou
- Recuo do inimigo no acerto forte (empurrão de 0,15 tile): é movimento de inimigo, fora da aprovação.
- Filtro grave e cauda mais longa por faixa: pediria efeito no barramento de áudio; o tom mais grave dá parte do peso.
- A proposta **R5-B** do M2 (14 → 16 e 22 → 26) fica **superada** por este lote; a vinheta de vida baixa (R5-A) e a atmosfera (R5-C/D) seguem separadas.

## Pendência humana
Ouvir e ver: se o número 24 a 30 px com pausa de 0,03 a 0,05 s dá a satisfação pedida, se o tom grave soa pesado (e não "abafado") e se a queda de elite e de chefe com a camada nova não polui. O ponto de ajuste está nas constantes de `DamageFeedback`.
