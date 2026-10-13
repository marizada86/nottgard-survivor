# SPEC-121 — Mesclagem de codex/assets-preparation-2026-10-10 na main / v01

Estado: **APROVADA por plano em 2026-10-13**. PLAN-053/SPEC-121, IN_PLAN, retorno ao PLAN-071 (B-006/S-011). Pedido: “atena, continuar implementando assets gerados pelo chatgpt”; escolhas: **“Mesclar a branch inteira”** e **“Por plano”**. Conteúdo segue o estado que a branch registra (CANON v01 do lettering e dos cursores; DRAFT do resto). Sem push, exportação, publicação ou aviso aos testers.

## Escopo
Branch `codex/assets-preparation-2026-10-10` (16 commits à frente da base `60fd1ff`, publicada no remoto): FILA-026 (ART-039/040 lettering e cursores), ART-032 (NPCs e pontos dos acontecimentos, `ui/happening_art.gd`), FILA-028 (33 peças preparadas, altar com loop 900 ms) e registros. Simulação prévia com `git merge-tree`: código auto-mescla (inclui `ui/run.gd` e `ui/overlay.gd`); conflitos só em `.atena/backlog/ARTE.md` e `.atena/state/plan-053-imagens.yaml`.

## Etapas (per-plan)
1. **S-001 — Mesclar em worktree isolado.** Branch de trabalho a partir da `main` (`a`+commits locais), merge da branch, resolução dos 2 documentos preservando ambos os lados (nada de histórico apagado), `plan.yaml` conferido. Main intacta.
2. **S-002 — Verificar.** Reimportar; suíte; smoke de 9 fases; `controller_check`; `mobile_buttons_check`; teste dos VFX desta sessão (regressão); testes novos da branch (`test_happening_art`, `test_lettering_assets`). Conferir que `core/battle.gd` e `data/` só mudam no que a branch declara (`data/cursor.json`, `data/stage_events.json`, `core/happenings.gd`).
3. **S-003 — Capturas e inspeção.** Telas com lettering/cursor, um acontecimento com NPC e um projétil/habilidade (convivência com o VFX). Inspeção do modelo não é aceite humano.
4. **S-004 — Avançar a `main` local** por fast-forward do merge verificado; remover o worktree; registros e recibo no `plan.yaml`.

## Prontidão
**BLOCKING:** nenhum. **RESOLVABLE:** conflitos documentais (S-001); possível sobreposição semântica em `ui/run.gd` (S-002/S-003). **DEFERRED:** playtest humano, push (republica o `latest`), exportação, decisões de Pilares/Socothbenoth/Lote C, FILA-027/029 sem peças.

## Segurança
Backup: tag local `pre-merge-assets-preparation-2026-10-13` na `main` antes de qualquer avanço. Rollback: voltar a `main` à tag (só local, sem tocar no remoto). Falha em qualquer verificação para o plano antes de S-004.
