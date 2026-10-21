# Lista de assets para gerar ou regerar no ChatGPT — 2026-10-21 (r1)

Status: DRAFT. Nada aqui foi gerado, aprovado ou promovido a CANON. Base: `ASSET-CHECKUP-20261021-r1.md` e as referências CANON do Vault (`F:\dev\nottgard-vault\output\referencias-personagens`, HEAD `50008c9`).
Regra do projeto: o Vault vale mais que o Nottcard. Onde a imagem gerada divergir do texto ou do CANON do Vault, o Vault vence e a imagem é refeita.

## 0. Como usar esta lista

**Entrega.** Salve cada imagem como PNG em `F:\dev\abyss-megadungeon\assets_incoming\<ID>.png` (varie com `_v2`, `_v3`). A Atena recorta, remove o fundo, redimensiona, monta as folhas de animação, importa no Godot e roda os testes. Nada entra no jogo sem seu aceite.

**Formato que o ChatGPT gera bem.** 1024×1024, 1536×1024 (paisagem) ou 1024×1536 (retrato). Todos os tamanhos finais abaixo são **alvo do jogo**; gere maior e a Atena reduz. Peça uma peça por imagem, centralizada, com 8% de margem. Para folhas de ícones (grade) peça espaço generoso entre as células.

**Fundos (já validado com Síntese e Nidhogg).**
- Sprites e ícones: `flat solid light-gray background #B4B4B4, no gradient, no floor shadow, no vignette`. A Atena remove o fundo por script.
- Molduras de UI e peças com interior vazio: `solid pure magenta #FF00FF background, and the empty interior area also pure magenta #FF00FF`.
- Brilhos aditivos: `on pure black background`.

**Proibido em todas as imagens:** texto, letras, números, logotipo, marca d'água, assinatura. Todo texto é desenhado pelo Godot.

**Anexe sempre como referência de estilo** (3 a 5 imagens por pedido):
- personagens e criaturas: `assets/enemies/zuggtmoy.png`, `assets/enemies/malcanthet.png`, `assets/portraits/durvall.png`;
- UI: `assets/ui/ficha/ficha_moldura_painel.png`, `assets/ui/ficha/ficha_slot_moldura.png`, `assets/ui/lettering/placa_titulo_larga.png`, `assets/ui/title/logo.png`;
- ícones: 8 ícones de `assets/icons/weapons` e `assets/icons/items` (ver folha em `.atena/generated/asset-checkup-20261021/m-icons.png`);
- cenas: `assets/ui/boss-intros/sacerdote_mente_derretida.png`, `assets/stages/shedaklah_thumb.png`.

### Blocos de prompt reutilizáveis

**STYLE-CHAR** (criaturas e personagens):
> Dark-fantasy 2D game sprite illustration in the exact style of the attached references: dense pixel-art-inspired painting with painterly shading, crisp dark outlines, muted desaturated palette, warm gold highlights and one saturated accent color for the magic of the subject, strong rim light from upper left, no soft airbrush blur. Full body, standing, front 3/4 view, centered, feet visible, facing slightly right. Readable silhouette at 150 px height. [background clause]. No text, no frame, no shadow on the floor.

**STYLE-UI** (molduras):
> Ornate dark-fantasy game UI element in the exact style of the attached ficha frame: aged dark iron and tarnished gold filigree, small four-point star ornaments at the corners, thin double border, interior dark charcoal with faint engraved texture, perfectly symmetrical, flat front view, no perspective, crisp edges so it can be 9-sliced. [background clause]. No text, no numbers, no characters inside.

**STYLE-ICON** (ícones 128×128):
> Single game icon in the style of the attached icons: centered object, dense pixel-art-inspired painting, dark outline, strong readable shape, limited palette with one glowing accent, slight rim light, no frame, no text, fills 80% of the canvas. Flat solid light-gray background #B4B4B4.

**STYLE-SCENE** (introduções e miniaturas):
> Dark-fantasy pixel-art-inspired painted illustration in the exact style of the attached references: moody low-key lighting, atmospheric fog, rich detail, 16:9 composition (safe margins: keep the subject inside the central 80%). No text, no UI, no frame, no watermark.

