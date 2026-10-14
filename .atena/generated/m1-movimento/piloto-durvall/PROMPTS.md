# Piloto Durvall: prompts prontos para o GPT

Nesta pasta você tem tudo. Para cada prompt: **abra uma conversa nova**, anexe os **2 arquivos** indicados, cole o texto da caixa e peça a imagem. Cada prompt é independente (não precisa mandar um antes do outro).

**Ordem sugerida:** comece só pelo **P1 (`move_e`)**: é o que mais mostra se o método funciona. Se ele sair bom, mande P2, P3 e P4.

**O que fazer com o resultado:** salve cada PNG em `retorno/` com o nome do prompt (`durvall_move_e_v01.png`, `durvall_move_se_v01.png`, `durvall_move_s_v01.png`, `durvall_attack_v01.png`; novas tentativas `_v02`, `_v03`) e me diga "retornou". Eu audito (altura, base, passo, corte, alfa), monto a comparação e deixo o Durvall novo andando no jogo com o ritmo novo (17 fps) para você ver.

**Se o GPT errar o formato** (fundo opaco, 5 ou 7 quadros, quadros com tamanhos diferentes, desenhou as linhas do gabarito): peça de novo com a frase "refaça respeitando exatamente 6 quadros iguais e fundo transparente; não desenhe as linhas do gabarito". Não precisa corrigir a mão: me mande o que vier.

Arquivos: `durvall_idle.png` (referência do personagem) e `gabarito_*.png` (guia de posição; **não** deve aparecer na imagem final).

---

## P1: `move_e` (andando para a direita, de perfil)

**Anexe:** `durvall_idle.png` e `gabarito_move_e.png`

```
Gere UMA tira de animação de personagem para jogo 2D isométrico: pintura de pixel detalhada, câmera três-quartos, luz vinda do alto à esquerda. Fundo TRANSPARENTE real (PNG com alfa). Sem cenário, sem chão, sem sombra projetada, sem texto, sem rótulos, sem desfoque de movimento.

PERSONAGEM: use a imagem "durvall_idle.png" como referência OBRIGATÓRIA de rosto, cabelo, armadura, espada, paleta, proporção e acabamento. Não redesenhe nada. É Durvall, drow de pele cinza-azulada, cabelo branco longo e solto, orelhas pontudas, armadura negra laminada com ombreiras de espinhos, faixa vinho no cinto, pendente azul no peito, botas negras e uma espada de lâmina azul-gelo luminosa na MÃO ESQUERDA (a mesma mão em todos os quadros).

FORMATO: uma faixa horizontal com 6 quadros iguais, lado a lado, sem espaço e sem moldura entre eles (cada quadro com proporção 2:3). Use "gabarito_move_e.png" só como guia de posição: linha verde = chão onde o pé de apoio toca; linha azul = topo da cabeça; retângulo vermelho = margem que nada pode cruzar; silhueta cinza = tamanho do personagem parado; cruzes rosa nos quadros 1 e 4 = onde os pés caem. NÃO desenhe nenhuma linha, número ou silhueta do gabarito na imagem final.

DIREÇÃO: o personagem anda para a DIREITA da imagem, de perfil, correndo num ritmo constante.

MEDIDAS (importante): o personagem tem sempre a MESMA altura da silhueta (do topo da cabeça à sola), em todos os quadros; nunca aumente ou diminua o corpo para animar, o movimento vem das pernas, dos braços e do tronco. O pé de apoio toca sempre a linha verde. A passada é LONGA: nos quadros 1 e 4 os dois pés ficam bem afastados, mais ou menos a metade da altura do corpo um do outro (as cruzes rosa). Nada pode encostar no retângulo vermelho, espada e cabelo incluídos.

QUADROS:
1) Contato: pé direito (o da frente) à frente tocando o chão com o calcanhar, pé esquerdo atrás só com a ponta apoiada; passada máxima.
2) Passagem baixa: corpo no ponto mais baixo, perna de apoio sob o corpo, outra perna saindo do chão.
3) Alto: a perna de trás empurra e a da frente está no ar; corpo no ponto mais alto.
4) Contato: igual ao 1, mas com as pernas trocadas (pé esquerdo à frente).
5) Passagem baixa, igual ao 2 com as pernas trocadas.
6) Alto, igual ao 3 com as pernas trocadas; o quadro 6 volta suavemente ao quadro 1.
Braços balançam em oposição às pernas. A espada continua na mesma mão em todos os quadros, sem cortar nem sair da margem.

NÃO FAÇA: mudar o rosto, o cabelo, a armadura ou a cor; trocar a espada de mão; incluir símbolo, aura ou efeito que não esteja no idle; cortar a espada; cenário; sombra no chão.
```

