# Mapa de pendências da árvore de trabalho (PLAN-087 B-002)

Gerado em 2026-10-09. Fotografia: 32 arquivos modificados e cerca de 150 não rastreados (a maioria capturas em `.atena/generated/`). `HEAD` = `main` = `origin/main` (727718b). **Nada foi commitado por este plano.**

## Grupos de commit propostos (nesta ordem)

A ordem importa: os documentos da 0.4.0 descrevem os dois heróis novos, então o código vai antes.

| Ordem | Grupo | Plano / spec | Arquivos | Observação |
|--:|---|---|---|---|
| 1 | **Arlindo e Erik jogáveis** | PLAN-086 / SPEC-160 | `data/{heroes,weapons,abilities,achievements,hero_bios,barks,audio_manifest}.json`; `core/items.gd`; `core/battle.gd` (4 trechos: `AREA_KINDS`, `forget_nova`/`fire_zone`, `fire_pct`/`area_dmg_pct`, `eco_xp_pct`); `ui/overlay.gd` (só a linha de `eco_pista_pct`); `ui/hero_view.gd` (tabelas de Arlindo/Erik e `art_id`); `tests/test_new_heroes.gd`, `test_data`, `test_arcanist`, `test_animation_assets`, `test_hero_animation_prompt_manifest`; `assets/portraits/{arlindo,erik}.png(.import)`, `assets/icons/abilities/{modify_memory,navios_em_chamas}.png(.import)` | Arte **provisória** (copiada do Nottcard, somente leitura lá). O corte do `overlay.gd` e do `hero_view.gd` pede `git add -p`. |
| 2 | **Seta de evento na borda** | PLAN-085 / SPEC-159 (MEC-061) | `ui/event_pointer.gd`, `tests/test_event_pointer.gd`, `core/happenings.gd`, `ui/hud.gd`, `ui/overlay.gd` (demais trechos), `tools/capture_event_pointer.{gd,tscn}` | O `overlay.gd` é dividido com o grupo 1. |
| 3 | **Registros de spec, plano e evidência** | PLAN-085/086/087 | SPEC-159, 160, 161; `plan-085/086/087`; EVID-219 (Arlindo/Erik), **EVID-221 (seta; renomeado de EVID-219 duplicado)**; PROPOSTA e PLAN-086 em `vault/drafts`; cartões em `backlog/` (MECANICAS, BALANCEAMENTO, BUGS, ARTE, README); `plan.yaml` | Só documentos e estado. |
| 4 | **Documentos da 0.4.0 refeita** | PLAN-083 S-023 | `backlog/RELEASES.md`; `changelogs/CHANGELOG-0.4.0.html` + PDF; `GUIA-FACIL-0.4.0.html` + PDF; `questionarios/QUESTIONARIO-007-v0.4.0.{html,md}` + PDF | Já incluem a névoa (adicionada neste plano). **A seta (MEC-061) ainda não consta**: entra quando o grupo 2 for commitado (decisão do dono, EVID-218). |

## Fora deste plano (outra sessão, preservado intocado)

| Origem | Itens | Por que não mexi |
|---|---|---|
| PLAN-082 / SPEC-154 (BUG-029, pixels soltos) | `tools/{reduce_hero_strips,audit_strip_edges,capture_hero_variants}.*`, `tests/test_hero_strips.gd`, `SPEC-154`, `plan-082`, EVID-211, `assets/animations/heroes_screen/` (1,5 MB), `.atena/generated/bug-029-reducao/` | Envolve arte e escala dos heróis. Atenção: o `ui/hero_view.gd` tem código desse plano **misturado** com o do PLAN-086 (`strip_set`, `cell_of`, `HERO_STRIP_SET` vazio). Se o grupo 1 levar o arquivo inteiro, o trecho inerte do PLAN-082 vai junto; a alternativa é cortar com `git add -p`. |
| Pacote do Caio (BUG-028) | `.atena/generated/caio-durvall/` | Movimentação; fica só local por decisão do dono. |
| Capturas | `.atena/generated/big-maps/*`, `nevoa-borda/`, `mec-061-seta-de-evento/`, `controller-experience/v01/unit-profile.json(.bak)` | Evidência visual; decidir à parte se entra no repositório. |
| `.uid` não rastreados | `tests/*.uid`, `tools/*.uid`, `ui/event_pointer.gd.uid` | O repositório rastreia 216 `.uid`; entram junto do `.gd` de cada grupo. |

## Colisões de ID encontradas

| Colisão | Situação |
|---|---|
| EVID-219 (seta de evento e Arlindo/Erik) | **Resolvida**: a da seta virou EVID-221; referências em SPEC-159, `plan-085`, `plan.yaml` e `MECANICAS.md` atualizadas. |
| SPEC-116 (`chao-de-dagruve-assado-procedural` e `dopamina-tematica`) | Aberta: duas specs com o mesmo número. Proposta: renumerar a mais recente em edição própria (ver o inventário). |
| `plan-066`, `plan-067`, `plan-068` (dois arquivos cada) | Aberta: números repetidos em `.atena/state/`. Os dois de cada número são planos distintos; proposta é só registrar, não renomear (links em `plan.yaml`). |

## Antes de qualquer commit

`tests/run_all.gd` com 0 falhas, `tools/smoke.tscn`, `tools/backlog_check.ps1`; um commit por grupo, aprovação por grupo; `git add -p` onde um arquivo atende a dois planos; nenhum push sem aprovação à parte.
