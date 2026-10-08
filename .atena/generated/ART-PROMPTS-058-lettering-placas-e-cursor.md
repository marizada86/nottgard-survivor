---
id: "ART-PROMPTS-058"
type: "prompts-de-arte"
title: "Lettering do jogo, placas de título e cursor do mouse"
status: "ready-for-generation (geração só com aprovação do dono; L01 vai primeiro e define o tom)"
created: "2026-10-06"
relations: ["[[SPEC-132-lettering-e-cursor-do-jogo]]", "[[PLAN-065-lettering-e-cursor-2026-10-06]]", "[[ART-PROMPTS-057-ficha-c-molduras-e-icones]]", "[[RESEARCH-003-paleta-das-deidades-2026-09-27]]"]
sources: ["backlog ART-039, ART-040, MEC-058", "ui/title.gd", "ui/hud.gd", "ui/run.gd", "ui/menu.tscn", "assets/ui/title/title_background.png", "assets/ui/evolucao_painel_moldura.png"]
---

# Lettering, placas e cursor (ART-039, ART-040)

> Derivado. Não autoriza geração por si; o dono aprova o início do lote. Fila operacional: [[CHATGPT-FILA-026-lettering-placas-e-cursor]].

## Inventário que fechou a lista (S-001, lido no código em 2026-10-06)

| Texto no jogo | Onde | Fixo? | Decisão |
|---|---|---|---|
| `NOTTGARD SURVIVORS` | título (`ui/title.gd`, hoje `Label` 72 pt) e cabeçalho do quartel (`ui/menu.tscn`, `Title` 44 pt) | sim | **L01 logo** (a mesma imagem, menor, no quartel) |
| `Clique para jogar` | título, com pulso de alfa | sim | **L02** (opcional; mantém o pulso por `modulate`) |
| `Vitória!` | `%ResultTitle` em `ui/hud.gd` | sim | **L03** |
| `Você caiu...` | `%ResultTitle` (`ui/hud.gd`, `ui/hud.tscn`) | sim | **L04** |
| `★  EVOLUÇÃO  ★` | cinemática de evolução (`ui/hud.gd`) | sim | **L05** (a imagem substitui o `★`) |
| `CHEFE` | `timer_label` no lugar do relógio | sim, mas é só um rótulo de HUD | fica em fonte (sem lettering) |
| Nome e subtítulo do chefe | apresentação do chefe (`ui/run.gd`) | **não** (por chefe) | **P03** placa + fonte |
| Título da HQ (14 em `data/hqs.json`) e `Quadro N de M` | `ui/hq_screen.gd` | **não** | **P01** placa + fonte |
| `Nível N — escolha`, títulos de loja, altar e pactos | `lv_title` em `ui/hud.gd` | **não** (número e nomes) | **P01** placa + fonte |
| Cabeçalhos do quartel e das opções (`ÁUDIO`, `VÍDEO`, `JOGABILIDADE`, `AÇÕES`, `Herói`, `Fase`) e abas da ficha C | `ui/menu.tscn`, `ui/character_sheet.gd` | sim, mas curtos e repetidos | **P02** placa + fonte |
| `Pausa`, `Reviver`, botões | `ui/hud.tscn` | sim | fora do escopo (botão segue o tema) |

**Resultado:** não há banner de momento além de `EVOLUÇÃO`; os demais textos de momento são dinâmicos e usam placa + fonte. A lista final tem **11 peças**: L01 a L05, P01 a P03 e C01 a C03.

## Convenção (a de ART-PROMPTS-057, com uma exceção)

- Fundo **e vazios internos** lisos **magenta #FF00FF** (use **ciano #00FFFF** se a peça levar roxo ou rosa, que é o caso do logo; avisar na mensagem). Uma imagem por mensagem. O magenta/ciano é removido na admissão.
- **Exceção às peças de moldura:** o **texto é obrigatório** nas peças L e deve ser **exatamente** o pedido, com acentos. Peças P e C **não** têm texto.
- Bordas duras contra a chave, sem sombra projetada, sem brilho que vaze do contorno (recorte limpo).
- Até **3 candidatas** por peça; cada nova tentativa corrige um defeito objetivo. Salvar em `.atena/generated/art-candidates/lettering/<id>_v01.png` (cursores em `.../cursor/`). Nada entra em `assets/` sem passar na prévia em escala real.
- **Conferência de grafia (peças L):** ler letra a letra, incluindo `ç`, `ã`, `ê`, `í`, `é` e as reticências de `Você caiu...`. **Duas candidatas com erro = a peça cai para placa + fonte** (decisão G-2 da SPEC-132).
- Marque `[x]` ao gerar e `[a]` ao aprovar.

