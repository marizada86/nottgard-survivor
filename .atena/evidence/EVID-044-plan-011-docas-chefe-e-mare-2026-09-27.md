# EVID-044 — PLAN-011: Docas, introdução de chefe e Maré de Névoa

Data: 2026-09-27  
Escopo: execução aprovada do PLAN-011 para Dagruve/Docas e Sacerdote da Mente Derretida.

## Implementado

- `data/boss_presentations.json` define, por chefe, splash, textos de UI, duração de overlay, pausa de simulação e parâmetros da Maré.
- `core/battle.gd` emite uma introdução única de chefe, pausa a simulação por 1,0 s e emite o primeiro telegráfo antes do retorno do combate.
- A Maré possui estados isolados `grace`, `warning` e `advancing`; após 8 s sem dano, avisa por 2 s, avança das bordas e escala de 1% a 3% da vida máxima por segundo em 20 s.
- O dano da Maré usa o caminho ambiental direto e ignora CA, CAM, esquiva, invulnerabilidade de esquiva, guarda, barreira e redução de dano genérica.
- `ui/run.gd` tem overlay reutilizável de chefe, fallback sem imagem e névoa em quatro bordas com intensidade dirigida pela simulação.
- A splash foi normalizada e integrada em `assets/ui/boss-intros/sacerdote_mente_derretida.png` (640x360, opaca).
- O braseiro selecionado foi normalizado e integrado em `assets/props/braseiro_01.png` (256x256, RGBA).
- O piso da Dagruve foi refeito como fonte de calçamento contínuo e integrado em `assets/tiles/dagruve_ground.png` (128x64, opaco). A candidata anterior, com linhas de apresentação, não foi reutilizada.

## Rastreabilidade de arte

| Asset | Versão integrada | Hash SHA-256 |
| --- | --- | --- |
| `boss-intros/sacerdote_mente_derretida_intro` | v03 | `3c07689108389950c964b614939e7510c1199121d5c6245f5b3142027927b2d4` |
| `props/braseiro_01` | v02 | `2e4fc0e1982da5d7b350df9e22617858d4c69aadcaa36154f14c660b5dc1540a` |
| `tiles/dagruve_ground` | v04 | `bf4f86c5580a7a7a9539a1f9042a192eb70c43b4168c5d0330d5b9c949395d62` |

O manifesto `.atena/generated/ASSET-PRODUCTION-MANIFEST-001.json` está válido e registra versão, destino e hash. O registrador preservou backups locais de assets substituídos em `.atena/evidence/legacy-backup/`.

## Validação executada

- `D:\Godot\godot.exe --headless --path . -s tests/run_all.gd` — `testes: 0 falha(s)`.
- `D:\Godot\godot.exe --headless --path . res://tools/smoke.tscn` — oito fases abertas, `smoke: ok`.
- Testes novos cobrem pausa única da introdução, telegráfo de retorno, 8 s de graça, aviso, rampa 1%→3% e a impossibilidade de CA/CAM/esquiva/invulnerabilidade anularem a Maré.
- Inspeção de arquivos confirmou todos os props das famílias usadas em Dagruve (`braseiro`, `caixote`, `barril`, `rede`, `doca`, `carga`, `margem`, `velas`, `livros`) e JSON válido do manifesto.

## Exceção de captura visual

`tools/shot.tscn` foi tentado em `--headless`, mas o driver sem viewport retorna textura nula e não pode salvar PNG. A execução de smoke com `ui/run.tscn` passou; falta apenas a captura em uma janela gráfica real para arquivar os quatro quadros previstos (pré-chefe, splash, graça e névoa avançando). Nenhuma mudança foi feita para contornar o driver ou alterar `DivineVisuals`.
