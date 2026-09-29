# CHATGPT-PROMPTS-ZUMBI-V01

Status: **local e não executado.**
Complementa `BRIEF-ZUMBI-REGEN-V01.md` e `PILOT-REQUEST-TEMPLATES-001.json`
(SPEC-061) com prompts adaptados especificamente para o gerador de imagem do
ChatGPT.

## Aviso honesto antes de usar isso

O ChatGPT **não é a ferramenta certa para gerar uma folha de animação
pixel-perfeita** (célula 256×384, frames alinhados em grade) — isso é o que
`ui/enemy_view.gd`/`SpriteStripFrames` exigem para os quatro arquivos
(`idle.png`, `move.png`, `attack.png`, `death.png`). Três limitações reais:

1. O ChatGPT gera cada imagem de forma independente — não existe garantia de
   que o zoom, o enquadramento ou a proporção do personagem fiquem idênticos
   entre uma mensagem e outra, mesmo pedindo "mesmo estilo".
2. Ele não aceita pedido de dimensão exata em pixels (não dá pra pedir
   "256×384" diretamente) — a saída sempre vem num tamanho fixo (geralmente
   quadrado).
3. Não existe controle de "frame 3 de uma caminhada de 6 frames" como
   conceito — cada frame é uma imagem nova, sem noção de sequência real.

**O que isso significa na prática:** dá para usar o ChatGPT para gerar cada
um dos 20 frames como uma **imagem de referência individual**, mas alguém
vai precisar, depois, abrir um editor de imagem (Photopea, GIMP, Aseprite
etc.) e:

- recortar/redimensionar cada frame pra caber exatamente numa célula
  256×384;
- realinhar manualmente o personagem pra manter o pé na base (y=367) e a
  escala consistente entre os 4/6 frames de cada folha;
- ajustar cor/proporção se um frame sair visivelmente diferente dos outros;
- só então montar a tira horizontal final (`idle.png` = 4 células lado a
  lado, `move.png`/`death.png` = 6, `attack.png` = 4) e salvar em
  `.atena/generated/zumbi-regeneration/v01/sheets/<strip>_source.png`.

Se isso parecer trabalho demais, a alternativa mais realista é usar, pra
este asset especificamente, a mesma ferramenta/ambiente que gerou o piloto
de Leoric (que lidava com strips diretamente) em vez do ChatGPT. Os
parágrafos abaixo ainda são úteis mesmo assim — como referência de pose e
estilo pra outra ferramenta, ou como ponto de partida pra edição manual.

## Como usar cada parágrafo

Uma mensagem por frame. Gere os 4 frames de `idle` em sequência na mesma
conversa (ajuda a manter uma pele/roupa consistente), depois recomece com
`move`, depois `attack`, depois `death`.

### Idle (4 frames)

