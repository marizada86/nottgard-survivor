---
id: "SPEC-154"
title: "Pixels soltos nos heróis: pré-redução das tiras para o tamanho de tela (BUG-029)"
status: "PAUSADA em 2026-10-09 (PLAN-082): o dono não adotou a variante C; HERO_STRIP_SET vazio e BUG-029 aberto; registros e ferramentas commitados (eb57860)"
origin: planned
implementation_preceded_spec: false
request_classification: PLAN_DEVIATION
created: "2026-10-09"
relations: ["[[SPEC-112-normalizacao-base-e-bordas-dos-herois]]", "[[EVID-140-normalizacao-base-e-bordas-dos-herois-2026-10-01]]", "[[EVID-146-auditoria-de-dimensoes-dos-herois-2026-10-02]]"]
cards: ["BUG-029", "BUG-025"]
---

# SPEC-154 — Pré-redução das tiras dos heróis (BUG-029)

Pedido do dono (2026-10-09): "abra o plano do BUG-029". Origem do bug: dono, 2026-10-05 ("heróis jogáveis voltaram a ter pixels soltos"). Risco: **médio** (arte de todos os heróis; reversível por herói).

## Situação de partida (lida em 2026-10-09)

- Cada herói tem 12 tiras em `assets/animations/heroes/<herói>/` (`idle`, `move_*`, `attack`, `active`, `death`), células de **256×384 px** (`CELL` em `ui/hero_view.gd`), 233 arquivos, 57 MB.
- O herói aparece com **40 a 76 px** de altura (`HERO_DISPLAY_HEIGHT`) a partir de uma arte de **224 a 368 px** (`HERO_IDLE_ART_HEIGHT`): escala em tela de ~0,13 a ~0,29 (Kayron: 66/316 = 0,21).
- `project.godot` usa `default_texture_filter=0` (vizinho mais próximo) e as tiras não têm mipmaps. Reduzir 4 a 8 vezes por vizinho mais próximo amostra um texel e **descarta o resto**: detalhes finos da armadura viram ruído (causa medida em 2026-10-05, [antes](../generated/bug-029/kayron-antes-nearest.png)).
- **Já tentado e rejeitado pelo dono (2026-10-05):** mipmaps + filtro linear no sprite (limpo, mas "visual suave"; [depois](../generated/bug-029/kayron-teste-mipmaps.png)). O alfa não é a causa (solidez 0,89 a 0,95).
- O que resta no cartão: **pré-reduzir as tiras para o tamanho de tela**, com reamostragem limpa, mantendo o pixel nítido.

## Proposta

1. **Ferramenta reprodutível** `tools/reduce_hero_strips.gd`: lê as tiras de um herói, reduz cada **quadro** (nunca a tira inteira, para não vazar entre quadros) por um fator uniforme e grava em `assets/animations/heroes_screen/<herói>/`. O mesmo comando regera tudo quando o dono trouxer arte nova (BUG-027, BUG-028, BUG-025), então a redução não vira retrabalho.
2. **Três variantes no piloto**, todas com alfa pré-multiplicado na redução (sem halo escuro nas bordas):

| Variante | Fator | Reamostragem | Em tela |
|---|---|---|---|
| **A** | exato `altura em tela / altura da arte` (1:1) | média por área (box) | pixel nítido a 1:1; sem filtro |
| **B** | igual à A | Lanczos com leve nitidez | 1:1; contorno mais marcado |
| **C** | o dobro do fator da A (a arte fica com 2× a altura em tela) | média por área | vizinho mais próximo a 2:1; granulado fino em vez de ruído |

