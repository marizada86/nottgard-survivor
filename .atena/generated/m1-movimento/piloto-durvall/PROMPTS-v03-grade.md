# Piloto Durvall: prompts v03 em GRADE (espada inteira, sem corte)

**Por que existe:** a espada continua cortada porque o gerador devolve os quadros em uma faixa estreita e a ponta sai da imagem. Medi nas fontes: no `move_e` v02 há 51 pixels opacos tocando a borda direita da imagem, no `move_s` v01 há 62 e no `move_se` v01 há 11. **Isso é corte do próprio gerador, não do recorte**, e nenhuma ferramenta recupera pixel que não foi desenhado.

**O que muda:** os quadros passam a ser **quadrados grandes** (512 × 512 no gabarito) em **grade** (3 colunas × 2 linhas; o ataque, 2 × 2), com faixas vazias entre eles e muito espaço em volta. O personagem aparece maior no quadro (corpo de 330 px de altura em vez de 231) para o gerador capricharem no detalhe; eu reduzo depois, sem repintar.

**Como usar:** conversa nova para cada prompt, anexe os 2 arquivos indicados, cole o texto, salve o PNG em `retorno/` com o nome indicado e diga "retornou". Os gabaritos estão nesta pasta.

**Tamanho da imagem:** peça ao GPT uma imagem **3:2 (por exemplo 1536 × 1024)** para os de 6 quadros e **quadrada (1024 × 1024)** para o ataque. Se ele devolver outra proporção, tudo bem: eu normalizo.

| Prompt | Anexe | Salve como |
|---|---|---|
| **P1 v03** `move_e`: andando para a direita, de perfil | `durvall_idle.png` + `gabarito_grade_move_e.png` | `durvall_move_e_grade_v01.png` |
| **P2 v03** `move_se`: andando para baixo e à direita | `durvall_idle.png` + `gabarito_grade_move.png` | `durvall_move_se_grade_v01.png` |
| **P3 v03** `move_s`: andando para baixo, de frente | `durvall_idle.png` + `gabarito_grade_move.png` | `durvall_move_s_grade_v01.png` |
| **P4 v03** `attack`: golpe de espada para a direita | `durvall_idle.png` + `gabarito_grade_attack.png` | `durvall_attack_grade_v01.png` |

---

## P1 v03: `move_e`: andando para a direita, de perfil

**Anexe:** `durvall_idle.png` + `gabarito_grade_move_e.png`. **Salve como** `durvall_move_e_grade_v01.png`.

