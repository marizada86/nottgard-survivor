---
id: "IMAGEGEN-LOG-001"
title: "Prompts executados — piloto do cultista de adaga"
created: "2026-09-29"
source: "[[ART-PROMPTS-031-piloto-animacao-cultista-adaga]]"
tool: "built-in image_gen"
---

# IMAGEGEN-LOG-001 — Prompts executados

Os textos abaixo registram o prompt efetivamente enviado: em cada grupo, o
prompt final é o bloco comum seguido da linha individual do quadro. A imagem
de referência oficial foi anexada em todas as chamadas; E01 também recebeu a
referência E01 aprovada. E02–E24 receberam ambas.

Referências locais:

- identidade e cor: `assets/enemies/cultista_adaga.png`;
- consistência após E01: `.atena/generated/art-candidates/enemy-pilot/cultista_adaga/cultista_adaga_idle_00_v01.png`.

## E01 — identidade

```text
Use case: stylized-concept
Asset type: single game character sprite; pilot identity frame E01 for Nottgard Survivors.
Input image: Image 1 is the official cultista_adaga sprite. Use it as the mandatory reference for identity, colors, clothing, silhouette, and the dagger hand.
Primary request: A single game character sprite of the same hooded cultist of a mist cult: tattered gray robe with plum-purple trim, deep hood that hides most of the face in shadow with a small red eye glyph painted on the hood, braided copper rope belt with a metal ring, bandaged forearms, worn brown leather boots, and a curved copper-colored dagger held low in the same hand as the reference. Pose: standing still in a neutral idle stance facing right, knees slightly bent, dagger held low, robe hanging still.
Style/medium: Dark-fantasy isometric pixel-art game sprite, crisp clean pixels with controlled dithering, three-quarter isometric angle tilted about 30 degrees from above, soft light from upper left.
Composition/framing: One full-body figure, centered, roughly 8% side margin, feet planted at the bottom of the frame, tall portrait image.
Scene/backdrop: A single flat, uniform solid cyan background (#00FFFF); no ground, floor, cast shadow, gradient, texture, or scenery.
Constraints: Preserve the official character identity and same dagger hand. The character faces toward the RIGHT side of the image. Entire silhouette must be solid and fully opaque, with no wispy, translucent, faded, or scattered-pixel areas. No blur, anti-aliasing, motion blur, or effect lines. No text, logo, watermark, frame, border, UI, or second character. Only this character.
```

## E02 — idle

```text
Use case: stylized-concept
Asset type: single game character sprite; pilot frame E02 for Nottgard Survivors.
Input image 1: official cultista_adaga sprite, mandatory identity/color reference.
Input image 2: approved E01 identity frame, mandatory consistency reference.
Primary request: Same hooded cultist character as in the attached identity frame (tattered gray robe with plum-purple trim, hood with a red eye glyph, copper rope belt, bandaged forearms, brown boots, curved copper dagger) - keep exactly the same clothing, colors, proportions, camera angle, zoom, facing direction and dagger hand. Pose: a faint breathing sway, shoulders rising slightly and the robe hem shifting a little, feet staying planted.
Style/medium: Dark-fantasy isometric pixel-art game sprite, three-quarter isometric angle tilted about 30 degrees from above, crisp rendering with controlled dithering, no blur or anti-aliasing, no motion-blur streaks and no effect lines.
Composition/framing: Centered with roughly 8% side margin, feet planted at the bottom of the frame, full figure, tall portrait image.
Scene/backdrop: A single flat uniform solid cyan color (#00FFFF), no ground, floor, cast shadow, gradient, texture, or scenery.
Constraints: The character faces toward the RIGHT side of the image. Entire silhouette solid and fully opaque; no wispy, translucent, faded, or speckled/scattered-pixel appearance. No text, logo, watermark, frame, border, UI, or second character - only this one character.
```

## E03–E04 — idle

**Common prompt:**

```text
Use case: stylized-concept. Asset type: single game character sprite, pilot for Nottgard Survivors. Input image 1 is the official cultist sprite and mandatory identity/color reference. Input image 2 is the approved E01 identity and mandatory consistency reference. Same hooded mist cultist: tattered gray robe with plum-purple trim, deep hood with red eye glyph, braided copper rope belt with metal ring, bandaged forearms, worn brown leather boots, curved copper dagger held low in the same hand. Preserve the exact identity, colors, clothing, proportions, camera angle, zoom, facing direction and dagger hand. Dark-fantasy isometric pixel-art game sprite, three-quarter angle tilted about 30 degrees from above, crisp pixels with controlled dithering, soft upper-left light, no blur, anti-aliasing, motion blur or effect lines. One full-body figure, centered with roughly 8% side margin, feet planted at bottom, tall portrait. Background: single flat solid cyan #00FFFF, no ground, floor, shadow, gradient, texture or scenery. Face toward the RIGHT side of the image. Entire silhouette solid and fully opaque; no wispy, translucent, faded or speckled pixels. No text, logo, watermark, frame, border, UI, or second character.
```

