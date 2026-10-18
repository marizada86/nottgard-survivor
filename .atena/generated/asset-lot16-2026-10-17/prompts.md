# LOT16/v01 —13prompts exatos

Built-in imagegen, uma folha por chamada. DRAFT;5fontes/30poses selecionadas.

## P10_v01

Gere UMA imagem com uma sequência de animação de personagem para jogo 2D isométrico: pintura de pixel detalhada, câmera três-quartos, luz vinda do alto à esquerda. Fundo TRANSPARENTE real (PNG com alfa). Sem cenário, sem chão, sem sombra projetada, sem texto, sem rótulos, sem desfoque de movimento.

PERSONAGEM: use a imagem "durvall_idle.png" como referência OBRIGATÓRIA de rosto, cabelo, armadura, espada, paleta, proporção e acabamento. Não redesenhe nada. É Durvall, drow de pele cinza-azulada, cabelo branco longo e solto, orelhas pontudas, armadura negra laminada com ombreiras de espinhos, faixa vinho no cinto, pendente azul no peito, botas negras e uma espada de lâmina azul-gelo luminosa na MÃO ESQUERDA do personagem (a mesma mão em todos os quadros; no idle, de frente, ela aparece do lado direito da imagem).

FORMATO: UMA imagem em GRADE com 6 quadros QUADRADOS e iguais (3 colunas por 2 linhas), lidos da esquerda para a direita e de cima para baixo (quadros 1, 2 e 3 na linha de cima; 4, 5 e 6 na linha de baixo), SEPARADOS por faixas VAZIAS e transparentes. Cada quadro é um quadrado grande, com muito espaço livre ao redor do personagem. Use "gabarito_grade_move.png" só como guia de posição: linha verde = chão onde o pé de apoio toca; linha azul = topo da cabeça; retângulo vermelho = margem de cada quadro; silhueta cinza = tamanho do personagem parado. NÃO desenhe nenhuma linha, número, faixa ou silhueta do gabarito na imagem final: as separações ficam TRANSPARENTES.

REGRA PRINCIPAL: cada quadro, com a espada, o cabelo e a capa, fica INTEIRO dentro do seu retângulo vermelho. Nada, nem a ponta da espada, pode tocar a borda do quadro, entrar na faixa de separação nem no quadro vizinho. Há bastante espaço: use-o.

DIREÇÃO: o personagem anda PARA CIMA E PARA A ESQUERDA da imagem, afastando-se da câmera e virado para a esquerda, em três-quartos de COSTAS. O rosto NÃO aparece ou aparece só um pedaço do perfil; predominam as costas. A espada fica na mão esquerda do personagem.

MEDIDAS (importante): o personagem tem sempre a MESMA altura da silhueta (do topo da cabeça à sola), em todos os quadros; nunca aumente ou diminua o corpo para animar. O pé de apoio toca sempre a linha verde. A passada é MÉDIA: nos quadros de contato os dois pés ficam afastados cerca de 40% da altura do corpo, vista pela direção em que ele anda. Entre um quadro e o seguinte a mudança de pose é PEQUENA e gradual: nada de saltos bruscos de perna ou de braço.

QUADROS (a mesma sequência de trote para todas as direções):
1) Contato: um pé à frente tocando o chão com o calcanhar, o outro atrás só com a ponta apoiada.
2) Passagem: perna de apoio sob o corpo, outra perna saindo do chão, corpo um pouco mais baixo.
3) Alto: a perna de trás vai à frente, pé curto no ar, corpo um pouco mais alto.
4) Contato: igual ao 1 com as pernas trocadas.
5) Passagem: igual ao 2 com as pernas trocadas.
6) Alto: igual ao 3 com as pernas trocadas; o quadro 6 leva suavemente de volta ao quadro 1.
Braços balançam pouco, em oposição às pernas. A espada fica na mesma mão (esquerda do personagem) em todos os quadros.

NÃO FAÇA: mudar o rosto, o cabelo, a armadura ou a cor; trocar a espada de mão; incluir símbolo, aura ou efeito que não esteja no idle; cortar a espada; deixar a espada atravessar para outro quadro; cenário; sombra no chão.

## P10_v02