## 1. Lote V — Regerar para aderir ao Vault (prioridade P0)

Cada item: ID, destino, alvo, o que está errado, referências CANON a anexar, prompt.

| ID | Destino | Alvo | O que está errado |
|---|---|---|---|
| V01 | `assets/enemies/sintese_abissal.png` + folhas | estático 320×480; quadros 256×384 | hoje é placeholder derivado do canon, sem animação desenhada |
| V02 | `assets/enemies/death_tyrant.png` + folhas | 320×480; 256×384 | beholder de olho azul; canon é escuro, de espinhos, olhos vermelhos |
| V03 | `assets/enemies/receptaculo_de_juiblex.png` + folhas | 320×480; 256×384 | limo humanoide; canon é monte de carne com ovo/núcleo |
| V04 | `assets/enemies/gargula.png` + folhas | 320×480; 256×384 | fera de pedra cinza; canon é alada, prateada com veios lilás |
| V05 | `assets/enemies/master_of_cruelties.png` + folhas | 320×480; 256×384 | demônio alado esguio; canon é encouraçado, de chifres, rosto de caveira, lança |
| V06 | `assets/enemies/manifestacao_de_juiblex.png` + folhas | 512×320 (célula); 320×480 | limo verde; canon é massa negra de tentáculos com olhos vermelhos |
| V07 | `assets/enemies/nidhogg.png` + folhas (novo) | 320×480; 256×384 | só existe cabeça e pescoço recortados |
| V08 | `assets/enemies/molydeus_*.png` | edição leve | segunda cabeça (cobra) vermelha; canon é verde-oliva |
| V09 | `assets/enemies/ezro.png`, `aberracao_shu.png` | 320×480 | paleta e acabamento diferentes do canon |
| V10 | `assets/portraits/kayron.png`, `assets/heroes/kayron.png` | 640×427; 256×384 | olhos com pupila escura; `DEC-AASIMAR-EYES-001` pede uma única cor |
| V11 | `assets/ui/boss-intros/sacerdote_mente_derretida.png` | 640×360 | a cena é um cais com mar; o chefe é de Dagruve |

**Poses para animação (V01–V07).** Para cada criatura gere, no mesmo estilo e mesma escala:
1. `_idle` (pose neutra), 2. `_attack` (golpe a meio caminho), 3. `_special` (se houver), 4. `_death` (caindo, ou desfazendo, ver nota). A Atena monta os quadros intermediários (balanço, avanço, tombo, pulso) a partir das poses; é o mesmo processo usado no placeholder da Síntese, mas com poses reais.

**Prompts (anexe também as referências CANON listadas):**

**V01 — A Síntese Abissal.** Refs CANON: `output/referencias-personagens/SINTESE-ABISSAL/roxo-r01/sintese-{front,back,left,right}-v01.png`, `B-OITO-FRONT-001/sintese-reference-user.png`.
> STYLE-CHAR. A hulking aberrant armored monstrosity that fills four grid tiles: black armor with gold trim, shoulders like jagged pauldrons, a crowned spiked helm with a glowing purple core in the chest, long black slime tendrils hanging from arms and legs, purple energy cracks and dripping purple ooze (all supernatural effects are PURPLE, never green). Same identity as the attached canon views. Poses: (1) idle, arms down, (2) attack: one clawed arm raised, purple energy gathering, (3) special: arms spread, purple shockwave bursting from the core, (4) death: collapsing into a pool of black-purple ooze, armor plates sliding apart.

**V02 — Death Tyrant.** Refs: `Death-Tyrant/r02/death-tyrant-front-candidate-v03.png`, `reference-1.png`, `reference-2.png`, `DTDD-views-r01/death-tyrant-*`.
> STYLE-CHAR (floating creature, no feet, hover glow instead of shadow). A dark spiked skull-like beholder corpse: black bone armor plates, ridged crest, a huge glowing red central eye, many smaller red eyes on writhing black stalks, jagged teeth in a wide maw. Same identity as the attached canon. Poses: idle hover; attack with mouth open and red rays; death with eyes dimming and body collapsing.

