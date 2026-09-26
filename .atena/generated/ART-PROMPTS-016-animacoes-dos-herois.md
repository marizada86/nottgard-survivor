---
id: "ART-PROMPTS-016"
type: "prompts-de-arte"
title: "Animações dos nove heróis jogáveis"
status: "approved-for-generation"
created: "2026-09-23"
relations: ["[[SPEC-021-prompts-de-animacao-dos-herois]]", "[[ART-PROMPTS-002-retratos-e-herois]]", "[[ART-PROMPTS-011-herois-run-e-inimigos-legado]]", "[[ART-PROMPTS-014-animacao-dagruve-piloto]]", "[[ART-PROMPTS-015-durvall-movimento-direcional]]"]
sources: ["data/heroes.json", "data/weapons.json", "data/abilities.json", "vault/canon/PLAN-001-nottgard-survivors.md"]
---

# Animações dos heróis jogáveis

Este pacote cobre Brook, Maelor, Sylas, Kayron, Korrak, Leoric, Nyrelia,
Zynara e Bromnor. Durvall reutiliza as doze sequências já definidas em
`ART-PROMPTS-014` e `ART-PROMPTS-015`.

Cada chamada abaixo é independente. Produza PNG RGBA com alfa real: corpo
inteiro, pixel art detalhada e sóbria, câmera três-quartos isométrica, luz
superior esquerda, células de `256×384`, base dos pés idêntica e sem invasão
entre células. Para seis quadros, entregar grade-fonte 3×2; para quatro,
grade-fonte 2×2. Não incluir cenário, piso, sombra projetada, borda, grade,
texto, rótulo, watermark, motion blur, anatomia extra, arma duplicada ou
redesign. Direções são visuais na tela, não coordenadas do chão.

O destino posterior de cada chamada é
`assets/animations/heroes/<id>/<sequencia>.png`; os caminhos de candidata e a
contagem constam no manifesto associado. Nenhuma chamada desta etapa gera uma
imagem automaticamente.

> **Regra global vigente desde 2026-09-24:** para qualquer lote novo, gerar somente `move_n`, `move_ne`, `move_e`, `move_se` e `move_s`.
> As chamadas `move_nw`, `move_w` e `move_sw` abaixo são legadas de um catálogo anterior e não devem ser executadas.
> O jogo as obtém espelhando respectivamente `move_ne`, `move_e` e `move_se` na horizontal.

## Brook França

Regra obrigatória de identidade: Brook é um anão. Ele tem orelhas curtas e
arredondadas, parcialmente cobertas pelo cabelo; nunca orelhas longas, pontudas
ou élficas. Esta regra prevalece sobre qualquer referência visual conflitante.

- `HERO-brook-idle` — Folha 2D isométrica de 4 quadros: Brook França, jovem anão adulto baixo e robusto, barba e cabelo castanho-escuros, armadura pesada de aço escuro e couro, maça compacta e pequeno acento dourado de Lliira. Respiração firme e guarda justa, sem pose régia.
- `HERO-brook-move_n` — Folha 2D isométrica de 6 quadros: Brook França, jovem anão adulto baixo e robusto, barba castanho-escura, aço e couro, maça compacta e acento dourado discreto de Lliira, caminhando visivelmente para cima na tela, passada pesada e legível.
- `HERO-brook-move_ne` — Folha 2D isométrica de 6 quadros: Brook França, jovem anão adulto baixo e robusto, barba castanho-escura, aço e couro, maça compacta e acento dourado discreto de Lliira, caminhando visivelmente para cima e direita na tela, passada pesada e legível.
- `HERO-brook-move_e` — Folha 2D isométrica de 6 quadros: Brook França, jovem anão adulto baixo e robusto, barba castanho-escura, aço e couro, maça compacta e acento dourado discreto de Lliira, caminhando visivelmente para a direita na tela, passada pesada e legível.
- `HERO-brook-move_se` — Folha 2D isométrica de 6 quadros: Brook França, jovem anão adulto baixo e robusto, barba castanho-escura, aço e couro, maça compacta e acento dourado discreto de Lliira, caminhando visivelmente para baixo e direita na tela, passada pesada e legível.
- `HERO-brook-move_s` — Folha 2D isométrica de 6 quadros: Brook França, jovem anão adulto baixo e robusto, barba castanho-escura, aço e couro, maça compacta e acento dourado discreto de Lliira, caminhando visivelmente para baixo na tela, passada pesada e legível.
- `HERO-brook-move_sw` — Folha 2D isométrica de 6 quadros: Brook França, jovem anão adulto baixo e robusto, barba castanho-escura, aço e couro, maça compacta e acento dourado discreto de Lliira, caminhando visivelmente para baixo e esquerda na tela, passada pesada e legível.
- `HERO-brook-move_w` — Folha 2D isométrica de 6 quadros: Brook França, jovem anão adulto baixo e robusto, barba castanho-escura, aço e couro, maça compacta e acento dourado discreto de Lliira, caminhando visivelmente para a esquerda na tela, passada pesada e legível.
- `HERO-brook-move_nw` — Folha 2D isométrica de 6 quadros: Brook França, jovem anão adulto baixo e robusto, barba castanho-escura, aço e couro, maça compacta e acento dourado discreto de Lliira, caminhando visivelmente para cima e esquerda na tela, passada pesada e legível.
- `HERO-brook-attack` — Folha 2D isométrica de 4 quadros: Brook França, jovem anão robusto de barba castanho-escura em aço e couro, desfere Sentença de Lliira com a maça compacta; arco curto controlado e onda dourada pequena, sem explosão que cubra o corpo.
- `HERO-brook-active` — Folha 2D isométrica de 6 quadros: Brook França, jovem anão robusto de aço e couro, ativa Guarda de Lliira; bloqueio firme com maça, escudo radiante dourado contido e resposta em onda curta, sem halo nem asas.
- `HERO-brook-death` — Folha 2D isométrica de 6 quadros: Brook França, jovem anão robusto de barba castanho-escura, aço e couro, cai de lado e solta a maça sem gore; o brilho dourado se apaga de modo contido.

