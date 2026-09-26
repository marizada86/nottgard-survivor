# EVID-017 — Caixotes de Dagruve

Data: 2026-09-24  
Spec: `SPEC-023-props-de-dagruve-caixotes`

## Autoridade e procedência

O dono aprovou o uso de referências locais selecionadas para este lote. Foram usadas somente:

- `D:\dev\nottgard\games\IA\nottcard-ai\assets\world\props\caixote.png`;
- `assets/props/pilar_01.png`.

Nenhum arquivo-fonte foi copiado para o projeto. As três saídas são designs novos.

## Entrega

| Asset final | Candidata | Silhueta |
| --- | --- | --- |
| `assets/props/caixote_01.png` | `.atena/generated/asset-candidates/props/dagruve/caixote_01_v01.png` | caixote alto com corda |
| `assets/props/caixote_02.png` | `.atena/generated/asset-candidates/props/dagruve/caixote_02_v01.png` | caixote baixo de carga |
| `assets/props/caixote_03.png` | `.atena/generated/asset-candidates/props/dagruve/caixote_03_v01.png` | pilha de dois caixotes com lona |

As candidatas vieram em `1254x1254`, apresentaram alfa `0,0,0,0` nos quatro cantos e foram normalizadas para `256x256` com transparência preservada.

## Integração e validação

- O tipo `caixote` foi integrado ao componente de props e três instâncias foram adicionadas à cena Dagruve.
- O manifesto contém 242 entradas e registra os hashes SHA-256 das três integrações.
- `tools/validate_generated_assets.ps1`: 242 arquivos, 213 com alfa, 0 erros.
- `D:\Godot\Godot_v4.7.2-stable_win64.exe --headless --path . -s tests/run_all.gd`: 0 falhas.