**V03 — Receptáculo de Juiblex.** Ref: `B-FALT-003-03/r01/receptaculo-front-candidate-v01.png`.
> STYLE-CHAR (creature low to the ground). A pulsing mound of pale-pink and ochre flesh covered with small eye-like pores, with a large translucent egg-like core in the top center, wet and ritual-fed. Same identity as the attached canon. Poses: idle pulse, attack (flesh lash/spurt), death (core cracks, mound deflates).

**V04 — Gárgula (família da Biblioteca Corrompida).** Ref: `RHE-004/S04-S05-biblioteca/refhq-r01/gargula-familia-front-candidate-v02.png`.
> STYLE-CHAR. A winged humanoid gargoyle in silver-lilac armor with violet veins and glowing eyes, face deformed as if stone had been melted and remolded like clay. Same identity as the attached canon. Poses: idle perched, walking, attack lunge, death (shatters into stone).

**V05 — Crueldades.** Refs: `MCMD/r01/crueldades-front-candidate-v01.png` (+ views), `15_Fontes/Referências Visuais/Crueldades/crueldades-referencia-usuario-r01.png`.
> STYLE-CHAR. A tall armored demon with curved horns and a skull-like face, crimson-black plate armor with spikes, torn cape, long dark spear. The Vault says it flies and enchants with a captivating presence: add a subtle hovering pose and a faint charm aura. Same identity as the attached canon. Poses: idle hover, spear thrust, death.

**V06 — Manifestação de Juiblex.** Refs: `JTJJ-r1/fronts/juiblex-front-candidate-v01.png`, `JTJJ-r1/inputs/juiblex-anexo-r1.png`.
> STYLE-CHAR (large, low). A towering mass of glossy black tar-like tendrils with several glowing red eyes, hive-mind creature, slime dripping. Same identity as the attached canon. Poses: idle, attack (tendril whip), special (splits into smaller blobs), death (melts).
> *Nota:* o Vault canoniza a massa negra de olhos vermelhos; os limos verdes continuam válidos para "Limo de Juiblex" e "Pudim Negro".

**V07 — Nidhogg (corpo inteiro).** Refs: `CNCR-r02/nidhogg/nidhogg-head-neck-hq-r03-v01.png` e `nidhogg-reference-selected-r01.png`. O Vault não define o corpo; só cabeça e pescoço.
> STYLE-CHAR (vertical 1024×1536). Nidhogg, a colossal dark-gray scaled serpent-dragon with branching pale antlers of root-wood, green leaf-like blades along the neck and one pale pink eye, rising out of the ground between giant tree roots. Show the head and a long arched neck emerging from a hole in root-covered soil, with the lower body implied underground. Poses: idle (head weaving), attack (head striking down with open jaws), death (head sinking into the roots).

**V08 — Molydeus.** Edição: anexe `assets/enemies/molydeus_chefe.png` e o canon `15_Fontes/Referências Visuais/Molydeus/molydeus-referencia-r1.png`.
> Edit the attached sprite: keep everything identical (red muscular body, wolf head, axe, chains) but recolor the snake draped over the shoulder to olive green with a yellow belly, as in the canon reference. Same background and size.

**V09 — Ezro e Shu.** Refs: `EEEE-r01/ezro/ezro-option-A-v01.png`, `B-FALT-003-02/r02/shu-front-candidate-v02.png`.
> STYLE-CHAR. (Ezro) a huge warty brown-ochre toad demon, wide mouth, heavy squat stance. (Shu) a realistic, long-legged grasshopper-like aberration with long antennae, standing upright. Same identity as the attached canon. One image each.

**V10 — Kayron (olhos).** Refs: `CHAR-028/pos-S24/r02-eyes/kayron-front-eyes-v01.png`, decisão `DEC-AASIMAR-EYES-001`.
> Edit the attached portrait: keep the face, white hair, black outfit and background unchanged, but make each eye one solid red color across the whole visible eye, no white sclera, no darker pupil, no iris ring. Same size.

