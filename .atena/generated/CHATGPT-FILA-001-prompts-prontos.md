---
id: "CHATGPT-FILA-001"
type: "fila-de-prompts"
title: "Fila consolidada de prompts prontos para o ChatGPT (39 imagens)"
status: "reconciliada em 2026-10-02: Lotes 1/2 já admitidos; piloto HQ integrado; EVID-145"
created: "2026-09-29"
relations: ["[[ART-PROMPTS-025-lote-1-nevoa-bau-de-chefe-imas-e-npcs]]", "[[ART-PROMPTS-026-lote-2-camada-de-cenario-por-bioma]]", "[[ART-PROMPTS-027-hqs-novas-guia-de-estilo-e-piloto]]", "[[SPEC-062-fila-de-geracao-externa-de-assets]]"]
---

# Fila consolidada de prompts para o ChatGPT

**Estado atual (2026-10-02):** a tabela e marcações abaixo são históricas. Os oito oficiais P01–P08 existem (EVID-110); o Lote 2 foi admitido em EVID-127; o piloto HQ e HQN-01–14 já constam no catálogo com 56 imagens (EVID-133). Não gerar novamente esta remessa. Os decais antigos de Docas continuam sujeitos à restrição de âncora seca descrita em EVID-127; isso não exige regeneração. Reconciliação em EVID-145.

Compilação **literal** dos parágrafos dos três ART-PROMPTS que ainda não foram gerados. O texto de cada bloco é copiado dos arquivos de origem sem alteração; em caso de dúvida, o arquivo de origem prevalece.

| Lote | Origem | Imagens | Prioridade sugerida |
|---|---|---:|---|
| 1 | ART-PROMPTS-025 — névoa, baú de chefe, ímã de XP, NPCs de evento | 8 concluídas | Admitido em 2026-09-29 |
| 3 (piloto HQ) | ART-PROMPTS-027 — HQ "Uma Noite Sem Fim" | 4 geradas e aprovadas | Integração e fidelidade aos retratos pendentes |
| 2 | ART-PROMPTS-026 — camada de cenário por bioma | 27 geradas e aprovadas | Admissão ainda trava em BUG-013 e na spec de decais |

Já processados e **fora** desta fila: Zumbi, quebráveis, props dos 7 biomas, Nyrelia e Leoric.

## Regras para todo envio

1. **Uma imagem por mensagem**, parágrafo completo colado. Gere o mesmo grupo na mesma conversa, em ordem.
2. **Fundo de cor sólida**, nunca "transparente" (a cor vem no próprio prompt). Depois, remova a cor para obter o alfa real. Exceção: a névoa, que é branca sobre preto e vira alfa por luminância.
3. **Formato quadrado ou paisagem** conforme a última frase do prompt; o recorte final é feito depois.
4. **Descarte e regenere** qualquer imagem com silhueta translúcida, pixels soltos, halo, texto, moldura ou personagem que destoe da referência.
5. **Salve** cada PNG bruto no caminho de candidata indicado, com o nome `<id>_v01.png` (`_v02` para nova tentativa).
6. **Nada entra em `assets/`** sem a aprovação explícita do dono. Devolva os PNGs brutos à Atena para normalizar e montar a prancha de revisão.

## Marcação de progresso

Marque `[x]` ao gerar e `[a]` ao aprovar.

## Lote 1 — névoa, baú de chefe, ímã de XP e NPCs (P01–P08)

Candidatas em `.atena/generated/art-candidates/lote-1/`. Névoa: branco sobre preto, converter **luminância em alfa** e testar a emenda da textura em 3×3. Ímã: fundo verde `#00FF00`. Baú aberto: gerar depois do fechado, na mesma conversa. Origem: [[ART-PROMPTS-025-lote-1-nevoa-bau-de-chefe-imas-e-npcs]].

### ART-008 — Névoa

#### P01 — `nevoa_textura_01` 

- [x] gerada · [x] aprovada · admitida: `assets/fx/nevoa_textura_01.png` (candidata v03 normalizada; `nevoa_textura_01_v01.png` e `nevoa_textura_01_v02.png` rejeitadas por emenda)

```text
A seamless tileable texture of dense drifting mist, rendered as soft layered wisps and curling banks of fog in pure white and light gray. Dark-fantasy pixel-art style with controlled dithering and visible stepped pixel bands for density, no smooth airbrushed gradient and no painterly softness. The pattern must repeat perfectly: the left edge must match the right edge and the top edge must match the bottom edge, with no visible seam and no single dominant focal shape. Mist must be uneven, with thinner and thicker regions, but never fully empty and never solid. Background: a single completely flat pure black (#000000) — the mist is white on black, with no color, no ground, no scenery, no objects, no creatures, no text, no logo, no watermark, no frame and no border. Square image.
```

#### P02 — `nevoa_borda_01` 

- [x] gerada · [x] aprovada · admitida: `assets/fx/nevoa_borda_01.png`

```text
A wide horizontal bank of thick dark-fantasy mist that is densest along the bottom edge of the image and fades gradually upward into nothing, drawn as layered curling fog in pure white and light gray. Pixel-art style with controlled dithering and visible stepped pixel bands, no smooth airbrushed gradient. The top third of the image must be almost fully empty black, so it can blend into a game scene. Background: a single completely flat pure black (#000000) — the mist is white on black, with no color, no ground, no scenery, no objects, no creatures, no text, no logo, no watermark, no frame and no border. Wide landscape image.
```

### ART-011 — Baú de chefe

#### P03 — `bau_chefe_fechado` 

- [x] gerada · [x] aprovada · admitida: `assets/interactions/bau_chefe_fechado.png`

```text
A large, heavy dark-fantasy treasure chest, closed, clearly grander than an ordinary wooden chest but from the same visual family: dark weathered wood wrapped in thick blackened iron bands, with rich gold trim on the corners, edges and a large ornate gold lock plate at the front, plus a few thick iron chains hanging across the lid. A faint warm golden light leaks out of the seams between the planks. Dark-fantasy isometric pixel-art game prop, viewed from a three-quarter isometric angle tilted about 30 degrees from above, with soft directional light from the upper left. Crisp, clean pixel-art rendering with controlled dithering, no blur and no smooth anti-aliasing. The object sits centered in the frame with roughly 12% empty margin on every side and does not touch or cross the image edges. The whole silhouette must be solid, fully opaque and readable at small size. Background: a single, completely flat and uniform solid magenta color (#FF00FF), with absolutely no ground, floor, cast shadow, gradient, vignette, texture, or scenery behind the object. Do not include any text, logo, watermark, frame, border, UI element, character, creature, skull, or second object — render only this one chest, alone. Square image.
```

