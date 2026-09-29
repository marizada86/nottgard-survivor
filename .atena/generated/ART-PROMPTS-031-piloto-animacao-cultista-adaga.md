---
id: "ART-PROMPTS-031"
type: "prompts-de-arte"
title: "Piloto de animação no padrão Zumbi — cultista_adaga (métodos 1 e 2)"
status: "prepared — decisões D-A1 a D-A6 do PLAN-041 aprovadas; aguardando geração externa, nada executado"
created: "2026-09-29"
relations: ["[[PLAN-041-animacao-padrao-zumbi-para-inimigos-e-interacoes-2026-09-29]]", "[[SPEC-061-preparacao-da-regeneracao-do-piloto-de-zumbi]]", "[[CHATGPT-PROMPTS-ZUMBI-V01]]"]
sources: ["assets/enemies/cultista_adaga.png", "data/enemies.json", "CHATGPT-PROMPTS-ZUMBI-V01"]
---

# Piloto de animação — cultista_adaga

Onda 0 do [[PLAN-041-animacao-padrao-zumbi-para-inimigos-e-interacoes-2026-09-29]]. Serve para **comparar dois métodos** com a régua do Zumbi e escolher o que será usado nas demais ondas. Nada foi gerado.

## Decisões do dono que valem para o piloto

- **Perfil A (padrão Zumbi):** idle 4, move 6, attack 4, death 6 = 20 quadros.
- **Movimento básico das pernas e virar para esquerda e direita.** A arte-base é gerada **voltada para a direita**; o jogo espelha (`flip_h`) ao andar para a esquerda, como nos heróis (EVID-029). Por isso os prompts pedem o personagem virado para a direita, com botas e pernas **visíveis e alternando** no `move`.
- O espelhamento e o `data/enemy_animations.json` são trabalho técnico separado (spec de integração); o piloto só entrega a arte.

## O personagem

Dados: `cultista_adaga` (Dagruve e Docas), velocidade 1,5, sem habilidade especial, escala 1,0, célula final 256×384. Arte oficial de referência: `assets/enemies/cultista_adaga.png` (capuz cinza rasgado com bordas ameixa, glifo de olho vermelho, corda de cobre, faixas nos antebraços, botas marrons, adaga curva cor de cobre).

Fundo **ciano `#00FFFF`** (não magenta): a roupa tem ameixa/roxo perto de magenta, o que estragaria a remoção da cor.

## Regras de envio

1. **Anexe em toda mensagem** `assets/enemies/cultista_adaga.png` (identidade e cores). Do 2º quadro em diante, anexe também **o quadro de identidade aprovado** (E01 ou o primeiro quadro aprovado).
2. Envie primeiro **só a identidade (E01)**. Só continue quando ela estiver aprovada: cor, proporção, capuz, mão da adaga e direção do olhar (direita).
3. **Método 1:** uma imagem por mensagem, na mesma conversa, em ordem. **Método 2:** uma imagem por estado (4 no total), na mesma conversa, depois de aprovada a identidade.
4. Salve como `<id>_v01.png` (`_v02` para nova tentativa) em `.atena/generated/art-candidates/enemy-pilot/cultista_adaga/`.
5. Descarte silhueta translúcida, pixels soltos, halo, texto, pose virada para a esquerda, quadro fora de escala ou mão da adaga trocada.

## Método 1 — quadro a quadro (20 imagens)

### IDLE

#### E01 - `cultista_adaga_idle_00` - postura parada (IDENTIDADE)

```text
A single game character sprite of a hooded cultist of a mist cult: a tattered gray robe with plum-purple trim, a deep hood that hides the face in shadow with a small red eye glyph painted on the hood, a braided copper rope belt with a metal ring, bandaged forearms, worn brown leather boots, and a curved copper-colored dagger held low in one hand (always the same hand in every frame). Pose: standing still, neutral idle stance facing right, knees slightly bent, dagger held low, robe hanging still. Dark-fantasy isometric pixel-art game sprite, three-quarter isometric angle tilted about 30 degrees from above, the character facing toward the RIGHT side of the image, soft light from the upper left, crisp clean pixel-art rendering with controlled dithering, no blur or anti-aliasing, no motion-blur streaks and no effect lines. Centered with roughly 8% side margin, feet planted at the bottom of the frame. Background: a single flat uniform solid cyan color (#00FFFF), no ground, floor, cast shadow, gradient, texture, or scenery. No text, logo, watermark, frame, border, UI, or second character - only this one character. Critically, the whole silhouette must be solid and fully opaque - no wispy, translucent, faded, or speckled/scattered-pixel appearance anywhere on the body; it must read as one clear, solid, fully-colored figure. Tall portrait image.
```

