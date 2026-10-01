---
id: "ART-PROMPTS-039"
type: "prompts-de-arte"
title: "Miniatura da fase Docas"
status: "ready-for-generation"
created: "2026-10-01"
relations: ["[[ART-PROMPTS-007-biomas-props-thumbnails]]"]
sources: ["data/stages.json (docas)", "ui/menu.gd", "backlog ART-024"]
---

# Miniatura da fase Docas (ART-024)

O menu "Jogar" carrega `assets/stages/<id>_thumb.png`; `docas_thumb.png` não existe e a linha "2. Docas" aparece sem imagem.
Fase: "M1 · cais, fenda e porão ritual", regra de poças de metal corroído (slime), chefe Guardião Aliado (verdadeiro),
paleta de chão azul-petróleo escuro (27,37,43 / 36,51,56), props de doca. Deve ficar diferente da miniatura de Dagruve (névoa, pilares, velas).

Matriz 1536×1024; final `assets/stages/docas_thumb.png`, 480×320 RGB, opaca, legível a 240×160.

## `docas_thumb`

```text
Use case: stylized-concept
Asset type: thumbnail de fase
Primary request: cais de pedra e madeira escura à beira de uma água negra e parada, caixotes e cordas empilhados, um guindaste quebrado, poças verdes de slime corrosivo no piso de metal enferrujado, ao fundo uma fenda arroxeada no casco de um armazém e a boca de um porão ritual iluminada por brasas
Style/medium: pixel art cinematográfica sombria coerente com o jogo
Composition/framing: paisagem 3:2, ponto focal central na entrada do porão ritual, espaço escuro nas bordas para UI, sem personagens dominantes
Lighting/mood: noite úmida, lampiões fracos âmbar, brilho verde das poças e roxo discreto da fenda
Constraints: imagem opaca, sem texto, logotipo, HUD ou moldura; leitura clara a 240x160
```

## Aceite
- Silhueta distinta de Dagruve; azul-petróleo dominante com acentos verde e âmbar.
- Sem letras nem placas legíveis.