#### P04 — `bau_chefe_aberto` 

- [x] gerada · [x] aprovada · admitida: `assets/interactions/bau_chefe_aberto.png`

```text
The exact same large ornate boss treasure chest as before — same size, same dark weathered wood, blackened iron bands, gold trim, ornate gold lock plate and hanging chains, same camera angle, same zoom and same position in the frame — but now open, with the lid tilted back and a warm golden glow spilling out of the inside, lighting the inner rim. The inside must show only a bright glow and a hint of gold, no readable items. Dark-fantasy isometric pixel-art game prop, three-quarter isometric angle tilted about 30 degrees from above, soft directional light from the upper left, crisp clean pixel art with controlled dithering, no blur or anti-aliasing. Centered with roughly 12% empty margin, not touching the frame edges, base of the chest at the same height as the closed version. The whole silhouette must be solid and fully opaque. Background: a single flat uniform solid magenta color (#FF00FF), no ground, floor, cast shadow, gradient, vignette, texture, or scenery. No text, logo, watermark, frame, border, UI, character, creature, skull, or second object — only this one chest, alone. Square image.
```

### ART-015 — Ímã de experiência

#### P05 — `ima_xp` 

- [x] gerada · [x] aprovada · admitida: `assets/pickups/magnet.png`

```text
A single small horseshoe magnet pickup item for a game: a thick U-shaped magnet made of polished steel-gray metal, with the two tips painted in strong red and white bands, and a few tiny bright sparks of energy between the two tips. Bold chunky shapes, very readable when shrunk to 64 pixels, strong dark outline. Dark-fantasy isometric pixel-art game item, viewed from a slightly raised three-quarter angle, with soft directional light from the upper left. Crisp, clean pixel-art rendering with controlled dithering, no blur and no smooth anti-aliasing. The item sits centered with roughly 12% empty margin on every side. The whole silhouette must be solid and fully opaque. Background: a single, completely flat and uniform solid bright green color (#00FF00), with absolutely no ground, cast shadow, gradient, vignette, texture, or scenery, and no green anywhere on the object itself. Do not include any text, logo, watermark, frame, border, UI element, character, or second object — only this one item, alone. Square image.
```

### ART-009 — NPCs de evento

#### P06 — `npc_loja` · comerciante

- [x] gerada · [x] aprovada · admitida: `assets/interactions/loja.png`

```text
A small traveling merchant stall for a dark-fantasy game: a hooded, cloaked merchant figure standing behind a low wooden counter under a sagging deep-red cloth awning, with a lantern hanging from the awning pole, a few closed sacks and a small open chest on the counter, and a leather coin purse and a few coins clearly visible in front. The dominant color of the whole object is deep red and warm brown, so it reads as a shop at a glance. The merchant's face stays hidden in the shadow of the hood. Dark-fantasy isometric pixel-art game prop, viewed from a three-quarter isometric angle tilted about 30 degrees from above, with soft directional light from the upper left. Crisp, clean pixel-art rendering with controlled dithering, no blur and no smooth anti-aliasing. Centered with roughly 12% empty margin on every side, not touching the frame edges. The whole silhouette must be solid and fully opaque. Background: a single, completely flat and uniform solid magenta color (#FF00FF), with no ground, floor, cast shadow, gradient, vignette, texture, or scenery. No text, no signboard lettering, logo, watermark, frame, border, UI element, weapon in use, or second character — only this one stall with its merchant, alone. Square image.
```

#### P07 — `npc_ferreiro` · ferreiro

- [x] gerada · [x] aprovada · admitida: `assets/interactions/ferreiro.png`

```text
A dark-fantasy blacksmith's work station: a hooded, broad-shouldered smith figure standing behind a heavy iron anvil, hammer resting in hand, next to a small stone forge with glowing orange embers, with a couple of unfinished blades and tongs leaning against the anvil. The dominant colors of the whole object are dark steel gray and glowing orange, so it reads as a forge at a glance, and it must look clearly different from a merchant stall. The smith's face stays hidden in shadow. Dark-fantasy isometric pixel-art game prop, viewed from a three-quarter isometric angle tilted about 30 degrees from above, with soft directional light from the upper left plus the orange glow of the forge. Crisp, clean pixel-art rendering with controlled dithering, no blur and no smooth anti-aliasing. Centered with roughly 12% empty margin on every side, not touching the frame edges. The whole silhouette must be solid and fully opaque. Background: a single, completely flat and uniform solid magenta color (#FF00FF), with no ground, floor, cast shadow, gradient, vignette, texture, or scenery. No text, logo, watermark, frame, border, UI element, or second character — only this one work station with its smith, alone. Square image.
```

#### P08 — `npc_curandeiro` · curandeiro

- [x] gerada · [x] aprovada · admitida: `assets/interactions/curandeiro.png`

```text
A dark-fantasy herbalist healer's corner: a hooded, gentle-looking healer figure kneeling or standing beside a small stone bowl and a bubbling iron cauldron that gives off soft warm golden-white steam, with bundles of dried herbs hanging from a short wooden rack and a few small glass vials on a low stool. The dominant colors of the whole object are soft moss green and pale warm gold, with a calm, restorative feeling, so it reads as healing at a glance and looks clearly different from a merchant stall and from a forge. The healer's face stays hidden in shadow. Dark-fantasy isometric pixel-art game prop, viewed from a three-quarter isometric angle tilted about 30 degrees from above, with soft directional light from the upper left. Crisp, clean pixel-art rendering with controlled dithering, no blur and no smooth anti-aliasing. Centered with roughly 12% empty margin on every side, not touching the frame edges. The whole silhouette must be solid and fully opaque. Background: a single, completely flat and uniform solid magenta color (#FF00FF), with no ground, floor, cast shadow, gradient, vignette, texture, or scenery. No text, no cross or religious symbol, logo, watermark, frame, border, UI element, or second character — only this one healing corner with its healer, alone. Square image.
```

