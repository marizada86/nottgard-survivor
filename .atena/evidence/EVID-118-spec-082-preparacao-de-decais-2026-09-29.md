# EVID-118 — Prévia técnica dos decais do Lote 2

Data: 2026-09-29  
SPEC: SPEC-082  
Status: **validação automatizada aprovada; inspeção visual de QA pendente**.

## Entrega

- `data/ground_decals.json` declara um remendo e uma trilha para cada um dos
  nove biomas, usando exclusivamente os 18 PNGs normalizados do cofre.
- `ui/ground_decals.gd` desenha a camada em `z_index = -90`: acima do piso
  (`-100`) e abaixo dos atores/props (`0`), sem nó, grupo ou API de colisão.
- `ui/run.gd` instancia a camada apenas como `GroundDecalsPreview` e só a
  torna visível no sandbox de QA. A run normal não depende dos candidatos.
- `tests/test_ground_decals.gd` verifica manifesto, existência, carregamento
  dos 18 PNGs, presença de remendo/trilha, determinismo e contrato de camada.

## Verificações executadas

- `D:\\Godot\\godot.exe --headless --path . -s res://tests/run_all.gd`:
  **0 falhas**.
- `D:\\Godot\\godot.exe --headless --path . res://tools/smoke.tscn`:
  **smoke ok** nas nove fases, todas em estado `running`.
- `git diff --check`: sem erros de whitespace.

## Critérios e ressalvas

- Os critérios de determinismo, isolamento de colisão e ordem de desenho têm
  evidência automatizada.
- O carregamento headless confirma que cada candidata de decal pode ser lida
  no sandbox.
- A confirmação de composição visual (ao menos um remendo e uma trilha
  legíveis por bioma) continua pendente: o projeto não possui o adaptador de
  captura selada necessário para comprová-la automaticamente, e não foi
  instalado por não fazer parte desta aprovação.

## Gate preservado

Nenhum PNG do Lote 2 foi promovido para `assets/`. Estruturas e decais seguem
condicionados à inspeção visual; BUG-013 não é fechado por esta evidência.
