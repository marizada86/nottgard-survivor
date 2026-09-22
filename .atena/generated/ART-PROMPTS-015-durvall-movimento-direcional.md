---
id: "ART-PROMPTS-015"
type: "prompts-de-arte"
title: "Durvall — movimento em oito direções"
status: "generated-and-integrated"
created: "2026-09-22"
relations: ["[[ART-PROMPTS-014-animacao-dagruve-piloto]]", "[[SPEC-018-direcoes-de-movimento-durvall]]"]
sources: ["assets/heroes/durvall.png", "assets/animations/heroes/durvall/move.png"]
---

# Durvall — movimento em oito direções

## Bloco comum obrigatório

Use case: `stylized-concept`. Asset type: folha-fonte de animação direcional para jogo 2D isométrico. A primeira imagem anexada é a referência obrigatória da identidade visual de Durvall; a segunda é a referência obrigatória de acabamento, escala e ritmo da animação de caminhada existente. Preservar exatamente o elfo sombrio de cabelo branco, armadura preta laminada, faixa e capa vinho, espada azul brilhante, pintura pixel-art detalhada, câmera três-quartos isométrica e luz superior esquerda. Fundo com alfa real; corpo inteiro; mesma linha de base, escala e recorte em todos os quadros; nenhum quadro invade outro. Sem cenário, piso, sombra projetada, texto, rótulo, grade, borda, watermark, motion blur, membro extra, objeto duplicado ou redesign.

Cada linha é uma chamada independente. Produzir exatamente 6 quadros cronológicos em grade limpa 3 colunas × 2 linhas. Corrida isométrica controlada, passada legível e espada segura. A direção é a direção visual na tela, não a direção do chão do jogo.

| Sequência | Direção visual em tela |
|---|---|
| `move_n` | para cima |
| `move_ne` | para cima e direita |
| `move_e` | para a direita |
| `move_se` | para baixo e direita |
| `move_s` | para baixo |
| `move_sw` | para baixo e esquerda |
| `move_w` | para a esquerda |
| `move_nw` | para cima e esquerda |

## Aceite visual

- A direção lida imediatamente na altura de jogo.
- Primeiro e último quadro conectam em loop sem salto de base ou escala.
- Alfa verdadeiro sem halo preto, branco ou vermelho.
- Roupa, rosto, cabelo, espada e câmera permanecem os mesmos entre todas as direções.