**V11 — Introdução do Sacerdote da Mente Derretida (Dagruve).** Ref atual: `assets/ui/boss-intros/sacerdote_mente_derretida.png`.
> STYLE-SCENE. Keep the priest exactly as in the attached art (hooded wax-melted robes, swinging censer, purple smoke) but set him in the abandoned chapel and graveyard of Dagruve at night: crooked tombstones, a visible fracture in the wall of fog behind him, green mist rolling over broken stone paths, an old wooden chapel with lit windows. No sea, no pier.

## 2. Lote U — Kit de UI para escolher itens, aprimoramentos e habilidades (P1)

**Problema.** O painel de oferta (`ui/offer_card.gd`) é uma lista de linhas pretas de 680×64, enquanto a ficha do herói tem moldura ornamentada. O jogador não distingue tipo, raridade, novidade nem evolução.

**Proposta de layout (a Atena implementa quando os assets chegarem).** Três cartões verticais lado a lado (4 no altar), cada um com 280×400 px lógicos a 1280×720:
```
        [ plaqueta do cabeçalho: NÍVEL 9 / ALTAR / LOJA ]
 ┌─────────┐   ┌─────────┐   ┌─────────┐
 │ [fita]  │   │ [fita]  │   │ [fita]  │   fita: NOVA / EVOLUI / SINERGIA / MALDIÇÃO
 │ ┌─────┐ │   │ ┌─────┐ │   │ ┌─────┐ │
 │ │ícone│ │   │ │ícone│ │   │ │ícone│ │   placa do ícone, gema de raridade no topo
 │ └─────┘ │   │ └─────┘ │   │ └─────┘ │
 │ Nome    │   │ Nome    │   │ Nome    │
 │ Nv 1→2  │   │ texto   │   │ ▲2  ▼1  │   chips de ▲ ▼ (altar), preço (loja)
 │ texto…  │   │ …       │   │ …       │
 │   [1]   │   │   [2]   │   │   [3]   │
 └─────────┘   └─────────┘   └─────────┘
          [ Rerrolar (R) — 3 restantes ]
```
**Estado (2026-10-21):** o cartão já existe com placeholders desenhados em código (`ui/offer_card.gd`, modo `setup_card`; `ui/hud.gd` usa a fileira horizontal em nível e altar). Quando as imagens chegarem basta soltar, já reduzidas a 1x, em `res://assets/ui/oferta/`: `oferta_cartao.png` (280×400, nove fatias, margem 28) e `oferta_placa_icone.png` (96×96, margem 16); sem os arquivos, valem os placeholders. Gemas, fitas, glifos e brilho (U03–U09) entram depois por código. Capturas antes e depois em `.atena/generated/asset-checkup-20261021/` (`after-oferta-*.png`).

Tinta por tipo e por raridade é feita em código (um único quadro neutro serve a todos); gemas e fitas têm variantes porque a cor sozinha não basta.