Use case background-removal precise edit. Preserve the SIX Durvall sprites and their six poses, costume, correct anatomicalLEFT sword hand, direction,3x2positions, scale, sharp pixelpaint, sword shape and silhouette from input. REMOVE ALL surrounding black/gray background and diffuse gray/blue/red HAZE/HALO CLOUDS. Every pixel outside the actual hair/armor/cloth/skin/boots/sword contours must become truly transparent. No head spotlight, no glow cloud behind hair, no ambient aura behind body, no blue cloud around sword. Keep only a THIN blue luminous edge attached to the sword blade itself. Do not trim/cut sword or hair. Keep1536x1024sheet3x2six equal512cells with clear transparent gaps. Fully solid matte body, antialiasing only at contour. No new marks, guide lines, floor/shadow or text. This is a transparent cutout cleanup, not adding lighting.

## P10_v03

Create a CLEAN TRANSPARENT GAME SPRITE SHEET, NOT a painting with a background. True PNG ALPHA: every empty space between limbs, around head, around sword and between frames is ZERO ALPHA. No glow gradient, no aura, no fog, no lighting vignette, no black/gray/color backdrop, no ground/shadow, no label or line. Sword is blue icy METAL with a narrow bright edge; it casts NO ambient light and has NO surrounding cloud. Body surfaces opaque. First reference ONLY character identity, second ONLY3x2layout; do NOT reproduce any reference background. Durvall drow, bluegray skin, long loose whitehair, pointed reddish ears, black laminated spiked armor, wine sash/waist strips, blackboots, blue icy sword in anatomicalLEFT hand. THREEQUARTER BACK facing and walking NORTHWEST UP-LEFT. Mostly back and back of whitehair, no frontal chest pendant. AnatomicalLEFT sword hand is near side. 1536x1024canvas, SIX complete distinct sprites in3columns2rows, equal512cells, reading lefttoright topbottom. Bodyheight330px percell, feet baseline420px percell, heads y90. Complete sword/hair/boots inside eachcell with min40px free space. Upperleft light painted only ON surfaces, detailed darkfantasy pixelpaint. Six phases:0rightleglead contact,1leftleg passing underbody and rightlegsupport knee flex,2leftleg lifted forward shortair,3LEFTlegleadcontact with legs CLEARLY reversed versus0,4rightlegpassing and leftlegsupport,5rightlegliftforward returning0. Slight bob 5px max, restrainedhair/sashfollow, same camera, proportions, armor and hand in all6. Do not clone same leg pose six times, do not mirror/copy rightward animation. No new lore/symbol/gear.

## P6_v01

Gere UMA imagem com uma sequência de animação de personagem para jogo 2D isométrico: pintura de pixel detalhada, câmera três-quartos, luz vinda do alto à esquerda. Fundo TRANSPARENTE real (PNG com alfa). Sem cenário, sem chão, sem sombra projetada, sem texto, sem rótulos, sem desfoque de movimento.

PERSONAGEM: use a imagem "durvall_idle.png" como referência OBRIGATÓRIA de rosto, cabelo, armadura, espada, paleta, proporção e acabamento. Não redesenhe nada. É Durvall, drow de pele cinza-azulada, cabelo branco longo e solto, orelhas pontudas, armadura negra laminada com ombreiras de espinhos, faixa vinho no cinto, pendente azul no peito, botas negras e uma espada de lâmina azul-gelo luminosa na MÃO ESQUERDA do personagem (a mesma mão em todos os quadros; no idle, de frente, ela aparece do lado direito da imagem).

FORMATO: UMA imagem em GRADE com 6 quadros QUADRADOS e iguais (3 colunas por 2 linhas), lidos da esquerda para a direita e de cima para baixo (quadros 1, 2 e 3 na linha de cima; 4, 5 e 6 na linha de baixo), SEPARADOS por faixas VAZIAS e transparentes. Cada quadro é um quadrado grande, com muito espaço livre ao redor do personagem. Use "gabarito_grade_move.png" só como guia de posição: linha verde = chão onde o pé de apoio toca; linha azul = topo da cabeça; retângulo vermelho = margem de cada quadro; silhueta cinza = tamanho do personagem parado. NÃO desenhe nenhuma linha, número, faixa ou silhueta do gabarito na imagem final: as separações ficam TRANSPARENTES.

REGRA PRINCIPAL: cada quadro, com a espada, o cabelo e a capa, fica INTEIRO dentro do seu retângulo vermelho. Nada, nem a ponta da espada, pode tocar a borda do quadro, entrar na faixa de separação nem no quadro vizinho. Há bastante espaço: use-o.

