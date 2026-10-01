---
id: "SPEC-115"
title: "Riqueza de cenário: piloto em Dagruve e Docas"
status: "aprovada pelo dono 2026-10-01; fases 1 e 2 implementadas (destrutíveis fixos, Sorte, armadilhas)"
created: "2026-10-01"
relations: ["[[EVID-139-playtest-higor-qa-14b15e4-2026-10-01]]", "[[PLAN-050-pos-playtest-higor-2026-10-01]]", "[[SPEC-114-passo-pelas-sombras-copia-isca]]"]
---

# SPEC-115 — Riqueza de cenário (MEC-030, piloto Dagruve + Docas)

Risco: **alto** (nova forma de jogar o mapa). Cartões: MEC-030 (guarda-chuva), MEC-033, MEC-034, MEC-035, ART-025, ART-026.

## Origem e decisões do dono
Relato IN-047/IN-048 (2026-10-01): cenário sem sentido na disposição; pede estradas, carroças, coisas destrutíveis e interativas e
armadilhas temáticas, "um cenário rico deixa a gameplay menos monótona".
- **Armadilha fere os dois** (herói e inimigos).
- **Destrutíveis soltam loot ocasionalmente**, com **sorte melhorável durante a run**.
- Piloto em Dagruve e Docas; o resultado vira molde para os outros sete biomas.

## O que já existe e será reaproveitado
- Quebráveis são inimigos parados com a flag `quebravel` (`core/battle.gd`, tabela por bioma em `BREAKABLE_TYPES_BY_STAGE`); hoje nascem em
  posições aleatórias perto do herói e têm drop garantido (ouro 65 %, poção 20 %, ímã 10 %, item 5 %).
- Zonas `telegraph` com `friendly: true` já ferem herói e inimigos (regra de Feng-tu). A armadilha usa esse mecanismo.
- Interações (`chest`, `fountain`, `altar`...) e seus pesos por fase (`stages.json`).
- Props manuais nas cenas `ui/stages/*.tscn`, decais de chão (`data/ground_decals.json`) e `TerrainLayout`.

## Regra de ouro
O layout **não consome a RNG da batalha** (como o `TerrainLayout`): as sementes do bot continuam comparáveis. Posições vêm de dados; variações usam uma RNG própria.

## Peças

### 1. Dados de cenário (`data/scenery.json`) — MEC-035
Por fase: `zones` (praça, cais, estrada, clareira), `props_fixos` (carroças, pilhas de caixotes, redes, guindaste), `destrutiveis` (tipo + posição fixa + zona)
e `armadilhas`. Mapa 60×60. Cada zona tem tema, ancora decais de estrada (trilha/remendo já existem) e agrupa props com sentido
(carroça na estrada, caixotes junto ao cais, velas junto ao altar). Nada flutua: usar o contrato de ancoragem de props (BUG-013).

- **Dagruve (distrito negligenciado, névoa e culto):** rua de pedra cruzando o mapa, carroça abandonada, barris e caixotes junto às paredes,
  velas/candelabros ao redor de uma praça com selo ritual.
- **Docas (cais, fenda e porão ritual):** cais de tábuas ao longo da água, guindaste, pilhas de carga, redes e barris, boca do porão ritual.

### 2. Destrutíveis fixos com loot e sorte — MEC-033 + MEC-035
- Carroça, barril, caixote, candelabro: inimigos parados `quebravel` colocados pelo layout, com PV por tipo (carroça aguenta mais).
  Quebram com qualquer arma; sem ação nova de combate.
- **Chance de loot ocasional:** hoje sempre cai algo. Nova regra: `chance_drop` base 55 %, +5 % por ponto de **Sorte**, teto 90 %.
- **Tabela de loot enviesada pela Sorte:** o peso do ouro cai e os pesos de poção, ímã e item sobem; item raro só passa de 5 % com Sorte.
- **Sorte** = modificador de Carisma + bônus de itens/bênçãos (`lucky_chests` já dá +4 nos baús) + um novo modificador `sorte` em itens e passivas.
  Assim melhora durante a run (nível de Carisma, itens, bênçãos) sem criar nova tela. Números em `data/difficulty.json` → `breakables`.
