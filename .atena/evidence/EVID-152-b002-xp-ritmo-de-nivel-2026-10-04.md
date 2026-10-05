---
id: "EVID-152"
title: "B-002: XP mais lento (curva e XP por inimigo) — SPEC-122"
created: "2026-10-04"
relations: ["[[EVID-151-linha-de-base-xp-e-raridade-2026-10-04]]", "[[SPEC-122-balanceamento-ritmo-inicial-xp-armas-e-raridade]]"]
---

# EVID-152 — B-002 (XP)

Mudança (dados em `data/difficulty.json`, bloco `xp`; leitura em `core/battle.gd`): `need_mult 1.0`, `need_growth 0.06` (curva base × (1 + 0,06·nível)), `kill_mult 0.75` (XP coletado × 0,75).

Medição: `tools/bot_curva.gd`, veterano padrão (meta 0), 4 heróis (durvall, maelor, korrak, nyrelia) × 3 sementes, 3 fases, `dt` 0,08. Amostra pequena; é alarme, não veredito.

| Fase | Nível ao sair antes (EVID-151) | Agora | PV mín. médio antes | Agora |
|---|---:|---:|---:|---:|
| Dagruve | 14,2 | 8,2 | 52 % | 34 % |
| Docas | 23,6 | 16,2 | 85 % | 73 % |
| Shedaklah | 35,5 | 23,3 | 71 % | 36 % |

Meta do dono (sair do Dagruve no nível 8–10): atendida (8,2). Os dois grupos não são idênticos (perfil e heróis diferem do EVID-150), então a queda de PV mínimo é indicativa.

Testes: `tests/run_all.gd` — 0 falhas.

Pendente: o dono e o Hiago validarem no playtest; nenhum commit feito.