DIREÇÃO: o personagem anda PARA CIMA da imagem, afastando-se da câmera, visto DE COSTAS. O rosto NÃO aparece: vê-se a nuca, o cabelo caindo nas costas, as costas da armadura e a capa. A espada, na mão esquerda do personagem, aparece do lado ESQUERDO da imagem.

MEDIDAS (importante): o personagem tem sempre a MESMA altura da silhueta (do topo da cabeça à sola), em todos os quadros; nunca aumente ou diminua o corpo para animar. O pé de apoio toca sempre a linha verde. A passada é MÉDIA: nos quadros de contato os dois pés ficam afastados cerca de 40% da altura do corpo, vista pela direção em que ele anda. Entre um quadro e o seguinte a mudança de pose é PEQUENA e gradual: nada de saltos bruscos de perna ou de braço.

QUADROS (a mesma sequência de trote para todas as direções):
1) Contato: um pé à frente tocando o chão com o calcanhar, o outro atrás só com a ponta apoiada.
2) Passagem: perna de apoio sob o corpo, outra perna saindo do chão, corpo um pouco mais baixo.
3) Alto: a perna de trás vai à frente, pé curto no ar, corpo um pouco mais alto.
4) Contato: igual ao 1 com as pernas trocadas.
5) Passagem: igual ao 2 com as pernas trocadas.
6) Alto: igual ao 3 com as pernas trocadas; o quadro 6 leva suavemente de volta ao quadro 1.
Braços balançam pouco, em oposição às pernas. A espada fica na mesma mão (esquerda do personagem) em todos os quadros.

NÃO FAÇA: mudar o rosto, o cabelo, a armadura ou a cor; trocar a espada de mão; incluir símbolo, aura ou efeito que não esteja no idle; cortar a espada; deixar a espada atravessar para outro quadro; cenário; sombra no chão.

## P6_v02

Use case background-removal precise edit. Preserve the SIX Durvall sprites and their six poses, costume, correct anatomicalLEFT sword hand, direction,3x2positions, scale, sharp pixelpaint, sword shape and silhouette from input. REMOVE ALL surrounding black/gray background and diffuse gray/blue/red HAZE/HALO CLOUDS. Every pixel outside the actual hair/armor/cloth/skin/boots/sword contours must become truly transparent. No head spotlight, no glow cloud behind hair, no ambient aura behind body, no blue cloud around sword. Keep only a THIN blue luminous edge attached to the sword blade itself. Do not trim/cut sword or hair. Keep1536x1024sheet3x2six equal512cells with clear transparent gaps. Fully solid matte body, antialiasing only at contour. No new marks, guide lines, floor/shadow or text. This is a transparent cutout cleanup, not adding lighting.

## P6_v03

Create a CLEAN TRANSPARENT GAME SPRITE SHEET, NOT a painting with a background. True PNG ALPHA: every empty space between limbs, around head, around sword and between frames is ZERO ALPHA. No glow gradient, no aura, no fog, no lighting vignette, no black/gray/color backdrop, no ground/shadow, no label or line. Sword is blue icy METAL with a narrow bright edge; it casts NO ambient light and has NO surrounding cloud. Body surfaces opaque. First reference ONLY character identity, second ONLY3x2layout; do NOT reproduce any reference background. Durvall drow, bluegray skin, long loose whitehair, pointed reddish ears, black laminated spiked armor, wine sash/waist strips, blackboots, blue icy sword in anatomicalLEFT hand. Full BACK view, walking NORTH UP away. No face/chest pendant. Anatomical LEFT sword hand is SCREEN LEFT. 1536x1024canvas, SIX complete distinct sprites in3columns2rows, equal512cells, reading lefttoright topbottom. Bodyheight330px percell, feet baseline420px percell, heads y90. Complete sword/hair/boots inside eachcell with min40px free space. Upperleft light painted only ON surfaces, detailed darkfantasy pixelpaint. Six phases:0rightleglead contact,1leftleg passing underbody and rightlegsupport knee flex,2leftleg lifted forward shortair,3LEFTlegleadcontact with legs CLEARLY reversed versus0,4rightlegpassing and leftlegsupport,5rightlegliftforward returning0. Slight bob 5px max, restrainedhair/sashfollow, same camera, proportions, armor and hand in all6. Do not clone same leg pose six times, do not mirror/copy rightward animation. No new lore/symbol/gear.