- E03 prompt suffix: `Frame E03 — cultista_adaga_idle_02. Pose: a small weight shift from one leg to the other, hood tilting slightly, robe hem shifting with the leg; feet remain planted and the dagger stays low. Tall portrait image.`
- E04 prompt suffix: `Frame E04 — cultista_adaga_idle_03. Pose: return smoothly to the initial neutral idle stance, shoulders settled, feet planted, dagger low and robe hanging still, ready to loop back to E01. Tall portrait image.`

## E05–E10 — move

**Common prompt:**

```text
Use case: stylized-concept. Asset type: single game character sprite, pilot for Nottgard Survivors. Input image 1 is the official cultist sprite and mandatory identity/color reference. Input image 2 is approved E01 and mandatory consistency reference. Same hooded mist cultist: tattered gray robe with plum-purple trim, deep hood with red eye glyph, braided copper rope belt with metal ring, bandaged forearms, worn brown leather boots, curved copper dagger held low in the same hand. Preserve exact identity, colors, clothing, proportions, camera angle, zoom, facing direction and dagger hand. Dark-fantasy isometric pixel-art sprite, three-quarter angle tilted about 30 degrees from above, crisp pixels with controlled dithering, soft upper-left light, no blur, anti-aliasing, motion blur or effect lines. One full-body figure, centered with roughly 8% side margin, tall portrait, boots fully visible. Background: single flat solid cyan #00FFFF, no ground, floor, shadow, gradient, texture or scenery. Character faces RIGHT. Entire silhouette solid and fully opaque; no wispy, translucent, faded or speckled pixels. No text, logo, watermark, frame, border, UI, or second character.
```

- E05 `cultista_adaga_move_00`: `Walk cycle contact: front foot touches the ground ahead, rear leg extended behind, robe hem swinging back; both boots clearly visible. Feet remain within the frame.`
- E06 `cultista_adaga_move_01`: `Walk cycle down: knees bend as weight transfers onto the front leg, torso at its lowest point, rear boot lifting. Feet remain within the frame.`
- E07 `cultista_adaga_move_02`: `Walk cycle passing: rear foot swings forward past the supporting leg, robe hem swirls, both boots visible. Feet remain within the frame.`
- E08 `cultista_adaga_move_03`: `Walk cycle contact with the OTHER foot in front; legs reversed from E05, robe hem swinging back, both boots visible. Feet remain within the frame.`
- E09 `cultista_adaga_move_04`: `Walk cycle down on the other side: weight transfers to the new front leg, torso low, rear boot lifting. Feet remain within the frame.`
- E10 `cultista_adaga_move_05`: `Walk cycle passing and closing: rear foot swings forward to complete the loop to E05, stable base without vertical bounce. Feet remain within the frame.`

For each candidate the exact suffix appended to the common prompt is
`{ID} — {name}. Pose: {instruction} Feet remain within the frame.`

## E11–E14 — attack

**Common prompt:**

```text
Use case: stylized-concept. Asset type: single game character sprite, pilot for Nottgard Survivors. Input image 1 is the official cultist sprite and mandatory identity/color reference. Input image 2 is approved E01 and mandatory consistency reference. Same hooded mist cultist: tattered gray robe with plum-purple trim, deep hood with red eye glyph, braided copper rope belt with metal ring, bandaged forearms, worn brown leather boots, curved copper dagger held low in the same hand. Preserve exact identity, colors, clothing, proportions, camera angle, zoom, facing direction and dagger hand. Dark-fantasy isometric pixel-art sprite, three-quarter angle tilted about 30 degrees from above, crisp pixels with controlled dithering, soft upper-left light, no blur, anti-aliasing, motion blur or effect lines. One full-body figure, centered with roughly 8% side margin, full pose visible, tall portrait. Background: single flat solid cyan #00FFFF, no ground, floor, shadow, gradient, texture or scenery. Character faces RIGHT. Entire silhouette solid and fully opaque; no wispy, translucent, faded or speckled pixels. No text, logo, watermark, frame, border, UI, or second character.
```

- E11 `cultista_adaga_attack_00`: `Attack wind-up: crouching slightly, dagger arm pulled back behind the body, weight on the rear leg.`
- E12 `cultista_adaga_attack_01`: `Start of a forward lunge: front foot steps forward, body leans aggressively toward the right, dagger arm beginning to swing.`
- E13 `cultista_adaga_attack_02`: `Strike: dagger thrust forward at full arm extension, body stretched into the lunge, complete silhouette clearly visible.`
- E14 `cultista_adaga_attack_03`: `Recovery: pull dagger back and straighten up, returning toward the neutral stance.`

For each candidate the exact suffix appended to the common prompt is
`{ID} — {name}. Pose: {instruction}`.

## E15–E20 — death

**Common prompt:**

