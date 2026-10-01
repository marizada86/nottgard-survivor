---
id: "ART-PROMPTS-052"
type: "prompts-de-arte"
title: "VFX do corpo a corpo — exceções do kit (ART-028)"
status: "pronto para envio depois do piloto; nada gerado"
created: "2026-10-01"
relations: ["[[PLAN-051-vfx-de-ataques-e-magias-2026-10-01]]", "[[CHATGPT-FILA-021-vfx-corpo-a-corpo-excecoes]]", "[[ART-PROMPTS-051-piloto-vfx-corpo-a-corpo-fisico]]"]
sources: ["data/weapons.json", "data/abilities.json", "ui/run.gd", "core/divine_visuals.gd"]
---

# ART-PROMPTS-052 — VFX do corpo a corpo — exceções do kit (ART-028)

Completa o corpo a corpo depois do piloto ([[ART-PROMPTS-051-piloto-vfx-corpo-a-corpo-fisico]]): a estocada longa e três exceções com motivo próprio (chicote, arco radiante, arco de fogo). Só vale depois de o piloto ser aprovado.

Contrato comum (igual ao piloto): fundo preto `#000000`, só o efeito em branco e cinza, sem cor; vista de cima achatada; tela 1024 × 1024, pivô no centro; sem personagem, arma, mão, texto, borda ou chão. A cor vem da tinta em runtime (`DivineVisuals`); motivos como chamas ou raios são desenhados em cinza.

## Alvos

| Código | Efeito | Modelo | Quadros | Cobre |
|---|---|---|---:|---|
| C | Estocada longa | golpe de 6 quadros | 6 | Estocada Mística (mágico, cone 25°, alcance 2,4) |
| D | Chicote | golpe de 6 quadros | 6 | Chicote Avarento (físico, cone 22°, alcance 3,0) |
| E | Arco largo radiante | golpe de 6 quadros | 6 | Golpe do Juízo (cone 120°), Martelo da Glória (cone 90°) |
| F | Arco largo de fogo | golpe de 6 quadros | 6 | Machado de Xar'gath (fogo, cone 100°) |
| | **Total** | | **24** | |

## Descrição de cada efeito

- **C — Estocada longa:** a long straight thin thrust, a narrow spear-like streak of light about 25 degrees wide that tapers sharply to a point, reach about 45 percent of the image width, with a few tiny faint circular glyph marks glinting along its length.
- **D — Chicote:** a long thin whip lash: a slender S-shaped curved line snapping outward, ending in a tiny bright crack burst at the tip, very thin and fast, reach about 45 percent of the image width.
- **E — Arco largo radiante:** a very wide sweeping arc of about 220 degrees made of a bright thick band with short radiating light rays and tiny star-shaped glints along its outer edge, holy and heavy, reach about 45 percent of the image width.
- **F — Arco largo de fogo:** a very wide sweeping arc of about 200 degrees, a thick band whose outer rim has flame-like licking tongues and small embers drifting off it, heavy and infernal, reach about 45 percent of the image width.

## Critérios de aprovação

- Fundo realmente preto, sem degradê; sem cor; sem personagem ou texto.
- Os quadros do mesmo efeito parecem o mesmo desenho: mesma espessura, brilho e textura.
- Golpes, rastros e projéteis apontam para a direita; pulsos e ciclos são simétricos e centrados.
- Ciclos de 4 ou 6 quadros fecham sem salto visível do último para o primeiro.
- Legível a 96 px de largura.

## Rejeição imediata

Cor saturada, fundo não preto, arma ou mão visível, efeito virado para outra direção, estilos diferentes entre quadros, perspectiva em vez de vista de cima.

Texto integral dos prompts em [[CHATGPT-FILA-021-vfx-corpo-a-corpo-excecoes]].
