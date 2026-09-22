---
id: "ART-PROMPTS-012"
type: "prompts-de-arte"
title: "Ícones de habilidades, regras de camada e pickups"
status: "approved-for-generation"
created: "2026-09-22"
relations: ["[[ART-PROMPTS-001-direcao-e-piloto]]", "[[SPEC-012-identidade-e-decisao]]", "[[SPEC-013-risco-e-camadas]]", "[[SPEC-015-producao-total-de-assets-visuais]]"]
sources: ["data/abilities.json", "data/stage_rules.json", "core/battle.gd", "vault Nottgard"]
---

# Habilidades, regras e pickups

## Bloco comum de ícones

```text
Use case: stylized-concept
Asset type: ícone de gameplay para Nottgard Survivors
Style/medium: pixel art sombria de alto contraste, contorno escuro grosso, materiais legíveis, poucos blocos de cor
Composition/framing: um símbolo ou gesto central, 18% de margem, silhueta clara a 32–48 px
Lighting/mood: luz superior esquerda, atmosfera abissal contida
Constraints: fundo realmente transparente; sem texto, letras, números, círculo de fundo, moldura, cenário, logotipo ou marca-d'água
```

Matriz 1024×1024; final 128×128 RGBA.

## Habilidades ativas — `assets/icons/abilities/<id>.png`

| ID | Pedido específico |
|---|---|
| `ruptura_sombria` | Espada negra abrindo rasgo angular azul-branco numa placa de armadura. |
| `guarda_de_lliira` | Escudo de aço escuro recebendo impacto e devolvendo fita radiante dourada e colorida. |
| `comunhao` | Duas mãos protegendo coração azul-claro cercado por aura circular curta e uma marca dourada. |
| `passo_pelas_sombras` | Bota/manto atravessando fenda violeta com duas pós-imagens compactas. |
| `sobrecarga_mistica` | Três armas simplificadas orbitando núcleo estelar azul-branco acelerado. |
| `impacto_de_xargath` | Machado negro atingindo o chão, explosão vermelha curta e gota de vida retornando à lâmina. |
| `constelacao` | Oito estrelas azul-brancas ligadas por fios finos em explosão radial compacta. |
| `dominacao` | Máscara escura presa por fios amarelos a uma pequena silhueta controlada, sem rosto real. |
| `suspensao_temporal` | Ampulheta negra com areia imóvel dentro de dois arcos de tempo interrompidos. |
| `concordia` | Martelo anão e escudo unidos por onda dourada/prateada que empurra para fora. |

## Regras de camada — `assets/icons/stages/<stage_id>_<rule>.png`

| ID | Pedido específico |
|---|---|
| `dagruve_rituals` | Selo roxo geométrico interrompido por pé/âncora central, velas âmbar mínimas. |
| `shedaklah_puddles` | Poça verde-violeta crescendo em três anéis orgânicos com esporo rosa. |
| `molor_bubbles` | Três bolhas verde-ácido prestes a explodir, setas de empurrão sem letras. |
| `durao_current` | Corrente azul de almas arrastando três fragmentos na mesma direção. |
| `feng_tu_strikes` | Estrela do Norte lançando raio azul-branco sobre marca vermelha de chão. |
| `shendilavri_illusions` | Duas silhuetas de súcubo sobrepostas, uma sólida e uma magenta translúcida. |
| `goranthis_sanctuary` | Fonte de mármore dividida: metade cura verde-água, metade revela carne/slime. |
| `pilares_rotation` | Quatro símbolos abissais simples girando ao redor de monólito violeta. |

## Pickups — `assets/pickups/<id>.png`

Matriz 1024×1024; final 64×64 RGBA. Um objeto flutuante central, sem chão.

| ID | Pedido específico |
|---|---|
| `xp_shard` | Fragmento cristalino azul-ciano pequeno apontando para cima, núcleo branco discreto. |
| `gold_coin` | Moeda antiga dourada grossa com entalhe geométrico não textual, vista três quartos. |
| `health_potion` | Frasco curto de vidro escuro com líquido vermelho, rolha cinza e brilho âmbar mínimo. |

Aceite: ícones legíveis em escala de cinza; regras diferenciadas por forma; pickups reconhecíveis a 16–24 px.

