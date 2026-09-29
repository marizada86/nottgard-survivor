---
id: "ART-PROMPTS-024"
type: "prompts-de-arte"
title: "Enriquecimento de cenário e quebráveis temáticos por bioma"
status: "approved-for-generation"
created: "2026-09-28"
updated: "2026-09-28"
relations: ["[[ART-PROMPTS-007-biomas-props-thumbnails]]", "[[SPEC-063-objetos-quebraveis-e-rebalanceamento-de-pocao]]", "[[SPEC-062-fila-de-geracao-externa-de-assets]]", "[[PLAN-032-proxima-atualizacao-pos-playtest-2026-09-28]]"]
sources: ["data/stages.json", "ART-PROMPTS-007", "SPEC-022 a SPEC-031 (padrão de props de Dagruve)"]
---

# Enriquecimento de cenário e quebráveis temáticos por bioma

## Contexto

Dagruve/Docas já receberam dez lotes dedicados de props
(SPEC-022 a SPEC-031: braseiros, caixotes, velas, livros, barris, redes,
ossos, estrutura de doca, carga, margem). As outras sete fases jogáveis
(Shedaklah, Molor, Durao, Feng-tu, Shendilavri, Goranthis, Pilares) só têm a
família única de prop original de ART-PROMPTS-007
(`cogumelo`/`bolha`/`rocha`/`torii`/`cristal`/`cachoeira`/`pilar_abissal`).
Este lote propõe:

1. Duas famílias de prop novas por bioma sub-decorado, no mesmo contrato de
   ART-PROMPTS-007 (puramente decorativas, sem gameplay).
2. Um quebrável temático por bioma, já registrado em
   `data/enemies.json`/`core/battle.gd` ([[SPEC-063-objetos-quebraveis-e-rebalanceamento-de-pocao]])
   e rodando **com arte provisória reaproveitada** — este lote é o pedido de
   arte definitiva para substituir esses provisórios pela fila de
   [[SPEC-062-fila-de-geracao-externa-de-assets]].

Nenhuma imagem foi gerada por esta sessão do Claude Code (sem ferramenta de
geração disponível) — este documento prepara os prompts. Os blocos
"Prompt específico" abaixo continuam como referência técnica compacta (mesmo
formato dos demais ART-PROMPTS); a seção seguinte adapta tudo em parágrafos
prontos pra colar direto no ChatGPT.

## Como usar estes prompts no ChatGPT (revisão de 2026-09-28)

O ChatGPT (DALL·E / gerador de imagem nativo) não é a mesma ferramenta que
gerou os lotes anteriores (Leoric, Nyrelia) — ele tem limitações próprias
que mudam como o prompt deve ser escrito:

1. **Frase corrida, não lista de tags.** O ChatGPT interpreta melhor um
   parágrafo descritivo contínuo do que fragmentos separados por vírgula ou
   um bloco de "Constraints:" à parte. Por isso, cada linha das tabelas
   abaixo tem uma versão em **parágrafo único e autocontido** — é essa
   versão que deve ser colada, não a coluna "Prompt específico" resumida.
2. **Sem prompt negativo separado.** O ChatGPT não tem um campo de
   "negative prompt" como outras ferramentas — toda restrição precisa virar
   frase afirmativa dentro do próprio texto ("não inclua X" funciona, mas
   junto do resto, não como lista à parte). Os parágrafos já vêm assim.
3. **Fundo: cor sólida, não "transparente".** Pedir "fundo transparente"
   direto ao ChatGPT é pouco confiável — ele tende a ignorar ou devolver
   fundo branco/gradiente. Em vez disso, os prompts pedem um **fundo liso de
   cor sólida única** (magenta `#FF00FF` por padrão; ciano `#00FFFF` nas
   linhas onde o próprio objeto já usa tons de magenta/vinho, marcado na
   tabela). Depois de gerada a imagem, remova essa cor de fundo à parte
   (remove.bg, GIMP com "Cor para Alfa", Photopea, ou script próprio) para
   obter o PNG com alfa real — os testes automatizados do projeto exigem
   canal alfa de verdade (`tests/test_animation_assets.gd`), não fundo
   branco.