## Maelor

- `HERO-maelor-idle` — Folha 2D isométrica de 4 quadros: Maelor, humano adulto de cabelo castanho-claro, vestes práticas de conjurador viajante em marrom e azul, mão com luz curativa azul-clara. Respiração protetora e foco sereno, sem aparência régia.
- `HERO-maelor-move_n` — Folha 2D isométrica de 6 quadros: Maelor, humano adulto de cabelo castanho-claro, vestes marrom e azul de conjurador viajante e luz curativa azul-clara na mão, caminhando visivelmente para cima na tela, postura protetora.
- `HERO-maelor-move_ne` — Folha 2D isométrica de 6 quadros: Maelor, humano adulto de cabelo castanho-claro, vestes marrom e azul de conjurador viajante e luz curativa azul-clara na mão, caminhando visivelmente para cima e direita na tela, postura protetora.
- `HERO-maelor-move_e` — Folha 2D isométrica de 6 quadros: Maelor, humano adulto de cabelo castanho-claro, vestes marrom e azul de conjurador viajante e luz curativa azul-clara na mão, caminhando visivelmente para a direita na tela, postura protetora.
- `HERO-maelor-move_se` — Folha 2D isométrica de 6 quadros: Maelor, humano adulto de cabelo castanho-claro, vestes marrom e azul de conjurador viajante e luz curativa azul-clara na mão, caminhando visivelmente para baixo e direita na tela, postura protetora.
- `HERO-maelor-move_s` — Folha 2D isométrica de 6 quadros: Maelor, humano adulto de cabelo castanho-claro, vestes marrom e azul de conjurador viajante e luz curativa azul-clara na mão, caminhando visivelmente para baixo na tela, postura protetora.
- `HERO-maelor-move_sw` — Folha 2D isométrica de 6 quadros: Maelor, humano adulto de cabelo castanho-claro, vestes marrom e azul de conjurador viajante e luz curativa azul-clara na mão, caminhando visivelmente para baixo e esquerda na tela, postura protetora.
- `HERO-maelor-move_w` — Folha 2D isométrica de 6 quadros: Maelor, humano adulto de cabelo castanho-claro, vestes marrom e azul de conjurador viajante e luz curativa azul-clara na mão, caminhando visivelmente para a esquerda na tela, postura protetora.
- `HERO-maelor-move_nw` — Folha 2D isométrica de 6 quadros: Maelor, humano adulto de cabelo castanho-claro, vestes marrom e azul de conjurador viajante e luz curativa azul-clara na mão, caminhando visivelmente para cima e esquerda na tela, postura protetora.
- `HERO-maelor-attack` — Folha 2D isométrica de 4 quadros: Maelor, humano adulto em vestes marrom e azul de viajante, lança um Raio de Luz azul-claro pela mão; gesto curto, corpo inteiro ainda legível e magia sem mudar a anatomia.
- `HERO-maelor-active` — Folha 2D isométrica de 6 quadros: Maelor, humano adulto em vestes marrom e azul, ativa Comunhão; abre a mão, aura azul-clara curta pulsa ao redor e pequenos sinais de cura e marca surgem sem esconder a silhueta.
- `HERO-maelor-death` — Folha 2D isométrica de 6 quadros: Maelor, humano adulto de cabelo castanho-claro e vestes marrom e azul, cai de lado sem gore; a pequena luz curativa azul-clara desaparece antes do último quadro.

