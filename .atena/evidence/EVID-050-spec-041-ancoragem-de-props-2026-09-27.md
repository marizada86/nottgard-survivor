# EVID-050 — SPEC-041: ancoragem visual de props no chão

Data: 2026-09-27  
Estado: verificada localmente

## Escopo verificado

- Props raster usam a borda inferior da área alfa útil como contato visual;
  o resultado fica em cache por textura.
- `visual_ground_offset` desloca arte e sombra juntas, sem modificar posição
  lógica ou raio de bloqueio.
- Fallbacks procedurais e penhascos compartilham a referência de solo.
- O alvo QA `prop_grounding` orienta a leitura de base, sombra e y-sort nas
  fases selecionadas.

## Validações

| Verificação | Resultado |
| --- | --- |
| Suíte (`tests/run_all.gd`) | 0 falhas |
| Smoke das fases | OK: Dagruve, Docas, Shedaklah, Molor, Durao, Feng Tu, Shendilavri, Goranthis e Pilares |
| Inspeção visual 1280×720 | Aprovada em Dagruve, Docas e Durao |

Os avisos conhecidos de ambiente do Godot (arquivo de log, certificados e
recursos retidos no encerramento headless) não interromperam o carregamento
nem o smoke.

## Capturas

- `SPEC-041-dagruve-props-2026-09-27.png` — baú, pilar, braseiros e estátua
  mantêm contato com o piso e leitura de profundidade.
- `SPEC-041-docas-props-2026-09-27.png` — carga, amarrações, altar e props
  baixos estão apoiados no cais.
- `SPEC-041-durao-props-2026-09-27.png` — penhascos e props próximos ao
  Estige gelatinoso mantêm base e sombra coerentes.

## Mudanças reconciliadas

- `ui/prop.gd`
- `ui/terrain_features.gd`
- `core/playtest.gd`
- `core/battle.gd`
- `tests/test_prop_grounding.gd`
- `tests/test_qa_sandbox.gd`