## P7_v01

Gere UMA imagem com uma sequência de animação de personagem para jogo 2D isométrico: pintura de pixel detalhada, câmera três-quartos, luz vinda do alto à esquerda. Fundo TRANSPARENTE real (PNG com alfa). Sem cenário, sem chão, sem sombra projetada, sem texto, sem rótulos, sem desfoque de movimento.

PERSONAGEM: use a imagem "durvall_idle.png" como referência OBRIGATÓRIA de rosto, cabelo, armadura, espada, paleta, proporção e acabamento. Não redesenhe nada. É Durvall, drow de pele cinza-azulada, cabelo branco longo e solto, orelhas pontudas, armadura negra laminada com ombreiras de espinhos, faixa vinho no cinto, pendente azul no peito, botas negras e uma espada de lâmina azul-gelo luminosa na MÃO ESQUERDA do personagem (a mesma mão em todos os quadros; no idle, de frente, ela aparece do lado direito da imagem).

FORMATO: UMA imagem em GRADE com 6 quadros QUADRADOS e iguais (3 colunas por 2 linhas), lidos da esquerda para a direita e de cima para baixo (quadros 1, 2 e 3 na linha de cima; 4, 5 e 6 na linha de baixo), SEPARADOS por faixas VAZIAS e transparentes. Cada quadro é um quadrado grande, com muito espaço livre ao redor do personagem. Use "gabarito_grade_move.png" só como guia de posição: linha verde = chão onde o pé de apoio toca; linha azul = topo da cabeça; retângulo vermelho = margem de cada quadro; silhueta cinza = tamanho do personagem parado. NÃO desenhe nenhuma linha, número, faixa ou silhueta do gabarito na imagem final: as separações ficam TRANSPARENTES.

REGRA PRINCIPAL: cada quadro, com a espada, o cabelo e a capa, fica INTEIRO dentro do seu retângulo vermelho. Nada, nem a ponta da espada, pode tocar a borda do quadro, entrar na faixa de separação nem no quadro vizinho. Há bastante espaço: use-o.

DIREÇÃO: o personagem anda PARA CIMA E PARA A DIREITA da imagem, afastando-se da câmera e virado para a direita, em três-quartos de COSTAS. O rosto NÃO aparece ou aparece só um pedaço do perfil da bochecha; predominam as costas. A espada fica na mão esquerda do personagem.

MEDIDAS (importante): o personagem tem sempre a MESMA altura da silhueta (do topo da cabeça à sola), em todos os quadros; nunca aumente ou diminua o corpo para animar. O pé de apoio toca sempre a linha verde. A passada é MÉDIA: nos quadros de contato os dois pés ficam afastados cerca de 40% da altura do corpo, vista pela direção em que ele anda. Entre um quadro e o seguinte a mudança de pose é PEQUENA e gradual: nada de saltos bruscos de perna ou de braço.

QUADROS (a mesma sequência de trote para todas as direções):
1) Contato: um pé à frente tocando o chão com o calcanhar, o outro atrás só com a ponta apoiada.
2) Passagem: perna de apoio sob o corpo, outra perna saindo do chão, corpo um pouco mais baixo.
3) Alto: a perna de trás vai à frente, pé curto no ar, corpo um pouco mais alto.
4) Contato: igual ao 1 com as pernas trocadas.
5) Passagem: igual ao 2 com as pernas trocadas.
6) Alto: igual ao 3 com as pernas trocadas; o quadro 6 leva suavemente de volta ao quadro 1.
Braços balançam pouco, em oposição às pernas. A espada fica na mesma mão (esquerda do personagem) em todos os quadros.

NÃO FAÇA: mudar o rosto, o cabelo, a armadura ou a cor; trocar a espada de mão; incluir símbolo, aura ou efeito que não esteja no idle; cortar a espada; deixar a espada atravessar para outro quadro; cenário; sombra no chão.

## P7_v02

Use case background-removal precise edit. Preserve the SIX Durvall sprites and their six poses, costume, correct anatomicalLEFT sword hand, direction,3x2positions, scale, sharp pixelpaint, sword shape and silhouette from input. REMOVE ALL surrounding black/gray background and diffuse gray/blue/red HAZE/HALO CLOUDS. Every pixel outside the actual hair/armor/cloth/skin/boots/sword contours must become truly transparent. No head spotlight, no glow cloud behind hair, no ambient aura behind body, no blue cloud around sword. Keep only a THIN blue luminous edge attached to the sword blade itself. Do not trim/cut sword or hair. Keep1536x1024sheet3x2six equal512cells with clear transparent gaps. Fully solid matte body, antialiasing only at contour. No new marks, guide lines, floor/shadow or text. This is a transparent cutout cleanup, not adding lighting.

