# EVID-022 — Restos ósseos genéricos de Dagruve

Data: 2026-09-24  
Spec: `SPEC-028-props-de-dagruve-ossos`

## Autoridade e procedência

Foram usadas apenas as referências aprovadas:

- `D:\dev\nottgard\games\IA\nottcard-ai\assets\world\props\ossos.png`;
- `assets/props/rede_01.png`, `assets/props/rede_02.png` e `assets/props/rede_03.png`.

Nenhum arquivo-fonte foi copiado. As três saídas são designs novos e não representam espécie, evento, facção ou lore específico.

## Entrega

| Asset final | Candidata | Silhueta |
| --- | --- | --- |
| `assets/props/ossos_01.png` | `.atena/generated/asset-candidates/props/dagruve/ossos_01_v01.png` | pilha compacta de ossos longos e arcos de costela |
| `assets/props/ossos_02.png` | `.atena/generated/asset-candidates/props/dagruve/ossos_02_v01.png` | dispersão horizontal de fragmentos e costelas |
| `assets/props/ossos_03.png` | `.atena/generated/asset-candidates/props/dagruve/ossos_03_v01.png` | monte irregular de fragmentos e arcos ósseos |

Cada candidata veio em `1254x1254`, tinha alfa `0,0,0,0` nos quatro cantos e foi normalizada para `256x256` com transparência preservada. Não há crânios, mandíbulas, dentes, runas, texto ou identificação de espécie.

## Validação

- O tipo `ossos` foi integrado ao componente de props e a três instâncias de Dagruve.
- `tools/validate_generated_assets.ps1`: 257 arquivos, 228 com alfa, 0 erros.
- `D:\Godot\Godot_v4.7.2-stable_win64.exe --headless --path . -s tests/run_all.gd`: 0 falhas.
- A abertura headless do editor reimportou `ossos_01.png` a `ossos_03.png` com saída 0. Avisos do perfil local do Godot não afetaram a importação.
