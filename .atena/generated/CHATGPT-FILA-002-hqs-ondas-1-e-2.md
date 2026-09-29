---
id: "CHATGPT-FILA-002"
type: "fila-de-prompts"
title: "Fila de prompts das HQs — Ondas 1 e 2 (52 imagens)"
status: "pronta para envio — nada executado; separada da CHATGPT-FILA-001, que está em andamento"
created: "2026-09-29"
relations: ["[[ART-PROMPTS-028-hqs-onda-1]]", "[[ART-PROMPTS-029-hqs-onda-2]]", "[[PLAN-040-hqs-novas-highlights-do-vault-2026-09-29]]", "[[CHATGPT-FILA-001-prompts-prontos]]"]
---

# Fila de prompts das HQs — Ondas 1 e 2

> **Não confundir com a [[CHATGPT-FILA-001-prompts-prontos]].** A FILA-001 (P01–P39: Lote 1, piloto “Uma Noite Sem Fim” e Lote 2) já foi enviada e está **em andamento** no ChatGPT. Esta fila é outra remessa: numeração própria **H01–H52**, arquivos de origem próprios (ART-PROMPTS-028 e 029) e candidatas com nomes distintos (`hq_n02` a `hq_n14`). Nada aqui tem relação com os pedidos em andamento.

Compilação **literal** dos parágrafos de ART-PROMPTS-028 e 029. Em caso de dúvida, o arquivo de origem prevalece.

| Bloco | Origem | Prompts | Numeração | HQs |
|---|---|---:|---|---|
| Onda 1 | ART-PROMPTS-028 | 20 | H01–H20 | HQN-02 a HQN-06 |
| Onda 2 | ART-PROMPTS-029 | 32 | H21–H52 | HQN-07 a HQN-14 |

## Regras para todo envio

1. **Uma imagem por mensagem**, parágrafo completo. **Uma HQ por conversa**, quadros em ordem.
2. **Anexe os retratos** indicados em cada quadro (`assets/portraits/<nome>.png`). Rosto, cabelo, roupa ou arma que destoem da referência reprovam o quadro.
3. **Imagens opacas 16:9**, sem texto, balão, moldura ou marca-d'água, sem gore. Sem remoção de fundo.
4. **Descarte e regenere** quadros com personagem fora da referência, texto, gore ou terço inferior poluído.
5. **Salve** cada PNG bruto como `.atena/generated/art-candidates/hq/<id>_q<n>_v01.png` (`_v02` para nova tentativa).
6. **Nada entra em `assets/`** sem aprovação explícita do dono (SPEC-080: redimensionar para 1280×720 e admitir).

## Marcação de progresso

Marque `[x]` ao gerar e `[a]` ao aprovar.

## Onda 1 — HQN-02 a HQN-06 (H01–H20)

Origem: [[ART-PROMPTS-028-hqs-onda-1]].

### HQN-02 — “Seremos um só”

Gatilho: Vencer Docas (chefe Guardião Alado). Proibido/cuidado: Adam, Astherion, a identidade do ‘Messias’, qualquer coisa após a Sessão 02; nada de sangue em detalhe.

#### H01 — `hq_n02_q1` · Recapitular · anexar: `kayron.png`, `durvall.png`, `sylas.png`, `maelor.png`

- [ ] gerada · [ ] aprovada · candidata: `.atena/generated/art-candidates/hq/hq_n02_q1_v01.png` · texto proposto na UI: Nas paredes do porão, uma só frase, repetida: “Seremos um só.”

```text
Four adventurers seen from behind at the bottom of a narrow stone stairway, entering a rusted, damp warehouse cellar whose walls are covered from floor to ceiling in carefully carved lines of abyssal glyphs, abstract marks that are not readable letters, repeating the same pattern over and over like a chant. Small clawed tracks run along the floor close to the walls, and old rust-colored stains cover the stone. Medium-wide shot from behind and slightly above, the carved walls converging toward a dark doorway, the party in dark silhouette lit by one amber lantern, cold green-gray fog at the floor, a faint hint of purple in the glyph grooves. Dark-fantasy illustration with dense pixel-art finish and controlled dithering, crisp pixel edges, no smooth painterly blur, wide 16:9 landscape composition. No text, no letters, no speech bubbles, no captions, no logo, no watermark, no frame or border, no UI. Keep the bottom third of the image visually calm and uncluttered. Nothing important is cropped by the edges. The named characters must match the attached reference portraits exactly; any other figure is an anonymous silhouette.
```

#### H02 — `hq_n02_q2` · Virar · anexar: `kayron.png`, `durvall.png`, `sylas.png`, `maelor.png`

- [ ] gerada · [ ] aprovada · candidata: `.atena/generated/art-candidates/hq/hq_n02_q2_v01.png` · texto proposto na UI: Um guardião alado. Mas era só uma cópia.

```text
A dark cellar chamber with an empty open coffin against the far wall and a single large carved eye above it, guarded by a winged demonic guardian with a clearly inhuman silhouette that hovers in the air over the coffin. Below, the four adventurers stand in a defensive line, small against the creature. Low-angle medium-wide shot looking up at the winged guardian, the empty coffin and the carved eye as the visual center, amber lantern light on the adventurers, cold shadow on the creature, a hint of red-brown rust on the walls. Dark-fantasy illustration with dense pixel-art finish and controlled dithering, crisp pixel edges, no smooth painterly blur, wide 16:9 landscape composition. No text, no letters, no speech bubbles, no captions, no logo, no watermark, no frame or border, no UI. Keep the bottom third of the image visually calm and uncluttered. Nothing important is cropped by the edges. The named characters must match the attached reference portraits exactly; any other figure is an anonymous silhouette.
```

#### H03 — `hq_n02_q3` · Apresentar · anexar: `sylas.png`

- [ ] gerada · [ ] aprovada · candidata: `.atena/generated/art-candidates/hq/hq_n02_q3_v01.png` · texto proposto na UI: Sylas executa o ritual: sangue celestial, sangue negro e um osso de galinha.

```text
A close shot of a pair of hands raising a small bone above a stone bowl that holds two liquids, one faintly golden-white and one thick and black, while pale ritual marks carved in the stone floor around the bowl begin to glow. A hooded figure is only partly visible behind the hands, and two other silhouettes watch from the edge of the light. Close, slightly high-angle shot, the bowl and hands at the center, soft pale glow from the marks, amber lantern at one side, deep shadow elsewhere, cold green-gray fog creeping at the floor. Dark-fantasy illustration with dense pixel-art finish and controlled dithering, crisp pixel edges, no smooth painterly blur, wide 16:9 landscape composition. No text, no letters, no speech bubbles, no captions, no logo, no watermark, no frame or border, no UI. Keep the bottom third of the image visually calm and uncluttered. Nothing important is cropped by the edges. The named characters must match the attached reference portraits exactly; any other figure is an anonymous silhouette.
```

#### H04 — `hq_n02_q4` · Dar gancho · anexar: `kayron.png`, `durvall.png`, `sylas.png`, `maelor.png`

- [ ] gerada · [ ] aprovada · candidata: `.atena/generated/art-candidates/hq/hq_n02_q4_v01.png` · texto proposto na UI: A névoa recuou. Uma voz sussurrou: “Só escuridão.”

```text
The four adventurers climb out of a hidden cellar door onto the quiet docks under the endless night, while the green-gray fog visibly thins and drifts away from the piers and warehouses, revealing the distant blue glow of the Tarn barrier. One of them stops and looks back at the dark doorway as if hearing something. Wide shot from the quay looking back toward the door, the party in silhouette, thinning fog, the blue barrier glow on the horizon, small amber lanterns on the piers. Dark-fantasy illustration with dense pixel-art finish and controlled dithering, crisp pixel edges, no smooth painterly blur, wide 16:9 landscape composition. No text, no letters, no speech bubbles, no captions, no logo, no watermark, no frame or border, no UI. Keep the bottom third of the image visually calm and uncluttered. Nothing important is cropped by the edges. The named characters must match the attached reference portraits exactly; any other figure is an anonymous silhouette.
```

