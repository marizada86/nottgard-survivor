# EVID-120 — Exclusão de rios, Estige e bloqueios nos decais

Data: 2026-09-29  
SPEC: SPEC-082  
Status: **verificação automatizada aprovada; inspeção visual pendente**.

## Defeito relatado

O QA visual identificou decais sobre a lâmina d'água. A implementação anterior
posicionava-os por coordenadas de tela fixas, sem consultar o terreno lógico.

## Correção

- `ui/ground_decals.gd` converte a posição desejada para o plano isométrico e
  busca deterministicamente a área seca mais próxima.
- A validação da pegada rejeita água, corrente, Estige e áreas bloqueadas,
  incluindo uma margem de segurança ao redor do decal.
- Docas fica deliberadamente sem prévia de decais: sua cena atual não declara
  uma âncora seca de cais. Isso evita trocar o defeito por uma colocação
  inventada sobre a água.
- `tests/test_ground_decals.gd` exige a pegada seca e garante a ausência de
  prévia em Docas enquanto essa âncora não existir.

## Verificações executadas

- `D:\\Godot\\godot.exe --headless --path . -s res://tests/run_all.gd`:
  **0 falhas**.
- `D:\\Godot\\godot.exe --headless --path . res://tools/smoke.tscn`:
  **smoke ok** nas nove fases.
- `git diff --check`: sem erros de whitespace.

## Pendente

Uma nova inspeção QA deve confirmar que Durão, Shedaklah, Shendilavri e
Goranthis não exibem decais sobre o Estige. Docas precisa de uma área seca
autorizada antes de receber seus decais. Nenhum asset do Lote 2 foi promovido
para `assets/` e BUG-013 permanece aberto.
