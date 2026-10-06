---
id: "ART-PROMPTS-057"
type: "prompts-de-arte"
title: "Ficha C: molduras, slots, abas e textura de fundo"
status: "ready-for-generation (geração só com aprovação do dono; cota de imagens)"
created: "2026-10-06"
relations: ["[[SPEC-130-ficha-c-em-abas-grade-e-detalhe]]", "[[EVID-167-ficha-c-em-abas-spec-130-2026-10-06]]", "[[ART-PROMPTS-043-ui-e-vfx-pendentes]]", "[[ART-PROMPTS-010-icones-passivas-bencaos-ui]]"]
sources: ["backlog ART-035, MEC-045", "ui/character_sheet.gd", "ui/sheet_slot.gd", "assets/ui/evolucao_painel_moldura.png"]
---

# Ficha C — molduras, slots, abas e textura (ART-035)

> Derivado. Não autoriza geração por si; o dono aprova o início do lote. Direção do dono (SPEC-130 D9): **gótico sombrio limpo**: fundo quase preto, moldura fina em ferro e ouro velho, ornamento só nas bordas e nos cantos, nunca atrás do texto. Referências de jogo: Castlevania (gótico), Blasphemous (ornamento, com moderação), Dead Cells e Megabonk (leitura limpa).

## Convenção (a mesma do ART-PROMPTS-043)

- Fundo **e centro** liso **magenta #FF00FF** (ciano #00FFFF se a peça usar magenta ou roxo); uma imagem por mensagem; remover o magenta na admissão. Sem texto legível, sem números, sem personagens.
- **Bordas duras contra o magenta**, sem sombra projetada, sem brilho que vaze para fora do contorno (o recorte precisa ficar limpo).
- Até **3 candidatas** por peça; cada nova tentativa corrige um defeito objetivo. Salvar em `.atena/generated/art-candidates/ficha-c/<id>_v01.png`; aprovada vai para `assets/ui/ficha/<id>.png`.
- Aprovar **em escala real no jogo** (1280×720), nunca só no PNG isolado.
- Marque `[x]` ao gerar e `[a]` ao aprovar.

## Referências a anexar (papel de cada uma)

| Arquivo | Papel |
|---|---|
| `assets/ui/evolucao_painel_moldura.png` | **Material, cor e família de ornamento** (metal escuro, ouro velho, brilho âmbar nas bordas internas). Não copiar a composição nem a espessura: a ficha precisa de **borda bem mais fina**. |
| `assets/icons/ui/ca.png` | Traço, contorno e densidade de pixel dos ícones (só para as peças A06 a A09). |
| `assets/icons/passives/inteligencia.png` | Idem: nível de detalhe e saturação aceitos em 128 px. |

## Bloco comum — molduras

```text
Use case: stylized-concept
Asset type: moldura de interface de jogo, vista frontal plana
Style/medium: pixel art sombria densa, pixels nítidos, contorno escuro, metal escuro e ouro velho com desgaste leve, mesma família da moldura de referência
Constraints: fundo e centro lisos magenta #FF00FF; bordas duras sem anti-aliasing contra o magenta; ornamento somente nos cantos e (quando pedido) no meio da borda superior; faixa lateral lisa e repetível; sem texto, números, runas legíveis, personagens, sombra projetada ou brilho fora do contorno
Avoid: ornamento no meio das laterais, relevo pesado que reduza a área útil, 3D, aparência de plástico, dourado saturado, vermelho vivo
```

---

## A01 — `ficha_moldura_painel`

Moldura externa de todo o painel. A imagem é **esticada por igual** para o painel de ~1090×613 (escala 0,85), então precisa estar em **16:9 exato**. Destino: `assets/ui/ficha/ficha_moldura_painel.png`, final **1280×720 RGBA**; gerar em 1536×864 (ou o 16:9 mais próximo) e reduzir.

- [ ] gerada · [ ] aprovada

```text
Use case: stylized-concept
Asset type: moldura externa de painel de ficha de personagem para jogo
Primary request: moldura retangular fina de ferro escuro e ouro velho; faixa lateral e inferior com cerca de 36 pixels de espessura na imagem de 1280×720, lisa, com pequenos rebites discretos e um filete âmbar apagado na borda interna; ornamentos góticos pontiagudos apenas nos quatro cantos (até 96 pixels), e um pequeno ornamento central no meio da borda superior (até 56 pixels de altura); centro vazio
Style/medium: pixel art sombria coerente com a moldura de evolução de referência, porém muito mais fina e discreta
Composition/framing: vista frontal plana, proporção exata 16 para 9, moldura ocupando a imagem toda; ocupar menos de 7% da largura em cada lado, salvo os cantos
Constraints: fundo fora da moldura e centro lisos magenta #FF00FF; bordas duras; sem texto, números ou personagens
```

