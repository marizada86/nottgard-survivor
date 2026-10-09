---
id: "ART-PROMPTS-049"
type: "prompts-de-arte"
title: "Animações dos inimigos de Goranthis — identidade e ciclos"
status: "concluido localmente — 86 fontes, 17 tiras e build validada; playtest humano pendente"
created: "2026-10-01"
relations: ["[[PLAN-041-animacao-padrao-zumbi-para-inimigos-e-interacoes-2026-09-29]]", "[[PLAN-048-geracao-animacoes-mobs-onda-1-2026-09-30]]", "[[ART-PROMPTS-033-mobs-onda-1-lote-a]]"]
---

# ART-PROMPTS-049 — Goranthis (Camada 597 · o verdadeiro Paraíso)

Segue a receita da Onda 1 (ART-PROMPTS-032 e 033), que o dono aprovou: **primeiro a identidade** (`idle_00`) de cada alvo, depois os demais quadros, cada um como imagem independente. Perfil A = 20 quadros (idle 4, move 6, attack 4, death 6). Perfil B (chefe) = 26 (mais `special` 6). Nenhuma imagem é asset oficial; tudo fica em `.atena/generated/art-candidates/enemies-goranthis/<id>/`.

## Alvos deste lote

| Alvo | Nome | Perfil | Quadros | Referência estática |
|---|---|---|---:|---|
| `guardiao_de_goranthis` | Guardião do Paraíso | A | 20 | `assets/enemies/guardiao_de_goranthis.png` |
| `cultista_de_socothbenoth` | Sacerdote de Ilusões | A | 20 | `assets/enemies/cultista_de_socothbenoth.png` |
| `death_tyrant` | Death Tyrant | A | 20 | `assets/enemies/death_tyrant.png` |
| `socothbenoth` | Socothbenoth, Âncora de Juiblex | B | 26 | `assets/enemies/socothbenoth.png` |
| **Total** | | | **86** | |

### Reuso (nada a gerar)

- `ilusao_de_socothbenoth` (Ilusão de Socothbenoth): **não gerar**. Reaproveita `cultista_de_socothbenoth` ou `socothbenoth` com o alfa que o jogo já aplica.

## Contrato do gate de identidade

```text
Use the attached static sprite as the exact identity reference: preserve its unique silhouette, clothing or anatomy, palette, props, and visual hierarchy. Create one full-body game sprite in a neutral idle pose, viewed at a three-quarter front angle and facing to the RIGHT. Dark-fantasy isometric pixel art, crisp controlled dithering, opaque solid silhouette, no blur, no antialiasing, no motion lines. Centered; the visual base is anchored at the bottom; at least 8% side margin. Transparent background. No ground, cast shadow, scenery, gradient, text, logo, watermark, frame, UI, or extra character. Keep the subject isolated, readable, and at the same apparent scale as the reference.
```

Cada identidade gera só o `idle_00`, anexando a arte estática do alvo. Salvar como `<id>_idle_00_v01.png`.

## I01 — `guardiao_de_goranthis_idle_00`

Referência: `assets/enemies/guardiao_de_goranthis.png`. Anjo de mármore marfim com veios verdes, duas grandes asas brancas, coroa dourada e lança dourada alta na mão esquerda. Pose: ereto, lança apoiada, asas fechadas parcialmente.

## I02 — `cultista_de_socothbenoth_idle_00`

Referência: `assets/enemies/cultista_de_socothbenoth.png`. Sacerdote de manto creme e vinho, coroa solar dourada, máscaras pálidas pendentes, cajado com espelho facial na mão direita e fitas de carne rosada. Pose: parado, cajado apoiado, fitas balançando presas.

## I03 — `death_tyrant_idle_00`

Referência: `assets/enemies/death_tyrant.png`. Esfera cinza-roxa espinhosa com grande olho azul central, vários olhos azuis em hastes tentaculares, rosto humano deformado na base e ornamentos de correntes pendurados. Pose: flutua no lugar, hastes oculares balançando, olho central piscando devagar.

## I04 — `socothbenoth_idle_00`

Referência: `assets/enemies/socothbenoth.png`. Figura alta de manto vinho e marfim com veios verdes, grandes chifres de osso, tentáculos negros saindo das costas, mãos longas e esguias. Pose: ereto e imponente, tentáculos balançando presos.

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

### `guardiao_de_goranthis` — Guardião do Paraíso
- Identidade fixa: Anjo de mármore marfim com veios verdes, duas grandes asas brancas, coroa dourada e lança dourada alta na mão esquerda.
- `idle`: ereto, lança apoiada, asas fechadas parcialmente.
- `move`: passos majestosos, lança sempre na mesma mão, asas balançando sem bater.
- `attack`: estocada de lança para a direita com um bater de asas curto.
- `death`: a armadura cede, joelhos dobram, tomba de lado com a lança junto ao corpo.

### `cultista_de_socothbenoth` — Sacerdote de Ilusões
- Identidade fixa: Sacerdote de manto creme e vinho, coroa solar dourada, máscaras pálidas pendentes, cajado com espelho facial na mão direita e fitas de carne rosada.
- `idle`: parado, cajado apoiado, fitas balançando presas.
- `move`: passos deslizantes, cajado sempre na mão direita, fitas ondulando presas.
- `attack`: gesto da mão esquerda e cajado erguido à direita, sem círculo nem projétil.
- `death`: joelhos cedem, manto cai sobre o corpo, tomba de lado.

### `death_tyrant` — Death Tyrant
- Identidade fixa: Esfera cinza-roxa espinhosa com grande olho azul central, vários olhos azuis em hastes tentaculares, rosto humano deformado na base e ornamentos de correntes pendurados.
- `idle`: flutua no lugar, hastes oculares balançando, olho central piscando devagar.
- `move`: desliza para a direita sem pernas, subindo e descendo, hastes alternando.
- `attack`: olho central brilha e a esfera avança à direita, sem raios nem projéteis.
- `death`: os olhos fecham um por um, o corpo cai e pousa murcho, tudo inteiro.

### `socothbenoth` — Socothbenoth, Âncora de Juiblex
- Identidade fixa: Figura alta de manto vinho e marfim com veios verdes, grandes chifres de osso, tentáculos negros saindo das costas, mãos longas e esguias.
- `idle`: ereto e imponente, tentáculos balançando presos.
- `move`: desliza em passos lentos, tentáculos e manto ondulando presos.
- `attack`: golpe de mão e tentáculo para a direita.
- `death`: os tentáculos caem, a figura se curva e desaba de joelhos e tomba de lado.
- `special_00`–`special_05` (6 quadros): abre os braços e ergue todos os tentáculos negros presos às costas, pico com tudo aberto, sem projéteis. Sequência: antecipação, início, subida, pico, sustentação, recuperação.

## Critérios de rejeição imediata

- Orientação para a esquerda, corte de asa, arma, braço ou cauda, escala diferente do `idle_00`, fundo não transparente.
- Gosma, névoa, chama, fungo ou corrente translúcidos, desfocados ou soltos; partículas, círculos mágicos, projéteis ou respingos separados.
- Troca de mão da arma, membros duplicados, texto, UI, cenário, sombra no chão ou segundo personagem.
- Solidez abaixo de 0,90 (0,79 apenas para o que é translúcido por desenho: `alma_penada`, `bolha_de_slime`).
