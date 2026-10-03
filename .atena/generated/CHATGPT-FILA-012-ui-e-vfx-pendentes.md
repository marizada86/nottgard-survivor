---
id: "CHATGPT-FILA-012"
type: "fila-de-prompts"
title: "Fila — UI e VFX pendentes (ART-002, 003, 004, 010, 014)"
status: "U07–U09 gerados e integrados em 2026-10-02; U01–U06 pendentes; EVID-145"
created: "2026-10-01"
relations: ["[[ART-PROMPTS-043-ui-e-vfx-pendentes]]"]
---

# Fila — UI e VFX pendentes

Compilação **literal** de ART-PROMPTS-043; em dúvida, a origem prevalece. Um item por mensagem. Fundo sólido (magenta ou ciano conforme o prompt), a remover depois.
Marque `[x]` ao gerar e `[a]` ao aprovar. Sem imagem de referência obrigatória; o ícone do lança-chamas pode levar `assets/icons/items/adaga.png` como âncora de estilo.

#### U01 - `hud_progresso_moldura` (ART-002)

- [ ] gerada · [ ] aprovada

```text
Use case: stylized-concept
Asset type: moldura de barra de progresso horizontal para HUD de jogo
Primary request: barra comprida e estreita de metal escuro e pedra, cantos reforçados, canal interno vazio e escuro onde o preenchimento aparece, um pequeno encaixe em forma de caveira de chefe na ponta direita, detalhes de rebites e runas apagadas
Style/medium: pixel art sombria coerente com o jogo, metal cinza-escuro com filetes âmbar discretos
Composition/framing: vista frontal plana, proporção 8 para 1, barra centrada ocupando quase toda a largura
Constraints: fundo liso magenta #FF00FF, canal interno preto sólido, sem texto, sem números, sem personagens
```n
#### U02 - `hud_progresso_marcador` (ART-002)

- [ ] gerada · [ ] aprovada

```text
Use case: stylized-concept
Asset type: ícone de marcador de progresso para HUD de jogo
Primary request: dois ícones lado a lado do mesmo tamanho: à esquerda um pequeno losango âmbar brilhante (posição atual do jogador), à direita uma caveira de chefe estilizada em vermelho-escuro com olhos âmbar (chegada do chefe)
Style/medium: pixel art sombria coerente com o jogo
Composition/framing: vista frontal plana, cada ícone centrado em metade da imagem, proporção 2 para 1
Constraints: fundo liso magenta #FF00FF, sem texto, sem personagens
```n
#### U03 - `catalogo_item_bloqueado` (ART-003)

- [ ] gerada · [ ] aprovada

```text
Use case: stylized-concept
Asset type: casela de catálogo de item bloqueado para menu de jogo
Primary request: casela quadrada de metal e pedra escuros com moldura gasta, interior quase preto com a silhueta preta de um item genérico e um pequeno cadeado de ferro no canto inferior, brilho âmbar quase apagado nas bordas
Style/medium: pixel art sombria coerente com o jogo
Composition/framing: vista frontal plana, casela centrada, quadrada
Constraints: fundo liso magenta #FF00FF, sem texto, sem letras, sem personagens
```n
#### U04 - `catalogo_item_moldura` (ART-003)

- [ ] gerada · [ ] aprovada

```text
Use case: stylized-concept
Asset type: casela de catálogo de item desbloqueado para menu de jogo
Primary request: casela quadrada vazia de metal escuro com moldura dourada fina e cantos reforçados, interior de pedra lisa escura onde o ícone do item será colocado, leve brilho âmbar na borda interna
Style/medium: pixel art sombria coerente com o jogo
Composition/framing: vista frontal plana, casela centrada, quadrada, mesmo tamanho e enquadramento da casela bloqueada
Constraints: fundo liso magenta #FF00FF, interior liso e vazio, sem texto, sem letras, sem personagens
```n
#### U05 - `item_lanca_chamas_icone` (ART-004)

- [ ] gerada · [ ] aprovada