Aceite: lateral e base **≤ 36 px** (no jogo ≤ 31 px); os ornamentos de canto não invadem a coluna do herói nem o botão de fechar; o ornamento do topo não cobre o título à esquerda nem as abas à direita.

---

## A02 — `ficha_moldura_detalhe`

Caixa do detalhe do item, também usada no cartão da habilidade e no quadro do retrato (9-slice). Destino: `assets/ui/ficha/ficha_moldura_detalhe.png`, final **512×128 RGBA**, margens de recorte **16 px** (código: `StyleBoxTexture`, margens 16, bordas esticadas).

- [ ] gerada · [ ] aprovada

```text
Use case: stylized-concept
Asset type: moldura de caixa de texto de interface, recortável em nove partes
Primary request: moldura retangular fina de ferro escuro com filete de ouro velho na borda interna, cantos com pequenos colchetes pontiagudos de 16 pixels, laterais e topo/base completamente lisos e uniformes para poderem ser esticados, centro vazio
Style/medium: pixel art sombria, mesma família da moldura de painel, muito discreta
Composition/framing: vista frontal plana, proporção 4 para 1, moldura ocupando a imagem toda
Constraints: fundo e centro lisos magenta #FF00FF; bordas duras; nenhum ornamento fora dos quatro cantos; sem texto
```

Aceite: ao esticar para 764×160 e para 270×110, cantos nítidos e bordas sem emenda nem deformação.

---

## A03 — `ficha_slot_moldura`