## Sylas Malafaia

- `HERO-sylas-idle` — Folha 2D isométrica de 4 quadros: Sylas Malafaia, tiefling adulto de pele escura avermelhada, chifres altos voltados para trás, armadura e manto carvão com detalhes roxos de Mask, sombras discretas no ombro e nenhuma asa. Guarda furtiva controlada.
- `HERO-sylas-move_n` — Folha 2D isométrica de 6 quadros: Sylas Malafaia, tiefling adulto de chifres para trás, armadura e manto carvão/roxo de Mask, sombras discretas e sem asas, caminhando visivelmente para cima na tela com passada furtiva.
- `HERO-sylas-move_ne` — Folha 2D isométrica de 6 quadros: Sylas Malafaia, tiefling adulto de chifres para trás, armadura e manto carvão/roxo de Mask, sombras discretas e sem asas, caminhando visivelmente para cima e direita na tela com passada furtiva.
- `HERO-sylas-move_e` — Folha 2D isométrica de 6 quadros: Sylas Malafaia, tiefling adulto de chifres para trás, armadura e manto carvão/roxo de Mask, sombras discretas e sem asas, caminhando visivelmente para a direita na tela com passada furtiva.
- `HERO-sylas-move_se` — Folha 2D isométrica de 6 quadros: Sylas Malafaia, tiefling adulto de chifres para trás, armadura e manto carvão/roxo de Mask, sombras discretas e sem asas, caminhando visivelmente para baixo e direita na tela com passada furtiva.
- `HERO-sylas-move_s` — Folha 2D isométrica de 6 quadros: Sylas Malafaia, tiefling adulto de chifres para trás, armadura e manto carvão/roxo de Mask, sombras discretas e sem asas, caminhando visivelmente para baixo na tela com passada furtiva.
- `HERO-sylas-move_sw` — Folha 2D isométrica de 6 quadros: Sylas Malafaia, tiefling adulto de chifres para trás, armadura e manto carvão/roxo de Mask, sombras discretas e sem asas, caminhando visivelmente para baixo e esquerda na tela com passada furtiva.
- `HERO-sylas-move_w` — Folha 2D isométrica de 6 quadros: Sylas Malafaia, tiefling adulto de chifres para trás, armadura e manto carvão/roxo de Mask, sombras discretas e sem asas, caminhando visivelmente para a esquerda na tela com passada furtiva.
- `HERO-sylas-move_nw` — Folha 2D isométrica de 6 quadros: Sylas Malafaia, tiefling adulto de chifres para trás, armadura e manto carvão/roxo de Mask, sombras discretas e sem asas, caminhando visivelmente para cima e esquerda na tela com passada furtiva.
- `HERO-sylas-attack` — Folha 2D isométrica de 4 quadros: Sylas Malafaia, tiefling adulto em carvão e roxo de Mask, dispara Raio Enfraquecedor violeta estreito pela mão; expressão controlada, nenhuma asa e nenhum efeito que cubra o corpo.
- `HERO-sylas-active` — Folha 2D isométrica de 6 quadros: Sylas Malafaia, tiefling adulto de chifres para trás, executa Passo pelas Sombras; avanço curto com sombra roxa aderida e rastro fino, retornando inteiro e sem duplicatas.
- `HERO-sylas-death` — Folha 2D isométrica de 6 quadros: Sylas Malafaia, tiefling adulto em armadura carvão e manto roxo, cai de lado sem gore; as sombras discretas se desfazem, sem asas ou transformação demoníaca.

## Kayron Lioran

