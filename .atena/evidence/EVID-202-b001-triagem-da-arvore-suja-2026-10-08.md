---
id: "EVID-202"
title: "PLAN-081 B-001 S-001 e S-002: bugs abertos e triagem da árvore suja"
created: "2026-10-08"
plan: "PLAN-081"
spec: "SPEC-148"
status: "S-001 e S-002 feitos; S-003 aguarda aprovação dos commits; S-004 parcial (0 falhas no HEAD limpo)"
---

# EVID-202 — Triagem da árvore suja (PLAN-081 B-001)

Base: `main` = `origin/main` = `94a6a2f`. Nada foi commitado, movido ou apagado nesta etapa; só leitura de `git status` e `git diff`.

## S-001 — `tools/backlog_check.ps1`

`powershell -NoProfile -ExecutionPolicy Bypass -File tools/backlog_check.ps1` (a política padrão do sistema bloqueia scripts sem o `Bypass`).

- P0 = 0; P1 abertos = 4; P1 implementados aguardando playtest = 14; verificações manuais pendentes = 8.
- **P1 sem implementação:** BUG-025, BUG-027, BUG-028, BUG-029. O BUG-033 está implementado local e aguarda reteste físico (a SPEC-148 o lista só como reteste, não como aberto).
- **Alertas de organização (3):** IDs duplicados ART-036, ART-037 (ARTE.md) e MEC-049 (MECANICAS.md). Os cartões de lettering e cursor, criados numa sessão paralela em 2026-10-06, colidem com os de mobile (MEC-049, ART-036) e de ícones de controle (ART-037). Próximos livres: ART-039, BAL-025, BUG-038, IN-073, MEC-058, TOOL-5. **Decisão pendente do dono** (renumerar o lettering para IDs livres).

## S-002 — mapa arquivo → grupo

60 itens (19 modificados, 41 novos, contando arquivos de pasta). Nenhum arquivo modificado mistura grupos: cada `M` pertence a um só, então **nenhum trecho precisa ser separado** (`hash-object` + `update-index`), basta `git add <caminhos>` por grupo.

### G1 — Economia de ouro (BAL-023, SPEC-142, PLAN-075)
Código: `core/battle.gd` (telemetria `gold_src`, `_kill_gold_value`, `_pay_gold_hit`, `sell_value`, teto 3,0), `core/happenings.gd` (origem "evento"), `data/difficulty.json` (bloco `gold`), `tests/test_battle.gd`, `tests/test_run_record.gd`, `tools/bot_curva.gd`.
Documentos: `.atena/backlog/BALANCEAMENTO.md` (BAL-023), `.atena/specs/SPEC-142-…`, `.atena/evidence/EVID-191`, `EVID-193`, `EVID-194`, `.atena/vault/drafts/PLAN-075-…`, `.atena/state/plan-075-economia-de-ouro.yaml`, `.atena/generated/gold-economy/` (279 KB).

### G2 — F7 reúne evidências num ZIP (SPEC-145, PLAN-078)
`core/playtest.gd` (atalho F7, `build_evidence_zip`, `unique_zip_path`, `zip_evidence`), `tests/test_playtest.gd`, `tools/kit_test.gd`, `README.md` (linha do F7), `.atena/specs/SPEC-078-…` (nota de substituição), `.atena/specs/SPEC-145-…`, `.atena/evidence/EVID-198`, `.atena/state/plan-078-…yaml`, `.atena/generated/playtest-zip/`.

### G3 — Esqueleto de lettering e cursor (SPEC-132, PLAN-065), sem arte
Código novo (nada em arquivo rastreado referencia `Lettering`): `ui/lettering.gd` (+`.uid`), `ui/lettering_gradient.gdshader` (+`.uid`), `data/lettering.json`, `tests/test_lettering_assets.gd` (+`.uid`), `tools/capture_lettering.gd` (+`.uid`), `tools/capture_lettering.tscn`.
Documentos: `.atena/vault/drafts/SPEC-132-…`, `PLAN-065-…`, `.atena/state/plan-065-lettering-cursor.yaml`, `.atena/evidence/EVID-172`, `.atena/generated/ART-PROMPTS-058-…`, `CHATGPT-FILA-026-…`, `.atena/generated/spec-132/` (1,4 MB).

### G4 — Diagnóstico do patinar e pacote do especialista Caio (BUG-028, SPEC-146, PLAN-079)
`.atena/specs/SPEC-146-…`, `.atena/state/plan-079-…yaml`, `.atena/generated/walk-debug/plan-before-079.yaml`, `.atena/generated/caio-durvall/Durvall-para-Caio-2026-10-08.zip` (**6,4 MB, binário**: ver decisão D2).