Moldura do slot com item. **Neutra e clara** (cinza-aço dessaturado, ≈ #C8C8CC) porque o jogo **tinge por código** com a cor da raridade (comum cinza, mágico azul, incomum verde, raro dourado, único laranja). Destino: `assets/ui/ficha/ficha_slot_moldura.png`, final **76×76 RGBA**, margens de recorte **10 px**.

- [ ] gerada · [ ] aprovada

```text
Use case: stylized-concept
Asset type: moldura de slot de inventário de jogo, 1 slot quadrado
Primary request: moldura quadrada fina de aço claro dessaturado com desgaste leve, cantos levemente chanfrados com pequenos rebites, filete interno mais escuro, bisel discreto; centro vazio onde o ícone do item aparece
Style/medium: pixel art sombria, tom NEUTRO claro (cinza-aço, sem cor própria) para ser tingida depois por multiplicação
Composition/framing: vista frontal plana, quadrada, moldura ocupando a imagem toda, espessura da borda em torno de 10% da largura
Constraints: fundo e centro lisos magenta #FF00FF; bordas duras; sem ouro, sem cor saturada, sem brilho, sem texto
```

Aceite: tingida de azul, verde, dourado e laranja continua legível; o ícone de 62 px dentro dela não encosta na borda.

---

## A04 — `ficha_slot_vazio`

Encaixe vazio da grade (armas 2/5, equipamento 3/4). Deve parecer um **nicho gravado**, discreto, bem menos chamativo que A03. Destino: `assets/ui/ficha/ficha_slot_vazio.png`, final **76×76 RGBA**.

- [ ] gerada · [ ] aprovada

```text
Use case: stylized-concept
Asset type: encaixe vazio de slot de inventário de jogo, 1 slot quadrado
Primary request: nicho quadrado afundado na pedra escura, bisel interno suave, bordas gastas, interior quase preto com leve textura de pedra, um pequeno losango gravado e apagado no centro
Style/medium: pixel art sombria, baixo contraste, tons de cinza-azulado escuro
Composition/framing: vista frontal plana, quadrada, ocupando a imagem toda
Constraints: fundo fora do nicho liso magenta #FF00FF (cantos recortados levemente); bordas duras; sem texto, sem cor viva, sem brilho
```

Aceite: ao lado de A03 o vazio recua visualmente; o losango não lê como ícone de item.

---

## A05 — `ficha_aba_moldura`

Botão das abas, neutro e claro (tingido por código: ouro quando ativa, aço quando inativa). Destino: `assets/ui/ficha/ficha_aba_moldura.png`, final **192×40 RGBA**, margens de recorte **12 px**.

- [ ] gerada · [ ] aprovada

```text
Use case: stylized-concept
Asset type: moldura de botão de aba de interface, recortável em nove partes
Primary request: faixa retangular fina e baixa de aço claro dessaturado com cantos chanfrados, filete interno escuro, pequeno rebite em cada extremidade, interior vazio
Style/medium: pixel art sombria, tom NEUTRO claro (cinza-aço, sem cor própria) para tingimento por código
Composition/framing: vista frontal plana, proporção 5 para 1, ocupando a imagem toda
Constraints: fundo e centro lisos magenta #FF00FF; bordas duras; topo, base e laterais uniformes e esticáveis; sem texto
```

Aceite: legível com o rótulo da aba (16 px) dentro; estica de 150 a 200 px sem deformar.

---

## Ícones das abas (A06 a A09)

Matriz 1024×1024, final **96×96 RGBA** (exibidos a 28–32 px ao lado do nome da aba). Destino: `assets/ui/ficha/ficha_aba_<nome>.png`. **Reconhecíveis a 28 px e em escala de cinza**; mesma paleta dos ícones atuais (aço, ouro velho, acento âmbar).

```text
Use case: stylized-concept
Asset type: ícone de aba de interface para jogo
Style/medium: pixel art sombria de alto contraste, contorno escuro grosso, poucos blocos de cor, silhueta clara a 28 pixels
Composition/framing: um símbolo central simples, 18% de margem, sem elementos soltos
Constraints: fundo liso magenta #FF00FF; sem texto, letras, números, moldura, círculo de fundo, logotipo ou aparência 3D
```

### A06 — `ficha_aba_armas`

- [ ] gerada · [ ] aprovada

```text
Primary request: espada e cajado cruzados em X, a espada de lâmina de aço claro e o cajado de madeira escura terminado em pequeno cristal violeta, guarda e empunhadura simples
```

### A07 — `ficha_aba_equipamento`

- [ ] gerada · [ ] aprovada

```text
Primary request: peitoral de aço escuro com ombreiras, e à frente dele um pequeno anel dourado ao lado de um amuleto de pedra em corrente curta
```

### A08 — `ficha_aba_passivas`

- [ ] gerada · [ ] aprovada

```text
Primary request: estrela de quatro pontas dourada em primeiro plano diante de um pequeno sol âmbar de raios curtos, os dois unidos como um só emblema
```

### A09 — `ficha_aba_sinergias`

- [ ] gerada · [ ] aprovada

```text
Primary request: símbolo do infinito feito de duas voltas de metal dourado entrelaçadas, com um pequeno cristal azul-ciano no cruzamento e três marcas curtas de soma ao redor
```

---

## A10 — `ficha_fundo_textura`

Textura **repetível** do fundo do painel (atrás de tudo, sob a moldura). Tem de ser quase lisa para o texto ficar legível. Destino: `assets/ui/ficha/ficha_fundo_textura.png`, final **256×256 RGB**, tileável nos quatro lados.

- [ ] gerada · [ ] aprovada

```text
Use case: stylized-concept
Asset type: textura de fundo repetível para painel de interface de jogo
Primary request: pedra escura quase preta, levemente azulada, com grão fino e raríssimas rachaduras muito sutis; variação de luminosidade de no máximo 8% entre o ponto mais claro e o mais escuro
Style/medium: pixel art sombria, textura contínua sem ponto focal
Composition/framing: quadrada, vista frontal plana, tileável horizontal e verticalmente sem emendas visíveis
Constraints: sem texto, sem símbolos, sem ornamento, sem vinheta, sem gradiente, sem cor viva
```

Aceite: repetida em 4×3 sobre o painel, não aparece grade nem padrão repetido; texto branco e dourado de 14 px lê sem esforço sobre ela.

---

## Integração (fora deste documento)

Trocar o desenho por código pelas imagens (`StyleBoxTexture` e `TextureRect` em `ui/character_sheet.gd`/`ui/sheet_slot.gd`, tingimento por raridade com `modulate`, ícones nas abas) é uma etapa **à parte** e precisa de spec e aprovação. Enquanto não houver arte aprovada, a ficha continua com as molduras desenhadas por código (SPEC-130, EVID-167); cada peça aprovada pode entrar sozinha, sem quebrar as outras.

Ao integrar, ajustar `PANEL_SIZE` para **1088×612** (16:9 exato) e a margem interna de 18 para **40 px**, para o conteúdo não encostar na moldura.

## Ordem sugerida

1. **A01** (moldura do painel) — define o tom de todas as outras.
2. **A03** e **A04** (slot cheio e vazio) — pior caso de legibilidade, ver lado a lado.
3. **A02** e **A05** (detalhe e aba).
4. **A06 a A09** (ícones das abas).
5. **A10** (textura), por último.

Total: **10 gerações** (mais até 2 candidatas extras por peça, se necessário).