**Frame 0 — postura parada**
> A single game character sprite of a Zumbi: a common human corpse reanimated by mist, wearing torn dockworker clothes, gray skin, hunched posture, no excessive gore. Pose: standing still, neutral idle stance, clothes and gray skin clearly readable. Dark-fantasy isometric pixel-art game sprite, three-quarter isometric angle tilted about 30 degrees from above, soft light from the upper left, crisp clean pixel-art rendering with controlled dithering, no blur or anti-aliasing. The character stands centered with roughly 8% side margin, feet planted at the bottom of the frame. Background: a single flat uniform solid magenta color (#FF00FF), no ground, floor, cast shadow, gradient, texture, or scenery. No text, logo, watermark, frame, border, UI, or second character — only this one character. Critically, the character's whole silhouette must be solid and fully opaque — no wispy, translucent, faded, ghostly, or speckled/scattered-pixel appearance anywhere on the body; it must read as one clear, solid, fully-colored figure.

**Frame 1 — leve balanço**
> Same Zumbi character as before (common human corpse reanimated by mist, torn dockworker clothes, gray skin, hunched posture, no excessive gore) — keep the same clothing, skin tone, proportions, camera angle and zoom as the previous frame. Pose: a faint swaying motion in the mist/clothes, body still fully filled-in and solid. Dark-fantasy isometric pixel-art game sprite, three-quarter isometric angle tilted about 30 degrees from above, soft light from the upper left, crisp clean pixel-art rendering with controlled dithering, no blur or anti-aliasing. Centered with roughly 8% side margin, feet planted at the bottom of the frame. Background: single flat uniform solid magenta color (#FF00FF), no ground, floor, cast shadow, gradient, texture, or scenery. No text, logo, watermark, frame, border, UI, or second character. Critically, the whole silhouette must be solid and fully opaque — no wispy, translucent, faded, or speckled/scattered-pixel look anywhere.

**Frame 2 — mudança de peso**
> Same Zumbi character as before, same clothing/skin/proportions/camera/zoom. Pose: a small weight shift from one leg to the other, hunched posture maintained. Dark-fantasy isometric pixel-art game sprite, three-quarter isometric angle tilted about 30 degrees from above, soft light from the upper left, crisp clean pixel-art rendering with controlled dithering, no blur or anti-aliasing. Centered with roughly 8% side margin, feet planted at the bottom of the frame. Background: single flat uniform solid magenta color (#FF00FF), no ground, floor, cast shadow, gradient, texture, or scenery. No text, logo, watermark, frame, border, UI, or second character. Critically, the whole silhouette must be solid and fully opaque — no wispy, translucent, faded, or speckled/scattered-pixel look anywhere.

**Frame 3 — retorno à postura inicial**
> Same Zumbi character as before, same clothing/skin/proportions/camera/zoom. Pose: returning to the initial neutral idle stance, feet firmly planted at the base. Dark-fantasy isometric pixel-art game sprite, three-quarter isometric angle tilted about 30 degrees from above, soft light from the upper left, crisp clean pixel-art rendering with controlled dithering, no blur or anti-aliasing. Centered with roughly 8% side margin, feet planted at the bottom of the frame. Background: single flat uniform solid magenta color (#FF00FF), no ground, floor, cast shadow, gradient, texture, or scenery. No text, logo, watermark, frame, border, UI, or second character. Critically, the whole silhouette must be solid and fully opaque — no wispy, translucent, faded, or speckled/scattered-pixel look anywhere.

### Move (6 frames)

**Frame 0 — contato do pé dianteiro**
> Same Zumbi character (common human corpse reanimated by mist, torn dockworker clothes, gray skin, hunched posture, no excessive gore), same clothing/skin/proportions/camera/zoom as the idle frames. Pose: a shambling, dragging walk cycle — front foot making contact with the ground. Dark-fantasy isometric pixel-art game sprite, three-quarter isometric angle tilted about 30 degrees from above, soft light from the upper left, crisp clean pixel-art rendering with controlled dithering, no blur or anti-aliasing. Centered with roughly 8% side margin, feet at the bottom of the frame. Background: single flat uniform solid magenta color (#FF00FF), no ground, floor, cast shadow, gradient, texture, or scenery. No text, logo, watermark, frame, border, UI, or second character. Critically, the whole silhouette must be solid and fully opaque — no wispy, translucent, faded, or speckled/scattered-pixel look anywhere.

**Frame 1 — transferência de peso, tronco curvado**
> Same Zumbi character as before, same clothing/skin/proportions/camera/zoom. Pose: mid-stride weight transfer, torso hunched forward. Dark-fantasy isometric pixel-art game sprite, three-quarter isometric angle tilted about 30 degrees from above, soft light from the upper left, crisp clean pixel-art rendering with controlled dithering, no blur or anti-aliasing. Centered with roughly 8% side margin, feet at the bottom of the frame. Background: single flat uniform solid magenta color (#FF00FF), no ground, floor, cast shadow, gradient, texture, or scenery. No text, logo, watermark, frame, border, UI, or second character. Critically, the whole silhouette must be solid and fully opaque — no wispy, translucent, faded, or speckled/scattered-pixel look anywhere.

**Frame 2 — passada intermediária, braços soltos**
> Same Zumbi character as before, same clothing/skin/proportions/camera/zoom. Pose: mid-stride, arms hanging loose at the sides. Dark-fantasy isometric pixel-art game sprite, three-quarter isometric angle tilted about 30 degrees from above, soft light from the upper left, crisp clean pixel-art rendering with controlled dithering, no blur or anti-aliasing. Centered with roughly 8% side margin, feet at the bottom of the frame. Background: single flat uniform solid magenta color (#FF00FF), no ground, floor, cast shadow, gradient, texture, or scenery. No text, logo, watermark, frame, border, UI, or second character. Critically, the whole silhouette must be solid and fully opaque — no wispy, translucent, faded, or speckled/scattered-pixel look anywhere.

**Frame 3 — novo contato do pé, passo assimétrico**
> Same Zumbi character as before, same clothing/skin/proportions/camera/zoom. Pose: the other foot making contact with the ground, an asymmetric, uneven walking step. Dark-fantasy isometric pixel-art game sprite, three-quarter isometric angle tilted about 30 degrees from above, soft light from the upper left, crisp clean pixel-art rendering with controlled dithering, no blur or anti-aliasing. Centered with roughly 8% side margin, feet at the bottom of the frame. Background: single flat uniform solid magenta color (#FF00FF), no ground, floor, cast shadow, gradient, texture, or scenery. No text, logo, watermark, frame, border, UI, or second character. Critically, the whole silhouette must be solid and fully opaque — no wispy, translucent, faded, or speckled/scattered-pixel look anywhere.

**Frame 4 — transferência de peso, roupas acompanham**
> Same Zumbi character as before, same clothing/skin/proportions/camera/zoom. Pose: weight transfer continuing, torn clothing trailing with the motion. Dark-fantasy isometric pixel-art game sprite, three-quarter isometric angle tilted about 30 degrees from above, soft light from the upper left, crisp clean pixel-art rendering with controlled dithering, no blur or anti-aliasing. Centered with roughly 8% side margin, feet at the bottom of the frame. Background: single flat uniform solid magenta color (#FF00FF), no ground, floor, cast shadow, gradient, texture, or scenery. No text, logo, watermark, frame, border, UI, or second character. Critically, the whole silhouette must be solid and fully opaque — no wispy, translucent, faded, or speckled/scattered-pixel look anywhere.

**Frame 5 — fechamento do ciclo**
> Same Zumbi character as before, same clothing/skin/proportions/camera/zoom. Pose: closing the walk cycle loop, base steady with no vertical bounce. Dark-fantasy isometric pixel-art game sprite, three-quarter isometric angle tilted about 30 degrees from above, soft light from the upper left, crisp clean pixel-art rendering with controlled dithering, no blur or anti-aliasing. Centered with roughly 8% side margin, feet at the bottom of the frame. Background: single flat uniform solid magenta color (#FF00FF), no ground, floor, cast shadow, gradient, texture, or scenery. No text, logo, watermark, frame, border, UI, or second character. Critically, the whole silhouette must be solid and fully opaque — no wispy, translucent, faded, or speckled/scattered-pixel look anywhere.

### Attack (4 frames)

**Frame 0 — aproximação, braços erguidos**
> Same Zumbi character (common human corpse reanimated by mist, torn dockworker clothes, gray skin, hunched posture, no excessive gore), same clothing/skin/proportions/camera/zoom as previous frames. Pose: lunging forward with both arms raised, about to attack. Dark-fantasy isometric pixel-art game sprite, three-quarter isometric angle tilted about 30 degrees from above, soft light from the upper left, crisp clean pixel-art rendering with controlled dithering, no blur or anti-aliasing. Centered with roughly 8% side margin, feet at the bottom of the frame. Background: single flat uniform solid magenta color (#FF00FF), no ground, floor, cast shadow, gradient, texture, or scenery. No text, logo, watermark, frame, border, UI, or second character. Critically, the whole silhouette must be solid and fully opaque — no wispy, translucent, faded, or speckled/scattered-pixel look anywhere.

**Frame 1 — início da investida**
> Same Zumbi character as before, same clothing/skin/proportions/camera/zoom. Pose: the start of a forward lunge, body leaning aggressively forward. Dark-fantasy isometric pixel-art game sprite, three-quarter isometric angle tilted about 30 degrees from above, soft light from the upper left, crisp clean pixel-art rendering with controlled dithering, no blur or anti-aliasing. Centered with roughly 8% side margin, feet at the bottom of the frame. Background: single flat uniform solid magenta color (#FF00FF), no ground, floor, cast shadow, gradient, texture, or scenery. No text, logo, watermark, frame, border, UI, or second character. Critically, the whole silhouette must be solid and fully opaque — no wispy, translucent, faded, or speckled/scattered-pixel look anywhere.

**Frame 2 — golpe/mordida curta**
> Same Zumbi character as before, same clothing/skin/proportions/camera/zoom. Pose: mid-strike, a short biting/clawing attack motion, full body silhouette clearly visible. Dark-fantasy isometric pixel-art game sprite, three-quarter isometric angle tilted about 30 degrees from above, soft light from the upper left, crisp clean pixel-art rendering with controlled dithering, no blur or anti-aliasing. Centered with roughly 8% side margin, feet at the bottom of the frame. Background: single flat uniform solid magenta color (#FF00FF), no ground, floor, cast shadow, gradient, texture, or scenery. No text, logo, watermark, frame, border, UI, or second character. Critically, the whole silhouette must be solid and fully opaque — no wispy, translucent, faded, or speckled/scattered-pixel look anywhere.

**Frame 3 — recuperação**
> Same Zumbi character as before, same clothing/skin/proportions/camera/zoom. Pose: recovering from the attack, returning to the hunched idle posture. Dark-fantasy isometric pixel-art game sprite, three-quarter isometric angle tilted about 30 degrees from above, soft light from the upper left, crisp clean pixel-art rendering with controlled dithering, no blur or anti-aliasing. Centered with roughly 8% side margin, feet at the bottom of the frame. Background: single flat uniform solid magenta color (#FF00FF), no ground, floor, cast shadow, gradient, texture, or scenery. No text, logo, watermark, frame, border, UI, or second character. Critically, the whole silhouette must be solid and fully opaque — no wispy, translucent, faded, or speckled/scattered-pixel look anywhere.

### Death (6 frames)

**Frame 0 — impacto**
> Same Zumbi character (common human corpse reanimated by mist, torn dockworker clothes, gray skin, hunched posture, no excessive gore), same clothing/skin/proportions/camera/zoom as previous frames. Pose: reacting to a fatal impact, body just beginning to give way. Dark-fantasy isometric pixel-art game sprite, three-quarter isometric angle tilted about 30 degrees from above, soft light from the upper left, crisp clean pixel-art rendering with controlled dithering, no blur or anti-aliasing. Centered with roughly 8% side margin, feet at the bottom of the frame. Background: single flat uniform solid magenta color (#FF00FF), no ground, floor, cast shadow, gradient, texture, or scenery. No text, logo, watermark, frame, border, UI, or second character. Critically, the whole silhouette must be solid and fully opaque — no wispy, translucent, faded, or speckled/scattered-pixel look anywhere.

**Frame 1 — joelhos dobram**
> Same Zumbi character as before, same clothing/skin/proportions/camera/zoom. Pose: knees buckling, torso tilting forward. Dark-fantasy isometric pixel-art game sprite, three-quarter isometric angle tilted about 30 degrees from above, soft light from the upper left, crisp clean pixel-art rendering with controlled dithering, no blur or anti-aliasing. Centered with roughly 8% side margin, feet at the bottom of the frame. Background: single flat uniform solid magenta color (#FF00FF), no ground, floor, cast shadow, gradient, texture, or scenery. No text, logo, watermark, frame, border, UI, or second character. Critically, the whole silhouette must be solid and fully opaque — no wispy, translucent, faded, or speckled/scattered-pixel look anywhere.

**Frame 2 — queda parcial**
> Same Zumbi character as before, same clothing/skin/proportions/camera/zoom. Pose: partially collapsed, one arm touching the ground. Dark-fantasy isometric pixel-art game sprite, three-quarter isometric angle tilted about 30 degrees from above, soft light from the upper left, crisp clean pixel-art rendering with controlled dithering, no blur or anti-aliasing. Centered with roughly 8% side margin. Background: single flat uniform solid magenta color (#FF00FF), no ground, floor, cast shadow, gradient, texture, or scenery. No text, logo, watermark, frame, border, UI, or second character. Critically, the whole silhouette must be solid and fully opaque — no wispy, translucent, faded, or speckled/scattered-pixel look anywhere.

**Frame 3 — corpo semi-caído**
> Same Zumbi character as before, same clothing/skin/proportions/camera/zoom. Pose: half-fallen, silhouette still clearly readable as the character. Dark-fantasy isometric pixel-art game sprite, three-quarter isometric angle tilted about 30 degrees from above, soft light from the upper left, crisp clean pixel-art rendering with controlled dithering, no blur or anti-aliasing. Centered with roughly 8% side margin. Background: single flat uniform solid magenta color (#FF00FF), no ground, floor, cast shadow, gradient, texture, or scenery. No text, logo, watermark, frame, border, UI, or second character. Critically, the whole silhouette must be solid and fully opaque — no wispy, translucent, faded, or speckled/scattered-pixel look anywhere.

**Frame 4 — colapso quase completo**
> Same Zumbi character as before, same clothing/skin/proportions/camera/zoom. Pose: nearly fully collapsed onto the ground, no dismemberment, body still intact. Dark-fantasy isometric pixel-art game sprite, three-quarter isometric angle tilted about 30 degrees from above, soft light from the upper left, crisp clean pixel-art rendering with controlled dithering, no blur or anti-aliasing. Centered with roughly 8% side margin. Background: single flat uniform solid magenta color (#FF00FF), no ground, floor, cast shadow, gradient, texture, or scenery. No text, logo, watermark, frame, border, UI, or second character. Critically, the whole silhouette must be solid and fully opaque — no wispy, translucent, faded, or speckled/scattered-pixel look anywhere.

**Frame 5 — corpo imóvel, cena final**
> Same Zumbi character as before, same clothing/skin/proportions/camera/zoom. Pose: final resting pose, motionless on the ground, body fully intact with no dismemberment. Dark-fantasy isometric pixel-art game sprite, three-quarter isometric angle tilted about 30 degrees from above, soft light from the upper left, crisp clean pixel-art rendering with controlled dithering, no blur or anti-aliasing. Centered with roughly 8% side margin. Background: single flat uniform solid magenta color (#FF00FF), no ground, floor, cast shadow, gradient, texture, or scenery. No text, logo, watermark, frame, border, UI, or second character. Critically, the whole silhouette must be solid and fully opaque — no wispy, translucent, faded, or speckled/scattered-pixel look anywhere.

## Depois de gerar

1. Remova o fundo magenta de cada uma das 20 imagens (mesma técnica indicada
   em ART-PROMPTS-024: remove.bg, GIMP "Cor para Alfa", Photopea etc.).
2. Recorte/redimensione cada frame pra caber numa célula 256×384, com o pé
   alinhado à base (y=367) e margem lateral de pelo menos 8 px.
3. Monte as quatro tiras horizontais (`idle`=4 células, `move`=6,
   `attack`=4, `death`=6) e salve como
   `.atena/generated/zumbi-regeneration/v01/sheets/{idle,move,attack,death}_source.png`.
4. Avise esta sessão (ou a que estiver ativa) pra normalizar, validar em
   runtime real e conduzir a seleção/admissão, conforme SPEC-061.
