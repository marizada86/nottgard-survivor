---
id: "ART-PROMPTS-043"
type: "prompts-de-arte"
title: "UI e VFX pendentes: barra de progresso, catálogo, lança-chamas, subida de nível e evolução"
status: "ready-for-generation"
created: "2026-10-01"
relations: ["[[SPEC-091-mini-cinematica-de-evolucao]]", "[[ART-PROMPTS-041-props-tematicos-piloto-dagruve-docas]]", "[[ART-PROMPTS-042-isca-do-sylas-e-eventos-ampulheta-doacao-aposta]]"]
sources: ["backlog ART-002, ART-003, ART-004, ART-010, ART-014", "MEC-002, MEC-003, MEC-004, MEC-008, MEC-009", "assets/icons/items/*"]
---

# UI e VFX pendentes (ART-002, 003, 004, 010, 014)

Convenção do projeto: fundo liso **magenta #FF00FF** (ciano #00FFFF quando o objeto usa magenta ou roxo), imagem quadrada ou na proporção pedida,
um item por mensagem, remover o fundo depois. Sem texto legível. Paleta do HUD: pedra e metal escuros, acentos âmbar e dourado.
Os VFX saem em grades; recortar os quadros na admissão. Efeitos de partícula do jogo continuam em código; estes são só os desenhos-base.

## ART-002 — Barra de progresso da fase (MEC-002)

### `hud_progresso_moldura`
Barra horizontal; o preenchimento é desenhado pelo jogo, então a imagem traz só a moldura vazia.

```text
Use case: stylized-concept
Asset type: moldura de barra de progresso horizontal para HUD de jogo
Primary request: barra comprida e estreita de metal escuro e pedra, cantos reforçados, canal interno vazio e escuro onde o preenchimento aparece, um pequeno encaixe em forma de caveira de chefe na ponta direita, detalhes de rebites e runas apagadas
Style/medium: pixel art sombria coerente com o jogo, metal cinza-escuro com filetes âmbar discretos
Composition/framing: vista frontal plana, proporção 8 para 1, barra centrada ocupando quase toda a largura
Constraints: fundo liso magenta #FF00FF, canal interno preto sólido, sem texto, sem números, sem personagens
```

### `hud_progresso_marcador`

```text
Use case: stylized-concept
Asset type: ícone de marcador de progresso para HUD de jogo
Primary request: dois ícones lado a lado do mesmo tamanho: à esquerda um pequeno losango âmbar brilhante (posição atual do jogador), à direita uma caveira de chefe estilizada em vermelho-escuro com olhos âmbar (chegada do chefe)
Style/medium: pixel art sombria coerente com o jogo
Composition/framing: vista frontal plana, cada ícone centrado em metade da imagem, proporção 2 para 1
Constraints: fundo liso magenta #FF00FF, sem texto, sem personagens
```

## ART-003 — Catálogo de itens do menu Esc (MEC-003)

### `catalogo_item_bloqueado`
Silhueta escura para itens ainda não desbloqueados; o jogo coloca o ícone real por cima dos desbloqueados.

```text
Use case: stylized-concept
Asset type: casela de catálogo de item bloqueado para menu de jogo
Primary request: casela quadrada de metal e pedra escuros com moldura gasta, interior quase preto com a silhueta preta de um item genérico e um pequeno cadeado de ferro no canto inferior, brilho âmbar quase apagado nas bordas
Style/medium: pixel art sombria coerente com o jogo
Composition/framing: vista frontal plana, casela centrada, quadrada
Constraints: fundo liso magenta #FF00FF, sem texto, sem letras, sem personagens
```

### `catalogo_item_moldura`

```text
Use case: stylized-concept
Asset type: casela de catálogo de item desbloqueado para menu de jogo
Primary request: casela quadrada vazia de metal escuro com moldura dourada fina e cantos reforçados, interior de pedra lisa escura onde o ícone do item será colocado, leve brilho âmbar na borda interna
Style/medium: pixel art sombria coerente com o jogo
Composition/framing: vista frontal plana, casela centrada, quadrada, mesmo tamanho e enquadramento da casela bloqueada
Constraints: fundo liso magenta #FF00FF, interior liso e vazio, sem texto, sem letras, sem personagens
```

## ART-004 — Item de dano temporário, lança-chamas (MEC-004)
Divindade de fogo ainda a definir; por isso o fogo é genérico, laranja e âmbar, sem símbolo de deidade.

### `item_lanca_chamas_icone`
Destino: `assets/icons/items/`. Âncora de estilo: `assets/icons/items/adaga.png`.