## Direção visual (quadro de estilo, S-002)

- **Família:** a mesma do jogo: pixel art sombria densa, metal escuro e **ouro velho** (`~#D9B866`), contorno quase preto, brilho **roxo abissal** (`~#6B2A91` a `#B56BFF`, ver RESEARCH-003) só como acento discreto.
- **Letras:** capitais góticas serifadas de talhe largo, na linha da fonte Cinzel Decorative já usada (`assets/fonts/CinzelDecorative-Bold.ttf`), com bisel de metal forjado. **Legíveis antes de decorativas**: a letra manda, o ornamento fica nas pontas.
- **Sem lore inventada:** ornamento abstrato (arcos, espinhos, fendas de luz, rebites). Nada de brasão, runa legível ou símbolo de divindade.
- **Referências a anexar** (dizer o papel de cada uma): `assets/ui/title/title_background.png` (clima e paleta do título); `assets/ui/evolucao_painel_moldura.png` (material, cor e família de ornamento; **não** copiar a composição); `assets/ui/backgrounds/victory_background.png` e `defeat_background.png` (as peças L03 e L04 ficam por cima delas).

## Bloco comum — lettering (L01 a L05)

```text
Use case: stylized-concept
Asset type: lettering de interface de jogo, vista frontal plana, centralizado com margem generosa
Style/medium: pixel art sombria densa, pixels nítidos, letras capitais góticas serifadas de talhe largo em ouro velho forjado com bisel e leve desgaste, contorno quase preto de 2 a 3 pixels, ornamento apenas nas pontas, brilho roxo abissal discreto só dentro do contorno
Constraints: fundo e vazios internos lisos na cor de chave pedida; bordas duras sem anti-aliasing contra a chave; texto EXATAMENTE como pedido, com acentos corretos e sem letras extras; sem sombra projetada, sem brilho fora do contorno, sem personagens
Avoid: letras ilegíveis ou fundidas, fonte cursiva, 3D plástico, dourado saturado, vermelho vivo, runas, brasões, texto adicional além do pedido
```

---

## L01 — `logo` (envia primeiro; define o tom das outras)

Destino: `assets/ui/title/logo.png`. **Final até 1100×176 RGBA** (o título reserva a faixa 1280×176). Pedir 3:2 (1536×1024) e cortar rente ao conteúdo. No quartel a mesma imagem aparece reduzida (~300×48), então **a leitura precisa sobreviver a um terço do tamanho**.

- [ ] gerada · [ ] aprovada · chave **ciano #00FFFF**

```text
Use case: stylized-concept
Asset type: logotipo do jogo "Nottgard Survivors" para tela de título
Primary request: lockup em duas linhas centralizado: linha de cima "NOTTGARD" em capitais grandes, linha de baixo "SURVIVORS" em capitais menores (cerca de 45% da altura), com espaço entre letras generoso; ouro velho forjado com bisel, contorno quase preto, rachadura fina de luz roxa abissal passando por trás das letras (dentro do contorno), pequenos espinhos e arcos góticos só nas duas pontas laterais, em simetria; proporção do conjunto cerca de 6:1 a 4:1
Style/medium: pixel art sombria densa, mesma família da moldura de evolução de referência e do clima do fundo do título
Constraints: fundo e vazios lisos ciano #00FFFF; bordas duras; texto EXATAMENTE "NOTTGARD" e "SURVIVORS", sem outras letras, números ou símbolos; sem sombra projetada nem brilho fora do contorno
Avoid: letras fundidas, ornamento cobrindo as letras, cursivo, 3D plástico, roxo saturado em excesso, runas, brasões
```

Aceite: lido a um terço do tamanho em 300×48 sem perder letra; o ornamento lateral não invade o texto; o ouro lê sobre o fundo roxo escuro do título.

## L02 — `prompt_clique` (opcional)

Destino: `assets/ui/title/prompt_clique.png`, **final até 480×64**. Texto "Clique para jogar" em caixa baixa com inicial maiúscula, mesmo material do logo, **mais discreto** (sem ornamento lateral, sem rachadura roxa forte). Se o dono achar que o texto em fonte já basta, a peça é dispensada.

