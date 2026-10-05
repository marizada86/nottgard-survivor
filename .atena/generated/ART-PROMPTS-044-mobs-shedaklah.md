---
id: "ART-PROMPTS-044"
type: "prompts-de-arte"
title: "Animações dos inimigos de Shedaklah — identidade e ciclos"
status: "oito identidades v03 aprovadas; oito alvos integrados; 166 quadros/33 tiras"
created: "2026-10-01"
relations: ["[[PLAN-041-animacao-padrao-zumbi-para-inimigos-e-interacoes-2026-09-29]]", "[[PLAN-048-geracao-animacoes-mobs-onda-1-2026-09-30]]", "[[ART-PROMPTS-033-mobs-onda-1-lote-a]]"]
---

# ART-PROMPTS-044 — Shedaklah (Andar 222 · fungo e slime)

Segue a receita da Onda 1 (ART-PROMPTS-032 e 033), que o dono aprovou: **primeiro a identidade** (`idle_00`) de cada alvo, depois os demais quadros, cada um como imagem independente. Perfil A = 20 quadros (idle 4, move 6, attack 4, death 6). Perfil B (chefe) = 26 (mais `special` 6). Nenhuma imagem é asset oficial; tudo fica em `.atena/generated/art-candidates/enemies-shedaklah/<id>/`.

## Alvos deste lote

| Alvo | Nome | Perfil | Quadros | Referência estática |
|---|---|---|---:|---|
| `servo_de_zuggtmoy` | Servo de Zuggtmoy | A | 20 | `assets/enemies/servo_de_zuggtmoy.png` |
| `cogumelo_fungico` | Cogumelo Fúngico | A | 20 | `assets/enemies/cogumelo_fungico.png` |
| `esporo_voador` | Esporo Voador | A | 20 | `assets/enemies/esporo_voador.png` |
| `slime_de_juiblex` | Limo de Juiblex | A | 20 | `assets/enemies/slime_de_juiblex.png` |
| `pudim_negro` | Pudim Negro | A | 20 | `assets/enemies/pudim_negro.png` |
| `gargula` | Gárgula | A | 20 | `assets/enemies/gargula.png` |
| `receptaculo_de_juiblex` | Receptáculo de Juiblex | A | 20 | `assets/enemies/receptaculo_de_juiblex.png` |
| `zuggtmoy` | Zuggtmoy, Dama dos Fungos | B | 26 | `assets/enemies/zuggtmoy.png` |
| **Total** | | | **166** | |

## Contrato do gate de identidade

```text
Use the attached static sprite as the exact identity reference: preserve its unique silhouette, clothing or anatomy, palette, props, and visual hierarchy. Create one full-body game sprite in a neutral idle pose, viewed at a three-quarter front angle and facing to the RIGHT. Dark-fantasy isometric pixel art, crisp controlled dithering, opaque solid silhouette, no blur, no antialiasing, no motion lines. Centered; the visual base is anchored at the bottom; at least 8% side margin. Transparent background. No ground, cast shadow, scenery, gradient, text, logo, watermark, frame, UI, or extra character. Keep the subject isolated, readable, and at the same apparent scale as the reference.
```

Cada identidade gera só o `idle_00`, anexando a arte estática do alvo. Salvar como `<id>_idle_00_v01.png`.

## I01 — `servo_de_zuggtmoy_idle_00`

Referência: `assets/enemies/servo_de_zuggtmoy.png`. Orc de pele verde, musculoso, com máscara respiratória de couro, dreads escuros, ombreiras e manto de farrapos cobertos de cogumelos claros, cinto com medalhões e lança de osso e metal na mão direita. Pose: parado, lança apoiada baixa, ombros relaxados, cogumelos do manto balançando levemente presos ao corpo.

## I02 — `cogumelo_fungico_idle_00`

Referência: `assets/enemies/cogumelo_fungico.png`. Fungo ambulante com chapéu largo marrom-rosado inclinado, gotas rosadas penduradas na borda, tronco branco-rosado retorcido com raízes grossas como pernas e protuberâncias de esporos. Pose: parado, chapéu levemente inclinado, gotas oscilando presas ao chapéu.

## I03 — `esporo_voador_idle_00`

Referência: `assets/enemies/esporo_voador.png`. Esfera ocular rosa com boca circular de dentes no centro, gotas rosadas pingando e duas asas membranosas de morcego rosa-lilás. Voa; não tem pernas. Pose: flutua no lugar, subida e descida suaves, asas abrindo e fechando devagar.

