---
id: "ART-PROMPTS-037"
type: "prompts-de-arte"
title: "Ciclo de animação — guardiao_copia"
status: "ciclo de 26 quadros aprovado visualmente; admissão no runtime pendente"
created: "2026-09-30"
relations:
  - "[[SPEC-108-ciclo-guardiao-copia]]"
  - "[[SPEC-107-piloto-visual-guardiao-copia]]"
  - "[[PLAN-048-geracao-animacoes-mobs-onda-1-2026-09-30]]"
  - "[[EVID-136-ciclo-guardiao-copia-2026-09-30]]"
sources:
  - "assets/enemies/guardiao_copia.png"
  - ".atena/generated/art-candidates/enemies-wave-1/guardiao_verdadeiro/frames/guardiao_verdadeiro_idle_01_v01.png"
  - ".atena/generated/art-candidates/enemies-wave-1/guardiao_verdadeiro/frames/guardiao_verdadeiro_idle_02_v01.png"
  - ".atena/generated/art-candidates/enemies-wave-1/guardiao_verdadeiro/frames/guardiao_verdadeiro_idle_03_v01.png"
  - ".atena/generated/art-candidates/enemies-wave-1/guardiao_verdadeiro/frames/guardiao_verdadeiro_move_00_v01.png"
  - ".atena/generated/art-candidates/enemies-wave-1/guardiao_verdadeiro/frames/guardiao_verdadeiro_move_01_v01.png"
  - ".atena/generated/art-candidates/enemies-wave-1/guardiao_verdadeiro/frames/guardiao_verdadeiro_move_02_v01.png"
  - ".atena/generated/art-candidates/enemies-wave-1/guardiao_verdadeiro/frames/guardiao_verdadeiro_move_03_v01.png"
  - ".atena/generated/art-candidates/enemies-wave-1/guardiao_verdadeiro/frames/guardiao_verdadeiro_move_04_v01.png"
  - ".atena/generated/art-candidates/enemies-wave-1/guardiao_verdadeiro/frames/guardiao_verdadeiro_move_05_v01.png"
  - ".atena/generated/art-candidates/enemies-wave-1/guardiao_verdadeiro/frames/guardiao_verdadeiro_attack_00_v01.png"
  - ".atena/generated/art-candidates/enemies-wave-1/guardiao_verdadeiro/frames/guardiao_verdadeiro_attack_01_v01.png"
  - ".atena/generated/art-candidates/enemies-wave-1/guardiao_verdadeiro/frames/guardiao_verdadeiro_attack_03_v01.png"
  - ".atena/generated/art-candidates/enemies-wave-1/guardiao_verdadeiro/frames/guardiao_verdadeiro_death_00_v01.png"
  - ".atena/generated/art-candidates/enemies-wave-1/guardiao_verdadeiro/frames/guardiao_verdadeiro_death_01_v01.png"
  - ".atena/generated/art-candidates/enemies-wave-1/guardiao_verdadeiro/frames/guardiao_verdadeiro_death_02_v01.png"
  - ".atena/generated/art-candidates/enemies-wave-1/guardiao_verdadeiro/frames/guardiao_verdadeiro_death_03_v01.png"
  - ".atena/generated/art-candidates/enemies-wave-1/guardiao_verdadeiro/frames/guardiao_verdadeiro_death_04_v01.png"
  - ".atena/generated/art-candidates/enemies-wave-1/guardiao_verdadeiro/frames/guardiao_verdadeiro_special_00_v01.png"
  - ".atena/generated/art-candidates/enemies-wave-1/guardiao_verdadeiro/frames/guardiao_verdadeiro_special_01_v01.png"
  - ".atena/generated/art-candidates/enemies-wave-1/guardiao_verdadeiro/frames/guardiao_verdadeiro_special_02_v01.png"
  - ".atena/generated/art-candidates/enemies-wave-1/guardiao_verdadeiro/frames/guardiao_verdadeiro_special_03_v01.png"
  - ".atena/generated/art-candidates/enemies-wave-1/guardiao_verdadeiro/frames/guardiao_verdadeiro_special_04_v01.png"
  - ".atena/generated/art-candidates/enemies-wave-1/guardiao_verdadeiro/frames/guardiao_verdadeiro_special_05_v01.png"
---

# ART-PROMPTS-037 — Ciclo da variante guardiao_copia

## Gate de transferência

A geração das 23 poses e a transferência das 24 referências nomeadas foram
autorizadas pelo dono em 2026-09-30. Para cada chamada, a imagem estática da
cópia é Image 1 (identidade) e exatamente uma pose correspondente de
guardiao_verdadeiro é Image 2 (pose do corpo, ação, composição e ancoragem).
Não enviar mais imagens.

## Prompt-base — usar em cada chamada