- [ ] gerada · [ ] aprovada · chave **ciano #00FFFF**

```text
(Bloco comum de lettering.) Primary request: a frase "Clique para jogar" em uma linha, letras gótico-serifadas em ouro velho forjado, discretas, sem ornamento nas pontas; legíveis a 30 pixels de altura. Texto EXATAMENTE "Clique para jogar".
```

## L03 — `banner_vitoria`

Destino: `assets/ui/lettering/banner_vitoria.png`, **final até 720×160**. Fica sobre `victory_background.png` (anexar).

- [ ] gerada · [ ] aprovada · chave **magenta #FF00FF**

```text
(Bloco comum de lettering.) Primary request: a palavra "Vitória!" em uma linha, com acento agudo no "ó" e ponto de exclamação, ouro velho forjado com leve brilho âmbar quente (vitória), ornamento de espinhos e arcos nas duas pontas, mais luminoso que o logo mas na mesma família. Texto EXATAMENTE "Vitória!".
```

## L04 — `banner_derrota`

Destino: `assets/ui/lettering/banner_derrota.png`, **final até 720×160**. Fica sobre `defeat_background.png` (anexar).

- [ ] gerada · [ ] aprovada · chave **magenta #FF00FF**

```text
(Bloco comum de lettering.) Primary request: a frase "Você caiu..." em uma linha, com acento circunflexo no "ê", três pontos finais, em metal escuro e ouro velho apagado e rachado, brilho roxo frio quase extinto, ornamento mínimo e quebrado nas pontas, clima de queda. Texto EXATAMENTE "Você caiu...".
```

## L05 — `banner_evolucao`

Destino: `assets/ui/lettering/banner_evolucao.png`, **final até 640×110**. Substitui `★  EVOLUÇÃO  ★` na cinemática (fica sobre `evolucao_painel_moldura.png`, anexar).

- [ ] gerada · [ ] aprovada · chave **magenta #FF00FF**

```text
(Bloco comum de lettering.) Primary request: a palavra "EVOLUÇÃO" em maiúsculas, com cedilha no "Ç" e til no "Ã", ouro velho brilhante com fagulhas âmbar subindo pelo contorno, estrelinhas de quatro pontas nas duas pontas laterais. Texto EXATAMENTE "EVOLUÇÃO".
```

---

## Bloco comum — placas de título (P01 a P03)

Placas **sem texto**. O código escreve o texto em fonte sobre elas. São **de nove fatias**: ornamento só nas pontas; a faixa do meio é **uniforme na horizontal** (pode ser esticada) e escura o bastante para texto claro.

```text
Use case: stylized-concept
Asset type: placa de título de interface de jogo para nove fatias, vista frontal plana, sem texto
Style/medium: pixel art sombria densa, ferro escuro com filete de ouro velho e rebites discretos, ornamento gótico nas duas pontas, miolo liso quase preto
Constraints: fundo liso magenta #FF00FF; bordas duras sem anti-aliasing; sem texto, números, runas ou personagens; faixa do meio perfeitamente uniforme na horizontal e sem ornamento; simétrica; sem sombra projetada nem brilho fora do contorno
Avoid: ornamento no miolo, relevo pesado, 3D plástico, dourado saturado
```

## P01 — `placa_titulo_larga`

Cabeçalho de telas, cartela de HQ e título de oferta. **Final 640×96**, margens de fatia **56 / 56 / 28 / 28** (esq / dir / topo / base). Destino: `assets/ui/lettering/placa_titulo_larga.png`.

- [ ] gerada · [ ] aprovada

```text
(Bloco comum de placas.) Primary request: placa larga e baixa, proporção cerca de 6,7:1, pontas com arcos e espinhos de até 56 pixels em 640 de largura, miolo de 40 pixels de altura liso.
```

## P02 — `placa_titulo_secao`

Cabeçalhos de seção e abas. **Final 320×48**, margens **32 / 32 / 16 / 16**. Destino: `assets/ui/lettering/placa_titulo_secao.png`. Mais simples que a P01 (só filete e cantos).

- [ ] gerada · [ ] aprovada

```text
(Bloco comum de placas.) Primary request: placa estreita e baixa, proporção cerca de 6,7:1, pontas simples com um pequeno espinho de até 32 pixels em 320 de largura, miolo liso; ainda mais discreta que uma placa de título.
```

## P03 — `placa_chefe`