## I04 — `slime_de_juiblex_idle_00`

Referência: `assets/enemies/slime_de_juiblex.png`. Massa alta de gosma verde-limão com vários olhos amarelos espalhados, braços grossos de gosma terminados em gotas pesadas e base larga aderida ao chão. Sem pernas. Pose: massa parada, olhos piscando de leve, superfície pulsando.

## I05 — `pudim_negro_idle_00`

Referência: `assets/enemies/pudim_negro.png`. Massa baixa e brilhante de limo preto-arroxeado que engoliu um crânio, uma espada e ossos, visíveis dentro da gosma. Sem pernas, base larga. Pose: massa parada, superfície brilhando e pulsando levemente.

## I06 — `gargula_idle_00`

Referência: `assets/enemies/gargula.png`. Gárgula de pedra cinza com musgo, quadrúpede agachada, asas de morcego semi-dobradas, garras longas e rosto de caveira felina com presas. Pose: agachada e parada, respiração mínima, asas dobradas.

## I07 — `receptaculo_de_juiblex_idle_00`

Referência: `assets/enemies/receptaculo_de_juiblex.png`. Versão grande e esguia do limo: corpo de gosma verde-limão com muitos olhos amarelos, braços longos de gosma e uma esfera verde luminosa e sólida no peito. Pose: massa parada, esfera do peito pulsando levemente, olhos piscando.

## I08 — `zuggtmoy_idle_00`

Referência: `assets/enemies/zuggtmoy.png`. Figura feminina alta fundida a uma árvore de cogumelos rosa-lilás em camadas, galhos brancos como braços com bulbos rosados, tronco de raízes entrelaçadas e saia de chapéus. Pose: parada e ereta, chapéus e bulbos balançando devagar.

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

### `servo_de_zuggtmoy` — Servo de Zuggtmoy
- Identidade fixa: Orc de pele verde, musculoso, com máscara respiratória de couro, dreads escuros, ombreiras e manto de farrapos cobertos de cogumelos claros, cinto com medalhões e lança de osso e metal na mão direita.
- `idle`: parado, lança apoiada baixa, ombros relaxados, cogumelos do manto balançando levemente presos ao corpo.
- `move`: passos pesados de caçador, lança sempre na mesma mão, cogumelos presos ao manto.
- `attack`: estocada de lança para a direita: recua o ombro, avança, ponto de impacto com a lança estendida.
- `death`: joelhos cedem, apoia-se na lança, tomba de lado e fica imóvel com a lança junto ao corpo.

### `cogumelo_fungico` — Cogumelo Fúngico
- Identidade fixa: Fungo ambulante com chapéu largo marrom-rosado inclinado, gotas rosadas penduradas na borda, tronco branco-rosado retorcido com raízes grossas como pernas e protuberâncias de esporos.
- `idle`: parado, chapéu levemente inclinado, gotas oscilando presas ao chapéu.
- `move`: caminhada lenta sobre as raízes, chapéu balançando, gotas sempre presas.
- `attack`: cabeçada: o chapéu se inclina para frente e golpeia à direita, sem esporos soltos.
- `death`: o chapéu desaba, o tronco dobra e o fungo murcha em um monte compacto, ainda inteiro no quadro.

### `esporo_voador` — Esporo Voador
- Identidade fixa: Esfera ocular rosa com boca circular de dentes no centro, gotas rosadas pingando e duas asas membranosas de morcego rosa-lilás. Voa; não tem pernas.
- `idle`: flutua no lugar, subida e descida suaves, asas abrindo e fechando devagar.
- `move`: voo para a direita com batida de asas alternando alta e baixa; o corpo sobe e desce, sem pernas.
- `attack`: mergulho com a boca aberta para a direita: recua, avança, ponto de mordida.
- `death`: asas travam, o corpo gira e cai, murcha no chão como esfera achatada com as asas dobradas.

### `slime_de_juiblex` — Limo de Juiblex
- Identidade fixa: Massa alta de gosma verde-limão com vários olhos amarelos espalhados, braços grossos de gosma terminados em gotas pesadas e base larga aderida ao chão. Sem pernas.
- `idle`: massa parada, olhos piscando de leve, superfície pulsando.
- `move`: a massa flui para a direita: a frente se alonga, a traseira acompanha; compressão e extensão alternadas.
- `attack`: um braço de gosma golpeia à direita: recua a massa, projeta o braço, ponto de impacto.
- `death`: derrete sobre si mesmo em uma poça alta e compacta com os olhos ainda visíveis.

