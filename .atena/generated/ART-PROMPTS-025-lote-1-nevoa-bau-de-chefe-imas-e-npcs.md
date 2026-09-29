---
id: "ART-PROMPTS-025"
type: "prompts-de-arte"
title: "Lote 1 — névoa, baú de chefe, ímã de XP e NPCs de evento"
status: "em andamento — geração no ChatGPT iniciada pelo dono em 2026-09-29; não misturar com as Ondas de HQ (ART-PROMPTS-028 e 029)"
created: "2026-09-29"
relations: ["[[SPEC-062-fila-de-geracao-externa-de-assets]]", "[[ART-PROMPTS-024-cenario-e-quebraveis-por-bioma]]", "[[SPEC-034-docas-prompts-introducao-chefes-e-mare-de-nevoa]]", "[[SPEC-064-eventos-economicos-loja-ferreiro-curandeiro]]"]
sources: ["backlog/ARTE.md ART-008, ART-009, ART-011, ART-015", "EVID-106 IN-002, IN-003, IN-013", "EVID-107 IN-026", "RESEARCH-003", "assets/interactions/chest_closed.png", "assets/pickups/xp_shard.png"]
---

# Lote 1 — névoa, baú de chefe, ímã de XP e NPCs de evento

## Contexto

Fecha o Lote 1 acordado em 2026-09-29. Cobre quatro itens de ARTE.md, todos
com decisão de design já tomada nos playtests:

| Item | O que pede | Assets deste lote |
|---|---|---|
| ART-008 | Asset visual da névoa (hoje inexistente) | 2 |
| ART-011 | Baú de chefe distinto dos baús comuns | 2 (fechado + aberto) |
| ART-015 | Ímã de experiência mais evidente | 1 |
| ART-009 | Assets de loja, ferreiro e curandeiro | 3 |

Total: **8 imagens**. Nenhuma foi gerada; este documento só prepara os prompts.
Os itens de ARTE.md que **não** entram aqui e o motivo estão na seção final.

## Sabor Nottgard

Sem lore nova. Só fatos já canônicos:

- **Névoa** — Dagruve é "névoa e culto" (`data/stages.json`); a Maré de Névoa
  pós-chefe está descrita em SPEC-034 (entra pelas laterais, deve preservar
  contraste de inimigos, projéteis, recompensas e portal). Sem divindade
  associada.
- **Baú de chefe** — um único visual genérico, válido para os 9 biomas
  (T02 relatou "apenas 1 baú"). Nenhuma divindade ou chefe específico; reforço
  de ferro escuro e ouro, da mesma família do baú comum.
- **Ímã** — item de utilidade, sem divindade. Precisa se distinguir do cristal
  de XP (azul, `xp_shard.png`), da moeda (dourada) e da poção.
- **NPCs** — comerciante, ferreiro e curandeiro são figuras anônimas, não
  personagens de lore. A leitura vem da **cor dominante e do objeto central**
  (RESEARCH-003 dá a Sendrinah a cura em dourado quente; usamos só como pista de
  paleta do curandeiro, **sem citar a divindade**).

## Como usar (mesmas regras de ART-PROMPTS-024)

1. Um asset por mensagem, parágrafo completo colado. Gere a mesma família na
   mesma conversa quando houver mais de uma peça.
2. Peça imagem **quadrada** na maior resolução; o recorte final é feito depois.
3. **Fundo de cor sólida, nunca "transparente"**. Cores usadas neste lote:
   magenta `#FF00FF` (padrão), verde `#00FF00` (ímã, porque o objeto tem
   vermelho) e **preto puro** (névoa; ver abaixo).
4. **Névoa é caso especial.** Névoa é translúcida, e remover um fundo
   chapado destruiria essa translucidez. Por isso a névoa é gerada em **branco
   sobre preto puro** e, na normalização, a **luminância vira o canal alfa**
   (cor final constante, alfa = brilho). O preto vira 100% transparente.
5. **Cobertura sólida é crítico** nos baús, NPCs e ímã: silhueta totalmente
   opaca, sem pixels soltos ou aspecto fantasmagórico (defeito recorrente de
   Leoric e Zumbi). Descarte e regenere se aparecer.