- `HERO-kayron-idle` — Folha 2D isométrica de 4 quadros: Kayron Lioran, aasimar adulto de cabelo branco muito claro, armadura negra leve e tecido escuro com acentos violeta de Shar, energia estelar mínima e penas de sombra transitórias, nunca asas anatômicas. Postura disciplinada.
- `HERO-kayron-move_n` — Folha 2D isométrica de 6 quadros: Kayron Lioran, aasimar adulto de cabelo branco, armadura negra leve e acentos violeta de Shar, energia estelar mínima e sem asas anatômicas, caminhando visivelmente para cima na tela.
- `HERO-kayron-move_ne` — Folha 2D isométrica de 6 quadros: Kayron Lioran, aasimar adulto de cabelo branco, armadura negra leve e acentos violeta de Shar, energia estelar mínima e sem asas anatômicas, caminhando visivelmente para cima e direita na tela.
- `HERO-kayron-move_e` — Folha 2D isométrica de 6 quadros: Kayron Lioran, aasimar adulto de cabelo branco, armadura negra leve e acentos violeta de Shar, energia estelar mínima e sem asas anatômicas, caminhando visivelmente para a direita na tela.
- `HERO-kayron-move_se` — Folha 2D isométrica de 6 quadros: Kayron Lioran, aasimar adulto de cabelo branco, armadura negra leve e acentos violeta de Shar, energia estelar mínima e sem asas anatômicas, caminhando visivelmente para baixo e direita na tela.
- `HERO-kayron-move_s` — Folha 2D isométrica de 6 quadros: Kayron Lioran, aasimar adulto de cabelo branco, armadura negra leve e acentos violeta de Shar, energia estelar mínima e sem asas anatômicas, caminhando visivelmente para baixo na tela.
- `HERO-kayron-move_sw` — Folha 2D isométrica de 6 quadros: Kayron Lioran, aasimar adulto de cabelo branco, armadura negra leve e acentos violeta de Shar, energia estelar mínima e sem asas anatômicas, caminhando visivelmente para baixo e esquerda na tela.
- `HERO-kayron-move_w` — Folha 2D isométrica de 6 quadros: Kayron Lioran, aasimar adulto de cabelo branco, armadura negra leve e acentos violeta de Shar, energia estelar mínima e sem asas anatômicas, caminhando visivelmente para a esquerda na tela.
- `HERO-kayron-move_nw` — Folha 2D isométrica de 6 quadros: Kayron Lioran, aasimar adulto de cabelo branco, armadura negra leve e acentos violeta de Shar, energia estelar mínima e sem asas anatômicas, caminhando visivelmente para cima e esquerda na tela.
- `HERO-kayron-attack` — Folha 2D isométrica de 4 quadros: Kayron Lioran, aasimar adulto de cabelo branco, armadura negra leve com violeta de Shar, projeta Descarga Estelar pequena e fria; energia controlada, sem asas anatômicas nem clarão que esconda o corpo.
- `HERO-kayron-active` — Folha 2D isométrica de 6 quadros: Kayron Lioran, aasimar adulto de armadura negra leve, ativa Sobrecarga Mística; runas violeta e faíscas estelares aceleram ao redor do torso, penas de sombra transitórias sem formar asas.
- `HERO-kayron-death` — Folha 2D isométrica de 6 quadros: Kayron Lioran, aasimar adulto de cabelo branco e armadura negra leve, cai de lado sem gore; as faíscas violeta e penas de sombra transitórias somem, sem asas.

## Korrak Nammat

