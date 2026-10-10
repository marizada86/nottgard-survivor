---
id: "SPEC-119"
title: "Segredos, Ecos de Nottgard e mapa maior"
status: "SUBSTITUÍDA em 2026-10-09 pela SPEC-152 (fatia piloto, implementada) e pela SPEC-157 (demais fases, executada); rascunho mantido como origem"
created: "2026-10-03"
relations: ["[[PLAN-055-mapas-vivos-segredos-e-dificuldade-2026-10-03]]", "[[EVID-147-auditoria-vault-x-jogo-2026-10-03]]", "[[SPEC-093-mapas-60x60]]", "[[SPEC-115-riqueza-de-cenario-piloto-dagruve-docas]]", "[[SPEC-117-alma-e-historia-na-run]]"]
cards: ["MEC-012", "MEC-032", "MEC-039"]
---

# SPEC-119 — Segredos, Ecos de Nottgard e mapa maior (PLAN-055 F4)

Origem: T03 (Daniel), 2026-10-03: "mapa maior com coisas escondidas e
referências à história de Nottgard". Decisão do dono (D3): **segredos
colecionáveis**; lore continua sendo sabor, mas recompensa quem explora.

**Rascunho:** nada implementado.

## Por que o mapa maior agora (e não antes)

Em EVID-108 (Q8), o mesmo Daniel **discordou** de mapa maior. O 60×60 da
SPEC-093 só esticou o mesmo conteúdo. O pedido de hoje é diferente: mapa maior
**com o que achar**. Por isso o aumento vem amarrado aos segredos; sem eles,
não vale a pena.

Inimigos nascem em anel em volta do herói (SPEC-093), então o mapa maior
**não dilui** o combate: só dá mais chão para explorar.

## 1. Tamanho

| Fases | Hoje | Proposta |
|---|---|---|
| Dagruve, Docas | 60×60 | **60×60** (início rápido; já têm cenário por dados da SPEC-115) |
| Shedaklah a Goranthis | 60×60 | **84×84** (≈ 2× de área) |
| Pilares | 60×60 | 60×60 (arena do modo infinito) |

Mesmo caminho da SPEC-093: `map_size` nas cenas, `TerrainLayout.scale`,
`tools/enlarge_stage_maps.gd` e `tools/rebalance_stage_props.gd`, chão assado de
novo (`tools/bake_ground.gd`, PLAN-054). O centro continua arena aberta; a
área nova vai para os **pontos de interesse** (POI) nas bordas.

## 2. Pontos de interesse (POI)

3 ou 4 por fase, nas bordas e cantos, cada um com algo a ganhar:

- **Ruína** com Eco e baú comum.
- **Câmara selada** (Relíquia da fase; abre com chave ou enigma).
- **Santuário** do bioma (bênção temporária, ligada ao gancho da fase).
- **Covil** de um elite opcional que guarda o baú melhor.

Definidos por dados (extensão de `data/level_design.json` ou
`data/scenery.json`), posição fixa por fase com pequena variação por semente,
sem consumir a RNG da batalha (mesma regra da SPEC-115).

## 3. Ecos de Nottgard (colecionável de lore)

- **3 a 5 por fase**, escondidos: atrás de destrutível, dentro de POI, no fim de
  um acontecimento (SPEC-118), ou dropado por um elite específico.
- Ao tocar: pausa curta (≤ 2 s, sem travar a run) e a frase do Eco; o texto
  completo vai para o **Diário** no Quartel, numa aba "Ecos", com a fonte.
- Texto: **paráfrase curta** do Vault (1 a 3 frases), no padrão de
  `stage_story` e `chronicles`, com `fonte_vault`. Nada do que EVID-147 lista
  como proibido.
- Exemplos (rascunho, pedem aprovação um a um):

| Fase | Eco | Fonte |
|---|---|---|
| Dagruve | "Antes de Dagruve, os mais antigos chamavam este chão de Greenhold." | S9-37 |
| Dagruve | Capela abandonada: os Guardas Celestiais enviados à fratura não voltaram | S7-08 |
| Docas | "Seremos um só", inscrição abissal junto à porta do porão | S2 |
| Shedaklah | O colar de retorno, deixado no arco de pedra para abrir o portal roxo | S16 |
| Molor | Diário do chefe dos cultistas de Thullgrime: "nos deixou só com uma casca vazia" | S17; `06_Itens/Diário do Chefe dos Cultistas de Thullgrime` |
| Durao | Os desertores: a guerra do andar acabou e ninguém sabe quem venceu | S16 |
| Feng-tu | Quem segue a estrela de Tou Um por muito tempo acaba vencido, no tempo dela | S18 |
| Shendilavri | Na loja de Rivenheart, nenhum item tinha magia | S18 |
| Goranthis | A ordem do mural: dor, luta, fúria que se acalma, alegria, conhecimento, paz, esperança | S19 |

Mais matéria-prima: os 29 itens/documentos do Vault ainda fora do jogo
(EVID-147 §4).

## 4. Relíquia da fase (o segredo grande)

Uma por fase, em câmara selada. Item **único** (não sai em baú comum),
ligado à lore, com efeito modesto e identidade forte. Exemplos:

| Fase | Relíquia | Como abre | Efeito (rascunho) |
|---|---|---|---|
| Molor | Baú das barracas de Thullgrime | completar o Ritual de estagnação (SPEC-118) | sorteia Lâmina da Digestão, Manto do Pântano ou Anel da Resistência Abissal (já existem) |
| Durao → Goranthis | **A runa de Vhaerith** (cadeia) | pedido em Durao; runa errada em Feng-tu (d6 = 5, S18); a certa escondida em Shendilavri ou Goranthis; voltar a Durao numa run seguinte | conquista + Eco final; libera um aprimoramento no Quartel |
| Goranthis | Espelho das Almas Desejantes | enigma das 7 runas na ordem do mural | mostra o "maior desejo": rerrolagem grátis por fase |
| Shendilavri | Cajado de desejos sussurrantes (já existe) em versão de relíquia | resgatar as vítimas drenadas | — |

## 5. Pista, não caça cega

- Eco perto (≤ 6 tiles): brilho leve e som baixo.
- Contador no HUD só depois do primeiro Eco achado na fase ("Ecos 1/4").
- No Quartel, por fase: "Ecos 3/5 · Relíquia ✓". Completar a fase dá
  conquista e moeda (sumidouro e motivo para voltar: MEC-015, MEC-016).

## 6. Riscos

- Explorar tira o jogador do centro, onde fica a pressão: a recompensa precisa
  compensar o tempo, senão ninguém vai. O POI deve ficar a ≤ 25 s de caminhada
  do centro.
- Texto demais quebra o ritmo: Eco curto na run, texto longo só no Diário.
- O bot não explora: o efeito só aparece em playtest humano.

## Testes

- `tests/test_map_scale.gd` ampliado para 84×84 nas fases 3 a 8.
- Cada Eco tem `fonte_vault` preenchida e não contém termos da lista de
  proibidos (teste de dados com lista de palavras: "Astherion" junto de
  "Durvall", "colar" junto de "Adam", etc.).
- Playtest: perguntar a T03 se achou e se quis procurar.
