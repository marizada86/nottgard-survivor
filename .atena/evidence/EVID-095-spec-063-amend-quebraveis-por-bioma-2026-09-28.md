# EVID-095 — Amendment da SPEC-063: quebráveis por bioma e drop enviesado

Data: 2026-09-28
SPEC: [[SPEC-063-objetos-quebraveis-e-rebalanceamento-de-pocao]] (amendment)
Prompts de arte: [[ART-PROMPTS-024-cenario-e-quebraveis-por-bioma]]

## Alterações realizadas

- `core/battle.gd`:
  - `_kill()`: drop do quebrável deixou de ser 1/3 poção, 1/3 moeda, 1/3 ímã
    e passou a ser **65% moeda, 20% poção, 10% ímã, 5% item** (via
    `Items.roll()` + `give_item()` — reaproveita a escolha de
    equipar/vender da SPEC-060 se o slot estiver ocupado, sem lógica nova).
  - `BREAKABLE_TYPES_BY_STAGE`: cada um dos 7 biomas sub-decorados
    (Shedaklah, Molor, Durao, Feng-tu, Shendilavri, Goranthis, Pilares)
    ganhou seu próprio quebrável temático, com `arbusto_quebravel` como
    alternativa em todos eles.
- `data/enemies.json`: 7 novos IDs (`saco_de_esporos_quebravel`,
  `casulo_viscoso_quebravel`, `urna_funeraria_quebravel`,
  `lanterna_de_papel_quebravel`, `espelho_ilusorio_quebravel`,
  `estatua_rachada_quebravel`, `relicario_instavel_quebravel`) — mesmo
  contrato dos três originais (`xp=0`, `speed=0`, `ca=0`, `cam=0`,
  `flags: ["inerte","quebravel"]`).
- `assets/enemies/`: 7 PNGs novos, **reaproveitados de arte já existente**
  (sem geração nova): `esporo_voador.png`, `bolha_de_slime.png`,
  `alma_penada.png`, `estatua_do_templo.png`, `ilusao_de_sucubo.png`,
  `guardiao_de_goranthis.png`, `gargula.png` — cada um tematicamente
  próximo do bioma correspondente, como placeholder até a arte definitiva
  (prompts em ART-PROMPTS-024) entrar pela fila de
  [[SPEC-062-fila-de-geracao-externa-de-assets]].
- `data/audio_manifest.json`: eventos `enemy.<id>.action`/`.death` para os
  7 novos IDs, reaproveitando arquivos de áudio já existentes — mesma
  exigência de `tests/test_audio.gd` já vista no lote original.
- `.atena/generated/ART-PROMPTS-024-cenario-e-quebraveis-por-bioma.md`:
  documento novo com prompts para (a) os 7 quebráveis definitivos e (b) 21
  props de cenário puramente decorativos (3 por bioma sub-decorado),
  preenchendo a lacuna identificada de que só Dagruve/Docas tinham lotes
  dedicados de props (SPEC-022 a SPEC-031).
- [[SPEC-062-fila-de-geracao-externa-de-assets]]: duas linhas novas
  (quebráveis definitivos e props de cenário), apontando para
  ART-PROMPTS-024.
- `tests/test_battle.gd`: novo bloco estatístico (500 amostras) confirmando
  que moeda é o drop mais comum e item é mais raro que moeda. Corrigi um
  problema no próprio teste durante o desenvolvimento: o array de pickups
  bate no limite `MAX_PICKUPS` (140) depois de várias iterações sem nunca
  ser consumido, e a partir daí `_drop()` já teria feito auto-coleta
  silenciosa — sem limpar o array a cada amostra, a contagem de ouro/ímã
  ficava artificialmente baixa. Corrigido limpando `pickups` a cada
  iteração do teste.

## Verificações executadas

| Comando | Resultado |
|---|---|
| `Godot_v4.7.2-stable_win64.exe --headless --editor --path . --quit` | Reimportou os 7 PNGs novos |
| `Godot_v4.7.2-stable_win64.exe --headless --path . -s tests/run_all.gd` | `testes: 0 falha(s)` (após corrigir o teste estatístico) |
| `Godot_v4.7.2-stable_win64.exe --headless --path . res://tools/smoke.tscn` | `smoke: ok` nas 8 fases |

## Exceção de validação

Sem checagem manual interativa nesta sessão (mesma limitação já registrada
em EVID-089/090/092/093/094). O documento ART-PROMPTS-024 e a linha nova na
fila de SPEC-062 preparam a substituição da arte provisória, mas isso
depende de o dono ter acesso a uma sessão com geração de imagem — nada
disso bloqueia o funcionamento atual dos quebráveis, que já jogam com
placeholders reaproveitados.