- `HERO-korrak-idle` — Folha 2D isométrica de 4 quadros: Korrak Nammat, goliath adulto enorme de pele cinza marcada por cicatrizes, couro, ferro e pele marrom, Machado de Xar'gath negro com fissuras vermelhas. Respiração pesada, silhueta forte e sem traços demoníacos.
- `HERO-korrak-move_n` — Folha 2D isométrica de 6 quadros: Korrak Nammat, goliath enorme de pele cinza cicatrizada, couro, ferro e pele marrom, Machado de Xar'gath negro com fissuras vermelhas, caminhando visivelmente para cima na tela com peso real.
- `HERO-korrak-move_ne` — Folha 2D isométrica de 6 quadros: Korrak Nammat, goliath enorme de pele cinza cicatrizada, couro, ferro e pele marrom, Machado de Xar'gath negro com fissuras vermelhas, caminhando visivelmente para cima e direita na tela com peso real.
- `HERO-korrak-move_e` — Folha 2D isométrica de 6 quadros: Korrak Nammat, goliath enorme de pele cinza cicatrizada, couro, ferro e pele marrom, Machado de Xar'gath negro com fissuras vermelhas, caminhando visivelmente para a direita na tela com peso real.
- `HERO-korrak-move_se` — Folha 2D isométrica de 6 quadros: Korrak Nammat, goliath enorme de pele cinza cicatrizada, couro, ferro e pele marrom, Machado de Xar'gath negro com fissuras vermelhas, caminhando visivelmente para baixo e direita na tela com peso real.
- `HERO-korrak-move_s` — Folha 2D isométrica de 6 quadros: Korrak Nammat, goliath enorme de pele cinza cicatrizada, couro, ferro e pele marrom, Machado de Xar'gath negro com fissuras vermelhas, caminhando visivelmente para baixo na tela com peso real.
- `HERO-korrak-move_sw` — Folha 2D isométrica de 6 quadros: Korrak Nammat, goliath enorme de pele cinza cicatrizada, couro, ferro e pele marrom, Machado de Xar'gath negro com fissuras vermelhas, caminhando visivelmente para baixo e esquerda na tela com peso real.
- `HERO-korrak-move_w` — Folha 2D isométrica de 6 quadros: Korrak Nammat, goliath enorme de pele cinza cicatrizada, couro, ferro e pele marrom, Machado de Xar'gath negro com fissuras vermelhas, caminhando visivelmente para a esquerda na tela com peso real.
- `HERO-korrak-move_nw` — Folha 2D isométrica de 6 quadros: Korrak Nammat, goliath enorme de pele cinza cicatrizada, couro, ferro e pele marrom, Machado de Xar'gath negro com fissuras vermelhas, caminhando visivelmente para cima e esquerda na tela com peso real.
- `HERO-korrak-attack` — Folha 2D isométrica de 4 quadros: Korrak Nammat, goliath enorme de pele cinza cicatrizada, golpeia com Machado de Xar'gath negro de fissuras vermelhas; corte pesado, arco curto e brasa contida, sem fogo cobrindo o corpo.
- `HERO-korrak-active` — Folha 2D isométrica de 6 quadros: Korrak Nammat, goliath enorme de couro e ferro, executa Impacto de Xar'gath; martelo do machado no solo, anel baixo de fogo vermelho e roubo de vida sugerido por brilho curto, sem explosão gigante.
- `HERO-korrak-death` — Folha 2D isométrica de 6 quadros: Korrak Nammat, goliath enorme de pele cinza cicatrizada, couro e ferro, cai pesadamente de lado e deixa o machado próximo, sem gore; as fissuras vermelhas se apagam.

## Leoric

- `HERO-leoric-idle` — Folha 2D isométrica de 4 quadros: Leoric, gnomo adulto, chapéu escuro largo, barba grisalha, manto verde-musgo com constelações douradas e foco azul. Postura de astrônomo místico adulto, nunca infantil ou chibi.
- `HERO-leoric-move_n` — Folha 2D isométrica de 6 quadros: Leoric, gnomo adulto de chapéu escuro largo, barba grisalha, manto verde-musgo com constelações douradas e foco azul, caminhando visivelmente para cima na tela; proporção adulta, não chibi.
- `HERO-leoric-move_ne` — Folha 2D isométrica de 6 quadros: Leoric, gnomo adulto de chapéu escuro largo, barba grisalha, manto verde-musgo com constelações douradas e foco azul, caminhando visivelmente para cima e direita na tela; proporção adulta, não chibi.
- `HERO-leoric-move_e` — Folha 2D isométrica de 6 quadros: Leoric, gnomo adulto de chapéu escuro largo, barba grisalha, manto verde-musgo com constelações douradas e foco azul, caminhando visivelmente para a direita na tela; proporção adulta, não chibi.
- `HERO-leoric-move_se` — Folha 2D isométrica de 6 quadros: Leoric, gnomo adulto de chapéu escuro largo, barba grisalha, manto verde-musgo com constelações douradas e foco azul, caminhando visivelmente para baixo e direita na tela; proporção adulta, não chibi.
- `HERO-leoric-move_s` — Folha 2D isométrica de 6 quadros: Leoric, gnomo adulto de chapéu escuro largo, barba grisalha, manto verde-musgo com constelações douradas e foco azul, caminhando visivelmente para baixo na tela; proporção adulta, não chibi.
- `HERO-leoric-move_sw` — Folha 2D isométrica de 6 quadros: Leoric, gnomo adulto de chapéu escuro largo, barba grisalha, manto verde-musgo com constelações douradas e foco azul, caminhando visivelmente para baixo e esquerda na tela; proporção adulta, não chibi.
- `HERO-leoric-move_w` — Folha 2D isométrica de 6 quadros: Leoric, gnomo adulto de chapéu escuro largo, barba grisalha, manto verde-musgo com constelações douradas e foco azul, caminhando visivelmente para a esquerda na tela; proporção adulta, não chibi.
- `HERO-leoric-move_nw` — Folha 2D isométrica de 6 quadros: Leoric, gnomo adulto de chapéu escuro largo, barba grisalha, manto verde-musgo com constelações douradas e foco azul, caminhando visivelmente para cima e esquerda na tela; proporção adulta, não chibi.
- `HERO-leoric-attack` — Folha 2D isométrica de 4 quadros: Leoric, gnomo adulto de manto verde-musgo e foco azul, dispara Sopro de Estrela como raio azul curto com pequenas constelações douradas; chapéu e barba continuam visíveis.
- `HERO-leoric-active` — Folha 2D isométrica de 6 quadros: Leoric, gnomo adulto de chapéu escuro e manto verde-musgo, ativa Constelação; oito estrelas pequenas saem em círculo do foco azul, sem cobrir o personagem nem virar aura sagrada.
- `HERO-leoric-death` — Folha 2D isométrica de 6 quadros: Leoric, gnomo adulto de chapéu escuro largo e barba grisalha, cai de lado sem gore; o foco azul e os pontos de constelação dourados se extinguem.