```text
Use case: stylized-concept
Asset type: ícone de item de jogo
Primary request: lança-chamas rústico de cultista, tubo de metal escuro com reservatório de óleo, bico aceso com uma chama laranja e âmbar saindo, correias de couro
Style/medium: pixel art sombria coerente com o jogo, metal escuro e chama viva
Composition/framing: objeto inteiro na diagonal, centrado, quadrado
Constraints: fundo liso magenta #FF00FF, sem texto, sem mãos ou personagens
```

### `vfx_jato_de_chamas`
Grade 2×2, quatro quadros do jato em loop; o jogo gira o efeito para a direção do ataque (jato apontando para a direita).

```text
Use case: stylized-concept
Asset type: sprite sheet de efeito de jato de chamas, 4 quadros em loop
Primary request: grade 2 por 2 com quatro quadros do mesmo jato de fogo apontado para a direita, saindo da borda esquerda da célula: quadro 1 chama fina e brilhante, quadro 2 língua longa com faíscas, quadro 3 jato largo com redemoinho laranja e âmbar, quadro 4 jato com pontas se desfazendo em brasas
Style/medium: pixel art sombria coerente com o jogo, núcleo amarelo claro, miolo laranja, bordas vermelho-escuro
Composition/framing: cada quadro com a base do jato colada na borda esquerda e centrada na altura, mesmo comprimento máximo em todos
Constraints: fundo liso magenta #FF00FF, sem texto, sem personagens, sem bordas entre os quadros, quadrado
```

## ART-010 — Impacto ao subir de nível (MEC-008)

### `vfx_subida_de_nivel`
Grade 2×2, quatro quadros em torno do herói; referência de sensação: clímax de Symphony of the Night, com anel de luz e raios.

```text
Use case: stylized-concept
Asset type: sprite sheet de efeito de subida de nível, 4 quadros
Primary request: grade 2 por 2 com quatro quadros do mesmo efeito visto de cima: quadro 1 faísca dourada no centro, quadro 2 anel de luz dourada se abrindo com raios, quadro 3 pilar de luz subindo com partículas brilhantes e anel grande, quadro 4 anel dissipando em partículas douradas e brancas
Style/medium: pixel art sombria coerente com o jogo, dourado, branco quente e âmbar sobre fundo liso
Composition/framing: cada quadro centrado na célula, anel máximo ocupando a maior parte da célula, mesmo tamanho em todos
Constraints: fundo liso ciano #00FFFF, sem texto, sem personagens, sem bordas entre os quadros, quadrado
```

## ART-014 — Evolução de arma (MEC-009)

### `vfx_evolucao_flare`
Grade 2×2 para o fundo do painel da cinemática: arma central em branco, o resto do efeito ao redor.

```text
Use case: stylized-concept
Asset type: sprite sheet de efeito de evolução de arma, 4 quadros
Primary request: grade 2 por 2 com quatro quadros do mesmo efeito: quadro 1 pequena esfera de luz branca com anel fino, quadro 2 raios longos saindo do centro e fragmentos de metal girando, quadro 3 explosão de luz branca e dourada com anel duplo e estilhaços, quadro 4 luz assentando em brilho dourado suave com fagulhas descendo
Style/medium: pixel art sombria coerente com o jogo, branco quente, dourado e âmbar, pequenos toques de roxo
Composition/framing: cada quadro centrado na célula, círculo máximo ocupando a maior parte da célula, sem arma desenhada no centro
Constraints: fundo liso ciano #00FFFF, sem texto, sem personagens, sem bordas entre os quadros, quadrado
```

### `evolucao_painel_moldura`

```text
Use case: stylized-concept
Asset type: moldura de painel de cinemática para HUD de jogo
Primary request: grande moldura retangular de metal escuro e ouro velho com cantos ornamentados, filetes de runas, centro vazio e escuro, brilho âmbar sutil nas bordas internas
Style/medium: pixel art sombria coerente com o jogo
Composition/framing: vista frontal plana, proporção 16 para 9, moldura ocupando a imagem toda
Constraints: fundo liso magenta #FF00FF fora da moldura, centro preto sólido, sem texto, sem personagens
```

## Aceite
- Mesmas paletas e traço dos ícones e props atuais; leitura clara a 32–128 px.
- Moldura e casela com interior liso para o jogo desenhar por cima.
- Efeitos legíveis sobre pedra escura e sobre o fundo de Dagruve e Docas; sem letras.
