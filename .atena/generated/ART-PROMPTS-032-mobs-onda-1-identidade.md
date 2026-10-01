---
id: "ART-PROMPTS-032"
type: "prompts-de-arte"
title: "Gate de identidade — mobs da Onda 1"
status: "oito identidades aprovadas pelo dono em 2026-09-30"
created: "2026-09-30"
relations: ["[[PLAN-048-geracao-animacoes-mobs-onda-1-2026-09-30]]", "[[PLAN-041-animacao-padrao-zumbi-para-inimigos-e-interacoes-2026-09-29]]"]
sources: ["assets/enemies", "assets/animations/enemies/zumbi/idle.png", "data/enemies.json"]
---

# ART-PROMPTS-032 — Gate de identidade dos mobs da Onda 1

Cada prompt gera apenas o `idle_00` do alvo. A arte estática indicada deve ser
anexada como referência de identidade; a imagem não é um asset oficial e será
salva somente em `.atena/generated/art-candidates/enemies-wave-1/<id>/`.

## Contrato comum

```text
Use the attached static sprite as the exact identity reference: preserve its unique silhouette, clothing or anatomy, palette, props, and visual hierarchy. Create one full-body game sprite in a neutral idle pose, viewed at a three-quarter front angle and facing to the RIGHT. Dark-fantasy isometric pixel art, crisp controlled dithering, opaque solid silhouette, no blur, no antialiasing, no motion lines. Centered; the visual base is anchored at the bottom; at least 8% side margin. Transparent background. No ground, cast shadow, scenery, gradient, text, logo, watermark, frame, UI, or extra character. Keep the subject isolated, readable, and at the same apparent scale as the reference.
```

## I01 — `slime_corrosivo_idle_00`

Referência: `assets/enemies/slime_corrosivo.png`. Slime ácido amarelo-esverdeado,
alto e assimétrico, superfície viscosa com bolhas, veios roxos, boca serrilhada
e correia de metal rompida. Pose: massa parada, gotas suspensas e bolhas leves;
sem pernas e sem humanoide.

## I02 — `cultista_arqueiro_idle_00`

Referência: `assets/enemies/cultista_arqueiro.png`. Arqueiro cultista encapuzado,
robes azul-acinzentadas gastas com tiras ameixa e cera amarela, símbolo de olho
no rosto escondido, botas enroladas e arco de madeira escura. Pose: arco baixo,
flecha não retesada, pronto para disparar à direita.

## I03 — `cultista_cajado_idle_00`

Referência: `assets/enemies/cultista_cajado.png`. Cultista alto de robe azul-escuro
e ameixa coberto de cera derretida, capuz com olho dourado e cajado retorcido com
lampião de chama quente. Pose: apoia o cajado no chão; chama estável, sem VFX de
ataque.

## I04 — `notivago_idle_00`

Referência: `assets/enemies/notivago.png`. Humanoide curvado de pele azul-acinzentada,
olho laranja, roupas e correias escuras rasgadas, longos braços e pernas de garras,
névoa roxa em faixas sobre os ombros. Pose: agachado e predatório, ainda legível;
a névoa é parte sólida da silhueta, sem transparência.

## I05 — `criatura_corrompida_idle_00`

Referência: `assets/enemies/criatura_corrompida.png`. Criatura humanoide corrompida
pela névoa, musculatura cinza-pálida, olhos magenta, fissuras e tendões roxos,
dedos alongados com garras vermelhas, vapor escuro ao redor da cabeça e dos pés.
Pose: postura inclinada e ameaçadora; vapor opaco, sem partículas soltas.

## I06 — `arch_hag_idle_00`

Referência: `assets/enemies/arch_hag.png`. Bruxa anciã magra, cabelos longos brancos,
rosto pálido, robe naval coberto de algas, conchas, cordas e medalhões; cajado com
lampião de vidro e chama verde-azulada na mão livre. Pose: olha para a direita,
lampião pendente, chama controlada como parte da silhueta.

## I07 — `tentaculo_kraken_idle_00`

Referência: `assets/enemies/tentaculo_kraken.png`. Tentáculo colossal de kraken
azul-escuro curvado, ventosas claras expostas, cordas e estacas, gotículas e espuma
na base. Pose: imóvel e arqueado para a direita; manter a base de água como parte
sólida do sprite, sem cenário.

## I08 — `guardiao_verdadeiro_idle_00`

Referência: `assets/enemies/guardiao_verdadeiro.png`. Guardião alado angelical de
armadura marfim e prata, penas cinza-escuras com veios violeta, olhos e runas
violeta luminosos, lança alta com ponta cristalina roxa. Pose: ereto e imponente,
lança apoiada; asas abertas mas inteiras dentro da célula. Sem aura, projéteis ou
telegráfos.

## Critérios de rejeição imediata

- Orientação para a esquerda, corte de asas/arma/tentáculo, escala incompatível,
  fundo não transparente, duplicação de membros ou objeto.
- Névoa, chama, água ou gosma translúcidas, desfocadas ou desconectadas.
- Qualquer texto, UI, cenário, sombra no chão ou segundo personagem.