## Nyrelia

- `HERO-nyrelia-idle` — Folha 2D isométrica de 4 quadros: Nyrelia, sacerdotisa adulta de Mask e Greenholders, rosto totalmente coberto por máscara escura lisa e elegante, capuz profundo, vestes verde-escuras e carvão, fechos de bronze e aura amarela mínima. Não revelar espécie, pele, olhos, cabelo ou orelhas.
- `HERO-nyrelia-move_n` — Folha 2D isométrica de 6 quadros: Nyrelia, sacerdotisa mascarada de espécie indeterminada, capuz profundo, vestes verde-escuras/carvão, fechos de bronze e aura amarela mínima, caminhando visivelmente para cima na tela. Não mostrar pele, olhos, cabelo ou orelhas.
- `HERO-nyrelia-move_ne` — Folha 2D isométrica de 6 quadros: Nyrelia, sacerdotisa mascarada de espécie indeterminada, capuz profundo, vestes verde-escuras/carvão, fechos de bronze e aura amarela mínima, caminhando visivelmente para cima e direita na tela. Não mostrar pele, olhos, cabelo ou orelhas.
- `HERO-nyrelia-move_e` — Folha 2D isométrica de 6 quadros: Nyrelia, sacerdotisa mascarada de espécie indeterminada, capuz profundo, vestes verde-escuras/carvão, fechos de bronze e aura amarela mínima, caminhando visivelmente para a direita na tela. Não mostrar pele, olhos, cabelo ou orelhas.
- `HERO-nyrelia-move_se` — Folha 2D isométrica de 6 quadros: Nyrelia, sacerdotisa mascarada de espécie indeterminada, capuz profundo, vestes verde-escuras/carvão, fechos de bronze e aura amarela mínima, caminhando visivelmente para baixo e direita na tela. Não mostrar pele, olhos, cabelo ou orelhas.
- `HERO-nyrelia-move_s` — Folha 2D isométrica de 6 quadros: Nyrelia, sacerdotisa mascarada de espécie indeterminada, capuz profundo, vestes verde-escuras/carvão, fechos de bronze e aura amarela mínima, caminhando visivelmente para baixo na tela. Não mostrar pele, olhos, cabelo ou orelhas.
- `HERO-nyrelia-move_sw` — Folha 2D isométrica de 6 quadros: Nyrelia, sacerdotisa mascarada de espécie indeterminada, capuz profundo, vestes verde-escuras/carvão, fechos de bronze e aura amarela mínima, caminhando visivelmente para baixo e esquerda na tela. Não mostrar pele, olhos, cabelo ou orelhas.
- `HERO-nyrelia-move_w` — Folha 2D isométrica de 6 quadros: Nyrelia, sacerdotisa mascarada de espécie indeterminada, capuz profundo, vestes verde-escuras/carvão, fechos de bronze e aura amarela mínima, caminhando visivelmente para a esquerda na tela. Não mostrar pele, olhos, cabelo ou orelhas.
- `HERO-nyrelia-move_nw` — Folha 2D isométrica de 6 quadros: Nyrelia, sacerdotisa mascarada de espécie indeterminada, capuz profundo, vestes verde-escuras/carvão, fechos de bronze e aura amarela mínima, caminhando visivelmente para cima e esquerda na tela. Não mostrar pele, olhos, cabelo ou orelhas.
- `HERO-nyrelia-attack` — Folha 2D isométrica de 4 quadros: Nyrelia, sacerdotisa mascarada de Mask, estende a mão de manga fechada e lança Dominar Pessoa como fio amarelo muito discreto; máscara e silhueta prática ficam visíveis, sem halo sagrado.
- `HERO-nyrelia-active` — Folha 2D isométrica de 6 quadros: Nyrelia, sacerdotisa mascarada de espécie indeterminada, ativa Dominação; gesto protetor e foco amarelo discreto à frente da máscara, sem revelar anatomia ou formar asas, halo ou símbolo inventado.
- `HERO-nyrelia-death` — Folha 2D isométrica de 6 quadros: Nyrelia, sacerdotisa mascarada de capuz verde-escuro e carvão, cai de lado sem gore; a máscara continua cobrindo tudo e a aura amarela mínima se extingue.