### HQN-03 — O Véu Vivo

Gatilho: Primeira entrada em Shedaklah. Proibido/cuidado: Quem é Adam por trás do exército, o segredo do mestre sobre Durvall; nada de mortes em detalhe. Helion MORRE aqui (confirmar D-N2).

#### H05 — `hq_n03_q1` · Recapitular · sem anexos

- [ ] gerada · [ ] aprovada · candidata: `.atena/generated/art-candidates/hq/hq_n03_q1_v01.png` · texto proposto na UI: O exército abissal chegou à estrela.

```text
A burning elven forest clearing at night, with a tall glowing star-stone standing at its center as the source of a golden-white light, while a huge army of demons, aberrations and hooded cultists pours in from one side of the frame, and a thin line of elven defenders holds the other side. Fires burn between the trees, white rose bushes are stained red-brown, and only shapes and silhouettes are shown, never wounds. Very wide, high-angle shot of the battlefield, the star-stone as the bright center, fire light in amber and orange, cold green-gray fog rolling in from the edge of the frame. Dark-fantasy illustration with dense pixel-art finish and controlled dithering, crisp pixel edges, no smooth painterly blur, wide 16:9 landscape composition. No text, no letters, no speech bubbles, no captions, no logo, no watermark, no frame or border, no UI. Keep the bottom third of the image visually calm and uncluttered. Nothing important is cropped by the edges. No named characters in this image; any figures are anonymous silhouettes.
```

#### H06 — `hq_n03_q2` · Virar · sem anexos

- [ ] gerada · [ ] aprovada · candidata: `.atena/generated/art-candidates/hq/hq_n03_q2_v01.png` · texto proposto na UI: A luz de Ailalore falhou. A Tarn começou a cair.

```text
The golden-white light of the star-stone stutters and dies, and a long beam of light that had connected it to a distant curtain of blue energy barrier breaks and falls to the ground. High above, a dark crack opens in the blue barrier and thick green-gray fog begins to pour through it over the city. Wide low-angle shot looking up along the fallen beam toward the cracking barrier, the star-stone dim in the foreground, blue barrier light fading, green fog descending, small elven silhouettes below. Dark-fantasy illustration with dense pixel-art finish and controlled dithering, crisp pixel edges, no smooth painterly blur, wide 16:9 landscape composition. No text, no letters, no speech bubbles, no captions, no logo, no watermark, no frame or border, no UI. Keep the bottom third of the image visually calm and uncluttered. Nothing important is cropped by the edges. No named characters in this image; any figures are anonymous silhouettes.
```

#### H07 — `hq_n03_q3` · Apresentar · sem anexos

- [ ] gerada · [ ] aprovada · candidata: `.atena/generated/art-candidates/hq/hq_n03_q3_v01.png` · texto proposto na UI: “Nottgard resistirá. Por essa terra que tanto amamos, eu dou a minha vida.” — Helion

```text
An old elven mage with a long gray beard and long dark robes kneels before the dimmed star-stone, planting a wooden staff into the ground with one hand and pressing a small seed into the earth with the other. His head is bowed in apology. Warm golden light rises around him against the cold green fog, and a group of small silhouettes stands behind him, reaching out but too far to stop him. Medium shot from slightly below, the kneeling mage centered, the staff and the seed in sharp focus, golden light against green fog, the silhouettes small at the edge of the frame. Dark-fantasy illustration with dense pixel-art finish and controlled dithering, crisp pixel edges, no smooth painterly blur, wide 16:9 landscape composition. No text, no letters, no speech bubbles, no captions, no logo, no watermark, no frame or border, no UI. Keep the bottom third of the image visually calm and uncluttered. Nothing important is cropped by the edges. No named characters in this image; any figures are anonymous silhouettes.
```

#### H08 — `hq_n03_q4` · Dar gancho · anexar: `leoric.png`, `maelor.png`, `brook.png`

- [ ] gerada · [ ] aprovada · candidata: `.atena/generated/art-candidates/hq/hq_n03_q4_v01.png` · texto proposto na UI: Helion se tornou o Véu Vivo. “Continuem protegendo Nottgard.”

```text
A gigantic tree has grown where the seed was planted, its trunk enormous and its roots spreading across the ground and over the city walls, forming a living hedge of blue and gold arcane energy that turns the green fog into clear air. Three adventurers stand small in front of the trunk, looking up, and through the parting fog above them a sky of stars is visible for the first time. Wide low-angle shot from behind the three figures, the tree filling the frame, stars in the upper third, blue-gold light on the roots, remnants of green fog at the ground. Dark-fantasy illustration with dense pixel-art finish and controlled dithering, crisp pixel edges, no smooth painterly blur, wide 16:9 landscape composition. No text, no letters, no speech bubbles, no captions, no logo, no watermark, no frame or border, no UI. Keep the bottom third of the image visually calm and uncluttered. Nothing important is cropped by the edges. The named characters must match the attached reference portraits exactly; any other figure is an anonymous silhouette.
```

### HQN-04 — O Palácio de Zuggtmoy

Gatilho: Vencer Shedaklah (chefe Zuggtmoy). Proibido/cuidado: Zuggtmoy deve estar VIVA, sem cadáver nem troféu (RESEARCH-001). A aparência dela é proposta de arte, não canon; nada de sexualização.

#### H09 — `hq_n04_q1` · Recapitular · sem anexos

- [ ] gerada · [ ] aprovada · candidata: `.atena/generated/art-candidates/hq/hq_n04_q1_v01.png` · texto proposto na UI: Shedaklah, andar 222: fungo de um lado, slime do outro.

```text
A vast fungal swamp under a dark cavern sky, with towering mushrooms in brown and violet with pink spore caps, glowing motes drifting in the air, and a winding stone path leading toward a distant palace that seems to have grown out of mycelium and stone. On the far right of the frame the ground turns into shining viscous slime. Very wide establishing shot, high vantage point, the palace small in the distance, violet spore light, wet reflections on the path. Dark-fantasy illustration with dense pixel-art finish and controlled dithering, crisp pixel edges, no smooth painterly blur, wide 16:9 landscape composition. No text, no letters, no speech bubbles, no captions, no logo, no watermark, no frame or border, no UI. Keep the bottom third of the image visually calm and uncluttered. Nothing important is cropped by the edges. No named characters in this image; any figures are anonymous silhouettes.
```

#### H10 — `hq_n04_q2` · Virar · anexar: `korrak.png`, `leoric.png`, `kayron.png`

- [ ] gerada · [ ] aprovada · candidata: `.atena/generated/art-candidates/hq/hq_n04_q2_v01.png` · texto proposto na UI: O Rio Estige parou. Algo o solidificou.

```text
A wide river of souls has turned into a motionless gelatin, its surface a pale translucent blue with faint ghostly shapes trapped inside, stretching across the swamp. Three adventurers stand on the bank looking at it, and a small dark canoe waits at the edge. Wide shot from the bank, the frozen river as the main shape, the party in silhouette at one side, cold blue glow from the river against violet spore light. Dark-fantasy illustration with dense pixel-art finish and controlled dithering, crisp pixel edges, no smooth painterly blur, wide 16:9 landscape composition. No text, no letters, no speech bubbles, no captions, no logo, no watermark, no frame or border, no UI. Keep the bottom third of the image visually calm and uncluttered. Nothing important is cropped by the edges. The named characters must match the attached reference portraits exactly; any other figure is an anonymous silhouette.
```

#### H11 — `hq_n04_q3` · Apresentar · anexar: `kayron.png`, `brook.png`

- [ ] gerada · [ ] aprovada · candidata: `.atena/generated/art-candidates/hq/hq_n04_q3_v01.png` · texto proposto na UI: Zuggtmoy oferece um mapa em troca de conter Juiblex.

