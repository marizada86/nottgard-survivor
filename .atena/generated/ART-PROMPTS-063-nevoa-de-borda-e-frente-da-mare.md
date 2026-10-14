---
id: "ART-PROMPTS-063"
type: "prompts-de-arte"
title: "Névoa do mundo: faixa da borda do mapa (NB01) e frente da Maré de fim de fase (NB02)"
status: "ready-for-generation (geração só com aprovação do dono; cota de imagens)"
state: "DRAFT"
revision: "r1"
created: "2026-10-13"
relations: ["[[ART-PROMPTS-025-lote-1-nevoa-bau-de-chefe-imas-e-npcs]]", "[[SPEC-158-nevoa-de-borda-e-de-fim-de-fase]]", "[[SPEC-034-docas-prompts-introducao-chefes-e-mare-de-nevoa]]"]
sources: ["ui/edge_fog.gd (faixa MEC-059, hoje polígonos em gradiente)", "ui/run.gd:_update_fog_overlay (Maré MEC-060, hoje nevoa_borda_01 nas quatro bordas da tela)", "assets/fx/nevoa_borda_01.png", "assets/fx/nevoa_textura_01.png", "data/fog.json"]
---

# Névoa do mundo: NB01 e NB02

> Derivado. Não autoriza geração, admissão em `assets/` nem mudança de código. Revisão DRAFT; nenhuma imagem existe ainda.

## Por que existe

A SPEC-158 entregou as duas mecânicas **sem arte nova**:

- **MEC-059, borda do mapa:** a faixa de 3 tiles é desenhada por `EdgeFog` com quatro trapézios de gradiente liso (verde `0.34, 0.62, 0.46`, alfa até 0,62). Mostra onde o dano começa, mas não parece névoa e destoa do pixel art com dither do resto do jogo.
- **MEC-060, Maré de fim de fase:** reaproveita `nevoa_borda_01.png` como moldura nas quatro bordas da **tela**. Essa imagem some suavemente para dentro; o jogador não enxerga uma **frente** que avança, só o escurecimento das bordas.

As duas peças abaixo resolvem cada uma, com papéis diferentes para não se confundirem em jogo:

| ID | Papel | Aparece quando | O que comunica |
|---|---|---|---|
| **NB01** | Névoa **rasteira** que cobre a faixa da borda do mapa | herói a até 6 tiles da borda (proximidade 0..1) | "aqui queima, afaste-se"; estática, respira devagar |
| **NB02** | **Frente** da Maré: parede de névoa com contorno legível | após o chefe, de `warning` até o fim do avanço | "a névoa está vindo"; o contorno é o limite entre seguro e queimando |

## O que o código faz com cada peça (para o gerador não resolver o que é do código)

- **Cor:** o jogo tinge por `modulate` (verde-acinzentado hoje). **As imagens são só luminância**: branco/cinza claro sobre preto; nenhuma cor própria.
- **Opacidade:** a luminância vira o canal alfa na admissão (mesma regra de ART-PROMPTS-025). O preto vira 100% transparente. Por isso **nunca** use preto como "sombra" dentro da névoa; densidade baixa = cinza escuro, e o vazio fica fora da névoa.
- **Intensidade e largura:** o código controla alfa e profundidade (`proximity`, `fog_intensity`). A imagem só fornece a **forma**; ela será esticada, então detalhes finos devem sobreviver a ser achatados e ampliados.
- **Leitura de combate:** a névoa não pode esconder inimigos, projéteis, recompensas nem portal (SPEC-034). Em ambas, a região de dentro do mapa fica **vazia**.

## Convenção (a de ART-PROMPTS-025)

- Um asset por mensagem, parágrafo completo colado, **branco sobre preto puro `#000000`**, sem cor, cenário, objeto, criatura, texto, moldura ou marca d'água.
- Peça imagem **larga (landscape)** na maior resolução; o recorte final é feito depois.
- Pixel art sombria, **dither controlado e faixas de densidade em degraus visíveis**; sem aerógrafo suave, sem aspecto pintado.
- Até **3 candidatas** por peça; cada nova tentativa corrige **um defeito objetivo**.
- Candidatas em `.atena/generated/art-candidates/nevoa-mundo/<id>_vNN.png`. Nada vai para `assets/` sem aprovação explícita do dono.
- Marque `[x]` ao gerar e `[a]` ao aprovar.

## Especificação técnica

| ID | Destino provável | Tamanho final | Fundo | Observação |
|---|---|---|---|---|
| `nevoa_mundo_borda_01` (NB01) | `assets/fx/` | 1536×384 (4:1), **repetível na horizontal** | preto → alfa | Densa na base (lado do vazio), some para cima (limite interno da faixa) |
| `nevoa_mundo_frente_01` (NB02) | `assets/fx/` | 1280×360 (mesmo formato de `nevoa_borda_01`, troca direta) | preto → alfa | Contorno de frente no alto, corpo denso embaixo, ponta esquerda e direita somem |

