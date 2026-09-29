---
id: "EVID-098"
title: "Candidatas do Lote A — quebráveis por bioma"
date: "2026-09-28"
status: "admitidas e verificadas"
relations:
  - "[[PLAN-035-geracao-de-assets-pendentes-2026-09-28]]"
  - "[[SPEC-062-fila-de-geracao-externa-de-assets]]"
  - "[[SPEC-063-objetos-quebraveis-e-rebalanceamento-de-pocao]]"
  - "[[ART-PROMPTS-024-cenario-e-quebraveis-por-bioma]]"
---

# EVID-098 — Candidatas do Lote A

## Autorização e método

O dono aprovou o PLAN-035 e liberou o Lote A nesta conversa. As imagens foram
geradas pelo gerador de imagem nativo, uma chamada por asset, usando os
prompts de quebráveis do `ART-PROMPTS-024` normalizados para saída RGBA com
fundo realmente transparente. A direção isométrica, luz superior esquerda,
objeto único, ausência de texto/cenário e exigência de silhueta sólida foram
preservadas.

## Candidatas

| ID | Bioma | Candidata |
|---|---|---|
| `saco_de_esporos_quebravel` | Shedaklah | `.atena/generated/art-candidates/breakables/saco_de_esporos_quebravel_v01.png` |
| `casulo_viscoso_quebravel` | Molor | `.atena/generated/art-candidates/breakables/casulo_viscoso_quebravel_v01.png` |
| `urna_funeraria_quebravel` | Durao | `.atena/generated/art-candidates/breakables/urna_funeraria_quebravel_v01.png` |
| `lanterna_de_papel_quebravel` | Feng-tu | `.atena/generated/art-candidates/breakables/lanterna_de_papel_quebravel_v01.png` |
| `espelho_ilusorio_quebravel` | Shendilavri | `.atena/generated/art-candidates/breakables/espelho_ilusorio_quebravel_v01.png` |
| `estatua_rachada_quebravel` | Goranthis | `.atena/generated/art-candidates/breakables/estatua_rachada_quebravel_v01.png` |
| `relicario_instavel_quebravel` | Pilares | `.atena/generated/art-candidates/breakables/relicario_instavel_quebravel_v01.png` |

## Verificação técnica

- Sete arquivos PNG foram copiados para a área de candidatas; nenhum arquivo
  sob `assets/` foi alterado.
- Todos são `Format32bppArgb`, com alfa zero nos cantos (um canto da candidata
  de esporos mede alfa 1, ainda efetivamente transparente) e dimensões entre
  1145×1374 e 1297×1212 px.
- A geração preserva uma figura única e centralizada; a inspeção artística em
  escala de jogo e a seleção de uma versão ainda são gates pendentes.

## Admissão aprovada

O dono aprovou as sete candidatas nesta conversa. Cada uma foi normalizada com
`Contain` e nearest-neighbor para 320×480 RGBA e substituiu somente o PNG de
mesmo ID em `assets/enemies/`. Os sete placeholders anteriores foram copiados
para `.atena/evidence/EVID-098-pre-admission-backup/assets/enemies/` antes da
substituição.

| ID | SHA-256 da versão admitida |
|---|---|
| `saco_de_esporos_quebravel` | `8ed752e820644dc73193c8f3dfa91fd11c7af9a1be1e54594dbaf521a919c5a0` |
| `casulo_viscoso_quebravel` | `22ac965cf1fe542ec6f5dc1716e701988d35f10b36ceba1c1ae5b2f7cae35f47` |
| `urna_funeraria_quebravel` | `d196d8805dc1f42a78148bca37b4d37ed2c5170c3558efa30511945939ef0d3a` |
| `lanterna_de_papel_quebravel` | `0e2ed3c6c603d5b3c58f5057e9b8a2ca0cc18de46eaa8df9a6c098c7ee522092` |
| `espelho_ilusorio_quebravel` | `1fb7067f320c2ab70218de25fe451522a362eb6d0cd4df1db912aa522987e0a8` |
| `estatua_rachada_quebravel` | `e3647bbd5a2250501875f9c8f0c5c02e4eb6d248cb88d5f83e1f12e9528ae8e5` |
| `relicario_instavel_quebravel` | `f06ef3ccbb2fcff9bc2820d1dcef70b53ac7bd97b7271b01f73430f72a1f3a38` |

## Validação pós-admissão

- O reimportador do Godot processou os PNGs substituídos.
- Os sete arquivos finais são `Format32bppArgb`, 320×480, com alfa zero no
  canto superior esquerdo.
- `godot --headless --path . -s tests/run_all.gd`: `testes: 0 falha(s)`.
- `godot --headless --path . res://tools/smoke.tscn`: as nove fases chegaram
  ao estado `running`; `smoke: ok`.
- O ambiente ainda emite avisos conhecidos por não poder gravar logs em
  `user://` e objetos do renderer liberados ao sair, mas nenhum teste ou smoke
  falhou.
