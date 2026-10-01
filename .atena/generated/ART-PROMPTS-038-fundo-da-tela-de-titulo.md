---
id: "ART-PROMPTS-038"
type: "prompts-de-arte"
title: "Fundo da tela de título (portal roxo do Abismo)"
status: "ready-for-generation"
created: "2026-10-01"
relations: ["[[ART-PROMPTS-013-telas-e-identidade-do-app]]"]
sources: ["nottgard-vault/04_Locais/Camadas do Plano Abissal (Arco 01).md", "ui/title.gd"]
---

# Fundo da tela de título

Tela "Clique para jogar" ([title.gd](../../ui/title.gd)). Hoje cai num gradiente roxo procedural porque `assets/ui/title/` está vazia.

Lore (vault): nas camadas do Plano Abissal, **portal roxo = mais fundo no Abismo**; portal verde volta ao plano material. A descida segue o **Rio Estige**. O portal roxo é o gancho do jogo.

Referência: nenhuma imagem; é um fundo novo, na mesma direção visual do menu (`quartel_background`). Matriz 1536×1024; final 1920×1080 RGB (`assets/ui/title/title_background.png`).

## `title_background`

```text
Use case: stylized-concept
Asset type: fundo da tela de título de jogo
Primary request: um grande portal roxo aberto no chão de uma planície de pedra escura, vórtice de energia violeta e lilás descendo em espiral rumo ao abismo, ao longe o contorno de uma cidade de pedra quase apagada na noite sem fim, pequenas brasas âmbar flutuando pela névoa
Style/medium: pixel art cinematográfica sombria, pixels nítidos, paleta violeta quase preto com lilás elétrico no portal e pequenos acentos âmbar
Composition/framing: 16:9, portal centralizado e levemente abaixo do meio, simétrico e majestoso; faixa superior limpa e escura para o logo, faixa inferior limpa e escura para o texto "Clique para jogar"; vinheta forte nas bordas
Lighting/mood: ameaça silenciosa e fascínio, luz do portal iluminando a névoa e as pedras ao redor, convite para descer
Constraints: sem texto, logotipo, watermark, botões, HUD ou personagem identificável
```

## Notas de uso

- O logo e o "Clique para jogar" são renderizados pelo jogo; a imagem não pode conter letras.
- Se o portal ficar muito luminoso no centro, escurecer topo e base na geração ou no processamento para manter a leitura do texto.
- Logo próprio (`logo.png`) é opcional e fica fora deste prompt; sem ele o jogo usa o nome em texto.