| ID | Destino | Alvo | O quê | Prompt (STYLE-UI) |
|---|---|---|---|---|
| U01 | `assets/ui/oferta/oferta_cartao.png` | 560×800 (9-slice, margens 56) | moldura neutra do cartão, interior vazio | "Vertical rectangular card frame, 1024×1536, thick ornate border with a recessed top window area marked by a slightly lighter inner bevel, interior plain dark charcoal stone texture. Magenta background and magenta where the card interior is NOT needed (outside only)." |
| U02 | `assets/ui/oferta/oferta_placa_icone.png` | 192×192 | placa quadrada do ícone, janela interior magenta | "Square icon plate, ornate gold-iron frame with a soft inner bevel, empty square window in the center filled with magenta." |
| U03 | `assets/ui/oferta/oferta_gemas.png` | 5 × 96×64 | gemas de raridade: Comum (cinza), Mágico (azul), Incomum (verde), Raro (âmbar), Único (roxo e dourado) | "Five small ornate gem setpieces in a row on a flat gray background, each a different gem color: gray quartz, blue sapphire, green emerald, amber topaz, purple amethyst with a gold crown. Same mount design, evenly spaced." |
| U04 | `assets/ui/oferta/oferta_fitas.png` | 5 × 256×72 | fitas em branco: NOVA (verde), EVOLUI (dourada), SINERGIA (azul), MALDIÇÃO (vermelha), BÊNÇÃO (violeta) | "Five blank ribbon banners with swallowtail ends and thin gold trim, one per color, stacked on a gray background, each large empty central area for text." |
| U05 | `assets/ui/oferta/oferta_cabecalho.png` | 3 × 800×140 | plaquetas largas em branco: Nível, Altar, Loja/Baú | "Three wide ornate blank title plaques with pointed filigree ends, same style as the attached placa_titulo_larga, stacked with gaps, empty central field for text, magenta background." |
| U06 | `assets/ui/oferta/oferta_glifos.png` | 9 × 64×64 | glifos de categoria: arma, passiva, equipamento, bênção, maldição, evolução, sinergia, moeda, dado | "Nine small monochrome gold-and-bone line-and-fill game glyphs in a 3×3 grid on gray: crossed swords, shield with plus, armor chest piece, winged hand giving light, broken chain with skull, arrow up with flame, two interlocking rings, coin stack, a twenty-sided die." |
| U07 | `assets/ui/oferta/oferta_setas.png` | 4 × 32×32 | ▲ verde, ▼ vermelha, ◆ neutra, estrela "nova" | "Four tiny game chips: green up-arrow, red down-arrow, gray diamond, gold four-point star, each with a thin dark outline." |
| U08 | `assets/ui/oferta/oferta_rerrolar.png` | 378×63 (9-slice) + dado 48×48 | botão de rerrolar, normal e apagado | "Wide ornate button frame like the attached botao_acao_moldura, plus a separate small twenty-sided die icon. Provide normal and desaturated disabled versions in the same image, stacked." |
| U09 | `assets/ui/oferta/oferta_brilho.png` | 560×800 | brilho de seleção em volta do cartão | "Soft golden rune-light halo outlining a vertical card shape, bright thin edge glow with a few floating sparks, on pure black background, additive style." |
| U10 | `assets/ui/oferta/oferta_fundo_textura.png` | 256×256 (tile) | textura de fundo do cartão | "Seamless tileable dark charcoal leather and stone texture with very faint engraved runes, low contrast." |
| U11 | `assets/ui/oferta/oferta_preco.png` | 160×48 | plaqueta de preço da loja, vazia | "Small blank price tag plate with a gold coin emblem on the left edge, ornate rim, empty center for numbers." |

**HUD e janelas (P1/P2)**

| ID | Destino | Alvo | O quê |
|---|---|---|---|
| U12 | `assets/ui/hud/hud_painel_heroi.png` | 400×150 (9-slice) | moldura do painel do herói (canto superior esquerdo), mesmo vocabulário da ficha |
| U13 | `assets/ui/hud/hud_barra_pv.png` | 300×28 + preenchimento | caixilho da barra de PV com tampas ornamentadas; preenchimento vermelho-sangue com brilho |
| U14 | `assets/ui/hud/hud_barra_xp.png` | 300×12 | caixilho fino + preenchimento azul |
| U15 | `assets/ui/hud/hud_habilidade_anel.png` | 96×96 | anel redondo ornamentado do slot de habilidade (com marcas para a recarga) |
| U16 | `assets/ui/hud/hud_chips.png` | 4 × 120×36 | molduras dos medidores: moedas, abates, CA, CAM |
| U17 | `assets/ui/hud/hud_cronometro.png` | 180×60 | placa do cronômetro |
| U18 | `assets/ui/hud/hud_botoes.png` | 3 × 56×56 | botões quadrados de topo: pausa, ajuda "?", velocidade "1x" |
| U19 | `assets/ui/hud/hud_lista_armas.png` | 220×40 (9-slice) | fundo discreto da lista de armas (canto inferior esquerdo) |
| U20 | `assets/ui/modal/modal_moldura.png` | 640×360 (9-slice, margens 64) | janela média para reviver, pausa, vitória/derrota e confirmações |
| U21 | `assets/ui/modal/tooltip_moldura.png` | 360×220 (9-slice) | moldura da dica de detalhe do cartão |

