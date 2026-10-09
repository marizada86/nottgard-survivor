---
id: "ART-PROMPTS-053"
type: "prompts-de-arte"
title: "VFX de projéteis e explosões (ART-029)"
status: "Orbe radiante oito candidatas revisadas, P01 aprovada; Orbe arcano oito candidatas revisadas, Q01 v03 aprovada; Onda cortante oito candidatas revisadas, R01 v02 aprovada; push concluído e verificado; N03 v01 pico aprovado; commit/push solicitado antes dos cinco demais N; M03 pendente; EVID-145"
created: "2026-10-01"
relations: ["[[PLAN-051-vfx-de-ataques-e-magias-2026-10-01]]", "[[CHATGPT-FILA-022-vfx-projeteis-e-explosoes]]", "[[ART-PROMPTS-051-piloto-vfx-corpo-a-corpo-fisico]]"]
sources: ["data/weapons.json", "data/abilities.json", "ui/run.gd", "core/divine_visuals.gd"]
---

# ART-PROMPTS-053 — VFX de projéteis e explosões (ART-029)

Projéteis (voo em 4 quadros em ciclo mais impacto em 4) e explosões em anel. Depende da aprovação do piloto de corpo a corpo.

Contrato comum (igual ao piloto): fundo preto `#000000`, só o efeito em branco e cinza, sem cor; vista de cima achatada; tela 1024 × 1024, pivô no centro; sem personagem, arma, mão, texto, borda ou chão. A cor vem da tinta em runtime (`DivineVisuals`); motivos como chamas ou raios são desenhados em cinza.

## Alvos

| Código | Efeito | Modelo | Quadros | Cobre |
|---|---|---|---:|---|
| P | Orbe radiante | voo de 4 quadros e impacto de 4 | 8 | Raio de Luz, Luz Mais Pura, Marca da Retidão (radiante) |
| Q | Orbe arcano | voo de 4 quadros e impacto de 4 | 8 | Raio Enfraquecedor, Dominar Pessoa, Cajado dos Desejos (mágico) |
| R | Onda cortante | voo de 4 quadros e impacto de 4 | 8 | Lâmina Trovejante, Tempestade (mágico) |
| N | Pulso radiante | pulso de 6 quadros | 6 | Sentença de Lliira, Julgamento da Glória, Descarga Estelar, Chuva de Estrelas, Vela Sagrada, Sopro de Estrela (radiante) |
| M | Ampulheta do silêncio | pulso de 6 quadros | 6 | Ampulheta do Silêncio Eterno (mágico, raio 4,0) |
| | **Total** | | **36** | |

## Descrição de cada efeito

- **P — Orbe radiante:** a round glowing orb of holy light with a bright white core and a soft halo, a short pointed tail behind it pointing LEFT because it flies to the RIGHT, and a few tiny star-like sparks.
- **Q — Orbe arcano:** a swirling arcane orb: a small dense bright core inside a thin rotating ring with tiny circular glyph marks on the ring, and a wispy smoky trail pointing LEFT because it flies to the RIGHT.
- **R — Onda cortante:** a thin crescent blade of energy, curved with its tips pointing backward to the LEFT because it flies to the RIGHT, with fine jagged lightning crackling along its edge.
- **N — Pulso radiante:** a perfectly round, centered pulse of light on the ground: a bright thin ring with a softer wide band just inside it and short light rays pointing outward.
- **M — Ampulheta do silêncio:** a perfectly round, centered zone of stillness: a thin ring with faint hourglass shapes spaced around it and fine falling sand grains drifting, a calm quiet glow rather than an explosion.

## Critérios de aprovação

- Fundo realmente preto, sem degradê; sem cor; sem personagem ou texto.
- Os quadros do mesmo efeito parecem o mesmo desenho: mesma espessura, brilho e textura.
- Golpes, rastros e projéteis apontam para a direita; pulsos e ciclos são simétricos e centrados.
- Ciclos de 4 ou 6 quadros fecham sem salto visível do último para o primeiro.
- Legível a 96 px de largura.

## Rejeição imediata

Cor saturada, fundo não preto, arma ou mão visível, efeito virado para outra direção, estilos diferentes entre quadros, perspectiva em vez de vista de cima.

Texto integral dos prompts em [[CHATGPT-FILA-022-vfx-projeteis-e-explosoes]].
