---
id: "ART-PROMPTS-045"
type: "prompts-de-arte"
title: "Animações dos inimigos de Molor — identidade e ciclos"
status: "pronto para envio — nada executado; aguarda aprovação das identidades"
created: "2026-10-01"
relations: ["[[PLAN-041-animacao-padrao-zumbi-para-inimigos-e-interacoes-2026-09-29]]", "[[PLAN-048-geracao-animacoes-mobs-onda-1-2026-09-30]]", "[[ART-PROMPTS-033-mobs-onda-1-lote-a]]"]
---

# ART-PROMPTS-045 — Molor (Andar 528 · caverna de bolhas)

Segue a receita da Onda 1 (ART-PROMPTS-032 e 033), que o dono aprovou: **primeiro a identidade** (`idle_00`) de cada alvo, depois os demais quadros, cada um como imagem independente. Perfil A = 20 quadros (idle 4, move 6, attack 4, death 6). Perfil B (chefe) = 26 (mais `special` 6). Nenhuma imagem é asset oficial; tudo fica em `.atena/generated/art-candidates/enemies-molor/<id>/`.

## Alvos deste lote

| Alvo | Nome | Perfil | Quadros | Referência estática |
|---|---|---|---:|---|
| `bolha_de_slime` | Bolha de Slime | A | 20 | `assets/enemies/bolha_de_slime.png` |
| `cultista_thullgrime` | Cultista de Ghaunadaur | A | 20 | `assets/enemies/cultista_thullgrime.png` |
| `blogbog` | Blogbog | B | 26 | `assets/enemies/blogbog.png` |
| **Total** | | | **66** | |

## Contrato do gate de identidade

```text
Use the attached static sprite as the exact identity reference: preserve its unique silhouette, clothing or anatomy, palette, props, and visual hierarchy. Create one full-body game sprite in a neutral idle pose, viewed at a three-quarter front angle and facing to the RIGHT. Dark-fantasy isometric pixel art, crisp controlled dithering, opaque solid silhouette, no blur, no antialiasing, no motion lines. Centered; the visual base is anchored at the bottom; at least 8% side margin. Transparent background. No ground, cast shadow, scenery, gradient, text, logo, watermark, frame, UI, or extra character. Keep the subject isolated, readable, and at the same apparent scale as the reference.
```

Cada identidade gera só o `idle_00`, anexando a arte estática do alvo. Salvar como `<id>_idle_00_v01.png`.

## I01 — `bolha_de_slime_idle_00`

Referência: `assets/enemies/bolha_de_slime.png`. Cúpula de gosma verde com bolhas internas e um crânio com ossos dentro, base larga aderida ao chão. A translucência é do desenho original: gerar com casca verde sólida e opaca. Pose: parada, bolhas internas se movendo levemente.

## I02 — `cultista_thullgrime_idle_00`

Referência: `assets/enemies/cultista_thullgrime.png`. Humanoide encapuzado de farrapos verde-musgo, máscara de osso com tentáculos no rosto, bolsa e talismã no cinto, botas de couro e cajado retorcido com um cacho de olhos roxos na ponta, segurado na mão esquerda. Pose: parado, apoia o cajado no chão, tentáculos do rosto balançando de leve.

## I03 — `blogbog_idle_00`

Referência: `assets/enemies/blogbog.png`. Guardião-cogumelo gigante: chapéu marrom largo no topo, corpo de raízes e madeira retorcidas, núcleo verde luminoso no peito, gosma verde escorrendo, braços longos de raízes. Pose: parado, núcleo do peito pulsando, gosma escorrendo presa.

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

### `bolha_de_slime` — Bolha de Slime
- Identidade fixa: Cúpula de gosma verde com bolhas internas e um crânio com ossos dentro, base larga aderida ao chão. A translucência é do desenho original: gerar com casca verde sólida e opaca.
- `idle`: parada, bolhas internas se movendo levemente.
- `move`: rola e desliza para a direita: a frente se alonga, a cúpula comprime e estica.
- `attack`: a cúpula se projeta contra a direita e comprime no impacto.
- `death`: a cúpula estoura em uma poça baixa e compacta com o crânio visível.

### `cultista_thullgrime` — Cultista de Ghaunadaur
- Identidade fixa: Humanoide encapuzado de farrapos verde-musgo, máscara de osso com tentáculos no rosto, bolsa e talismã no cinto, botas de couro e cajado retorcido com um cacho de olhos roxos na ponta, segurado na mão esquerda.
- `idle`: parado, apoia o cajado no chão, tentáculos do rosto balançando de leve.
- `move`: passos arrastados, cajado sempre na mesma mão, farrapos balançando.
- `attack`: ergue o cajado e aponta para a direita, sem círculo mágico nem projétil.
- `death`: joelhos cedem, o cajado cai junto ao corpo sem se soltar, tomba de lado.

### `blogbog` — Blogbog
- Identidade fixa: Guardião-cogumelo gigante: chapéu marrom largo no topo, corpo de raízes e madeira retorcidas, núcleo verde luminoso no peito, gosma verde escorrendo, braços longos de raízes.
- `idle`: parado, núcleo do peito pulsando, gosma escorrendo presa.
- `move`: passos pesados de raiz sobre raiz, braços balançando, chapéu estável.
- `attack`: esmaga com os dois braços de raízes para a direita.
- `death`: o núcleo apaga, o corpo desmorona em raízes e chapéu, tudo unido, imóvel.
- `special_00`–`special_05` (6 quadros): enraíza e floresce: ergue os braços de raízes, o núcleo do peito brilha no máximo e o chapéu se abre, sem partículas soltas. Sequência: antecipação, início, subida, pico, sustentação, recuperação.

## Critérios de rejeição imediata

- Orientação para a esquerda, corte de asa, arma, braço ou cauda, escala diferente do `idle_00`, fundo não transparente.
- Gosma, névoa, chama, fungo ou corrente translúcidos, desfocados ou soltos; partículas, círculos mágicos, projéteis ou respingos separados.
- Troca de mão da arma, membros duplicados, texto, UI, cenário, sombra no chão ou segundo personagem.
- Solidez abaixo de 0,90 (0,79 apenas para o que é translúcido por desenho: `alma_penada`, `bolha_de_slime`).
