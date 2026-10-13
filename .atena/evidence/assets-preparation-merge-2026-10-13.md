# Mesclagem de codex/assets-preparation-2026-10-10 na main — 2026-10-13

PLAN-053/SPEC-121, IN_PLAN, per-plan. [Spec](../specs/SPEC-121-retomada-fila-imagens/assets-preparation-merge-v01.md). Pedido do dono: “atena, continuar implementando assets gerados pelo chatgpt”; escolhas **Mesclar a branch inteira** e **Por plano**. Sem push, exportação, publicação ou aviso aos testers.

## O que entrou
16 commits da branch publicada `codex/assets-preparation-2026-10-10` (base `60fd1ff`), em merge `--no-ff` num worktree isolado a partir da `main` com o VFX desta sessão:
- **FILA-026 (ART-039/040):** lettering do jogo (banners de vitória, derrota e evolução, placas) e cursores de menu, mão e mira; `ui/lettering.gd`, menu, HUD, overlay, `data/cursor.json`; registrado na branch como CANON v01.
- **ART-032 (SPEC-118):** 17 artes estáticas de NPCs e pontos dos acontecimentos, Manifestação de Juiblex, `ui/happening_art.gd`, `core/happenings.gd`, `data/stage_events.json`; DRAFT aceito por você.
- **FILA-028:** 33 peças preparadas e aceitas (arcanista, ícones, segredos, altar com loop 900 ms) em `.atena/generated/`, mais as evidências `fila026-*`, `fila028-*` e `art032-*`.
- **Conflitos:** só `ARTE.md` e `plan-053-imagens.yaml`. Em `plan-053-imagens.yaml` os dois blocos são independentes e ficaram ambos. Em `ARTE.md` as duas versões da linha ART-045 divergiam; prevaleceu a da `main` (arte própria integrada) e a linha da branch foi preservada na íntegra numa seção “Reconciliação da mesclagem”.
- **Código que as duas linhas tocaram:** `ui/run.gd` e `ui/overlay.gd` auto-mesclaram sem conflito (VFX dos projéteis de um lado, lettering e eventos do outro).

## Verificação (S-002 e S-003, no worktree)
Reimportação completa (2.719 recursos, 0 erros na segunda passada) e então: suíte **0 falhas** (inclui `test_happening_art` e `test_lettering_assets` da branch e o teste dos VFX), smoke **nove fases ok**, `controller_check` **94/0**, `mobile_buttons_check` **146/0**. Captura de convivência ([capture.gd](../generated/assets-preparation-merge-2026-10-13/capture.gd), 21 capturas): os cinco projéteis e as dez habilidades passam pela mesma cena com o HUD, o lettering e a arte dos acontecimentos; vi corte, rastro, guarda e HUD completo.

**Limite honesto:** a tela de título e as telas de lettering não foram refotografadas aqui; para elas valem as 18 capturas da própria branch ([fila026-integration](fila026-integration-2026-10-11.md)). O erro `queue_free` de um número flutuante, visto na captura, é código de 21/09 de `ui/run.gd` disparado por eu liberar os nós do `fx` à mão no harness; não é da mesclagem.

## Estado
Aceite visual dos NPCs e dos pontos, e o playtest humano de lettering e cursores (aparência e mira na janela real), seguem **pendentes do dono**. BUG-025/027/028/029 preservados; retorno ao PLAN-071 B-006/S-011. Rollback local: tag `pre-merge-assets-preparation-2026-10-13`.