Orientação nas duas: **densa na parte de baixo da imagem, vazia no alto**, igual a `nevoa_borda_01`, para o código atual girar e espelhar sem mudança.

---

## Parágrafos prontos para o ChatGPT

### NB01 — névoa rasteira da borda do mapa

**`nevoa_mundo_borda_01`**
> A wide horizontal strip of low, creeping ground mist for a dark-fantasy game, drawn as slow rolling banks and long thin horizontal wisps in pure white and light gray. The mist hugs the ground: it is thickest and most opaque along the bottom edge of the image and fades steadily upward until the top third is almost completely empty black. Wisps must run mostly horizontally, parallel to the long axis of the strip, with occasional small curls, and no tall vertical columns, no towering shapes and no single dominant focal cloud. Pixel-art style with controlled dithering and clearly visible stepped pixel bands for density, no smooth airbrushed gradient and no painterly softness. The pattern must be seamlessly tileable horizontally: the left edge must match the right edge exactly, with no visible seam and no feature that repeats obviously. Density varies unevenly along the strip, with thinner and thicker patches, but the bottom edge is never empty. Background: a single completely flat pure black (#000000) — the mist is white on black, with no color, no ground, no scenery, no objects, no creatures, no text, no logo, no watermark, no frame and no border. Wide landscape image.

Aceite específico: emenda sem costura em 3×1; a faixa lida a 1/4 do tamanho continua parecendo névoa rasteira (não "nuvem"); sem silhuetas reconhecíveis.

### NB02 — frente da Maré de Névoa

**`nevoa_mundo_frente_01`**
> A wide horizontal wall of advancing dark-fantasy fog seen from the side, with a clearly readable leading edge. The leading edge runs across the upper part of the image as a churning, billowing crest of rolling fog banks with a few thin curling tendrils reaching upward and forward; the contour must be distinct, like the front of a tide, drawn with stepped pixel bands and controlled dithering rather than a soft gradient. Below the crest, the body of the fog becomes dense and nearly solid, with visible internal swirls and layers of lighter and darker gray, thickest along the bottom edge of the image. The top quarter of the image is empty black so it can sit over a game scene. The left and right ends of the wall fade softly into black over about the outer eight percent of the width, so the wall can overlap at screen corners without a hard cut. One single connected bank, no gaps or holes, no separate floating clouds. Pixel-art style, no smooth airbrushed gradient and no painterly softness. Background: a single completely flat pure black (#000000) — the fog is white and light gray on black, with no color, no ground, no scenery, no objects, no creatures, no text, no logo, no watermark, no frame and no border. Wide landscape image.

Aceite específico: o contorno do alto lê **como limite** a 80 px de profundidade e a 360 px de profundidade (o código estica de 14 px até metade da tela); distinto de `nevoa_borda_01`, que some sem contorno.

---

## Pós-processamento (quando houver candidata aprovada)

1. Recortar para o tamanho final (tabela acima).
2. Converter para alfa por luminância: cor constante branco-acinzentada, alfa = brilho. Preto → 0.
3. **NB01:** teste de emenda lado a lado em 3×1 e em 3×3; se aparecer costura, normalizar como foi feito em `prepare_pending_fog_texture.gd`.
4. **NB02:** conferir que o miolo (alto da imagem) fica com alfa zero e que as pontas chegam a alfa próximo de zero.
5. Tonalidade por `modulate` no jogo; **não** pintar cor na imagem.

## Critérios de aceite

1. Cada candidata respeita seu parágrafo: branco sobre preto, pixel art com dither, sem cor, objeto, criatura, texto ou moldura.
2. **NB01** emenda sem costura na horizontal e parece névoa **rasteira** (sem torres, sem foco).
3. **NB02** tem contorno de frente nítido, corpo denso, alto vazio e pontas que somem; distinta de `nevoa_borda_01` e de NB01 lado a lado.
4. Em jogo (humano): a faixa da borda é lida como "perigo" sem esconder inimigos, projéteis ou portal; a frente da Maré lê como algo **que avança**. Subjetivo; fica pendente até playtest.
5. Nenhuma admissão em `assets/` sem seleção explícita do dono, com backup do que for substituído e suíte + smoke verdes depois.

## Fora deste lote

| Item | Motivo |
|---|---|
| Alterar `ui/edge_fog.gd` ou `ui/run.gd` para usar as texturas | exige admissão e emenda na SPEC-158 (hoje "arte nova: nenhuma"); o desenho com UV nos trapézios isométricos é trabalho de código, não de prompt |
| Névoa própria por bioma (Docas, Abismo) | tonalidade por `modulate` basta; `docas_fog_layer` de ART-PROMPTS-017 segue como ideia separada |
| Mudar dano, largura da faixa ou ritmo da Maré | mecânica; fora de escopo de arte |

## Gate

Aguardando o dono aprovar a geração (cota de imagens). Depois: candidatas em `art-candidates/nevoa-mundo/`, escolha do dono, spec de admissão e só então código.
