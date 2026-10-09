---
id: "ART-PROMPTS-054"
type: "prompts-de-arte"
title: "VFX das habilidades dos 10 heróis (ART-030)"
status: "H103 v01 pico candidato, gate humano pendente; FILA0231/60 geradas,59 restantes; sem runtime"
created: "2026-10-01"
relations: ["[[PLAN-051-vfx-de-ataques-e-magias-2026-10-01]]", "[[CHATGPT-FILA-023-vfx-habilidades-dos-herois]]", "[[ART-PROMPTS-051-piloto-vfx-corpo-a-corpo-fisico]]"]
sources: ["data/weapons.json", "data/abilities.json", "ui/run.gd", "core/divine_visuals.gd"]
---

# ART-PROMPTS-054 — VFX das habilidades dos 10 heróis (ART-030)

Uma animação de 6 quadros por habilidade ativa. As áreas e os projéteis das habilidades que já usam o kit (a guarda de Brook responde com pulso radiante, a constelação de Leoric dispara orbes radiantes) reaproveitam os efeitos das filas 020 a 022. Depende do piloto.

Contrato comum (igual ao piloto): fundo preto `#000000`, só o efeito em branco e cinza, sem cor; vista de cima achatada; tela 1024 × 1024, pivô no centro; sem personagem, arma, mão, texto, borda ou chão. A cor vem da tinta em runtime (`DivineVisuals`); motivos como chamas ou raios são desenhados em cinza.

## Alvos

| Código | Efeito | Modelo | Quadros | Cobre |
|---|---|---|---:|---|
| H1 | Durvall: Ruptura Sombria | golpe de 6 quadros | 6 | cleave físico, alcance 3,2, cone 85° |
| H2 | Brook: Guarda de Lliira | ciclo de 6 quadros | 6 | guard, 4 s, bloqueia um golpe |
| H3 | Maelor: Comunhão | ciclo de 6 quadros | 6 | healing_aura radiante, raio 3,2 |
| H4 | Sylas: Passo pelas Sombras | rastro de 6 quadros | 6 | dash_weaken mágico, distância 3,5 |
| H5 | Kayron: Sobrecarga Mística | ciclo de 6 quadros | 6 | overdrive, 7 s, acelera as armas |
| H6 | Korrak: Impacto de Xar'gath | pulso de 6 quadros | 6 | slam fogo, raio 3,0 |
| H7 | Leoric: Constelação | pulso de 6 quadros | 6 | star_burst radiante, 8 projéteis |
| H8 | Nyrelia: Dominação | ciclo de 6 quadros | 6 | charm, 7 s, converte um inimigo |
| H9 | Zynara: Suspensão Temporal | pulso de 6 quadros | 6 | time_stop, 4 s, raio 7,0 |
| H10 | Bromnor: Concórdia | pulso de 6 quadros | 6 | guard_nova radiante, raio 3,5, repele |
| | **Total** | | **60** | |

## Descrição de cada efeito

- **H1 — Durvall: Ruptura Sombria:** a huge heavy cleaving rift: a wide sweeping cut of about 170 degrees with a jagged torn line ripping through the middle of the band, like armor being split open, thin dark cracks inside the bright band, reach about 45 percent of the image width.
- **H2 — Brook: Guarda de Lliira:** a protective dome barrier seen from above: a round translucent shield ring around the center with a soft inner glow and small three-pointed star marks spaced on the rim, calm and steady.
- **H3 — Maelor: Comunhão:** a gentle healing aura: a wide soft circle of light with small plus-shaped sparkles rising and drifting outward, and a slow pulsing ring.
- **H4 — Sylas: Passo pelas Sombras:** a ribbon of shadow smoke: a long tapering streak with wispy torn ends, like the trail left by a very fast dash through shadows, with a few sharp narrow mask-shaped glints, reach about 45 percent of the image width.
- **H5 — Kayron: Sobrecarga Mística:** a crackling energy aura: jagged electric arcs spiraling around an empty center, fast and chaotic yet circular, bright white lightning with fine branches.
- **H6 — Korrak: Impacto de Xar'gath:** a ground slam: a thick shockwave ring with radial cracks spreading across the ground and a burst of flame tongues rising from the center, ember specks flying outward.
- **H7 — Leoric: Constelação:** a constellation burst: eight bright star points radiating outward from the center, with thin lines connecting neighboring stars, like a star map exploding outward.
- **H8 — Nyrelia: Dominação:** a hypnotic charm sigil: a spiral eye-like glyph made of concentric thin rings with a small bright pupil at the center, lying flat and slowly rotating.
- **H9 — Zynara: Suspensão Temporal:** a time-stop field: a very large circle with clock-like tick marks around the rim, two thin clock hands at the center, and frozen shard-like fragments hanging around, an eerie stillness.
- **H10 — Bromnor: Concórdia:** a shield-shaped shockwave: a bright expanding ring with a sturdy shield emblem silhouette at the center and short outward-pushing chevron arrows along the ring.

## Critérios de aprovação

- Fundo realmente preto, sem degradê; sem cor; sem personagem ou texto.
- Os quadros do mesmo efeito parecem o mesmo desenho: mesma espessura, brilho e textura.
- Golpes, rastros e projéteis apontam para a direita; pulsos e ciclos são simétricos e centrados.
- Ciclos de 4 ou 6 quadros fecham sem salto visível do último para o primeiro.
- Legível a 96 px de largura.

## Rejeição imediata

Cor saturada, fundo não preto, arma ou mão visível, efeito virado para outra direção, estilos diferentes entre quadros, perspectiva em vez de vista de cima.

Texto integral dos prompts em [[CHATGPT-FILA-023-vfx-habilidades-dos-herois]].
