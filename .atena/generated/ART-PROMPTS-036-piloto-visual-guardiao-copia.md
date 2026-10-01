---
id: "ART-PROMPTS-036"
type: "prompts-de-arte"
title: "Piloto visual de animação — guardiao_copia"
status: "3 quadros do piloto aprovados; geração e transferência das 23 referências adicionais autorizadas pela SPEC-108"
created: "2026-09-30"
relations:
  - "[[SPEC-107-piloto-visual-guardiao-copia]]"
  - "[[PLAN-048-geracao-animacoes-mobs-onda-1-2026-09-30]]"
  - "[[EVID-134-lote-c-mobs-2026-09-30]]"
  - "[[EVID-135-piloto-guardiao-copia-2026-09-30]]"
sources:
  - "assets/enemies/guardiao_copia.png"
  - ".atena/generated/art-candidates/enemies-wave-1/guardiao_verdadeiro/frames/guardiao_verdadeiro_idle_00_v01.png"
  - ".atena/generated/art-candidates/enemies-wave-1/guardiao_verdadeiro/frames/guardiao_verdadeiro_attack_02_v01.png"
  - ".atena/generated/art-candidates/enemies-wave-1/guardiao_verdadeiro/frames/guardiao_verdadeiro_death_05_v02.png"
---

# ART-PROMPTS-036 — Piloto do `guardiao_copia`

## Referências e destino

Em cada chamada, usar a arte estática oficial `guardiao_copia.png` como
referência 1, somente para identidade, paleta, armadura, asas e arma. Usar o
quadro aprovado correspondente de `guardiao_verdadeiro` como referência 2,
somente para pose, ação, composição e ancoragem. Não transferir a identidade do
verdadeiro para a cópia. A SPEC-107 foi aprovada; enviar essas referências ao
ImageGen somente após autorização explícita da transferência dos quatro
arquivos listados no frontmatter.

## Base fixa

```text
Use Image 1 as the exact character identity reference: guardiao_copia. Preserve its muted gray/silver armor, dark charcoal-gray wings, gold circular emblems and trim, face, proportions, and its own short diagonally held gold-and-steel spear. Use Image 2 only as a pose and composition reference. Transfer the body pose, action, camera, facing, and bottom anchor from Image 2, but do not transfer Image 2's purple runes, violet glow, violet feather veins, bright eyes, or long crystal-tipped staff. Create exactly one independent full-body 2D game animation frame, not a strip or contact sheet. Dark-fantasy pixel art, crisp pixel edges, controlled dithering, three-quarter front view facing right. Center the whole character in a tall 2:3 frame matching a 320x480 game cell; preserve coherent character scale and a stable bottom visual anchor. Transparent RGBA background. No ground, cast shadow, scenery, gradient, text, logo, watermark, border, UI, extra character, blur, antialiasing, motion lines, loose particles, detached magic, detached body parts, redesign, cropping, or weapon replacement. Keep all body parts, wings, and the spear inside the canvas.
```

## `guardiao_copia_idle_00_pilot_v01.png`

Image 2: `guardiao_verdadeiro_idle_00_v01.png`. Use the approved neutral upright
pose, but keep the copy's own short diagonal spear and muted identity. The
result is a calm, readable neutral stance; do not add violet energy or ornament.

## `guardiao_copia_attack_02_pilot_v01.png`

Image 2: `guardiao_verdadeiro_attack_02_v01.png`. Use its forward-thrust apex,
torso rotation, and leg placement as pose only. Keep the weapon recognizably the
copy's shorter gold-and-steel spear; adapt grip and hands to that weapon without
turning it into the true guardian's long crystal staff. Make the attack legible
without particles or detached effects.

## `guardiao_copia_death_05_pilot_v01.png`

Image 2: `guardiao_verdadeiro_death_05_v02.png`. Use its final compact fallen
pose and low wing arrangement as pose only. Keep the copy's gray/gold palette
and short spear in hand, with the whole figure and weapon visible; no purple
glow, crystal staff, or detached effects.

## Postprocess

Generate as a single 2:3 frame at 1024×1536 when supported; preserve the
transparent alpha channel and reduce to 320×480 using nearest-neighbor. Keep
the raw result separately from the native candidate, record both paths and
prompt provenance, and never overwrite the source references.

## Resultados

Em 2026-09-30, a SPEC-107 e a transferência das quatro referências foram
aprovadas. Os três prompts foram executados no ImageGen. Originais e destinos
320×480, com QA, hashes e prancha, estão registrados em
[[EVID-135-piloto-guardiao-copia-2026-09-30]]. O dono aprovou as três
amostras e, em 2026-09-30, autorizou gerar as 23 poses restantes conforme
SPEC-108. As imagens permanecem candidatas e fora do runtime; as 23 novas
referências correspondentes foram autorizadas para transferência e a geração
está em curso.
