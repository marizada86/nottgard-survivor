---
id: EVID-265
title: Renomeação para Nottgard - Abyss Megadungeon
spec: SPEC-181
plan: PLAN-106
date: 2026-10-15
content_state: CANON
---

# EVID-265 — Renomeação

Aprovação do dono em 2026-10-15 (escopo A, por plano). Nada foi commitado.

## Verificado

| Verificação | Resultado |
|---|---|
| `ProjectSettings application/config/name` | Nottgard - Abyss Megadungeon |
| `OS.get_user_data_dir()` | `...\Godot\app_userdata\Nottgard Survivors` (inalterado; saves preservados) |
| `tests/run_all.gd` (headless) | 0 falha(s) |
| Largura do título do menu (Cinzel 44 px) | 870 px, cabe |

## Não verificado / pendente

- Captura visual do menu e do título em jogo.
- `assets/ui/title/logo.png` ainda mostra SURVIVORS (ART-049).
- Build, exportação e release não foram tocados.