---

## P2: `move_se` (andando para baixo e à direita)

**Anexe:** `durvall_idle.png` e `gabarito_move_se.png`

```
Gere UMA tira de animação de personagem para jogo 2D isométrico: pintura de pixel detalhada, câmera três-quartos, luz vinda do alto à esquerda. Fundo TRANSPARENTE real (PNG com alfa). Sem cenário, sem chão, sem sombra projetada, sem texto, sem rótulos, sem desfoque de movimento.

PERSONAGEM: use a imagem "durvall_idle.png" como referência OBRIGATÓRIA de rosto, cabelo, armadura, espada, paleta, proporção e acabamento. Não redesenhe nada. É Durvall, drow de pele cinza-azulada, cabelo branco longo e solto, orelhas pontudas, armadura negra laminada com ombreiras de espinhos, faixa vinho no cinto, pendente azul no peito, botas negras e uma espada de lâmina azul-gelo luminosa na MÃO ESQUERDA (a mesma mão em todos os quadros).

FORMATO: uma faixa horizontal com 6 quadros iguais, lado a lado, sem espaço e sem moldura entre eles (cada quadro com proporção 2:3). Use "gabarito_move_se.png" só como guia de posição: linha verde = chão onde o pé de apoio toca; linha azul = topo da cabeça; retângulo vermelho = margem que nada pode cruzar; silhueta cinza = tamanho do personagem parado. NÃO desenhe nenhuma linha, número ou silhueta do gabarito na imagem final.

DIREÇÃO: o personagem anda para BAIXO E PARA A DIREITA da imagem (vem em direção à câmera, virado para a direita), em três-quartos de frente, correndo num ritmo constante. Rosto visível em três-quartos.

MEDIDAS (importante): o personagem tem sempre a MESMA altura da silhueta (do topo da cabeça à sola), em todos os quadros; nunca aumente ou diminua o corpo para animar. O pé de apoio toca sempre a linha verde. A passada é LONGA: nos quadros 1 e 4 os dois pés ficam bem afastados, a uns 100 a 110 px na horizontal e uns 50 px na vertical da imagem (o da frente mais baixo e mais à direita). Nada pode encostar no retângulo vermelho, espada e cabelo incluídos.

QUADROS:
1) Contato: pé direito à frente (mais baixo na imagem) tocando com o calcanhar, pé esquerdo atrás só com a ponta apoiada; passada máxima.
2) Passagem baixa: corpo no ponto mais baixo, perna de apoio sob o corpo, outra saindo do chão.
3) Alto: perna de trás empurra, a da frente no ar; corpo no ponto mais alto.
4) Contato: igual ao 1 com as pernas trocadas (pé esquerdo à frente).
5) Passagem baixa, igual ao 2 com as pernas trocadas.
6) Alto, igual ao 3 com as pernas trocadas; o quadro 6 volta suavemente ao 1.
Braços balançam em oposição às pernas. A espada fica na mesma mão em todos os quadros, sem cortar.

NÃO FAÇA: mudar o rosto, o cabelo, a armadura ou a cor; trocar a espada de mão; incluir símbolo, aura ou efeito que não esteja no idle; cortar a espada; cenário; sombra no chão.
```

---

## P3: `move_s` (andando para baixo, de frente)

**Anexe:** `durvall_idle.png` e `gabarito_move_s.png`

