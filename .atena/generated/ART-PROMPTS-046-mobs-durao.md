---
id: "ART-PROMPTS-046"
type: "prompts-de-arte"
title: "Animações dos inimigos de Durao — identidade e ciclos"
status: "pronto para envio — nada executado; aguarda aprovação das identidades"
created: "2026-10-01"
relations: ["[[PLAN-041-animacao-padrao-zumbi-para-inimigos-e-interacoes-2026-09-29]]", "[[PLAN-048-geracao-animacoes-mobs-onda-1-2026-09-30]]", "[[ART-PROMPTS-033-mobs-onda-1-lote-a]]"]
---

# ART-PROMPTS-046 — Durao (Andar 274 · a jaula e o rio de almas)

Segue a receita da Onda 1 (ART-PROMPTS-032 e 033), que o dono aprovou: **primeiro a identidade** (`idle_00`) de cada alvo, depois os demais quadros, cada um como imagem independente. Perfil A = 20 quadros (idle 4, move 6, attack 4, death 6). Perfil B (chefe) = 26 (mais `special` 6). Nenhuma imagem é asset oficial; tudo fica em `.atena/generated/art-candidates/enemies-durao/<id>/`.

## Alvos deste lote

| Alvo | Nome | Perfil | Quadros | Referência estática |
|---|---|---|---:|---|
| `alma_penada` | Alma Penada | A | 20 | `assets/enemies/alma_penada.png` |
| `demonio_de_gehenna` | Demônio de Gehenna | A | 20 | `assets/enemies/demonio_de_gehenna.png` |
| `carcereiro_de_pedra` | Carcereiro de Pedra | A | 20 | `assets/enemies/carcereiro_de_pedra.png` |
| `aberracao_shu` | Shu | A | 20 | `assets/enemies/aberracao_shu.png` |
| `ezro` | Ezro | A | 20 | `assets/enemies/ezro.png` |
| `molydeus_chefe` | Molydeus, Carcereiro-Chefe | B | 26 | `assets/enemies/molydeus_chefe.png` |
| **Total** | | | **126** | |

### Reuso (nada a gerar)

- `molydeus_menor` (Molydeus, elite): **não gerar**. Reaproveita a animação de `molydeus_chefe` com a escala 1,6 contra 1,9 que o jogo já aplica (PLAN-041, tabela de reuso). Só entra se o dono vetar o reuso após a admissão.

## Contrato do gate de identidade

```text
Use the attached static sprite as the exact identity reference: preserve its unique silhouette, clothing or anatomy, palette, props, and visual hierarchy. Create one full-body game sprite in a neutral idle pose, viewed at a three-quarter front angle and facing to the RIGHT. Dark-fantasy isometric pixel art, crisp controlled dithering, opaque solid silhouette, no blur, no antialiasing, no motion lines. Centered; the visual base is anchored at the bottom; at least 8% side margin. Transparent background. No ground, cast shadow, scenery, gradient, text, logo, watermark, frame, UI, or extra character. Keep the subject isolated, readable, and at the same apparent scale as the reference.
```

Cada identidade gera só o `idle_00`, anexando a arte estática do alvo. Salvar como `<id>_idle_00_v01.png`.

## I01 — `alma_penada_idle_00`

Referência: `assets/enemies/alma_penada.png`. Espectro azul-ciano esguio de torso esquelético com costelas visíveis, braços finos e cauda de névoa azul que afina para baixo. A translucência é do desenho original: gerar a névoa como faixas sólidas e conectadas. Pose: flutua no lugar, a cauda ondulando devagar, subida e descida leves.

## I02 — `demonio_de_gehenna_idle_00`

Referência: `assets/enemies/demonio_de_gehenna.png`. Demônio-inseto esguio vermelho-escuro com antenas, couraça de placas de osso, tabardo de placas, pernas de gafanhoto e uma lança longa na mão esquerda. Pose: parado, lança apoiada, antenas vibrando levemente.

