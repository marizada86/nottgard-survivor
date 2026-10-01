---
id: "ART-PROMPTS-033"
type: "prompts-de-arte"
title: "Ciclos de animação dos mobs — Onda 1, Lote A"
status: "80 quadros candidatos aprovados visualmente pelo dono em 2026-09-30"
created: "2026-09-30"
relations: ["[[PLAN-048-geracao-animacoes-mobs-onda-1-2026-09-30]]", "[[EVID-127-mobs-wave-1-gate-identidade-2026-09-30]]", "[[CANDIDATES-MANIFEST-003]]"]
---

# ART-PROMPTS-033 — Ciclos do Lote A

## Referências e destino

Para cada quadro, anexar a arte oficial de `assets/enemies/<id>.png` e o
`idle_00` aprovado de `.atena/generated/art-candidates/enemies-wave-1/<id>/`.
Gerar uma imagem independente em orientação para a direita, transparente, com
o mesmo tamanho de tela retrato das identidades. Salvar em
`.atena/generated/art-candidates/enemies-wave-1/<id>/<id>_<estado>_<quadro>_v01.png`.

## Identidades fixas por alvo

- `slime_corrosivo`: massa alta, assimétrica e viscosa amarelo-esverdeada,
  bolhas, veios roxos, boca serrilhada e correia metálica rompida; criatura sem
  pernas, base larga aderida ao chão.
- `cultista_arqueiro`: capuz azul-acinzentado, símbolos de cera amarela, mantos
  e faixas ameixa, botas marrons e arco de madeira escura; flecha e arco ficam
  sempre na mesma mão.
- `cultista_cajado`: robe azul-escuro e ameixa coberto de cera, capuz com olho
  dourado, cajado retorcido e lampião aceso; altura alta e estreita.
- `notivago`: humanoide curvado azul-acinzentado, olho laranja, roupa escura
  rasgada, braços longos com garras e faixas sólidas de névoa roxa nos ombros.

## Base fixa para cada prompt

```text
Use the two attached images as references: preserve the exact character identity from the static sprite, and match the approved idle frame for proportions, palette, scale, camera and facing. Create exactly one full-body animation frame. Dark-fantasy isometric pixel art, three-quarter front view, facing RIGHT, crisp controlled dithering, clean pixel edges. Centered in a tall 2:3 frame with the visual base at the bottom and at least 8% side margin. Truly transparent background. The complete silhouette is solid and opaque; keep slime, mist, cloth, and effects attached to the character. No ground, cast shadow, scenery, gradient, text, logo, watermark, frame, UI, second character, blur, motion streaks, or loose particles. Keep the same apparent scale as the approved identity frame.
```

## Quadro a quadro

For each target, generate the following poses. Numbering is zero-based and
the approved identity is `idle_00`.

### Idle

- `idle_01`: gentle breathing or subtle surface/cloth movement, feet/base fixed.
- `idle_02`: small weight shift or contained organic pulse; preserve the
  silhouette and bottom anchor.
- `idle_03`: settle into the approved `idle_00` pose so the loop closes cleanly.

### Move

- `move_00`: first contact; lead foot reaches forward (or slime front edge
  flows forward), rear side trails; both feet remain visible on humanoids.
- `move_01`: weight transfers; knees/body lower slightly or slime compresses.
- `move_02`: passing pose; trailing foot/side passes the planted support.
- `move_03`: opposite contact with the other leg/side forward.
- `move_04`: transfer onto the opposite support, with a restrained body dip.
- `move_05`: passing/closing pose, ready to return to `move_00` without a jump.

### Attack

- `attack_00`: clear anticipation pose. Archer draws the bow; staff cultist
  raises the lamp/staff; Notívago lowers its shoulders; slime draws its upper
  mass back.
- `attack_01`: the action begins. Archer releases; staff cultist points the
  staff; Notívago lunges; slime leans its mouth forward.
- `attack_02`: readable point of impact/release, without separate projectile,
  spell circle, splash, or detached effect.
- `attack_03`: restrained recovery, returning toward the neutral stance.

### Death

- `death_00`: receives impact; clear but compact reaction.
- `death_01`: knees/structure begin to buckle.
- `death_02`: falls lower, losing balance.
- `death_03`: semi-fallen pose, full silhouette still inside the frame.
- `death_04`: collapses onto the base; slime settles into itself.
- `death_05`: final still pose, fully visible and suitable as the last frame.

The common pose notes adapt to anatomy, but never change the approved identity.
For the archer, keep the bow, arrow and hands anatomically coherent. For the
staff cultist, keep the staff and lantern attached and do not create VFX. For
the Notívago, keep both claws visible when the pose allows it. For the slime,
preserve the mouth, purple veins and belt; do not invent limbs or detached
splashes. Do not mirror images: game integration handles movement facing.