### G5 — Documentos e estado do Atena
`.atena/state/plan.yaml` (DEV-007 a DEV-013 e início do PLAN-081), `plan-074-…`, `plan-076-…`, `plan-080-…` (recibos de push), `plan-081-…yaml`, `.atena/specs/SPEC-148-…`, `.atena/vault/drafts/PLAN-081-…`, `.atena/backlog/RELEASES.md` (seções de ouro e 0.3.3), `.atena/generated/v040-release/` (dois snapshots), este EVID-202 e três `.uid` de scripts já rastreados (`tests/test_scripts_compile.gd.uid`, `tools/capture_ability_hud.gd.uid`, `tools/capture_character_sheet.gd.uid`).

### G6 — Versão (fica para B-008)
`core/version.gd` (0.3.2 → 0.3.3) e `export_presets.cfg` (três presets 0.3.3.0). O fechamento sobe tudo para 0.4.0; até lá continuam como alteração local.

### Fora de todos os grupos (sem commit, a menos que o dono decida)
`.atena/generated/controller-experience/v01/unit-profile.json` e `unit-profile.json.bak` (4 KB cada): parecem saída de teste local, sem spec nem EVID que os cite. Ver D3.

## Proposta de commits (S-003), em ordem

| # | Grupo | Mensagem sugerida |
|---|---|---|
| 1 | G1 | `BAL-023: economia de ouro com telemetria, bônus proporcional e teto de recompensa (SPEC-142)` |
| 2 | G2 | `F7 reúne as evidências do playtest num ZIP ao lado do executável (SPEC-145)` |
| 3 | G3 | `SPEC-132: esqueleto de lettering (sem arte) e testes` |
| 4 | G4 | `BUG-028: pacote Durvall para o especialista Caio e documentos (SPEC-146)` |
| 5 | G5 | `Atena: DEV-007 a DEV-013, PLAN-081 (v0.4.0), recibos e documentos de estado` |

G5 por último, para o `plan.yaml` registrar os cinco hashes reais. Cada commit leva `Co-Authored-By` e só sai com aprovação.

## Decisões que preciso do dono

| Id | Decisão | Padrão sugerido |
|---|---|---|
| D1 | Renumerar os cartões de lettering/cursor que colidem (ART-036/037, MEC-049 do SPEC-132) para IDs livres? | Sim, para ART-039/ART-040 e MEC-058, num commit de documentos à parte (toca SPEC-132, PLAN-065, ARTE.md e MECANICAS.md) |
| D2 | O ZIP de 6,4 MB (`caio-durvall`) entra no Git? | Não: deixar local e listar o caminho no SPEC-146 (o `.gitignore` já exclui `build/`) |
| D3 | `unit-profile.json` e `.bak` | Deixar fora do Git |

## S-004 — suíte no `HEAD` limpo

Cópia limpa do `HEAD` (`git archive`) em pasta isolada do scratchpad; importação e `tests/run_all.gd` com `Godot_v4.7.2-stable_win64.exe`. Resultado registrado abaixo quando terminar.

**Resultado (HEAD `94a6a2f`, cópia limpa via `git archive`):** importação concluída e `tests/run_all.gd` terminou com **`testes: 0 falha(s)`**, saída 0. Os avisos de RIDs e objetos vazados ao sair são do encerramento do Godot headless, sem falha de teste. Como a cópia limpa não tem `.atena/` nem os arquivos dos grupos G1 a G4, a suíte completa será repetida no `HEAD` final de B-001, depois dos commits aprovados.

## S-003 — commits (aprovados pelo dono em 2026-10-08: "aprovo os 5 commits, faça D1, D2 e D3 como recomendado")

| Commit | Grupo |
|---|---|
| `020642b` | G1 economia de ouro (BAL-023) |
| `4a33764` | G2 F7 reúne evidências num ZIP |
| `421dd29` | G3 esqueleto de lettering (cartões já renumerados) |
| `ad3220d` | G4 documentos do pacote Caio (ZIP só local) |
| `2a18614` | D1 renumeração: lettering ART-036/037 → ART-039/040, MEC-049 → MEC-058; próximos livres no README do backlog |
| G5 | documentos de estado (commit seguinte; o hash fica no `git log`) |

D1: `backlog_check` caiu de 3 para 0 alertas de organização. D2: o ZIP fica local, anotado no SPEC-146. D3: `unit-profile.json` e `.bak` ficaram fora do Git. Nenhum push foi feito.

## S-004 final e S-005 — `HEAD` `5953d44` (cópia limpa via `git archive`, com `.atena/`)

| Verificação | Resultado |
|---|---|
| `tests/run_all.gd` | `testes: 0 falha(s)`, saída 0 |
| `res://tools/smoke.tscn` (nove fases) | `smoke: ok`, saída 0 |
| `res://tools/kit_test.tscn` | `kit: OK`, saída 0. Precisa de janela: em `--headless` o `take_print` espera uma captura que o renderizador dummy não entrega e o teste trava (saída 124); rodado com `--resolution 640x360` |

Os avisos de RIDs e objetos vazados ao sair são do encerramento do Godot, sem falha de teste. **B-001 concluído.** G6 (versão) continua como alteração local até B-008.
