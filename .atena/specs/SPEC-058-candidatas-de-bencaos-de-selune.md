---
id: "SPEC-058"
type: "especificação delimitada"
title: "Candidatas de ícones para as bênçãos de Selûne"
status: "implementada e reconciliada"
created: "2026-09-27"
approved: "2026-09-27"
relations:
  - "[[SPEC-056-sobreposicao-visual-das-divindades]]"
  - "[[ART-PROMPTS-010-icones-passivas-bencaos-ui]]"
  - "[[EVID-087-icones-de-bencaos-de-selune-2026-09-27]]"
---

# SPEC-058 — Candidatas de ícones para as bênçãos de Selûne

## Intenção e escopo

Produzir uma candidata raster inédita para cada ícone de bênção de Selûne já
presente em `data/boons.json` e ainda ausente do jogo:

| ID | Destino de candidata | Leitura necessária |
|---|---|---|
| `selune_luar` | `.atena/generated/art-candidates/icons/boons/selune_luar_v01.png` | crescente azul-luar prateado protegendo uma gota de vida, sem texto |
| `selune_guia` | `.atena/generated/art-candidates/icons/boons/selune_guia_v01.png` | crescente azul-luar prateado guiando uma estrela, sem texto |

Cada candidata deve ser um PNG 128×128 RGBA, com fundo realmente transparente,
silhueta reconhecível em 32–48 px e a linguagem dos demais ícones de bênção:
pixel art sombria, contorno escuro grosso, poucos blocos de cor e luz superior
esquerda.

## Não objetivos

- Não criar emblemas genéricos das divindades nem novos consumidores de UI.
- Não alterar lore, dados, regras de combate, paletas, cenas ou código.
- Não substituir nem criar arquivos sob `assets/` nesta etapa.
- Não incluir Helion como afinidade divina.

## Plano de voo aprovado

1. Gerar uma candidata por ID em fundo transparente.
2. Conferir transparência, dimensões, ausência de texto/marca-d'água e leitura
   na escala de ícone.
3. Apresentar as duas candidatas ao dono para aprovação visual explícita.
4. Somente após essa aprovação: copiar os arquivos selecionados para
   `assets/icons/boons/`, atualizar o manifesto, validar e registrar evidência.

## Critérios para a próxima decisão humana

- As duas candidatas estão visualmente coerentes entre si e com a paleta de
  Selûne (`#8CCBFF`, prata e branco).
- Luar Protetor comunica proteção e vida; Guia das Estrelas comunica direção e
  coleta/movimento sem texto ou números.
- Nenhuma candidata introduz símbolo religioso, personagem, moldura, cenário,
  texto ou watermark não aprovados.

## Reconciliação

O dono aprovou visualmente as candidatas `v01` em 2026-09-27. Elas foram
integradas como `assets/icons/boons/selune_luar.png` e
`assets/icons/boons/selune_guia.png`, registradas no manifesto oficial e
validadas conforme `EVID-087`.
