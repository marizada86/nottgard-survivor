---
id: PROMPTS-RETRATOS-FICHA-HUD
title: Prompts para o ChatGPT gerar os retratos da Ficha do herói (C) e do HUD, dos 12 heróis jogáveis
status: DRAFT r1 em 2026-10-14; aguarda revisão do dono; nenhuma imagem gerada nem admitida; sem promoção a canon
content_state: DRAFT
sources: ["ui/menu.gd", "ui/character_sheet.gd", "ui/hero_panel.gd", ".atena/vault/drafts/FICHAS-DE-IDENTIDADE-herois-m1-2026-10-14.md", ".atena/vault/canon/ART-DIRECTION-019-leoric-retrato-selecao-2026-09-29.md", "data/heroes.json"]
---

# Retratos novos: Ficha do herói (C) e HUD

## O que muda e o que fica

| Lugar | Hoje | Decisão |
|---|---|---|
| Menu de seleção (360×180) | `assets/portraits/<id>.png` | **Fica como está** |
| Ficha do herói (C), moldura de 250×90 px (70 px no toque) | o mesmo retrato do menu, encolhido e centralizado na moldura | **Imagem nova, em faixa larga** |
| HUD, canto da tela de jogo (76×76 px) | o mesmo retrato do menu, cortado em quadrado (`COVERED`) | **Imagem nova, em quadrado, rosto grande** |

Por que imagens separadas: a faixa da Ficha é ~3:1 e o quadrado do HUD é 1:1, enquanto o retrato do menu é 3:2. Hoje o retrato é encolhido na Ficha e cortado no HUD, e o rosto fica pequeno. No HUD ele aparece com 76 px, então precisa de rosto grande e contraste forte.

## Como usar no ChatGPT

1. Abra **uma conversa por herói** (mantém o rosto e a roupa iguais entre os dois formatos).
2. Anexe as referências do herói: `assets/portraits/<id>.png` (rosto, estilo e roupa) e `assets/heroes/<id>.png` (sprite, para cores e silhueta). Escreva "use the attached images as the reference for the face, outfit and palette".
3. Cole primeiro o prompt **FICHA**, aprove ou peça ajuste, depois cole o **HUD** na mesma conversa.
4. Salve como `<id>_ficha.png` e `<id>_hud.png` e me entregue. Eu corto a faixa para 3:1, confiro contra a ficha de identidade e proponho a admissão.

Tamanhos pedidos: **FICHA** 1536×1024 (eu corto a faixa central 1536×512); **HUD** 1024×1024.

## Bloco de estilo (já incluído em cada prompt)

> Dark fantasy painterly digital illustration, like a moody oil-painting concept portrait: natural face and hand proportions, worn materials, cold side lighting with small warm accents, soft atmospheric depth, blurred dark background. Not cartoon, not chibi, not anime, not pixel art. No text, no letters, no border, no frame, no watermark, no user interface.

## Formatos

- **FICHA**: composição cinematográfica larga, 3:2. Tudo o que importa (rosto, arma ou símbolo) fica na faixa horizontal central, porque o topo e a base serão cortados. Cabeça e ombros no centro, arma ou efeito se estendendo na horizontal.
- **HUD**: quadrado 1:1, cabeça e ombros, rosto ocupando uns 60% do quadro, fundo escuro simples com luz de contorno na cor do herói. Silhueta legível a 76 px.

---

## 1. Durvall

**FICHA**

```
Dark fantasy painterly digital illustration, like a moody oil-painting concept portrait: natural face and hand proportions, worn materials, cold side lighting with small warm accents, soft atmospheric depth, blurred dark background. Not cartoon, not chibi, not anime, not pixel art. No text, no letters, no border, no frame, no watermark, no user interface.

Wide cinematic composition, 3:2 canvas (1536x1024). Keep every important element (face, sword) inside the central horizontal band of the image, because top and bottom will be cropped to a 3:1 strip. Head and shoulders in the center.

Durvall, a drow: cool grey-blue skin, long loose white hair, pointed ears with a faint reddish tint, severe stern face. Black laminated plate armor with spiked pauldrons, a wine-red sash, a small blue pendant on the chest. He holds a sword with a luminous ice-blue blade that extends horizontally to the right side of the frame, casting cold blue light on his face. Background: dark night ruins of a castle, blurred, with faint blue mist. Use the attached images as the reference for face, outfit and palette.
```