6. Destinos de candidata:
   `.atena/generated/art-candidates/lote-1/<id>_vNN.png`. Nada vai para
   `assets/` sem aprovação explícita do dono.

## Especificação técnica

| ID | Destino provável | Tamanho final | Fundo | Observação |
|---|---|---|---|---|
| `nevoa_textura_01` | `assets/fx/` (novo) | 512×512, repetível | preto → alfa | Deve emendar nas quatro bordas |
| `nevoa_borda_01` | `assets/fx/` (novo) | 1280×360 | preto → alfa | Borda densa embaixo, some para cima |
| `bau_chefe_fechado` | `assets/interactions/` | ~192×192, mesmo enquadramento de `chest_closed.png` | magenta | Maior e mais ornado que o baú comum |
| `bau_chefe_aberto` | `assets/interactions/` | idem `chest_open.png` | magenta | Mesma peça, aberta, mesmo ponto de base |
| `ima_xp` | `assets/pickups/` | 64×64 (igual `xp_shard.png`) | verde | Legível a 64 px |
| `npc_loja` | `assets/interactions/` (novo) | ≤256×256 | magenta | Estático |
| `npc_ferreiro` | `assets/interactions/` (novo) | ≤256×256 | magenta | Estático |
| `npc_curandeiro` | `assets/interactions/` (novo) | ≤256×256 | magenta | Estático |

Os destinos são sugestão: o caminho definitivo e a integração ficam para a spec
de admissão. O efeito de **atração dos cristais** do ART-015 (rastro, anel de
alcance) é procedural no código e **não** é prompt de imagem.

---

## Parágrafos prontos para o ChatGPT

### ART-008 — Névoa