```
Gere UMA imagem com uma sequência de animação de personagem para jogo 2D isométrico: pintura de pixel detalhada, câmera três-quartos, luz vinda do alto à esquerda. Fundo TRANSPARENTE real (PNG com alfa). Sem cenário, sem chão, sem sombra projetada, sem texto, sem rótulos, sem desfoque de movimento.

PERSONAGEM: use a imagem "durvall_idle.png" como referência OBRIGATÓRIA de rosto, cabelo, armadura, espada, paleta, proporção e acabamento. Não redesenhe nada. É Durvall, drow de pele cinza-azulada, cabelo branco longo e solto, orelhas pontudas, armadura negra laminada com ombreiras de espinhos, faixa vinho no cinto, pendente azul no peito, botas negras e uma espada de lâmina azul-gelo luminosa na MÃO ESQUERDA (a mesma mão em todos os quadros).

FORMATO: UMA imagem em GRADE com 6 quadros QUADRADOS e iguais (3 colunas por 2 linhas), lidos da esquerda para a direita e de cima para baixo (quadros 1, 2 e 3 na linha de cima; 4, 5 e 6 na linha de baixo), SEPARADOS por faixas VAZIAS e transparentes. Cada quadro é um quadrado grande, com muito espaço livre ao redor do personagem. Use "gabarito_grade_move_e.png" só como guia de posição: linha verde = chão onde o pé de apoio toca; linha azul = topo da cabeça; retângulo vermelho = margem de cada quadro; silhueta cinza = tamanho do personagem parado; cruzes rosa nos quadros 1 e 4 = onde os pés caem. NÃO desenhe nenhuma linha, número, faixa ou silhueta do gabarito na imagem final: as separações ficam TRANSPARENTES.

REGRA PRINCIPAL: cada quadro, com a espada, o cabelo e a capa, fica INTEIRO dentro do seu retângulo vermelho. Nada, nem a ponta da espada, pode tocar a borda do quadro, entrar na faixa de separação nem no quadro vizinho. Há bastante espaço: use-o.

DIREÇÃO: o personagem anda para a DIREITA da imagem, de perfil, em um trote firme e natural, tronco quase ereto (no máximo levemente inclinado para a frente).

MEDIDAS (importante): o personagem tem sempre a MESMA altura da silhueta (do topo da cabeça à sola), em todos os quadros; nunca aumente ou diminua o corpo para animar. O pé de apoio toca sempre a linha verde. A passada é MÉDIA, não longa: nos quadros 1 e 4 os dois pés ficam afastados cerca de 40% da altura do corpo (as cruzes rosa). Entre um quadro e o seguinte a mudança de pose é PEQUENA e gradual: nada de saltos bruscos de perna ou de braço.

QUADROS:
1) Contato: pé direito (da frente) tocando com o calcanhar, pé esquerdo atrás com a ponta apoiada.
2) Passagem: perna de apoio sob o corpo, outra perna saindo do chão, corpo um pouco mais baixo.
3) Alto: a perna de trás vai à frente, pé curto no ar, corpo um pouco mais alto.
4) Contato: igual ao 1 com as pernas trocadas (pé esquerdo à frente).
5) Passagem: igual ao 2 com as pernas trocadas.
6) Alto: igual ao 3 com as pernas trocadas; o quadro 6 leva suavemente de volta ao quadro 1.
Braços balançam pouco, em oposição às pernas. A espada fica na mesma mão em todos os quadros.

NÃO FAÇA: mudar o rosto, o cabelo, a armadura ou a cor; trocar a espada de mão; incluir símbolo, aura ou efeito que não esteja no idle; cortar a espada; deixar a espada atravessar para outro quadro; cenário; sombra no chão.
```

---

## P2 v03: `move_se`: andando para baixo e à direita

**Anexe:** `durvall_idle.png` + `gabarito_grade_move.png`. **Salve como** `durvall_move_se_grade_v01.png`.

```
Gere UMA imagem com uma sequência de animação de personagem para jogo 2D isométrico: pintura de pixel detalhada, câmera três-quartos, luz vinda do alto à esquerda. Fundo TRANSPARENTE real (PNG com alfa). Sem cenário, sem chão, sem sombra projetada, sem texto, sem rótulos, sem desfoque de movimento.

PERSONAGEM: use a imagem "durvall_idle.png" como referência OBRIGATÓRIA de rosto, cabelo, armadura, espada, paleta, proporção e acabamento. Não redesenhe nada. É Durvall, drow de pele cinza-azulada, cabelo branco longo e solto, orelhas pontudas, armadura negra laminada com ombreiras de espinhos, faixa vinho no cinto, pendente azul no peito, botas negras e uma espada de lâmina azul-gelo luminosa na MÃO ESQUERDA (a mesma mão em todos os quadros).

FORMATO: UMA imagem em GRADE com 6 quadros QUADRADOS e iguais (3 colunas por 2 linhas), lidos da esquerda para a direita e de cima para baixo (quadros 1, 2 e 3 na linha de cima; 4, 5 e 6 na linha de baixo), SEPARADOS por faixas VAZIAS e transparentes. Cada quadro é um quadrado grande, com muito espaço livre ao redor do personagem. Use "gabarito_grade_move.png" só como guia de posição: linha verde = chão onde o pé de apoio toca; linha azul = topo da cabeça; retângulo vermelho = margem de cada quadro; silhueta cinza = tamanho do personagem parado. NÃO desenhe nenhuma linha, número, faixa ou silhueta do gabarito na imagem final: as separações ficam TRANSPARENTES.

REGRA PRINCIPAL: cada quadro, com a espada, o cabelo e a capa, fica INTEIRO dentro do seu retângulo vermelho. Nada, nem a ponta da espada, pode tocar a borda do quadro, entrar na faixa de separação nem no quadro vizinho. Há bastante espaço: use-o.

DIREÇÃO: o personagem anda para BAIXO E PARA A DIREITA da imagem (vem em direção à câmera, virado para a direita), em três-quartos de frente, em um trote firme e natural. Rosto visível em três-quartos.

MEDIDAS (importante): o personagem tem sempre a MESMA altura da silhueta (do topo da cabeça à sola), em todos os quadros; nunca aumente ou diminua o corpo para animar. O pé de apoio toca sempre a linha verde. A passada é MÉDIA: nos quadros de contato os dois pés ficam bem afastados, o da frente mais baixo e mais à direita na imagem. Entre um quadro e o seguinte a mudança de pose é PEQUENA e gradual: nada de saltos bruscos de perna ou de braço.

QUADROS:
1) Contato: pé direito à frente (mais baixo na imagem) tocando com o calcanhar, pé esquerdo atrás só com a ponta apoiada.
2) Passagem: corpo no ponto mais baixo, perna de apoio sob o corpo, outra saindo do chão.
3) Alto: perna de trás vai à frente, corpo um pouco mais alto.
4) Contato: igual ao 1 com as pernas trocadas (pé esquerdo à frente).
5) Passagem: igual ao 2 com as pernas trocadas.
6) Alto: igual ao 3 com as pernas trocadas; o quadro 6 volta suavemente ao 1.
Braços balançam pouco, em oposição às pernas. A espada fica na mesma mão em todos os quadros.

NÃO FAÇA: mudar o rosto, o cabelo, a armadura ou a cor; trocar a espada de mão; incluir símbolo, aura ou efeito que não esteja no idle; cortar a espada; deixar a espada atravessar para outro quadro; cenário; sombra no chão.
```

