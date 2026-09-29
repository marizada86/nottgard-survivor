# EVID-104 — Admissão das animações do Zumbi v01

Data: 2026-09-29  
SPEC: [[SPEC-061-preparacao-da-regeneracao-do-piloto-de-zumbi]]  
Estado: admitido localmente, sem commit ou publicação

## Decisão e proveniência

- O dono aprovou a prancha de candidatos EVID-103 e autorizou a admissão.
- As 20 imagens selecionadas permanecem em
  `.atena/generated/zumbi-regeneration/v01/candidates/`.
- `tools/build_zumbi_candidate_strips.ps1` criou as tiras RGBA, com célula
  `256×384`, margem mínima de 8 px e ancoragem pela base.
- Os quatro arquivos substituídos foram preservados em
  `EVID-104-zumbi-pre-admission-backup/assets/animations/enemies/zumbi/`.

## Arquivos oficiais admitidos

| Tira | Quadros | Dimensão final | Path oficial |
| --- | ---: | --- | --- |
| idle | 4 | 1024×384 | `assets/animations/enemies/zumbi/idle.png` |
| move | 6 | 1536×384 | `assets/animations/enemies/zumbi/move.png` |
| attack | 4 | 1024×384 | `assets/animations/enemies/zumbi/attack.png` |
| death | 6 | 1536×384 | `assets/animations/enemies/zumbi/death.png` |

## Verificação

- Reimportação do Godot: quatro tiras detectadas e reimportadas sem falha.
- `godot --headless --path . -s tests/run_all.gd`: `testes: 0 falha(s)`.
- `godot --headless --path . res://tools/smoke.tscn`: nove fases em `running`;
  `smoke: ok`.
- A prancha em fundo xadrez EVID-103 comprova a composição e a transparência
  das 20 células aceitas.

## Exceção de captura visual

A tentativa de capturar uma run pelo `tools/shot.tscn` em modo headless não
produziu viewport: o renderer dummy retornou textura nula. Isso impede uma
captura visual automatizada neste ambiente, mas não invalida a importação, a
instanciação no smoke ou a aprovação visual humana da prancha. Uma captura em
janela interativa fica pendente quando houver um renderer com viewport.