#### E02 - `cultista_adaga_idle_01` - respiração

```text
Same hooded cultist character as in the attached identity frame (tattered gray robe with plum-purple trim, hood with a red eye glyph, copper rope belt, bandaged forearms, brown boots, curved copper dagger) - keep exactly the same clothing, colors, proportions, camera angle, zoom, facing direction and dagger hand. Pose: a faint breathing sway, shoulders rising slightly and the robe hem shifting a little, feet staying planted. Dark-fantasy isometric pixel-art game sprite, three-quarter isometric angle tilted about 30 degrees from above, the character facing toward the RIGHT side of the image, soft light from the upper left, crisp clean pixel-art rendering with controlled dithering, no blur or anti-aliasing, no motion-blur streaks and no effect lines. Centered with roughly 8% side margin, feet planted at the bottom of the frame. Background: a single flat uniform solid cyan color (#00FFFF), no ground, floor, cast shadow, gradient, texture, or scenery. No text, logo, watermark, frame, border, UI, or second character - only this one character. Critically, the whole silhouette must be solid and fully opaque - no wispy, translucent, faded, or speckled/scattered-pixel appearance anywhere on the body; it must read as one clear, solid, fully-colored figure. Tall portrait image.
```

#### E03 - `cultista_adaga_idle_02` - mudança de peso

```text
Same hooded cultist character as in the attached identity frame (tattered gray robe with plum-purple trim, hood with a red eye glyph, copper rope belt, bandaged forearms, brown boots, curved copper dagger) - keep exactly the same clothing, colors, proportions, camera angle, zoom, facing direction and dagger hand. Pose: a small weight shift from one leg to the other, hood tilting slightly, the robe hem shifting with the leg. Dark-fantasy isometric pixel-art game sprite, three-quarter isometric angle tilted about 30 degrees from above, the character facing toward the RIGHT side of the image, soft light from the upper left, crisp clean pixel-art rendering with controlled dithering, no blur or anti-aliasing, no motion-blur streaks and no effect lines. Centered with roughly 8% side margin, feet planted at the bottom of the frame. Background: a single flat uniform solid cyan color (#00FFFF), no ground, floor, cast shadow, gradient, texture, or scenery. No text, logo, watermark, frame, border, UI, or second character - only this one character. Critically, the whole silhouette must be solid and fully opaque - no wispy, translucent, faded, or speckled/scattered-pixel appearance anywhere on the body; it must read as one clear, solid, fully-colored figure. Tall portrait image.
```

#### E04 - `cultista_adaga_idle_03` - retorno

```text
Same hooded cultist character as in the attached identity frame (tattered gray robe with plum-purple trim, hood with a red eye glyph, copper rope belt, bandaged forearms, brown boots, curved copper dagger) - keep exactly the same clothing, colors, proportions, camera angle, zoom, facing direction and dagger hand. Pose: returning to the initial neutral idle stance, feet planted, ready to loop back to the first frame. Dark-fantasy isometric pixel-art game sprite, three-quarter isometric angle tilted about 30 degrees from above, the character facing toward the RIGHT side of the image, soft light from the upper left, crisp clean pixel-art rendering with controlled dithering, no blur or anti-aliasing, no motion-blur streaks and no effect lines. Centered with roughly 8% side margin, feet planted at the bottom of the frame. Background: a single flat uniform solid cyan color (#00FFFF), no ground, floor, cast shadow, gradient, texture, or scenery. No text, logo, watermark, frame, border, UI, or second character - only this one character. Critically, the whole silhouette must be solid and fully opaque - no wispy, translucent, faded, or speckled/scattered-pixel appearance anywhere on the body; it must read as one clear, solid, fully-colored figure. Tall portrait image.
```

### MOVE

#### E05 - `cultista_adaga_move_00` - contato do pé dianteiro

```text
Same hooded cultist character as in the attached identity frame (tattered gray robe with plum-purple trim, hood with a red eye glyph, copper rope belt, bandaged forearms, brown boots, curved copper dagger) - keep exactly the same clothing, colors, proportions, camera angle, zoom, facing direction and dagger hand. Pose: walk cycle contact frame - the front foot touches the ground ahead and the rear leg is extended behind, the robe hem swinging back, both boots clearly visible. Dark-fantasy isometric pixel-art game sprite, three-quarter isometric angle tilted about 30 degrees from above, the character facing toward the RIGHT side of the image, soft light from the upper left, crisp clean pixel-art rendering with controlled dithering, no blur or anti-aliasing, no motion-blur streaks and no effect lines. Centered with roughly 8% side margin, feet planted at the bottom of the frame. Background: a single flat uniform solid cyan color (#00FFFF), no ground, floor, cast shadow, gradient, texture, or scenery. No text, logo, watermark, frame, border, UI, or second character - only this one character. Critically, the whole silhouette must be solid and fully opaque - no wispy, translucent, faded, or speckled/scattered-pixel appearance anywhere on the body; it must read as one clear, solid, fully-colored figure. Tall portrait image.
```

