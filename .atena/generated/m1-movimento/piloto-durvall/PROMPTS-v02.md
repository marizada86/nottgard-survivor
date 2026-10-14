# Piloto Durvall: prompts v02 (ataque em célula larga e andar para baixo sem corte)

Mesmo esquema: conversa nova, anexe os 2 arquivos, cole o texto, salve em `retorno/` e diga "retornou". Os outros dois retornos do v02 estão no arquivo [PROMPT-P1-v02.md](PROMPT-P1-v02.md).

| Prompt | Para quê | Anexe | Salve como |
|---|---|---|---|
| **P4 v02** | Ataque com a espada inteira (célula larga 512 × 512) | `durvall_idle.png` + `gabarito_attack_wide.png` | `durvall_attack_wide_v01.png` |
| **P3 v02** | Andar para baixo sem a espada atravessar o quadro vizinho | `durvall_idle.png` + `gabarito_move_s_v02.png` | `durvall_move_s_v02.png` |

---

## P4 v02: `attack` em célula larga

**Por quê:** no v01 o golpe passava de 290 px de largura e a espada era cortada na borda do quadro de 256 px. Agora cada quadro tem **512 × 512** e o personagem fica do **mesmo tamanho** do idle (a espada é que tem espaço).

```
Gere UMA tira de animação de ataque para jogo 2D isométrico: pintura de pixel detalhada, câmera três-quartos, luz vinda do alto à esquerda. Fundo TRANSPARENTE real (PNG com alfa). Sem cenário, sem chão, sem sombra projetada, sem texto, sem rótulos, sem desfoque de movimento.

PERSONAGEM: use a imagem "durvall_idle.png" como referência OBRIGATÓRIA de rosto, cabelo, armadura, espada, paleta, proporção e acabamento. Não redesenhe nada. É Durvall, drow de pele cinza-azulada, cabelo branco longo e solto, orelhas pontudas, armadura negra laminada com ombreiras de espinhos, faixa vinho no cinto, pendente azul no peito, botas negras e uma espada de lâmina azul-gelo luminosa na MÃO ESQUERDA (a mesma mão em todos os quadros).

FORMATO: uma faixa horizontal com 4 quadros QUADRADOS iguais (512 × 512 cada), lado a lado, sem espaço e sem moldura entre eles. Use "gabarito_attack_wide.png" só como guia de posição: linha verde = chão onde o pé de apoio toca; linha azul = topo da cabeça; retângulo vermelho = margem que nada pode cruzar; silhueta cinza = tamanho do personagem parado, ao centro de cada quadro. NÃO desenhe nenhuma linha, número ou silhueta do gabarito na imagem final.

DIREÇÃO: o personagem está virado para a DIREITA da imagem, em três-quartos de frente, e golpeia para a direita.

MEDIDAS (importante): o CORPO do personagem tem sempre a MESMA altura da silhueta cinza (do topo da cabeça à sola), em todos os quadros: nunca aumente ou diminua o corpo, o tronco pode se inclinar. O pé de apoio traseiro toca sempre a linha verde. O quadro é largo para a espada caber: a lâmina pode ir longe para a direita, mas NUNCA toca nem cruza o retângulo vermelho e NUNCA é cortada pela borda do quadro. Cada quadro fica inteiro dentro do seu quadrado: nada passa para o quadro vizinho.

QUADROS:
1) Antecipação: recolhe a espada junto ao corpo e carrega o peso para trás.
2) Golpe: passo à frente, espada em arco largo na linha do alvo, maior extensão do corpo.
3) Impacto: ponto final do golpe, braço estendido, lâmina com o brilho azul um pouco mais intenso (sem efeito novo).
4) Recuperação: volta à guarda do personagem parado.
A espada fica na mão esquerda em todos os quadros.

NÃO FAÇA: mudar o rosto, o cabelo, a armadura ou a cor; trocar a espada de mão; incluir símbolo, aura, faísca ou rastro de golpe; cortar a espada; cenário; sombra no chão.
```

