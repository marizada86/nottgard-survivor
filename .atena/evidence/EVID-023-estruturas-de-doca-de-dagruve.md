# EVID-023 — Estruturas de doca de Dagruve

Data: 2026-09-24  
Spec: `SPEC-029-props-de-dagruve-estrutura-de-doca`

## Autoridade e procedência

Foram usadas apenas referências internas aprovadas:

- `assets/props/rede_01.png`, `assets/props/rede_02.png` e `assets/props/rede_03.png`;
- `assets/props/barril_01.png`, `assets/props/barril_02.png` e `assets/props/barril_03.png`.

As três saídas são designs originais, sem texto, símbolos, runas, emblemas ou marcações de propriedade.

## Entrega

| Asset final | Candidata | Silhueta |
| --- | --- | --- |
| `assets/props/doca_01.png` | `.atena/generated/asset-candidates/props/dagruve/doca_01_v01.png` | tábuas quebradas, corda e estaca baixa |
| `assets/props/doca_02.png` | `.atena/generated/asset-candidates/props/dagruve/doca_02_v01.png` | poste de amarração gasto, corda e sobras de madeira |
| `assets/props/doca_03.png` | `.atena/generated/asset-candidates/props/dagruve/doca_03_v01.png` | viga baixa, corda enrolada, pequenas tábuas e cunha |

Cada candidata veio em `1254x1254`, tinha alfa `0,0,0,0` nos quatro cantos e foi normalizada para `256x256` com transparência preservada.

## Validação

- O tipo `doca` foi integrado ao componente de props e a três instâncias de Dagruve.
- `tools/validate_generated_assets.ps1`: 260 arquivos, 231 com alfa, 0 erros.
- `D:\Godot\Godot_v4.7.2-stable_win64.exe --headless --path . -s tests/run_all.gd`: 0 falhas.
- A abertura headless do editor reimportou `doca_01.png` a `doca_03.png` com saída 0. Avisos do perfil local do Godot não afetaram a importação.