```text
A throne hall made of living fungus and pale stone, where a regal, graceful sovereign with fungal crown and robes of woven mycelium sits calmly on a throne, holding out a rolled map. Orderly rows of human and half-orc soldiers stand at attention along the walls, loyal by choice, not chained. Two adventurers stand before the throne, listening. Medium-wide shot along the length of the hall toward the throne, symmetrical composition, violet light from glowing mushrooms, warm amber torches on the soldiers, the sovereign dignified and not monstrous. Dark-fantasy illustration with dense pixel-art finish and controlled dithering, crisp pixel edges, no smooth painterly blur, wide 16:9 landscape composition. No text, no letters, no speech bubbles, no captions, no logo, no watermark, no frame or border, no UI. Keep the bottom third of the image visually calm and uncluttered. Nothing important is cropped by the edges. The named characters must match the attached reference portraits exactly; any other figure is an anonymous silhouette.
```

#### H12 — `hq_n04_q4` · Dar gancho · anexar: `korrak.png`, `leoric.png`, `brook.png`

- [ ] gerada · [ ] aprovada · candidata: `.atena/generated/art-candidates/hq/hq_n04_q4_v01.png` · texto proposto na UI: Adiante, o território de Juiblex.

```text
Three adventurers walk toward a border where the ground turns into wet green-black slime with big bubbles, some about to burst. Ahead, a half-finished humanoid bas-relief is carved into the slime, still incomplete. Wide low shot from behind the three figures, the slime border as the destination, the half-finished relief as a small landmark, cold green light, a hint of violet at the edges. Dark-fantasy illustration with dense pixel-art finish and controlled dithering, crisp pixel edges, no smooth painterly blur, wide 16:9 landscape composition. No text, no letters, no speech bubbles, no captions, no logo, no watermark, no frame or border, no UI. Keep the bottom third of the image visually calm and uncluttered. Nothing important is cropped by the edges. The named characters must match the attached reference portraits exactly; any other figure is an anonymous silhouette.
```

### HQN-05 — O Núcleo Verde

Gatilho: Vencer Molor (chefe Blogbog). Proibido/cuidado: Aparência de Blogbog é proposta de arte; nada de gore.

#### H13 — `hq_n05_q1` · Recapitular · anexar: `brook.png`, `leoric.png`, `korrak.png`

- [ ] gerada · [ ] aprovada · candidata: `.atena/generated/art-candidates/hq/hq_n05_q1_v01.png` · texto proposto na UI: O portal roxo levou mais fundo.

```text
An ancient stone arch with no opening slowly lights up with runes and a swirling purple portal opens inside it, surrounded by mushrooms and slime, while three adventurers step toward it. Medium-wide shot from behind the three figures, the portal as the light source, purple glow on wet stone, green slime glints at the sides. Dark-fantasy illustration with dense pixel-art finish and controlled dithering, crisp pixel edges, no smooth painterly blur, wide 16:9 landscape composition. No text, no letters, no speech bubbles, no captions, no logo, no watermark, no frame or border, no UI. Keep the bottom third of the image visually calm and uncluttered. Nothing important is cropped by the edges. The named characters must match the attached reference portraits exactly; any other figure is an anonymous silhouette.
```

#### H14 — `hq_n05_q2` · Virar · sem anexos

- [ ] gerada · [ ] aprovada · candidata: `.atena/generated/art-candidates/hq/hq_n05_q2_v01.png` · texto proposto na UI: Molor, andar 528: bolhas que crescem e explodem.

```text
A closed cavern whose floor, walls and ceiling are covered with glossy green-black slime and enormous bubbles in different sizes, some swelling, some bursting into fine spray. Faint tiny figures of adventurers cross a narrow ridge in the middle of the cave. Very wide shot, the cavern seen from one end, the tiny party as scale, sickly green light from the bubbles, wet highlights, dark rock. Dark-fantasy illustration with dense pixel-art finish and controlled dithering, crisp pixel edges, no smooth painterly blur, wide 16:9 landscape composition. No text, no letters, no speech bubbles, no captions, no logo, no watermark, no frame or border, no UI. Keep the bottom third of the image visually calm and uncluttered. Nothing important is cropped by the edges. No named characters in this image; any figures are anonymous silhouettes.
```

#### H15 — `hq_n05_q3` · Apresentar · anexar: `brook.png`, `korrak.png`

- [ ] gerada · [ ] aprovada · candidata: `.atena/generated/art-candidates/hq/hq_n05_q3_v01.png` · texto proposto na UI: O chefe de Molor caiu.

```text
A huge shapeless mass of slime and fungus rears up in the cave, its body dissolving and spraying acid in a wide arc, while a paladin raises a glowing hammer of golden light that cuts across the slime and a large goliath warrior swings an axe beside him. The burst of golden light is the brightest thing in the frame. Medium-wide low-angle shot, the monster towering, the golden hammer light as the focus, green acid spray in the air, dark cavern around. Dark-fantasy illustration with dense pixel-art finish and controlled dithering, crisp pixel edges, no smooth painterly blur, wide 16:9 landscape composition. No text, no letters, no speech bubbles, no captions, no logo, no watermark, no frame or border, no UI. Keep the bottom third of the image visually calm and uncluttered. Nothing important is cropped by the edges. The named characters must match the attached reference portraits exactly; any other figure is an anonymous silhouette.
```

#### H16 — `hq_n05_q4` · Dar gancho · anexar: `leoric.png`

- [ ] gerada · [ ] aprovada · candidata: `.atena/generated/art-candidates/hq/hq_n05_q4_v01.png` · texto proposto na UI: Dentro dele, um núcleo verde ainda pulsava. Era parte de Juiblex.

```text
In the remains of the dissolved creature a small green core still pulses and twists on the ground, glowing from within, while a small gnome adventurer crouches to look at it. Far behind them, a thin pale-blue river of souls begins to flow again in the dark. Close low-angle shot of the pulsing core in the foreground, the gnome to one side, the faint blue river in the far background, green light against dark stone. Dark-fantasy illustration with dense pixel-art finish and controlled dithering, crisp pixel edges, no smooth painterly blur, wide 16:9 landscape composition. No text, no letters, no speech bubbles, no captions, no logo, no watermark, no frame or border, no UI. Keep the bottom third of the image visually calm and uncluttered. Nothing important is cropped by the edges. The named characters must match the attached reference portraits exactly; any other figure is an anonymous silhouette.
```

### HQN-06 — A Jaula de Durão

Gatilho: Vencer Durão (desbloqueia Korrak). Proibido/cuidado: O prisioneiro Vhaerith aparece sem mutilação. Não mostrar a morte dos desertores. Aparência dos Molydeus e de Xar'gath é proposta de arte.

#### H17 — `hq_n06_q1` · Recapitular · sem anexos

- [ ] gerada · [ ] aprovada · candidata: `.atena/generated/art-candidates/hq/hq_n06_q1_v01.png` · texto proposto na UI: Durão, andar 274: uma guerra sem fim que terminou sem vencedor.

```text
An arid wasteland of black basalt and dead vegetation, abandoned war camps with torn tents and broken carts, and a river of souls partly turned to gelatin winding through the middle, glowing with a pale ghostly blue. Very wide shot from a low ridge, empty and silent, rust-red dust in the air, the blue river as the only light. Dark-fantasy illustration with dense pixel-art finish and controlled dithering, crisp pixel edges, no smooth painterly blur, wide 16:9 landscape composition. No text, no letters, no speech bubbles, no captions, no logo, no watermark, no frame or border, no UI. Keep the bottom third of the image visually calm and uncluttered. Nothing important is cropped by the edges. No named characters in this image; any figures are anonymous silhouettes.
```

#### H18 — `hq_n06_q2` · Virar · sem anexos

- [ ] gerada · [ ] aprovada · candidata: `.atena/generated/art-candidates/hq/hq_n06_q2_v01.png` · texto proposto na UI: Três carcereiros vigiam quem tenta fugir.