## Lote 3 (piloto HQ) — "Uma Noite Sem Fim" (P09–P12)

Candidatas em `.atena/generated/art-candidates/hq/`. **Mesma conversa, em ordem.** Anexar os retratos `assets/portraits/kayron.png`, `durvall.png`, `sylas.png` e `maelor.png` nos quadros 2, 3 e 4 (o quadro 1 não tem personagens). Sem texto na imagem; terço inferior calmo. Origem: [[ART-PROMPTS-027-hqs-novas-guia-de-estilo-e-piloto]].

### Quadro 1 — plano aberto, o mundo

#### P09 — `hq_n01_q1` 

- [ ] gerada · [ ] aprovada · candidata: `.atena/generated/art-candidates/hq/hq_n01_q1_v01.png`

```text
A vast wide shot of a city under an endless sunless night: a sky like a gray-green cloth stretched over rooftops, docks and temples, with no sun and no moon, only a pale sickly green glow leaking through the fog. In the far distance an enormous curtain of blue energy, the Tarn barrier, rises like a wall of light around the city and keeps the fog back. Tiny amber lanterns dot the streets far below. Camera high and wide, the city small, the sky heavy. Cold gray-green fog, a single blue barrier glow, small warm amber points. Dark-fantasy illustration with dense pixel-art finish and controlled dithering, crisp pixel edges, no smooth painterly blur, wide 16:9 landscape composition. No text, no letters, no speech bubbles, no captions, no logo, no watermark, no frame or border, no UI. Keep the bottom third of the image visually calm and uncluttered. Nothing important is cropped by the edges. No characters in this image.
```

### Quadro 2 — plano médio, o grupo nas Docas

#### P10 — `hq_n01_q2` 

- [ ] gerada · [ ] aprovada · candidata: `.atena/generated/art-candidates/hq/hq_n01_q2_v01.png`

```text
Four adventurers seen from behind, standing side by side on a quiet stone quay at the docks, looking out at rows of shuttered warehouses, stacked crates and empty piers beneath a low green-gray fog. The docks are strangely empty and silent, with a few hooded figures barely visible very far away and dark water at the edge of the frame. A cold wind lifts their cloaks. Camera at shoulder height behind the group, medium-wide shot, the group in dark silhouette against the pale fog, a faint blue glow of the Tarn on the horizon, small amber lanterns on the piers. Dark-fantasy illustration with dense pixel-art finish and controlled dithering, crisp pixel edges, no smooth painterly blur, wide 16:9 landscape composition. No text, no letters, no speech bubbles, no captions, no logo, no watermark, no frame or border, no UI. Keep the bottom third of the image visually calm and uncluttered. Nothing important is cropped by the edges. The four characters must match the attached reference portraits exactly.
```

### Quadro 3 — plano fechado, a rachadura na Tarn

#### P11 — `hq_n01_q3` 

- [ ] gerada · [ ] aprovada · candidata: `.atena/generated/art-candidates/hq/hq_n01_q3_v01.png`

```text
A close, low-angle shot of a jagged crack running through a wall of blue energy barrier where it meets the stone of the harbor, with carefully carved ritual runes glowing faintly around the crack and thin green fog seeping through it like smoke. In the foreground, a hand reaches out toward the crack and stops just short of touching it, while three other silhouettes behind lean forward. One silhouette stands slightly apart, unaffected and still, while the others stagger back as if struck by an unseen presence. The fog carries a faint hint of purple where it touches the runes. Camera close and low, the crack at the center, blue barrier light against dark stone, green fog, a hint of purple. Dark-fantasy illustration with dense pixel-art finish and controlled dithering, crisp pixel edges, no smooth painterly blur, wide 16:9 landscape composition. No text, no letters, no speech bubbles, no captions, no logo, no watermark, no frame or border, no UI. Keep the bottom third of the image visually calm and uncluttered. Nothing important is cropped by the edges. Characters must match the attached reference portraits exactly.
```

### Quadro 4 — gancho, a porta escondida

#### P12 — `hq_n01_q4` 

- [ ] gerada · [ ] aprovada · candidata: `.atena/generated/art-candidates/hq/hq_n01_q4_v01.png`

```text
A dark warehouse ruin beside the glowing blue barrier, with a hidden door half buried in stone at the base of the wall and a narrow stairway leading down into blackness. One dark-armored figure with long white hair stands at the entrance, seen from behind and slightly from the side, resting a hand on the cold stone as if listening to what waits below. Three other silhouettes wait a few steps behind, holding back. A single amber lantern on the ground lights the first steps and nothing beyond them. Camera medium-wide from behind and above, the doorway as the visual destination, deep shadow below, amber light on the stairs, blue barrier glow from the side, green fog at the floor. Dark-fantasy illustration with dense pixel-art finish and controlled dithering, crisp pixel edges, no smooth painterly blur, wide 16:9 landscape composition. No text, no letters, no speech bubbles, no captions, no logo, no watermark, no frame or border, no UI. Keep the bottom third of the image visually calm and uncluttered. Nothing important is cropped by the edges. Characters must match the attached reference portraits exactly.
```

## Lote 2 — camada de cenário por bioma (P13–P39)

Candidatas em `.atena/generated/art-candidates/scenery/<bioma>/`. **Comece pelo piloto de Dagruve (P13–P15) e devolva à Atena antes dos demais biomas.** Cores de fundo: magenta `#FF00FF`; ciano `#00FFFF` em Shendilavri e Pilares. Remendos e trilhas precisam de borda irregular e suave. A admissão em `assets/` só depois de fechar o BUG-013 e de existir a spec de decais (SPEC-079). Origem: [[ART-PROMPTS-026-lote-2-camada-de-cenario-por-bioma]].

### Piloto — Dagruve

#### P13 — `dagruve_estrutura_01` 

- [ ] gerada · [ ] aprovada · candidata: `.atena/generated/art-candidates/scenery/dagruve_estrutura_01_v01.png`