---

## P3 v03: `move_s`: andando para baixo, de frente

**Anexe:** `durvall_idle.png` + `gabarito_grade_move.png`. **Salve como** `durvall_move_s_grade_v01.png`.

```
Gere UMA imagem com uma sequência de animação de personagem para jogo 2D isométrico: pintura de pixel detalhada, câmera três-quartos, luz vinda do alto à esquerda. Fundo TRANSPARENTE real (PNG com alfa). Sem cenário, sem chão, sem sombra projetada, sem texto, sem rótulos, sem desfoque de movimento.

PERSONAGEM: use a imagem "durvall_idle.png" como referência OBRIGATÓRIA de rosto, cabelo, armadura, espada, paleta, proporção e acabamento. Não redesenhe nada. É Durvall, drow de pele cinza-azulada, cabelo branco longo e solto, orelhas pontudas, armadura negra laminada com ombreiras de espinhos, faixa vinho no cinto, pendente azul no peito, botas negras e uma espada de lâmina azul-gelo luminosa na MÃO ESQUERDA (a mesma mão em todos os quadros; no idle ela aparece do lado direito da imagem).

FORMATO: UMA imagem em GRADE com 6 quadros QUADRADOS e iguais (3 colunas por 2 linhas), lidos da esquerda para a direita e de cima para baixo (quadros 1, 2 e 3 na linha de cima; 4, 5 e 6 na linha de baixo), SEPARADOS por faixas VAZIAS e transparentes. Cada quadro é um quadrado grande, com muito espaço livre ao redor do personagem. Use "gabarito_grade_move.png" só como guia de posição: linha verde = chão onde o pé de apoio toca; linha azul = topo da cabeça; retângulo vermelho = margem de cada quadro; silhueta cinza = tamanho do personagem parado. NÃO desenhe nenhuma linha, número, faixa ou silhueta do gabarito na imagem final: as separações ficam TRANSPARENTES.

REGRA PRINCIPAL: cada quadro, com a espada, o cabelo e a capa, fica INTEIRO dentro do seu retângulo vermelho. Nada, nem a ponta da espada, pode tocar a borda do quadro, entrar na faixa de separação nem no quadro vizinho. Há bastante espaço: use-o.

DIREÇÃO: o personagem anda PARA BAIXO da imagem, vindo direto em direção à câmera, de frente, em um trote firme e natural.

MEDIDAS (importante): o personagem tem sempre a MESMA altura da silhueta (do topo da cabeça à sola), em todos os quadros; nunca aumente ou diminua o corpo para animar. O pé de apoio toca sempre a linha verde. A passada é MÉDIA: nos quadros de contato um pé está claramente à frente do outro, o da frente mais baixo na imagem, com a perna de trás encurtada pela perspectiva. Entre um quadro e o seguinte a mudança de pose é PEQUENA e gradual: nada de saltos bruscos de perna ou de braço.

QUADROS:
1) Contato: pé direito à frente (mais baixo na imagem), calcanhar tocando; pé esquerdo atrás, só a ponta apoiada.
2) Passagem: corpo um pouco mais baixo, pernas cruzando sob o corpo.
3) Alto: a perna de trás vai à frente, corpo um pouco mais alto.
4) Contato: igual ao 1 com as pernas trocadas (pé esquerdo à frente).
5) Passagem: igual ao 2 com as pernas trocadas.
6) Alto: igual ao 3 com as pernas trocadas; o quadro 6 volta suavemente ao 1.
Braços balançam pouco, em oposição às pernas. A espada fica na mesma mão em todos os quadros.

NÃO FAÇA: mudar o rosto, o cabelo, a armadura ou a cor; trocar a espada de mão; incluir símbolo, aura ou efeito que não esteja no idle; cortar a espada; deixar a espada atravessar para outro quadro; cenário; sombra no chão.
```