## I03 — `carcereiro_de_pedra_idle_00`

Referência: `assets/enemies/carcereiro_de_pedra.png`. Golem de pedra cinza bloco a bloco, grossas correntes e algemas enferrujadas penduradas nos braços e cintura, núcleo azul luminoso no peito. Pose: parado, núcleo azul pulsando, correntes balançando de leve.

## I04 — `aberracao_shu_idle_00`

Referência: `assets/enemies/aberracao_shu.png`. Aberração alta e magra tipo inseto verde-oliva, braços como foices curvas, olhos roxos, asas membranosas fechadas nas costas, pernas finas e garras nos pés. Pose: parada e ereta, foices recolhidas, antenas vibrando.

## I05 — `ezro_idle_00`

Referência: `assets/enemies/ezro.png`. Sapo gigante verde-musgo, agachado, com massa roxa de um grande olho único sobre a cabeça, boca larga de dentes e olhos laranja. Pose: agachado e parado, papo respirando, língua recolhida.

## I06 — `molydeus_chefe_idle_00`

Referência: `assets/enemies/molydeus_chefe.png`. Besta demoníaca vermelha com cabeça de lobo, cobra sobre o ombro direito, corpo musculoso com armadura de correntes e placas enferrujadas e um grande machado de lâmina dupla segurado com as duas mãos. Pose: ereto e imponente, machado apoiado diante do corpo, cobra balançando.

## Base fixa para cada quadro (depois da identidade aprovada)

```text
Use the two attached images as references: preserve the exact character identity from the static sprite, and match the approved idle frame for proportions, palette, scale, camera and facing. Create exactly one full-body animation frame. Dark-fantasy isometric pixel art, three-quarter front view, facing RIGHT, crisp controlled dithering, clean pixel edges. Centered in a tall 2:3 frame with the visual base at the bottom and at least 8% side margin. Truly transparent background. The complete silhouette is solid and opaque; keep slime, mist, fungus, cloth, chains, flames and other effects attached to the character. No ground, cast shadow, scenery, gradient, text, logo, watermark, frame, UI, second character, blur, motion streaks, or loose particles. Keep the same apparent scale as the approved identity frame.
```

Anexar a arte estática `assets/enemies/<id>.png` e o `idle_00` aprovado. Salvar como `<id>_<estado>_<quadro>_v01.png`.

## Poses comuns (todos os alvos)

- `idle_01`: respiração ou pulsação leve, base fixa. `idle_02`: pequena troca de peso ou pulso contido. `idle_03`: assenta na pose de `idle_00` para o loop fechar.
- `move_00`: primeiro contato, passo (ou frente do corpo) à frente. `move_01`: transferência de peso, leve queda do corpo. `move_02`: passagem. `move_03`: contato oposto. `move_04`: transferência oposta. `move_05`: fechamento, pronto para voltar a `move_00` sem salto.
- `attack_00`: antecipação clara. `attack_01`: início da ação. `attack_02`: ponto de impacto legível, sem projétil, círculo, respingo ou efeito solto. `attack_03`: recuperação contida.
- `death_00`: recebe o impacto. `death_01`: estrutura começa a ceder. `death_02`: cai mais, perde o equilíbrio. `death_03`: semi-caído, silhueta inteira no quadro. `death_04`: colapso. `death_05`: pose final imóvel.
- Não espelhar imagens: a integração cuida do lado. Nada de pernas, armas ou objetos duplicados, nem trocar o lado da arma entre quadros.

## Poses específicas por alvo

### `alma_penada` — Alma Penada
- Identidade fixa: Espectro azul-ciano esguio de torso esquelético com costelas visíveis, braços finos e cauda de névoa azul que afina para baixo. A translucência é do desenho original: gerar a névoa como faixas sólidas e conectadas.
- `idle`: flutua no lugar, a cauda ondulando devagar, subida e descida leves.
- `move`: desliza para a direita sem pernas: o corpo ondula, a cauda alterna esquerda e direita.
- `attack`: estende as garras à direita num arranque: recua o torso, avança, ponto de alcance.
- `death`: o corpo se desfaz em faixas sólidas de névoa que descem e se recolhem até o último quadro, tudo conectado.

