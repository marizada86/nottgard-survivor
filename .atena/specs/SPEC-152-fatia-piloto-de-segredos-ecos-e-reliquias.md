---
id: "SPEC-152"
title: "Fatia piloto de segredos: mapa 84×84, pontos de interesse, Ecos, relíquias e aba do Diário (MEC-039)"
status: "IMPLEMENTADA e publicada (fatia piloto, PLAN-081 B-006); ampliada às oito fases pela SPEC-157; aguarda playtest e arte (ART-043)"
origin: planned
implementation_preceded_spec: false
request_classification: PLAN_DEVIATION
created: "2026-10-08"
relations: ["[[SPEC-148-lancamento-da-v0-4-0]]", "[[SPEC-119-segredos-ecos-e-mapa-maior]]", "[[SPEC-118-acontecimentos-exclusivos-por-fase]]", "[[SPEC-093-mapas-60x60]]", "[[PROPOSTA-ecos-pois-e-reliquias-fatia-piloto-v0-4-0-2026-10-08]]"]
cards: ["MEC-039", "MEC-012"]
---

# SPEC-152 — Fatia piloto de segredos (MEC-039)

Aprovado pelo dono em 2026-10-08 ("aprovo tudo como recomendado"): os 12 Ecos, as 3 relíquias (cópia garantida, sem exclusividade; sorteio Lâmina × Anel em Molor), as chaves das câmaras (com a Arena do Testador sempre presente em Durao) e o mapa 84×84 nas 3 fases (plano B: 72×72). Conteúdo e fontes na [proposta](../vault/drafts/PROPOSTA-ecos-pois-e-reliquias-fatia-piloto-v0-4-0-2026-10-08.md). Risco: **alto** (mapa e mecânica nova); um commit por mecânica.

## Estado de partida (lido em 2026-10-08)

- O tamanho do mapa mora no nó `Ground` de `ui/stages/<fase>.tscn` (`map_size`); `ui/run.gd` o passa a `Battle.map_size` e a `TerrainLayout.scale = lado / 40`. As três fases estão em 60×60.
- O chão assado (`assets/tiles/<fase>_ground_baked_v1.png`, `tools/bake_ground.gd`, `SIZE = 60`) cobre o losango do mapa; `level_design.json` (`chao`, `props`) é desenhado em coordenadas de 60×60 e lido por `SceneryLayout`, `bake_ground` e pelas estruturas (`stage_structures.json`, `target`) e decais (`ground_decals.json`, posições de tela).
- `data/scenery.json` (por fase) já carrega destrutíveis, armadilhas e interativos fixos, lidos por `Battle.place_scenery`.
- Os acontecimentos-chave (SPEC-118) concluem por `Happenings._apply_reward`: "O portal sem vão" (Shedaklah, fixo), "Ritual de estagnação" (Molor, fixo) e "Arena do Testador" (Durao, `pool: optional`).

## 1. Mapa 84×84 (commit 1)

1. `Ground.map_size` das cenas de Shedaklah, Molor e Durao passa a `84×84`; `TerrainLayout.scale` já vem do lado do mapa (2,1). Posição dos nós `Sorted` e `SpawnPoints` multiplicada por 84/60 = **1,4**, e cópias determinísticas de props para manter a densidade por tile (como na SPEC-093). `tools/enlarge_stage_maps.gd` ganha os argumentos `de`, `para` e a lista de fases (o padrão continua 40 → 60).
2. **Escala de desenho** (`design_scale = lado / 60`) aplicada a tudo que foi desenhado em 60×60: posições dos aglomerados de `level_design` (`SceneryLayout`), formas do `chao` no assado, `target` das estruturas e posições dos decais. Mapas de 60×60 não mudam (`design_scale = 1`).
3. `tools/bake_ground.gd` aceita o lado como terceiro argumento e reassa os três chãos; os PNGs novos substituem os `v1` das três fases (nome `v2`; as cenas apontam para eles).
4. **Plano B:** se o `.exe` perder desempenho de forma visível em 84×84, a fatia usa 72×72 (`design_scale` 1,2), sem nova consulta.

## 2. Pontos de interesse (commit 2)

`data/secrets.json` (tabela nova, lida por `Data`): por fase, `pois` (`ruina`, `camara`, `covil`) com `id`, `pos` e, no covil, `elite`. Posição fixa por fase, em coordenadas de 84×84, sem consumir a RNG da batalha.

| Tipo | Efeito |
|---|---|
| `ruina` | 2 Ecos e um baú comum (`chest`, `safe`: não vira Mímico) |
| `covil` | o elite da fase (`gargula`, `pudim_negro`, `carcereiro_de_pedra`) nasce **parado** perto do covil e só ataca quando o herói chega a 8 tiles; ao morrer larga um baú de chefe (`boss_chest`) |
| `camara` | interativo `camara_selada` (ver 4) |

Posições: as da proposta (coordenadas de 60×60) vezes 1,4, ajustadas ao chão por `_free_scenery_spot`. A tabela de dados é a fonte; o teste confere que cada POI está dentro do mapa, longe do início e em chão onde o herói cabe.