**HUD**

```
Dark fantasy painterly digital illustration, like a moody oil-painting concept portrait: natural face and hand proportions, worn materials, cold side lighting with small warm accents, soft atmospheric depth. Not cartoon, not chibi, not anime, not pixel art. No text, no letters, no border, no frame, no watermark, no user interface.

Square 1:1 canvas (1024x1024), head-and-shoulders portrait, the face filling about 60% of the frame, centered, looking slightly toward the viewer. Strong readable silhouette and high contrast, because it will be shown at 76x76 pixels. Simple dark background with a subtle ice-blue rim light.

Durvall, a drow: cool grey-blue skin, long loose white hair, pointed ears with a faint reddish tint, severe stern face. Black laminated plate armor with spiked pauldrons; the edge of a glowing ice-blue sword blade is visible beside his face. Same character as the attached images.
```

## 2. Brook França

> Atenção: a referência canônica de Brook (`brook-canonical-2026-09-29.png`) continua ausente (P2 das fichas). Use o sprite atual e o retrato atual como referência, e reenvie a canônica se a achar.

**FICHA**

```
Dark fantasy painterly digital illustration, like a moody oil-painting concept portrait: natural face and hand proportions, worn materials, cold side lighting with small warm accents, soft atmospheric depth, blurred dark background. Not cartoon, not chibi, not anime, not pixel art. No text, no letters, no border, no frame, no watermark, no user interface.

Wide cinematic composition, 3:2 canvas (1536x1024). Keep every important element (face, mace) inside the central horizontal band of the image, because top and bottom will be cropped to a 3:1 strip. Head and shoulders in the center.

Brook França, a halfling paladin: compact and short, a mature determined face, white hair combed back, a short white beard, pointed ears. Sturdy dark armor of worn steel with very discreet gold trim, and a dark cape with a thin gold edge. A spiked mace held head-down at the left side of the frame. A restrained, soft warm radiant light on him, no halo, no wings, no excessive glow, no regal pose. He is clearly a halfling, never a tall human, and carries no hammer and no blue shield. Background: a dim stone hall, blurred. Use the attached images as the reference for face, outfit and palette.
```

**HUD**

```
Dark fantasy painterly digital illustration, like a moody oil-painting concept portrait: natural face and hand proportions, worn materials, cold side lighting with small warm accents, soft atmospheric depth. Not cartoon, not chibi, not anime, not pixel art. No text, no letters, no border, no frame, no watermark, no user interface.

Square 1:1 canvas (1024x1024), head-and-shoulders portrait, the face filling about 60% of the frame, centered, looking slightly toward the viewer. Strong readable silhouette and high contrast, because it will be shown at 76x76 pixels. Simple dark background with a subtle warm gold rim light.

Brook França, a halfling paladin: a mature determined face, white hair combed back, a short white beard, pointed ears, dark sturdy worn steel armor with very discreet gold trim, dark cape. No halo, no wings. Same character as the attached images.
```

## 3. Maelor

**FICHA**

```
Dark fantasy painterly digital illustration, like a moody oil-painting concept portrait: natural face and hand proportions, worn materials, cold side lighting with small warm accents, soft atmospheric depth, blurred dark background. Not cartoon, not chibi, not anime, not pixel art. No text, no letters, no border, no frame, no watermark, no user interface.

Wide cinematic composition, 3:2 canvas (1536x1024). Keep every important element (face, flame, medallion) inside the central horizontal band of the image, because top and bottom will be cropped to a 3:1 strip. Head and shoulders in the center.

Maelor, a young human devotee: tousled chestnut-golden hair, light stubble, an attentive expression. Light coat with brown collars, a navy-blue cape with gold borders, a belt with pouches and small blue vials, a gold star medallion on the chest. A blue flame floats in his open palm at the left side of the frame, lighting his face; his other hand is extended to the opposite side. Background: a night sky with one bright star, blurred. Use the attached images as the reference for face, outfit and palette.
```

**HUD**

```
Dark fantasy painterly digital illustration, like a moody oil-painting concept portrait: natural face and hand proportions, worn materials, cold side lighting with small warm accents, soft atmospheric depth. Not cartoon, not chibi, not anime, not pixel art. No text, no letters, no border, no frame, no watermark, no user interface.

Square 1:1 canvas (1024x1024), head-and-shoulders portrait, the face filling about 60% of the frame, centered, looking slightly toward the viewer. Strong readable silhouette and high contrast, because it will be shown at 76x76 pixels. Simple dark background with a subtle blue rim light.

Maelor, a young human: tousled chestnut-golden hair, light stubble, an attentive expression, navy cape with gold borders, gold star medallion on the chest, a soft blue flame glow from the lower left. Same character as the attached images.
```

