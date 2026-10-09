---
id: "EVID-215"
title: "PLAN-083 B-002: segredos de Dagruve e Docas (60x60)"
created: "2026-10-09"
spec: "SPEC-157"
cards: ["MEC-039"]
status: "implementado local; sem commit"
---

# EVID-215 — B-002 do PLAN-083

Spec: [SPEC-157](../specs/SPEC-157-segredos-nas-outras-fases-v0-5-0.md). Conteúdo aprovado pelo dono em 2026-10-09 ([proposta, seção 7](../vault/drafts/PROPOSTA-segredos-nas-outras-fases-v0-5-0-2026-10-09.md)), com duas correções: não existem Greenhold nem Greenholders, só **Grimhold** e **Grimholders**; e a **Arch-hag sustentava o ritual** que invocava o Kraken.

## O que mudou

| Arquivo | Mudança |
|---|---|
| `data/secrets.json` | Dagruve e Docas: 3 POIs (ruína, câmara, covil), 4 Ecos e relíquia cada (Broche Celestial; Colar dos Tentáculos) |
| `data/stage_events.json` | `ritual_da_nevoa` e `cais_atacado` ganham `reward.unlock_chamber` e `fonte_vault` |
| `core/battle.gd` | o selo do Ritual da Névoa, ao ser interrompido, abre a câmara (`unlock_chamber` na zona); a onda do Cais atacado vira `_key_wave` e, com as 3 criaturas abatidas, abre a câmara; os afixos do elite do covil não mexem mais na RNG da batalha |
| `data/achievements.json` | `ecos_dagruve` e `ecos_docas` (300 moedas) |
| `tests/test_secrets.gd` | cinco fases, lado do mapa por fase (60 ou 84); novo `_key_events` (selo interrompido, selo que acaba, onda abatida, ordem das mortes, onda comum) |
| `tests/test_battle.gd` | cenário de Dagruve e Docas passa a aceitar o covil, o baú da ruína e a câmara dos segredos |
| `tools/probe_secret_spots.gd` | mapa ASCII do chão para escolher os pontos (nova) |

Pontos (tiles): Dagruve, ruína (28, 10), câmara (47, 16), covil (11, 51) com Cultista de Cajado; Docas, ruína (50, 40), câmara (38, 8), covil (10, 52) com Arch-hag. Ecos: ruína a ±1,6 tile do ponto, câmara a (−2,6; −1,6), destrutível Dagruve (6, 24) com candelabro e Docas (24, 52) com pilha de carga.

## Verificações

| Verificação | Resultado |
|---|---|
| `test_secrets` (cinco fases) | 0 falhas |
| **Mutação** (`_event_unlocks_chamber` sempre falso) | 2 falhas (selo sem marca; onda com 0 criaturas-chave); restaurado, 0 |
| `test_battle` | sem falhas (as 8 antigas eram só expectativas de "só destrutíveis") |
| `tests/run_all.gd` | falhas só de `test_fog_edge` e `test_scripts_compile` (`ui/overlay.gd`, `ui/run.gd`), do trabalho em andamento de outra sessão (SPEC-158, névoa de borda); nenhuma nos meus arquivos |
| `res://tools/smoke.tscn` | `smoke: ok` |
| Capturas | `.atena/generated/big-maps/{dagruve,docas}_s157_*.png` (cantos, visão geral e cada POI) |

## Notas

- Os Ecos 2 a 4 de Docas vêm de trechos sem o marcador de consolidação aprovada; o dono aprovou assim.
- O Vault (somente leitura aqui) ainda grafa Greenhold/Greenholders em `Dagruve.md` (S9-37); o texto do jogo segue o dono.
- A chave de Dagruve exige interromper o selo (se ele acabar, a câmara fica fechada naquela run); a das Docas, derrotar as 3 criaturas da onda.
- `core/battle.gd` também tem alterações da outra sessão (névoa de borda); o commit deve levar só os trechos desta tarefa.
