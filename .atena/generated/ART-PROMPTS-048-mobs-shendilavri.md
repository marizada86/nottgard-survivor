---
id: "ART-PROMPTS-048"
type: "prompts-de-arte"
title: "Animações dos inimigos de Shendilavri — identidade e ciclos"
status: "pronto para envio — nada executado; aguarda aprovação das identidades"
created: "2026-10-01"
relations: ["[[PLAN-041-animacao-padrao-zumbi-para-inimigos-e-interacoes-2026-09-29]]", "[[PLAN-048-geracao-animacoes-mobs-onda-1-2026-09-30]]", "[[ART-PROMPTS-033-mobs-onda-1-lote-a]]"]
---

# ART-PROMPTS-048 — Shendilavri (Camada 570 · o reino das súcubos)

Segue a receita da Onda 1 (ART-PROMPTS-032 e 033), que o dono aprovou: **primeiro a identidade** (`idle_00`) de cada alvo, depois os demais quadros, cada um como imagem independente. Perfil A = 20 quadros (idle 4, move 6, attack 4, death 6). Perfil B (chefe) = 26 (mais `special` 6). Nenhuma imagem é asset oficial; tudo fica em `.atena/generated/art-candidates/enemies-shendilavri/<id>/`.

## Alvos deste lote

| Alvo | Nome | Perfil | Quadros | Referência estática |
|---|---|---|---:|---|
| `escravo_de_rivenheart` | Escravo de Rivenheart | A | 20 | `assets/enemies/escravo_de_rivenheart.png` |
| `sucubo` | Súcubo | A | 20 | `assets/enemies/sucubo.png` |
| `guarda_do_castelo` | Guarda do Castelo Argento | A | 20 | `assets/enemies/guarda_do_castelo.png` |
| `master_of_cruelties` | Master of Cruelties | A | 20 | `assets/enemies/master_of_cruelties.png` |
| `malcanthet` | Malcanthet, Rainha das Súcubos | B | 26 | `assets/enemies/malcanthet.png` |
| **Total** | | | **106** | |

### Reuso (nada a gerar)

- `ilusao_de_sucubo` (Ilusão): **não gerar**. Reaproveita a animação de `sucubo` com alfa 0,45 (`illusory`), como já roda hoje.

## Contrato do gate de identidade

```text
Use the attached static sprite as the exact identity reference: preserve its unique silhouette, clothing or anatomy, palette, props, and visual hierarchy. Create one full-body game sprite in a neutral idle pose, viewed at a three-quarter front angle and facing to the RIGHT. Dark-fantasy isometric pixel art, crisp controlled dithering, opaque solid silhouette, no blur, no antialiasing, no motion lines. Centered; the visual base is anchored at the bottom; at least 8% side margin. Transparent background. No ground, cast shadow, scenery, gradient, text, logo, watermark, frame, UI, or extra character. Keep the subject isolated, readable, and at the same apparent scale as the reference.
```

Cada identidade gera só o `idle_00`, anexando a arte estática do alvo. Salvar como `<id>_idle_00_v01.png`.

## I01 — `escravo_de_rivenheart_idle_00`

Referência: `assets/enemies/escravo_de_rivenheart.png`. Jovem de cabelos castanhos presos, magra, descalça, em vestido rasgado vermelho e creme, algemas com correntes nos pulsos e tornozelos, postura curvada. Pose: curvada e parada, correntes balançando de leve.

## I02 — `sucubo_idle_00`

Referência: `assets/enemies/sucubo.png`. Demônia vermelha com chifres, asas pequenas de morcego, cauda longa, armadura de couro preto e ouro, botas altas, mão esquerda estendida e lâmina curva na mão direita. Pose: parada, mão esquerda estendida, lâmina baixa, cauda balançando.

## I03 — `guarda_do_castelo_idle_00`

Referência: `assets/enemies/guarda_do_castelo.png`. Cavaleiro de armadura negra com espigões, capa carmesim, elmo com chifres, lança longa de ponta serrilhada na mão direita. Pose: ereto e parado, lança apoiada, capa estável.

## I04 — `master_of_cruelties_idle_00`