Nome e subtítulo do chefe na apresentação (hoje o texto fica solto sobre a arte). **Final 720×112**, margens **80 / 80 / 36 / 36**. Destino: `assets/ui/lettering/placa_chefe.png`. Pode ser um pouco mais ameaçadora que a P01 (espinhos maiores nas pontas), **sem cor de bioma** (o código tinge pelo bioma do chefe).

- [ ] gerada · [ ] aprovada

```text
(Bloco comum de placas.) Primary request: placa larga, proporção cerca de 6,4:1, pontas com espinhos e chifres de ferro de até 80 pixels em 720 de largura, miolo de 56 pixels liso e mais escuro; ferro quase sem cor, para ser tingido pelo código.
```

---

## Cursor (ART-040)

Convenção própria: gerar **em 4×** (128 px para ponteiro e mão, 160 px para a mira), 1:1, **chave magenta #FF00FF**, **sem texto**. O script reduz a 32/32/40 px com filtro de vizinho mais próximo ou área e valida o hotspot. O cursor aparece sobre fundos **escuros e claros**: precisa de **contorno quase preto de 1 px (final)** por fora e **filete de ouro velho** por dentro, para ler nos dois casos. Se a leitura a 32 px falhar, o plano desenha o cursor por script (decisão G-3).

```text
Use case: stylized-concept
Asset type: cursor de mouse de jogo, pixel art, vista frontal plana, centralizado, 1:1
Style/medium: pixel art sombria densa, silhueta simples e legível em 32 pixels, ferro escuro com filete de ouro velho, contorno quase preto por fora, uma única faísca roxa discreta
Constraints: fundo liso magenta #FF00FF; bordas duras; sem texto, números ou sombra projetada; sem brilho fora do contorno
Avoid: detalhe fino que some em 32 pixels, 3D plástico, dourado saturado, vermelho vivo
```

### C01 — `cursor_ponteiro`

Final **32×32**, hotspot na **ponta** (em 4×: ponta no canto superior esquerdo, a 4 px da borda). Destino: `assets/ui/cursor/cursor_ponteiro.png`.

- [ ] gerada · [ ] aprovada

```text
(Bloco comum de cursor.) Primary request: ponteiro em forma de seta inclinada, ponta afiada no canto superior esquerdo, corpo de ferro com filete de ouro, cauda curta; ocupa 100% da imagem 128×128.
```

### C02 — `cursor_mao`

Final **32×32**, hotspot na **ponta do dedo indicador**. Destino: `assets/ui/cursor/cursor_mao.png`. Mesma família da C01, para o jogador ler "clicável".

- [ ] gerada · [ ] aprovada

```text
(Bloco comum de cursor.) Primary request: manopla gótica de ferro com o dedo indicador estendido apontando para cima e levemente para a esquerda, outros dedos fechados, filete de ouro nos nós dos dedos; ocupa 100% da imagem 128×128; o dedo indicador é a parte mais alta e mais à esquerda.
```

### C03 — `cursor_mira`

Final **40×40**, hotspot no **centro exato** (20,20). Destino: `assets/ui/cursor/cursor_mira.png`. **O centro fica vazio** (ponto de acerto visível) e a mira é **simétrica**, porque o combate lê esse ponto.

- [ ] gerada · [ ] aprovada

```text
(Bloco comum de cursor, imagem 160×160.) Primary request: mira circular fina: anel de ferro com filete de ouro, quatro marcas em cruz (cima, baixo, esquerda, direita) saindo do anel para dentro e para fora, centro completamente vazio; perfeitamente simétrica; sem ponto central.
```

Aceite dos cursores: lidos a 32/40 px reais, sobre captura clara **e** escura, compostos no hotspot; a mira não esconde o inimigo sob o centro; o ponteiro e a mão são reconhecíveis como par.

---

## Normalização na admissão (S-011, resumo)

1. Remover a chave (magenta ou ciano) com tolerância e **erosão de 1 px** para tirar halo; auditar com `tools/audit_candidate_alpha.gd`.
2. Cortar rente ao conteúdo, respeitar o tamanho final e **não ampliar**.
3. Placas: validar margens de nove fatias (miolo uniforme na horizontal).
4. Cursores: reduzir de 4× para 32/32/40, gravar hotspots em `data/cursor.json`.
5. Prévia obrigatória sobre capturas do jogo; aprovação do dono por peça; só então `assets/`.