```text
A small abandoned two-story house from a neglected city district, half-collapsed, built of weathered gray-blue stone and dark rotting timber, with a partly fallen roof, boarded and broken windows, a crooked chimney, and a faint sickly mist clinging to its foundation. It looks lived-in long ago and then abandoned, with no writing, signs or symbols. Dark-fantasy isometric pixel-art game prop, viewed from a three-quarter isometric angle tilted about 30 degrees from above, with soft directional light from the upper left. Crisp, clean pixel-art rendering with controlled dithering, no blur and no smooth anti-aliasing. The object sits centered with roughly 12% empty margin on every side and does not touch the frame edges. Its base rests firmly on the ground with a solid footing of rubble and fallen stones, so nothing looks like it is hovering, and no stray pixels float below the base. The whole silhouette is solid and fully opaque. Background: a single, completely flat and uniform solid magenta color (#FF00FF), with no ground plane, cast shadow, gradient, vignette, texture, or scenery. No text, logo, watermark, frame, border, UI element, character, creature, or second object — only this one house, alone. Square image.
```

#### P14 — `dagruve_remendo_01` 

- [ ] gerada · [ ] aprovada · candidata: `.atena/generated/art-candidates/scenery/dagruve_remendo_01_v01.png`

```text
A flat irregular patch of sickly, sparse gray-green grass and weeds pushing up through cracked wet gray-blue cobblestones, with a few bare stones and small dark puddles showing through. It is a ground decal: seen from a three-quarter isometric angle tilted about 30 degrees from above, it reads as a flat patch lying on the floor, wider than tall (about 2:1), with soft irregular organic edges that fade out into nothing, and no raised object taller than a few pixels. Dark-fantasy pixel-art style, soft light from the upper left, crisp clean pixel art with controlled dithering, no blur and no smooth airbrushed gradient. Centered with roughly 8% empty margin, not touching the frame edges. Background: a single, completely flat and uniform solid magenta color (#FF00FF), with no scenery, no cast shadow, no gradient or texture behind it. No text, logo, watermark, frame, border, UI element, character, creature, or second object, and no hard straight edges or perfect diamond outline — only this one ground patch, alone. Landscape image.
```

#### P15 — `dagruve_trilha_01` 

- [ ] gerada · [ ] aprovada · candidata: `.atena/generated/art-candidates/scenery/dagruve_trilha_01_v01.png`

```text
A worn stretch of an old city lane made of uneven gray-blue cobblestones with dark mortar, some stones cracked or missing, faint moss in the joints, running from the left side of the image to the right side as a slightly winding strip. It is a ground decal: seen from a three-quarter isometric angle tilted about 30 degrees from above, it reads as a flat path lying on the floor, wider than tall (about 2:1), with ragged edges where the stones thin out and fade into nothing at both ends, and no raised object taller than a few pixels. Dark-fantasy pixel-art style, soft light from the upper left, crisp clean pixel art with controlled dithering, no blur and no smooth airbrushed gradient. Centered with roughly 8% empty margin. Background: a single, completely flat and uniform solid magenta color (#FF00FF), with no scenery, no cast shadow, no gradient or texture behind it. No text, logo, watermark, frame, border, UI element, character, creature, or second object, and no perfect diamond outline — only this one path, alone. Landscape image.
```

### Docas

#### P16 — `docas_estrutura_01` 

- [ ] gerada · [ ] aprovada · candidata: `.atena/generated/art-candidates/scenery/docas_estrutura_01_v01.png`

```text
A small dockside warehouse corner: a ruined storage shed of dark damp timber and gray stone at the edge of a quay, with a sagging tarred roof, a broken loading hatch, a rusted winch and a few snapped mooring posts at its base, salt stains and wet dark streaks running down the walls. It looks like a working harbor building that has been left to rot, with no writing, signs or symbols. Dark-fantasy isometric pixel-art game prop, viewed from a three-quarter isometric angle tilted about 30 degrees from above, soft directional light from the upper left. Crisp, clean pixel-art rendering with controlled dithering, no blur and no smooth anti-aliasing. Centered with roughly 12% empty margin on every side, not touching the frame edges. Its base rests firmly on the ground with a solid footing of planks, stones and debris, so nothing looks like it is hovering, and no stray pixels float below the base. The whole silhouette is solid and fully opaque. Background: a single, completely flat and uniform solid magenta color (#FF00FF), with no ground plane, cast shadow, gradient, vignette, texture, or scenery. No text, logo, watermark, frame, border, UI element, character, creature, or second object — only this one shed, alone. Square image.
```

#### P17 — `docas_remendo_01` 

- [ ] gerada · [ ] aprovada · candidata: `.atena/generated/art-candidates/scenery/docas_remendo_01_v01.png`

```text
A flat irregular patch of wet dark silt and damp sand mixed with scattered small pebbles, shell fragments and a few strands of dark seaweed, with a shallow puddle catching a dull teal reflection. It is a ground decal: seen from a three-quarter isometric angle tilted about 30 degrees from above, it reads as a flat patch lying on the floor, wider than tall (about 2:1), with soft irregular organic edges that fade out into nothing, and no raised object taller than a few pixels. Dark-fantasy pixel-art style, soft light from the upper left, crisp clean pixel art with controlled dithering, no blur and no smooth airbrushed gradient. Centered with roughly 8% empty margin, not touching the frame edges. Background: a single, completely flat and uniform solid magenta color (#FF00FF), with no scenery, no cast shadow, no gradient or texture behind it. No text, logo, watermark, frame, border, UI element, character, creature, or second object, and no hard straight edges or perfect diamond outline — only this one ground patch, alone. Landscape image.
```

#### P18 — `docas_trilha_01` 

- [ ] gerada · [ ] aprovada · candidata: `.atena/generated/art-candidates/scenery/docas_trilha_01_v01.png`

```text
A stretch of old wooden boardwalk made of weathered dark planks with rusted nails, some planks broken or missing, laid over wet stone and running from the left side of the image to the right side as a slightly uneven strip, with a rope or chain remnant along one edge. It is a ground decal: seen from a three-quarter isometric angle tilted about 30 degrees from above, it reads as a flat path lying on the floor, wider than tall (about 2:1), with ragged edges where the planks end and fade into nothing at both ends, and no raised object taller than a few pixels. Dark-fantasy pixel-art style, soft light from the upper left, crisp clean pixel art with controlled dithering, no blur and no smooth airbrushed gradient. Centered with roughly 8% empty margin. Background: a single, completely flat and uniform solid magenta color (#FF00FF), with no scenery, no cast shadow, no gradient or texture behind it. No text, logo, watermark, frame, border, UI element, character, creature, or second object, and no perfect diamond outline — only this one path, alone. Landscape image.
```