Referência: `assets/enemies/master_of_cruelties.png`. Demônio alado alto, grandes asas pretas e vermelhas, máscara dourada, gema solar dourada no peito, garras compridas, robe longo preto e carmesim. Pose: ereto, asas semi-abertas e estáveis, garras baixas.

## I05 — `malcanthet_idle_00`

Referência: `assets/enemies/malcanthet.png`. Rainha demoníaca com grandes chifres, asas de morcego, cauda longa, coroa, armadura negra e dourada com rubis, cetro com espelho de ametista na mão direita e mão esquerda estendida. Pose: ereta e imponente, mão esquerda estendida, cetro baixo, cauda balançando.

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

### `escravo_de_rivenheart` — Escravo de Rivenheart
- Identidade fixa: Jovem de cabelos castanhos presos, magra, descalça, em vestido rasgado vermelho e creme, algemas com correntes nos pulsos e tornozelos, postura curvada.
- `idle`: curvada e parada, correntes balançando de leve.
- `move`: passos descalços arrastados, correntes balançando presas.
- `attack`: lança-se para a frente à direita, correntes acompanhando.
- `death`: cai de joelhos, as correntes caem junto, tomba de lado.

### `sucubo` — Súcubo
- Identidade fixa: Demônia vermelha com chifres, asas pequenas de morcego, cauda longa, armadura de couro preto e ouro, botas altas, mão esquerda estendida e lâmina curva na mão direita.
- `idle`: parada, mão esquerda estendida, lâmina baixa, cauda balançando.
- `move`: passos elegantes e cruzados, asas semi-abertas, cauda balançando presa.
- `attack`: golpe de lâmina curva para a direita e gesto da mão esquerda.
- `death`: joelhos cedem, asas descem, tomba de lado com a lâmina junto ao corpo.

### `guarda_do_castelo` — Guarda do Castelo Argento
- Identidade fixa: Cavaleiro de armadura negra com espigões, capa carmesim, elmo com chifres, lança longa de ponta serrilhada na mão direita.
- `idle`: ereto e parado, lança apoiada, capa estável.
- `move`: marcha de cavaleiro, lança sempre na mão direita, capa balançando.
- `attack`: estocada de lança para a direita.
- `death`: a armadura cede, joelhos dobram, tomba de lado com a lança junto ao corpo.

### `master_of_cruelties` — Master of Cruelties
- Identidade fixa: Demônio alado alto, grandes asas pretas e vermelhas, máscara dourada, gema solar dourada no peito, garras compridas, robe longo preto e carmesim.
- `idle`: ereto, asas semi-abertas e estáveis, garras baixas.
- `move`: passos altos e sinistros, asas balançando levemente, sem voo.
- `attack`: corte de garras para a direita com as asas abertas.
- `death`: as asas caem, joelhos dobram, tomba de lado com as asas abertas no quadro.

### `malcanthet` — Malcanthet, Rainha das Súcubos
- Identidade fixa: Rainha demoníaca com grandes chifres, asas de morcego, cauda longa, coroa, armadura negra e dourada com rubis, cetro com espelho de ametista na mão direita e mão esquerda estendida.
- `idle`: ereta e imponente, mão esquerda estendida, cetro baixo, cauda balançando.
- `move`: passos elegantes e longos, asas semi-abertas, cetro sempre na mão direita.
- `attack`: gesto da mão esquerda e golpe do cetro à direita.
- `death`: asas descem, joelhos dobram, tomba de lado com o cetro junto ao corpo.
- `special_00`–`special_05` (6 quadros): abre as asas por completo e ergue o cetro com o espelho brilhando, pico com tudo aberto, sem projéteis nem círculos. Sequência: antecipação, início, subida, pico, sustentação, recuperação.

## Critérios de rejeição imediata

- Orientação para a esquerda, corte de asa, arma, braço ou cauda, escala diferente do `idle_00`, fundo não transparente.
- Gosma, névoa, chama, fungo ou corrente translúcidos, desfocados ou soltos; partículas, círculos mágicos, projéteis ou respingos separados.
- Troca de mão da arma, membros duplicados, texto, UI, cenário, sombra no chão ou segundo personagem.
- Solidez abaixo de 0,90 (0,79 apenas para o que é translúcido por desenho: `alma_penada`, `bolha_de_slime`).
