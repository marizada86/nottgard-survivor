---
id: "ART-PROMPTS-026"
type: "prompts-de-arte"
title: "Lote 2 — camada de cenário por bioma (estruturas, remendos de solo e trilhas)"
status: "16 decais admitidos — Docas e estruturas pendentes; ondas de HQ seguem em ART-PROMPTS-028 e 029"
created: "2026-09-29"
relations: ["[[SPEC-062-fila-de-geracao-externa-de-assets]]", "[[ART-PROMPTS-024-cenario-e-quebraveis-por-bioma]]", "[[ART-PROMPTS-007-biomas-props-thumbnails]]", "[[SPEC-042-ancoras-artisticas-e-sombras-de-props]]", "[[RESEARCH-001-abismo-bestiario-visual-2026-09-21]]"]
sources: ["backlog/ARTE.md ART-012", "EVID-106 IN-010, IN-018", "BUG-013", "data/stages.json", "RESEARCH-001", "ART-PROMPTS-007", "assets/stages/*_thumb.png"]
---

# Lote 2 — camada de cenário por bioma

## Contexto

ART-012 nasceu do playtest de T01 (IN-010, IN-018): o terreno é simples e
destoa da estética, e ele pede uma **nova camada de ambientação** — casas,
ruínas, grama, areia, caminhos de pedra e trilhas — remetendo à lore e
reaproveitando o que já existe. T02 e T03 concordaram "em parte" (Q12).

Hoje cada bioma tem: (1) um piso repetível (`assets/tiles/<bioma>_ground*`),
(2) props isolados (`assets/props/`) e (3) o thumbnail. **Falta tudo entre o
piso e os props**: nada quebra a repetição do chão e nenhuma estrutura dá
sensação de lugar. O lote acrescenta **três camadas**, nove biomas, **27
imagens**.

Nada foi gerado. Este documento só prepara os prompts e as recomendações.

## Reconciliação de execução — 2026-09-29

- Remendo e trilha de Dagruve, Shedaklah, Molor, Durão, Feng-tu,
  Shendilavri, Goranthis e Pilares foram aprovados visualmente, normalizados,
  validados e admitidos em `assets/decals/`.
- Docas permanece sem decal: a cena ainda não fornece uma âncora seca de cais.
- As nove estruturas seguem como candidatas e as HQs pertencem a uma
  integração independente.

## Recomendação da Atena (resposta a IN-010 / IN-018)

Ordem de camadas, de baixo para cima, para cada bioma:

| Camada | Estado | O que faz |
|---|---|---|
| 1. Piso repetível | existe | base do bioma; não mexer |
| 2. **Remendo de solo** | **novo (este lote)** | mancha irregular (grama, areia, lodo…) que **quebra a repetição** do piso |
| 3. **Trilha** | **novo (este lote)** | trecho de caminho que guia o olhar e dá sensação de rota |
| 4. **Estrutura** | **novo (este lote)** | ruína ou construção maior: dá sensação de lugar e de história |
| 5. Props existentes | existe | densidade atual; reaproveitar (tabela abaixo) |

Regras de uso, para o desenho da integração (fora do escopo de imagem):

1. **Remendos e trilhas ficam no chão, abaixo dos inimigos e dos props**, sem
   colisão. Devem parecer pintados no piso, não objetos.
2. **Estruturas ocupam pouco espaço**: 1 a 3 por mapa, longe do ponto inicial,
   para não agravar o mapa "claustrofóbico" (MEC-012) nem reintroduzir travas
   de inimigos (BUG-012). Colisão só onde a spec de integração decidir.
3. **Densidade sugerida por mapa:** 6–10 remendos, 2–3 trilhas, 1–3 estruturas.
4. **Referências de estética:** as do projeto (Vampire Survivors e Death Must
   Die, citadas em ART-007) e os thumbnails `assets/stages/*_thumb.png`, que
   já têm a linguagem visual desejada (ex.: Feng-tu com degraus, torii e
   névoa verde).

### Reaproveitamento (T01 pediu "reaproveitar assets existentes")

| Bioma | Props existentes que combinam com a nova camada |
|---|---|
| Dagruve | `pilar_*`, `velas_*`, `braseiro_*`, `livros_*`, `ossos_*` |
| Docas | `doca_*`, `barril_*`, `caixote_*`, `carga_*`, `rede_*`, `margem_*` |
| Shedaklah | `cogumelo_*`, `esporo_*`, `lodo_01` |
| Molor | `bolha_*`, `estalactite_*`, `resina_01` |
| Durão | `rocha_*`, `corrente_*`, `osso_01` |
| Feng-tu | `torii_*`, `lanterna_*`, `sino_01` |
| Shendilavri | `cristal_*`, `veu_01`, `taca_01`, `espelho_ornado_01` |
| Goranthis | `cachoeira_*`, `coluna_01`, `flor_01`, `taca_dourada_01` |
| Pilares | `pilar_abissal_*`, `fragmento_01`, `runa_01`, `nucleo_01` |

