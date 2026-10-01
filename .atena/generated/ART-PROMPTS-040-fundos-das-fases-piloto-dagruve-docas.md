---
id: "ART-PROMPTS-040"
type: "prompts-de-arte"
title: "Fundos das fases piloto (Dagruve e Docas)"
status: "ready-for-generation"
created: "2026-10-01"
relations: ["[[SPEC-115-riqueza-de-cenario-piloto-dagruve-docas]]", "[[ART-PROMPTS-039-miniatura-das-docas]]", "[[ART-PROMPTS-026-lote-2-camada-de-cenario-por-bioma]]"]
sources: ["backlog ART-025", "data/stages.json", "assets/stages/dagruve_thumb.png", "assets/tiles/*_ground_atlas_v*.png"]
---

# Fundos das fases piloto (ART-025)

Fundo coerente com o novo cenário (estrada, carroça, cais, selo, guindaste). Vista de cima/três-quartos como o piso do jogo, **sem personagens, sem texto**.
Cada imagem é uma composição de referência e de piso: zonas legíveis (estrada, praça, cais) que o layout de `data/scenery.json` vai seguir.
Matriz 1536×1024; opaca RGB; recorte final decidido na admissão. Âncora: miniatura da fase (`assets/stages/<id>_thumb.png`).

## `dagruve_fundo`

```text
Use case: stylized-concept
Asset type: fundo de fase de jogo (vista de cima, três quartos)
Primary request: distrito negligenciado coberto de névoa baixa, uma rua de pedra irregular cruzando a imagem de lado a lado, uma praça central de pedra com um selo ritual desenhado no chão, paredes de casas arruinadas nas bordas, poças escuras, poeira e ossos esparsos, manchas de musgo entre as lajes
Style/medium: pixel art sombria coerente com o jogo, pixels nítidos, paleta de pedra cinza-arroxeada escura, névoa lilás clara, acentos âmbar de velas
Composition/framing: visão de cima em três quartos, chão ocupando quase toda a imagem, rua em diagonal suave, praça com selo ao centro, bordas mais escuras, área central limpa para a ação
Lighting/mood: noite de culto, névoa que abafa a luz, brilho fraco âmbar de velas junto ao selo
Constraints: imagem opaca, sem texto, logotipo, HUD, personagens ou criaturas, sem moldura
```

## `docas_fundo`

```text
Use case: stylized-concept
Asset type: fundo de fase de jogo (vista de cima, três quartos)
Primary request: cais de tábuas e pedra escura ao longo de uma água negra parada, tábuas gastas com pregos e cordas, piso de metal enferrujado com poças verdes de slime corrosivo, uma fenda arroxeada no casco de um armazém ao fundo, a boca de um porão ritual iluminada por brasas, trilhos de carga cruzando o cais
Style/medium: pixel art sombria coerente com o jogo, pixels nítidos, paleta azul-petróleo escura, acentos verde ácido das poças e âmbar de lampiões, roxo discreto na fenda
Composition/framing: visão de cima em três quartos, cais em faixa larga diagonal com a água em uma das bordas, área central limpa para a ação, bordas mais escuras
Lighting/mood: noite úmida, lampiões fracos, brilho verde das poças e roxo da fenda
Constraints: imagem opaca, sem texto, logotipo, HUD, personagens ou criaturas, sem placas legíveis, sem moldura
```

## Aceite
- Dagruve cinza-arroxeado com névoa; Docas azul-petróleo com verde e âmbar; silhuetas distintas.
- A rua (Dagruve) e o cais (Docas) são identificáveis para ancorar as zonas de `scenery.json`.
- Sem letras nem placas legíveis; nada que lembre personagem.
