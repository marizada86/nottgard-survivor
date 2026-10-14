---
id: "SPEC-175"
title: "Câmara selada com pista no questlog (MEC-068, opção B)"
status: "IMPLEMENTADA LOCAL em 2026-10-13 (PLAN-102, EVID-244); DRAFT; aguarda playtest humano; commitada local (bbb792e), sem push"
origin: planned
implementation_preceded_spec: false
request_classification: PLAN_DEVIATION
created: "2026-10-13"
relations: ["[[SPEC-152-fatia-piloto-de-segredos-ecos-e-reliquias]]", "[[SPEC-157-segredos-nas-outras-fases-v0-5-0]]", "[[SPEC-168-questlog-a-direita-sem-moldura-mec-064]]", "[[SPEC-159-seta-de-evento-na-borda-da-tela-mec-061]]"]
cards: ["MEC-068", "IN-074", "MEC-064"]
content_state: DRAFT
approval_mode: per-plan
plan_id: PLAN-102
---

# SPEC-175 — Câmara selada com pista no questlog (opção B)

Origem: relato do dono em 2026-10-13 (IN-074): *"a câmara selada é muito vago, não dá pra saber o que tem que fazer"*; análise na conversa e escolha **"opção B"** (A mínimo, B recomendado, C completo).

## Estado de partida (verificado no código em 2026-10-13)
- A câmara (`interactions` kind `camara`, `core/battle.gd:1591`) só tem o rótulo "câmara selada" (`ui/overlay.gd:442`) e, ao apertar E, o aviso "A câmara está selada. Algo da fase a abrirá." (`core/battle.gd:1633`). Não aparece no questlog.
- A chave de cada fase é o acontecimento com `reward.unlock_chamber` em `data/stage_events.json` (8 fases). O questlog (`Happenings.hud_entries`) pula acontecimentos sem `objective_text`.
- Chaves **fora do questlog** por construção: Ritual da Névoa (Dagruve, `ritual`, 115 s) e Cais atacado (Docas, `wave`, 90 s) não são objetivos de `Happenings` (vão pelo caminho antigo de `_fire_stage_event`); Do trono ao lodo (Goranthis, `map_shift`, 400 s) é objetivo mas sem texto. As outras 5 têm `objective_text`, mas nada as liga à câmara.
- Como cada chave abre a câmara: **ritual**: ficar sobre o selo (raio 1,7) por `interrupt` segundos antes de `delay` (7 s); passado o prazo o ritual traz reforços e **some, sem nova chance: a câmara de Dagruve fica selada pelo resto da partida** (`core/battle.gd:944-963`). **onda**: abater todas as criaturas da onda-chave (`_key_wave`). **map_shift**: abre sozinho quando o acontecimento dispara (400 s). Os demais seguem o objetivo do acontecimento.

## Comportamento novo (opção B)
1. **Linha da câmara no questlog**, depois que o jogador **viu** a câmara (herói a até `camara_vista` = 10 unidades dela; nunca antes, para preservar o segredo). Some quando a relíquia é pega.
2. Estados da linha:

   | Estado | Título | Texto |
   |---|---|---|
   | chave ainda não disparou | Câmara selada | `Abre com «<acontecimento>» aos m:ss.` |
   | chave em curso | Câmara selada | instrução da chave (`chamber_hint`), com progresso quando houver (onda: abatidas/total) |
   | chave perdida (só ritual) | Câmara selada | `A chave se perdeu nesta partida.` |
   | aberta, relíquia não pega | Câmara aberta | `Vá até ela e aperte [E].` |

3. A linha da câmara **sempre mostra o texto** (hoje só o objetivo mais urgente mostra) e tem uma vaga reservada: com 4 objetivos, o último comum cede lugar a ela.
4. O aviso ao apertar E na câmara selada passa a nomear a chave: `A câmara está selada: <instrução>.`
5. `data/stage_events.json`: campo novo `chamber_hint` nos 8 acontecimentos-chave (os 5 que já têm `objective_text` o reaproveitam, os outros 3 ganham texto novo).
6. `data/secrets.json` `_regras.camara_vista` (padrão 10.0).

| Fase | Acontecimento-chave | `chamber_hint` |
|---|---|---|
| Dagruve | Ritual da Névoa | interrompa o ritual: fique sobre o selo |
| Docas | Cais atacado | derrote as criaturas que atacam o cais |
| Shedaklah | O portal sem vão | leve esporo e limo ao arco de pedra |
| Molor | Ritual de estagnação | mate os carregadores antes que cheguem à massa |
| Durao | Arena do Testador | vença o duelo |
| Feng-tu | Escolta do peregrino | proteja João até o templo |
| Shendilavri | Vítimas drenadas | liberte as vítimas |
| Goranthis | Do trono ao lodo | nada a fazer: o paraíso cai sozinho (o horário vem do acontecimento sorteado, 400 s ±8%) |

## Decisões do dono
| # | Decisão |
|---|---|
| D1 | Opção **B** (2026-10-13). |
| D2 | Nível de aprovação: **por plano** (`per-plan`). |
| D3 | Chave do ritual perdida: **só avisar** que se perdeu; nenhuma regra muda (o ritual não volta e a câmara não abre sozinha). |

## Critérios de aceite
1. Antes de ver a câmara, nenhuma linha dela no questlog; depois de vista, aparece com o acontecimento e o horário.
2. Em cada um dos 3 tipos (ritual, onda, map_shift) a linha mostra a instrução correta durante o acontecimento e "Câmara aberta" ao abrir; ritual perdido mostra "se perdeu".
3. A linha tem texto mesmo sem ser a mais urgente e não é cortada pelo limite de 4 linhas.
4. O aviso do E nomeia a chave.
5. As 8 chaves têm `chamber_hint`; `tests/test_data.gd` valida.
6. Nada muda no questlog dos acontecimentos nem nos ganhos da câmara (relíquia, Ecos, posições).
7. Suíte e smoke passam; **playtest humano** de legibilidade pendente por definição.

## Lacunas
| Tipo | Item | Padrão |
|---|---|---|
| BLOCKING | nenhuma | — |
| RESOLVABLE | Distância em que a câmara conta como vista | 10 unidades (dado em `secrets.json`) |
| DEFERRED | Seta na borda da tela até a câmara aberta; descrição em todas as linhas (opção C); retry do ritual; arte da câmara (ART-043) | Depois do playtest |

## Verificação planejada
Testes novos (estados da linha, vaga reservada, aviso), suíte, smoke, uma captura do questlog por tipo de chave, `tools/backlog_check.ps1`; EVID-244.

## Fora do escopo
Mudar quando, onde ou como as chaves disparam; relíquias; Ecos; arte.