### Shedaklah

#### P19 — `shedaklah_estrutura_01` 

- [ ] gerada · [ ] aprovada · candidata: `.atena/generated/art-candidates/scenery/shedaklah_estrutura_01_v01.png`

```text
A ruined stone hut swallowed by fungus: low crumbling walls of dark stone almost completely covered in thick brown-violet mycelium, with soft pink spore-cap growths sprouting from the roof and doorway, a collapsed roof, and slimy drips running down the walls. It clearly began as a simple shelter and was taken over by a fungal swamp, with no writing, signs or symbols. Dark-fantasy isometric pixel-art game prop, viewed from a three-quarter isometric angle tilted about 30 degrees from above, soft directional light from the upper left. Crisp, clean pixel-art rendering with controlled dithering, no blur and no smooth anti-aliasing. Centered with roughly 12% empty margin on every side, not touching the frame edges. Its base rests firmly on the ground with a thick footing of roots, mycelium and fallen stones, so nothing looks like it is hovering, and no stray pixels float below the base. The whole silhouette is solid and fully opaque. Background: a single, completely flat and uniform solid magenta color (#FF00FF), with no ground plane, cast shadow, gradient, vignette, texture, or scenery. No text, logo, watermark, frame, border, UI element, character, creature, or second object — only this one hut, alone. Square image.
```

#### P20 — `shedaklah_remendo_01` 

- [ ] gerada · [ ] aprovada · candidata: `.atena/generated/art-candidates/scenery/shedaklah_remendo_01_v01.png`

```text
A flat irregular patch of brown fungal soil covered by a mat of fine violet mycelium threads, with tiny pale spore dots, small damp slime smears and a few very small flat mushroom caps no taller than a few pixels. It is a ground decal: seen from a three-quarter isometric angle tilted about 30 degrees from above, it reads as a flat patch lying on the floor, wider than tall (about 2:1), with soft irregular organic edges that fade out into nothing. Dark-fantasy pixel-art style, soft light from the upper left, crisp clean pixel art with controlled dithering, no blur and no smooth airbrushed gradient. Centered with roughly 8% empty margin, not touching the frame edges. Background: a single, completely flat and uniform solid magenta color (#FF00FF), with no scenery, no cast shadow, no gradient or texture behind it, and no magenta or pink on the patch itself except a muted violet. No text, logo, watermark, frame, border, UI element, character, creature, or second object, and no hard straight edges or perfect diamond outline — only this one ground patch, alone. Landscape image.
```

#### P21 — `shedaklah_trilha_01` 

- [ ] gerada · [ ] aprovada · candidata: `.atena/generated/art-candidates/scenery/shedaklah_trilha_01_v01.png`

```text
A winding line of flat, dark, rounded stepping stones set into brownish fungal mud, running from the left side of the image to the right side, with thin violet mycelium threads growing across the gaps between the stones and a few damp slime smears. It is a ground decal: seen from a three-quarter isometric angle tilted about 30 degrees from above, it reads as a flat path lying on the floor, wider than tall (about 2:1), with the stones thinning out and fading into nothing at both ends, and no raised object taller than a few pixels. Dark-fantasy pixel-art style, soft light from the upper left, crisp clean pixel art with controlled dithering, no blur and no smooth airbrushed gradient. Centered with roughly 8% empty margin. Background: a single, completely flat and uniform solid magenta color (#FF00FF), with no scenery, no cast shadow, no gradient or texture behind it. No text, logo, watermark, frame, border, UI element, character, creature, or second object, and no perfect diamond outline — only this one path, alone. Landscape image.
```

### Molor

#### P22 — `molor_estrutura_01` 

- [ ] gerada · [ ] aprovada · candidata: `.atena/generated/art-candidates/scenery/molor_estrutura_01_v01.png`

```text
A collapsed hovel of rotten dark timber and scavenged stone, piled with refuse and old bones and coated in a glossy green-black slimy film, with slime dripping from the broken roof and a few small translucent bubbles clinging to the walls. It looks like a shelter built out of garbage and decay in a filthy cavern, with no writing, signs or symbols. Dark-fantasy isometric pixel-art game prop, viewed from a three-quarter isometric angle tilted about 30 degrees from above, soft directional light from the upper left. Crisp, clean pixel-art rendering with controlled dithering, no blur and no smooth anti-aliasing. Centered with roughly 12% empty margin on every side, not touching the frame edges. Its base rests firmly on the ground with a solid footing of refuse, slime puddles and debris, so nothing looks like it is hovering, and no stray pixels float below the base. The whole silhouette is solid and fully opaque. Background: a single, completely flat and uniform solid magenta color (#FF00FF), with no ground plane, cast shadow, gradient, vignette, texture, or scenery. No text, logo, watermark, frame, border, UI element, character, creature, or second object — only this one hovel, alone. Square image.
```

#### P23 — `molor_remendo_01` 

- [ ] gerada · [ ] aprovada · candidata: `.atena/generated/art-candidates/scenery/molor_remendo_01_v01.png`

```text
A flat irregular patch of green-black slimy scum with a dull wet sheen, scattered flat bubbles, small scraps of rotten refuse, tiny bone fragments and a few stains of acid-yellow residue. It is a ground decal: seen from a three-quarter isometric angle tilted about 30 degrees from above, it reads as a flat patch lying on the floor, wider than tall (about 2:1), with soft irregular organic edges that fade out into nothing, and no raised object taller than a few pixels. Dark-fantasy pixel-art style, soft light from the upper left, crisp clean pixel art with controlled dithering, no blur and no smooth airbrushed gradient. Centered with roughly 8% empty margin, not touching the frame edges. Background: a single, completely flat and uniform solid magenta color (#FF00FF), with no scenery, no cast shadow, no gradient or texture behind it. No text, logo, watermark, frame, border, UI element, character, creature, or second object, and no hard straight edges or perfect diamond outline — only this one ground patch, alone. Landscape image.
```

#### P24 — `molor_trilha_01` 

- [ ] gerada · [ ] aprovada · candidata: `.atena/generated/art-candidates/scenery/molor_trilha_01_v01.png`