## 4. Sylas Malafaia

**FICHA**

```
Dark fantasy painterly digital illustration, like a moody oil-painting concept portrait: natural face and hand proportions, worn materials, cold side lighting with small warm accents, soft atmospheric depth, blurred dark background. Not cartoon, not chibi, not anime, not pixel art. No text, no letters, no border, no frame, no watermark, no user interface.

Wide cinematic composition, 3:2 canvas (1536x1024). Keep every important element (mask, horns, dagger) inside the central horizontal band of the image, because top and bottom will be cropped to a 3:1 strip. Head and shoulders in the center.

Sylas, a tiefling devotee: two curved horns rising from the head, a hood, a dark beak-shaped mask with glowing violet eyes, a tall closed silhouette. Black armor with violet details, a central purple sash, a torn purple cape, a necklace with a violet stone, pauldrons. A violet dagger pointing downward at the left side of the frame, casting purple light. Background: dark swirling shadow and mist, blurred. Use the attached images as the reference for face, outfit and palette.
```

**HUD**

```
Dark fantasy painterly digital illustration, like a moody oil-painting concept portrait: natural face and hand proportions, worn materials, cold side lighting with small warm accents, soft atmospheric depth. Not cartoon, not chibi, not anime, not pixel art. No text, no letters, no border, no frame, no watermark, no user interface.

Square 1:1 canvas (1024x1024), head-and-shoulders portrait, the mask filling about 60% of the frame, centered, looking slightly toward the viewer. Strong readable silhouette and high contrast, because it will be shown at 76x76 pixels. Simple dark background with a subtle violet rim light.

Sylas, a tiefling: two curved horns, a hood, a dark beak-shaped mask with glowing violet eyes, black armor with violet details. Same character as the attached images.
```

## 5. Kayron Lioran

> Decisão P1: sprite atual, **sem asas**.

**FICHA**

```
Dark fantasy painterly digital illustration, like a moody oil-painting concept portrait: natural face and hand proportions, worn materials, cold side lighting with small warm accents, soft atmospheric depth, blurred dark background. Not cartoon, not chibi, not anime, not pixel art. No text, no letters, no border, no frame, no watermark, no user interface.

Wide cinematic composition, 3:2 canvas (1536x1024). Keep every important element (face, hand with light) inside the central horizontal band of the image, because top and bottom will be cropped to a 3:1 strip. Head and shoulders in the center.

Kayron, a young aasimar scholar: short messy silver-white hair, light eyes, a young serious face. Black laminated armor with buckles, a torn purple cape, a purple cloth at the neck, a dark central sash with an emblem. NO wings. One hand raised, gathering cold violet-white starlight that lights his face. Background: a dim wall with faint abyssal inscriptions, blurred. Use the attached images as the reference for face, outfit and palette.
```

**HUD**

```
Dark fantasy painterly digital illustration, like a moody oil-painting concept portrait: natural face and hand proportions, worn materials, cold side lighting with small warm accents, soft atmospheric depth. Not cartoon, not chibi, not anime, not pixel art. No text, no letters, no border, no frame, no watermark, no user interface.

Square 1:1 canvas (1024x1024), head-and-shoulders portrait, the face filling about 60% of the frame, centered, looking slightly toward the viewer. Strong readable silhouette and high contrast, because it will be shown at 76x76 pixels. Simple dark background with a subtle violet rim light.

Kayron, a young aasimar: short messy silver-white hair, light eyes, a serious face, black laminated armor, a torn purple cape and a purple cloth at the neck. No wings. Same character as the attached images.
```

## 6. Korrak Nammat

**FICHA**