```text
A tall winged demonic jailer with a menacing, inhuman silhouette flies low over the dead landscape, followed at a distance by two others, patrolling above a group of tiny fleeing silhouettes below. The jailer is armored in rust-colored iron and has a long tail. Low-angle wide shot looking up at the flying jailer, the fleeing silhouettes small below, rust-red sky, blue glow from the river. Dark-fantasy illustration with dense pixel-art finish and controlled dithering, crisp pixel edges, no smooth painterly blur, wide 16:9 landscape composition. No text, no letters, no speech bubbles, no captions, no logo, no watermark, no frame or border, no UI. Keep the bottom third of the image visually calm and uncluttered. Nothing important is cropped by the edges. No named characters in this image; any figures are anonymous silhouettes.
```

#### H19 — `hq_n06_q3` · Apresentar · anexar: `korrak.png`

- [ ] gerada · [ ] aprovada · candidata: `.atena/generated/art-candidates/hq/hq_n06_q3_v01.png` · texto proposto na UI: Korrak empunha o machado de Xar'gath. Ele cobra uma provação.

```text
A large goliath warrior stands in a circular arena of fire, gripping a huge infernal battle axe with a small glowing eye set in the blade, and facing a tall horned demon silhouette across a pool of dark liquid. The fire draws a perfect circle around them. Medium-wide low-angle shot, the goliath in the foreground, the demon framed by flames across from him, orange and red firelight, deep shadow above. Dark-fantasy illustration with dense pixel-art finish and controlled dithering, crisp pixel edges, no smooth painterly blur, wide 16:9 landscape composition. No text, no letters, no speech bubbles, no captions, no logo, no watermark, no frame or border, no UI. Keep the bottom third of the image visually calm and uncluttered. Nothing important is cropped by the edges. The named characters must match the attached reference portraits exactly; any other figure is an anonymous silhouette.
```

#### H20 — `hq_n06_q4` · Dar gancho · anexar: `brook.png`, `kayron.png`

- [ ] gerada · [ ] aprovada · candidata: `.atena/generated/art-candidates/hq/hq_n06_q4_v01.png` · texto proposto na UI: Na jaula, um elfo oferece o próprio sangue em troca de uma runa.

```text
An immense iron cage stands at the end of the dead landscape, filled with the dim silhouettes of prisoners. At the bars a thin elf with an aged scholar's look holds out his open hand toward two adventurers, while a stone portal frame with no opening waits in front of the cage. Wide shot from the adventurers' side, the cage looming, the elf and the portal frame as the center, cold blue glow, rust dust, oppressive sky. Dark-fantasy illustration with dense pixel-art finish and controlled dithering, crisp pixel edges, no smooth painterly blur, wide 16:9 landscape composition. No text, no letters, no speech bubbles, no captions, no logo, no watermark, no frame or border, no UI. Keep the bottom third of the image visually calm and uncluttered. Nothing important is cropped by the edges. The named characters must match the attached reference portraits exactly; any other figure is an anonymous silhouette.
```

## Onda 2 — HQN-07 a HQN-14 (H21–H52)

Origem: [[ART-PROMPTS-029-hqs-onda-2]].

### HQN-07 — A Peregrinação da Estrela

Gatilho: Vencer Feng-tu (chefe Lu Yueh). Proibido/cuidado: Sem estética oriental genérica; a Tou Um nunca aparece em corpo (só a estrela); sem massacre dos fiéis em detalhe.

#### H21 — `hq_n07_q1` · Recapitular · sem anexos

- [ ] gerada · [ ] aprovada · candidata: `.atena/generated/art-candidates/hq/hq_n07_q1_v01.png` · texto proposto na UI: Feng-tu, andar 300: Tou Um e Lu Yueh disputam o andar.

```text
A layered landscape of a flooded dark valley with cherry trees, wooden bridges, bamboo groves and snowy mountains, where a slate-blue temple stands on a terrace with its upper floor open and its wooden pillars stained by sickly green plague. A river of gelatin runs through the middle. Very wide establishing shot, misty, the temple as the small focal point, cold blue-slate palette, green pestilence in the fog, a single bright northern star above. Dark-fantasy illustration with dense pixel-art finish and controlled dithering, crisp pixel edges, no smooth painterly blur, wide 16:9 landscape composition. No text, no letters, no speech bubbles, no captions, no logo, no watermark, no frame or border, no UI. Keep the bottom third of the image visually calm and uncluttered. Nothing important is cropped by the edges. No named characters in this image; any figures are anonymous silhouettes.
```

#### H22 — `hq_n07_q2` · Virar · anexar: `leoric.png`, `kayron.png`, `korrak.png`

- [ ] gerada · [ ] aprovada · candidata: `.atena/generated/art-candidates/hq/hq_n07_q2_v01.png` · texto proposto na UI: O Discípulo Pestilento e suas larvas.

```text
Inside the open temple, a masked plague priest raises both arms as a huge cloud of toxic green mist spreads across the floor, while small maggot-like creatures with human faces burst into puffs of pestilence around him. A gnome in a starry form fires glowing arrows, a winged figure teleports in with a flash of lightning, and a large goliath hurls an axe. Dynamic medium-wide shot, the toxic cloud rolling toward the camera, bright star-light and lightning cutting through the green, temple pillars framing the scene. Dark-fantasy illustration with dense pixel-art finish and controlled dithering, crisp pixel edges, no smooth painterly blur, wide 16:9 landscape composition. No text, no letters, no speech bubbles, no captions, no logo, no watermark, no frame or border, no UI. Keep the bottom third of the image visually calm and uncluttered. Nothing important is cropped by the edges. The named characters must match the attached reference portraits exactly; any other figure is an anonymous silhouette.
```

#### H23 — `hq_n07_q3` · Apresentar · anexar: `brook.png`

- [ ] gerada · [ ] aprovada · candidata: `.atena/generated/art-candidates/hq/hq_n07_q3_v01.png` · texto proposto na UI: Só quem segue a estrela é curado.

```text
A frail human pilgrim in plain robes points toward a single brilliant star over misty mountains, while a sick, exhausted armored paladin leans on a companion's shoulder beside him. The pilgrim's face is calm and full of faith. Medium shot from behind and to the side, the pilgrim's arm leading the eye to the star, cold blue light on the group, faint green sickness in the paladin's skin. Dark-fantasy illustration with dense pixel-art finish and controlled dithering, crisp pixel edges, no smooth painterly blur, wide 16:9 landscape composition. No text, no letters, no speech bubbles, no captions, no logo, no watermark, no frame or border, no UI. Keep the bottom third of the image visually calm and uncluttered. Nothing important is cropped by the edges. The named characters must match the attached reference portraits exactly; any other figure is an anonymous silhouette.
```

#### H24 — `hq_n07_q4` · Dar gancho · anexar: `brook.png`, `kayron.png`

- [ ] gerada · [ ] aprovada · candidata: `.atena/generated/art-candidates/hq/hq_n07_q4_v01.png` · texto proposto na UI: Oito dias de caminhada. A estrela nunca se aproxima. Eles se curaram.

```text
A long line of small travelers walks across a misty plain and a winding path toward a single bright star that hangs above the horizon and never gets closer. A faint clean glow surrounds them and the green sickness fades from the air behind them. Extreme wide shot from behind, the line of figures small, the star large and constant, deep blue mist, a soft clear glow following the group. Dark-fantasy illustration with dense pixel-art finish and controlled dithering, crisp pixel edges, no smooth painterly blur, wide 16:9 landscape composition. No text, no letters, no speech bubbles, no captions, no logo, no watermark, no frame or border, no UI. Keep the bottom third of the image visually calm and uncluttered. Nothing important is cropped by the edges. The named characters must match the attached reference portraits exactly; any other figure is an anonymous silhouette.
```

### HQN-08 — O Chifre de Malcanthet

Gatilho: Vencer Shendilavri (chefe Malcanthet). Proibido/cuidado: Malcanthet VIVA, sem cadáver ou troféu (RESEARCH-001); nada de cenas de orgia ou escravidão explícitas; sem sexualização. Aparência de Malcanthet e Graz'zt é proposta de arte.