```text
A trail of flattened refuse and rotten planks laid across green-black slime, made of warped wooden boards, packed trash and a few bones pressed into the muck, running from the left side of the image to the right side as an uneven strip, with slime creeping over its edges. It is a ground decal: seen from a three-quarter isometric angle tilted about 30 degrees from above, it reads as a flat path lying on the floor, wider than tall (about 2:1), with ragged edges that fade into nothing at both ends, and no raised object taller than a few pixels. Dark-fantasy pixel-art style, soft light from the upper left, crisp clean pixel art with controlled dithering, no blur and no smooth airbrushed gradient. Centered with roughly 8% empty margin. Background: a single, completely flat and uniform solid magenta color (#FF00FF), with no scenery, no cast shadow, no gradient or texture behind it. No text, logo, watermark, frame, border, UI element, character, creature, or second object, and no perfect diamond outline — only this one path, alone. Landscape image.
```

### Durao

#### P25 — `durao_estrutura_01` 

- [ ] gerada · [ ] aprovada · candidata: `.atena/generated/art-candidates/scenery/durao_estrutura_01_v01.png`

```text
The ruined corner of a military barracks in a barren post-war wasteland: thick walls of dark basalt blocks partly collapsed, with rusted iron window bars, a broken iron door hanging open, a dented iron plate roof half torn away, and reddish rust stains running down the stone. A faint pale ghostly blue glow leaks from one doorway. It looks like a fortress prison left to ruin, with no writing, signs or symbols. Dark-fantasy isometric pixel-art game prop, viewed from a three-quarter isometric angle tilted about 30 degrees from above, soft directional light from the upper left. Crisp, clean pixel-art rendering with controlled dithering, no blur and no smooth anti-aliasing. Centered with roughly 12% empty margin on every side, not touching the frame edges. Its base rests firmly on the ground with a solid footing of fallen blocks and rusty dust, so nothing looks like it is hovering, and no stray pixels float below the base. The whole silhouette is solid and fully opaque. Background: a single, completely flat and uniform solid magenta color (#FF00FF), with no ground plane, cast shadow, gradient, vignette, texture, or scenery. No text, logo, watermark, frame, border, UI element, character, creature, or second object — only this one ruin, alone. Square image.
```

#### P26 — `durao_remendo_01` 

- [ ] gerada · [ ] aprovada · candidata: `.atena/generated/art-candidates/scenery/durao_remendo_01_v01.png`

```text
A flat irregular patch of dry cracked earth and rust-colored ash sand, with scattered small basalt pebbles, fine iron-red dust and a few faint pale-blue ghostly veins glowing softly in the cracks. It is a ground decal: seen from a three-quarter isometric angle tilted about 30 degrees from above, it reads as a flat patch lying on the floor, wider than tall (about 2:1), with soft irregular organic edges that fade out into nothing, and no raised object taller than a few pixels. Dark-fantasy pixel-art style, soft light from the upper left, crisp clean pixel art with controlled dithering, no blur and no smooth airbrushed gradient. Centered with roughly 8% empty margin, not touching the frame edges. Background: a single, completely flat and uniform solid magenta color (#FF00FF), with no scenery, no cast shadow, no gradient or texture behind it. No text, logo, watermark, frame, border, UI element, character, creature, or second object, and no hard straight edges or perfect diamond outline — only this one ground patch, alone. Landscape image.
```

#### P27 — `durao_trilha_01` 

- [ ] gerada · [ ] aprovada · candidata: `.atena/generated/art-candidates/scenery/durao_trilha_01_v01.png`

```text
A trail of packed rust-colored dust and dark basalt slabs worn smooth by marching feet, with old wheel ruts and a few rusted iron spikes or chain links half buried along its sides, running from the left side of the image to the right side as a slightly winding strip. It is a ground decal: seen from a three-quarter isometric angle tilted about 30 degrees from above, it reads as a flat path lying on the floor, wider than tall (about 2:1), with ragged edges that fade into nothing at both ends, and no raised object taller than a few pixels. Dark-fantasy pixel-art style, soft light from the upper left, crisp clean pixel art with controlled dithering, no blur and no smooth airbrushed gradient. Centered with roughly 8% empty margin. Background: a single, completely flat and uniform solid magenta color (#FF00FF), with no scenery, no cast shadow, no gradient or texture behind it. No text, logo, watermark, frame, border, UI element, character, creature, or second object, and no perfect diamond outline — only this one path, alone. Landscape image.
```

### Feng-tu

#### P28 — `feng_tu_estrutura_01` 

- [ ] gerada · [ ] aprovada · candidata: `.atena/generated/art-candidates/scenery/feng_tu_estrutura_01_v01.png`

```text
A small ruined shrine from a destroyed temple: a broken tiered roof of dark curved tiles with red-lacquered wooden pillars, partly collapsed, slate-blue stone steps at the front, faded red banners hanging torn and unreadable, and a few stains of sickly green on the stone. The place feels abandoned after a plague, with a single faint star-shaped opening in the roof, no writing, no readable symbols, and no religious figures. Dark-fantasy isometric pixel-art game prop, viewed from a three-quarter isometric angle tilted about 30 degrees from above, soft directional light from the upper left. Crisp, clean pixel-art rendering with controlled dithering, no blur and no smooth anti-aliasing. Centered with roughly 12% empty margin on every side, not touching the frame edges. Its base rests firmly on the ground with a solid footing of stone steps and fallen roof tiles, so nothing looks like it is hovering, and no stray pixels float below the base. The whole silhouette is solid and fully opaque. Background: a single, completely flat and uniform solid magenta color (#FF00FF), with no ground plane, cast shadow, gradient, vignette, texture, or scenery. No text, logo, watermark, frame, border, UI element, character, creature, or second object — only this one shrine, alone. Square image.
```

#### P29 — `feng_tu_remendo_01` 

- [ ] gerada · [ ] aprovada · candidata: `.atena/generated/art-candidates/scenery/feng_tu_remendo_01_v01.png`

```text
A flat irregular patch of cracked slate-blue temple flagstones covered with dark green moss and greenish plague stains, with a few fallen dry leaves and small pieces of broken red roof tile. It is a ground decal: seen from a three-quarter isometric angle tilted about 30 degrees from above, it reads as a flat patch lying on the floor, wider than tall (about 2:1), with soft irregular organic edges that fade out into nothing, and no raised object taller than a few pixels. Dark-fantasy pixel-art style, soft light from the upper left, crisp clean pixel art with controlled dithering, no blur and no smooth airbrushed gradient. Centered with roughly 8% empty margin, not touching the frame edges. Background: a single, completely flat and uniform solid magenta color (#FF00FF), with no scenery, no cast shadow, no gradient or texture behind it. No text, logo, watermark, frame, border, UI element, character, creature, or second object, and no hard straight edges or perfect diamond outline — only this one ground patch, alone. Landscape image.
```