```
Dark fantasy painterly digital illustration, like a moody oil-painting concept portrait: natural face and hand proportions, worn materials, cold side lighting with small warm accents, soft atmospheric depth, blurred dark background. Not cartoon, not chibi, not anime, not pixel art. No text, no letters, no border, no frame, no watermark, no user interface.

Wide cinematic composition, 3:2 canvas (1536x1024). Keep every important element (face, axe) inside the central horizontal band of the image, because top and bottom will be cropped to a 3:1 strip. Head and shoulders in the center.

Korrak, a goliath: grey skin, very broad and muscular, a shaved head with a mohawk crest, a full dark beard, a closed stern gaze. Brown beast fur over the shoulders, a spiked pauldron, a leather chestplate with belts, worn metal bracers. He holds with both hands a double-bladed dark axe with glowing lava cracks; the axe head sits fully inside the frame on the right side and is never cut by the border. Background: dark rock with drifting orange embers, blurred. Use the attached images as the reference for face, outfit and palette.
```

**HUD**

```
Dark fantasy painterly digital illustration, like a moody oil-painting concept portrait: natural face and hand proportions, worn materials, cold side lighting with small warm accents, soft atmospheric depth. Not cartoon, not chibi, not anime, not pixel art. No text, no letters, no border, no frame, no watermark, no user interface.

Square 1:1 canvas (1024x1024), head-and-shoulders portrait, the face filling about 60% of the frame, centered, looking slightly toward the viewer. Strong readable silhouette and high contrast, because it will be shown at 76x76 pixels. Simple dark background with a subtle orange-red lava rim light.

Korrak, a goliath: grey skin, a shaved head with a mohawk crest, a full dark beard, a closed stern gaze, brown beast fur and a spiked pauldron on the shoulders. Same character as the attached images.
```

## 7. Leoric

> ART-DIRECTION-019: gnomo adulto, nunca criança ou mascote; cartola preta com faixa marrom; foco azul só como acento pequeno; fundo sem personagens.

**FICHA**

```
Dark fantasy painterly digital illustration, like a moody oil-painting concept portrait: natural face and hand proportions, worn materials, cold side lighting with small warm accents, soft atmospheric depth, blurred dark background. Not cartoon, not chibi, not anime, not pixel art. No text, no letters, no border, no frame, no watermark, no user interface.

Wide cinematic composition, 3:2 canvas (1536x1024). Keep every important element (face, hat, staff crystal) inside the central horizontal band of the image, because top and bottom will be cropped to a 3:1 strip. Head and shoulders in the center.

Leoric, an adult gnome: short and compact, never a child and never a mascot. A voluminous grey beard, pointed ears, a scowling sideways glance. A black top hat with a brown band, a brown overcoat open over a dark vest, a belt with pockets, a book at the waist. A gnarled wooden staff with a small blue crystal at the left side of the frame; the blue is only a small accent. Natural face and hand proportions, worn materials, cold side light with discreet warm points. Background: a dim arcane crypt or library, dark and blurred, no other characters. Use the attached images as the reference for face, outfit and palette.
```

**HUD**

```
Dark fantasy painterly digital illustration, like a moody oil-painting concept portrait: natural face and hand proportions, worn materials, cold side lighting with small warm accents, soft atmospheric depth. Not cartoon, not chibi, not anime, not pixel art. No text, no letters, no border, no frame, no watermark, no user interface.

Square 1:1 canvas (1024x1024), head-and-shoulders portrait, the face filling about 60% of the frame, centered, looking slightly sideways. Strong readable silhouette and high contrast, because it will be shown at 76x76 pixels. Simple dark background with a subtle cool blue rim light.

Leoric, an adult gnome: a voluminous grey beard, pointed ears, a scowl, a black top hat with a brown band, a brown overcoat. Never a child or a mascot. Same character as the attached images.
```

## 8. Nyrelia

> Decisão P4: **rosto oculto**. Nada de rosto, cabelo ou espécie.

**FICHA**

```
Dark fantasy painterly digital illustration, like a moody oil-painting concept portrait: natural face and hand proportions, worn materials, cold side lighting with small warm accents, soft atmospheric depth, blurred dark background. Not cartoon, not chibi, not anime, not pixel art. No text, no letters, no border, no frame, no watermark, no user interface.

Wide cinematic composition, 3:2 canvas (1536x1024). Keep every important element (hood, mask, glowing sphere) inside the central horizontal band of the image, because top and bottom will be cropped to a 3:1 strip. Head and shoulders in the center.

Nyrelia, a priestess: tall and long-silhouetted, her face completely hidden by a dark green hood and a smooth dark mask; no face, no hair and no skin are visible anywhere. A moss-green mantle with gold borders, a gold brooch at the shoulder, a veil over the chest, a vertical embroidered green panel in front, a black dress, gloves. Her hands are together in front of her, holding a luminous green sphere that lights the mask from below. Background: a dark shadowy temple, blurred. Use the attached images as the reference for outfit and palette.
```