#### H25 — `hq_n08_q1` · Recapitular · sem anexos

- [ ] gerada · [ ] aprovada · candidata: `.atena/generated/art-candidates/hq/hq_n08_q1_v01.png` · texto proposto na UI: Rivenheart: luxo, ilusão e correntes.

```text
A walled coastal city on a hillside above an ocean under a permanent sunset, with a grand gate guarded by fiends, elegant towers in wine and black stone, and a slow procession of chained silhouettes in the streets. Beneath the beauty, subtle uncanny shimmer suggests that most of what is seen is illusion. Wide establishing shot from a hill, sunset light in deep red-orange and magenta on the sea, the city glittering, shadowed foreground. Dark-fantasy illustration with dense pixel-art finish and controlled dithering, crisp pixel edges, no smooth painterly blur, wide 16:9 landscape composition. No text, no letters, no speech bubbles, no captions, no logo, no watermark, no frame or border, no UI. Keep the bottom third of the image visually calm and uncluttered. Nothing important is cropped by the edges. No named characters in this image; any figures are anonymous silhouettes.
```

#### H26 — `hq_n08_q2` · Virar · anexar: `sylas.png`, `brook.png`

- [ ] gerada · [ ] aprovada · candidata: `.atena/generated/art-candidates/hq/hq_n08_q2_v01.png` · texto proposto na UI: Malcanthet quer o Espelho de volta. Em segredo.

```text
A sumptuous throne hall in polished black and deep-wine stone with silver inlay, where a regal winged queen sits on the throne, elegant, stern, dressed in dark wine and gold, her face partly in shadow. Two disguised adventurers stand before her, one speaking calmly while the other watches, and two radiant armored warrior women wait at her sides. Medium-wide shot toward the throne, dramatic depth, warm candle light against a cold silver shimmer, the queen at the vertical center. Dark-fantasy illustration with dense pixel-art finish and controlled dithering, crisp pixel edges, no smooth painterly blur, wide 16:9 landscape composition. No text, no letters, no speech bubbles, no captions, no logo, no watermark, no frame or border, no UI. Keep the bottom third of the image visually calm and uncluttered. Nothing important is cropped by the edges. The named characters must match the attached reference portraits exactly; any other figure is an anonymous silhouette.
```

#### H27 — `hq_n08_q3` · Apresentar · anexar: `kayron.png`, `sylas.png`

- [ ] gerada · [ ] aprovada · candidata: `.atena/generated/art-candidates/hq/hq_n08_q3_v01.png` · texto proposto na UI: Sete notas, sete runas. A parede se abriu.

```text
A silent music room with seven small tables each carrying a glowing carved rune and a musical instrument, arranged in a row before a secret stone wall that is sliding open to reveal a pedestal holding an ornate mirror with a silver frame. A soft silver light pours out of the opening. Two adventurers watch from the room. Medium-wide shot, the tables in the foreground, the opening wall and the mirror as the destination, silver and cold blue light, amber accents on the instruments. Dark-fantasy illustration with dense pixel-art finish and controlled dithering, crisp pixel edges, no smooth painterly blur, wide 16:9 landscape composition. No text, no letters, no speech bubbles, no captions, no logo, no watermark, no frame or border, no UI. Keep the bottom third of the image visually calm and uncluttered. Nothing important is cropped by the edges. The named characters must match the attached reference portraits exactly; any other figure is an anonymous silhouette.
```

#### H28 — `hq_n08_q4` · Dar gancho · sem anexos

- [ ] gerada · [ ] aprovada · candidata: `.atena/generated/art-candidates/hq/hq_n08_q4_v01.png` · texto proposto na UI: Graz'zt arrancou o chifre de Malcanthet e declarou guerra.

```text
Two demon lords face each other in a grand hall, one tall, dark and regal in black armor with a triumphant posture, the other winged and furious, one of her curved horns missing. The tall lord hurls a broken curved horn into a glowing portal on the floor between them. Dramatic low-angle wide shot, the two lords as opposing silhouettes, the portal glow lighting the horn in mid-air, deep red and silver light, tiny adventurers at the edge of the frame. Dark-fantasy illustration with dense pixel-art finish and controlled dithering, crisp pixel edges, no smooth painterly blur, wide 16:9 landscape composition. No text, no letters, no speech bubbles, no captions, no logo, no watermark, no frame or border, no UI. Keep the bottom third of the image visually calm and uncluttered. Nothing important is cropped by the edges. No named characters in this image; any figures are anonymous silhouettes.
```

### HQN-09 — O Paraíso que Era Ilusão

Gatilho: Vencer Goranthis (chefe Socothbenoth). Proibido/cuidado: Nada de rostos nas paredes de carne, sem gore; Juiblex cai no vault, mas o chefe no jogo é Socothbenoth (a HQ mostra o palácio, não a luta).

#### H29 — `hq_n09_q1` · Recapitular · sem anexos

- [ ] gerada · [ ] aprovada · candidata: `.atena/generated/art-candidates/hq/hq_n09_q1_v01.png` · texto proposto na UI: Goranthis, camada 597: o verdadeiro Paraíso.

```text
An enormous white waterfall pours down a cliff beside a graceful marble palace covered with gold trim and pale aqua-green moss, with a wide river flowing normally at its foot. Soft light, elegant gardens and a sense of peace, almost too perfect. Very wide establishing shot with an upward tilt along the waterfall, soft ivory and gold light with a faint aqua tint, small white flowers in the foreground. Dark-fantasy illustration with dense pixel-art finish and controlled dithering, crisp pixel edges, no smooth painterly blur, wide 16:9 landscape composition. No text, no letters, no speech bubbles, no captions, no logo, no watermark, no frame or border, no UI. Keep the bottom third of the image visually calm and uncluttered. Nothing important is cropped by the edges. No named characters in this image; any figures are anonymous silhouettes.
```

#### H30 — `hq_n09_q2` · Virar · anexar: `kayron.png`, `sylas.png`, `korrak.png`

- [ ] gerada · [ ] aprovada · candidata: `.atena/generated/art-candidates/hq/hq_n09_q2_v01.png` · texto proposto na UI: Comida, bebida e festa, tudo de graça. Tudo ilusão.

```text
A lavish banquet hall with long tables piled with food and wine, golden light and elegant guests without guards, where three adventurers walk through the crowd. The guests are slightly wrong, with faint shimmer and no shadows, and the walls glitter oddly. Medium-wide shot at eye level, warm golden light, a subtle cold shimmer at the edges of the frame, the party in the middle of the crowd. Dark-fantasy illustration with dense pixel-art finish and controlled dithering, crisp pixel edges, no smooth painterly blur, wide 16:9 landscape composition. No text, no letters, no speech bubbles, no captions, no logo, no watermark, no frame or border, no UI. Keep the bottom third of the image visually calm and uncluttered. Nothing important is cropped by the edges. The named characters must match the attached reference portraits exactly; any other figure is an anonymous silhouette.
```

#### H31 — `hq_n09_q3` · Apresentar · anexar: `brook.png`, `kayron.png`

- [ ] gerada · [ ] aprovada · candidata: `.atena/generated/art-candidates/hq/hq_n09_q3_v01.png` · texto proposto na UI: Tirado do trono, o palácio revelou o que era: carne.

```text
The same great hall, now stripped of its illusion: the walls and ceiling are made of wet pink-gray organic tissue that seems to breathe, dark tar-like slime spreads along the ceiling, and an ornate throne stands empty in the middle of the room. Two adventurers look up in silence. Wide shot from behind the two figures, the empty throne as the center, cold sickly light, no faces or figures in the walls. Dark-fantasy illustration with dense pixel-art finish and controlled dithering, crisp pixel edges, no smooth painterly blur, wide 16:9 landscape composition. No text, no letters, no speech bubbles, no captions, no logo, no watermark, no frame or border, no UI. Keep the bottom third of the image visually calm and uncluttered. Nothing important is cropped by the edges. The named characters must match the attached reference portraits exactly; any other figure is an anonymous silhouette.
```

