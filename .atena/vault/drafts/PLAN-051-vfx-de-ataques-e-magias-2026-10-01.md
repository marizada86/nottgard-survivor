---
id: "PLAN-051"
type: "plano"
title: "VFX de ataques, magias e habilidades — kit base com exceções"
status: "decisões D-V1 a D-V4 alinhadas com o dono em 2026-10-01; piloto preparado, nada enviado"
created: "2026-10-01"
relations: ["[[PLAN-041-animacao-padrao-zumbi-para-inimigos-e-interacoes-2026-09-29]]", "[[SPEC-054-vfx-procedural-para-areas-de-terreno]]", "[[SPEC-116-dopamina-tematica]]", "[[ART-PROMPTS-051-piloto-vfx-corpo-a-corpo-fisico]]"]
---

# PLAN-051 — VFX de ataques, magias e habilidades

## Ponto de partida (código em 2026-10-01)

| O quê | Hoje | Onde |
|---|---|---|
| Corpo a corpo (12 armas) | polígono de cone translúcido que some em 0,16 s | `_swing` em `ui/run.gd` |
| Explosão (7) e zona (3) | um anel `Line2D` que cresce | `_ring` em `ui/run.gd` |
| Projétil (8) | sem arte própria | `_fire_bolt` em `core/battle.gd` |
| Habilidades dos 10 heróis | sem visual próprio | `data/abilities.json` |
| Faíscas de impacto, cor por divindade | já existem | `spawn_impact`, `DivineVisuals` |
| `assets/fx/` | só 2 texturas de névoa | — |

## Decisões do dono (2026-10-01)

| ID | Decisão |
|---|---|
| D-V1 | **Kit base + exceções.** Um kit por formato × tipo de dano; arte própria só para evoluções e armas icônicas. |
| D-V2 | **Técnica mista.** Quadros desenhados (6 a 8) para ataques, projéteis e impactos principais, no padrão do Zumbi; partículas e shader em Godot para brilho, rastro e tinta. |
| D-V3 | **Prioridade:** corpo a corpo, projéteis e magias, habilidades dos heróis. Zonas e golpes de inimigos ficam para depois. |
| D-V4 | **Arte neutra + tinta em runtime.** Branco e tons de cinza; o jogo pinta com `DivineVisuals` (herói ou divindade). Um conjunto serve às 7 divindades. |
| D-V5 | **Uma arte girada em runtime**, desenhada apontando para a direita. |
| D-V6 | **Curto:** 6 quadros, cerca de 0,2 s, para corpo a corpo; projétil com 4 quadros de voo em loop e 4 de impacto. |
| D-V7 | **Primeiro entregável:** este plano mais o piloto de corpo a corpo físico, para validar a receita antes do resto. |

## Premissas técnicas (Atena, a confirmar na integração)

- **Fundo preto `#000000`, não ciano.** Efeitos de luz têm bordas suaves; ciano suja o halo. Na integração, a luminância vira alfa e o efeito entra com mistura aditiva. Isso substitui o chroma ciano das filas de mobs.
- **Vista de cima, achatada no chão.** O efeito é desenhado como se visto de cima; o jogo aplica a compressão isométrica 2:1 (`Iso.to_screen`) depois de girar.
- **Pivô no centro da imagem**, efeito apontando para a direita, raio máximo de 45 % da largura. O jogo escala pelo `range` da arma e pelo `cone`.
- **Tela quadrada de 1024 × 1024**, reduzida na admissão.
- **Respeitar "Reduzir efeitos de impacto"** (`Game.reduced_impact()`): com a opção ligada, o efeito usa só o quadro de pico, menos brilho.

## Catálogo e custo estimado

Contagem por `data/weapons.json`. Quadros de 6 por animação, salvo indicação.

| Grupo | Formas do kit | Armas cobertas | Imagens (aprox.) |
|---|---|---|---:|
| Corpo a corpo, físico | corte médio (cone 45–60°: adaga, esmagador, espada sombria, lâmina da digestão, rajada infinita), arco largo (90–100°: atordoante, espada do receptáculo), estocada longa (22–25°: chicote) | 8 físicas | 18 |
| Corpo a corpo, exceções | estocada longa mágica, chicote, arco largo radiante (juízo, martelo), arco largo de fogo (machado) | 5 | 24 |
| Projétil | orbe radiante, orbe arcano e onda cortante (voo 4 + impacto 4 cada) | 8 bolts | 24 |
| Explosão | pulso radiante (6 armas); ampulheta do silêncio como exceção | 7 | 12 |
| Habilidades dos heróis | uma animação de 6 quadros por herói | 10 | 60 |
| Total (piloto de 12 + 120) | | | 132 |

Zonas (cera, tentáculos) e golpes de inimigos e chefes ficam fora deste plano até o dono mandar.

## Ordem

1. **Piloto — corpo a corpo físico** ([[ART-PROMPTS-051-piloto-vfx-corpo-a-corpo-fisico]], [[CHATGPT-FILA-020-piloto-vfx-corpo-a-corpo-fisico]]): 2 formas, 12 imagens. Valida preto, vista de cima, pivô, tinta e quantidade de quadros.
2. Integração mecânica em `ui/run.gd` (não é arte): substituir o `_swing` por uma `AnimatedSprite2D` com tinta e rotação; manter o polígono como alternativa para "efeitos reduzidos".
3. Resto do corpo a corpo (exceções), depois projéteis e explosões, depois habilidades dos heróis.

## Riscos

- Coerência entre quadros de VFX gerados em imagens independentes é pior que a de personagens. O piloto existe para medir isso; o gate de estilo (o quadro de pico) vem primeiro.
- Arte neutra pode ficar sem graça quando tintada de roxo ou verde. Validar no jogo com as 7 cores de `DIVINE_THEMES`.
- Um arco de 200° não casa com o cone de 90° da adaga: por isso o kit tem três formas, não uma.
