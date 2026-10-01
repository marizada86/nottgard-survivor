---
id: "ART-PROMPTS-034"
type: "prompts-de-arte"
title: "Ciclos de animação dos mobs — Onda 1, Lote B"
status: "40 quadros candidatos aprovados pelo dono em 2026-09-30"
created: "2026-09-30"
relations: ["[[PLAN-048-geracao-animacoes-mobs-onda-1-2026-09-30]]", "[[EVID-128-lote-a-animacoes-mobs-2026-09-30]]", "[[CANDIDATES-MANIFEST-003]]"]
sources: ["assets/enemies/criatura_corrompida.png", "assets/enemies/arch_hag.png"]
---

# ART-PROMPTS-034 — Ciclos do Lote B

## Referências e destino

Em cada geração, anexar duas referências: (1) arte estática oficial em
`assets/enemies/<id>.png`, para preservar identidade; (2) o `idle_00` já
aprovado em `.atena/generated/art-candidates/enemies-wave-1/<id>/`, para escala,
proporção, orientação e acabamento. Gerar uma imagem independente por ID. O
`idle_00` aprovado será redimensionado para a célula nativa e incluído no ciclo;
gerar apenas `idle_01` a `idle_03`, `move_00` a `move_05`, `attack_00` a
`attack_03` e `death_00` a `death_05` (19 gerações novas por mob). Destino final:
`.atena/generated/art-candidates/enemies-wave-1/<id>/frames/`.

## Base fixa para cada prompt

```text
Use case: stylized-concept
Asset type: full-body 2D game animation sprite frame
Primary request: create exactly one frame from the named animation pose.
Input images: Image 1: official static sprite, exact identity reference; Image 2: approved idle_00, scale, proportion, palette, camera and facing reference.
Style/medium: dark-fantasy isometric pixel art, three-quarter front view, crisp pixel edges and controlled dithering.
Composition/framing: single full-body figure centered in a tall 2:3 frame; facing RIGHT; visual base at the bottom; preserve the approved apparent scale and at least 8% side margin.
Constraints: genuinely transparent background; full opaque character silhouette including smoke, cloth, moss and flame; no ground, cast shadow, scenery, gradient, text, logo, watermark, border, UI, second character, blur, motion streaks, loose particles, detached magic, or detached body parts. Do not mirror or redesign the character. Preserve exact identity, palette, props, camera and frame scale from the references.
```

Output should be 1024×1536 RGBA before nearest-neighbor reduction to the
256×384 native cell. Keep the base anchor and apparent height consistent within
each 20-frame cycle. One generated image per prompt ID; no sprite strips.

## I05 — `criatura_corrompida`

Keep the approved hunched humanoid: ash-gray muscular body, magenta eyes, violet
veins and tendons, long red claws, ragged brown waist wraps, and dense gray
smoke curls attached around head, arms and feet. No added limbs, weapons,
projectiles or smoke clouds. Smoke stays opaque and attached to the same figure.

## I06 — `arch_hag`

Keep the approved thin sea-witch: pale elderly face, long white hair, dark naval
robes with green seaweed, netting, shells and tokens, crooked staff with hanging
lantern, and the small green-blue flame already belonging to the raised free
hand. The staff and lantern remain attached and anatomically coherent. No new
spell projectile, aura or loose particles.

## Poses, in order

### Idle (`idle_01`–`idle_03`)

- `idle_01`: gentle breathing; fixed feet/base; only slight hair, robe or
  attached-smoke settling.
- `idle_02`: small contained weight shift; preserve silhouette, held props and
  bottom anchor.
- `idle_03`: settle naturally back toward approved `idle_00` for a clean loop.

### Move (`move_00`–`move_05`)

- `move_00`: first contact; lead foot steps right, rear side trails; keep both
  feet and the full attached smoke silhouette visible.
- `move_01`: weight transfers; knees and torso lower slightly.
- `move_02`: passing pose; trailing foot passes the planted support.
- `move_03`: opposite contact, other leg forward; staff stays gripped and
  lantern hangs from it.
- `move_04`: transfer onto opposite support with a restrained body dip.
- `move_05`: passing/closing pose, ready to return to `move_00` without a jump.

For the witch, the free hand and small intrinsic flame stay controlled while
the robe and hair lag slightly. For the corrupted creature, move the long legs
and arms with a hunched gait; keep both claws visible where the anatomy allows.

### Attack (`attack_00`–`attack_03`)

- `attack_00`: anticipation; corrupted creature draws shoulders and claws back;
  witch raises her staff/free hand into a readable preparation pose.
- `attack_01`: action begins; corrupted creature lunges with both claws; witch
  thrusts the staff/hand forward. No projectile.
- `attack_02`: clear impact/release pose, expressed by body posture only; no
  target, splash, spell circle or detached VFX.
- `attack_03`: restrained recovery toward neutral stance; props remain held.

### Death (`death_00`–`death_05`)

- `death_00`: compact reaction to impact.
- `death_01`: knees and shoulders begin to buckle.
- `death_02`: loses balance and falls lower.
- `death_03`: semi-fallen, with the complete silhouette inside the frame.
- `death_04`: collapses onto its base; keep smoke attached; staff and lantern
  remain attached to the witch's hand/arm.
- `death_05`: final still pose, fully visible and suitable as the last frame.

Do not depict gore, dismemberment, loose props, extra figures, environmental
effects or left-facing poses. Preserve the identity silhouette throughout.