**`nevoa_textura_01`**
> A seamless tileable texture of dense drifting mist, rendered as soft layered wisps and curling banks of fog in pure white and light gray. Dark-fantasy pixel-art style with controlled dithering and visible stepped pixel bands for density, no smooth airbrushed gradient and no painterly softness. The pattern must repeat perfectly: the left edge must match the right edge and the top edge must match the bottom edge, with no visible seam and no single dominant focal shape. Mist must be uneven, with thinner and thicker regions, but never fully empty and never solid. Background: a single completely flat pure black (#000000) — the mist is white on black, with no color, no ground, no scenery, no objects, no creatures, no text, no logo, no watermark, no frame and no border. Square image.

**`nevoa_borda_01`**
> A wide horizontal bank of thick dark-fantasy mist that is densest along the bottom edge of the image and fades gradually upward into nothing, drawn as layered curling fog in pure white and light gray. Pixel-art style with controlled dithering and visible stepped pixel bands, no smooth airbrushed gradient. The top third of the image must be almost fully empty black, so it can blend into a game scene. Background: a single completely flat pure black (#000000) — the mist is white on black, with no color, no ground, no scenery, no objects, no creatures, no text, no logo, no watermark, no frame and no border. Wide landscape image.

Pós-processamento: converter para alfa por luminância (cor branca-acinzentada
constante, alfa = brilho). Tonalizar no jogo (verde-acinzentado doentio ou
cinza-azulado) por `modulate`, para reaproveitar o mesmo asset em outros biomas.
Testar a emenda da textura repetida em 3×3 antes de aceitar.

### ART-011 — Baú de chefe

**`bau_chefe_fechado`**
> A large, heavy dark-fantasy treasure chest, closed, clearly grander than an ordinary wooden chest but from the same visual family: dark weathered wood wrapped in thick blackened iron bands, with rich gold trim on the corners, edges and a large ornate gold lock plate at the front, plus a few thick iron chains hanging across the lid. A faint warm golden light leaks out of the seams between the planks. Dark-fantasy isometric pixel-art game prop, viewed from a three-quarter isometric angle tilted about 30 degrees from above, with soft directional light from the upper left. Crisp, clean pixel-art rendering with controlled dithering, no blur and no smooth anti-aliasing. The object sits centered in the frame with roughly 12% empty margin on every side and does not touch or cross the image edges. The whole silhouette must be solid, fully opaque and readable at small size. Background: a single, completely flat and uniform solid magenta color (#FF00FF), with absolutely no ground, floor, cast shadow, gradient, vignette, texture, or scenery behind the object. Do not include any text, logo, watermark, frame, border, UI element, character, creature, skull, or second object — render only this one chest, alone. Square image.

**`bau_chefe_aberto`**
> The exact same large ornate boss treasure chest as before — same size, same dark weathered wood, blackened iron bands, gold trim, ornate gold lock plate and hanging chains, same camera angle, same zoom and same position in the frame — but now open, with the lid tilted back and a warm golden glow spilling out of the inside, lighting the inner rim. The inside must show only a bright glow and a hint of gold, no readable items. Dark-fantasy isometric pixel-art game prop, three-quarter isometric angle tilted about 30 degrees from above, soft directional light from the upper left, crisp clean pixel art with controlled dithering, no blur or anti-aliasing. Centered with roughly 12% empty margin, not touching the frame edges, base of the chest at the same height as the closed version. The whole silhouette must be solid and fully opaque. Background: a single flat uniform solid magenta color (#FF00FF), no ground, floor, cast shadow, gradient, vignette, texture, or scenery. No text, logo, watermark, frame, border, UI, character, creature, skull, or second object — only this one chest, alone. Square image.

Gere o fechado primeiro; use-o como referência na mesma conversa para o aberto.
Compare lado a lado com `chest_closed.png`/`chest_open.png`: o baú de chefe
deve ser inconfundível **a 64 px**.

### ART-015 — Ímã de experiência

**`ima_xp`**
> A single small horseshoe magnet pickup item for a game: a thick U-shaped magnet made of polished steel-gray metal, with the two tips painted in strong red and white bands, and a few tiny bright sparks of energy between the two tips. Bold chunky shapes, very readable when shrunk to 64 pixels, strong dark outline. Dark-fantasy isometric pixel-art game item, viewed from a slightly raised three-quarter angle, with soft directional light from the upper left. Crisp, clean pixel-art rendering with controlled dithering, no blur and no smooth anti-aliasing. The item sits centered with roughly 12% empty margin on every side. The whole silhouette must be solid and fully opaque. Background: a single, completely flat and uniform solid bright green color (#00FF00), with absolutely no ground, cast shadow, gradient, vignette, texture, or scenery, and no green anywhere on the object itself. Do not include any text, logo, watermark, frame, border, UI element, character, or second object — only this one item, alone. Square image.

O ímã deve destoar de `xp_shard.png` (azul), `gold_coin.png` (dourado) e
`health_potion.png`. Se sair azul ou dourado, regenere.

### ART-009 — NPCs de evento

Os três compartilham a mesma câmera, escala e nível de detalhe; gere na mesma
conversa, um por mensagem, sempre com o parágrafo completo.

**`npc_loja`** — comerciante
> A small traveling merchant stall for a dark-fantasy game: a hooded, cloaked merchant figure standing behind a low wooden counter under a sagging deep-red cloth awning, with a lantern hanging from the awning pole, a few closed sacks and a small open chest on the counter, and a leather coin purse and a few coins clearly visible in front. The dominant color of the whole object is deep red and warm brown, so it reads as a shop at a glance. The merchant's face stays hidden in the shadow of the hood. Dark-fantasy isometric pixel-art game prop, viewed from a three-quarter isometric angle tilted about 30 degrees from above, with soft directional light from the upper left. Crisp, clean pixel-art rendering with controlled dithering, no blur and no smooth anti-aliasing. Centered with roughly 12% empty margin on every side, not touching the frame edges. The whole silhouette must be solid and fully opaque. Background: a single, completely flat and uniform solid magenta color (#FF00FF), with no ground, floor, cast shadow, gradient, vignette, texture, or scenery. No text, no signboard lettering, logo, watermark, frame, border, UI element, weapon in use, or second character — only this one stall with its merchant, alone. Square image.

**`npc_ferreiro`** — ferreiro
> A dark-fantasy blacksmith's work station: a hooded, broad-shouldered smith figure standing behind a heavy iron anvil, hammer resting in hand, next to a small stone forge with glowing orange embers, with a couple of unfinished blades and tongs leaning against the anvil. The dominant colors of the whole object are dark steel gray and glowing orange, so it reads as a forge at a glance, and it must look clearly different from a merchant stall. The smith's face stays hidden in shadow. Dark-fantasy isometric pixel-art game prop, viewed from a three-quarter isometric angle tilted about 30 degrees from above, with soft directional light from the upper left plus the orange glow of the forge. Crisp, clean pixel-art rendering with controlled dithering, no blur and no smooth anti-aliasing. Centered with roughly 12% empty margin on every side, not touching the frame edges. The whole silhouette must be solid and fully opaque. Background: a single, completely flat and uniform solid magenta color (#FF00FF), with no ground, floor, cast shadow, gradient, vignette, texture, or scenery. No text, logo, watermark, frame, border, UI element, or second character — only this one work station with its smith, alone. Square image.

**`npc_curandeiro`** — curandeiro
> A dark-fantasy herbalist healer's corner: a hooded, gentle-looking healer figure kneeling or standing beside a small stone bowl and a bubbling iron cauldron that gives off soft warm golden-white steam, with bundles of dried herbs hanging from a short wooden rack and a few small glass vials on a low stool. The dominant colors of the whole object are soft moss green and pale warm gold, with a calm, restorative feeling, so it reads as healing at a glance and looks clearly different from a merchant stall and from a forge. The healer's face stays hidden in shadow. Dark-fantasy isometric pixel-art game prop, viewed from a three-quarter isometric angle tilted about 30 degrees from above, with soft directional light from the upper left. Crisp, clean pixel-art rendering with controlled dithering, no blur and no smooth anti-aliasing. Centered with roughly 12% empty margin on every side, not touching the frame edges. The whole silhouette must be solid and fully opaque. Background: a single, completely flat and uniform solid magenta color (#FF00FF), with no ground, floor, cast shadow, gradient, vignette, texture, or scenery. No text, no cross or religious symbol, logo, watermark, frame, border, UI element, or second character — only this one healing corner with its healer, alone. Square image.

Teste de aceite dos três: lado a lado, a 96 px, distinguíveis só pela cor
dominante e silhueta (vermelho/marrom = loja, aço/laranja = ferreiro,
verde/dourado suave = curandeiro). Esse é o defeito relatado por 2 jogadores.

---

## Critérios de aceite do lote

1. Cada candidata respeita seu parágrafo: pixel art sombria, isométrico 3/4,
   luz superior esquerda, sem texto, moldura, personagem indevido ou cenário.
2. Baús, ímã e NPCs: silhueta sólida, sem halo e sem fundo residual após a
   remoção da cor; legíveis em escala de jogo.
3. Névoa: emenda sem costura (textura), translucidez preservada pelo alfa por
   luminância, e nenhum objeto, criatura ou cor no branco-sobre-preto.
4. Baú de chefe distinguível do baú comum a 64 px; ímã distinguível do cristal
   de XP e da moeda; três NPCs distinguíveis entre si.
5. Nenhuma admissão em `assets/` sem seleção explícita do dono, com backup do
   que for substituído e suíte + smoke verdes depois de cada admissão.

## Fora deste lote (e por quê)

| Item | Motivo |
|---|---|
| ART-002, 003, 007, 016, 017 | Layout, cor e texto de UI: feitos no Godot/código, não em imagem |
| ART-001 | Verificação do Zumbi (BUG-001), não é prompt |
| ART-004, 005, 014 | Presos a mecânicas ainda não decididas (MEC-004, 005, 009) |
| ART-006, 010 | Áudio/VFX de level-up; o ChatGPT não gera áudio e T03 discorda de ART-010 |
| ART-012, 013 | Lote grande de cenário e HQ de história; `ART-PROMPTS-026` à parte |

## Gate

Preparado, não executado. Após o dono gerar e devolver os PNGs brutos, a
sessão normaliza, valida em runtime, apresenta prancha de revisão e só então
admite, registrando a evidência (`EVID-109` é o próximo número livre).