---

## P4 v03: `attack`: golpe de espada para a direita

**Anexe:** `durvall_idle.png` + `gabarito_grade_attack.png`. **Salve como** `durvall_attack_grade_v01.png`.

```
Gere UMA imagem com uma sequência de animação de ataque para jogo 2D isométrico: pintura de pixel detalhada, câmera três-quartos, luz vinda do alto à esquerda. Fundo TRANSPARENTE real (PNG com alfa). Sem cenário, sem chão, sem sombra projetada, sem texto, sem rótulos, sem desfoque de movimento.

PERSONAGEM: use a imagem "durvall_idle.png" como referência OBRIGATÓRIA de rosto, cabelo, armadura, espada, paleta, proporção e acabamento. Não redesenhe nada. É Durvall, drow de pele cinza-azulada, cabelo branco longo e solto, orelhas pontudas, armadura negra laminada com ombreiras de espinhos, faixa vinho no cinto, pendente azul no peito, botas negras e uma espada de lâmina azul-gelo luminosa na MÃO ESQUERDA (a mesma mão em todos os quadros).

FORMATO: UMA imagem em GRADE com 4 quadros QUADRADOS e iguais (2 colunas por 2 linhas), lidos da esquerda para a direita e de cima para baixo (quadros 1 e 2 na linha de cima; 3 e 4 na linha de baixo), SEPARADOS por faixas VAZIAS e transparentes. Cada quadro é um quadrado grande, com muito espaço livre ao redor do personagem. Use "gabarito_grade_attack.png" só como guia de posição: linha verde = chão onde o pé de apoio toca; linha azul = topo da cabeça; retângulo vermelho = margem de cada quadro; silhueta cinza = tamanho do personagem parado. NÃO desenhe nenhuma linha, número, faixa ou silhueta do gabarito na imagem final: as separações ficam TRANSPARENTES.

REGRA PRINCIPAL: cada quadro, com a espada, o cabelo e a capa, fica INTEIRO dentro do seu retângulo vermelho. Nada, nem a ponta da espada, pode tocar a borda do quadro, entrar na faixa de separação nem no quadro vizinho. Há bastante espaço: use-o.

DIREÇÃO: o personagem está virado para a DIREITA da imagem, em três-quartos de frente, e golpeia para a direita.

MEDIDAS (importante): o CORPO do personagem tem sempre a MESMA altura da silhueta cinza (do topo da cabeça à sola), em todos os quadros: nunca aumente ou diminua o corpo, o tronco pode se inclinar. O pé de apoio traseiro toca sempre a linha verde. A espada pode ir longe, mas NUNCA toca a borda do quadro.

QUADROS:
1) Antecipação: recolhe a espada junto ao corpo e carrega o peso para trás.
2) Golpe: passo à frente, espada em arco largo na linha do alvo, maior extensão do corpo.
3) Impacto: ponto final do golpe, braço estendido, lâmina com o brilho azul um pouco mais intenso (sem efeito novo).
4) Recuperação: volta à guarda do personagem parado.
A espada fica na mão esquerda em todos os quadros.

NÃO FAÇA: mudar o rosto, o cabelo, a armadura ou a cor; trocar a espada de mão; incluir símbolo, aura, faísca ou rastro de golpe; cortar a espada; deixar a espada atravessar para outro quadro; cenário; sombra no chão.
```