- Os destrutíveis aleatórios de hoje continuam (spawn dinâmico), usando a mesma tabela.

### 3. Armadilhas de cenário que ferem os dois — MEC-034
Entidade de fase com posição fixa, ciclo e telegrafia (anel vermelho), reaproveitando `zones` `telegraph` com `friendly: true`.
- **Dagruve — Selo Sacrificial:** glifo no chão que pulsa a cada 7 s (aviso de 1,2 s), 2d6 mágico em raio 1,6.
- **Docas — Carga Solta:** carga suspensa pelo guindaste cai a cada 9 s em ponto marcado (aviso de 1,0 s), 2d8 físico em raio 1,4 e deixa uma poça de slime.
- Fere herói e inimigos igualmente; inimigos comuns **não evitam** a armadilha (valor tático de levá-los até ela).
- Dano escala com `tier()` como os ataques de inimigo; sem armadilha em cima do ponto de nascimento do herói.

### 4. Interativo temático — parte de MEC-030 (fase 2)
Um objeto por bioma, reaproveitando as interações existentes com visual temático (poço de oferendas em Dagruve; guincho do cais em Docas).
Só entra se as fases 1 a 3 passarem no playtest.

### 5. Arte (ART-025, ART-026)
Fundo de fase coerente com o cenário, estrada, carroça, guindaste, pilhas de carga e glifo do selo. Prompts pelo Sabor Nottgard; o jogo roda com
os assets atuais enquanto a arte não chega (retângulos/props existentes).

## Fases de implementação (um commit por fase)
1. **Dados + destrutíveis fixos + Sorte** (MEC-033/035): `data/scenery.json`, leitor no Battle e no cenário, loot com Sorte, testes.
2. **Armadilhas** (MEC-034): entidade, telegrafia, dano em ambos, testes de dano e de não nascer sobre o herói.
3. **Layout e props com sentido** (decais de estrada, carroça, cais) com a arte disponível.
4. **Interativo temático** e arte nova (ART-025/026).

## Testes
- Destrutível fixo existe na posição do dado e quebra com dano.
- Probabilidade de drop cresce com a Sorte e respeita o teto; tabela não perde peso total.
- Armadilha fere herói e inimigo no raio, não fora dele, e respeita o aviso.
- Layout não altera a sequência da RNG da batalha (mesma semente, mesmos spawns de onda).
- Rodada do bot: Sylas, Durvall e Brook em Dagruve e Docas antes e depois.

## Não objetivos
Mapa novo, novas fases, regras de fase novas, mudar dificuldade das ondas (isso é BAL).

## Perguntas ainda abertas
- Número de destrutíveis fixos por mapa (proposta: 14 em Dagruve e 16 em Docas) e se recarregam depois de quebrados (proposta: não; os aleatórios continuam).
- Armadilhas visíveis desde o início ou reveladas ao chegar perto (proposta: sempre visíveis, para o jogador poder usá-las).

## Decisões do dono (2026-10-01)
- Quantidade: 14 destrutíveis fixos em Dagruve e 16 nas Docas; **não recarregam** depois de quebrados (os aleatórios continuam).
- Armadilhas **sempre visíveis**, para o jogador poder usá-las.

## Fase 1 — implementada 2026-10-01
- `data/scenery.json`: posições fixas dos destrutíveis por zona (usa só tipos existentes: candelabro, caixote, arbusto; carroça e barril entram com ART-026).
- `Battle.place_scenery()` (chamada em `ui/run.gd` depois dos bloqueios do cenário): posição pedida ou a livre mais próxima (até 3 tiles), nunca a menos de 4 do herói; não consome a RNG da batalha.
- Destrutíveis (fixos ou aleatórios) **não contam no limite de inimigos** do diretor (`_combat_count`).
- **Sorte**: `Battle.luck()` = mod. de Carisma + `sorte`. Chance de drop 55 % +5 %/ponto (piso 30 %, teto 90 %); pesos ouro 65 (−3/ponto, piso 20), poção 20 (+1), ímã 10 (+0,5), item 5 (+1,5); o item rolado também recebe a Sorte. Números em `data/difficulty.json` → `breakables.loot`.
- Fontes de Sorte: Carisma (atributo e passiva), afixo de item **"do Trevo"** (+1 a +2), bênção **Sorriso da Sorte** (+2).
- Testes em `tests/test_battle.gd`. Mudança de comportamento: o destrutível deixou de soltar sempre algo (agora ~55 % no início).

