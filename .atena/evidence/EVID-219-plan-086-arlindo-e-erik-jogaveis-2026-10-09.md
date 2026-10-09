---
id: "EVID-219"
title: "PLAN-086: Arlindo Orlando e Erik Blackthorn jogáveis (dados, código, testes, bot)"
created: "2026-10-09"
spec: "SPEC-160"
cards: ["MEC-062", "MEC-063", "ART-045", "BAL-027"]
status: "implementado local com arte provisória; sem commit; arte própria pendente (ART-045)"
---

# EVID-219 — PLAN-086

Spec: [SPEC-160](../specs/SPEC-160-arlindo-orlando-e-erik-blackthorn-jogaveis.md). Conteúdo aprovado pelo dono em 2026-10-09 ([proposta](../vault/drafts/PROPOSTA-arlindo-e-erik-jogaveis-2026-10-09.md)); aprovação por plano; `art_like` provisório.

## O que mudou

| Área | Mudança |
|---|---|
| Dados | `heroes.json` (arlindo, erik, com `art_like` e `unlock` `ach:ecos_dagruve` / `ach:ecos_docas`), `weapons.json` (Memória Alterada, Tocha do Incendiário), `abilities.json` (Modify Memory, Navios em Chamas), `hero_bios.json`, `barks.json`, `achievements.json` (`bio_arlindo`, `bio_erik`; textos de desbloqueio), `audio_manifest.json` (eventos clonados de Sylas, Korrak, Dominar Pessoa e Espada Sombria) |
| Grimholders | título e bio da Nyrelia: "Greenholders" → "Grimholders" |
| `core/battle.gd` | `use_active` com `forget_nova` (inimigos próximos perdem os ataques por 2 s; chefe no máximo 0,6 s) e `fire_zone` (zona de fogo do herói à frente por 8 s); `_hero_hit` soma `fire_pct` (dano de fogo) e `area_dmg_pct` (nova, zona, slam e as duas habilidades novas); `_update_ecos` dá XP por Eco (`eco_xp_pct`) |
| `core/items.gd` | rótulos dos quatro mods novos |
| `ui/overlay.gd` | o brilho do Eco usa `eco_pista_pct` (Arlindo: 6 → 9 tiles) |
| `ui/hero_view.gd` | `art_id` (sem `idle.png` próprio usa a animação de `art_like`) e as tabelas de altura e base de Arlindo e Erik |
| Arte provisória | retratos copiados do Nottcard (somente leitura lá); ícones das habilidades copiados de Dominação e de Impacto de Xar'gath; animação de Sylas e de Durvall |
| Testes | `tests/test_new_heroes.gd` (novo); ajustes em `test_data`, `test_arcanist`, `test_animation_assets`, `test_hero_animation_prompt_manifest` (heróis com `art_like` têm pacote próprio, ART-PROMPTS-060) |
| Arte (prompts) | `ART-PROMPTS-060` e `CHATGPT-FILA-027` (retrato e nove tiras por herói) |

Desvio do aprovado: a passiva do Arlindo diz "Ecos brilham de mais longe e cada Eco rende XP" (sem "e câmaras"), porque a câmara já fica sempre visível no mapa e não há brilho dela para ampliar.

## Verificações

| Verificação | Resultado |
|---|---|
| `test_new_heroes` | 0 falhas |
| **Mutação** (sem `fire_pct`, `area_dmg_pct`, XP do Eco e o `stun` do esquecimento) | 4 falhas; restaurado, 0 |
| `tests/run_all.gd` | `testes: 0 falha(s)` |
| `res://tools/smoke.tscn` | `smoke: ok` |
| `tools/audit_projeto.gd` | `erros=0; avisos=9` (7 antigos + falta de `assets/heroes/arlindo.png` e `erik.png`, retratos estáticos que a arte própria resolve) |
| PDFs | changelog 4 páginas, guia 2, questionário 1 |

## Bot por herói (S-012; 15 sementes, 9 fases, lado 60; com e sem a faixa de borda do SPEC-158)

Dados em `.atena/generated/arlindo/bot/` (`run_bot.sh`, `bot_noedge.gd`).

| Herói · meta | Com borda | Sem borda |
|---|---|---|
| Arlindo · novato | 0,0 fases · nv 2,3 · 3,5 min | 0,1 · nv 3,7 · 7,5 min |
| Arlindo · veterano | 0,3 · nv 4,4 · 6,3 min | 0,1 · nv 5,4 · 7,1 min |
| Erik · novato | 0,3 · nv 10,3 · 4,4 min | 0,3 · nv 10,5 · 3,8 min |
| Erik · veterano | 0,7 · nv 13,6 · 6,8 min | 0,9 · nv 14,8 · 7,9 min |

Referência (EVID-208, veterano, sem a borda): Sylas 1,1, Kayron 1,0, Leoric 0,3, Nyrelia 0,3, Durvall 0,2, Zynara 0,1.

**Leitura:** o **Erik** fica no meio do grupo (0,9 fases, nível ~15) e nenhuma anomalia aparece. O **Arlindo** fica entre os mais fracos (0,1 a 0,3 fases, nível 4 a 5), no patamar de Zynara, Nyrelia e Leoric, os suportes que o bot já mede como baixos. O bot não explora Ecos nem aproveita o controle (esquecer e lentidão) como um jogador; **nenhum número foi mexido** (BAL-027 aberto: decidir com playtest se o Arlindo recebe ajuste). A faixa de borda quase não muda estes resultados (diferenças dentro do ruído).

## Pendências

- Arte própria (ART-045): retratos e nove tiras de cada herói; depois atualizar `HERO_IDLE_ART_HEIGHT`, `HERO_FEET_Y` e `HERO_DISPLAY_HEIGHT` e apagar o `art_like`.
- Sons e ícones de habilidade próprios (provisórios).
- Commits (um por mecânica) e push: aprovação do dono.
- `core/battle.gd`, `ui/hero_view.gd`, `ui/overlay.gd` e `tests/test_animation_assets.gd` têm alterações de outras sessões; o commit deve levar só os trechos desta tarefa.
