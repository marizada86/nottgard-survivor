# EVID-244 — Câmara selada com pista no questlog (2026-10-13)

**Origem:** dono, relato "a câmara selada é muito vago, não dá pra saber o que tem que fazer" (IN-074), depois "opção B".
**Plano:** PLAN-102 / SPEC-175; modo **por plano**; chave do ritual perdida: só avisar; conteúdo DRAFT.
**Estado medido:** HEAD `ed546ad` + árvore de trabalho (depois commitada: código em `bbb792e`, documentos no commit seguinte); Godot 4.7.2.

## 1. Causa verificada (antes da mudança)
- A câmara não aparecia no questlog; a única pista era o rótulo "câmara selada" e o aviso do E ("Algo da fase a abrirá").
- 3 das 8 chaves nem eram visíveis no questlog: Ritual da Névoa (Dagruve) e Cais atacado (Docas) não são objetivos de `Happenings` (vão pelo caminho antigo de `_fire_stage_event`); Do trono ao lodo (Goranthis) é objetivo sem `objective_text`.
- O ritual-chave de Dagruve, se não interrompido em 7 s, some **sem nova chance**: a câmara fica selada pelo resto da partida e nada avisava.

## 2. Entregue (local)
| Peça | O que faz |
|---|---|
| `data/stage_events.json` | `chamber_hint` nos 8 acontecimentos-chave |
| `data/secrets.json` | `_regras.camara_vista` = 10,0 (distância em que a câmara conta como vista) |
| `core/battle.gd` | `chamber_seen`, `chamber_key_def()`, `chamber_status_text()`, `chamber_entry()`; marca a chave do ritual como perdida; aviso do E nomeia a chave |
| `ui/quest_panel.gd` | Linha `kind: chamber` com vaga reservada e sempre com texto |
| `ui/hud.gd` | Junta `chamber_entry()` às linhas do questlog |
| `tests/test_secrets.gd` | `_chamber_log`: dados das 8 chaves, estados da linha (longe, vista, em curso, perdida, aberta, pega), aviso do E, progresso da onda 0/3 → 2/3, horário do paraíso, vaga reservada no questlog |
| `tools/capture_chamber_log.*` | Capturas do questlog por tipo de chave |

Estados da linha (depois que o herói chega a 10 unidades da câmara; some ao pegar a relíquia):

| Estado | Título | Texto |
|---|---|---|
| chave ainda não disparou | Câmara selada | `Abre com «Ritual da Névoa» aos 1:55.` (horário real do acontecimento sorteado) |
| em curso | Câmara selada | instrução (`Interrompa o ritual: fique sobre o selo.`; onda: `Derrote as criaturas que atacam o cais.` com 1/3) |
| ritual perdido | Câmara selada | `A chave se perdeu nesta partida.` |
| aberta | Câmara aberta | `Vá até ela e aperte [E].` |

Nada mudou em quando, onde ou como as chaves disparam, nem em relíquias, Ecos ou posições.

## 3. Verificação
| Verificação | Resultado |
|---|---|
| `tests/run_all.gd` | **0 falhas** (a 1ª rodada achou 1: o paraíso de Goranthis tem jitter, dizia 6:50 e não 6:40; teste e spec corrigidos para o horário real) |
| Mutação: não marcar a chave perdida + sem vaga reservada | **3 falhas** nos testes novos; restaurado |
| `tools/smoke.tscn` | 9 fases ok |
| `tools/controller_check.tscn` | 94 verificações, 0 falhas |
| `tools/mobile_buttons_check.tscn` | 146 verificações, 0 falhas |
| `tools/backlog_check.ps1` | P0=0, P1 abertos=4, P1 aguardando playtest=16, verificações manuais=0; 1 alerta antigo (ART-045 duplicado) |
| Capturas (1280×720) | [.atena/generated/mec-068-camara-selada/](../generated/mec-068-camara-selada/): Dagruve (pendente, em curso, perdida), Docas (1/3), Goranthis (aberta); texto legível, sem sobrepor a HUD |

## 4. Limites e pendências
- **Playtest humano pendente** (legibilidade da linha e se 10 unidades é a distância certa para "vista").
- A linha só aparece depois de o jogador chegar perto da câmara (preserva o segredo). Quem nunca passa por ela não vê a dica. Seta na borda e descrição em todas as linhas (opção C) ficam para depois do playtest.
- A chave perdida do ritual de Dagruve segue sendo definitiva na partida (escolha do dono: só avisar). Sem retry nem abertura automática.
- Horário do acontecimento: o mostrado é o real da partida (jitter do acontecimento); antes de disparar é uma previsão exata do que foi sorteado.
- A suíte e as verificações regravam `unit-profile.json`, `integration-profile.json`, `buttons-profile.json` e `buttons-report.json` em `.atena/generated`, como já acontecia; fora do escopo.
- Commits locais (código `bbb792e` e documentos); sem push, build ou exportação.