## Dependência importante: BUG-013 (props flutuando)

BUG-013 (P2, **confirmado por 3 de 3 jogadores**, ver SPEC-041/042) é o
"asset flutuando" que T01 associa a este pedido. Duas consequências:

1. **Os prompts abaixo já exigem contato firme com o chão** (entulho, raízes,
   escombros na base, sem pixels soltos abaixo). Isso é necessário, mas não
   suficiente: a âncora final é definida em código (SPEC-042).
2. **Recomendo fechar BUG-013 antes de admitir qualquer estrutura deste lote.**
   Se não, o defeito se multiplica por 27 assets. Gerar os candidatos pode
   acontecer em paralelo, só a admissão espera.

Também é necessário abrir uma **spec de integração** (próximo número livre:
SPEC-079) para a camada de decais (remendo/trilha), que hoje **não existe** no
código. Este lote entrega arte; ele não faz o jogo desenhá-la.

## Sabor Nottgard por bioma

Só fatos canônicos de RESEARCH-001 e `data/stages.json`; sem lore nova.

| Bioma | Fato canônico usado | Materiais e paleta (de ART-PROMPTS-007) |
|---|---|---|
| Dagruve | "Distrito negligenciado · névoa e culto" | pedra molhada cinza-azulada, musgo mínimo |
| Docas | "Cais, fenda e porão ritual" | pedra e madeira úmidas, azul-petróleo escuro |
| Shedaklah | Fungo e slime; equilíbrio quebrado por Juiblex | marrom fúngico, micélio violeta |
| Molor | Decomposição, lixo, parasitas, slime; fungo secundário | rocha verde-negra com filme viscoso |
| Durão | Deserto pós-guerra, ferro oxidado, basalto, azul de almas | basalto, ferrugem, veios azul-fantasma |
| Feng-tu | Templo destruído de Tou Um; peregrinação da estrela; peste | lajes azul-ardósia, juntas vermelhas, verde de peste |
| Shendilavri | Cidade murada; luxo corrompido e ilusão | pedra vinho e preta, prata, magenta |
| Goranthis | Paraíso ilusório: começa belo e termina orgânico | mármore marfim e ouro, musgo verde-água |
| Pilares | Materialização do Abismo; **mistura motivos aprovados, sem nova linguagem** | pedra violeta quase preta, veios lilás |

## Como usar (mesmas regras de ART-PROMPTS-024 e 025)

1. **Um asset por mensagem**, parágrafo completo colado. Gere o mesmo bioma
   na mesma conversa para manter a paleta.
2. **Fundo de cor sólida, nunca "transparente"**: magenta `#FF00FF` por
   padrão; ciano `#00FFFF` onde o objeto usa vinho/lilás (Shendilavri e
   Pilares). Remover a cor depois para obter o alfa real.
3. **Imagem quadrada** para estruturas; **paisagem** para remendos e trilhas.
4. **Remendos e trilhas precisam de borda irregular e suave**: se saírem com
   contorno reto, moldura ou losango perfeito, descarte. Eles serão
   sobrepostos ao piso e não podem parecer um adesivo.
5. **Cobertura sólida** nas estruturas: silhueta opaca, sem pixels soltos nem
   aspecto fantasmagórico. Descarte e regenere se aparecer.
6. **Ordem de geração:** piloto em **Dagruve** (3 imagens). Só após o dono
   aprovar o piloto seguem as demais, um bioma por vez.
7. Candidatas em `.atena/generated/art-candidates/scenery/<bioma>/`. Nada vai
   para `assets/` sem aprovação explícita do dono e sem BUG-013 fechado.

## Especificação técnica

| Tipo | Tamanho final | Sufixo do ID | Destino provável |
|---|---|---|---|
| Estrutura | até 256×256 RGBA | `_estrutura_01` | `assets/props/` |
| Remendo de solo | 256×128 RGBA (2:1) | `_remendo_01` | `assets/decals/` (novo) |
| Trilha | 256×128 RGBA (2:1) | `_trilha_01` | `assets/decals/` (novo) |

Prefixo do ID: `dagruve`, `docas`, `shedaklah`, `molor`, `durao`, `feng_tu`,
`shendilavri`, `goranthis`, `pilares`. Os destinos são sugestão; a spec de
integração define os definitivos.

---

## Parágrafos prontos para o ChatGPT

### Piloto — Dagruve