Use case: stylized-concept
Asset type: one 2D game animation frame
Primary request: Create exactly one independent full-body animation frame for guardiao_copia. Use Image 1 as the exact character identity reference: preserve its muted gray/silver armor, dark charcoal-gray wings, gold circular emblems and trim, face, proportions, and its own short gold-and-steel spear. Use Image 2 only for the body pose, action, composition, facing, and bottom anchor; do not copy its weapon or weapon length. Adapt the body pose to the copy.
Scene/backdrop: genuinely transparent background; no floor or scenery
Subject: the same guardiao_copia character in the exact pose/state named for this call
Style/medium: dark-fantasy pixel-art game sprite matching Image 1's hard-edged pixel clusters and restrained dithering; not a smooth painterly illustration
Composition/framing: full figure centered in a tall 2:3 frame matching a 320x480 game cell; three-quarter front view facing right; coherent character scale and stable bottom visual anchor; keep all body parts, wings, and spear inside the canvas
Constraints: transparent RGBA; one frame only, not a strip or contact sheet; keep the copy's gray/gold identity and exact short spear from Image 1. The final weapon is a small gold-and-steel spear with a short dark shaft and no crystal, no oversized blade, and no jewel; tip-to-butt length is about 45% of the character height and must stay below 55%. Image 2's long staff must be completely replaced and must not appear even as a silhouette. Preserve Image 2's torso, head, wings, and leg pose; the hand/arm holding the staff may be repositioned to grip the copy's short spear naturally. The spear angle may adapt to the action but its identity and short length may not. No purple runes, violet glow, violet feather veins, or bright eyes; no ground, cast shadow, gradient, text, logo, watermark, border, UI, extra character, blur, antialiasing, motion lines, loose particles, detached magic, detached body parts, redesign, or cropping
Avoid: transferring Image 2's identity, staff, crystal, weapon silhouette, or palette; any long polearm; adding effects not present in the body pose reference

## Adaptação explícita da arma por estado

Esta instrução acompanha cada prompt da tabela; a Image 2 fornece a pose do
corpo, não a posição da haste comprida nem o braço que a segura.

- idle e move: reposicionar o braço da arma se necessário e segurar a lança
  curta da cópia na diagonal à frente do corpo, como na Image 1.
- attack: usar a lança curta da cópia na ação indicada pela pose-fonte; manter
  o tamanho/forma da Image 1 e adaptar a mão, sem prolongar a arma.
- death: conservar a lança curta junto ao corpo e na mão quando a pose permitir;
  não reproduzir o cajado nem o cristal da pose-fonte.
- special: usar a lança curta na pose de corpo indicada, sem energia, brilho,
  runas, projéteis ou efeitos separados.

## Chamadas e fontes

Em cada linha, complementar o prompt-base com o estado/arquivo final e usar o
arquivo listado como única Image 2. Uma chamada independente por linha. O corpo
segue a pose-fonte; a arma e o braço que a segura são reinterpretados para
manter a lança curta da cópia, não a haste do verdadeiro.

| Saída candidata | Image 2 — somente pose |
|---|---|
| guardiao_copia_idle_01_v01.png | guardiao_verdadeiro_idle_01_v01.png |
| guardiao_copia_idle_02_v01.png | guardiao_verdadeiro_idle_02_v01.png |
| guardiao_copia_idle_03_v01.png | guardiao_verdadeiro_idle_03_v01.png |
| guardiao_copia_move_00_v01.png | guardiao_verdadeiro_move_00_v01.png |
| guardiao_copia_move_01_v01.png | guardiao_verdadeiro_move_01_v01.png |
| guardiao_copia_move_02_v01.png | guardiao_verdadeiro_move_02_v01.png |
| guardiao_copia_move_03_v01.png | guardiao_verdadeiro_move_03_v01.png |
| guardiao_copia_move_04_v01.png | guardiao_verdadeiro_move_04_v01.png |
| guardiao_copia_move_05_v01.png | guardiao_verdadeiro_move_05_v01.png |
| guardiao_copia_attack_00_v01.png | guardiao_verdadeiro_attack_00_v01.png |
| guardiao_copia_attack_01_v01.png | guardiao_verdadeiro_attack_01_v01.png |
| guardiao_copia_attack_03_v01.png | guardiao_verdadeiro_attack_03_v01.png |
| guardiao_copia_death_00_v01.png | guardiao_verdadeiro_death_00_v01.png |
| guardiao_copia_death_01_v01.png | guardiao_verdadeiro_death_01_v01.png |
| guardiao_copia_death_02_v01.png | guardiao_verdadeiro_death_02_v01.png |
| guardiao_copia_death_03_v01.png | guardiao_verdadeiro_death_03_v01.png |
| guardiao_copia_death_04_v01.png | guardiao_verdadeiro_death_04_v01.png |
| guardiao_copia_special_00_v01.png | guardiao_verdadeiro_special_00_v01.png |
| guardiao_copia_special_01_v01.png | guardiao_verdadeiro_special_01_v01.png |
| guardiao_copia_special_02_v01.png | guardiao_verdadeiro_special_02_v01.png |
| guardiao_copia_special_03_v01.png | guardiao_verdadeiro_special_03_v01.png |
| guardiao_copia_special_04_v01.png | guardiao_verdadeiro_special_04_v01.png |
| guardiao_copia_special_05_v01.png | guardiao_verdadeiro_special_05_v01.png |

## Pós-processamento e estado

Quando suportado, gerar em 1024×1536; preservar o original e o alfa; derivar a
célula final 320×480 por vizinho-mais-próximo. Todos os destinos de candidatos
são novos e ficam fora do runtime. A primeira saída de teste herdou o cajado
longo da pose-fonte e não foi selecionada; o prompt foi reforçado com prioridade
explícita para a lança curta da cópia antes de continuar as gerações.

## Resultado da geração

As 23 saídas selecionadas, os 23 originais e os hashes dos arquivos de saída e
das 24 referências autorizadas estão registrados em
[[EVID-136-ciclo-guardiao-copia-2026-09-30]]. Para `idle_01`, `attack_01` e
`death_01`, foi escolhida uma nova tentativa após a primeira imagem não atender
à instrução específica da pose/arma; tentativas não selecionadas permanecem
fora do pacote local de candidatos. Em 2026-09-30, o dono aprovou visualmente
os 23 quadros novos. A aprovação cobre os candidatos, não sua admissão no jogo;
os arquivos continuam fora do runtime até uma SPEC e decisão próprias.