## P7_v03

Create a CLEAN TRANSPARENT GAME SPRITE SHEET, NOT a painting with a background. True PNG ALPHA: every empty space between limbs, around head, around sword and between frames is ZERO ALPHA. No glow gradient, no aura, no fog, no lighting vignette, no black/gray/color backdrop, no ground/shadow, no label or line. Sword is blue icy METAL with a narrow bright edge; it casts NO ambient light and has NO surrounding cloud. Body surfaces opaque. First reference ONLY character identity, second ONLY3x2layout; do NOT reproduce any reference background. Durvall drow, bluegray skin, long loose whitehair, pointed reddish ears, black laminated spiked armor, wine sash/waist strips, blackboots, blue icy sword in anatomicalLEFT hand. THREEQUARTER BACK facing and walking NORTHEAST UP-RIGHT. Mostly back and back of white hair, no frontal chest pendant, at most tiny cheek profile. AnatomicalLEFT sword hand remains left, not mirror. 1536x1024canvas, SIX complete distinct sprites in3columns2rows, equal512cells, reading lefttoright topbottom. Bodyheight330px percell, feet baseline420px percell, heads y90. Complete sword/hair/boots inside eachcell with min40px free space. Upperleft light painted only ON surfaces, detailed darkfantasy pixelpaint. Six phases:0rightleglead contact,1leftleg passing underbody and rightlegsupport knee flex,2leftleg lifted forward shortair,3LEFTlegleadcontact with legs CLEARLY reversed versus0,4rightlegpassing and leftlegsupport,5rightlegliftforward returning0. Slight bob 5px max, restrainedhair/sashfollow, same camera, proportions, armor and hand in all6. Do not clone same leg pose six times, do not mirror/copy rightward animation. No new lore/symbol/gear.

## P8_v01

Gere UMA imagem com uma sequência de animação de personagem para jogo 2D isométrico: pintura de pixel detalhada, câmera três-quartos, luz vinda do alto à esquerda. Fundo TRANSPARENTE real (PNG com alfa). Sem cenário, sem chão, sem sombra projetada, sem texto, sem rótulos, sem desfoque de movimento.

PERSONAGEM: use a imagem "durvall_idle.png" como referência OBRIGATÓRIA de rosto, cabelo, armadura, espada, paleta, proporção e acabamento. Não redesenhe nada. É Durvall, drow de pele cinza-azulada, cabelo branco longo e solto, orelhas pontudas, armadura negra laminada com ombreiras de espinhos, faixa vinho no cinto, pendente azul no peito, botas negras e uma espada de lâmina azul-gelo luminosa na MÃO ESQUERDA do personagem (a mesma mão em todos os quadros; no idle, de frente, ela aparece do lado direito da imagem).

FORMATO: UMA imagem em GRADE com 6 quadros QUADRADOS e iguais (3 colunas por 2 linhas), lidos da esquerda para a direita e de cima para baixo (quadros 1, 2 e 3 na linha de cima; 4, 5 e 6 na linha de baixo), SEPARADOS por faixas VAZIAS e transparentes. Cada quadro é um quadrado grande, com muito espaço livre ao redor do personagem. Use "gabarito_grade_move.png" só como guia de posição: linha verde = chão onde o pé de apoio toca; linha azul = topo da cabeça; retângulo vermelho = margem de cada quadro; silhueta cinza = tamanho do personagem parado. NÃO desenhe nenhuma linha, número, faixa ou silhueta do gabarito na imagem final: as separações ficam TRANSPARENTES.

REGRA PRINCIPAL: cada quadro, com a espada, o cabelo e a capa, fica INTEIRO dentro do seu retângulo vermelho. Nada, nem a ponta da espada, pode tocar a borda do quadro, entrar na faixa de separação nem no quadro vizinho. Há bastante espaço: use-o.

DIREÇÃO: o personagem anda para a ESQUERDA da imagem, de perfil. Ele está virado para a esquerda; a mão esquerda dele, com a espada, fica do lado da câmera (a espada aparece à frente do corpo). NÃO é um espelho da corrida para a direita: o personagem continua com a espada na mesma mão.