### `demonio_de_gehenna` — Demônio de Gehenna
- Identidade fixa: Demônio-inseto esguio vermelho-escuro com antenas, couraça de placas de osso, tabardo de placas, pernas de gafanhoto e uma lança longa na mão esquerda.
- `idle`: parado, lança apoiada, antenas vibrando levemente.
- `move`: passos longos e ágeis de pernas de gafanhoto, lança sempre na mesma mão.
- `attack`: estocada de lança para a direita com avanço do corpo.
- `death`: a couraça cede, joelhos dobram, tomba de lado com a lança junto ao corpo.

### `carcereiro_de_pedra` — Carcereiro de Pedra
- Identidade fixa: Golem de pedra cinza bloco a bloco, grossas correntes e algemas enferrujadas penduradas nos braços e cintura, núcleo azul luminoso no peito.
- `idle`: parado, núcleo azul pulsando, correntes balançando de leve.
- `move`: passos muito pesados, o corpo inteiro oscilando, correntes balançando presas.
- `attack`: soco duplo para a direita com as correntes acompanhando.
- `death`: o núcleo apaga, as juntas cedem e o golem desaba de joelhos e tomba em bloco, unido.

### `aberracao_shu` — Shu
- Identidade fixa: Aberração alta e magra tipo inseto verde-oliva, braços como foices curvas, olhos roxos, asas membranosas fechadas nas costas, pernas finas e garras nos pés.
- `idle`: parada e ereta, foices recolhidas, antenas vibrando.
- `move`: passos finos e rápidos de inseto, foices balançando, asas fechadas.
- `attack`: corte com as duas foices para a direita em arco cruzado.
- `death`: as pernas finas cedem, as foices se cruzam, desaba de lado com as asas fechadas.

### `ezro` — Ezro
- Identidade fixa: Sapo gigante verde-musgo, agachado, com massa roxa de um grande olho único sobre a cabeça, boca larga de dentes e olhos laranja.
- `idle`: agachado e parado, papo respirando, língua recolhida.
- `move`: saltos curtos e pesados para a direita: agacha, impulsiona, pousa.
- `attack`: abre a boca e estende a língua para a direita, ainda presa à boca; sem efeitos soltos.
- `death`: as patas cedem, a barriga toca o chão, o olho único se fecha e ele tomba de lado.

### `molydeus_chefe` — Molydeus, Carcereiro-Chefe
- Identidade fixa: Besta demoníaca vermelha com cabeça de lobo, cobra sobre o ombro direito, corpo musculoso com armadura de correntes e placas enferrujadas e um grande machado de lâmina dupla segurado com as duas mãos.
- `idle`: ereto e imponente, machado apoiado diante do corpo, cobra balançando.
- `move`: passos pesados, machado carregado diante do corpo, cobra balançando presa.
- `attack`: golpe de machado em arco para a direita.
- `death`: joelhos cedem, o machado cai junto ao corpo, tomba para frente sem sair do quadro.
- `special_00`–`special_05` (6 quadros): ergue o machado acima da cabeça e crava no chão à direita, correntes balançando presas, sem rachaduras nem efeito solto. Sequência: antecipação, início, subida, pico, sustentação, recuperação.

## Critérios de rejeição imediata

- Orientação para a esquerda, corte de asa, arma, braço ou cauda, escala diferente do `idle_00`, fundo não transparente.
- Gosma, névoa, chama, fungo ou corrente translúcidos, desfocados ou soltos; partículas, círculos mágicos, projéteis ou respingos separados.
- Troca de mão da arma, membros duplicados, texto, UI, cenário, sombra no chão ou segundo personagem.
- Solidez abaixo de 0,90 (0,79 apenas para o que é translúcido por desenho: `alma_penada`, `bolha_de_slime`).
