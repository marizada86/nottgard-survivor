# EVID-020 — Barris de Dagruve

Data: 2026-09-24  
Spec: `SPEC-026-props-de-dagruve-barris`

## Autoridade e procedência

Foram usadas apenas as referências aprovadas:

- `D:\dev\nottgard\games\IA\nottcard-ai\assets\world\props\barril.png`;
- `assets/props/caixote_01.png`, `assets/props/caixote_02.png` e `assets/props/caixote_03.png`.

Nenhum arquivo-fonte foi copiado. As três saídas são designs novos, sem texto, símbolo, runa ou marca de facção.

## Entrega

| Asset final | Candidata | Silhueta |
| --- | --- | --- |
| `assets/props/barril_01.png` | `.atena/generated/asset-candidates/props/dagruve/barril_01_v01.png` | barril em pé com corda |
| `assets/props/barril_02.png` | `.atena/generated/asset-candidates/props/dagruve/barril_02_v01.png` | barril quebrado deitado |
| `assets/props/barril_03.png` | `.atena/generated/asset-candidates/props/dagruve/barril_03_v01.png` | dupla de barris |

Cada candidata veio em `1254x1254`, tinha alfa `0,0,0,0` nos quatro cantos e foi normalizada para `256x256` com transparência preservada.

## Validação

- O tipo `barril` foi integrado ao componente de props e às três instâncias de Dagruve.
- `tools/validate_generated_assets.ps1`: 251 arquivos, 222 com alfa, 0 erros.
- `D:\Godot\Godot_v4.7.2-stable_win64.exe --headless --path . -s tests/run_all.gd`: 0 falhas.
- A abertura headless do editor reimportou `barril_01.png` a `barril_03.png` com saída 0. Avisos do perfil local do Godot não afetaram a importação.