#### E06 - `cultista_adaga_move_01` - apoio, joelhos dobram

```text
Same hooded cultist character as in the attached identity frame (tattered gray robe with plum-purple trim, hood with a red eye glyph, copper rope belt, bandaged forearms, brown boots, curved copper dagger) - keep exactly the same clothing, colors, proportions, camera angle, zoom, facing direction and dagger hand. Pose: walk cycle down frame - knees bending, weight transferring onto the front leg, torso at its lowest point, the rear boot lifting. Dark-fantasy isometric pixel-art game sprite, three-quarter isometric angle tilted about 30 degrees from above, the character facing toward the RIGHT side of the image, soft light from the upper left, crisp clean pixel-art rendering with controlled dithering, no blur or anti-aliasing, no motion-blur streaks and no effect lines. Centered with roughly 8% side margin, feet planted at the bottom of the frame. Background: a single flat uniform solid cyan color (#00FFFF), no ground, floor, cast shadow, gradient, texture, or scenery. No text, logo, watermark, frame, border, UI, or second character - only this one character. Critically, the whole silhouette must be solid and fully opaque - no wispy, translucent, faded, or speckled/scattered-pixel appearance anywhere on the body; it must read as one clear, solid, fully-colored figure. Tall portrait image.
```

#### E07 - `cultista_adaga_move_02` - passagem do pé traseiro

```text
Same hooded cultist character as in the attached identity frame (tattered gray robe with plum-purple trim, hood with a red eye glyph, copper rope belt, bandaged forearms, brown boots, curved copper dagger) - keep exactly the same clothing, colors, proportions, camera angle, zoom, facing direction and dagger hand. Pose: walk cycle passing frame - the rear foot swinging forward past the supporting leg, the robe hem swirling, both boots visible. Dark-fantasy isometric pixel-art game sprite, three-quarter isometric angle tilted about 30 degrees from above, the character facing toward the RIGHT side of the image, soft light from the upper left, crisp clean pixel-art rendering with controlled dithering, no blur or anti-aliasing, no motion-blur streaks and no effect lines. Centered with roughly 8% side margin, feet planted at the bottom of the frame. Background: a single flat uniform solid cyan color (#00FFFF), no ground, floor, cast shadow, gradient, texture, or scenery. No text, logo, watermark, frame, border, UI, or second character - only this one character. Critically, the whole silhouette must be solid and fully opaque - no wispy, translucent, faded, or speckled/scattered-pixel appearance anywhere on the body; it must read as one clear, solid, fully-colored figure. Tall portrait image.
```

#### E08 - `cultista_adaga_move_03` - contato com o outro pé

```text
Same hooded cultist character as in the attached identity frame (tattered gray robe with plum-purple trim, hood with a red eye glyph, copper rope belt, bandaged forearms, brown boots, curved copper dagger) - keep exactly the same clothing, colors, proportions, camera angle, zoom, facing direction and dagger hand. Pose: walk cycle contact frame with the OTHER foot in front - legs mirrored from the first frame, robe hem swinging back, both boots clearly visible. Dark-fantasy isometric pixel-art game sprite, three-quarter isometric angle tilted about 30 degrees from above, the character facing toward the RIGHT side of the image, soft light from the upper left, crisp clean pixel-art rendering with controlled dithering, no blur or anti-aliasing, no motion-blur streaks and no effect lines. Centered with roughly 8% side margin, feet planted at the bottom of the frame. Background: a single flat uniform solid cyan color (#00FFFF), no ground, floor, cast shadow, gradient, texture, or scenery. No text, logo, watermark, frame, border, UI, or second character - only this one character. Critically, the whole silhouette must be solid and fully opaque - no wispy, translucent, faded, or speckled/scattered-pixel appearance anywhere on the body; it must read as one clear, solid, fully-colored figure. Tall portrait image.
```

#### E09 - `cultista_adaga_move_04` - apoio no outro pé