Prompts de U12–U21: STYLE-UI + "perfectly rectangular 9-slice-ready [descrição], interior empty magenta". Para U13 gere o caixilho e o preenchimento separados (preenchimento horizontal de 256×24, gradiente vermelho-sangue com realce, sem texto).

## 3. Lote Q — Quartel (menus fora da partida) (P1/P2)

**Problema.** Marcas, Melhorias e Conquistas são listas de texto; heróis e fases sem cartões; códex vazio.

| ID | Destino | Alvo | O quê |
|---|---|---|---|
| Q01 | `assets/icons/quartel/abas.png` | 8 × 48×48 | ícones das abas: Jogar, Marcas, Melhorias, Conquistas, Códex, Opções, Diário, Ranking |
| Q02 | `assets/ui/quartel/heroi_cartao.png` | 360×72 (9-slice) + 96×96 | cartão de herói da lista com janela do retrato; versão bloqueada com corrente e cadeado |
| Q03 | `assets/ui/quartel/fase_cartao.png` | 360×88 (9-slice) | cartão de fase com janela de miniatura, medalhão numerado e versão bloqueada |
| Q04 | `assets/icons/melhorias/*.png` | 18 × 96×96 | um ícone por melhoria (ver tabela abaixo), em 3 folhas de 6 |
| Q05 | `assets/ui/quartel/pips.png` | 4 × 24×24 + botões | pip de nível vazio e cheio; molduras de botão "Comprar", "Máx", "Bloqueado" |
| Q06 | `assets/icons/marcas/*.png` | 9 × 128×128 | marcas do Abismo: Carapaça, Pressa, Horda, Elites despertos, Fúria, Abismo vivo, Fome, Chefe desperto, Sem trégua |
| Q07 | `assets/ui/quartel/medalhas.png` | 4 × 96×96 | medalha de conquista: bloqueada, bronze, prata, ouro (e especial) |
| Q08 | `assets/icons/conquistas/*.png` | 12 × 64×64 | emblemas por categoria: abates, sequência sem dano, sobrevivência, nível, moedas, baús, elites, chefes, rituais, Ecos, HQs, biografias de herói |
| Q09 | `assets/icons/codex/*.png` | 6 × 48×48 + silhueta | categorias do códex: inimigos, armas, itens, passivas, bênçãos, heróis; cartão "???" com silhueta |
| Q10 | `assets/icons/resultado/*.png` | 6 × 48×48 | tela de resultado: tempo, nível, abates, chefes, moedas, profundidade |

**Melhorias (Q04), ícones temáticos:** Força Bruta (punho de armadura), Vitalidade (coração), Mão Cheia (leque de cartas), Rerrolagem (dado girando), Sorte (trevo de quatro folhas dourado), Bolso Fundo (bolsa), Ganância (moedas), Ímã (ímã em U), Guarnição (peitoral), Pés Ligeiros (bota alada), Segunda Chance (ampulheta com asas), Teimosia do Infeliz (dado quebrado com 1), Ressonância Arcana (cristal vibrando), Corpo de Ferro (escudo de ferro), Mente Aguçada (olho com runa), Braço Forte (braço com bracelete), Presença (coroa/aura), Sangue Vivo (gota com chama).
Prompt-base de Q04/Q06/Q08: STYLE-ICON + lista acima, em folha (grade com espaço entre células).

## 4. Lote C — Lacunas de conteúdo (P2)

