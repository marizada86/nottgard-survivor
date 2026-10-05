---
id: "EVID-158"
title: "Velocidade de movimento x passo da arte (heróis e inimigos)"
created: "2026-10-05"
relations: ["[[EVID-153-varredura-b001-movimentacao-dos-herois-2026-10-04]]", "[[SPEC-123-revisao-da-movimentacao-dos-herois]]"]
---

# EVID-158 — velocidade do jogo x passo da arte

Só leitura e medição; nada do jogo mudou.

## Método

- **Velocidade do jogo (px de tela por segundo):** herói `SPEED_PX = 190` × (1 + `speed_pct`), igual em qualquer direção (`core/hero.gd`). Inimigo `speed` × 45,25 na horizontal de tela e × 22,63 na vertical (projeção 2:1, `core/iso.gd`).
- **Passo que a arte pede:** em cada quadro da tira de andar (`move_e` nos heróis, `move` nos inimigos), largura da silhueta nos 12% mais baixos (a faixa dos pés); o máximo entre os quadros é a abertura dos pés `S`, na escala de exibição. Um ciclo tem 6 quadros a 10 quadros/s (0,6 s) e dois passos, então `v_art = 2·S / 0,6 s`.
- **Razão** = velocidade do jogo ÷ `v_art`. **Maior que 1:** o chão passa mais rápido que as pernas (pés deslizam). **Menor que 1:** as pernas giram mais que o chão passa (passo "no lugar").

Limites: a faixa dos pés inclui barras de capa e corpos largos (slimes, Pudim Negro, Molydeus), voadores e fantasmas não têm pé, e os heróis só foram medidos no `move_e`. É estimativa; quem decide é o olho.

## Heróis (`move_e`, velocidade de jogo em px/s)

| Herói | Altura em tela | `S` | `v_art` | Jogo | Razão |
|---|---:|---:|---:|---:|---:|
| Korrak | 76 | 57,5 | 192 | 171 | 0,89 |
| Kayron | 66 | 47,6 | 159 | 190 | 1,20 |
| Sylas | 64 | 47,4 | 158 | 190 | 1,20 |
| Durvall | 60 | 36,4 | 121 | 190 | 1,57 |
| Leoric | 40 | 38,6 | 129 | 190 | 1,48 |
| Zynara | 60 | 33,8 | 113 | 190 | 1,69 |
| Nyrelia | 62 | 31,2 | 104 | 190 | 1,83 |
| Maelor | 64 | 30,2 | 101 | 190 | 1,89 |
| Brook | 40 | 28,7 | 96 | 190 | 1,98 |
| Bromnor | 48 | 27,3 | 91 | 190 | 2,09 |

## Referência: humanoides que o dono aprovou

| Inimigo | Razão horizontal | Razão vertical |
|---|---:|---:|
| Zumbi | 0,62 | 0,31 |
| Bandido (`cultista_adaga`) | 0,66 | 0,33 |
| Cultista arqueiro | 0,66 | 0,33 |
| Cultista cajado | 0,56 | 0,28 |
| Cultista Thullgrime | 0,58 | 0,29 |
| Cultista de Feng Tu | 0,64 | 0,32 |

Quase todo humanoide inimigo cai em 0,56 a 0,66. Medidas pouco confiáveis (sem pé ou corpo largo): Alma Penada 2,82, Esporo Voador 2,05, Notívago 1,34, Larva de Lu Yueh 1,01, Pudim Negro 0,08, Molydeus 0,15, Zuggtmoy 0,14.

## Leitura

- Os inimigos aprovados andam com a razão em torno de 0,6; os heróis, entre 1,2 e 2,1 (Korrak, 0,89, é a exceção). A arte dos heróis tem passo curto para a velocidade que o jogo impõe, o que lê como patinação.
- A velocidade do herói não pode cair para a razão dos inimigos (Zynara a 0,6 andaria a ~68 px/s). A alavanca barata é a **cadência da tira** (quadros por segundo), não a velocidade.
- `fps` para razão 1,0 = `3·v / S`: Brook 19,9; Bromnor 20,9; Maelor 18,9; Nyrelia 18,3; Zynara 16,9; Durvall 15,7; Leoric 14,8; Kayron 12,0; Sylas 12,0; Korrak 8,9 (hoje 10; ficaria mais lento). Para razão 0,8, multiplicar por 1,25.
- Efeito colateral: ligar a cadência à velocidade real (`speed_px() / 190`) faria bênçãos e itens de velocidade mudarem o passo, e a lentidão (×0,6) o reduzir.

## Decisão do dono (2026-10-05): cadência não adotada

O dono viu o clipe (Zynara 17 q/s, Bromnor 21 q/s), pediu para aplicar e, em seguida, disse que **não gostou da nova cadência**. A mudança em `ui/hero_view.gd` (`WALK_FPS`) e o teste correspondente foram revertidos, sem commit; o jogo continua com 10 quadros/s para todos os heróis. A razão 1,0 do método foi só uma estimativa e não representa a preferência visual do dono.

Se o assunto voltar: o dono já testou o ponto de razão 1,0; qualquer nova tentativa deve partir de valores menores (por exemplo razão 1,3 a 1,5) e do clipe em `.atena/generated/art-candidates/heroes-dimensoes/clip-passo/`, e não repetir 17 e 21.