MEDIDAS (importante): o personagem tem sempre a MESMA altura da silhueta (do topo da cabeça à sola), em todos os quadros; nunca aumente ou diminua o corpo para animar. O pé de apoio toca sempre a linha verde. A passada é MÉDIA: nos quadros de contato os dois pés ficam afastados cerca de 40% da altura do corpo, vista pela direção em que ele anda. Entre um quadro e o seguinte a mudança de pose é PEQUENA e gradual: nada de saltos bruscos de perna ou de braço.

QUADROS (a mesma sequência de trote para todas as direções):
1) Contato: um pé à frente tocando o chão com o calcanhar, o outro atrás só com a ponta apoiada.
2) Passagem: perna de apoio sob o corpo, outra perna saindo do chão, corpo um pouco mais baixo.
3) Alto: a perna de trás vai à frente, pé curto no ar, corpo um pouco mais alto.
4) Contato: igual ao 1 com as pernas trocadas.
5) Passagem: igual ao 2 com as pernas trocadas.
6) Alto: igual ao 3 com as pernas trocadas; o quadro 6 leva suavemente de volta ao quadro 1.
Braços balançam pouco, em oposição às pernas. A espada fica na mesma mão (esquerda do personagem) em todos os quadros.

NÃO FAÇA: mudar o rosto, o cabelo, a armadura ou a cor; trocar a espada de mão; incluir símbolo, aura ou efeito que não esteja no idle; cortar a espada; deixar a espada atravessar para outro quadro; cenário; sombra no chão.

## P9_v01

Gere UMA imagem com uma sequência de animação de personagem para jogo 2D isométrico: pintura de pixel detalhada, câmera três-quartos, luz vinda do alto à esquerda. Fundo TRANSPARENTE real (PNG com alfa). Sem cenário, sem chão, sem sombra projetada, sem texto, sem rótulos, sem desfoque de movimento.

PERSONAGEM: use a imagem "durvall_idle.png" como referência OBRIGATÓRIA de rosto, cabelo, armadura, espada, paleta, proporção e acabamento. Não redesenhe nada. É Durvall, drow de pele cinza-azulada, cabelo branco longo e solto, orelhas pontudas, armadura negra laminada com ombreiras de espinhos, faixa vinho no cinto, pendente azul no peito, botas negras e uma espada de lâmina azul-gelo luminosa na MÃO ESQUERDA do personagem (a mesma mão em todos os quadros; no idle, de frente, ela aparece do lado direito da imagem).

FORMATO: UMA imagem em GRADE com 6 quadros QUADRADOS e iguais (3 colunas por 2 linhas), lidos da esquerda para a direita e de cima para baixo (quadros 1, 2 e 3 na linha de cima; 4, 5 e 6 na linha de baixo), SEPARADOS por faixas VAZIAS e transparentes. Cada quadro é um quadrado grande, com muito espaço livre ao redor do personagem. Use "gabarito_grade_move.png" só como guia de posição: linha verde = chão onde o pé de apoio toca; linha azul = topo da cabeça; retângulo vermelho = margem de cada quadro; silhueta cinza = tamanho do personagem parado. NÃO desenhe nenhuma linha, número, faixa ou silhueta do gabarito na imagem final: as separações ficam TRANSPARENTES.

REGRA PRINCIPAL: cada quadro, com a espada, o cabelo e a capa, fica INTEIRO dentro do seu retângulo vermelho. Nada, nem a ponta da espada, pode tocar a borda do quadro, entrar na faixa de separação nem no quadro vizinho. Há bastante espaço: use-o.

DIREÇÃO: o personagem anda PARA BAIXO E PARA A ESQUERDA da imagem (vem em direção à câmera, virado para a esquerda), em três-quartos de frente. Rosto visível em três-quartos. A espada fica na mão esquerda do personagem.

MEDIDAS (importante): o personagem tem sempre a MESMA altura da silhueta (do topo da cabeça à sola), em todos os quadros; nunca aumente ou diminua o corpo para animar. O pé de apoio toca sempre a linha verde. A passada é MÉDIA: nos quadros de contato os dois pés ficam afastados cerca de 40% da altura do corpo, vista pela direção em que ele anda. Entre um quadro e o seguinte a mudança de pose é PEQUENA e gradual: nada de saltos bruscos de perna ou de braço.