4. **Sem dimensão exata em pixels.** O ChatGPT não aceita "256×384" nem
   "256×256" como tamanho de saída — ele gera em tamanhos fixos (quadrado ou
   retrato/paisagem largos). Peça a imagem **quadrada**, na maior resolução
   oferecida; depois recorte/redimensione para o tamanho final do jogo (até
   256×256 para props, livre para quebráveis) num editor de imagem comum.
5. **Um objeto por mensagem.** Gere cada linha da tabela como uma mensagem
   separada. Se quiser consistência de estilo entre vários objetos do mesmo
   bioma, gere-os na mesma conversa, em sequência — mas sempre com o
   parágrafo completo, não uma versão abreviada assumindo que o ChatGPT
   "lembra" as regras da mensagem anterior.
6. **Cobertura sólida é crítico nos quebráveis.** O defeito que apareceu em
   Leoric e no Zumbi (silhueta quase transparente, com pixels soltos) é
   exatamente o tipo de erro que passa despercebido num teste automatizado
   de "tem algum pixel visível", mas salta aos olhos numa run de verdade.
   Os parágrafos dos quebráveis repetem essa exigência explicitamente — se
   uma imagem gerada sair com esse problema, **descarte e gere de novo**, não
   tente aproveitar.

## Bloco — props de cenário (decorativo, sem gameplay)

```text
Use case: stylized-concept
Asset type: prop isométrico de cenário
Style/medium: pixel art densa e sombria coerente com os sprites
Composition/framing: um objeto em três quartos isométrico, câmera 30 graus acima, base central inferior, 12% de margem, luz superior esquerda
Constraints: fundo realmente transparente, sem chão ou sombra separada, texto, personagens, moldura ou marca-d'água; silhueta legível a 64–160 px
```

Cada linha gera `assets/props/<id>.png`, candidata em
`.atena/generated/art-candidates/props/<id>_vNN.png`, final até 256×256 RGBA
— mesmo pipeline de ART-PROMPTS-007.

| Bioma | ID | Prompt específico (referência compacta) | Fundo sugerido |
|---|---|---|---|
| Shedaklah | `esporo_01` | Cacho pendente único de vagens de esporo, violeta-rosado, gotejando levemente. | magenta |
| Shedaklah | `esporo_02` | Trio de vagens da mesma família em alturas diferentes, uma já aberta e vazia. | magenta |
| Shedaklah | `lodo_01` | Poça de lodo fúngico elevada com bolhas de gás presas na superfície. | magenta |
| Molor | `estalactite_01` | Estalactite viscosa única pingando líquido verde-negro sobre poça pequena. | magenta |
| Molor | `estalactite_02` | Par de estalactites da mesma família, uma rachada na ponta. | magenta |
| Molor | `resina_01` | Poça de resina ácida solidificada com bolhas presas, sem brilho excessivo. | magenta |
| Durao | `corrente_01` | Corrente enferrujada solta caída no chão, elo final partido. | magenta |
| Durao | `corrente_02` | Poste baixo de prisão com corrente presa e grilhão vazio balançando. | magenta |
| Durao | `osso_01` | Pilha pequena de ossos e crânio parcial, poeira ferrugem ao redor. | magenta |
| Feng-tu | `lanterna_01` | Poste de lanterna de papel vermelha intacta, luz interna fraca. | magenta |
| Feng-tu | `lanterna_02` | Mesmo poste com a lanterna rasgada e apagada. | magenta |
| Feng-tu | `sino_01` | Sino de templo pequeno pendurado em suporte de madeira simples. | magenta |
| Shendilavri | `veu_01` | Véu de seda vinho pendurado, drapeado, leve brilho ilusório na borda. | **ciano** (objeto usa vinho/magenta) |
| Shendilavri | `taca_01` | Taça derramada sobre mesa baixa partida, vinho escuro escorrido. | **ciano** |
| Shendilavri | `espelho_ornado_01` | Moldura de espelho vazia (sem reflexo), dourada e desgastada. | magenta |
| Goranthis | `coluna_01` | Coluna de mármore rachada, musgo verde-água subindo pela base. | magenta |
| Goranthis | `flor_01` | Touceira baixa de flores brancas com uma pétala corrompida em roxo. | magenta |
| Goranthis | `taca_dourada_01` | Taça cerimonial dourada tombada sobre tecido branco manchado. | magenta |
| Pilares | `fragmento_01` | Fragmento flutuante de pilar quebrado, preso por energia lilás fraca. | **ciano** (energia lilás perto de magenta) |
| Pilares | `runa_01` | Placa de runa baixa, símbolo instável trocando de forma sutilmente. | magenta |
| Pilares | `nucleo_01` | Núcleo cristalino pequeno pulsando luz violeta fraca, base rachada. | **ciano** |

