# EVID-016 — Braseiros de Dagruve

Data: 2026-09-24  
Spec: `SPEC-022-props-de-dagruve-braseiros`

## Autoridade e procedência

O dono aprovou explicitamente o envio de referências locais selecionadas para a geração deste lote. Foram usadas somente:

- `D:\dev\nottgard\games\IA\nottcard-ai\assets\world\props\braseiro.png`;
- `assets/props/pilar_01.png`;
- `assets/props/cristal_01.png`.

Nenhum arquivo do `nottcard-ai` foi copiado para o jogo. As três saídas são composições novas, mantidas também como candidatas rastreáveis.

## Entrega

| Asset final | Candidata | Resultado |
| --- | --- | --- |
| `assets/props/braseiro_01.png` | `.atena/generated/asset-candidates/props/dagruve/braseiro_01_v01.png` | braseiro alto sobre pedestal |
| `assets/props/braseiro_02.png` | `.atena/generated/asset-candidates/props/dagruve/braseiro_02_v01.png` | tigela baixa com correntes |
| `assets/props/braseiro_03.png` | `.atena/generated/asset-candidates/props/dagruve/braseiro_03_v01.png` | cesto hexagonal sobre tripé |

Cada candidata foi gerada em `1254x1254`, apresentou alfa `0,0,0,0` nos quatro cantos e foi normalizada para PNG `256x256` com transparência preservada. A inspeção visual confirmou silhuetas distintas e leitura adequada na escala final.

## Integração

- `ui/prop.gd` inclui `braseiro` no seletor de tipos.
- `ui/stages/dagruve.tscn` contém três instâncias, posicionadas para selecionar as três variações pelo mecanismo determinístico existente.
- `.atena/generated/ASSET-PRODUCTION-MANIFEST-001.json` registra as três entradas integradas, suas candidatas, referências e hashes SHA-256.

## Validação

| Verificação | Resultado |
| --- | --- |
| `tools/validate_generated_assets.ps1` | 239 arquivos, 210 com alfa, 0 erros |
| `D:\Godot\Godot_v4.7.2-stable_win64.exe --headless --path . -s tests/run_all.gd` | 0 falhas |
| Abertura headless do projeto | importou os três PNGs; saída 0 |
| `git diff --check` | sem erros |

A abertura headless registrou avisos de permissão para diretórios de configuração do perfil local do Godot. Eles não afetaram a importação dos assets nem os testes.