```
Gere UMA tira de animação de personagem para jogo 2D isométrico: pintura de pixel detalhada, câmera três-quartos, luz vinda do alto à esquerda. Fundo TRANSPARENTE real (PNG com alfa). Sem cenário, sem chão, sem sombra projetada, sem texto, sem rótulos, sem desfoque de movimento.

PERSONAGEM: use a imagem "durvall_idle.png" como referência OBRIGATÓRIA de rosto, cabelo, armadura, espada, paleta, proporção e acabamento. Não redesenhe nada. É Durvall, drow de pele cinza-azulada, cabelo branco longo e solto, orelhas pontudas, armadura negra laminada com ombreiras de espinhos, faixa vinho no cinto, pendente azul no peito, botas negras e uma espada de lâmina azul-gelo luminosa na MÃO ESQUERDA (a mesma mão em todos os quadros; no idle ela aparece do lado direito da imagem).

FORMATO: uma faixa horizontal com 6 quadros iguais, lado a lado, sem espaço e sem moldura entre eles (cada quadro com proporção 2:3). Use "gabarito_move_s.png" só como guia de posição: linha verde = chão onde o pé de apoio toca; linha azul = topo da cabeça; retângulo vermelho = margem que nada pode cruzar; silhueta cinza = tamanho do personagem parado. NÃO desenhe nenhuma linha, número ou silhueta do gabarito na imagem final.

DIREÇÃO: o personagem anda PARA BAIXO da imagem, vindo direto em direção à câmera, de frente, correndo num ritmo constante.

MEDIDAS (importante): o personagem tem sempre a MESMA altura da silhueta (do topo da cabeça à sola), em todos os quadros; nunca aumente ou diminua o corpo para animar. O pé de apoio toca sempre a linha verde. A passada é LONGA: nos quadros 1 e 4 um pé está claramente à frente do outro, o da frente mais baixo na imagem (uns 50 a 60 px de diferença) e a perna de trás encurtada pela perspectiva. Nada pode encostar no retângulo vermelho, espada e cabelo incluídos.

QUADROS:
1) Contato: pé direito à frente (mais baixo na imagem), calcanhar tocando; pé esquerdo atrás, só a ponta apoiada.
2) Passagem baixa: corpo no ponto mais baixo, pernas cruzando sob o corpo, perna de apoio sob o centro.
3) Alto: a perna de trás empurra, a da frente no ar; corpo no ponto mais alto.
4) Contato: igual ao 1 com as pernas trocadas (pé esquerdo à frente).
5) Passagem baixa, igual ao 2 com as pernas trocadas.
6) Alto, igual ao 3 com as pernas trocadas; o quadro 6 volta suavemente ao 1.
Braços balançam em oposição às pernas. A espada fica na mesma mão em todos os quadros, sem cortar.

NÃO FAÇA: mudar o rosto, o cabelo, a armadura ou a cor; trocar a espada de mão; incluir símbolo, aura ou efeito que não esteja no idle; cortar a espada; cenário; sombra no chão.
```

---

## P4: `attack` (golpe de espada, 4 quadros)

**Anexe:** `durvall_idle.png` e `gabarito_attack.png`

```
Gere UMA tira de animação de ataque para jogo 2D isométrico: pintura de pixel detalhada, câmera três-quartos, luz vinda do alto à esquerda. Fundo TRANSPARENTE real (PNG com alfa). Sem cenário, sem chão, sem sombra projetada, sem texto, sem rótulos, sem desfoque de movimento.

PERSONAGEM: use a imagem "durvall_idle.png" como referência OBRIGATÓRIA de rosto, cabelo, armadura, espada, paleta, proporção e acabamento. Não redesenhe nada. É Durvall, drow de pele cinza-azulada, cabelo branco longo e solto, orelhas pontudas, armadura negra laminada com ombreiras de espinhos, faixa vinho no cinto, pendente azul no peito, botas negras e uma espada de lâmina azul-gelo luminosa na MÃO ESQUERDA (a mesma mão em todos os quadros).

FORMATO: uma faixa horizontal com 4 quadros iguais, lado a lado, sem espaço e sem moldura entre eles (cada quadro com proporção 2:3). Use "gabarito_attack.png" só como guia de posição: linha verde = chão onde o pé de apoio toca; linha azul = topo da cabeça; retângulo vermelho = margem que nada pode cruzar; silhueta cinza = tamanho do personagem parado. NÃO desenhe nenhuma linha, número ou silhueta do gabarito na imagem final.

DIREÇÃO: o personagem está virado para a DIREITA da imagem, em três-quartos de frente, e golpeia para a direita.

MEDIDAS (importante): o corpo do personagem tem sempre a MESMA altura da silhueta nos quadros (o tronco pode se inclinar, mas não cresce nem encolhe). O pé de apoio traseiro fica sempre na linha verde. A espada é grande: se o golpe pedir mais espaço, aponte a lâmina em diagonal para baixo ou para cima, mas NUNCA deixe a espada tocar ou cruzar o retângulo vermelho, e não reduza o personagem.

QUADROS:
1) Antecipação: recolhe a espada junto ao corpo e carrega o peso para trás.
2) Golpe: passo à frente, espada em arco largo na linha do alvo, maior extensão do corpo.
3) Impacto: ponto final do golpe, braço estendido, lâmina com o brilho azul um pouco mais intenso (sem efeito novo).
4) Recuperação: volta à guarda do personagem parado.
A espada fica na mão esquerda em todos os quadros.

NÃO FAÇA: mudar o rosto, o cabelo, a armadura ou a cor; trocar a espada de mão; incluir símbolo, aura, faísca ou rastro de golpe; cortar a espada; cenário; sombra no chão.
```
