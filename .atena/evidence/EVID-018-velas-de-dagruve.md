# EVID-018 — Velas de Dagruve

Data: 2026-09-24  
Spec: `SPEC-024-props-de-dagruve-velas`

## Decisão visual

Os primeiros candidatos de vela tinham ornamentação ritualística, incluindo um emblema não definido no lore. Eles foram rejeitados e nunca entraram no workspace. O lote integrado foi regenerado com a restrição explícita de não conter símbolos, runas, emblemas, bandeiras ou escrita.

## Autoridade e procedência

Foram usadas somente as referências aprovadas:

- `D:\dev\nottgard\games\IA\nottcard-ai\assets\world\props\vela.png`;
- `assets/props/pilar_01.png`;
- `assets/props/caixote_01.png` e `assets/props/caixote_02.png`.

Os três resultados são designs novos, não cópias.

## Entrega

| Asset final | Candidata | Silhueta |
| --- | --- | --- |
| `assets/props/velas_01.png` | `.atena/generated/asset-candidates/props/dagruve/velas_01_v01.png` | bandeja de madeira com três velas |
| `assets/props/velas_02.png` | `.atena/generated/asset-candidates/props/dagruve/velas_02_v01.png` | laje baixa com velas e copo de ferro |
| `assets/props/velas_03.png` | `.atena/generated/asset-candidates/props/dagruve/velas_03_v01.png` | lanterna prática de convés |

Cada candidata foi recebida em `1254x1254`, tinha alfa `0,0,0,0` nos quatro cantos e foi normalizada para `256x256` com transparência preservada.

## Validação

- O tipo `velas` foi integrado ao componente de props e às três instâncias de Dagruve.
- `tools/validate_generated_assets.ps1`: 245 arquivos, 216 com alfa, 0 erros.
- `D:\Godot\Godot_v4.7.2-stable_win64.exe --headless --path . -s tests/run_all.gd`: 0 falhas.
- A abertura headless do editor reimportou `velas_01.png` a `velas_03.png` com saída 0. Avisos de permissão do perfil local do Godot não afetaram a importação.