## 3. Ecos (commit 3)

1. Cada Eco é uma entrada de `secrets.json` (`ecos`: `id`, `texto`, `fonte_vault`, `onde`: `poi`, `evento` ou `destrutivel`, `pos`). 12 no total, textos e fontes da proposta aprovada.
2. **Pegar:** o herói a até 1,2 tile de um Eco o recolhe sozinho. Aparece uma faixa na tela com o texto por 6 s (sem pausar nem travar a run) e um som existente de coleta. **Desvio da SPEC-119:** em vez de "pausa curta", faixa que não para o jogo, para não interromper a luta.
3. **Pista:** a até 6 tiles o Eco brilha de leve. O contador "Ecos 1/4" na HUD só aparece depois do primeiro achado na fase.
4. **Persistência:** `profile.data.ecos[fase][eco_id] = true`, gravado ao pegar. O perfil ganha o campo `ecos` com valor padrão `{}` (saves antigos continuam válidos).
5. **Diário (Quartel):** nova entrada "Ecos" na aba de histórias: por fase, "Ecos 3/4 · Relíquia ✓"; cada Eco achado mostra o texto completo e a fonte do Vault; os não achados aparecem como "🔒 Eco escondido".
6. Cada Eco tem `fonte_vault` e nenhuma palavra da lista de proibidos (teste de dados: "Astherion" junto de "Durvall", "colar" junto de "Adam", "Adam" fora de aspas, "Luna", "Vanimelda", "Mystralia" e "Arco 02").

## 4. Relíquias e câmaras seladas (commit 4)

1. `camara_selada` é um interativo (E) que fica **trancado** até a chave da fase: o reward do acontecimento-chave ganha `"unlock_chamber": true` (`_apply_reward` chama `Battle.unlock_chamber()`), em "O portal sem vão", "O ritual de estagnação" e "Arena do Testador". Trancada, a interação mostra "A câmara está selada. Algo da fase a abrirá."
2. Aberta, entrega a relíquia por `give_item(Items.unique(...), true)` (mesmo fluxo do baú: pausa e mostra o item se o slot estiver vazio): Shedaklah **Manto do Pântano**, Molor **Lâmina da Digestão** ou **Anel da Resistência Abissal** (sorteio na hora, com RNG própria), Durao **Machado de Xar'gath**. O item entra com o selo "Relíquia" no aviso.
3. **Cópia garantida:** o item continua no sorteio normal de baús e lojas; nenhuma tabela de drop muda.
4. **Durao:** "Arena do Testador" passa de `pool: optional` para fixo, para a câmara não ficar trancada.
5. Cada relíquia só pode ser pega uma vez por run (flag da câmara).

## 5. Conquista

Uma conquista por fase, "Ecos de <fase>", ao achar os 4 Ecos e abrir a relíquia da fase (estatística nova `secrets_<fase>` no perfil), com recompensa em moedas (valor fixo no JSON, a conferir com a economia da BAL-023).

## Não objetivos

Ecos e relíquias fora de Shedaklah, Molor e Durao; mapa 84×84 em outras fases; exclusividade das relíquias; a cadeia da runa de Vhaerith; arte nova (o Eco e a câmara usam o losango/rótulo provisório e ícone existente, ART-043); som próprio; segredos do mestre.

## Lacunas

| Id | Lacuna | Classe | Tratamento |
|---|---|---|---|
| G1 | Desempenho em 84×84 | NON_BLOCKING | Medido no `.exe` (S-020); plano B 72×72 |
| G2 | Valor da moeda da conquista | NON_BLOCKING | Valor inicial no JSON; ajuste em B-007 |
| G3 | Arte do Eco e da câmara | NON_BLOCKING | Provisório (ART-043) |

Zero lacunas `BLOCKING`.

## Critérios de aceite

1. As três cenas têm `map_size` 84×84; `test_map_scale` atualizado (as outras seis fases seguem 60×60); nenhum prop fora da margem e nenhuma célula 12×12 vazia; estruturas, decais e props escalados conforme `design_scale`.
2. Os três chãos reassados cobrem o losango 84×84 sem buracos; captura de cada fase conferida.
3. `secrets.json` valida: 3 POIs e 4 Ecos por fase, `fonte_vault` e termos proibidos; todo ponto dentro do mapa, a pé do início e onde o herói cabe.
4. Eco: tocar o Eco grava no perfil, mostra a faixa de 6 s e não duplica; o contador aparece só depois do primeiro; o Diário lista achados e escondidos.
5. Covil: o elite não ataca antes de 8 tiles; ao morrer larga baú de chefe.
6. Câmara: trancada sem a chave, aberta pelo `unlock_chamber`, uma vez por run, entrega a relíquia certa de cada fase; Durao sempre tem a arena.
7. Conquistas por fase concedidas ao cumprir os quatro Ecos e a relíquia.
8. Suíte, smoke das nove fases e `audit_projeto` sem falhas novas; bot em 84×84 roda sem erro; desempenho do `.exe` medido; EVID com capturas.
