---
id: "EVID-216"
title: "PLAN-083 B-004: segredos de Feng-tu, Shendilavri e Goranthis (84x84) e o Espelho das Almas Desejantes"
created: "2026-10-09"
spec: "SPEC-157"
cards: ["MEC-039"]
status: "implementado local; sem commit"
---

# EVID-216 — B-004 do PLAN-083

Spec: [SPEC-157](../specs/SPEC-157-segredos-nas-outras-fases-v0-5-0.md). Conteúdo aprovado pelo dono em 2026-10-09 (12 Ecos da [proposta, seção 3](../vault/drafts/PROPOSTA-segredos-nas-outras-fases-v0-5-0-2026-10-09.md), relíquias da seção 2). O Espelho segue o **padrão registrado (G2): sem rerrolagem grátis**; o dono não respondeu à pergunta específica, então a decisão fica anotada e reversível.

## O que mudou

| Arquivo | Mudança |
|---|---|
| `data/secrets.json` | Feng-tu, Shendilavri e Goranthis: 3 POIs, 4 Ecos e relíquia cada (Sopro de Estrela; Cajado dos Desejos Sussurrantes; Espelho das Almas Desejantes) |
| `data/items.json` | novo único `espelho_das_almas_desejantes` (amuleto, tier 5, carisma +2, sorte +3, `icon_like` provisório do amuleto simples) |
| `data/stage_events.json` | `reward.unlock_chamber` em `escolta_do_peregrino`, `vitimas_drenadas` (passa a **fixo**, sai do sorteio de opcionais) e `do_trono_ao_lodo` |
| `core/happenings.gd` | `map_shift` aplica o `reward` do acontecimento (Goranthis abre a câmara quando o paraíso cai) |
| `data/achievements.json` | `ecos_feng_tu`, `ecos_shendilavri`, `ecos_goranthis` (300 moedas) |
| `tests/test_secrets.gd` | oito fases; relíquias e chaves das três; Do trono ao lodo abre a câmara e um `map_shift` sem reward não abre |

Pontos (tiles, mapa 84×84): Feng-tu, ruína (16, 20), câmara (68, 16), covil (66, 66) com Estátua do Templo; Shendilavri, ruína (60, 18), câmara (20, 20), covil (64, 68) com Guarda do Castelo; Goranthis, ruína (20, 62), câmara (62, 20), covil (66, 66) com Death Tyrant. Ecos nos destrutíveis: Feng-tu (42, 72) lanterna de papel, Shendilavri (30, 70) estátua rachada, Goranthis (28, 12) espelho ilusório. O mar de Shendilavri (x ≤ 13) e o rio de Goranthis (x ≥ 72) ficam fora de todos os pontos.

## Verificações

| Verificação | Resultado |
|---|---|
| `test_secrets` (oito fases) | 0 falhas |
| `tests/run_all.gd` | `testes: 0 falha(s)` |
| `res://tools/smoke.tscn` | `smoke: ok` |
| Capturas | `.atena/generated/big-maps/{feng_tu,shendilavri,goranthis}_s157_*.png` (cantos, visão geral, cada POI) |

## Notas e riscos

- **Efeitos de jogo além do Espelho:** Vítimas drenadas passa a acontecer **toda run** em Shendilavri (dá duas Irmãs Radiantes aliadas, 40 s, ao ser cumprido); isso muda um pouco a fase e entra na rodada do bot (B-005).
- **Chaves passivas e ativas:** Feng-tu pede escoltar João até o templo; Shendilavri, libertar as 4 vítimas em 55 s; Goranthis, só chegar a ~400 s (o evento dispara sozinho). Falhar a escolta ou o resgate deixa a câmara fechada naquela run.
- O Espelho entra também no sorteio normal de equipamentos únicos pelo tier, como as outras relíquias (cópia garantida na câmara, sem exclusividade).
- `core/happenings.gd` tem alterações de outra sessão (SPEC-159, setas de eventos); o commit deve levar só o trecho do `map_shift`.