**HUD**

```
Dark fantasy painterly digital illustration, like a moody oil-painting concept portrait: natural face and hand proportions, worn materials, cold side lighting with small warm accents, soft atmospheric depth. Not cartoon, not chibi, not anime, not pixel art. No text, no letters, no border, no frame, no watermark, no user interface.

Square 1:1 canvas (1024x1024), head-and-shoulders portrait of a figure whose face is completely hidden by a dark green hood and a smooth dark mask (no face, no hair, no skin visible), the hood filling about 60% of the frame, centered. Strong readable silhouette and high contrast, because it will be shown at 76x76 pixels. Simple dark background with a subtle green glow from below and a gold rim light.

Nyrelia: moss-green mantle with gold borders, a gold brooch at the shoulder. Same character as the attached images.
```

## 9. Zynara Vellen

**FICHA**

```
Dark fantasy painterly digital illustration, like a moody oil-painting concept portrait: natural face and hand proportions, worn materials, cold side lighting with small warm accents, soft atmospheric depth, blurred dark background. Not cartoon, not chibi, not anime, not pixel art. No text, no letters, no border, no frame, no watermark, no user interface.

Wide cinematic composition, 3:2 canvas (1536x1024). Keep every important element (face, hourglass) inside the central horizontal band of the image, because top and bottom will be cropped to a 3:1 strip. Head and shoulders in the center.

Zynara Vellen, an elf: long wavy white hair, a high bun with a gold ornament, pointed ears, a serene expression. A long black dress with gold embroidery, a corset and puffed sleeves, a belt with a flask and a star pendant. She holds an hourglass on the right side of the frame, its sand catching warm gold light. Background: a dim council hall with stone arches, blurred, with soft gold light. Use the attached images as the reference for face, outfit and palette.
```

**HUD**

```
Dark fantasy painterly digital illustration, like a moody oil-painting concept portrait: natural face and hand proportions, worn materials, cold side lighting with small warm accents, soft atmospheric depth. Not cartoon, not chibi, not anime, not pixel art. No text, no letters, no border, no frame, no watermark, no user interface.

Square 1:1 canvas (1024x1024), head-and-shoulders portrait, the face filling about 60% of the frame, centered, looking slightly toward the viewer. Strong readable silhouette and high contrast, because it will be shown at 76x76 pixels. Simple dark background with a subtle warm gold rim light.

Zynara Vellen, an elf: long wavy white hair, a high bun with a gold ornament, pointed ears, a serene expression, a black dress with gold embroidery. Same character as the attached images.
```

## 10. Bromnor Martelo da Luz

> Vault: o espírito dele habita o martelo. **Não representar isso** (sem fantasma, sem aura espectral).

**FICHA**

```
Dark fantasy painterly digital illustration, like a moody oil-painting concept portrait: natural face and hand proportions, worn materials, cold side lighting with small warm accents, soft atmospheric depth, blurred dark background. Not cartoon, not chibi, not anime, not pixel art. No text, no letters, no border, no frame, no watermark, no user interface.

Wide cinematic composition, 3:2 canvas (1536x1024). Keep every important element (face, hammer head) inside the central horizontal band of the image, because top and bottom will be cropped to a 3:1 strip. Head and shoulders in the center.

Bromnor, a dwarf high counselor and battle leader: a long wavy white beard, white hair, strong eyebrows, a broad and low body. Golden armor engraved with knot patterns, a blue mantle, a tall decorated pauldron. A warhammer with a golden head and a long haft rests on his shoulder at the left side of the frame. No ghost, no spirit, no spectral aura. Background: a dwarven forge hall with warm golden light, blurred. Use the attached images as the reference for face, outfit and palette.
```

**HUD**

```
Dark fantasy painterly digital illustration, like a moody oil-painting concept portrait: natural face and hand proportions, worn materials, cold side lighting with small warm accents, soft atmospheric depth. Not cartoon, not chibi, not anime, not pixel art. No text, no letters, no border, no frame, no watermark, no user interface.

Square 1:1 canvas (1024x1024), head-and-shoulders portrait, the face and beard filling about 60% of the frame, centered, looking slightly toward the viewer. Strong readable silhouette and high contrast, because it will be shown at 76x76 pixels. Simple dark background with a subtle warm gold rim light.

Bromnor, a dwarf: a long wavy white beard, white hair, strong eyebrows, golden engraved armor with a tall decorated pauldron, a blue mantle. No ghost, no spectral aura. Same character as the attached images.
```