```text
Same hooded cultist character as in the attached identity frame (tattered gray robe with plum-purple trim, hood with a red eye glyph, copper rope belt, bandaged forearms, brown boots, curved copper dagger) - keep exactly the same clothing, colors, proportions, camera angle, zoom, facing direction and dagger hand. Pose: walk cycle down frame - weight transferring onto the new front leg, torso at its lowest point, the rear boot lifting. Dark-fantasy isometric pixel-art game sprite, three-quarter isometric angle tilted about 30 degrees from above, the character facing toward the RIGHT side of the image, soft light from the upper left, crisp clean pixel-art rendering with controlled dithering, no blur or anti-aliasing, no motion-blur streaks and no effect lines. Centered with roughly 8% side margin, feet planted at the bottom of the frame. Background: a single flat uniform solid cyan color (#00FFFF), no ground, floor, cast shadow, gradient, texture, or scenery. No text, logo, watermark, frame, border, UI, or second character - only this one character. Critically, the whole silhouette must be solid and fully opaque - no wispy, translucent, faded, or speckled/scattered-pixel appearance anywhere on the body; it must read as one clear, solid, fully-colored figure. Tall portrait image.
```

#### E10 - `cultista_adaga_move_05` - passagem e fechamento do ciclo

```text
Same hooded cultist character as in the attached identity frame (tattered gray robe with plum-purple trim, hood with a red eye glyph, copper rope belt, bandaged forearms, brown boots, curved copper dagger) - keep exactly the same clothing, colors, proportions, camera angle, zoom, facing direction and dagger hand. Pose: walk cycle passing frame - the rear foot swinging forward, closing the loop so the next frame is the first contact frame again, base steady with no vertical bounce. Dark-fantasy isometric pixel-art game sprite, three-quarter isometric angle tilted about 30 degrees from above, the character facing toward the RIGHT side of the image, soft light from the upper left, crisp clean pixel-art rendering with controlled dithering, no blur or anti-aliasing, no motion-blur streaks and no effect lines. Centered with roughly 8% side margin, feet planted at the bottom of the frame. Background: a single flat uniform solid cyan color (#00FFFF), no ground, floor, cast shadow, gradient, texture, or scenery. No text, logo, watermark, frame, border, UI, or second character - only this one character. Critically, the whole silhouette must be solid and fully opaque - no wispy, translucent, faded, or speckled/scattered-pixel appearance anywhere on the body; it must read as one clear, solid, fully-colored figure. Tall portrait image.
```

### ATTACK

#### E11 - `cultista_adaga_attack_00` - preparo

```text
Same hooded cultist character as in the attached identity frame (tattered gray robe with plum-purple trim, hood with a red eye glyph, copper rope belt, bandaged forearms, brown boots, curved copper dagger) - keep exactly the same clothing, colors, proportions, camera angle, zoom, facing direction and dagger hand. Pose: attack wind-up - crouching slightly, the dagger arm pulled back behind the body, weight on the rear leg. Dark-fantasy isometric pixel-art game sprite, three-quarter isometric angle tilted about 30 degrees from above, the character facing toward the RIGHT side of the image, soft light from the upper left, crisp clean pixel-art rendering with controlled dithering, no blur or anti-aliasing, no motion-blur streaks and no effect lines. Centered with roughly 8% side margin, feet planted at the bottom of the frame. Background: a single flat uniform solid cyan color (#00FFFF), no ground, floor, cast shadow, gradient, texture, or scenery. No text, logo, watermark, frame, border, UI, or second character - only this one character. Critically, the whole silhouette must be solid and fully opaque - no wispy, translucent, faded, or speckled/scattered-pixel appearance anywhere on the body; it must read as one clear, solid, fully-colored figure. Tall portrait image.
```

#### E12 - `cultista_adaga_attack_01` - início da investida

```text
Same hooded cultist character as in the attached identity frame (tattered gray robe with plum-purple trim, hood with a red eye glyph, copper rope belt, bandaged forearms, brown boots, curved copper dagger) - keep exactly the same clothing, colors, proportions, camera angle, zoom, facing direction and dagger hand. Pose: the start of a forward lunge - front foot stepping forward, body leaning aggressively toward the right, dagger arm beginning to swing. Dark-fantasy isometric pixel-art game sprite, three-quarter isometric angle tilted about 30 degrees from above, the character facing toward the RIGHT side of the image, soft light from the upper left, crisp clean pixel-art rendering with controlled dithering, no blur or anti-aliasing, no motion-blur streaks and no effect lines. Centered with roughly 8% side margin, feet planted at the bottom of the frame. Background: a single flat uniform solid cyan color (#00FFFF), no ground, floor, cast shadow, gradient, texture, or scenery. No text, logo, watermark, frame, border, UI, or second character - only this one character. Critically, the whole silhouette must be solid and fully opaque - no wispy, translucent, faded, or speckled/scattered-pixel appearance anywhere on the body; it must read as one clear, solid, fully-colored figure. Tall portrait image.
```

#### E13 - `cultista_adaga_attack_02` - golpe