#### H32 — `hq_n09_q4` · Dar gancho · anexar: `kayron.png`, `sylas.png`, `brook.png`, `korrak.png`

- [ ] gerada · [ ] aprovada · candidata: `.atena/generated/art-candidates/hq/hq_n09_q4_v01.png` · texto proposto na UI: O Estige voltou a correr. O grupo voltou para casa.

```text
A glowing river of souls flows freely again through a dark landscape, and four adventurers stand at a portal made of red-golden hammer light. Behind them the once beautiful landscape lies dead, with withered plants and no living creature. Wide shot from behind, the river's blue glow and the golden-red portal light as contrast, the dead landscape in gray, a sense of relief and loss. Dark-fantasy illustration with dense pixel-art finish and controlled dithering, crisp pixel edges, no smooth painterly blur, wide 16:9 landscape composition. No text, no letters, no speech bubbles, no captions, no logo, no watermark, no frame or border, no UI. Keep the bottom third of the image visually calm and uncluttered. Nothing important is cropped by the edges. The named characters must match the attached reference portraits exactly; any other figure is an anonymous silhouette.
```

### HQN-10 — A Síntese Abissal

Gatilho: Vencer Os Pilares (Síntese Abissal). Proibido/cuidado: Spoiler pesado (D-N2): não revelar o segredo do mestre; nada de tortura em detalhe (a figura acorrentada aparece adormecida, sem chicote); ninguém morre.

#### H33 — `hq_n10_q1` · Recapitular · anexar: `maelor.png`, `kayron.png`, `brook.png`, `sylas.png`

- [ ] gerada · [ ] aprovada · candidata: `.atena/generated/art-candidates/hq/hq_n10_q1_v01.png` · texto proposto na UI: O Castelo da Fome, cercado de fogo azul.

```text
Four adventurers at the foot of a hill look up at a castle with four pointed towers surrounded by blue flames, its stone rotten and stained. Above its arched door, two carved lines can be seen as abstract marks, one scratched out. Low-angle wide shot from behind the party, the castle looming, blue fire lighting the stone, dark sky, green fog swirling at the base of the hill. Dark-fantasy illustration with dense pixel-art finish and controlled dithering, crisp pixel edges, no smooth painterly blur, wide 16:9 landscape composition. No text, no letters, no speech bubbles, no captions, no logo, no watermark, no frame or border, no UI. Keep the bottom third of the image visually calm and uncluttered. Nothing important is cropped by the edges. The named characters must match the attached reference portraits exactly; any other figure is an anonymous silhouette.
```

#### H34 — `hq_n10_q2` · Virar · anexar: `maelor.png`

- [ ] gerada · [ ] aprovada · candidata: `.atena/generated/art-candidates/hq/hq_n10_q2_v01.png` · texto proposto na UI: “Quando a lamparina apagar...”

```text
In the last room of a long corridor, a young winged woman hangs asleep in chains by her arms, pale and exhausted, glowing softly, while robed figures chant in unison around her in silhouette. A single oil lamp near her flickers, almost out. A man watches from the shadows, and a dim figure of a dark-armored warrior stands beside him. Medium-wide shot from the corridor entrance, the flickering lamp at the center, one adventurer's hand in the foreground, cold blue fire and green shadow, the winged figure the only warm light. Dark-fantasy illustration with dense pixel-art finish and controlled dithering, crisp pixel edges, no smooth painterly blur, wide 16:9 landscape composition. No text, no letters, no speech bubbles, no captions, no logo, no watermark, no frame or border, no UI. Keep the bottom third of the image visually calm and uncluttered. Nothing important is cropped by the edges. The named characters must match the attached reference portraits exactly; any other figure is an anonymous silhouette.
```

#### H35 — `hq_n10_q3` · Apresentar · anexar: `kayron.png`, `brook.png`, `sylas.png`

- [ ] gerada · [ ] aprovada · candidata: `.atena/generated/art-candidates/hq/hq_n10_q3_v01.png` · texto proposto na UI: A Síntese Abissal.

```text
A towering armored aberration made of black slime and dark plate armor, with one huge hand glowing green, rises in a wide hall while the floor breaks and glowing runes light up along the walls. Three small adventurers face it, one with a radiant weapon raised. Low-angle wide shot, the monster towering, radiant light from the adventurers cutting the dark, green rune light and blue flames, heavy dust in the air. Dark-fantasy illustration with dense pixel-art finish and controlled dithering, crisp pixel edges, no smooth painterly blur, wide 16:9 landscape composition. No text, no letters, no speech bubbles, no captions, no logo, no watermark, no frame or border, no UI. Keep the bottom third of the image visually calm and uncluttered. Nothing important is cropped by the edges. The named characters must match the attached reference portraits exactly; any other figure is an anonymous silhouette.
```

#### H36 — `hq_n10_q4` · Dar gancho · anexar: `maelor.png`, `kayron.png`

- [ ] gerada · [ ] aprovada · candidata: `.atena/generated/art-candidates/hq/hq_n10_q4_v01.png` · texto proposto na UI: A névoa acabou. Mas os pilares no horizonte ainda estendem as mãos.

```text
A clear starry night sky above the ruins of a crushed castle, with no fog anywhere, while in the far distance at the horizon several colossal stone pillars rise from earth to sky, each ending in a giant reaching stone hand. Two adventurers look at them, small against the horizon. Extreme wide shot from behind the two figures, stars filling the upper half, the pillars at the horizon in violet-black stone, the warm light of a distant city on one side. Dark-fantasy illustration with dense pixel-art finish and controlled dithering, crisp pixel edges, no smooth painterly blur, wide 16:9 landscape composition. No text, no letters, no speech bubbles, no captions, no logo, no watermark, no frame or border, no UI. Keep the bottom third of the image visually calm and uncluttered. Nothing important is cropped by the edges. The named characters must match the attached reference portraits exactly; any other figure is an anonymous silhouette.
```

### HQN-11 — A Concórdia Eterna

Gatilho: Conquista Caçador de Chefes (desbloqueia Bromnor). Proibido/cuidado: Sem violência mostrada; o massacre aparece só como clarão e silhueta; nada de quem o matou (está em disputa no vault).

#### H37 — `hq_n11_q1` · Recapitular · sem anexos

- [ ] gerada · [ ] aprovada · candidata: `.atena/generated/art-candidates/hq/hq_n11_q1_v01.png` · texto proposto na UI: Fateridge. Guardas Celestiais contra a população.

```text
A dark medieval city square at night in a state of panic, with winged armored guards in gleaming plate confronting crowds of frightened silhouetted townspeople, torn banners, overturned carts and broken lanterns. No blood and no wounds, only tension. Wide high-angle shot, the crowd swirling, cold torch light and long shadows, small red accents on the banners. Dark-fantasy illustration with dense pixel-art finish and controlled dithering, crisp pixel edges, no smooth painterly blur, wide 16:9 landscape composition. No text, no letters, no speech bubbles, no captions, no logo, no watermark, no frame or border, no UI. Keep the bottom third of the image visually calm and uncluttered. Nothing important is cropped by the edges. No named characters in this image; any figures are anonymous silhouettes.
```

#### H38 — `hq_n11_q2` · Virar · anexar: `bromnor.png`

- [ ] gerada · [ ] aprovada · candidata: `.atena/generated/art-candidates/hq/hq_n11_q2_v01.png` · texto proposto na UI: Bromnor sai ferido da forja.

