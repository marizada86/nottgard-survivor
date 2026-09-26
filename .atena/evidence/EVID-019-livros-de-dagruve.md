# EVID-019 — Livros de Dagruve

Data: 2026-09-24  
Spec: `SPEC-025-props-de-dagruve-livros`

## Autoridade e procedência

Foram usadas apenas as referências aprovadas:

- `D:\dev\nottgard\games\IA\nottcard-ai\assets\world\props\livros.png`;
- `assets/props/caixote_01.png`, `assets/props/caixote_03.png` e `assets/props/velas_02.png`.

Nenhum arquivo foi copiado. Os três resultados são designs novos e foram solicitados sem escrita, runas, emblemas ou marcas de facção.

## Entrega

| Asset final | Candidata | Silhueta |
| --- | --- | --- |
| `assets/props/livros_01.png` | `.atena/generated/asset-candidates/props/dagruve/livros_01_v01.png` | pilha de tomos com pergaminho enrolado |
| `assets/props/livros_02.png` | `.atena/generated/asset-candidates/props/dagruve/livros_02_v01.png` | livro aberto com páginas sem conteúdo |
| `assets/props/livros_03.png` | `.atena/generated/asset-candidates/props/dagruve/livros_03_v01.png` | caixa baixa de documentos |

Cada candidata veio em `1254x1254`, tinha alfa `0,0,0,0` nos quatro cantos e foi normalizada para `256x256` com transparência preservada.

## Validação

- O tipo `livros` foi integrado ao componente de props e às três instâncias de Dagruve.
- `tools/validate_generated_assets.ps1`: 248 arquivos, 219 com alfa, 0 erros.
- `D:\Godot\Godot_v4.7.2-stable_win64.exe --headless --path . -s tests/run_all.gd`: 0 falhas.
- A abertura headless do editor reimportou `livros_01.png` a `livros_03.png` com saída 0. Avisos de permissão do perfil local do Godot não afetaram a importação.