```text
Use case: stylized-concept
Asset type: ícone de item de jogo
Primary request: lança-chamas rústico de cultista, tubo de metal escuro com reservatório de óleo, bico aceso com uma chama laranja e âmbar saindo, correias de couro
Style/medium: pixel art sombria coerente com o jogo, metal escuro e chama viva
Composition/framing: objeto inteiro na diagonal, centrado, quadrado
Constraints: fundo liso magenta #FF00FF, sem texto, sem mãos ou personagens
```n
#### U06 - `vfx_jato_de_chamas` (ART-004)

- [ ] gerada · [ ] aprovada

```text
Use case: stylized-concept
Asset type: sprite sheet de efeito de jato de chamas, 4 quadros em loop
Primary request: grade 2 por 2 com quatro quadros do mesmo jato de fogo apontado para a direita, saindo da borda esquerda da célula: quadro 1 chama fina e brilhante, quadro 2 língua longa com faíscas, quadro 3 jato largo com redemoinho laranja e âmbar, quadro 4 jato com pontas se desfazendo em brasas
Style/medium: pixel art sombria coerente com o jogo, núcleo amarelo claro, miolo laranja, bordas vermelho-escuro
Composition/framing: cada quadro com a base do jato colada na borda esquerda e centrada na altura, mesmo comprimento máximo em todos
Constraints: fundo liso magenta #FF00FF, sem texto, sem personagens, sem bordas entre os quadros, quadrado
```n
#### U07 - `vfx_subida_de_nivel` (ART-010)

- [x] gerada · [ ] aprovada

```text
Use case: stylized-concept
Asset type: sprite sheet de efeito de subida de nível, 4 quadros
Primary request: grade 2 por 2 com quatro quadros do mesmo efeito visto de cima: quadro 1 faísca dourada no centro, quadro 2 anel de luz dourada se abrindo com raios, quadro 3 pilar de luz subindo com partículas brilhantes e anel grande, quadro 4 anel dissipando em partículas douradas e brancas
Style/medium: pixel art sombria coerente com o jogo, dourado, branco quente e âmbar sobre fundo liso
Composition/framing: cada quadro centrado na célula, anel máximo ocupando a maior parte da célula, mesmo tamanho em todos
Constraints: fundo liso ciano #00FFFF, sem texto, sem personagens, sem bordas entre os quadros, quadrado
```n
#### U08 - `vfx_evolucao_flare` (ART-014)

- [x] gerada · [ ] aprovada

```text
Use case: stylized-concept
Asset type: sprite sheet de efeito de evolução de arma, 4 quadros
Primary request: grade 2 por 2 com quatro quadros do mesmo efeito: quadro 1 pequena esfera de luz branca com anel fino, quadro 2 raios longos saindo do centro e fragmentos de metal girando, quadro 3 explosão de luz branca e dourada com anel duplo e estilhaços, quadro 4 luz assentando em brilho dourado suave com fagulhas descendo
Style/medium: pixel art sombria coerente com o jogo, branco quente, dourado e âmbar, pequenos toques de roxo
Composition/framing: cada quadro centrado na célula, círculo máximo ocupando a maior parte da célula, sem arma desenhada no centro
Constraints: fundo liso ciano #00FFFF, sem texto, sem personagens, sem bordas entre os quadros, quadrado
```n
#### U09 - `evolucao_painel_moldura` (ART-014)

- [x] gerada · [ ] aprovada

```text
Use case: stylized-concept
Asset type: moldura de painel de cinemática para HUD de jogo
Primary request: grande moldura retangular de metal escuro e ouro velho com cantos ornamentados, filetes de runas, centro vazio e escuro, brilho âmbar sutil nas bordas internas
Style/medium: pixel art sombria coerente com o jogo
Composition/framing: vista frontal plana, proporção 16 para 9, moldura ocupando a imagem toda
Constraints: fundo liso magenta #FF00FF fora da moldura, centro preto sólido, sem texto, sem personagens
```n
