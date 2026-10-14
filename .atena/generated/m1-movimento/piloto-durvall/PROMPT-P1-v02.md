# P1 v02: `move_e` mais fluido (6 quadros, passada mais curta)

**Por quê:** no P1 v01 os pés ficam muito afastados nos quadros de contato (≈ 145 px de passo, a metade da altura e mais), e cada troca de pose salta demais. No P2 e no P3, que você aprovou, a passada projetada é bem menor. Aqui a passada cai para ≈ 40% da altura e as poses mudam aos poucos.

**Anexe:** `durvall_idle.png` e `gabarito_move_e_v02.png` (cruzes rosa mais próximas, nos quadros 1 e 4). Salve como `durvall_move_e_v02.png` em `retorno/`.

```
Gere UMA tira de animação de personagem para jogo 2D isométrico: pintura de pixel detalhada, câmera três-quartos, luz vinda do alto à esquerda. Fundo TRANSPARENTE real (PNG com alfa). Sem cenário, sem chão, sem sombra projetada, sem texto, sem rótulos, sem desfoque de movimento.

PERSONAGEM: use a imagem "durvall_idle.png" como referência OBRIGATÓRIA de rosto, cabelo, armadura, espada, paleta, proporção e acabamento. Não redesenhe nada. É Durvall, drow de pele cinza-azulada, cabelo branco longo e solto, orelhas pontudas, armadura negra laminada com ombreiras de espinhos, faixa vinho no cinto, pendente azul no peito, botas negras e uma espada de lâmina azul-gelo luminosa na MÃO ESQUERDA (a mesma mão em todos os quadros).

FORMATO: uma faixa horizontal com 6 quadros iguais, lado a lado, sem espaço e sem moldura entre eles (cada quadro com proporção 2:3). Use "gabarito_move_e_v02.png" só como guia de posição: linha verde = chão onde o pé de apoio toca; linha azul = topo da cabeça; retângulo vermelho = margem que nada pode cruzar; silhueta cinza = tamanho do personagem parado; cruzes rosa nos quadros 1 e 4 = onde os pés caem. NÃO desenhe nenhuma linha, número ou silhueta do gabarito na imagem final.

DIREÇÃO: o personagem anda para a DIREITA da imagem, de perfil, em um trote firme e natural, tronco quase ereto (no máximo levemente inclinado para a frente).

MEDIDAS (importante): o personagem tem sempre a MESMA altura da silhueta (do topo da cabeça à sola), em todos os quadros; nunca aumente ou diminua o corpo para animar. O pé de apoio toca sempre a linha verde. A passada é MÉDIA, não longa: nos quadros 1 e 4 os dois pés ficam afastados cerca de 40% da altura do corpo (as cruzes rosa). Entre um quadro e o seguinte a mudança de pose é PEQUENA e gradual: nada de saltos bruscos de perna ou de braço. Os quadros 1 e 4 e os quadros 2 e 5 devem ser parecidos entre si, com as pernas trocadas. Nada pode encostar no retângulo vermelho, espada e cabelo incluídos.

QUADROS:
1) Contato: pé direito (da frente) tocando com o calcanhar, pé esquerdo atrás com a ponta apoiada.
2) Passagem: perna de apoio sob o corpo, outra perna saindo do chão, corpo um pouco mais baixo.
3) Alto: a perna de trás vai à frente, pé curto no ar (no máximo uns dois dedos acima da linha verde), corpo um pouco mais alto.
4) Contato: igual ao 1 com as pernas trocadas (pé esquerdo à frente).
5) Passagem: igual ao 2 com as pernas trocadas.
6) Alto: igual ao 3 com as pernas trocadas; o quadro 6 leva suavemente de volta ao quadro 1.
Braços balançam pouco, em oposição às pernas. A espada fica na mesma mão em todos os quadros, sem cortar.

NÃO FAÇA: mudar o rosto, o cabelo, a armadura ou a cor; trocar a espada de mão; incluir símbolo, aura ou efeito que não esteja no idle; cortar a espada; cenário; sombra no chão; salto exagerado.
```