Aceite: mesma silhueta legível a 64–160 px; nenhuma variante introduz nova
facção, texto ou personagem; paleta de cada bioma segue a já aprovada em
ART-PROMPTS-007 (`<bioma>_ground`).

### Parágrafos prontos para ChatGPT — props de cenário

Cole um parágrafo por mensagem. Troque só a primeira frase (a descrição do
objeto); o resto já está pronto.

**`esporo_01`** — Shedaklah
> A single hanging cluster of fungal spore pods, violet-pink in color, dripping faintly with a thin viscous fluid. Dark-fantasy isometric pixel-art game prop, viewed from a three-quarter isometric angle tilted about 30 degrees from above, with soft directional light coming from the upper left. Crisp, clean pixel-art rendering with controlled dithering — no blur, no smooth anti-aliasing, no painterly softness. The object sits centered in the frame with roughly 12% empty margin on every side and does not touch or cross the image edges. Background: a single, completely flat and uniform solid magenta color (#FF00FF), with absolutely no ground, floor, cast shadow, gradient, vignette, texture, or scenery of any kind behind the object. Do not include any text, logo, watermark, frame, border, UI element, character, creature, or second object — render only this one object, alone. This is a purely decorative background prop, not a creature.

**`esporo_02`** — Shedaklah
> A tight trio of fungal spore pods at different heights, from the same family as a large hanging spore cluster, one of them already burst open and empty. Dark-fantasy isometric pixel-art game prop, viewed from a three-quarter isometric angle tilted about 30 degrees from above, with soft directional light coming from the upper left. Crisp, clean pixel-art rendering with controlled dithering — no blur, no smooth anti-aliasing. The object sits centered with roughly 12% empty margin on every side and does not touch the frame edges. Background: a single, completely flat and uniform solid magenta color (#FF00FF), with no ground, floor, cast shadow, gradient, vignette, texture, or scenery. Do not include any text, logo, watermark, frame, border, UI, character, creature, or second unrelated object — only this one prop, alone.

**`lodo_01`** — Shedaklah
> A raised pool of fungal slime/mud, brownish-violet, with small gas bubbles trapped just under its surface. Dark-fantasy isometric pixel-art game prop, viewed from a three-quarter isometric angle tilted about 30 degrees from above, soft directional light from the upper left, crisp clean pixel-art with controlled dithering, no blur or anti-aliasing softness. Centered with roughly 12% empty margin on every side, not touching the frame edges. Background: a single flat uniform solid magenta color (#FF00FF), no ground, floor, cast shadow, gradient, vignette, texture, or scenery. No text, logo, watermark, frame, border, UI, character, or creature — only this one object.

**`estalactite_01`** — Molor
> A single tall viscous stalactite dripping a greenish-black liquid onto a small puddle below it. Dark-fantasy isometric pixel-art game prop, three-quarter isometric angle tilted about 30 degrees from above, soft light from the upper left, crisp clean pixel art with controlled dithering, no blur or anti-aliasing. Centered with roughly 12% empty margin, not touching the frame edges. Background: single flat uniform solid magenta color (#FF00FF), no ground, floor, cast shadow, gradient, vignette, texture, or scenery. No text, logo, watermark, frame, border, UI, character, or creature — only this one object.

**`estalactite_02`** — Molor
> A pair of viscous stalactites from the same family as a dripping cave stalactite, one of them visibly cracked at its tip. Dark-fantasy isometric pixel-art game prop, three-quarter isometric angle tilted about 30 degrees from above, soft light from the upper left, crisp clean pixel art with controlled dithering, no blur or anti-aliasing. Centered with roughly 12% empty margin, not touching the frame edges. Background: single flat uniform solid magenta color (#FF00FF), no ground, floor, cast shadow, gradient, vignette, texture, or scenery. No text, logo, watermark, frame, border, UI, character, or creature — only this one object.

**`resina_01`** — Molor
> A pool of solidified acidic resin with small trapped bubbles inside it, dull surface with no excessive shine. Dark-fantasy isometric pixel-art game prop, three-quarter isometric angle tilted about 30 degrees from above, soft light from the upper left, crisp clean pixel art with controlled dithering, no blur or anti-aliasing. Centered with roughly 12% empty margin, not touching the frame edges. Background: single flat uniform solid magenta color (#FF00FF), no ground, floor, cast shadow, gradient, vignette, texture, or scenery. No text, logo, watermark, frame, border, UI, character, or creature — only this one object.

**`corrente_01`** — Durao
> A loose rusted iron chain lying coiled on the ground, its final link visibly broken. Dark-fantasy isometric pixel-art game prop, three-quarter isometric angle tilted about 30 degrees from above, soft light from the upper left, crisp clean pixel art with controlled dithering, no blur or anti-aliasing. Centered with roughly 12% empty margin, not touching the frame edges. Background: single flat uniform solid magenta color (#FF00FF), no ground, floor, cast shadow, gradient, vignette, texture, or scenery. No text, logo, watermark, frame, border, UI, character, or creature — only this one object.

**`corrente_02`** — Durao
> A short low prison post with a rusted chain attached and an empty open shackle swinging from it. Dark-fantasy isometric pixel-art game prop, three-quarter isometric angle tilted about 30 degrees from above, soft light from the upper left, crisp clean pixel art with controlled dithering, no blur or anti-aliasing. Centered with roughly 12% empty margin, not touching the frame edges. Background: single flat uniform solid magenta color (#FF00FF), no ground, floor, cast shadow, gradient, vignette, texture, or scenery. No text, logo, watermark, frame, border, UI, character, or creature — only this one object.

**`osso_01`** — Durao
> A small pile of bones with a partial skull resting on top, faint rust-colored dust scattered around the base. Dark-fantasy isometric pixel-art game prop, three-quarter isometric angle tilted about 30 degrees from above, soft light from the upper left, crisp clean pixel art with controlled dithering, no blur or anti-aliasing. Centered with roughly 12% empty margin, not touching the frame edges. Background: single flat uniform solid magenta color (#FF00FF), no ground, floor, cast shadow, gradient, vignette, texture, or scenery. No text, logo, watermark, frame, border, UI, character, or creature — only this one object.

**`lanterna_01`** — Feng-tu
> A short wooden post holding one intact red paper lantern, with a faint warm light glowing from inside it. Dark-fantasy isometric pixel-art game prop, three-quarter isometric angle tilted about 30 degrees from above, soft light from the upper left, crisp clean pixel art with controlled dithering, no blur or anti-aliasing. Centered with roughly 12% empty margin, not touching the frame edges. Background: single flat uniform solid magenta color (#FF00FF), no ground, floor, cast shadow, gradient, vignette, texture, or scenery. No text, logo, watermark, frame, border, UI, character, or creature — only this one object.

**`lanterna_02`** — Feng-tu
> The same wooden lantern post, but the paper lantern is now torn and unlit, from the same family as an intact glowing red paper lantern post. Dark-fantasy isometric pixel-art game prop, three-quarter isometric angle tilted about 30 degrees from above, soft light from the upper left, crisp clean pixel art with controlled dithering, no blur or anti-aliasing. Centered with roughly 12% empty margin, not touching the frame edges. Background: single flat uniform solid magenta color (#FF00FF), no ground, floor, cast shadow, gradient, vignette, texture, or scenery. No text, logo, watermark, frame, border, UI, character, or creature — only this one object.

**`sino_01`** — Feng-tu
> A small temple bell hanging from a simple wooden support frame. Dark-fantasy isometric pixel-art game prop, three-quarter isometric angle tilted about 30 degrees from above, soft light from the upper left, crisp clean pixel art with controlled dithering, no blur or anti-aliasing. Centered with roughly 12% empty margin, not touching the frame edges. Background: single flat uniform solid magenta color (#FF00FF), no ground, floor, cast shadow, gradient, vignette, texture, or scenery. No text, logo, watermark, frame, border, UI, character, or creature — only this one object.

**`veu_01`** — Shendilavri *(fundo ciano)*
> A draped wine-red silk veil hanging loosely, with a faint illusory shimmer along its edge. Dark-fantasy isometric pixel-art game prop, three-quarter isometric angle tilted about 30 degrees from above, soft light from the upper left, crisp clean pixel art with controlled dithering, no blur or anti-aliasing. Centered with roughly 12% empty margin, not touching the frame edges. Background: single flat uniform solid cyan color (#00FFFF) — use cyan, not magenta, because the object itself contains wine-red and magenta tones — with no ground, floor, cast shadow, gradient, vignette, texture, or scenery. No text, logo, watermark, frame, border, UI, character, or creature — only this one object.

**`taca_01`** — Shendilavri *(fundo ciano)*
> A spilled goblet lying on a low broken table, dark wine liquid poured out across the surface. Dark-fantasy isometric pixel-art game prop, three-quarter isometric angle tilted about 30 degrees from above, soft light from the upper left, crisp clean pixel art with controlled dithering, no blur or anti-aliasing. Centered with roughly 12% empty margin, not touching the frame edges. Background: single flat uniform solid cyan color (#00FFFF) — use cyan, not magenta, because the object itself contains wine-red tones — with no ground, floor, cast shadow, gradient, vignette, texture, or scenery. No text, logo, watermark, frame, border, UI, character, or creature — only this one object.

**`espelho_ornado_01`** — Shendilavri
> An empty ornate mirror frame with no reflection inside it, gold-colored and visibly worn/tarnished. Dark-fantasy isometric pixel-art game prop, three-quarter isometric angle tilted about 30 degrees from above, soft light from the upper left, crisp clean pixel art with controlled dithering, no blur or anti-aliasing. Centered with roughly 12% empty margin, not touching the frame edges. Background: single flat uniform solid magenta color (#FF00FF), no ground, floor, cast shadow, gradient, vignette, texture, or scenery. No text, logo, watermark, frame, border, UI, character, or creature — only this one object.

**`coluna_01`** — Goranthis
> A cracked marble column with pale teal-green moss growing up from its base. Dark-fantasy isometric pixel-art game prop, three-quarter isometric angle tilted about 30 degrees from above, soft light from the upper left, crisp clean pixel art with controlled dithering, no blur or anti-aliasing. Centered with roughly 12% empty margin, not touching the frame edges. Background: single flat uniform solid magenta color (#FF00FF), no ground, floor, cast shadow, gradient, vignette, texture, or scenery. No text, logo, watermark, frame, border, UI, character, or creature — only this one object.

**`flor_01`** — Goranthis
> A low cluster of white flowers, with a single petal corrupted into a deep purple color. Dark-fantasy isometric pixel-art game prop, three-quarter isometric angle tilted about 30 degrees from above, soft light from the upper left, crisp clean pixel art with controlled dithering, no blur or anti-aliasing. Centered with roughly 12% empty margin, not touching the frame edges. Background: single flat uniform solid magenta color (#FF00FF), no ground, floor, cast shadow, gradient, vignette, texture, or scenery. No text, logo, watermark, frame, border, UI, character, or creature — only this one object.

**`taca_dourada_01`** — Goranthis
> A tipped-over ceremonial golden goblet resting on a stained white cloth. Dark-fantasy isometric pixel-art game prop, three-quarter isometric angle tilted about 30 degrees from above, soft light from the upper left, crisp clean pixel art with controlled dithering, no blur or anti-aliasing. Centered with roughly 12% empty margin, not touching the frame edges. Background: single flat uniform solid magenta color (#FF00FF), no ground, floor, cast shadow, gradient, vignette, texture, or scenery. No text, logo, watermark, frame, border, UI, character, or creature — only this one object.

**`fragmento_01`** — Pilares *(fundo ciano)*
> A small floating fragment of a broken stone pillar, held together by a faint purple magical energy. Dark-fantasy isometric pixel-art game prop, three-quarter isometric angle tilted about 30 degrees from above, soft light from the upper left, crisp clean pixel art with controlled dithering, no blur or anti-aliasing. Centered with roughly 12% empty margin, not touching the frame edges. Background: single flat uniform solid cyan color (#00FFFF) — use cyan, not magenta, because the magical energy glow is close to magenta/purple — with no ground, floor, cast shadow, gradient, vignette, texture, or scenery. No text, logo, watermark, frame, border, UI, character, or creature — only this one object.

**`runa_01`** — Pilares
> A low stone rune plaque with an unstable symbol carved into it, subtly shifting shape. Dark-fantasy isometric pixel-art game prop, three-quarter isometric angle tilted about 30 degrees from above, soft light from the upper left, crisp clean pixel art with controlled dithering, no blur or anti-aliasing. Centered with roughly 12% empty margin, not touching the frame edges. Background: single flat uniform solid magenta color (#FF00FF), no ground, floor, cast shadow, gradient, vignette, texture, or scenery. No text, logo, watermark, frame, border, UI, character, or creature — only this one object.

**`nucleo_01`** — Pilares *(fundo ciano)*
> A small crystalline core pulsing with a faint violet light, sitting on a cracked stone base. Dark-fantasy isometric pixel-art game prop, three-quarter isometric angle tilted about 30 degrees from above, soft light from the upper left, crisp clean pixel art with controlled dithering, no blur or anti-aliasing. Centered with roughly 12% empty margin, not touching the frame edges. Background: single flat uniform solid cyan color (#00FFFF) — use cyan, not magenta, because the core's glow is violet, close to magenta — with no ground, floor, cast shadow, gradient, vignette, texture, or scenery. No text, logo, watermark, frame, border, UI, character, or creature — only this one object.

## Bloco — quebráveis (gameplay: HP baixo, drop garantido)

```text
Use case: stylized-concept
Asset type: objeto quebrável de cenário (inimigo inerte no motor)
Style/medium: pixel art densa e sombria coerente com os sprites de inimigo
Composition/framing: um objeto único em três quartos isométrico, câmera 30 graus acima, enquadramento centralizado, 10–14% de margem, luz superior esquerda
Constraints: fundo realmente transparente, sem chão, sombra separada, texto, personagem, moldura ou marca-d'água; silhueta sólida e legível a 62 px de altura de exibição; nada semitransparente ou com pixels soltos (defeito já visto em Leoric/Zumbi — ver SPEC-061)
```

Cada linha gera `assets/enemies/<id>.png`, RGBA, dimensão livre (a engine
escala mantendo proporção). Já existem no jogo como
`flags: ["inerte", "quebravel"]` — este lote só troca a arte provisória
reaproveitada pela definitiva.

| ID (já registrado) | Bioma | Placeholder atual | Prompt específico (referência compacta) | Fundo sugerido |
|---|---|---|---|---|
| `saco_de_esporos_quebravel` | Shedaklah | `esporo_voador.png` reaproveitado | Vagem de esporo grande e arredondada, violeta-rosada, prestes a estourar, veios luminosos finos. | magenta |
| `casulo_viscoso_quebravel` | Molor | `bolha_de_slime.png` reaproveitado | Casulo viscoso verde-negro preso a base rochosa curta, membrana tensa. | magenta |
| `urna_funeraria_quebravel` | Durao | `alma_penada.png` reaproveitado | Urna funerária de pedra basáltica rachada, veio azul-fantasma fraco na lateral. | magenta |
| `lanterna_de_papel_quebravel` | Feng-tu | `estatua_do_templo.png` reaproveitado | Lanterna de papel vermelha pendurada em poste curto de madeira, sem chama visível. | magenta |
| `espelho_ilusorio_quebravel` | Shendilavri | `ilusao_de_sucubo.png` reaproveitado | Espelho ilusório vinho e prata, moldura de cristal, reflexo levemente distorcido dentro. | **ciano** |
| `estatua_rachada_quebravel` | Goranthis | `guardiao_de_goranthis.png` reaproveitado | Estátua de mármore marfim rachada ao meio, fissura revelando um brilho vermelho-carne contido — sem gore explícito. | magenta |
| `relicario_instavel_quebravel` | Pilares | `gargula.png` reaproveitado | Relicário pequeno flutuante, pedra violeta-negra com runa instável, leve distorção ao redor. | **ciano** |

Aceite: silhueta sólida (sem o defeito de opacidade esparsa já visto em
Leoric/Zumbi), reconhecível como objeto do bioma, legível a 62 px.

### Parágrafos prontos para ChatGPT — quebráveis

**`saco_de_esporos_quebravel`** — Shedaklah
> A large rounded fungal spore pod, violet-pink in color, swollen and looking like it is about to burst, with thin glowing veins running across its surface. Dark-fantasy isometric pixel-art game object (a destructible scenery prop, not a creature), viewed from a three-quarter isometric angle tilted about 30 degrees from above, soft directional light from the upper left, crisp clean pixel-art rendering with controlled dithering, no blur or anti-aliasing. The object sits centered with roughly 12% empty margin on every side and does not touch the frame edges. Background: a single, completely flat and uniform solid magenta color (#FF00FF), with no ground, floor, cast shadow, gradient, vignette, texture, or scenery. Do not include any text, logo, watermark, frame, border, UI, character, or creature — only this one object, alone. Critically, the object's silhouette must be solid and fully opaque all the way through — no wispy, translucent, faded, ghostly, or speckled/scattered-pixel appearance anywhere on it; it must read as one clear, solid shape even at a small display size of about 62 pixels tall.

**`casulo_viscoso_quebravel`** — Molor
> A viscous greenish-black cocoon attached to a short rocky base, its membrane visibly taut and tense. Dark-fantasy isometric pixel-art game object (a destructible scenery prop, not a creature), three-quarter isometric angle tilted about 30 degrees from above, soft light from the upper left, crisp clean pixel art with controlled dithering, no blur or anti-aliasing. Centered with roughly 12% empty margin, not touching the frame edges. Background: single flat uniform solid magenta color (#FF00FF), no ground, floor, cast shadow, gradient, vignette, texture, or scenery. No text, logo, watermark, frame, border, UI, character, or creature — only this one object. Critically, the silhouette must be solid and fully opaque throughout — no wispy, translucent, faded, or speckled/scattered-pixel look — reading as one clear solid shape even at about 62 pixels tall.

**`urna_funeraria_quebravel`** — Durao
> A cracked basalt funerary urn with a faint ghostly-blue vein of light running along its side. Dark-fantasy isometric pixel-art game object (a destructible scenery prop, not a creature), three-quarter isometric angle tilted about 30 degrees from above, soft light from the upper left, crisp clean pixel art with controlled dithering, no blur or anti-aliasing. Centered with roughly 12% empty margin, not touching the frame edges. Background: single flat uniform solid magenta color (#FF00FF), no ground, floor, cast shadow, gradient, vignette, texture, or scenery. No text, logo, watermark, frame, border, UI, character, or creature — only this one object. Critically, the silhouette must be solid and fully opaque throughout — no wispy, translucent, faded, or speckled/scattered-pixel look — reading as one clear solid shape even at about 62 pixels tall.

**`lanterna_de_papel_quebravel`** — Feng-tu
> A red paper lantern hanging from a short wooden post, unlit with no visible flame inside. Dark-fantasy isometric pixel-art game object (a destructible scenery prop, not a creature), three-quarter isometric angle tilted about 30 degrees from above, soft light from the upper left, crisp clean pixel art with controlled dithering, no blur or anti-aliasing. Centered with roughly 12% empty margin, not touching the frame edges. Background: single flat uniform solid magenta color (#FF00FF), no ground, floor, cast shadow, gradient, vignette, texture, or scenery. No text, logo, watermark, frame, border, UI, character, or creature — only this one object. Critically, the silhouette must be solid and fully opaque throughout — no wispy, translucent, faded, or speckled/scattered-pixel look — reading as one clear solid shape even at about 62 pixels tall.

**`espelho_ilusorio_quebravel`** — Shendilavri *(fundo ciano)*
> An illusory mirror with a crystal frame, wine-red and silver in color, its reflection inside subtly distorted. Dark-fantasy isometric pixel-art game object (a destructible scenery prop, not a creature), three-quarter isometric angle tilted about 30 degrees from above, soft light from the upper left, crisp clean pixel art with controlled dithering, no blur or anti-aliasing. Centered with roughly 12% empty margin, not touching the frame edges. Background: single flat uniform solid cyan color (#00FFFF) — use cyan, not magenta, because the mirror itself contains wine-red and magenta tones — with no ground, floor, cast shadow, gradient, vignette, texture, or scenery. No text, logo, watermark, frame, border, UI, character, or creature — only this one object. Critically, the silhouette must be solid and fully opaque throughout — no wispy, translucent, faded, or speckled/scattered-pixel look — reading as one clear solid shape even at about 62 pixels tall.

**`estatua_rachada_quebravel`** — Goranthis
> An ivory marble statue cracked down the middle, with a contained reddish-flesh-toned glow visible through the crack — no explicit gore, just a faint unsettling light. Dark-fantasy isometric pixel-art game object (a destructible scenery prop, not a creature), three-quarter isometric angle tilted about 30 degrees from above, soft light from the upper left, crisp clean pixel art with controlled dithering, no blur or anti-aliasing. Centered with roughly 12% empty margin, not touching the frame edges. Background: single flat uniform solid magenta color (#FF00FF), no ground, floor, cast shadow, gradient, vignette, texture, or scenery. No text, logo, watermark, frame, border, UI, character, or creature — only this one object. Critically, the silhouette must be solid and fully opaque throughout — no wispy, translucent, faded, or speckled/scattered-pixel look — reading as one clear solid shape even at about 62 pixels tall.

**`relicario_instavel_quebravel`** — Pilares *(fundo ciano)*
> A small floating reliquary made of violet-black stone, carved with an unstable rune, with a faint visual distortion shimmering around it. Dark-fantasy isometric pixel-art game object (a destructible scenery prop, not a creature), three-quarter isometric angle tilted about 30 degrees from above, soft light from the upper left, crisp clean pixel art with controlled dithering, no blur or anti-aliasing. Centered with roughly 12% empty margin, not touching the frame edges. Background: single flat uniform solid cyan color (#00FFFF) — use cyan, not magenta, because the stone and its glow are violet, close to magenta — with no ground, floor, cast shadow, gradient, vignette, texture, or scenery. No text, logo, watermark, frame, border, UI, character, or creature — only this one object. Critically, the silhouette must be solid and fully opaque throughout — no wispy, translucent, faded, or speckled/scattered-pixel look — reading as one clear solid shape even at about 62 pixels tall.

## Fila de geração

Estas 7 linhas de quebrável entram em
[[SPEC-062-fila-de-geracao-externa-de-assets]] junto do Zumbi. As 21 linhas
de prop de cenário viraram sete specs por bioma
([[SPEC-065-props-de-shedaklah]] a [[SPEC-071-props-dos-pilares]]) — ver
recomendação de priorizar os quebráveis primeiro, já registrada em cada uma
delas.
