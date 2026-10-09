---
id: "ART-PROMPTS-050"
type: "prompts-de-arte"
title: "Animações dos inimigos de Pilares — identidade e ciclos"
status: "concluido localmente — 26 fontes, 5 tiras e build validada; playtest humano pendente"
created: "2026-10-01"
relations: ["[[PLAN-041-animacao-padrao-zumbi-para-inimigos-e-interacoes-2026-09-29]]", "[[PLAN-048-geracao-animacoes-mobs-onda-1-2026-09-30]]", "[[ART-PROMPTS-033-mobs-onda-1-lote-a]]"]
---

# ART-PROMPTS-050 — Pilares (Modo infinito · o céu é puxado para cá)

Segue a receita da Onda 1 (ART-PROMPTS-032 e 033), que o dono aprovou: **primeiro a identidade** (`idle_00`) de cada alvo, depois os demais quadros, cada um como imagem independente. Perfil A = 20 quadros (idle 4, move 6, attack 4, death 6). Perfil B (chefe) = 26 (mais `special` 6). Nenhuma imagem é asset oficial; tudo fica em `.atena/generated/art-candidates/enemies-pilares/<id>/`.

## Alvos deste lote

| Alvo | Nome | Perfil | Quadros | Referência estática |
|---|---|---|---:|---|
| `sintese_abissal` | A Síntese Abissal | B | 26 | `assets/enemies/sintese_abissal.png` |
| **Total** | | | **26** | |

### Reuso (nada a gerar)

- Todos os outros inimigos de Pilares (`cultista_ghaunadaur`, `limo`, `guardiao_de_goranthis`, `demonio_de_gehenna`, `sucubo`, `aberracao_shu`, `master_of_cruelties`, `death_tyrant`, `molydeus_menor`) **já são cobertos** pelos lotes de Feng Tu, Shedaklah, Durao, Shendilavri e Goranthis. Esta é a menor remessa: um chefe só.

## Contrato do gate de identidade

```text
Use the attached static sprite as the exact identity reference: preserve its unique silhouette, clothing or anatomy, palette, props, and visual hierarchy. Create one full-body game sprite in a neutral idle pose, viewed at a three-quarter front angle and facing to the RIGHT. Dark-fantasy isometric pixel art, crisp controlled dithering, opaque solid silhouette, no blur, no antialiasing, no motion lines. Centered; the visual base is anchored at the bottom; at least 8% side margin. Transparent background. No ground, cast shadow, scenery, gradient, text, logo, watermark, frame, UI, or extra character. Keep the subject isolated, readable, and at the same apparent scale as the reference.
```

Cada identidade gera só o `idle_00`, anexando a arte estática do alvo. Salvar como `<id>_idle_00_v01.png`.

## I01 — `sintese_abissal_idle_00`

Referência: `assets/enemies/sintese_abissal.png`. Fusão colossal: asa de morcego carmesim à esquerda, braço direito como gaiola de ferro, tronco de raízes brancas com cogumelos rosados, núcleo roxo luminoso no peito e mão com sino-lampião pingando verde. Pose: ereto e imponente, núcleo roxo pulsando, gaiola e sino balançando de leve.

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

### `sintese_abissal` — A Síntese Abissal
- Identidade fixa: Fusão colossal: asa de morcego carmesim à esquerda, braço direito como gaiola de ferro, tronco de raízes brancas com cogumelos rosados, núcleo roxo luminoso no peito e mão com sino-lampião pingando verde.
- `idle`: ereto e imponente, núcleo roxo pulsando, gaiola e sino balançando de leve.
- `move`: passos muito pesados, gaiola e sino balançando presos, asa estável.
- `attack`: golpe da gaiola de ferro para a direita.
- `death`: o núcleo apaga, o tronco racha, o corpo desaba em bloco, tudo unido e imóvel.
- `special_00`–`special_05` (6 quadros): o núcleo roxo pulsa no máximo, o braço-gaiola avança e o sino balança, pico com tudo aberto, sem raios nem efeitos soltos. Sequência: antecipação, início, subida, pico, sustentação, recuperação.

## Critérios de rejeição imediata

- Orientação para a esquerda, corte de asa, arma, braço ou cauda, escala diferente do `idle_00`, fundo não transparente.
- Gosma, névoa, chama, fungo ou corrente translúcidos, desfocados ou soltos; partículas, círculos mágicos, projéteis ou respingos separados.
- Troca de mão da arma, membros duplicados, texto, UI, cenário, sombra no chão ou segundo personagem.
- Solidez abaixo de 0,90 (0,79 apenas para o que é translúcido por desenho: `alma_penada`, `bolha_de_slime`).
