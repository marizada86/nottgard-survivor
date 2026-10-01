---
id: "ART-PROMPTS-042"
type: "prompts-de-arte"
title: "Cópia-isca e explosão do Sylas; Ampulheta, Altar da Doação e Mesa de Aposta"
status: "ready-for-generation"
created: "2026-10-01"
relations: ["[[SPEC-114-passo-pelas-sombras-copia-isca]]", "[[SPEC-085-jogar-mais-rapido-2x-e-ampulheta]]", "[[SPEC-087-fidelidade-e-eventos-de-risco]]", "[[ART-PROMPTS-041-props-tematicos-piloto-dagruve-docas]]"]
sources: ["backlog ART-027, ART-018, ART-019, ART-020", "assets/heroes/sylas.png", "assets/interactions/*"]
---

# Isca do Sylas e três eventos (ART-027, ART-018, ART-019, ART-020)

Convenção do projeto: fundo liso **magenta #FF00FF** (ciano #00FFFF quando o objeto tem magenta ou roxo), imagem quadrada na maior resolução,
um objeto por mensagem, remover o fundo depois. Sem texto legível. Âncora de estilo das interações: `assets/interactions/altar_active.png`,
`loja.png`, `ferreiro.png`.

## ART-027 — Passo pelas Sombras

### `sylas_copia_isca`
Anexar `assets/heroes/sylas.png` como referência de silhueta e roupa. Destino: `assets/heroes/sylas_decoy.png`.

```text
Use case: stylized-concept
Asset type: sprite de cópia-isca de personagem de jogo
Primary request: a mesma figura do personagem de referência, mesma silhueta, pose e proporções, mas como uma cópia de sombra: corpo translúcido roxo-escuro, contornos violeta brilhantes, fios de fumaça escura saindo dos pés e das bordas, olhos como dois pontos luminosos violeta
Style/medium: pixel art sombria coerente com o jogo, pixels nítidos, mesma resolução do personagem de referência
Composition/framing: figura inteira centrada, vista igual à do personagem de referência
Constraints: fundo liso ciano #00FFFF, sem texto, sem outros personagens, quadrado
```

### `sylas_explosao_sombria`
Destino: sequência de 4 quadros para o evento `decoy_blast` (recortar a grade 2×2).

```text
Use case: stylized-concept
Asset type: sprite sheet de efeito visual de explosão, 4 quadros
Primary request: grade 2 por 2 com quatro quadros da mesma explosão de energia sombria vista de cima: quadro 1 núcleo pequeno roxo-escuro comprimido, quadro 2 onda violeta se abrindo com fagulhas, quadro 3 anel grande de fumaça roxa e vinho com raios escuros, quadro 4 anel dissipando em fiapos e brasas
Style/medium: pixel art sombria coerente com o jogo, paleta preto-violeta, lilás elétrico e vinho
Composition/framing: cada quadro centrado em sua célula, mesmo tamanho de círculo máximo em todos, círculo de impacto ocupando a maior parte da célula
Constraints: fundo liso ciano #00FFFF, sem texto, sem personagens, sem bordas entre os quadros, quadrado
```

## Eventos de mapa

### `ampulheta` (ART-018)
Destino: `assets/interactions/ampulheta.png`.

```text
Use case: stylized-concept
Asset type: objeto interativo de jogo
Primary request: grande ampulheta de metal escuro e vidro sobre um pedestal de pedra gasta, areia lilás luminosa caindo no centro, runas apagadas na moldura, brilho roxo discreto ao redor
Style/medium: pixel art sombria coerente com o jogo, pedra cinza-arroxeada, metal escuro e acentos lilás
Composition/framing: vista três quartos, objeto inteiro centrado, sombra suave no chão
Constraints: fundo liso magenta #FF00FF, sem texto, sem personagens, quadrado
```

### `altar_doacao` (ART-019)
Destino: `assets/interactions/doacao.png`. Diferente do altar de bênção: aqui o jogador deixa um equipamento.

```text
Use case: stylized-concept
Asset type: objeto interativo de jogo
Primary request: altar de oferenda de pedra escura com uma bacia rasa no topo, uma espada e uma armadura velha depositadas como oferenda, velas acesas ao redor, fios de luz dourada subindo da bacia, símbolo de mão aberta gravado na frente
Style/medium: pixel art sombria coerente com o jogo, pedra cinza, acentos dourados e âmbar
Composition/framing: vista três quartos, objeto inteiro centrado, sombra suave no chão
Constraints: fundo liso magenta #FF00FF, sem texto legível, sem personagens, quadrado
```

### `mesa_aposta` (ART-020)
Destino: `assets/interactions/aposta.png`.

```text
Use case: stylized-concept
Asset type: objeto interativo de jogo
Primary request: mesa de jogo de madeira escura gasta com toalha de feltro verde-escuro rasgada, pilhas de moedas de ouro, três dados de osso, cartas viradas e uma vela, atmosfera de aposta clandestina
Style/medium: pixel art sombria coerente com o jogo, madeira marrom, feltro verde escuro e acentos dourados
Composition/framing: vista três quartos, objeto inteiro centrado, sombra suave no chão
Constraints: fundo liso magenta #FF00FF, sem texto, sem personagens, quadrado
```

## Aceite
- Isca reconhecível como o Sylas, mas claramente uma sombra; explosão lê bem a 64–128 px e não lembra magia de cura.
- Os três eventos se distinguem entre si e de loja, ferreiro e curandeiro pela silhueta e pela cor.
- Fundo sólido uniforme; sem letras.