#### P30 — `feng_tu_trilha_01` 

- [ ] gerada · [ ] aprovada · candidata: `.atena/generated/art-candidates/scenery/feng_tu_trilha_01_v01.png`

```text
A pilgrimage path of worn slate-blue stone slabs with thin worn-red joints between them, with a few slabs cracked or missing and faint green moss in the gaps, running from the left side of the image to the right side as a slightly winding strip. It is a ground decal: seen from a three-quarter isometric angle tilted about 30 degrees from above, it reads as a flat path lying on the floor, wider than tall (about 2:1), with ragged edges where the slabs thin out and fade into nothing at both ends, and no raised object taller than a few pixels. Dark-fantasy pixel-art style, soft light from the upper left, crisp clean pixel art with controlled dithering, no blur and no smooth airbrushed gradient. Centered with roughly 8% empty margin. Background: a single, completely flat and uniform solid magenta color (#FF00FF), with no scenery, no cast shadow, no gradient or texture behind it. No text, logo, watermark, frame, border, UI element, character, creature, or second object, and no perfect diamond outline — only this one path, alone. Landscape image.
```

### Shendilavri

#### P31 — `shendilavri_estrutura_01` 

- [ ] gerada · [ ] aprovada · candidata: `.atena/generated/art-candidates/scenery/shendilavri_estrutura_01_v01.png`

```text
A ruined ornate pavilion of a corrupted luxury city: a small open pavilion with polished black and deep-wine stone columns inlaid with thin silver lines, a partly collapsed domed roof, torn wine-colored silk drapes hanging between the columns, and a cracked staircase at the front. It feels like an opulent place left in decay, with a faint uncanny shimmer on the silver inlays, no writing, no symbols and no figures. Dark-fantasy isometric pixel-art game prop, viewed from a three-quarter isometric angle tilted about 30 degrees from above, soft directional light from the upper left. Crisp, clean pixel-art rendering with controlled dithering, no blur and no smooth anti-aliasing. Centered with roughly 12% empty margin on every side, not touching the frame edges. Its base rests firmly on the ground with a solid footing of steps and fallen stone, so nothing looks like it is hovering, and no stray pixels float below the base. The whole silhouette is solid and fully opaque. Background: a single, completely flat and uniform solid cyan color (#00FFFF), with no ground plane, cast shadow, gradient, vignette, texture, or scenery, and no cyan on the object itself. No text, logo, watermark, frame, border, UI element, character, creature, or second object — only this one pavilion, alone. Square image.
```

#### P32 — `shendilavri_remendo_01` 

- [ ] gerada · [ ] aprovada · candidata: `.atena/generated/art-candidates/scenery/shendilavri_remendo_01_v01.png`

```text
A flat irregular patch of dark wine-colored petals, small scraps of torn silk and tiny glass or crystal shards scattered over polished black stone, with a few thin silver flecks glinting. It is a ground decal: seen from a three-quarter isometric angle tilted about 30 degrees from above, it reads as a flat patch lying on the floor, wider than tall (about 2:1), with soft irregular organic edges that fade out into nothing, and no raised object taller than a few pixels. Dark-fantasy pixel-art style, soft light from the upper left, crisp clean pixel art with controlled dithering, no blur and no smooth airbrushed gradient. Centered with roughly 8% empty margin, not touching the frame edges. Background: a single, completely flat and uniform solid cyan color (#00FFFF), with no scenery, no cast shadow, no gradient or texture behind it, and no cyan on the patch itself. No text, logo, watermark, frame, border, UI element, character, creature, or second object, and no hard straight edges or perfect diamond outline — only this one ground patch, alone. Landscape image.
```

#### P33 — `shendilavri_trilha_01` 

- [ ] gerada · [ ] aprovada · candidata: `.atena/generated/art-candidates/scenery/shendilavri_trilha_01_v01.png`

```text
A grand processional walkway of polished black and deep-wine stone tiles with thin silver inlay lines running along its length, some tiles cracked and a few dark-red petals resting on it, running from the left side of the image to the right side as a slightly winding strip. It is a ground decal: seen from a three-quarter isometric angle tilted about 30 degrees from above, it reads as a flat path lying on the floor, wider than tall (about 2:1), with ragged edges where the tiles end and fade into nothing at both ends, and no raised object taller than a few pixels. Dark-fantasy pixel-art style, soft light from the upper left, crisp clean pixel art with controlled dithering, no blur and no smooth airbrushed gradient. Centered with roughly 8% empty margin. Background: a single, completely flat and uniform solid cyan color (#00FFFF), with no scenery, no cast shadow, no gradient or texture behind it, and no cyan on the path itself. No text, logo, watermark, frame, border, UI element, character, creature, or second object, and no perfect diamond outline — only this one path, alone. Landscape image.
```

### Goranthis

#### P34 — `goranthis_estrutura_01` 

- [ ] gerada · [ ] aprovada · candidata: `.atena/generated/art-candidates/scenery/goranthis_estrutura_01_v01.png`

```text
A ruined marble pavilion of a false paradise: a small open gazebo of ivory marble columns with worn gold trim, a partly collapsed roof, and pale aqua-green moss climbing the stone. Thick, faintly fleshy pink-toned vines wind around one column and the base, hinting that the beauty is corrupted from within, without any gore, faces or creatures. It looks serene at first glance and slightly wrong on closer look, with no writing or symbols. Dark-fantasy isometric pixel-art game prop, viewed from a three-quarter isometric angle tilted about 30 degrees from above, soft directional light from the upper left. Crisp, clean pixel-art rendering with controlled dithering, no blur and no smooth anti-aliasing. Centered with roughly 12% empty margin on every side, not touching the frame edges. Its base rests firmly on the ground with a solid footing of marble steps, roots and fallen stone, so nothing looks like it is hovering, and no stray pixels float below the base. The whole silhouette is solid and fully opaque. Background: a single, completely flat and uniform solid magenta color (#FF00FF), with no ground plane, cast shadow, gradient, vignette, texture, or scenery. No text, logo, watermark, frame, border, UI element, character, creature, or second object — only this one pavilion, alone. Square image.
```

