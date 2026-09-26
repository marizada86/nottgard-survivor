# EVID-021 — Redes de Dagruve

Data: 2026-09-24  
Spec: `SPEC-027-props-de-dagruve-redes`

## Autoridade e procedência

Foram usadas apenas as referências aprovadas:

- `D:\dev\nottgard\games\IA\nottcard-ai\assets\world\props\rede.png`;
- `assets/props/barril_01.png`, `assets/props/barril_02.png` e `assets/props/barril_03.png`.

Nenhum arquivo-fonte foi copiado. As três saídas são designs novos, sem texto, símbolo, runa ou marca de facção.

## Entrega

| Asset final | Candidata | Silhueta |
| --- | --- | --- |
| `assets/props/rede_01.png` | `.atena/generated/asset-candidates/props/dagruve/rede_01_v01.png` | rede enrolada, corda e flutuador baixo |
| `assets/props/rede_02.png` | `.atena/generated/asset-candidates/props/dagruve/rede_02_v01.png` | novelo de rede, corda, boias e lançadeira de madeira |
| `assets/props/rede_03.png` | `.atena/generated/asset-candidates/props/dagruve/rede_03_v01.png` | rede dobrada sobre flutuador e boia de cortiça |

Cada candidata veio em `1254x1254` e foi normalizada para `256x256` com transparência preservada. O alfa nos cantos foi `0,0,1,0` na primeira e `0,0,0,0` nas demais; todos os cantos permanecem transparentes.

## Validação

- O tipo `rede` foi integrado ao componente de props e a três instâncias de Dagruve.
- `tools/validate_generated_assets.ps1`: 254 arquivos, 225 com alfa, 0 erros.
- `D:\Godot\Godot_v4.7.2-stable_win64.exe --headless --path . -s tests/run_all.gd`: 0 falhas.
- A abertura headless do editor reimportou `rede_01.png` a `rede_03.png` com saída 0. Avisos do perfil local do Godot não afetaram a importação.