3. **Piloto no Kayron** (o herói das capturas do BUG-029): as três variantes em jogo, nos zooms 1,0, 1,5 e 2,0 e em 1280×720 e 1920×1080, lado a lado com o atual, em capturas. **O dono escolhe a variante** (ou nenhuma).
4. **Integração por herói, sem apagar nada:** as tiras originais continuam em `assets/animations/heroes/`. Uma tabela `HERO_STRIP_SET` em `ui/hero_view.gd` diz, por herói, o diretório e o fator; sem entrada, vale o atual. Reverter um herói = apagar a entrada. Para cada herói reduzido o código recalcula, a partir do fator, `CELL`, `HERO_IDLE_ART_HEIGHT`, `HERO_FEET_Y` e `display_scale` (a altura em tela **não muda**).
5. **Expansão** aos outros 9 heróis só depois da escolha do piloto, por lotes com captura e aprovação visual.
6. **Testes:** `tests/test_animation_assets.gd` e os de marcos de pés ganham a leitura de `HERO_STRIP_SET`; um teste novo confere, para cada herói reduzido, a mesma altura em tela, os pés na mesma linha de base (±1 px), o mesmo número de quadros por tira, nenhum quadro cortado na borda e a mesma solidez do miolo (alfa acima de 50%, ±0,03).

## Decisões do dono (2026-10-09)

| Tema | Decisão |
|---|---|
| Rota e aprovação | Fazer agora e voltar ao PLAN-071; aprovação por plano |
| Variante | **C** (média por área, 2× a altura em tela), com a ressalva: não cortar as pontas dos assets na borda da célula |
| Resposta à ressalva | Cada quadro reduzido ganha **2 px de margem transparente** (`pad`); teste e auditoria exigem ≥ 2 px de folga em todos os quadros usados (EVID-211) |

## Não objetivos

Mipmaps ou filtro linear em runtime (rejeitados); mudar a altura em tela de qualquer herói (isso é BUG-025 e a revisão de escala combinada para quando as imagens novas entrarem); regerar arte; inimigos, retratos e HQs; mexer na velocidade de passo (BUG-028).

## Lacunas

| Id | Lacuna | Classe | Tratamento |
|---|---|---|---|
| G1 | Qual variante agrada ao olho do dono | NON_BLOCKING | Decisão visual do piloto (B-001); o plano para nela |
| G2 | Herói do piloto | NON_BLOCKING | Kayron (já há antes/depois do bug); trocável por pedido |
| G3 | Zoom real do jogador (a câmera pode ter zoom) | NON_BLOCKING | O piloto captura zooms 1,0, 1,5 e 2,0 |
| G4 | Arte nova pode chegar no meio do rollout | NON_BLOCKING | A ferramenta regera por herói; nada é perdido |

Zero lacunas `BLOCKING`.

## Critérios de aceite

1. Existe `tools/reduce_hero_strips.gd` e ela é determinística (rodar duas vezes dá arquivos idênticos).
2. As três variantes do Kayron foram capturadas em jogo, com o atual ao lado; o dono escolheu uma (ou rejeitou todas e o plano parou sem mexer nos outros).
3. Para cada herói reduzido: altura em tela igual à de hoje (±1 px), pés na mesma linha (±1 px), quadros por tira iguais, nenhum quadro cortado, solidez do miolo igual (±0,03; a média de todo o alfa cai de propósito com a borda suavizada).
4. Os pixels soltos do cartão BUG-029 não aparecem nas capturas dos heróis reduzidos em 1280×720 e 1920×1080.
5. Suíte, smoke das nove fases, `kit_test` e `audit_projeto` sem falhas novas; originais intactos; tamanho do repositório cresce menos de 15 MB.
6. Cartão BUG-029 atualizado só **depois** de um playtest humano; até lá fica "implementado, aguarda playtest".

## Riscos

- **Aparência:** a pré-redução pode parecer mais suave que o vizinho mais próximo. O piloto e a escolha do dono existem por isso.
- **Efeito em cadeia:** o código usa a célula 256×384 em `hero_view.gd`; ferramentas de QA também. Mitigação: tabela por herói, QA continua lendo os originais.
- **Retrabalho:** arte nova do BUG-027 e BUG-028 substitui tiras. Mitigação: a ferramenta regera.