```text
Same hooded cultist character as in the attached identity frame (tattered gray robe with plum-purple trim, hood with a red eye glyph, copper rope belt, bandaged forearms, brown boots, curved copper dagger) - keep exactly the same clothing, colors, proportions, camera angle, zoom, facing direction and dagger hand. Pose: the strike - the dagger thrust forward at full arm extension, body fully stretched into the lunge, full silhouette clearly visible. Dark-fantasy isometric pixel-art game sprite, three-quarter isometric angle tilted about 30 degrees from above, the character facing toward the RIGHT side of the image, soft light from the upper left, crisp clean pixel-art rendering with controlled dithering, no blur or anti-aliasing, no motion-blur streaks and no effect lines. Centered with roughly 8% side margin, feet planted at the bottom of the frame. Background: a single flat uniform solid cyan color (#00FFFF), no ground, floor, cast shadow, gradient, texture, or scenery. No text, logo, watermark, frame, border, UI, or second character - only this one character. Critically, the whole silhouette must be solid and fully opaque - no wispy, translucent, faded, or speckled/scattered-pixel appearance anywhere on the body; it must read as one clear, solid, fully-colored figure. Tall portrait image.
```

#### E14 - `cultista_adaga_attack_03` - recuperação

```text
Same hooded cultist character as in the attached identity frame (tattered gray robe with plum-purple trim, hood with a red eye glyph, copper rope belt, bandaged forearms, brown boots, curved copper dagger) - keep exactly the same clothing, colors, proportions, camera angle, zoom, facing direction and dagger hand. Pose: recovery - pulling the dagger back and straightening up, returning toward the neutral stance. Dark-fantasy isometric pixel-art game sprite, three-quarter isometric angle tilted about 30 degrees from above, the character facing toward the RIGHT side of the image, soft light from the upper left, crisp clean pixel-art rendering with controlled dithering, no blur or anti-aliasing, no motion-blur streaks and no effect lines. Centered with roughly 8% side margin, feet planted at the bottom of the frame. Background: a single flat uniform solid cyan color (#00FFFF), no ground, floor, cast shadow, gradient, texture, or scenery. No text, logo, watermark, frame, border, UI, or second character - only this one character. Critically, the whole silhouette must be solid and fully opaque - no wispy, translucent, faded, or speckled/scattered-pixel appearance anywhere on the body; it must read as one clear, solid, fully-colored figure. Tall portrait image.
```

### DEATH

#### E15 - `cultista_adaga_death_00` - impacto

```text
Same hooded cultist character as in the attached identity frame (tattered gray robe with plum-purple trim, hood with a red eye glyph, copper rope belt, bandaged forearms, brown boots, curved copper dagger) - keep exactly the same clothing, colors, proportions, camera angle, zoom, facing direction and dagger hand. Pose: reacting to a fatal blow - the body recoiling, head thrown back slightly, the dagger starting to slip. Dark-fantasy isometric pixel-art game sprite, three-quarter isometric angle tilted about 30 degrees from above, the character facing toward the RIGHT side of the image, soft light from the upper left, crisp clean pixel-art rendering with controlled dithering, no blur or anti-aliasing, no motion-blur streaks and no effect lines. Centered with roughly 8% side margin, feet planted at the bottom of the frame. Background: a single flat uniform solid cyan color (#00FFFF), no ground, floor, cast shadow, gradient, texture, or scenery. No text, logo, watermark, frame, border, UI, or second character - only this one character. Critically, the whole silhouette must be solid and fully opaque - no wispy, translucent, faded, or speckled/scattered-pixel appearance anywhere on the body; it must read as one clear, solid, fully-colored figure. Tall portrait image.
```

#### E16 - `cultista_adaga_death_01` - joelhos dobram

```text
Same hooded cultist character as in the attached identity frame (tattered gray robe with plum-purple trim, hood with a red eye glyph, copper rope belt, bandaged forearms, brown boots, curved copper dagger) - keep exactly the same clothing, colors, proportions, camera angle, zoom, facing direction and dagger hand. Pose: the knees buckling, the torso tilting forward, the dagger falling from the hand. Dark-fantasy isometric pixel-art game sprite, three-quarter isometric angle tilted about 30 degrees from above, the character facing toward the RIGHT side of the image, soft light from the upper left, crisp clean pixel-art rendering with controlled dithering, no blur or anti-aliasing, no motion-blur streaks and no effect lines. Centered with roughly 8% side margin, feet planted at the bottom of the frame. Background: a single flat uniform solid cyan color (#00FFFF), no ground, floor, cast shadow, gradient, texture, or scenery. No text, logo, watermark, frame, border, UI, or second character - only this one character. Critically, the whole silhouette must be solid and fully opaque - no wispy, translucent, faded, or speckled/scattered-pixel appearance anywhere on the body; it must read as one clear, solid, fully-colored figure. Tall portrait image.
```

