---
id: "EVID-207"
title: "PLAN-081 B-006: fatia piloto de segredos (mapa 84×84, pontos de interesse, Ecos, relíquias, Diário)"
created: "2026-10-08"
plan: "PLAN-081"
spec: "SPEC-152"
cards: ["MEC-039", "MEC-012", "ART-043"]
status: "implementado local; mudanças no índice e na árvore, sem commit (aguarda aprovação)"
---

# EVID-207 — Fatia piloto de segredos (MEC-039)

Spec: [SPEC-152](../specs/SPEC-152-fatia-piloto-de-segredos-ecos-e-reliquias.md). Conteúdo aprovado pelo dono em 2026-10-08 ("aprovo tudo como recomendado"): [proposta](../vault/drafts/PROPOSTA-ecos-pois-e-reliquias-fatia-piloto-v0-4-0-2026-10-08.md).

## O que mudou

**Mecânica A — mapa 84×84 (MEC-012 reaberto):** `tools/enlarge_stage_maps.gd` ganhou `de`, `para` e lista de fases (e nomes únicos para as cópias); `tools/bake_ground.gd` aceita o lado; cenas de Shedaklah, Molor e Durao em `Vector2i(84, 84)` com herói em (0, 1344) e props escalados; chãos reassados `*_ground_baked_v2.png` (5376×2688, 7 a 8 MB cada); `SceneryLayout` multiplica os centros dos aglomerados por lado/60, filtra água, margem, parede e célula repetida e acrescenta uma cópia deslocada de cada aglomerado; `StageStructures` multiplica o alvo por lado/60. Decais ficam como estão (já eram desenhados no canto NW do mapa).

**Mecânica B — segredos (MEC-039):**

| Peça | Onde |
|---|---|
| `data/secrets.json` (3 POIs, 4 Ecos e relíquia por fase; `_regras`) | tabela nova, registrada no `run_record` e no `audit_projeto` |
| Ruína (baú seguro e fixo) e covil (elite dormente que acorda a 8 tiles e larga baú de chefe) | `Battle._place_secrets`, `Enemy.lair`, `_enemy_step`, `_kill` |
| Eco: recolhe sozinho a 1,2 tile, evento `eco`, `stats.ecos`, pista a 6 tiles (`Overlay._draw_ecos`) | `Battle._update_ecos`; `ui/run.gd`; `ui/overlay.gd` |
| Faixa do Eco (6 s, sem pausar) e "✦ Ecos n/4" só depois do primeiro | `ui/eco_banner.gd`, `ui/hud.gd` |
| Perfil: `ecos`, `relics`, `mark_eco_found`, `mark_relic_taken`, `secrets_complete`, stat `secrets_<fase>` | `core/profile.gd` (saves antigos continuam válidos) |
| Diário: entrada "✦ Ecos: <fase> (n/4 · Relíquia ✓)" com texto e fonte | `ui/menu.gd` |
| Câmara selada (`camara`), `unlock_chamber`, relíquia por `give_item` | `Battle._open_chamber`; reward `unlock_chamber` nos três acontecimentos-chave (`Happenings._apply_reward`); Arena do Testador fixa |
| Conquistas `ecos_shedaklah`, `ecos_molor`, `ecos_durao` (300 moedas) | `data/achievements.json` |

## Verificações

| Verificação | Resultado |
|---|---|
| `test_secrets` (novo, 6 grupos) | 0 falhas: dados e termos proibidos, posições (dentro do mapa, em chão livre, a ≤ 40 tiles do centro), covil, Ecos, perfil, Diário, câmara e relíquias nas três fases (Molor sorteia as duas em 40 sementes), chaves e conquistas |
| `test_map_scale`, `test_level_design` | 0 falhas, agora com 84×84 nas três fases e 60×60 nas outras seis |
| `tests/run_all.gd` | `testes: 0 falha(s)` |
| `res://tools/smoke.tscn`, `tools/audit_projeto.gd` | `smoke: ok`; `erros=0; avisos=7` (os 7 de `boss_presentations`) |
| FPS em janela 1280×720 (`tools/measure_fps.gd`, 8 s) | Dagruve 60×60: média 59,7; Shedaklah 59,6; Molor 59,9; Durao 59,8 (84×84). Sem perda visível; picos mínimos são carga inicial, iguais na fase de 60×60. Repetir no `.exe` do fechamento (S-026) |
| Capturas (`tools/capture_big_maps.gd`, em `.atena/generated/big-maps/`; só as principais vão ao Git: visão geral de Shedaklah, Molor e Durao, ruína de Shedaklah, câmara de Durao e a faixa do Eco) | conferidas |

## Limites e pendências

- **Arte e som provisórios** (ART-043): Eco é um brilho em código, a câmara é o losango roxo com rótulo, ruína e covil usam o baú e o elite existentes.
- **Desvio da SPEC-119:** o Eco abre uma faixa de 6 s em vez de uma pausa curta, para não interromper a luta.
- **Bot:** não modela 84×84 nem segredos (`bot.gd` usa um lado único e não chama `place_scenery`); as linhas de base de B-007 não mudam por causa do mapa.
- **Efeito na dificuldade:** o mapa maior dilui o contato com baús e eventos que nascem perto do herói; só playtest humano mostra se Shedaklah, Molor e Durao ficaram vazios demais.
- **Commits:** nenhum feito. Proposta: (1) mapa 84×84 (MEC-012), já no índice; (2) MEC-039 segredos (um commit, porque a lógica compartilha `core/battle.gd`); (3) documentos e estado.