**`dagruve_estrutura_01`**
> A small abandoned two-story house from a neglected city district, half-collapsed, built of weathered gray-blue stone and dark rotting timber, with a partly fallen roof, boarded and broken windows, a crooked chimney, and a faint sickly mist clinging to its foundation. It looks lived-in long ago and then abandoned, with no writing, signs or symbols. Dark-fantasy isometric pixel-art game prop, viewed from a three-quarter isometric angle tilted about 30 degrees from above, with soft directional light from the upper left. Crisp, clean pixel-art rendering with controlled dithering, no blur and no smooth anti-aliasing. The object sits centered with roughly 12% empty margin on every side and does not touch the frame edges. Its base rests firmly on the ground with a solid footing of rubble and fallen stones, so nothing looks like it is hovering, and no stray pixels float below the base. The whole silhouette is solid and fully opaque. Background: a single, completely flat and uniform solid magenta color (#FF00FF), with no ground plane, cast shadow, gradient, vignette, texture, or scenery. No text, logo, watermark, frame, border, UI element, character, creature, or second object — only this one house, alone. Square image.

**`dagruve_remendo_01`**
> A flat irregular patch of sickly, sparse gray-green grass and weeds pushing up through cracked wet gray-blue cobblestones, with a few bare stones and small dark puddles showing through. It is a ground decal: seen from a three-quarter isometric angle tilted about 30 degrees from above, it reads as a flat patch lying on the floor, wider than tall (about 2:1), with soft irregular organic edges that fade out into nothing, and no raised object taller than a few pixels. Dark-fantasy pixel-art style, soft light from the upper left, crisp clean pixel art with controlled dithering, no blur and no smooth airbrushed gradient. Centered with roughly 8% empty margin, not touching the frame edges. Background: a single, completely flat and uniform solid magenta color (#FF00FF), with no scenery, no cast shadow, no gradient or texture behind it. No text, logo, watermark, frame, border, UI element, character, creature, or second object, and no hard straight edges or perfect diamond outline — only this one ground patch, alone. Landscape image.

**`dagruve_trilha_01`**
> A worn stretch of an old city lane made of uneven gray-blue cobblestones with dark mortar, some stones cracked or missing, faint moss in the joints, running from the left side of the image to the right side as a slightly winding strip. It is a ground decal: seen from a three-quarter isometric angle tilted about 30 degrees from above, it reads as a flat path lying on the floor, wider than tall (about 2:1), with ragged edges where the stones thin out and fade into nothing at both ends, and no raised object taller than a few pixels. Dark-fantasy pixel-art style, soft light from the upper left, crisp clean pixel art with controlled dithering, no blur and no smooth airbrushed gradient. Centered with roughly 8% empty margin. Background: a single, completely flat and uniform solid magenta color (#FF00FF), with no scenery, no cast shadow, no gradient or texture behind it. No text, logo, watermark, frame, border, UI element, character, creature, or second object, and no perfect diamond outline — only this one path, alone. Landscape image.

### Docas

**`docas_estrutura_01`**
> A small dockside warehouse corner: a ruined storage shed of dark damp timber and gray stone at the edge of a quay, with a sagging tarred roof, a broken loading hatch, a rusted winch and a few snapped mooring posts at its base, salt stains and wet dark streaks running down the walls. It looks like a working harbor building that has been left to rot, with no writing, signs or symbols. Dark-fantasy isometric pixel-art game prop, viewed from a three-quarter isometric angle tilted about 30 degrees from above, soft directional light from the upper left. Crisp, clean pixel-art rendering with controlled dithering, no blur and no smooth anti-aliasing. Centered with roughly 12% empty margin on every side, not touching the frame edges. Its base rests firmly on the ground with a solid footing of planks, stones and debris, so nothing looks like it is hovering, and no stray pixels float below the base. The whole silhouette is solid and fully opaque. Background: a single, completely flat and uniform solid magenta color (#FF00FF), with no ground plane, cast shadow, gradient, vignette, texture, or scenery. No text, logo, watermark, frame, border, UI element, character, creature, or second object — only this one shed, alone. Square image.

**`docas_remendo_01`**
> A flat irregular patch of wet dark silt and damp sand mixed with scattered small pebbles, shell fragments and a few strands of dark seaweed, with a shallow puddle catching a dull teal reflection. It is a ground decal: seen from a three-quarter isometric angle tilted about 30 degrees from above, it reads as a flat patch lying on the floor, wider than tall (about 2:1), with soft irregular organic edges that fade out into nothing, and no raised object taller than a few pixels. Dark-fantasy pixel-art style, soft light from the upper left, crisp clean pixel art with controlled dithering, no blur and no smooth airbrushed gradient. Centered with roughly 8% empty margin, not touching the frame edges. Background: a single, completely flat and uniform solid magenta color (#FF00FF), with no scenery, no cast shadow, no gradient or texture behind it. No text, logo, watermark, frame, border, UI element, character, creature, or second object, and no hard straight edges or perfect diamond outline — only this one ground patch, alone. Landscape image.

**`docas_trilha_01`**
> A stretch of old wooden boardwalk made of weathered dark planks with rusted nails, some planks broken or missing, laid over wet stone and running from the left side of the image to the right side as a slightly uneven strip, with a rope or chain remnant along one edge. It is a ground decal: seen from a three-quarter isometric angle tilted about 30 degrees from above, it reads as a flat path lying on the floor, wider than tall (about 2:1), with ragged edges where the planks end and fade into nothing at both ends, and no raised object taller than a few pixels. Dark-fantasy pixel-art style, soft light from the upper left, crisp clean pixel art with controlled dithering, no blur and no smooth airbrushed gradient. Centered with roughly 8% empty margin. Background: a single, completely flat and uniform solid magenta color (#FF00FF), with no scenery, no cast shadow, no gradient or texture behind it. No text, logo, watermark, frame, border, UI element, character, creature, or second object, and no perfect diamond outline — only this one path, alone. Landscape image.

### Shedaklah

**`shedaklah_estrutura_01`**
> A ruined stone hut swallowed by fungus: low crumbling walls of dark stone almost completely covered in thick brown-violet mycelium, with soft pink spore-cap growths sprouting from the roof and doorway, a collapsed roof, and slimy drips running down the walls. It clearly began as a simple shelter and was taken over by a fungal swamp, with no writing, signs or symbols. Dark-fantasy isometric pixel-art game prop, viewed from a three-quarter isometric angle tilted about 30 degrees from above, soft directional light from the upper left. Crisp, clean pixel-art rendering with controlled dithering, no blur and no smooth anti-aliasing. Centered with roughly 12% empty margin on every side, not touching the frame edges. Its base rests firmly on the ground with a thick footing of roots, mycelium and fallen stones, so nothing looks like it is hovering, and no stray pixels float below the base. The whole silhouette is solid and fully opaque. Background: a single, completely flat and uniform solid magenta color (#FF00FF), with no ground plane, cast shadow, gradient, vignette, texture, or scenery. No text, logo, watermark, frame, border, UI element, character, creature, or second object — only this one hut, alone. Square image.

**`shedaklah_remendo_01`**
> A flat irregular patch of brown fungal soil covered by a mat of fine violet mycelium threads, with tiny pale spore dots, small damp slime smears and a few very small flat mushroom caps no taller than a few pixels. It is a ground decal: seen from a three-quarter isometric angle tilted about 30 degrees from above, it reads as a flat patch lying on the floor, wider than tall (about 2:1), with soft irregular organic edges that fade out into nothing. Dark-fantasy pixel-art style, soft light from the upper left, crisp clean pixel art with controlled dithering, no blur and no smooth airbrushed gradient. Centered with roughly 8% empty margin, not touching the frame edges. Background: a single, completely flat and uniform solid magenta color (#FF00FF), with no scenery, no cast shadow, no gradient or texture behind it, and no magenta or pink on the patch itself except a muted violet. No text, logo, watermark, frame, border, UI element, character, creature, or second object, and no hard straight edges or perfect diamond outline — only this one ground patch, alone. Landscape image.

**`shedaklah_trilha_01`**
> A winding line of flat, dark, rounded stepping stones set into brownish fungal mud, running from the left side of the image to the right side, with thin violet mycelium threads growing across the gaps between the stones and a few damp slime smears. It is a ground decal: seen from a three-quarter isometric angle tilted about 30 degrees from above, it reads as a flat path lying on the floor, wider than tall (about 2:1), with the stones thinning out and fading into nothing at both ends, and no raised object taller than a few pixels. Dark-fantasy pixel-art style, soft light from the upper left, crisp clean pixel art with controlled dithering, no blur and no smooth airbrushed gradient. Centered with roughly 8% empty margin. Background: a single, completely flat and uniform solid magenta color (#FF00FF), with no scenery, no cast shadow, no gradient or texture behind it. No text, logo, watermark, frame, border, UI element, character, creature, or second object, and no perfect diamond outline — only this one path, alone. Landscape image.

### Molor

**`molor_estrutura_01`**
> A collapsed hovel of rotten dark timber and scavenged stone, piled with refuse and old bones and coated in a glossy green-black slimy film, with slime dripping from the broken roof and a few small translucent bubbles clinging to the walls. It looks like a shelter built out of garbage and decay in a filthy cavern, with no writing, signs or symbols. Dark-fantasy isometric pixel-art game prop, viewed from a three-quarter isometric angle tilted about 30 degrees from above, soft directional light from the upper left. Crisp, clean pixel-art rendering with controlled dithering, no blur and no smooth anti-aliasing. Centered with roughly 12% empty margin on every side, not touching the frame edges. Its base rests firmly on the ground with a solid footing of refuse, slime puddles and debris, so nothing looks like it is hovering, and no stray pixels float below the base. The whole silhouette is solid and fully opaque. Background: a single, completely flat and uniform solid magenta color (#FF00FF), with no ground plane, cast shadow, gradient, vignette, texture, or scenery. No text, logo, watermark, frame, border, UI element, character, creature, or second object — only this one hovel, alone. Square image.

**`molor_remendo_01`**
> A flat irregular patch of green-black slimy scum with a dull wet sheen, scattered flat bubbles, small scraps of rotten refuse, tiny bone fragments and a few stains of acid-yellow residue. It is a ground decal: seen from a three-quarter isometric angle tilted about 30 degrees from above, it reads as a flat patch lying on the floor, wider than tall (about 2:1), with soft irregular organic edges that fade out into nothing, and no raised object taller than a few pixels. Dark-fantasy pixel-art style, soft light from the upper left, crisp clean pixel art with controlled dithering, no blur and no smooth airbrushed gradient. Centered with roughly 8% empty margin, not touching the frame edges. Background: a single, completely flat and uniform solid magenta color (#FF00FF), with no scenery, no cast shadow, no gradient or texture behind it. No text, logo, watermark, frame, border, UI element, character, creature, or second object, and no hard straight edges or perfect diamond outline — only this one ground patch, alone. Landscape image.

**`molor_trilha_01`**
> A trail of flattened refuse and rotten planks laid across green-black slime, made of warped wooden boards, packed trash and a few bones pressed into the muck, running from the left side of the image to the right side as an uneven strip, with slime creeping over its edges. It is a ground decal: seen from a three-quarter isometric angle tilted about 30 degrees from above, it reads as a flat path lying on the floor, wider than tall (about 2:1), with ragged edges that fade into nothing at both ends, and no raised object taller than a few pixels. Dark-fantasy pixel-art style, soft light from the upper left, crisp clean pixel art with controlled dithering, no blur and no smooth airbrushed gradient. Centered with roughly 8% empty margin. Background: a single, completely flat and uniform solid magenta color (#FF00FF), with no scenery, no cast shadow, no gradient or texture behind it. No text, logo, watermark, frame, border, UI element, character, creature, or second object, and no perfect diamond outline — only this one path, alone. Landscape image.

### Durão

**`durao_estrutura_01`**
> The ruined corner of a military barracks in a barren post-war wasteland: thick walls of dark basalt blocks partly collapsed, with rusted iron window bars, a broken iron door hanging open, a dented iron plate roof half torn away, and reddish rust stains running down the stone. A faint pale ghostly blue glow leaks from one doorway. It looks like a fortress prison left to ruin, with no writing, signs or symbols. Dark-fantasy isometric pixel-art game prop, viewed from a three-quarter isometric angle tilted about 30 degrees from above, soft directional light from the upper left. Crisp, clean pixel-art rendering with controlled dithering, no blur and no smooth anti-aliasing. Centered with roughly 12% empty margin on every side, not touching the frame edges. Its base rests firmly on the ground with a solid footing of fallen blocks and rusty dust, so nothing looks like it is hovering, and no stray pixels float below the base. The whole silhouette is solid and fully opaque. Background: a single, completely flat and uniform solid magenta color (#FF00FF), with no ground plane, cast shadow, gradient, vignette, texture, or scenery. No text, logo, watermark, frame, border, UI element, character, creature, or second object — only this one ruin, alone. Square image.

**`durao_remendo_01`**
> A flat irregular patch of dry cracked earth and rust-colored ash sand, with scattered small basalt pebbles, fine iron-red dust and a few faint pale-blue ghostly veins glowing softly in the cracks. It is a ground decal: seen from a three-quarter isometric angle tilted about 30 degrees from above, it reads as a flat patch lying on the floor, wider than tall (about 2:1), with soft irregular organic edges that fade out into nothing, and no raised object taller than a few pixels. Dark-fantasy pixel-art style, soft light from the upper left, crisp clean pixel art with controlled dithering, no blur and no smooth airbrushed gradient. Centered with roughly 8% empty margin, not touching the frame edges. Background: a single, completely flat and uniform solid magenta color (#FF00FF), with no scenery, no cast shadow, no gradient or texture behind it. No text, logo, watermark, frame, border, UI element, character, creature, or second object, and no hard straight edges or perfect diamond outline — only this one ground patch, alone. Landscape image.

**`durao_trilha_01`**
> A trail of packed rust-colored dust and dark basalt slabs worn smooth by marching feet, with old wheel ruts and a few rusted iron spikes or chain links half buried along its sides, running from the left side of the image to the right side as a slightly winding strip. It is a ground decal: seen from a three-quarter isometric angle tilted about 30 degrees from above, it reads as a flat path lying on the floor, wider than tall (about 2:1), with ragged edges that fade into nothing at both ends, and no raised object taller than a few pixels. Dark-fantasy pixel-art style, soft light from the upper left, crisp clean pixel art with controlled dithering, no blur and no smooth airbrushed gradient. Centered with roughly 8% empty margin. Background: a single, completely flat and uniform solid magenta color (#FF00FF), with no scenery, no cast shadow, no gradient or texture behind it. No text, logo, watermark, frame, border, UI element, character, creature, or second object, and no perfect diamond outline — only this one path, alone. Landscape image.

### Feng-tu

**`feng_tu_estrutura_01`**
> A small ruined shrine from a destroyed temple: a broken tiered roof of dark curved tiles with red-lacquered wooden pillars, partly collapsed, slate-blue stone steps at the front, faded red banners hanging torn and unreadable, and a few stains of sickly green on the stone. The place feels abandoned after a plague, with a single faint star-shaped opening in the roof, no writing, no readable symbols, and no religious figures. Dark-fantasy isometric pixel-art game prop, viewed from a three-quarter isometric angle tilted about 30 degrees from above, soft directional light from the upper left. Crisp, clean pixel-art rendering with controlled dithering, no blur and no smooth anti-aliasing. Centered with roughly 12% empty margin on every side, not touching the frame edges. Its base rests firmly on the ground with a solid footing of stone steps and fallen roof tiles, so nothing looks like it is hovering, and no stray pixels float below the base. The whole silhouette is solid and fully opaque. Background: a single, completely flat and uniform solid magenta color (#FF00FF), with no ground plane, cast shadow, gradient, vignette, texture, or scenery. No text, logo, watermark, frame, border, UI element, character, creature, or second object — only this one shrine, alone. Square image.

**`feng_tu_remendo_01`**
> A flat irregular patch of cracked slate-blue temple flagstones covered with dark green moss and greenish plague stains, with a few fallen dry leaves and small pieces of broken red roof tile. It is a ground decal: seen from a three-quarter isometric angle tilted about 30 degrees from above, it reads as a flat patch lying on the floor, wider than tall (about 2:1), with soft irregular organic edges that fade out into nothing, and no raised object taller than a few pixels. Dark-fantasy pixel-art style, soft light from the upper left, crisp clean pixel art with controlled dithering, no blur and no smooth airbrushed gradient. Centered with roughly 8% empty margin, not touching the frame edges. Background: a single, completely flat and uniform solid magenta color (#FF00FF), with no scenery, no cast shadow, no gradient or texture behind it. No text, logo, watermark, frame, border, UI element, character, creature, or second object, and no hard straight edges or perfect diamond outline — only this one ground patch, alone. Landscape image.

**`feng_tu_trilha_01`**
> A pilgrimage path of worn slate-blue stone slabs with thin worn-red joints between them, with a few slabs cracked or missing and faint green moss in the gaps, running from the left side of the image to the right side as a slightly winding strip. It is a ground decal: seen from a three-quarter isometric angle tilted about 30 degrees from above, it reads as a flat path lying on the floor, wider than tall (about 2:1), with ragged edges where the slabs thin out and fade into nothing at both ends, and no raised object taller than a few pixels. Dark-fantasy pixel-art style, soft light from the upper left, crisp clean pixel art with controlled dithering, no blur and no smooth airbrushed gradient. Centered with roughly 8% empty margin. Background: a single, completely flat and uniform solid magenta color (#FF00FF), with no scenery, no cast shadow, no gradient or texture behind it. No text, logo, watermark, frame, border, UI element, character, creature, or second object, and no perfect diamond outline — only this one path, alone. Landscape image.

### Shendilavri

**`shendilavri_estrutura_01`**
> A ruined ornate pavilion of a corrupted luxury city: a small open pavilion with polished black and deep-wine stone columns inlaid with thin silver lines, a partly collapsed domed roof, torn wine-colored silk drapes hanging between the columns, and a cracked staircase at the front. It feels like an opulent place left in decay, with a faint uncanny shimmer on the silver inlays, no writing, no symbols and no figures. Dark-fantasy isometric pixel-art game prop, viewed from a three-quarter isometric angle tilted about 30 degrees from above, soft directional light from the upper left. Crisp, clean pixel-art rendering with controlled dithering, no blur and no smooth anti-aliasing. Centered with roughly 12% empty margin on every side, not touching the frame edges. Its base rests firmly on the ground with a solid footing of steps and fallen stone, so nothing looks like it is hovering, and no stray pixels float below the base. The whole silhouette is solid and fully opaque. Background: a single, completely flat and uniform solid cyan color (#00FFFF), with no ground plane, cast shadow, gradient, vignette, texture, or scenery, and no cyan on the object itself. No text, logo, watermark, frame, border, UI element, character, creature, or second object — only this one pavilion, alone. Square image.

**`shendilavri_remendo_01`**
> A flat irregular patch of dark wine-colored petals, small scraps of torn silk and tiny glass or crystal shards scattered over polished black stone, with a few thin silver flecks glinting. It is a ground decal: seen from a three-quarter isometric angle tilted about 30 degrees from above, it reads as a flat patch lying on the floor, wider than tall (about 2:1), with soft irregular organic edges that fade out into nothing, and no raised object taller than a few pixels. Dark-fantasy pixel-art style, soft light from the upper left, crisp clean pixel art with controlled dithering, no blur and no smooth airbrushed gradient. Centered with roughly 8% empty margin, not touching the frame edges. Background: a single, completely flat and uniform solid cyan color (#00FFFF), with no scenery, no cast shadow, no gradient or texture behind it, and no cyan on the patch itself. No text, logo, watermark, frame, border, UI element, character, creature, or second object, and no hard straight edges or perfect diamond outline — only this one ground patch, alone. Landscape image.

**`shendilavri_trilha_01`**
> A grand processional walkway of polished black and deep-wine stone tiles with thin silver inlay lines running along its length, some tiles cracked and a few dark-red petals resting on it, running from the left side of the image to the right side as a slightly winding strip. It is a ground decal: seen from a three-quarter isometric angle tilted about 30 degrees from above, it reads as a flat path lying on the floor, wider than tall (about 2:1), with ragged edges where the tiles end and fade into nothing at both ends, and no raised object taller than a few pixels. Dark-fantasy pixel-art style, soft light from the upper left, crisp clean pixel art with controlled dithering, no blur and no smooth airbrushed gradient. Centered with roughly 8% empty margin. Background: a single, completely flat and uniform solid cyan color (#00FFFF), with no scenery, no cast shadow, no gradient or texture behind it, and no cyan on the path itself. No text, logo, watermark, frame, border, UI element, character, creature, or second object, and no perfect diamond outline — only this one path, alone. Landscape image.

### Goranthis

**`goranthis_estrutura_01`**
> A ruined marble pavilion of a false paradise: a small open gazebo of ivory marble columns with worn gold trim, a partly collapsed roof, and pale aqua-green moss climbing the stone. Thick, faintly fleshy pink-toned vines wind around one column and the base, hinting that the beauty is corrupted from within, without any gore, faces or creatures. It looks serene at first glance and slightly wrong on closer look, with no writing or symbols. Dark-fantasy isometric pixel-art game prop, viewed from a three-quarter isometric angle tilted about 30 degrees from above, soft directional light from the upper left. Crisp, clean pixel-art rendering with controlled dithering, no blur and no smooth anti-aliasing. Centered with roughly 12% empty margin on every side, not touching the frame edges. Its base rests firmly on the ground with a solid footing of marble steps, roots and fallen stone, so nothing looks like it is hovering, and no stray pixels float below the base. The whole silhouette is solid and fully opaque. Background: a single, completely flat and uniform solid magenta color (#FF00FF), with no ground plane, cast shadow, gradient, vignette, texture, or scenery. No text, logo, watermark, frame, border, UI element, character, creature, or second object — only this one pavilion, alone. Square image.

**`goranthis_remendo_01`**
> A flat irregular patch of soft green grass dotted with small white flowers, with here and there a single flower with a corrupted purple petal, and a few cracked ivory marble fragments half hidden in the grass. It is a ground decal: seen from a three-quarter isometric angle tilted about 30 degrees from above, it reads as a flat patch lying on the floor, wider than tall (about 2:1), with soft irregular organic edges that fade out into nothing, and no raised object taller than a few pixels. Dark-fantasy pixel-art style, soft light from the upper left, crisp clean pixel art with controlled dithering, no blur and no smooth airbrushed gradient. Centered with roughly 8% empty margin, not touching the frame edges. Background: a single, completely flat and uniform solid magenta color (#FF00FF), with no scenery, no cast shadow, no gradient or texture behind it, and no magenta or bright pink on the patch itself. No text, logo, watermark, frame, border, UI element, character, creature, or second object, and no hard straight edges or perfect diamond outline — only this one ground patch, alone. Landscape image.

**`goranthis_trilha_01`**
> A garden path of ivory marble stepping slabs with worn gold edging, spaced unevenly across aqua-green moss and short grass, some slabs cracked, running from the left side of the image to the right side as a slightly winding strip. It is a ground decal: seen from a three-quarter isometric angle tilted about 30 degrees from above, it reads as a flat path lying on the floor, wider than tall (about 2:1), with the slabs thinning out and fading into nothing at both ends, and no raised object taller than a few pixels. Dark-fantasy pixel-art style, soft light from the upper left, crisp clean pixel art with controlled dithering, no blur and no smooth airbrushed gradient. Centered with roughly 8% empty margin. Background: a single, completely flat and uniform solid magenta color (#FF00FF), with no scenery, no cast shadow, no gradient or texture behind it. No text, logo, watermark, frame, border, UI element, character, creature, or second object, and no perfect diamond outline — only this one path, alone. Landscape image.

### Os Pilares

Nesta camada o bioma **mistura motivos já aprovados** e não cria uma nona
linguagem visual. Por isso os três prompts usam fragmentos de outras camadas.

**`pilares_estrutura_01`**
> A grounded heap of fused ruins from different layers of an abyss, welded together into one solid mass: a piece of a slate-blue temple roof, a broken ivory marble column, a rusted iron-barred window and a chunk of black wine-colored stone, all fused by thick violet-black crystalline growths with faint lilac veins. Nothing floats: the whole mass sits heavily on the ground on a wide cracked base. It has no writing and no readable symbols. Dark-fantasy isometric pixel-art game prop, viewed from a three-quarter isometric angle tilted about 30 degrees from above, soft directional light from the upper left. Crisp, clean pixel-art rendering with controlled dithering, no blur and no smooth anti-aliasing. Centered with roughly 12% empty margin on every side, not touching the frame edges. Its base rests firmly on the ground with a solid footing of crystal and rubble, so nothing looks like it is hovering, and no stray pixels float below the base. The whole silhouette is solid and fully opaque. Background: a single, completely flat and uniform solid cyan color (#00FFFF), with no ground plane, cast shadow, gradient, vignette, texture, or scenery, and no cyan on the object itself. No text, logo, watermark, frame, border, UI element, character, creature, or second object — only this one fused ruin, alone. Square image.

**`pilares_remendo_01`**
> A flat irregular patch of fractured violet-black stone with fine lilac electric veins spreading through the cracks, and small scattered fragments of mixed stone in slate-blue, ivory and rust tones lying on top. It is a ground decal: seen from a three-quarter isometric angle tilted about 30 degrees from above, it reads as a flat patch lying on the floor, wider than tall (about 2:1), with soft irregular organic edges that fade out into nothing, and no raised object taller than a few pixels. Dark-fantasy pixel-art style, soft light from the upper left, crisp clean pixel art with controlled dithering, no blur and no smooth airbrushed gradient. Centered with roughly 8% empty margin, not touching the frame edges. Background: a single, completely flat and uniform solid cyan color (#00FFFF), with no scenery, no cast shadow, no gradient or texture behind it, and no cyan on the patch itself. No text, logo, watermark, frame, border, UI element, character, creature, or second object, and no hard straight edges or perfect diamond outline — only this one ground patch, alone. Landscape image.

**`pilares_trilha_01`**
> A fractured causeway of violet-black stone slabs held together by thin glowing lilac veins, with a few slabs shifted out of line and small mixed fragments of other stones between them, running from the left side of the image to the right side as a slightly winding strip. It is a ground decal: seen from a three-quarter isometric angle tilted about 30 degrees from above, it reads as a flat path lying on the floor, wider than tall (about 2:1), with ragged edges where the slabs thin out and fade into nothing at both ends, and no raised object taller than a few pixels. Dark-fantasy pixel-art style, soft light from the upper left, crisp clean pixel art with controlled dithering, no blur and no smooth airbrushed gradient. Centered with roughly 8% empty margin. Background: a single, completely flat and uniform solid cyan color (#00FFFF), with no scenery, no cast shadow, no gradient or texture behind it, and no cyan on the path itself. No text, logo, watermark, frame, border, UI element, character, creature, or second object, and no perfect diamond outline — only this one path, alone. Landscape image.

---

## Critérios de aceite

1. Cada candidata respeita seu parágrafo: pixel art sombria, isométrico 3/4,
   luz superior esquerda, sem texto, moldura, personagem ou cenário indevido.
2. **Estruturas:** silhueta sólida e opaca, base com contato firme no chão, sem
   pixels soltos abaixo (critério anti-BUG-013), legíveis a 96–160 px.
3. **Remendos e trilhas:** bordas irregulares e suaves, sem contorno reto,
   losango perfeito ou moldura; nenhum elemento alto; quando sobrepostos a
   `<bioma>_ground`, devem parecer parte do chão.
4. Mesma paleta do bioma (ART-PROMPTS-007) e coerência dentro do trio.
5. Nada de lore nova: nenhum símbolo legível, texto, figura ou facção.
6. Nenhuma admissão em `assets/` sem seleção explícita do dono, sem BUG-013
   fechado e sem a spec de integração da camada de decais.

## Fora deste lote (e por quê)

| Item | Motivo |
|---|---|
| ART-013 (HQ / cutscene) | Depende de decisão sobre as histórias do "Nottcard"; fica para `ART-PROMPTS-027` |
| ART-004, 005, 014 | Presos a mecânicas ainda não decididas |
| ART-002, 003, 007, 016, 017 | Layout, cor e texto de UI: feitos no Godot |
| ART-006, 010 | Áudio/VFX; o ChatGPT não gera áudio |

## Gate

As 27 candidatas brutas foram geradas e aprovadas pelo dono em 2026-09-29, preservadas em
`.atena/generated/art-candidates/scenery/` e normalizadas para revisão em
`.atena/generated/art-candidates/scenery-normalized/`. A admissão continua
bloqueada até o fechamento visual do BUG-013 e a spec de integração de decais.