| ID | Destino | Alvo | O quê |
|---|---|---|---|
| C01 | `assets/ui/boss-intros/guardiao_verdadeiro.png` | 640×360 | Docas: porão ritual, caixão de pedra vazio, círculo ritual, Guardião Alado verdadeiro |
| C02 | `.../zuggtmoy.png` | 640×360 | Shedaklah: palácio de fungos, Zuggtmoy |
| C03 | `.../blogbog.png` | 640×360 | Molor: caverna de bolhas de limo, Blogbog |
| C04 | `.../molydeus_chefe.png` | 640×360 | Durao: jaula gigante, rio de almas, Molydeus |
| C05 | `.../discipulo_pestilento.png` | 640×360 | Feng-tu: templo de Tou Um degradado pela peste, Discípulo Pestilento e larvas |
| C06 | `.../malcanthet.png` | 640×360 | Rivenheart: luxo, ilusão e correntes, Malcanthet |
| C07 | `.../socothbenoth.png` | 640×360 | Goranthis: castelo-festa que é ilusão, Socothbenoth no trono |
| C08 | `.../sintese_abissal.png` | 640×360 | Castelo da Fome cercado de fogo azul, Morro Zapomoni, a Síntese |
| C09 | `assets/stages/reino_abissal_thumb.png` | 480×320 | raízes colossais sobre o vazio, legião ao longe |
| C10 | `assets/stages/domwieck_thumb.png` | 480×320 | jardim de Ailalore sob invasão, rosas brancas, cinzas e brasas, estrela caída no centro |
| C11 | `assets/decals/reino_abissal_{remendo,trilha}_01.png`, `domwieck_*` | 4 × 256×128 | decais de chão: raiz com brilho vermelho; paralelepípedo com musgo, pétalas e brasas |
| C12 | `assets/interactions/ruina_{reino_abissal,domwieck,pilares}.png` | 3 × 256×256 | ruínas de POI com câmara selada, no estilo dos `ruina_*` existentes |
| C13 | ícones de armas ausentes | 7 × 128×128 | Maça Demolidora, Raio da Ruína, Domínio Coletivo, Martelo da Luz (versão antiga e simples), Constelação de Silva, Memória Alterada, Tocha do Incendiário |
| C14 | `assets/icons/items/espelho_das_almas_desejantes.png` | 128×128 | espelho de mão de Malcanthet, moldura de chifres, reflexo em névoa |
| C15 | ícones de bênçãos ausentes | 13 × 128×128 | Mask Faca na Sombra, Mask Mestre das Fechaduras, Lliira Passo Leve, Shar Pacto da Perda, Shar Véu da Noite, Selûne Prata, Ghaunadaur Massa Faminta, Helion Resto da Tarn, Lu Yueh Praga, Zuggtmoy Esporos, Zuggtmoy Guarnição, Juiblex Gelatina, Juiblex Mente-Colmeia |
| C16 | `assets/vfx/habilidade_arlindo.png`, `habilidade_erik.png` | 1536×256 cada (6 quadros de 256×256) | Arlindo, Memória Alterada (ondas de memória e fantasmas translúcidos); Erik, Navios em Chamas (faixa de fogo com cascos de navio) |

Prompts: C01–C08 usam STYLE-SCENE, "boss on the right 60%, environment on the left". C09–C10 usam STYLE-SCENE em 3:2. C11: "top-down seamless ground patch, transparent-edge feathered, same material as attached docas_remendo_01". C12: STYLE-SCENE de objeto, "single ruin prop, isometric 3/4 view". C13–C15 em folhas de grade com STYLE-ICON. C16: tira horizontal de 6 quadros iguais com o efeito animando; se o ChatGPT não mantiver consistência, gere 1 quadro-chave e a Atena anima.

## 5. Lote N — Novos personagens e criaturas do Vault (P3)

Só entram se forem usados em evento, chefe ou NPC. Cada item tem CANON no Vault; anexe a referência e peça "same identity, game sprite style".

