# EVID-110 — Lote 1: admissão de arte

Data: 2026-09-29  
Origem: `ART-PROMPTS-025`, `CHATGPT-FILA-001`, aprovação explícita do dono.

## Decisão

O dono aprovou P01–P08. Os oito assets aprovados foram normalizados e
admitidos; as candidatas brutas permanecem em
`.atena/generated/art-candidates/lote-1/`.

## Admissões

| Prompt | Candidata | Oficial | SHA-256 |
|---|---|---|---|
| P01 `nevoa_textura_01` | `nevoa_textura_01_v03.png` | `assets/fx/nevoa_textura_01.png` | `4e9eeeb1acb29a580c022b4b7787d7281722f902c22f7ac3c06dc3a54b7a59cd` |
| P02 `nevoa_borda_01` | `nevoa_borda_01_v01.png` | `assets/fx/nevoa_borda_01.png` | `0f9b43b5bfeddbbcd7582c203df054e419902c33d426277a333a2eac261ac064` |
| P03 `bau_chefe_fechado` | `bau_chefe_fechado_v01.png` | `assets/interactions/bau_chefe_fechado.png` | `b08c6170b9880ea4d807519ecd30e71082af74db0568aa66ad8a200a108f63f6` |
| P04 `bau_chefe_aberto` | `bau_chefe_aberto_v01.png` | `assets/interactions/bau_chefe_aberto.png` | `1beeb4f8e543f9186bcf11f31e822497eadc134618b7971c32da012cf27f7d5e` |
| P05 `ima_xp` | `ima_xp_v01.png` | `assets/pickups/magnet.png` | `0683ccadc0dd76209cad3ad8932dd117053b2e400133d09647ed65aa4406d0c3` |
| P06 `npc_loja` | `npc_loja_v01.png` | `assets/interactions/loja.png` | `b7c092ab509af9687288004d3b0c693f470487b8bd4dbea2f46b353f336afba7` |
| P07 `npc_ferreiro` | `npc_ferreiro_v01.png` | `assets/interactions/ferreiro.png` | `d1ceebecf889cde151fc51d29558ee0e7b0a06ca7a802e843edc3a3ee6344ab0` |
| P08 `npc_curandeiro` | `npc_curandeiro_v01.png` | `assets/interactions/curandeiro.png` | `ef6656e0c333193a1d8e427a347ce43394dcaacbcc4fab2f5c96ea3eac998f0b` |

P01 foi convertida de branco-sobre-preto para alfa por luminância e sua
normalização de emenda atingiu diferenças médias de borda de 0,0072 (esquerda/
direita) e 0,0128 (topo/base), em escala RGBA 0–255. P02 foi convertida pelo
mesmo método e aplicada como borda de névoa nas quatro margens da run. P03–P04
estão prontos para a mecânica de baú de chefe; P05 e P06–P08 já são carregados
pelos caminhos existentes de pickup e interação.

## Histórico de exceção resolvida

As candidatas P01 v01 e v02 falharam o teste de emenda, com diferença média de
borda acima de 30 níveis RGB nas duas direções. A v03 foi normalizada antes da
admissão, passou no teste e substituiu a pendência sem reaproveitar as versões
rejeitadas.

## Validação

- Auditoria de dimensões e alfa executada antes da admissão.
- `tests/run_all.gd` e `tools/smoke.tscn` foram executados em modo headless e
  encerraram com código 0.
- A captura visual automatizada da cena não foi materializada pelo renderer
  headless; a revisão humana da prancha e da prévia 3×3 foi a aprovação visual
  de P01–P08.