## 11. Arlindo Orlando

**FICHA**

```
Dark fantasy painterly digital illustration, like a moody oil-painting concept portrait: natural face and hand proportions, worn materials, cold side lighting with small warm accents, soft atmospheric depth, blurred dark background. Not cartoon, not chibi, not anime, not pixel art. No text, no letters, no border, no frame, no watermark, no user interface.

Wide cinematic composition, 3:2 canvas (1536x1024). Keep every important element (face, hat, hands) inside the central horizontal band of the image, because top and bottom will be cropped to a 3:1 strip. Head and shoulders in the center.

Arlindo, a mature human wanderer: a lined face, a short grey beard, his gaze lowered, a slightly stooped posture. A brown wide-brim felt hat, a long brown overcoat, a dark red scarf, dark gloves. His hands are together in front of him with faint glowing motes of memory floating between them, no object held. Background: misty ruined houses at dusk, blurred. Use the attached images as the reference for face, outfit and palette.
```

**HUD**

```
Dark fantasy painterly digital illustration, like a moody oil-painting concept portrait: natural face and hand proportions, worn materials, cold side lighting with small warm accents, soft atmospheric depth. Not cartoon, not chibi, not anime, not pixel art. No text, no letters, no border, no frame, no watermark, no user interface.

Square 1:1 canvas (1024x1024), head-and-shoulders portrait, the face filling about 60% of the frame, centered, gaze slightly lowered. Strong readable silhouette and high contrast, because it will be shown at 76x76 pixels. Simple dark background with a subtle warm amber rim light.

Arlindo, a mature human wanderer: a lined face, a short grey beard, a brown wide-brim felt hat, a dark red scarf, a brown overcoat. Same character as the attached images.
```

## 12. Erik Blackthorn

> Decisão P6: **sem cicatriz**.

**FICHA**

```
Dark fantasy painterly digital illustration, like a moody oil-painting concept portrait: natural face and hand proportions, worn materials, cold side lighting with small warm accents, soft atmospheric depth, blurred dark background. Not cartoon, not chibi, not anime, not pixel art. No text, no letters, no border, no frame, no watermark, no user interface.

Wide cinematic composition, 3:2 canvas (1536x1024). Keep every important element (face, torch flame, medallion) inside the central horizontal band of the image, because top and bottom will be cropped to a 3:1 strip. Head and shoulders in the center.

Erik, a robust human scout: tousled black hair, a full beard, a hard gaze, no scars. A light fur collar and a wool scarf, a dark blue coat with crossed leather belts, a glowing medallion on the chest, a sword hilt visible above one shoulder. A lit torch held at the left side of the frame, the whole flame inside the image, lighting his face orange. Background: night docks with a faint orange glow in the distance, blurred. Use the attached images as the reference for face, outfit and palette.
```

**HUD**

```
Dark fantasy painterly digital illustration, like a moody oil-painting concept portrait: natural face and hand proportions, worn materials, cold side lighting with small warm accents, soft atmospheric depth. Not cartoon, not chibi, not anime, not pixel art. No text, no letters, no border, no frame, no watermark, no user interface.

Square 1:1 canvas (1024x1024), head-and-shoulders portrait, the face filling about 60% of the frame, centered, looking slightly toward the viewer. Strong readable silhouette and high contrast, because it will be shown at 76x76 pixels. Simple dark background with a subtle orange torch-light rim light.

Erik, a robust human scout: tousled black hair, a full beard, a hard gaze, no scars, a light fur collar, a wool scarf, a dark blue coat, a glowing medallion. Same character as the attached images.
```

---

## Depois que as imagens chegarem (não executado)

1. Eu corto a faixa 3:1 da FICHA e confiro cada imagem contra a ficha de identidade (traços fixos e "não pode").
2. Salvo em `assets/portraits/ficha/<id>.png` e `assets/portraits/hud/<id>.png`, com fallback para `assets/portraits/<id>.png`.
3. Ajusto `ui/character_sheet.gd` e `ui/hero_panel.gd` para usar os novos caminhos. O menu (`ui/menu.gd`) não muda.
4. Admissão com aceite do dono (registro de aprovação e trava de assets) e playtest visual do HUD a 76 px.