```text
A stout dwarf in worn plate armor steps through the door of a farm-tool forge, wounded and leaning on the frame, his gaze fixed on the chaos in the street. The forge glows orange behind him. Medium shot at the door, the dwarf lit from behind by the forge, cold night light on his face. Dark-fantasy illustration with dense pixel-art finish and controlled dithering, crisp pixel edges, no smooth painterly blur, wide 16:9 landscape composition. No text, no letters, no speech bubbles, no captions, no logo, no watermark, no frame or border, no UI. Keep the bottom third of the image visually calm and uncluttered. Nothing important is cropped by the edges. The named characters must match the attached reference portraits exactly; any other figure is an anonymous silhouette.
```

#### H39 — `hq_n11_q3` · Apresentar · anexar: `bromnor.png`

- [ ] gerada · [ ] aprovada · candidata: `.atena/generated/art-candidates/hq/hq_n11_q3_v01.png` · texto proposto na UI: A Aurora da Concórdia Eterna.

```text
The dwarf raises both arms and a wave of pure gold and silver light bursts from him across the whole square, making swords, spears and torches fall from the hands of everyone around him, leaving crowds and guards suddenly still. Wide low-angle shot, the burst of golden-silver light as the brightest element, the dwarf small at the center, weapons falling in the air, silhouettes frozen. Dark-fantasy illustration with dense pixel-art finish and controlled dithering, crisp pixel edges, no smooth painterly blur, wide 16:9 landscape composition. No text, no letters, no speech bubbles, no captions, no logo, no watermark, no frame or border, no UI. Keep the bottom third of the image visually calm and uncluttered. Nothing important is cropped by the edges. The named characters must match the attached reference portraits exactly; any other figure is an anonymous silhouette.
```

#### H40 — `hq_n11_q4` · Dar gancho · anexar: `bromnor.png`, `brook.png`

- [ ] gerada · [ ] aprovada · candidata: `.atena/generated/art-candidates/hq/hq_n11_q4_v01.png` · texto proposto na UI: Bromnor virou luz.

```text
The dwarf's body dissolves into hundreds of golden particles that rise into the night air, while in the foreground a young paladin watches this memory with his hand outstretched, as if seeing it through another's eyes. Medium shot from behind the paladin, the golden particles rising, soft gold on dark blue, calm and sad. Dark-fantasy illustration with dense pixel-art finish and controlled dithering, crisp pixel edges, no smooth painterly blur, wide 16:9 landscape composition. No text, no letters, no speech bubbles, no captions, no logo, no watermark, no frame or border, no UI. Keep the bottom third of the image visually calm and uncluttered. Nothing important is cropped by the edges. The named characters must match the attached reference portraits exactly; any other figure is an anonymous silhouette.
```

### HQN-12 — O Nome Aluris

Gatilho: Conquista Aluris (desbloqueia Leoric). Proibido/cuidado: O Cerco de Aluris é da HQN-13 e Helion pediu segredo; aqui ninguém na multidão sabe o significado do nome. Gilly e Hrothgar não têm descrição no vault: aparecem de longe ou por silhueta, e são proposta de arte.

#### H41 — `hq_n12_q1` · Recapitular · sem anexos

- [ ] gerada · [ ] aprovada · candidata: `.atena/generated/art-candidates/hq/hq_n12_q1_v01.png` · texto proposto na UI: A ponte foi reaberta. A cidade respirava de novo.

```text
A wide stone bridge between two cities, freshly reopened, decorated with banners and lanterns and crowded with cheerful townspeople of all races, under a night sky with a soft green tint that is thinner than usual. The mood is warm and hopeful. Wide shot along the length of the bridge, warm amber lantern light, thin fog, blue glow of the barrier in the distance. Dark-fantasy illustration with dense pixel-art finish and controlled dithering, crisp pixel edges, no smooth painterly blur, wide 16:9 landscape composition. No text, no letters, no speech bubbles, no captions, no logo, no watermark, no frame or border, no UI. Keep the bottom third of the image visually calm and uncluttered. Nothing important is cropped by the edges. No named characters in this image; any figures are anonymous silhouettes.
```

#### H42 — `hq_n12_q2` · Virar · anexar: `kayron.png`, `sylas.png`, `maelor.png`, `brook.png`

- [ ] gerada · [ ] aprovada · candidata: `.atena/generated/art-candidates/hq/hq_n12_q2_v01.png` · texto proposto na UI: Gilly pediu um nome. Para a ponte e para eles.

```text
A stage at the middle of the bridge with a small council official addressing the crowd, while four adventurers stand together on the stage and look at each other in silence. The crowd is a blur of faces and hands, applauding. Medium-wide shot from the crowd looking up at the stage, warm stage light on the party, the crowd in dark silhouettes in the foreground. Dark-fantasy illustration with dense pixel-art finish and controlled dithering, crisp pixel edges, no smooth painterly blur, wide 16:9 landscape composition. No text, no letters, no speech bubbles, no captions, no logo, no watermark, no frame or border, no UI. Keep the bottom third of the image visually calm and uncluttered. Nothing important is cropped by the edges. The named characters must match the attached reference portraits exactly; any other figure is an anonymous silhouette.
```

#### H43 — `hq_n12_q3` · Apresentar · anexar: `kayron.png`

- [ ] gerada · [ ] aprovada · candidata: `.atena/generated/art-candidates/hq/hq_n12_q3_v01.png` · texto proposto na UI: “Aluris. Em homenagem a uma cidade antiga que um dia existiu.”

```text
A close shot of a cloaked figure with a serious, weighty expression, speaking one word into the night, while the blurred faces of the crowd behind him show no reaction, as if the word means nothing to them. Close shot in soft focus on the crowd, sharp on the speaker, warm light on one side and cold blue on the other. Dark-fantasy illustration with dense pixel-art finish and controlled dithering, crisp pixel edges, no smooth painterly blur, wide 16:9 landscape composition. No text, no letters, no speech bubbles, no captions, no logo, no watermark, no frame or border, no UI. Keep the bottom third of the image visually calm and uncluttered. Nothing important is cropped by the edges. The named characters must match the attached reference portraits exactly; any other figure is an anonymous silhouette.
```

#### H44 — `hq_n12_q4` · Dar gancho · sem anexos

- [ ] gerada · [ ] aprovada · candidata: `.atena/generated/art-candidates/hq/hq_n12_q4_v01.png` · texto proposto na UI: Ninguém ali sabia o peso daquela palavra.

```text
On the edge of the stage, a broad, angry military leader in dark armor steps away from the crowd with his fist clenched, and far behind him, at the end of the bridge, a very old gray-bearded elven mage watches from a shadowed balcony. Wide shot from the stage side, the angry figure in the foreground, the old mage tiny in the background, cold shadow, a single banner in the breeze. Dark-fantasy illustration with dense pixel-art finish and controlled dithering, crisp pixel edges, no smooth painterly blur, wide 16:9 landscape composition. No text, no letters, no speech bubbles, no captions, no logo, no watermark, no frame or border, no UI. Keep the bottom third of the image visually calm and uncluttered. Nothing important is cropped by the edges. No named characters in this image; any figures are anonymous silhouettes.
```

### HQN-13 — O Cerco de Aluris

Gatilho: Conquista Mestre de Camadas (desbloqueia Zynara). Proibido/cuidado: Chacina de humanos: NUNCA mostrada, só a rocha e a muralha; Helion pediu segredo (não revelar como conhecimento do jogador sem D-N2). Helion e Thalion são propostas de arte.

#### H45 — `hq_n13_q1` · Recapitular · sem anexos

- [ ] gerada · [ ] aprovada · candidata: `.atena/generated/art-candidates/hq/hq_n13_q1_v01.png` · texto proposto na UI: Eléstria, ano 700: um presente rasgou o céu.

```text
A silver elven city nestled between snowy mountains, with graceful towers and terraces, while a streak of bright light with a long tail crosses the sky and every citizen looks up in silence. Wide establishing shot, cool silver and pale gold light, the streak of light as the diagonal, tiny figures on the terraces. Dark-fantasy illustration with dense pixel-art finish and controlled dithering, crisp pixel edges, no smooth painterly blur, wide 16:9 landscape composition. No text, no letters, no speech bubbles, no captions, no logo, no watermark, no frame or border, no UI. Keep the bottom third of the image visually calm and uncluttered. Nothing important is cropped by the edges. No named characters in this image; any figures are anonymous silhouettes.
```

