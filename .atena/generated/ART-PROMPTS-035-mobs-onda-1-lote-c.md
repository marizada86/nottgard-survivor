---
id: "ART-PROMPTS-035"
type: "prompts-de-arte"
title: "Ciclos de animação dos mobs — Onda 1, Lote C"
status: "40 quadros candidatos aprovados pelo dono; reuso da cópia requer decisão visual"
created: "2026-09-30"
relations: ["[[PLAN-048-geracao-animacoes-mobs-onda-1-2026-09-30]]", "[[EVID-133-lote-b-mobs-2026-09-30]]", "[[CANDIDATES-MANIFEST-003]]"]
sources: ["assets/enemies/tentaculo_kraken.png", "assets/enemies/guardiao_verdadeiro.png"]
---

# ART-PROMPTS-035 — Ciclos do Lote C

## Referências e destino

Para cada imagem, usar como referência 1 a arte oficial estática correspondente
e como referência 2 o `idle_00` aprovado em
`.atena/generated/art-candidates/enemies-wave-1/<id>/`. Preservar identidade,
paleta, escala, câmera e orientação. Gerar um quadro individual por ID e salvar
as candidatas finais em `.atena/generated/art-candidates/enemies-wave-1/<id>/frames/`.

## Base fixa para cada geração

```text
Use case: stylized-concept. Asset type: one full-body 2D game animation sprite frame. Create exactly one independent frame for the specified pose, not a strip or contact sheet. Use Image 1 as the exact official identity reference and Image 2 as the approved idle_00 reference for exact identity, palette, scale, proportion, camera, and facing. Dark-fantasy isometric pixel art, three-quarter front view, facing RIGHT, crisp pixel edges and controlled dithering. Center the complete subject in a tall 2:3 frame; preserve the approved apparent scale and bottom visual anchor. Genuinely transparent RGBA background; opaque, attached character silhouette. No ground, cast shadow, scenery, gradient, text, logo, watermark, border, UI, extra character, blur, antialiasing, motion lines, loose particles, detached magic, detached body parts, or redesign. Keep every part of the subject within the canvas.
```

Generate source images at 1024×1536, then reduce using nearest-neighbor to the
native cell: 256×384 for the tentacle or 320×480 for the guardian. Preserve
alpha. One prompt ID maps to one image; do not synthesize sprite strips.

## I07 — `tentaculo_kraken` — perfil C

Tentáculo colossal azul-escuro, curvado e arqueado para a direita; ventosas
claras expostas; cordas e estacas presas à anatomia; gotículas e espuma da base
permanecem como partes sólidas e conectadas do sprite. É uma criatura imóvel:
não criar passos nem transladar a base entre quadros. Manter a curva ampla dentro
da célula, sem cortar ponta, tentáculo, estacas ou espuma.

### `idle_01`–`idle_03`

- `idle_01`: pequena contração no meio da curva; base fixa e ponta quase parada.
- `idle_02`: leve balanço da ponta para a direita, sem alterar o arco geral.
- `idle_03`: relaxa em direção à curva neutra do `idle_00`, para fechar o loop.

### `attack_00`–`attack_03`

- `attack_00`: enrola a ponta para trás, preparação legível; base fixa.
- `attack_01`: estende e chicoteia a ponta para a direita, sem sair da célula.
- `attack_02`: ápice do golpe, curva esticada e ventosas visíveis; sem alvo ou
  efeito separado.
- `attack_03`: recolhe a ponta em direção à curva neutra; base e espuma fixas.

### `death_00`–`death_05`

- `death_00`: contração súbita da curva.
- `death_01`: arco perde tensão e a ponta começa a baixar.
- `death_02`: corpo inclina-se para a base; cordas e estacas continuam presas.
- `death_03`: tentáculo parcialmente recolhido e mais baixo, ainda inteiro.
- `death_04`: colapsa sobre a própria base, inteiramente dentro da célula.
- `death_05`: pose final imóvel, compacta e legível; espuma conectada.

## I08 — `guardiao_verdadeiro` — perfil B, chefe

Guardar a identidade do guardião alado: armadura marfim e prata, penas cinza-
escuras com veios violeta, olhos e runas violetas luminosos, lança alta de ponta
cristalina roxa. Figura ereta e imponente; lança sempre na mão, asas completas,
ambos os pés ancorados e corpo com escala coerente. A célula 320×480 foi
reservada para caber asas e lança sem corte. As habilidades especiais são poses
corporais: sem aura, raio, projétil, círculo mágico ou telegráfo separado.

### `idle_01`–`idle_03`

- `idle_01`: respiração discreta; lança apoiada, asas mantêm a forma.
- `idle_02`: pequeno ajuste de peso, sem deslocar a base nem baixar a lança.
- `idle_03`: retorna naturalmente à postura de `idle_00` para fechar o loop.

### `move_00`–`move_05`

- `move_00`: contato, pé da frente inicia passo para a direita.
- `move_01`: transferência de peso e leve flexão dos joelhos.
- `move_02`: passagem do pé traseiro, torso estabiliza.
- `move_03`: contato alternado com a outra perna à frente.
- `move_04`: transferência sobre o apoio oposto, leve balanço das asas.
- `move_05`: passada de fechamento, pronta para reiniciar sem salto.

Lança firmemente empunhada em todos os quadros; asas não encobrem todo o corpo
nem ultrapassam o enquadramento.

### `attack_00`–`attack_03`

- `attack_00`: preparação curta, lança recua sem perder a empunhadura.
- `attack_01`: investida da lança para a direita, corpo acompanha o movimento.
- `attack_02`: ápice do golpe e extensão completa, ponta ainda dentro da célula.
- `attack_03`: recolhe a lança e recupera a guarda, sem VFX.

### `death_00`–`death_05`

- `death_00`: reação compacta ao impacto, sem ferimento gráfico.
- `death_01`: joelhos cedem e as asas começam a baixar.
- `death_02`: perde equilíbrio e desce, lança ainda presa à mão.
- `death_03`: queda semi-ajoelhada, asas dobram sem cortar.
- `death_04`: colapso controlado sobre os joelhos/base; corpo, asas e lança
  continuam totalmente visíveis.
- `death_05`: pose final estática, inteiramente dentro da célula.

### `special_00`–`special_05`

- `special_00`: postura mais ampla, lança erguida junto ao corpo — começo da
  habilidade, sem energia solta.
- `special_01`: abre as asas ao máximo dentro do quadro e prepara o movimento.
- `special_02`: pose central de poder, lança acima do ombro e torso firme.
- `special_03`: gesto decisivo da lança para a frente; a pose, não um VFX,
  comunica a habilidade.
- `special_04`: pausa em postura forte de conclusão; sem aura ou projétil.
- `special_05`: retorna à guarda neutra do `idle_00`.

O `special` não altera o desenho da criatura, não substitui a lança e não
introduz um ataque à distância. Preservar anatomia, número de asas, membros,
dedos e mãos ao longo de todo o ciclo.

## Correções internas antes da revisão

Nas duas pranchas, o primeiro `death_05` voltava a uma pose mais ereta que o
quadro anterior. Foram substituídos por `tentaculo_kraken_death_05_v02.png` e
`guardiao_verdadeiro_death_05_v02.png`, usando o `death_04` como referência
adicional de continuidade. As versões v01 permanecem como superseded; a fila e
o manifesto selecionam v02.
