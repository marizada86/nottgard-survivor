---
id: "ART-PROMPTS-041"
type: "prompts-de-arte"
title: "Props temáticos do piloto: estrada, carroça, destrutíveis, armadilhas e interativos"
status: "ready-for-generation"
created: "2026-10-01"
relations: ["[[SPEC-115-riqueza-de-cenario-piloto-dagruve-docas]]", "[[ART-PROMPTS-024-cenario-e-quebraveis-por-bioma]]", "[[ART-PROMPTS-040-fundos-das-fases-piloto-dagruve-docas]]"]
sources: ["backlog ART-026", "SPEC-115 §1-4", "assets/props/*"]
---

# Props temáticos do piloto (ART-026)

Convenção do projeto (ART-PROMPTS-024): **fundo liso magenta #FF00FF** (ciano #00FFFF quando o objeto tem magenta/vinho), imagem quadrada na maior
resolução, um objeto por mensagem, recorte e remoção do fundo depois. Vista três quartos, sombra suave embaixo, sem texto.
Âncora de estilo: props existentes de Dagruve/Docas (`barril_01`, `caixote_01`, `velas_01`, `doca_01`, `rede_01`).

## Dagruve

### `dagruve_estrada_trecho`

```text
Use case: stylized-concept
Asset type: trecho de estrada de pedra para jogo, tileável nas pontas
Primary request: trecho reto de rua de pedra antiga, lajes irregulares cinza-arroxeadas gastas, sulcos de roda de carroça, musgo e poeira nas juntas, bordas desgastadas
Style/medium: pixel art sombria coerente com o jogo
Composition/framing: vista de cima em três quartos, trecho horizontal centrado, extremidades esquerda e direita com o mesmo padrão para emendar
Constraints: fundo liso magenta #FF00FF, sem texto, sem personagens, quadrado
```

### `dagruve_carroca_abandonada`

```text
Use case: stylized-concept
Asset type: prop destrutível de jogo
Primary request: carroça de madeira abandonada, uma roda quebrada, tombada de lado, sacos rasgados e tábuas soltas, madeira escura e corda velha
Style/medium: pixel art sombria coerente com o jogo, paleta marrom-escuro e cinza
Composition/framing: vista três quartos, objeto inteiro centrado, sombra suave no chão
Constraints: fundo liso magenta #FF00FF, sem texto, sem personagens, quadrado
```

### `dagruve_selo_sacrificial`

```text
Use case: stylized-concept
Asset type: armadilha de chão de jogo
Primary request: grande círculo ritual gravado na pedra, glifos e runas concêntricos, linhas de energia roxo e vinho pulsando fracas, fissuras com brilho escuro, aparência de selo de sacrifício
Style/medium: pixel art sombria coerente com o jogo
Composition/framing: vista de cima, círculo inteiro centrado e simétrico, sem profundidade
Constraints: fundo liso ciano #00FFFF, sem texto legível, sem personagens, quadrado
```

### `dagruve_poco_oferendas`

```text
Use case: stylized-concept
Asset type: objeto interativo de jogo
Primary request: poço de pedra baixo com borda gasta, velas acesas e oferendas (moedas, ossos pequenos, fitas) ao redor, água escura com brilho âmbar fraco no fundo
Style/medium: pixel art sombria coerente com o jogo, pedra cinza-arroxeada e acentos âmbar
Composition/framing: vista três quartos, objeto centrado, sombra suave
Constraints: fundo liso magenta #FF00FF, sem texto, sem personagens, quadrado
```

## Docas

### `docas_cais_trecho`

```text
Use case: stylized-concept
Asset type: trecho de cais de tábuas para jogo, tileável nas pontas
Primary request: trecho reto de cais de tábuas escuras gastas, pregos, cordas e manchas úmidas, uma borda de pedra do lado da água
Style/medium: pixel art sombria coerente com o jogo, azul-petróleo e marrom escuro
Composition/framing: vista de cima em três quartos, trecho horizontal, pontas com o mesmo padrão para emendar
Constraints: fundo liso magenta #FF00FF, sem texto, sem personagens, quadrado
```

### `docas_guindaste`

```text
Use case: stylized-concept
Asset type: prop de cenário de jogo
Primary request: guindaste de cais de madeira e ferro enferrujado, braço longo com corrente e gancho pendurado, base de pedra, corda e roldana
Style/medium: pixel art sombria coerente com o jogo, azul-petróleo, ferrugem e marrom
Composition/framing: vista três quartos, objeto inteiro centrado, sombra suave
Constraints: fundo liso magenta #FF00FF, sem texto, sem personagens, quadrado
```

### `docas_pilha_de_carga`

```text
Use case: stylized-concept
Asset type: prop destrutível de jogo
Primary request: pilha de caixotes e fardos amarrados com corda, barris ao lado, madeira escura e lona rasgada, uma etiqueta sem letras
Style/medium: pixel art sombria coerente com o jogo
Composition/framing: vista três quartos, conjunto centrado, sombra suave
Constraints: fundo liso magenta #FF00FF, sem texto, sem personagens, quadrado
```

### `docas_carga_solta`

```text
Use case: stylized-concept
Asset type: armadilha de jogo
Primary request: grande caixote de carga pendurado por corrente e gancho, balançando, com um círculo de aviso vermelho e riscado no chão embaixo, madeira e ferro enferrujado
Style/medium: pixel art sombria coerente com o jogo
Composition/framing: vista três quartos, caixote no alto e marca de impacto embaixo, centrado
Constraints: fundo liso ciano #00FFFF, sem texto legível, sem personagens, quadrado
```

### `docas_guincho_do_cais`

```text
Use case: stylized-concept
Asset type: objeto interativo de jogo
Primary request: guincho de cais com manivela e tambor de corda enrolada, estrutura de madeira e ferro, uma lanterna âmbar presa ao lado
Style/medium: pixel art sombria coerente com o jogo, azul-petróleo e acento âmbar
Composition/framing: vista três quartos, objeto centrado, sombra suave
Constraints: fundo liso magenta #FF00FF, sem texto, sem personagens, quadrado
```

## Aceite
- Mesmo traço e paleta dos props atuais; leitura clara a 64–128 px.
- Armadilhas (selo, carga solta) distinguíveis dos destrutíveis; sem letras legíveis.
- Fundo sólido uniforme para remoção limpa.