## Zynara Vellen

- `HERO-zynara-idle` — Folha 2D isométrica de 4 quadros: Zynara Vellen, elfa adulta alta de cabelo branco-prateado, traje negro de estudiosa com filigrana dourada sóbria, pequena ampulheta prateada e postura analítica. Conselheira e pesquisadora, nunca rainha.
- `HERO-zynara-move_n` — Folha 2D isométrica de 6 quadros: Zynara Vellen, elfa adulta alta de cabelo branco-prateado, traje negro com filigrana dourada sóbria e ampulheta prateada, caminhando visivelmente para cima na tela; postura analítica, não régia.
- `HERO-zynara-move_ne` — Folha 2D isométrica de 6 quadros: Zynara Vellen, elfa adulta alta de cabelo branco-prateado, traje negro com filigrana dourada sóbria e ampulheta prateada, caminhando visivelmente para cima e direita na tela; postura analítica, não régia.
- `HERO-zynara-move_e` — Folha 2D isométrica de 6 quadros: Zynara Vellen, elfa adulta alta de cabelo branco-prateado, traje negro com filigrana dourada sóbria e ampulheta prateada, caminhando visivelmente para a direita na tela; postura analítica, não régia.
- `HERO-zynara-move_se` — Folha 2D isométrica de 6 quadros: Zynara Vellen, elfa adulta alta de cabelo branco-prateado, traje negro com filigrana dourada sóbria e ampulheta prateada, caminhando visivelmente para baixo e direita na tela; postura analítica, não régia.
- `HERO-zynara-move_s` — Folha 2D isométrica de 6 quadros: Zynara Vellen, elfa adulta alta de cabelo branco-prateado, traje negro com filigrana dourada sóbria e ampulheta prateada, caminhando visivelmente para baixo na tela; postura analítica, não régia.
- `HERO-zynara-move_sw` — Folha 2D isométrica de 6 quadros: Zynara Vellen, elfa adulta alta de cabelo branco-prateado, traje negro com filigrana dourada sóbria e ampulheta prateada, caminhando visivelmente para baixo e esquerda na tela; postura analítica, não régia.
- `HERO-zynara-move_w` — Folha 2D isométrica de 6 quadros: Zynara Vellen, elfa adulta alta de cabelo branco-prateado, traje negro com filigrana dourada sóbria e ampulheta prateada, caminhando visivelmente para a esquerda na tela; postura analítica, não régia.
- `HERO-zynara-move_nw` — Folha 2D isométrica de 6 quadros: Zynara Vellen, elfa adulta alta de cabelo branco-prateado, traje negro com filigrana dourada sóbria e ampulheta prateada, caminhando visivelmente para cima e esquerda na tela; postura analítica, não régia.
- `HERO-zynara-attack` — Folha 2D isométrica de 4 quadros: Zynara Vellen, elfa estudiosa de traje negro e filigrana dourada sóbria, ergue a ampulheta prateada e emite Marca da Retidão como traço prateado curto; sem coroa ou pose de rainha.
- `HERO-zynara-active` — Folha 2D isométrica de 6 quadros: Zynara Vellen, elfa estudiosa de cabelo branco-prateado, ativa Suspensão Temporal; areia prateada e anéis temporais pequenos desaceleram ao redor, mantendo rosto, ampulheta e silhueta visíveis.
- `HERO-zynara-death` — Folha 2D isométrica de 6 quadros: Zynara Vellen, elfa adulta alta de cabelo branco-prateado e traje negro, cai de lado sem gore; a ampulheta prateada perde o brilho, sem desaparecer nem quebrar em texto.