#### H46 — `hq_n13_q2` · Virar · anexar: `zynara.png`

- [ ] gerada · [ ] aprovada · candidata: `.atena/generated/art-candidates/hq/hq_n13_q2_v01.png` · texto proposto na UI: “Nossa estrela está morrendo.”

```text
A round council chamber where a proud elven veteran with a hard face speaks to a small group, and a calm woman elf (the younger version of an elven high councilor) stands silently, while a young, beardless elven mage looks at the floor with sadness. Medium-wide shot from the center of the round room, the three figures at different depths, cold silver light from a high window, warm tones on the veteran. Dark-fantasy illustration with dense pixel-art finish and controlled dithering, crisp pixel edges, no smooth painterly blur, wide 16:9 landscape composition. No text, no letters, no speech bubbles, no captions, no logo, no watermark, no frame or border, no UI. Keep the bottom third of the image visually calm and uncluttered. Nothing important is cropped by the edges. The named characters must match the attached reference portraits exactly; any other figure is an anonymous silhouette.
```

#### H47 — `hq_n13_q3` · Apresentar · sem anexos

- [ ] gerada · [ ] aprovada · candidata: `.atena/generated/art-candidates/hq/hq_n13_q3_v01.png` · texto proposto na UI: Setenta anos de cerco, e a muralha não caía.

```text
A vast siege camp at night before a massive human city wall, with exhausted elven soldiers sitting near dim fires, banners hanging limp, and the human wall lit calmly by its own defenders' fires in the distance. No combat, only fatigue. Very wide shot along the camp toward the wall, low fires, gray dawnless sky, small silhouettes in slumped poses. Dark-fantasy illustration with dense pixel-art finish and controlled dithering, crisp pixel edges, no smooth painterly blur, wide 16:9 landscape composition. No text, no letters, no speech bubbles, no captions, no logo, no watermark, no frame or border, no UI. Keep the bottom third of the image visually calm and uncluttered. Nothing important is cropped by the edges. No named characters in this image; any figures are anonymous silhouettes.
```

#### H48 — `hq_n13_q4` · Dar gancho · sem anexos

- [ ] gerada · [ ] aprovada · candidata: `.atena/generated/art-candidates/hq/hq_n13_q4_v01.png` · texto proposto na UI: Helion invocou uma rocha do céu. A muralha caiu.

```text
A lone elven mage on a royal stag raises a staff before a huge stone wall, a magical circle glowing at his feet, while a colossal boulder falls out of the darkening sky toward the wall. The sun seems to dim for an instant. No people are visible on the wall, only shapes. Extreme wide low-angle shot, the boulder falling as the largest shape, the mage tiny in the foreground, dramatic dark sky with a thin pale streak. Dark-fantasy illustration with dense pixel-art finish and controlled dithering, crisp pixel edges, no smooth painterly blur, wide 16:9 landscape composition. No text, no letters, no speech bubbles, no captions, no logo, no watermark, no frame or border, no UI. Keep the bottom third of the image visually calm and uncluttered. Nothing important is cropped by the edges. No named characters in this image; any figures are anonymous silhouettes.
```

### HQN-14 — A Máscara

Gatilho: Conquista Pilares Ativos (desbloqueia Nyrelia). Proibido/cuidado: Nada da Sessão 13 em diante sobre Nyrelia (a visão de ‘Seremos um só’ é ilusão); as falas são do vault.

#### H49 — `hq_n14_q1` · Recapitular · anexar: `sylas.png`

- [ ] gerada · [ ] aprovada · candidata: `.atena/generated/art-candidates/hq/hq_n14_q1_v01.png` · texto proposto na UI: Entre a multidão, alguém usava uma máscara igual à dele.

```text
A busy rally crowd at night under lanterns, with one masked hooded figure standing still among them, wearing a plain pale mask, looking straight at the viewer's side. In the foreground a tiefling in a similar mask stops, startled. Medium shot over the shoulder of the tiefling toward the masked figure, shallow depth, warm lantern bokeh, cold blue rim light on the masks. Dark-fantasy illustration with dense pixel-art finish and controlled dithering, crisp pixel edges, no smooth painterly blur, wide 16:9 landscape composition. No text, no letters, no speech bubbles, no captions, no logo, no watermark, no frame or border, no UI. Keep the bottom third of the image visually calm and uncluttered. Nothing important is cropped by the edges. The named characters must match the attached reference portraits exactly; any other figure is an anonymous silhouette.
```

#### H50 — `hq_n14_q2` · Virar · anexar: `sylas.png`, `brook.png`, `kayron.png`

- [ ] gerada · [ ] aprovada · candidata: `.atena/generated/art-candidates/hq/hq_n14_q2_v01.png` · texto proposto na UI: O colar mostrou uma aura amarela.

```text
A dead-end alley where three adventurers have cornered a hooded masked figure, and a true-seeing amulet in one adventurer's hand casts a faint light that reveals a yellow aura around the figure, different from the green auras they have learned to fear. Medium-wide shot down a narrow alley, the amulet glow in the foreground, the yellow aura at the far end, dark stone walls. Dark-fantasy illustration with dense pixel-art finish and controlled dithering, crisp pixel edges, no smooth painterly blur, wide 16:9 landscape composition. No text, no letters, no speech bubbles, no captions, no logo, no watermark, no frame or border, no UI. Keep the bottom third of the image visually calm and uncluttered. Nothing important is cropped by the edges. The named characters must match the attached reference portraits exactly; any other figure is an anonymous silhouette.
```

#### H51 — `hq_n14_q3` · Apresentar · anexar: `sylas.png`, `nyrelia.png`

- [ ] gerada · [ ] aprovada · candidata: `.atena/generated/art-candidates/hq/hq_n14_q3_v01.png` · texto proposto na UI: Nyrelia, a sacerdotisa que o criou.

```text
A priestess in dark cloth with a plain white mask stands facing a tiefling in a matching mask, both very still, the space between them charged with old affection and old secrets, the alley behind them quiet. Close two-shot in profile, symmetry between the two masks, warm amber light from one side and cold blue from the other, shallow depth. Dark-fantasy illustration with dense pixel-art finish and controlled dithering, crisp pixel edges, no smooth painterly blur, wide 16:9 landscape composition. No text, no letters, no speech bubbles, no captions, no logo, no watermark, no frame or border, no UI. Keep the bottom third of the image visually calm and uncluttered. Nothing important is cropped by the edges. The named characters must match the attached reference portraits exactly; any other figure is an anonymous silhouette.
```

#### H52 — `hq_n14_q4` · Dar gancho · anexar: `sylas.png`, `nyrelia.png`

- [ ] gerada · [ ] aprovada · candidata: `.atena/generated/art-candidates/hq/hq_n14_q4_v01.png` · texto proposto na UI: “Crianças não precisam carregar guerra.”

```text
The masked priestess places a gentle hand on the tiefling's shoulder, her head slightly bowed, as the tiefling looks down at the floor, and behind them two other adventurers wait at a discreet distance. Close low-angle shot of the hand and shoulder, the two masks softly out of focus behind, warm light and soft shadow, quiet mood. Dark-fantasy illustration with dense pixel-art finish and controlled dithering, crisp pixel edges, no smooth painterly blur, wide 16:9 landscape composition. No text, no letters, no speech bubbles, no captions, no logo, no watermark, no frame or border, no UI. Keep the bottom third of the image visually calm and uncluttered. Nothing important is cropped by the edges. The named characters must match the attached reference portraits exactly; any other figure is an anonymous silhouette.
```

## Como devolver

1. Coloque os PNGs brutos em `.atena/generated/art-candidates/hq/`.
2. Avise a Atena por HQ. Ela monta a prancha de revisão.
3. Você aprova por imagem; só então acontece a admissão.