### `pudim_negro` — Pudim Negro
- Identidade fixa: Massa baixa e brilhante de limo preto-arroxeado que engoliu um crânio, uma espada e ossos, visíveis dentro da gosma. Sem pernas, base larga.
- `idle`: massa parada, superfície brilhando e pulsando levemente.
- `move`: rasteja para a direita como lesma: a frente se estica, a traseira é puxada, ritmo pesado.
- `attack`: salta contra o alvo: encolhe, projeta a massa para a direita, ponto de impacto achatado.
- `death`: afunda e se espalha em uma poça baixa, os objetos engolidos ainda visíveis.

### `gargula` — Gárgula
- Identidade fixa: Gárgula de pedra cinza com musgo, quadrúpede agachada, asas de morcego semi-dobradas, garras longas e rosto de caveira felina com presas.
- `idle`: agachada e parada, respiração mínima, asas dobradas.
- `move`: marcha pesada de quadrúpede, as quatro patas alternando, asas semi-dobradas sem bater.
- `attack`: golpe de garra da pata direita e mordida: recua o peito, avança a cabeça, ponto de impacto.
- `death`: a pedra racha e as pernas cedem; desaba de lado com asas abertas, todos os fragmentos ainda unidos ao corpo.

### `receptaculo_de_juiblex` — Receptáculo de Juiblex
- Identidade fixa: Versão grande e esguia do limo: corpo de gosma verde-limão com muitos olhos amarelos, braços longos de gosma e uma esfera verde luminosa e sólida no peito.
- `idle`: massa parada, esfera do peito pulsando levemente, olhos piscando.
- `move`: desliza para a direita em passos de gosma, braços balançando, esfera no peito sempre visível.
- `attack`: os dois braços longos golpeiam para a direita: recua, projeta, ponto de impacto.
- `death`: a esfera apaga, o corpo desmorona em uma poça alta e compacta.

### `zuggtmoy` — Zuggtmoy, Dama dos Fungos
- Identidade fixa: Figura feminina alta fundida a uma árvore de cogumelos rosa-lilás em camadas, galhos brancos como braços com bulbos rosados, tronco de raízes entrelaçadas e saia de chapéus.
- `idle`: parada e ereta, chapéus e bulbos balançando devagar.
- `move`: desliza em passos lentos e majestosos, galhos balançando, saia de chapéus ondulando.
- `attack`: os galhos se projetam para a direita em golpe de chicote, bulbos na ponta.
- `death`: os galhos murcham, os chapéus caem, ela se curva e desaba em tronco murcho e inteiro.
- `special_00`–`special_05` (6 quadros): floração de esporos: abre os braços e os chapéus, os bulbos incham na ponta dos galhos, pico com tudo aberto, sem partículas soltas. Sequência: antecipação, início, subida, pico, sustentação, recuperação.

## Critérios de rejeição imediata

- Orientação para a esquerda, corte de asa, arma, braço ou cauda, escala diferente do `idle_00`, fundo não transparente.
- Gosma, névoa, chama, fungo ou corrente translúcidos, desfocados ou soltos; partículas, círculos mágicos, projéteis ou respingos separados.
- Troca de mão da arma, membros duplicados, texto, UI, cenário, sombra no chão ou segundo personagem.
- Solidez abaixo de 0,90 (0,79 apenas para o que é translúcido por desenho: `alma_penada`, `bolha_de_slime`).

2026-10-03: Servo, Cogumelo e Esporo integrados (60 quadros / 12 tiras), manifesto 88 PNGs. Suite zero falhas; smoke nove fases ok. Limo: sete novos quadros preservados (idle_01–03, move_00–03), mais idle_00 aprovado; faltam 12 quadros. Gerador bloqueado por HTTP 429 usage_limit_reached; liberação prevista 03/10/2026 10:19:52 America/Sao_Paulo. Pudim, Gargula, Receptaculo e Zuggtmoy aguardam 82 quadros; retomada total 94 prompts em shedaklah-resume-after-limit-2026-10-03.json. Nenhum ciclo incompleto foi admitido.
