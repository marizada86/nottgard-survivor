---
id: "ART-PROMPTS-007"
type: "prompts-de-arte"
title: "Biomas, props e thumbnails"
status: "approved-for-generation"
created: "2026-09-21"
relations: ["[[ART-PROMPTS-001-direcao-e-piloto]]", "[[ASSET-MATRIX-001-imagens-e-prompts-2026-09-21]]"]
sources: ["data/stages.json", "PLAN-002"]
---

# Biomas, props e thumbnails

> Lote posterior: possui prompts, mas a geração espera integração e piloto aprovados.

## Bloco — atlas de piso

```text
Use case: stylized-concept
Asset type: atlas de piso isométrico para jogo
Style/medium: pixel art sombria, pixels nítidos, dithering controlado, luz neutra superior esquerda
Composition/framing: quatro losangos isométricos 2:1 de 64x32 organizados em uma faixa 128x64 final; cada célula repete sem emenda e não possui objeto alto
Constraints: piso opaco, sem texto, personagens, sombras direcionais fortes, bordas visíveis entre tiles ou ponto focal; adequado a nearest-neighbor
```

| ID / arquivo final | Prompt específico |
|---|---|
| `dagruve_ground` → `assets/tiles/dagruve_ground.png` | Pedra molhada cinza-azulada de cais, juntas escuras, musgo mínimo, respingos âmbar e roxo doentio muito discretos. |
| `shedaklah_ground` | Solo marrom fúngico com micélio violeta, pequenas manchas de lodo e fibras; sem cogumelos altos. |
| `molor_ground` | Rocha verde-negra coberta por filme viscoso, bolhas achatadas e resíduos ácidos. |
| `durao_ground` | Basalto árido rachado, poeira ferrugem e finos veios azul-fantasma. |
| `feng_tu_ground` | Lajes azul-ardósia de templo, juntas vermelhas gastas e marcas verdes de peste sem escrita. |
| `shendilavri_ground` | Pedra vinho e preta polida, filetes de prata, pequenas rachaduras magenta ilusórias. |
| `goranthis_ground` | Mármore marfim e dourado gasto, musgo verde-água e fissuras orgânicas quase invisíveis. |
| `pilares_ground` | Pedra violeta quase preta, veios lilás elétricos e fragmentos de várias camadas, sem símbolo central. |

Candidata: `.atena/generated/art-candidates/tiles/<id>_vNN.png`. Matriz 1024×512; final conforme atlas. Aceite: teste 8×8 sem costura ou repetição gritante.

## Bloco — props

```text
Use case: stylized-concept
Asset type: prop isométrico de cenário
Style/medium: pixel art densa e sombria coerente com os sprites
Composition/framing: um objeto em três quartos isométrico, câmera 30 graus acima, base central inferior, 12% de margem, luz superior esquerda
Constraints: fundo realmente transparente, sem chão ou sombra separada, texto, personagens, moldura ou marca-d'água; silhueta legível a 64–160 px
```

Cada linha gera `assets/props/<id>.png`, candidata `.atena/generated/art-candidates/props/<id>_vNN.png`, final até 256×256 RGBA.

| ID | Prompt específico; variantes da família mantêm material/escala |
|---|---|
| `pilar_01` | Pilar inteiro e estreito de cais/cripta em pedra cinza molhada, cera e aro de ferro. |
| `pilar_02` | Pilar da mesma família quebrado ao meio, topo lascado e cera escorrida. |
| `pilar_03` | Pilar largo da mesma família com argola e corrente curta enferrujada. |
| `cogumelo_01` | Torre fúngica única de Shedaklah, marrom-violeta, chapéu rosa de esporo. |
| `cogumelo_02` | Grupo compacto de três cogumelos da mesma família em alturas diferentes. |
| `cogumelo_03` | Arco baixo de micélio e chapéus pendentes da mesma família. |
| `bolha_01` | Bolsa viscosa única alta de Molor, verde-negra, presa a base rochosa. |
| `bolha_02` | Ninho compacto de bolhas da mesma substância, tamanhos variados. |
| `bolha_03` | Coluna viscosa colapsada com detritos internos, mesma família. |
| `rocha_01` | Monólito lascado de Durao em basalto/ferrugem, veio azul de alma. |
| `rocha_02` | Pilha baixa de três rochas da mesma família, poeira ferrugem. |
| `rocha_03` | Fragmento de basalto com grilhão oxidado e veio azul discreto. |
| `torii_01` | Portal torii inteiro de Feng-tu em madeira vermelha e ardósia, sem escrita. |
| `torii_02` | Lateral quebrada do mesmo torii, viga inclinada ainda presa à base. |
| `torii_03` | Mini-santuário fechado da mesma família, sem estátua ou escrita. |
| `cristal_01` | Agulha única de cristal vinho/magenta de Shendilavri com encaixe prateado. |
| `cristal_02` | Leque baixo de três cristais da mesma família. |
| `cristal_03` | Cristal rachado da mesma família com reflexo ilusório preso à superfície. |
| `cachoeira_01` | Fonte vertical compacta de Goranthis, mármore e água verde-água. |
| `cachoeira_02` | Pequena queda de água sobre arco de mármore da mesma família. |
| `cachoeira_03` | Bacia rachada da mesma família revelando carne sob o mármore. |
| `pilar_abissal_01` | Monólito em forma de lâmina, violeta-negro com veio lilás elétrico. |
| `pilar_abissal_02` | Par de monólitos torcidos da mesma pedra, unidos na base. |
| `pilar_abissal_03` | Fragmento flutuante preso por energia lilás a uma base quebrada. |

Aceite: três silhuetas distintas por família; colisão visual semelhante; nenhuma variante introduz nova facção.

## Bloco — thumbnails

```text
Use case: stylized-concept
Asset type: thumbnail de fase
Style/medium: pixel art cinematográfica sombria coerente com o jogo
Composition/framing: paisagem 3:2, ponto focal ambiental central, espaço escuro nas bordas para UI, sem personagens dominantes
Constraints: imagem opaca, sem texto, logotipo, HUD ou moldura; leitura clara a 240x160
```

Matriz 1536×1024; final `assets/stages/<stage_id>_thumb.png`, 480×320 RGB.

| Stage | Prompt específico |
|---|---|
| `dagruve` | Docas de pedra molhada na névoa, pilares e velas, rasgo roxo distante. |
| `shedaklah` | Pântano dividido pelo Estige: floresta de cogumelos de um lado, mar de slime do outro. |
| `molor` | Caverna verde-negra de bolhas, passarelas de lixo e silhueta de Thullgrime. |
| `durao` | Deserto de basalto, jaula colossal, rio azul de almas e ferrugem. |
| `feng_tu` | Templo de ardósia sob Estrela do Norte, torii vermelho e névoa verde de epidemia. |
| `shendilavri` | Rivenheart costeira ao pôr do sol vinho, muralhas, cristais e reflexos falsos. |
| `goranthis` | Paraíso de mármore e cachoeira impossível, com rachadura revelando carne e slime. |
| `pilares` | Monólitos violeta-negros sob céu rasgado, fragmentos das seis camadas convergindo. |