QUADROS (a mesma sequência de trote para todas as direções):
1) Contato: um pé à frente tocando o chão com o calcanhar, o outro atrás só com a ponta apoiada.
2) Passagem: perna de apoio sob o corpo, outra perna saindo do chão, corpo um pouco mais baixo.
3) Alto: a perna de trás vai à frente, pé curto no ar, corpo um pouco mais alto.
4) Contato: igual ao 1 com as pernas trocadas.
5) Passagem: igual ao 2 com as pernas trocadas.
6) Alto: igual ao 3 com as pernas trocadas; o quadro 6 leva suavemente de volta ao quadro 1.
Braços balançam pouco, em oposição às pernas. A espada fica na mesma mão (esquerda do personagem) em todos os quadros.

NÃO FAÇA: mudar o rosto, o cabelo, a armadura ou a cor; trocar a espada de mão; incluir símbolo, aura ou efeito que não esteja no idle; cortar a espada; deixar a espada atravessar para outro quadro; cenário; sombra no chão.

## P9_v02

Use case stylized game sprite sheet, 1536x1024 transparent PNG. Durvall drow identity from FIRST image; SECOND is only layout guide, omit all guide lines/numbers/background. Six whole sprites in3columns2rows, each fitting a512square, bodyheight330px and footline420px in each cell. All six face SOUTHWEST: walk diagonally TOWARD VIEWER AND SCREEN LEFT, threequarter FRONT view, nose points SCREEN LEFT, face on LEFT SIDE of head. Torso and toes orient lowerleft, NOT lower-right. White long hair behind toward screen RIGHT, black laminated spiked armor, dark wine sash, blue pendant on FRONT chest only. Icy-blue sword held in anatomical LEFT hand, which is the NEAR CAMERA hand for this facing, sword hilt and blade at screenLEFT/front of torso, point diagonally downleft. Do not mirror a rightward sprite. Six distinct medium trot phases:0contact,1passing/recoil,2raised passing,3OPPOSITEcontact with legs reversed,4oppositepassing,5raised return. Body proportions and scale stable, mediumstride40%bodyheight, complete boots and complete sword in all6cells. Matte solid character, completely transparent empty exterior and gaps; NO gray haze behind hair, NO diffuse blue/red aura, NO bloom cloud, NO spotlight, NO backdrop or ground. Sword blade may have narrow blue edging only. Pixel-painted darkfantasy, upperleft light asreference, no new costume/lore, no text.

## P9_v03

Create a CLEAN TRANSPARENT GAME SPRITE SHEET, NOT a painting with a background. True PNG ALPHA: every empty space between limbs, around head, around sword and between frames is ZERO ALPHA. No glow gradient, no aura, no fog, no lighting vignette, no black/gray/color backdrop, no ground/shadow, no label or line. Sword is blue icy METAL with a narrow bright edge; it casts NO ambient light and has NO surrounding cloud. Body surfaces opaque. First reference ONLY character identity, second ONLY3x2layout; do NOT reproduce any reference background. Durvall drow, bluegray skin, long loose whitehair, pointed reddish ears, black laminated spiked armor, wine sash/waist strips, blackboots, blue icy sword in anatomicalLEFT hand. THREEQUARTER FRONT facing and walking SOUTHWEST DOWN-LEFT toward viewer. Nose and toes point SCREENLEFT. Anatomical LEFT arm is on SCREEN RIGHT side of the FRONT chest and holds sword across the front toward lowerleft; keep hand itself on viewer's RIGHT side, sword blade crosses low in front. Other hand empty. Blue pendant on chest. 1536x1024canvas, SIX complete distinct sprites in3columns2rows, equal512cells, reading lefttoright topbottom. Bodyheight330px percell, feet baseline420px percell, heads y90. Complete sword/hair/boots inside eachcell with min40px free space. Upperleft light painted only ON surfaces, detailed darkfantasy pixelpaint. Six phases:0rightleglead contact,1leftleg passing underbody and rightlegsupport knee flex,2leftleg lifted forward shortair,3LEFTlegleadcontact with legs CLEARLY reversed versus0,4rightlegpassing and leftlegsupport,5rightlegliftforward returning0. Slight bob 5px max, restrainedhair/sashfollow, same camera, proportions, armor and hand in all6. Do not clone same leg pose six times, do not mirror/copy rightward animation. No new lore/symbol/gear.