---

## P3 v02: `move_s` com faixas vazias entre os quadros

**Por quê:** no v01 a espada de um quadro atravessava o limite e aparecia no quadro seguinte (por isso "cortada de um lado e aparece do outro"). Agora há uma **faixa vazia (cinza-escuro)** entre os quadros, e nada pode entrar nela.

```
Gere UMA tira de animação de personagem para jogo 2D isométrico: pintura de pixel detalhada, câmera três-quartos, luz vinda do alto à esquerda. Fundo TRANSPARENTE real (PNG com alfa). Sem cenário, sem chão, sem sombra projetada, sem texto, sem rótulos, sem desfoque de movimento.

PERSONAGEM: use a imagem "durvall_idle.png" como referência OBRIGATÓRIA de rosto, cabelo, armadura, espada, paleta, proporção e acabamento. Não redesenhe nada. É Durvall, drow de pele cinza-azulada, cabelo branco longo e solto, orelhas pontudas, armadura negra laminada com ombreiras de espinhos, faixa vinho no cinto, pendente azul no peito, botas negras e uma espada de lâmina azul-gelo luminosa na MÃO ESQUERDA (a mesma mão em todos os quadros; no idle ela aparece do lado direito da imagem).

FORMATO: uma faixa horizontal com 6 quadros (cada um com proporção 2:3) SEPARADOS por faixas VAZIAS e transparentes, mais estreitas que um quadro. No gabarito, as áreas claras são os quadros e as faixas cinza-escuro entre elas são as separações. Use "gabarito_move_s_v02.png" só como guia de posição: linha verde = chão onde o pé de apoio toca; linha azul = topo da cabeça; retângulo vermelho = margem de cada quadro; silhueta cinza = tamanho do personagem parado. NÃO desenhe nenhuma linha, número, faixa ou silhueta do gabarito na imagem final: as separações ficam TRANSPARENTES.

REGRA PRINCIPAL: cada quadro, com a espada e o cabelo, fica INTEIRO dentro do seu retângulo vermelho. Nada, nem a ponta da espada, pode tocar ou entrar na faixa de separação nem no quadro vizinho. Se precisar, aponte a espada mais para baixo e perto do corpo.

DIREÇÃO: o personagem anda PARA BAIXO da imagem, vindo direto em direção à câmera, de frente, em um trote firme e natural.

MEDIDAS (importante): o personagem tem sempre a MESMA altura da silhueta (do topo da cabeça à sola), em todos os quadros; nunca aumente ou diminua o corpo para animar. O pé de apoio toca sempre a linha verde. A passada é MÉDIA: nos quadros de contato um pé está claramente à frente do outro, o da frente mais baixo na imagem, com a perna de trás encurtada pela perspectiva. Mudança de pose pequena e gradual entre quadros consecutivos.

QUADROS:
1) Contato: pé direito à frente (mais baixo na imagem), calcanhar tocando; pé esquerdo atrás, só a ponta apoiada.
2) Passagem: corpo um pouco mais baixo, pernas cruzando sob o corpo.
3) Alto: a perna de trás vai à frente, corpo um pouco mais alto.
4) Contato: igual ao 1 com as pernas trocadas (pé esquerdo à frente).
5) Passagem: igual ao 2 com as pernas trocadas.
6) Alto: igual ao 3 com as pernas trocadas; o quadro 6 leva suavemente de volta ao quadro 1.
Braços balançam pouco, em oposição às pernas. A espada fica na mesma mão em todos os quadros, sempre dentro do retângulo vermelho.

NÃO FAÇA: mudar o rosto, o cabelo, a armadura ou a cor; trocar a espada de mão; incluir símbolo, aura ou efeito que não esteja no idle; cortar a espada; deixar a espada atravessar para outro quadro; cenário; sombra no chão.
```