```text
Use case: stylized-concept. Asset type: single game character sprite, pilot for Nottgard Survivors. Input image 1 is the official cultist sprite and mandatory identity/color reference. Input image 2 is approved E01 and mandatory consistency reference. Same hooded mist cultist: tattered gray robe with plum-purple trim, deep hood with red eye glyph, braided copper rope belt with metal ring, bandaged forearms, worn brown leather boots, curved copper dagger held in the same hand. Preserve exact identity, colors, clothing, proportions, camera angle, zoom, facing direction and dagger hand. Dark-fantasy isometric pixel-art sprite, three-quarter angle tilted about 30 degrees from above, crisp pixels with controlled dithering, soft upper-left light, no blur, anti-aliasing, motion blur or effect lines. One complete figure, centered with roughly 8% side margin, full pose visible in tall portrait. Background: single flat solid cyan #00FFFF, no ground, floor, shadow, gradient, texture or scenery. Character faces RIGHT. Entire silhouette solid and fully opaque; no wispy, translucent, faded or speckled pixels. No text, logo, watermark, frame, border, UI, or second character.
```

- E15 `cultista_adaga_death_00`: `Reacting to a fatal blow: body recoils, head thrown back slightly, dagger starting to slip from the hand.`
- E16 `cultista_adaga_death_01`: `Knees buckle, torso tilts forward, dagger falling from the hand.`
- E17 `cultista_adaga_death_02`: `Dropping to the knees, one hand touching the ground, hood hanging low.`
- E18 `cultista_adaga_death_03`: `Half fallen, body tipping onto its side; silhouette remains readable as the same character.`
- E19 `cultista_adaga_death_04`: `Nearly collapsed on the ground, robe spread around the body, no dismemberment.`
- E20 `cultista_adaga_death_05`: `Final resting pose, motionless on the ground, body intact, dagger lying beside the hand, robe spread out.`

For each candidate the exact suffix appended to the common prompt is
`{ID} — {name}. Pose: {instruction}`.

## E21–E24 — strips

**Common prompt:**

```text
Use case: stylized-concept. Asset type: one horizontal animation sprite strip for Nottgard Survivors. Input image 1 is the official cultist sprite and mandatory identity/color reference. Input image 2 is approved E01 and mandatory identity, proportion, camera, and facing reference. Same hooded mist cultist: tattered gray robe with plum-purple trim, deep hood with red eye glyph, braided copper rope belt with metal ring, bandaged forearms, worn brown leather boots, curved copper dagger in the same hand. Preserve exact identity, outfit, colors, scale, camera and right-facing direction in every frame. Dark-fantasy isometric pixel-art sprite, three-quarter angle tilted about 30 degrees from above, crisp pixel rendering with controlled dithering, soft upper-left light, no blur, anti-aliasing, motion blur or effect lines. Background: single flat uniform solid cyan #00FFFF, no ground, floor, shadow, gradient, texture or scenery. No text, logo, watermark, frame, border, UI, or extra characters. Every silhouette fully opaque. Very wide landscape image.
```

- E21 `cultista_adaga_row_idle`: exactly 4 copies in one row, evenly spaced with empty cyan gaps; state `idle`; sequence: `1) standing still in a neutral idle stance facing right, knees slightly bent, dagger low, robe still. 2) faint breathing sway, shoulders rising slightly and robe hem shifting, feet planted. 3) small weight shift to the other leg, hood tilting slightly, robe hem shifting. 4) return to the initial neutral stance, feet planted, ready to loop.`
- E22 `cultista_adaga_row_move`: exactly 6 copies in one row, evenly spaced with empty cyan gaps; state `move`; sequence: `1) walk contact: front foot touches ground ahead, rear leg extended, robe swings back, both boots visible. 2) down frame: knees bend, weight transfers to front leg, torso lowest, rear boot lifts. 3) passing: rear foot swings past supporting leg, both boots visible. 4) contact with the OTHER foot in front, legs reversed from frame 1. 5) down frame transferring weight to the new front leg. 6) passing frame closes the cycle back to frame 1, stable base, no vertical bounce.`
- E23 `cultista_adaga_row_attack`: exactly 4 copies in one row, evenly spaced with empty cyan gaps; state `attack`; sequence: `1) wind-up, crouched slightly, dagger arm pulled back, weight on rear leg. 2) forward lunge begins, front foot steps forward, torso leans right, dagger arm swings. 3) strike, dagger thrust forward at full extension, body stretched into lunge. 4) recovery, pull dagger back and return toward neutral stance.`
- E24 `cultista_adaga_row_death`: exactly 6 copies in one row, evenly spaced with empty cyan gaps; state `death`; sequence: `1) fatal impact, body recoils and head tilts back, dagger starting to slip. 2) knees buckle and dagger falls. 3) dropping to knees, one hand touches ground, hood low. 4) half fallen, body tips onto side but remains readable. 5) nearly collapsed, robe spread, intact body. 6) motionless final resting pose, intact, dagger beside hand.`

Each final prompt is the common prompt followed by this exact structure, with
the values above substituted: `{ID} — {name}. Create exactly {n} copies of the
same character arranged left-to-right in one horizontal row. The frames must
be evenly spaced, with clear empty cyan gaps; no frame touches or overlaps
another and nothing is cropped. State: {state}. Frame sequence: {sequence}`.