#### E17 - `cultista_adaga_death_02` - de joelhos

```text
Same hooded cultist character as in the attached identity frame (tattered gray robe with plum-purple trim, hood with a red eye glyph, copper rope belt, bandaged forearms, brown boots, curved copper dagger) - keep exactly the same clothing, colors, proportions, camera angle, zoom, facing direction and dagger hand. Pose: dropping to the knees, one hand touching the ground, hood hanging low. Dark-fantasy isometric pixel-art game sprite, three-quarter isometric angle tilted about 30 degrees from above, the character facing toward the RIGHT side of the image, soft light from the upper left, crisp clean pixel-art rendering with controlled dithering, no blur or anti-aliasing, no motion-blur streaks and no effect lines. Centered with roughly 8% side margin, feet planted at the bottom of the frame. Background: a single flat uniform solid cyan color (#00FFFF), no ground, floor, cast shadow, gradient, texture, or scenery. No text, logo, watermark, frame, border, UI, or second character - only this one character. Critically, the whole silhouette must be solid and fully opaque - no wispy, translucent, faded, or speckled/scattered-pixel appearance anywhere on the body; it must read as one clear, solid, fully-colored figure. Tall portrait image.
```

#### E18 - `cultista_adaga_death_03` - semi-caído

```text
Same hooded cultist character as in the attached identity frame (tattered gray robe with plum-purple trim, hood with a red eye glyph, copper rope belt, bandaged forearms, brown boots, curved copper dagger) - keep exactly the same clothing, colors, proportions, camera angle, zoom, facing direction and dagger hand. Pose: half fallen, the body tipping onto its side, silhouette still readable as the same character. Dark-fantasy isometric pixel-art game sprite, three-quarter isometric angle tilted about 30 degrees from above, the character facing toward the RIGHT side of the image, soft light from the upper left, crisp clean pixel-art rendering with controlled dithering, no blur or anti-aliasing, no motion-blur streaks and no effect lines. Centered with roughly 8% side margin, feet planted at the bottom of the frame. Background: a single flat uniform solid cyan color (#00FFFF), no ground, floor, cast shadow, gradient, texture, or scenery. No text, logo, watermark, frame, border, UI, or second character - only this one character. Critically, the whole silhouette must be solid and fully opaque - no wispy, translucent, faded, or speckled/scattered-pixel appearance anywhere on the body; it must read as one clear, solid, fully-colored figure. Tall portrait image.
```

#### E19 - `cultista_adaga_death_04` - colapso quase completo

```text
Same hooded cultist character as in the attached identity frame (tattered gray robe with plum-purple trim, hood with a red eye glyph, copper rope belt, bandaged forearms, brown boots, curved copper dagger) - keep exactly the same clothing, colors, proportions, camera angle, zoom, facing direction and dagger hand. Pose: nearly collapsed on the ground, the robe spread around the body, no dismemberment. Dark-fantasy isometric pixel-art game sprite, three-quarter isometric angle tilted about 30 degrees from above, the character facing toward the RIGHT side of the image, soft light from the upper left, crisp clean pixel-art rendering with controlled dithering, no blur or anti-aliasing, no motion-blur streaks and no effect lines. Centered with roughly 8% side margin, feet planted at the bottom of the frame. Background: a single flat uniform solid cyan color (#00FFFF), no ground, floor, cast shadow, gradient, texture, or scenery. No text, logo, watermark, frame, border, UI, or second character - only this one character. Critically, the whole silhouette must be solid and fully opaque - no wispy, translucent, faded, or speckled/scattered-pixel appearance anywhere on the body; it must read as one clear, solid, fully-colored figure. Tall portrait image.
```

#### E20 - `cultista_adaga_death_05` - imóvel

```text
Same hooded cultist character as in the attached identity frame (tattered gray robe with plum-purple trim, hood with a red eye glyph, copper rope belt, bandaged forearms, brown boots, curved copper dagger) - keep exactly the same clothing, colors, proportions, camera angle, zoom, facing direction and dagger hand. Pose: final resting pose - motionless on the ground, body fully intact, the dagger lying beside the hand, the robe spread out. Dark-fantasy isometric pixel-art game sprite, three-quarter isometric angle tilted about 30 degrees from above, the character facing toward the RIGHT side of the image, soft light from the upper left, crisp clean pixel-art rendering with controlled dithering, no blur or anti-aliasing, no motion-blur streaks and no effect lines. Centered with roughly 8% side margin, feet planted at the bottom of the frame. Background: a single flat uniform solid cyan color (#00FFFF), no ground, floor, cast shadow, gradient, texture, or scenery. No text, logo, watermark, frame, border, UI, or second character - only this one character. Critically, the whole silhouette must be solid and fully opaque - no wispy, translucent, faded, or speckled/scattered-pixel appearance anywhere on the body; it must read as one clear, solid, fully-colored figure. Tall portrait image.
```