## Bromnor Martelo da Luz

- `HERO-bromnor-idle` — Folha 2D isométrica de 4 quadros: Bromnor Martelo da Luz, anão idoso largo e poderoso, cabelo e barba brancos longos, armadura de bronze e aço, couro e tecido azul profundo, Martelo da Glória com luz dourada/prateada contida. Líder justo, vivo e corpóreo.
- `HERO-bromnor-move_n` — Folha 2D isométrica de 6 quadros: Bromnor Martelo da Luz, anão idoso largo de barba branca longa, bronze, aço, couro e tecido azul, Martelo da Glória com luz dourada/prateada contida, caminhando visivelmente para cima na tela.
- `HERO-bromnor-move_ne` — Folha 2D isométrica de 6 quadros: Bromnor Martelo da Luz, anão idoso largo de barba branca longa, bronze, aço, couro e tecido azul, Martelo da Glória com luz dourada/prateada contida, caminhando visivelmente para cima e direita na tela.
- `HERO-bromnor-move_e` — Folha 2D isométrica de 6 quadros: Bromnor Martelo da Luz, anão idoso largo de barba branca longa, bronze, aço, couro e tecido azul, Martelo da Glória com luz dourada/prateada contida, caminhando visivelmente para a direita na tela.
- `HERO-bromnor-move_se` — Folha 2D isométrica de 6 quadros: Bromnor Martelo da Luz, anão idoso largo de barba branca longa, bronze, aço, couro e tecido azul, Martelo da Glória com luz dourada/prateada contida, caminhando visivelmente para baixo e direita na tela.
- `HERO-bromnor-move_s` — Folha 2D isométrica de 6 quadros: Bromnor Martelo da Luz, anão idoso largo de barba branca longa, bronze, aço, couro e tecido azul, Martelo da Glória com luz dourada/prateada contida, caminhando visivelmente para baixo na tela.
- `HERO-bromnor-move_sw` — Folha 2D isométrica de 6 quadros: Bromnor Martelo da Luz, anão idoso largo de barba branca longa, bronze, aço, couro e tecido azul, Martelo da Glória com luz dourada/prateada contida, caminhando visivelmente para baixo e esquerda na tela.
- `HERO-bromnor-move_w` — Folha 2D isométrica de 6 quadros: Bromnor Martelo da Luz, anão idoso largo de barba branca longa, bronze, aço, couro e tecido azul, Martelo da Glória com luz dourada/prateada contida, caminhando visivelmente para a esquerda na tela.
- `HERO-bromnor-move_nw` — Folha 2D isométrica de 6 quadros: Bromnor Martelo da Luz, anão idoso largo de barba branca longa, bronze, aço, couro e tecido azul, Martelo da Glória com luz dourada/prateada contida, caminhando visivelmente para cima e esquerda na tela.
- `HERO-bromnor-attack` — Folha 2D isométrica de 4 quadros: Bromnor Martelo da Luz, anão idoso largo de bronze e tecido azul, golpeia com o Martelo da Glória; arco forte e luz dourada/prateada curta, sem converter o martelo em cajado.
- `HERO-bromnor-active` — Folha 2D isométrica de 6 quadros: Bromnor Martelo da Luz, anão idoso largo de barba branca longa, ativa Concórdia; guarda firme e nova radial dourada/prateada baixa repelem ao redor, sem halo estourado ou aparência fantasma.
- `HERO-bromnor-death` — Folha 2D isométrica de 6 quadros: Bromnor Martelo da Luz, anão idoso largo de barba branca longa, bronze e tecido azul, cai de lado sem gore; o Martelo da Glória permanece corpóreo e sua luz dourada/prateada se apaga.

## Registro de cobertura

| Grupo | Quantidade |
|---|---:|
| Heróis com prompts novos | 9 |
| Sequências por herói | 12 |
| Chamadas novas | 108 |
| Sequências de Durvall reutilizadas | 12 |
| Sequências totais do elenco | 120 |
