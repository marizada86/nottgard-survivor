# SPEC-093 — Mapas maiores: 60×60 tiles (MEC-012)

Status: **implementada (2026-09-29); validação em playtest.**

Origem: T01 S2-N7 ("mapa apertado, claustrofóbico; ampliar ou fazer loop") e a pergunta 8 do questionário 002 (T01 e T02
concordam; **T03 discorda**; prioridade nº 2 de T02), em [[EVID-106-playtest-publico-t01-higor-2026-09-29]],
[[EVID-107-playtest-publico-t02-hiago-2026-09-29]] e [[EVID-108-playtest-publico-t03-dna-2026-09-29]]. Decisões do dono
(2026-09-29): **60×60** em **todas as fases**, **props escalados**, balanceamento **mantido e medido com o bot**;
sobre o terreno, o dono escolheu "aguardar o ART-012" (ver "Interpretação" abaixo).

## O que mudou

| Item | Antes | Depois |
|---|---|---|
| Lado do mapa (`Ground.map_size` nas 9 cenas) | 40×40 (1 600 tiles) | **60×60 (3 600 tiles, 2,25× de área)** |
| Herói e pontos de spawn | centro 20,20 | ×1,5 (centro 30,30) |
| Props originais | posições de 40×40 | ×1,5 (a projeção isométrica é linear) |
| Densidade de props | ~0,04 por tile | cópias determinísticas (dagruve +72, docas +10, shedaklah +54, molor +57, durao +42, feng_tu +42, shendilavri +47, goranthis +42, pilares +42) **e redistribuição**: props que ficavam fora do mapa (docas e margens de Dagruve, ossos, etc.) foram realocados para dentro (2,5 tiles de margem) e toda célula de 12×12 tem pelo menos a densidade original de props por tile |
| Terreno (materiais, rio Estige, montanhas de Durao, poças de Molor, bordas) | desenhado para 40×40 | o mesmo desenho **esticado ×1,5** (`TerrainLayout.scale`) |

## Implementação

- `TerrainLayout.scale` (`core/terrain_layout.gd`): as consultas públicas (`material_at`, `is_blocked`,
  `distance_to_styx`, `direction_to_styx`, `styx_sample`, `mountain_anchors`) convertem o ponto para o desenho
  original e devolvem distâncias e raios já escalados. **Padrão 1,0** (testes, bot e qualquer código que não defina).
- `ui/run.gd` e `ui/ground.gd` definem `scale = map_size.x / 40` ao carregar e ao desenhar a fase.
- `tools/enlarge_stage_maps.gd` gerou as cenas (idempotente; posições ×1,5, `map_size = 60×60`, cópias de props
  fora de montanhas, água do Estige, do ponto inicial e a ≥ 2,3 tiles de outros props).
- `tools/rebalance_stage_props.gd` (2º passe, idempotente): realoca props fora da margem e completa as células de 12×12 abaixo da densidade original. Nasceu de um relato do dono no primeiro teste do mapa 60×60: "embaixo não tem nada e em cima tem objetos saindo do cenário".
- `tools/bot.gd` ganhou o 6º argumento (lado do mapa) para medir 60×60; `tools/shot.gd` a flag `wide` (câmera aberta).
- Não mudam: spawn em anel em volta do herói, tetos de inimigos, velocidade da névoa, distâncias de eventos.

## Interpretação da decisão sobre o terreno

O dono escolheu **aguardar o ART-012** para o terreno novo. Deixar o desenho parado em 40×40 dentro de um mapa de
60×60 empurraria o herói para dentro do rio e das paredes de borda; por isso esticar a matemática (sem arte nova, sem
lore) é o único jeito de o mapa maior funcionar **agora**. A camada visual nova (estruturas, remendos de solo e
trilhas, ART-PROMPTS-026) continua esperando o ART-012 e será posicionada sobre o mapa 60×60. Se preferir voltar
atrás, `git revert` do commit da SPEC-093 restaura 40×40.

## Testes

`tests/test_map_scale.gd`: nenhum prop fora da margem e nenhuma célula de 12×12 sem prop nas 9 cenas; o material em `p×1,5` (escala 1,5) é o mesmo que em `p` (escala 1) nas 9 fases; montanhas,
água do Estige e distância escalam; as 9 cenas têm `map_size` 60×60 e o herói no centro.

## Medição (bot, começo em Dagruve, 5 sementes por herói)

Ver o resultado em [[EVID-111-mapas-60x60-bot-2026-09-29]].

## Limites

- Cópias de props são determinísticas, mas não desenhadas à mão: pode haver agrupamentos pouco naturais.
- O bot não mede a sensação de espaço; o playtest decide se 60×60 resolveu o "apertado" sem deixar o mapa vazio.
- A Maré de Névoa cobre o mapa na mesma proporção, mas percorre 50% mais distância; o efeito não foi medido.