## Método 2 — uma fileira por estado (4 imagens)

Use depois da identidade aprovada. Anexe a arte oficial e o quadro de identidade.

### E21 - `cultista_adaga_row_idle` - 4 quadros

```text
A wide horizontal sprite strip containing exactly 4 frames of a hooded cultist of a mist cult: a tattered gray robe with plum-purple trim, a deep hood that hides the face in shadow with a small red eye glyph painted on the hood, a braided copper rope belt with a metal ring, bandaged forearms, worn brown leather boots, and a curved copper-colored dagger held low in one hand (always the same hand in every frame), arranged left to right in a single row. Every frame shows the same character at the same scale, the same camera angle and the same invisible ground line, evenly spaced with clear empty cyan space between neighbors so that no frame touches or overlaps another and nothing is cropped by the edges. The animation state is 'idle'. Frames from left to right: 1) standing still, neutral idle stance facing right, knees slightly bent, dagger held low, robe hanging still. 2) a faint breathing sway, shoulders rising slightly and the robe hem shifting a little, feet staying planted. 3) a small weight shift from one leg to the other, hood tilting slightly, the robe hem shifting with the leg. 4) returning to the initial neutral idle stance, feet planted, ready to loop back to the first frame. Dark-fantasy isometric pixel-art game sprite, three-quarter isometric angle tilted about 30 degrees from above, the character facing toward the RIGHT side of the image, soft light from the upper left, crisp clean pixel-art rendering with controlled dithering, no blur or anti-aliasing, no motion-blur streaks and no effect lines. Background: a single flat uniform solid cyan color (#00FFFF), no ground, floor, cast shadow, gradient, texture, or scenery. No text, logo, watermark, frame, border, UI, or any other character - only repeated copies of this one character. Critically, the whole silhouette must be solid and fully opaque - no wispy, translucent, faded, or speckled/scattered-pixel appearance anywhere on the body; it must read as one clear, solid, fully-colored figure. Very wide landscape image.
```

### E22 - `cultista_adaga_row_move` - 6 quadros

```text
A wide horizontal sprite strip containing exactly 6 frames of a hooded cultist of a mist cult: a tattered gray robe with plum-purple trim, a deep hood that hides the face in shadow with a small red eye glyph painted on the hood, a braided copper rope belt with a metal ring, bandaged forearms, worn brown leather boots, and a curved copper-colored dagger held low in one hand (always the same hand in every frame), arranged left to right in a single row. Every frame shows the same character at the same scale, the same camera angle and the same invisible ground line, evenly spaced with clear empty cyan space between neighbors so that no frame touches or overlaps another and nothing is cropped by the edges. The animation state is 'move'. Frames from left to right: 1) walk cycle contact frame - the front foot touches the ground ahead and the rear leg is extended behind, the robe hem swinging back, both boots clearly visible. 2) walk cycle down frame - knees bending, weight transferring onto the front leg, torso at its lowest point, the rear boot lifting. 3) walk cycle passing frame - the rear foot swinging forward past the supporting leg, the robe hem swirling, both boots visible. 4) walk cycle contact frame with the OTHER foot in front - legs mirrored from the first frame, robe hem swinging back, both boots clearly visible. 5) walk cycle down frame - weight transferring onto the new front leg, torso at its lowest point, the rear boot lifting. 6) walk cycle passing frame - the rear foot swinging forward, closing the loop so the next frame is the first contact frame again, base steady with no vertical bounce. Dark-fantasy isometric pixel-art game sprite, three-quarter isometric angle tilted about 30 degrees from above, the character facing toward the RIGHT side of the image, soft light from the upper left, crisp clean pixel-art rendering with controlled dithering, no blur or anti-aliasing, no motion-blur streaks and no effect lines. Background: a single flat uniform solid cyan color (#00FFFF), no ground, floor, cast shadow, gradient, texture, or scenery. No text, logo, watermark, frame, border, UI, or any other character - only repeated copies of this one character. Critically, the whole silhouette must be solid and fully opaque - no wispy, translucent, faded, or speckled/scattered-pixel appearance anywhere on the body; it must read as one clear, solid, fully-colored figure. Very wide landscape image.
```

### E23 - `cultista_adaga_row_attack` - 4 quadros