## Fase 2 — implementada 2026-10-01
- `data/scenery.json` → `armadilhas` por fase; `Battle._place_traps()` (chamada por `place_scenery()`) cria uma zona `kind: "trap"` por armadilha, nunca a menos de 4 do herói.
- Ciclo: `t` conta até 0; ao entrar em `warn` emite `trap_warn` (som de aviso) e a armadilha "arma"; em 0 dispara (`_fire_trap`): dano em **herói e inimigos** no raio (sem desvio, chefes inclusos), depois reinicia.
- **Selo Sacrificial** (Dagruve, (42,38), raio 1,6, 7 s, aviso 1,2 s, 2d6 mágico) e **Carga Solta** (Docas, (28,22), raio 1,4, 9 s, aviso 1,0 s, 2d8 físico, deixa uma poça de slime por 8 s). Bônus de dano = (4 + tier)/2, como os ataques de inimigos.
- Sempre visíveis: `ui/overlay.gd` `_draw_trap` (glifo roxo com raios em Dagruve, anel âmbar nas Docas); ao armar, a cor vira vermelha e o preenchimento cresce até o disparo.
- Visual provisório (desenhado por código); arte própria do glifo e da carga em ART-026.
- Testes em `tests/test_battle.gd`: colocação, aviso antes do dano, dano em herói e inimigo dentro do raio, nada fora, ciclo reinicia, poça das Docas.
- Capturas conferidas na janela do jogo (Dagruve e Docas).

## Fases 3 e 4 sem arte nova — implementadas 2026-10-01
Decisão do dono: seguir sem as imagens novas (ART-025/026 seguem na fila do ChatGPT).
- **Layout por zonas** (`ui/scenery_layout.gd`, dados em `data/scenery.json` → `props` e `_kinds`): em Dagruve e Docas os props soltos da cena (~66 por mapa) são
  substituídos por aglomerados com sentido, só com a arte existente.
  - Dagruve: praça do selo (braseiros, velas, ossos em volta do glifo), rua leste-oeste com pilares em ruínas, beco de carga a oeste, sudoeste, norte em ruínas, leste e sudeste.
  - Docas: borda do cais (margem, braseiros, correntes), armazém norte (carga, barris), redes, carga oeste, cais sul (braseiros entre os candelabros), pier leste, porão ritual (velas, ossos, livros), margem leste e sul aberto.
  - Nada nasce a menos de 5 tiles do início; testes impedem prop sobre destrutível ou dentro da armadilha. Fases sem `props` no JSON continuam com a cena como estava.
- **Interativos fixos** (`interativos`): poço de oferendas em Dagruve (reaproveita `fountain`) e oficina do cais nas Docas (reaproveita `ferreiro`). Não contam no limite de 4 interações aleatórias.
- **Estradas** (`estradas` + `GroundDecals.road_placements`): infraestrutura pronta e **dormente**. As trilhas atuais não são alinhadas ao eixo isométrico (ficam como manchas soltas), então a estrada só liga quando existir
  `assets/decals/dagruve_estrada_trecho.png` (ART-026, C03). Rua leste-oeste em y=26 e rua do selo em x=42 já estão declaradas.
- Capturas conferidas na janela do jogo.
- **Falta (depende de arte):** estradas, carroça e pilha de carga como destrutíveis novos, glifo e carga das armadilhas, fundo atrás do mapa, arte do poço e do guincho.
