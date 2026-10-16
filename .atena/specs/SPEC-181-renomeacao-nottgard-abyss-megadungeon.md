---
id: "SPEC-181"
title: "Renomeação do jogo para Nottgard - Abyss Megadungeon"
status: "IMPLEMENTADA localmente em 2026-10-15; arte do logotipo pendente (ART-049)"
origin: planned
implementation_preceded_spec: false
request_classification: PLAN_CHANGE_REQUEST   # decisao de nome do dono; aprovada por plano em 2026-10-15
created: "2026-10-15"
revision: "r1 (2026-10-15)"
relations: ["[[PLAN-001-nottgard-survivors]]", "[[ART-049]]"]
content_state: CANON   # nome aprovado explicitamente pelo dono; registrado em PLAN-001 §16
---

# SPEC-181 — Renomeação para Nottgard - Abyss Megadungeon

## Decisão do dono (2026-10-15)

"o nome do jogo mudou de Nottgard Survivor para Nottgard - Abyss Megadungeon".
Escopo A aprovado, por plano: preservar saves, canon por nova revisão, histórico
intocado, nomes de arquivo do .exe e do zip mantidos por ora.

## O que muda

| Local | Mudança |
|---|---|
| `project.godot` | `config/name` passa a Nottgard - Abyss Megadungeon |
| `core/version.gd` | `GAME_NAME` (título, menu de versão, guia do playtest) |
| `ui/menu.tscn`, `tools/build_scenes.gd` | título do menu: NOTTGARD - ABYSS MEGADUNGEON (870 px a 44 px, cabe) |
| `export_presets.cfg` | `product_name` e `file_description` dos três perfis |
| `README.md`, `.github/workflows/build-release.yml` | título e textos da release |
| `tools/build_asset_manifest.ps1`, `tools/generate_audio.js` | rótulo do projeto |

## O que NÃO muda

- **Saves, ajustes e registros de run:** `config/use_custom_user_dir=true` com
  `custom_user_dir_name="Godot/app_userdata/Nottgard Survivors"` mantém o mesmo
  `user://` de antes. Sem isso, a mudança de `config/name` deixaria os saves
  órfãos. Verificado: `OS.get_user_data_dir()` aponta para a pasta antiga.
- **Nomes de arquivo do .exe e do zip** (`NottgardSurvivors*.exe`,
  `NottgardSurvivors-windows.zip`) e o `game_id` de `core/run_record.gd`
  (`nottgard-survivors`): ficam como estão, para não quebrar o link do release
  latest, o CI e os registros de run. Renomear é decisão futura do dono.
- Histórico: specs, planos, evidências, rascunhos e `.atena/generated/`.
- O repositório e a pasta `nottgard-survivor`.

## Pendências

- **ART-049:** `assets/ui/title/logo.png` traz "NOTTGARD SURVIVORS" na arte; a tela
  de título continua mostrando o nome antigo até haver logotipo novo.
- Decidir depois se os nomes de arquivo do release acompanham o novo nome.

## Aceite

- Suíte `tests/run_all.gd`: 0 falhas.
- `config/name` e `GAME_NAME` com o nome novo; `user://` inalterado.