```text
A wide horizontal sprite strip containing exactly 4 frames of a hooded cultist of a mist cult: a tattered gray robe with plum-purple trim, a deep hood that hides the face in shadow with a small red eye glyph painted on the hood, a braided copper rope belt with a metal ring, bandaged forearms, worn brown leather boots, and a curved copper-colored dagger held low in one hand (always the same hand in every frame), arranged left to right in a single row. Every frame shows the same character at the same scale, the same camera angle and the same invisible ground line, evenly spaced with clear empty cyan space between neighbors so that no frame touches or overlaps another and nothing is cropped by the edges. The animation state is 'attack'. Frames from left to right: 1) attack wind-up - crouching slightly, the dagger arm pulled back behind the body, weight on the rear leg. 2) the start of a forward lunge - front foot stepping forward, body leaning aggressively toward the right, dagger arm beginning to swing. 3) the strike - the dagger thrust forward at full arm extension, body fully stretched into the lunge, full silhouette clearly visible. 4) recovery - pulling the dagger back and straightening up, returning toward the neutral stance. Dark-fantasy isometric pixel-art game sprite, three-quarter isometric angle tilted about 30 degrees from above, the character facing toward the RIGHT side of the image, soft light from the upper left, crisp clean pixel-art rendering with controlled dithering, no blur or anti-aliasing, no motion-blur streaks and no effect lines. Background: a single flat uniform solid cyan color (#00FFFF), no ground, floor, cast shadow, gradient, texture, or scenery. No text, logo, watermark, frame, border, UI, or any other character - only repeated copies of this one character. Critically, the whole silhouette must be solid and fully opaque - no wispy, translucent, faded, or speckled/scattered-pixel appearance anywhere on the body; it must read as one clear, solid, fully-colored figure. Very wide landscape image.
```

### E24 - `cultista_adaga_row_death` - 6 quadros

```text
A wide horizontal sprite strip containing exactly 6 frames of a hooded cultist of a mist cult: a tattered gray robe with plum-purple trim, a deep hood that hides the face in shadow with a small red eye glyph painted on the hood, a braided copper rope belt with a metal ring, bandaged forearms, worn brown leather boots, and a curved copper-colored dagger held low in one hand (always the same hand in every frame), arranged left to right in a single row. Every frame shows the same character at the same scale, the same camera angle and the same invisible ground line, evenly spaced with clear empty cyan space between neighbors so that no frame touches or overlaps another and nothing is cropped by the edges. The animation state is 'death'. Frames from left to right: 1) reacting to a fatal blow - the body recoiling, head thrown back slightly, the dagger starting to slip. 2) the knees buckling, the torso tilting forward, the dagger falling from the hand. 3) dropping to the knees, one hand touching the ground, hood hanging low. 4) half fallen, the body tipping onto its side, silhouette still readable as the same character. 5) nearly collapsed on the ground, the robe spread around the body, no dismemberment. 6) final resting pose - motionless on the ground, body fully intact, the dagger lying beside the hand, the robe spread out. Dark-fantasy isometric pixel-art game sprite, three-quarter isometric angle tilted about 30 degrees from above, the character facing toward the RIGHT side of the image, soft light from the upper left, crisp clean pixel-art rendering with controlled dithering, no blur or anti-aliasing, no motion-blur streaks and no effect lines. Background: a single flat uniform solid cyan color (#00FFFF), no ground, floor, cast shadow, gradient, texture, or scenery. No text, logo, watermark, frame, border, UI, or any other character - only repeated copies of this one character. Critically, the whole silhouette must be solid and fully opaque - no wispy, translucent, faded, or speckled/scattered-pixel appearance anywhere on the body; it must read as one clear, solid, fully-colored figure. Very wide landscape image.
```

## Como comparar (régua do Zumbi)

| Critério | Meta |
|---|---|
| Solidez de opacidade (`tools/audit_alpha_solidity.gd`) | ≥ 0,90 |
| Identidade igual à arte oficial | cor, capuz, glifo, corda, mão da adaga |
| Direção | todos os quadros voltados para a direita |
| Escala | sem salto de altura entre quadros do mesmo estado |
| Pernas | botas visíveis e alternando no `move`; ciclo fecha sem pulo |
| Trabalho manual | anotar minutos de recorte e ajuste por método |
| Custo | nº de imagens e de regenerações por método |

Vence o método que atingir a régua com menos regenerações e menos ajuste manual. Se o método 2 falhar na consistência ou no recorte automático, as demais ondas seguem o método 1.

## Gate

Preparado, não executado. Nada entra em `assets/` sem aprovação explícita do dono, prancha de revisão, backup e conferência numa run real.
