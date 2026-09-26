# EVID-024 — Carga abandonada de Dagruve

Data: 2026-09-24  
Spec: `SPEC-030-props-de-dagruve-carga`

## Autoridade e procedência

Foram usadas apenas referências internas aprovadas:

- `assets/props/doca_01.png`, `assets/props/doca_02.png` e `assets/props/doca_03.png`;
- `assets/props/caixote_01.png`, `assets/props/caixote_02.png` e `assets/props/caixote_03.png`.

As três saídas são designs originais, sem rótulos, texto, símbolos, runas, emblemas ou conteúdo identificável.

## Entrega

| Asset final | Candidata | Silhueta |
| --- | --- | --- |
| `assets/props/carga_01.png` | `.atena/generated/asset-candidates/props/dagruve/carga_01_v01.png` | dois sacos, pacote amarrado e lona enrolada |
| `assets/props/carga_02.png` | `.atena/generated/asset-candidates/props/dagruve/carga_02_v01.png` | saco achatado, rolos de lona e pacote dobrado |
| `assets/props/carga_03.png` | `.atena/generated/asset-candidates/props/dagruve/carga_03_v01.png` | saco compacto apoiado em dois rolos de tecido |

Cada candidata veio em `1254x1254`, tinha alfa `0,0,0,0` nos quatro cantos e foi normalizada para `256x256` com transparência preservada.

## Validação

- O tipo `carga` foi integrado ao componente de props e a três instâncias de Dagruve.
- `tools/validate_generated_assets.ps1`: 263 arquivos, 234 com alfa, 0 erros.
- `D:\Godot\Godot_v4.7.2-stable_win64.exe --headless --path . -s tests/run_all.gd`: 0 falhas.
- A abertura headless do editor reimportou `carga_01.png` a `carga_03.png` com saída 0. Avisos do perfil local do Godot não afetaram a importação.
