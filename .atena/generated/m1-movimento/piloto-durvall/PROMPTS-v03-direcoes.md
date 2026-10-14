# Piloto Durvall: direções que faltam (prompts v03 em grade)

Mesmo esquema do v03 aprovado: grade 3 colunas × 2 linhas, quadros quadrados de 512 × 512 com faixas vazias, personagem com 330 px de altura no quadro (eu reduzo depois), espada inteira dentro do quadro.

**As cinco direções são tiras de verdade, não espelhos.** Espelhar a corrida para a direita trocaria a espada de mão (o contrato de animação só aceita espelho quando a simetria for confirmada, e a espada do Durvall não é simétrica).

**Anexe em todos:** `durvall_idle.png` e `gabarito_grade_move.png` (os dois estão nesta pasta). Peça uma imagem **3:2 (1536 × 1024)**.

| Prompt | Direção | Salve como |
|---|---|---|
| **P6** | `move_n` andando para CIMA, de costas | `durvall_move_n_grade_v01.png` |
| **P7** | `move_ne` andando para CIMA e à direita, três-quartos de costas | `durvall_move_ne_grade_v01.png` |
| **P8** | `move_w` andando para a esquerda, de perfil | `durvall_move_w_grade_v01.png` |
| **P9** | `move_sw` andando para baixo e à esquerda, três-quartos de frente | `durvall_move_sw_grade_v01.png` |
| **P10** | `move_nw` andando para cima e à esquerda, três-quartos de costas | `durvall_move_nw_grade_v01.png` |

Mande **uma direção por conversa nova**. Salve em `retorno/` e diga "retornou". Se quiser testar o método antes de gastar as cinco, comece pelo **P6 (`move_n`)**, que também fecha a queixa de ver o rosto ao andar para cima.

---

## P6: `move_n`, andando para CIMA, de costas

**Anexe:** `durvall_idle.png` + `gabarito_grade_move.png`. **Salve como** `durvall_move_n_grade_v01.png`.

```
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
```

---

## P7: `move_ne`, andando para CIMA e à direita, três-quartos de costas

**Anexe:** `durvall_idle.png` + `gabarito_grade_move.png`. **Salve como** `durvall_move_ne_grade_v01.png`.

```
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
```

---

## P8: `move_w`, andando para a esquerda, de perfil

**Anexe:** `durvall_idle.png` + `gabarito_grade_move.png`. **Salve como** `durvall_move_w_grade_v01.png`.

```
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
```

---

## P9: `move_sw`, andando para baixo e à esquerda, três-quartos de frente

**Anexe:** `durvall_idle.png` + `gabarito_grade_move.png`. **Salve como** `durvall_move_sw_grade_v01.png`.

```
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
```

---

## P10: `move_nw`, andando para cima e à esquerda, três-quartos de costas

**Anexe:** `durvall_idle.png` + `gabarito_grade_move.png`. **Salve como** `durvall_move_nw_grade_v01.png`.

```
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
```