| ID | Uso sugerido | Ref CANON |
|---|---|---|
| N01 | Inimigo/NPC Reaper do Estige (o NPC `npc_reaper_barqueiro` existe; conferir com o canon e, se divergir, refazer) | `B-FALT-003-05/r01/reaper-front-candidate-v01.png` |
| N02 | Beholder (elite do ritual do Reino Abissal, 2º sacrifício) | `BBB-r01/beholder/beholder-front-candidate-v01.png` |
| N03 | Kein (chefe ou cena do ritual no Reino Abissal) | `CHAR-029/S05-S06-conselheiro/r01/kein-front-candidate-v01.png` |
| N04 | Astherion (câmara secreta de Dagruve; chefe opcional) | `B-OITO-FRONT-001/astherion-front-candidate-v01.png` |
| N05 | Kūkan Shito (observador em Feng-tu, cópia ilusória) | `KKLLL-r01/B-KKLLL-002/kukan-shito-front-candidate-v01.png` |
| N06 | Taverneiro metamorfo e Atendente (Vila das Sombras, S11) | `B-OITO-FRONT-001/taverneiro-metamorfo-front-candidate-v01.png`, `atendente-front-candidate-v01.png` |
| N07 | Wonka e Willie (Docas, NPCs de evento) | `CHAR-062/.../wonka-front-approved-v02-hq.png`, `CHAR-061/S01-S02/r01/willie-front-candidate-v01.png` |
| N08 | Marciela (Raiz/Shedaklah, guia) | `CHAR-038/S17-S18-manto-pantano/recovered-20261019-r01/marciela-front-recovered.png` |
| N09 | Thalion (elite/chefe do capítulo 2) | `CANON-SEIS-20261018-r1/tha-03-thalion_fullbody_candidate_v1.png` |
| N10 | Aila (NPC no Domwieck pós-libertação) | `CHAR-002/S14-desperta/r03-turnaround/aila-front-v01.png` |
| N11 | Mímico (já definido, sem uso; Espeto de Pau/baús) | usar o sprite atual; só conferir |

Prompt-base: STYLE-CHAR + "same identity as the attached canon reference; adapt to a game sprite, keep outfit, colors and silhouette; poses: idle, attack, death".

## 6. Prioridade e esforço

| Prioridade | Itens | Imagens estimadas | Efeito |
|---|---|---:|---|
| P0 Vault | V01–V11 | 45 (incl. poses) | tira divergências de canon; fecha a Síntese e o Nidhogg |
| P1 UI de escolha | U01–U11 | 11 | transforma level-up, altar, baú e loja |
| P1 HUD e modais | U12–U21 | 10 | coesão com a ficha |
| P1/P2 Quartel | Q01–Q10 | 28 | Melhorias, Marcas e Conquistas deixam de ser listas |
| P2 Conteúdo | C01–C16 | 36 | chefes com introdução, mapas novos completos |
| P3 Novos | N01–N11 | 30 | expande o elenco do Vault |

Ordem sugerida: **U01–U08 primeiro** (maior ganho visível por imagem), depois V01 e V07 (já em jogo como placeholder), depois Q02–Q06, C09–C10, C01–C08, V02–V06.

## 7. Critérios de aceite (a Atena confere antes de integrar)

- Sem texto, marca ou assinatura; fundo plano conforme a cláusula; borda limpa depois da remoção do fundo.
- Identidade igual à referência CANON (silhueta, cores, equipamento, olhos de aasimar numa cor só); onde o Vault for omisso, sem inventar lore.
- Escala e proporção coerentes com o par existente; legível a 150 px de altura (inimigos) e a 64 px (ícones).
- Molduras: bordas simétricas, interior realmente vazio, cantos íntegros para 9-slice.
- Aceite visual é seu: a Atena verifica formato e consistência, você julga estilo e fidelidade.
- Nenhuma imagem é promovida a CANON por estar aqui. Proveniência e aprovação ficam registradas por imagem.

## 8. Depois da entrega (trabalho da Atena)

1. Limpeza e recorte por script (fundo, 9-slice, folhas, quadros de animação).
2. Integração: novo cartão de oferta em `ui/offer_card.gd` e `ui/hud.gd`; abas do Quartel em `ui/menu.gd`; introduções em `data/boss_presentations.json`; miniaturas, decais e ruínas nos dados de fase.
3. Testes (`run_all`, `test_animation_assets`, auditoria) e capturas antes e depois para você comparar.
4. Plano de portagem para o projeto de origem.