#### P35 — `goranthis_remendo_01` 

- [ ] gerada · [ ] aprovada · candidata: `.atena/generated/art-candidates/scenery/goranthis_remendo_01_v01.png`

```text
A flat irregular patch of soft green grass dotted with small white flowers, with here and there a single flower with a corrupted purple petal, and a few cracked ivory marble fragments half hidden in the grass. It is a ground decal: seen from a three-quarter isometric angle tilted about 30 degrees from above, it reads as a flat patch lying on the floor, wider than tall (about 2:1), with soft irregular organic edges that fade out into nothing, and no raised object taller than a few pixels. Dark-fantasy pixel-art style, soft light from the upper left, crisp clean pixel art with controlled dithering, no blur and no smooth airbrushed gradient. Centered with roughly 8% empty margin, not touching the frame edges. Background: a single, completely flat and uniform solid magenta color (#FF00FF), with no scenery, no cast shadow, no gradient or texture behind it, and no magenta or bright pink on the patch itself. No text, logo, watermark, frame, border, UI element, character, creature, or second object, and no hard straight edges or perfect diamond outline — only this one ground patch, alone. Landscape image.
```

#### P36 — `goranthis_trilha_01` 

- [ ] gerada · [ ] aprovada · candidata: `.atena/generated/art-candidates/scenery/goranthis_trilha_01_v01.png`

```text
A garden path of ivory marble stepping slabs with worn gold edging, spaced unevenly across aqua-green moss and short grass, some slabs cracked, running from the left side of the image to the right side as a slightly winding strip. It is a ground decal: seen from a three-quarter isometric angle tilted about 30 degrees from above, it reads as a flat path lying on the floor, wider than tall (about 2:1), with the slabs thinning out and fading into nothing at both ends, and no raised object taller than a few pixels. Dark-fantasy pixel-art style, soft light from the upper left, crisp clean pixel art with controlled dithering, no blur and no smooth airbrushed gradient. Centered with roughly 8% empty margin. Background: a single, completely flat and uniform solid magenta color (#FF00FF), with no scenery, no cast shadow, no gradient or texture behind it. No text, logo, watermark, frame, border, UI element, character, creature, or second object, and no perfect diamond outline — only this one path, alone. Landscape image.
```

### Os Pilares

#### P37 — `pilares_estrutura_01` 

- [ ] gerada · [ ] aprovada · candidata: `.atena/generated/art-candidates/scenery/pilares_estrutura_01_v01.png`

```text
A grounded heap of fused ruins from different layers of an abyss, welded together into one solid mass: a piece of a slate-blue temple roof, a broken ivory marble column, a rusted iron-barred window and a chunk of black wine-colored stone, all fused by thick violet-black crystalline growths with faint lilac veins. Nothing floats: the whole mass sits heavily on the ground on a wide cracked base. It has no writing and no readable symbols. Dark-fantasy isometric pixel-art game prop, viewed from a three-quarter isometric angle tilted about 30 degrees from above, soft directional light from the upper left. Crisp, clean pixel-art rendering with controlled dithering, no blur and no smooth anti-aliasing. Centered with roughly 12% empty margin on every side, not touching the frame edges. Its base rests firmly on the ground with a solid footing of crystal and rubble, so nothing looks like it is hovering, and no stray pixels float below the base. The whole silhouette is solid and fully opaque. Background: a single, completely flat and uniform solid cyan color (#00FFFF), with no ground plane, cast shadow, gradient, vignette, texture, or scenery, and no cyan on the object itself. No text, logo, watermark, frame, border, UI element, character, creature, or second object — only this one fused ruin, alone. Square image.
```

#### P38 — `pilares_remendo_01` 

- [ ] gerada · [ ] aprovada · candidata: `.atena/generated/art-candidates/scenery/pilares_remendo_01_v01.png`

```text
A flat irregular patch of fractured violet-black stone with fine lilac electric veins spreading through the cracks, and small scattered fragments of mixed stone in slate-blue, ivory and rust tones lying on top. It is a ground decal: seen from a three-quarter isometric angle tilted about 30 degrees from above, it reads as a flat patch lying on the floor, wider than tall (about 2:1), with soft irregular organic edges that fade out into nothing, and no raised object taller than a few pixels. Dark-fantasy pixel-art style, soft light from the upper left, crisp clean pixel art with controlled dithering, no blur and no smooth airbrushed gradient. Centered with roughly 8% empty margin, not touching the frame edges. Background: a single, completely flat and uniform solid cyan color (#00FFFF), with no scenery, no cast shadow, no gradient or texture behind it, and no cyan on the patch itself. No text, logo, watermark, frame, border, UI element, character, creature, or second object, and no hard straight edges or perfect diamond outline — only this one ground patch, alone. Landscape image.
```

#### P39 — `pilares_trilha_01` 

- [ ] gerada · [ ] aprovada · candidata: `.atena/generated/art-candidates/scenery/pilares_trilha_01_v01.png`

```text
A fractured causeway of violet-black stone slabs held together by thin glowing lilac veins, with a few slabs shifted out of line and small mixed fragments of other stones between them, running from the left side of the image to the right side as a slightly winding strip. It is a ground decal: seen from a three-quarter isometric angle tilted about 30 degrees from above, it reads as a flat path lying on the floor, wider than tall (about 2:1), with ragged edges where the slabs thin out and fade into nothing at both ends, and no raised object taller than a few pixels. Dark-fantasy pixel-art style, soft light from the upper left, crisp clean pixel art with controlled dithering, no blur and no smooth airbrushed gradient. Centered with roughly 8% empty margin. Background: a single, completely flat and uniform solid cyan color (#00FFFF), with no scenery, no cast shadow, no gradient or texture behind it, and no cyan on the path itself. No text, logo, watermark, frame, border, UI element, character, creature, or second object, and no perfect diamond outline — only this one path, alone. Landscape image.
```

## Como devolver

1. Coloque os PNGs brutos nas pastas de candidata indicadas.
2. Avise a Atena por lote. Ela normaliza, valida em runtime e monta a prancha de revisão.
3. Você aprova por imagem; só então acontece a admissão, com backup e suíte + smoke verdes.
