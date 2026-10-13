# EVID-238 — Lançamento oficial da 0.4.0: documentos, verificação e pacote (2026-10-10)

**Origem:** dono, "atena, agora vamos lançar a v0.4.0 oficialmente, prepare tudo para os playtesters".
**Desvio:** DEV-036 (PLAN_DEVIATION do PLAN-071); rota "fazer agora e voltar"; aprovação por plano (PLAN-096, SPEC-169).
**Decisões do dono:** incluir BUG-042 e MEC-064; manter o pré-lançamento `latest` (sem mudar o workflow).

## Estado do código
- O dono commitou e publicou `602cef5` (BUG-042, MEC-064, registro de Erik/Arlindo, piloto de tiras do Kayron fora do jogo) em **outra sessão**, durante este plano. `origin/main` = `602cef5`.
- CI "Build and Release" do `602cef5` (run 38027372176): **success** (05:24 a 05:29 UTC). Release `latest` = *Playtest v0.4.0 (602cef5…)*, pré-lançamento, tag `latest` em `602cef5`, `NottgardSurvivors-windows.zip` (387 455 156 bytes) e `NottgardSurvivors.exe` (461 802 488 bytes).
- Desvio de regra registrado: `602cef5` mistura duas mecânicas/bugs, registros e assets em um commit (a regra é um commit por mecânica). Não reescrito (já publicado).
- `VERSION` = `0.4.0`; `file_version`/`product_version` = `0.4.0.0`. Não mudou.

## Documentos reescritos (o que entrou depois de 2026-10-09 e não constava)
| Documento | Mudança |
|---|---|
| CHANGELOG-0.4.0 (html, pdf) | Cartão novo "Seis eventos aleatórios"; cartão da tela ampliado (barra de progresso, questlog à direita, avisos, pausa em abas, Quartel no novo visual, fade); névoa de 2%–6% para **3%–9%** (`data/fog.json`); Arlindo e Erik com arte própria; provisórios e conhecidos atualizados; 3 itens em "Pequenos ajustes"; 4 itens em "O que testar". PDF de **4 páginas**. |
| GUIA-FACIL-0.4.0 (html, pdf) | Esc = menu em abas; resumo com barra, questlog, pausa, eventos e névoa 3%–9%; heróis com arte própria. **2 páginas.** |
| QUESTIONARIO-007 (md, html, pdf) | Perguntas 13 a 16 (eventos, barra e questlog, pausa em abas, névoa); mapa pergunta → cartão e regra de leitura. **1 página.** |
| RELEASES.md, changelogs/README.md | Seção 0.4.0 e "O que testar" (itens 20 a 23), checklist, linha do changelog. |

Números conferidos nos arquivos: eventos em `data/random_events.json`; névoa em `data/fog.json`; barra em `ui/stage_progress.gd` (aviso a 80%, chefe vermelho, Maré azul); abas da pausa em `ui/pause_menu.gd` (`TAB_NAMES`); teclas em `core/game.gd` (C, E, Q, Tab, Esc, T/F); sons emprestados de Arlindo e Erik em `data/audio_manifest.json`.

## Pacote
`.atena/generated/v040-lancamento/`: os 3 PDFs, `AVISO-DISCORD.md` (texto para colar) e `CONFERENCIA-ANTES-DE-ENVIAR.md`.

## Verificação (checkout limpo de `602cef5`, `git archive`, importação nova)
| Verificação | Resultado |
|---|---|
| Suíte (`tests/run_all.gd`) | **0 falha(s)** |
| Smoke das 9 fases | `smoke: ok` |
| `kit_test` (com janela) | `kit: OK` |
| `controller_check` (headless) | 90 verificações, 0 falhas |
| `mobile_buttons_check` | 146 verificações, 0 falhas |
| `backlog_check` | 0 alertas; P1 abertos 4 (BUG-025, 027, 028, 029); P1 aguardando playtest 15 |

## `.exe` local (exportado em 2026-10-10 02:44, a pedido do dono)
`build/NottgardSurvivors-Playtest 0.4.0.exe` (472 410 808 bytes), preset "Windows Playtest Publico", de `602cef5` com `stamp_build` (`commit: 602cef5`, sem `+`). **Não é idêntico ao do CI** (461 802 488 bytes): a pasta `tmp/` local (gitignored, 13 MB de rascunhos) entrou no pacote. Mesmo jogo; para um binário fiel, exportar de checkout limpo. Não executado nesta sessão (só o carimbo foi conferido no arquivo).

## Não feito (e por quê)
- Commit dos documentos, push deles e **aviso aos testers**: aguardam o dono.
- Subjetivo (legibilidade, conforto, diversão) aguarda playtest.
