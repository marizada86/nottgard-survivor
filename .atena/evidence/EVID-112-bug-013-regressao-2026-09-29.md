# EVID-112 — Regressão BUG-013: contato visual de props

Data: 2026-09-29  
Spec: [[SPEC-081-regressao-bug-013-contato-visual-de-props]]

## Diagnóstico

O relato de props flutuando persistiu em Dagruve, Docas e Durão porque a
proteção automatizada anterior só verificava perfis com `shadow_mode:
dynamic`. Doze props planos com `shadow_mode: none` tinham `contact_anchor`
entre 5,1 e 20,5 pixels de tela abaixo da base opaca; `rocha_03` também
ultrapassava a tolerância em 2,4 pixels.

| Grupo | Perfis fora da tolerância antes | Resultado após correção |
|---|---:|---:|
| Docas, margens, ossos e redes | 12 | 0 |
| `rocha_03` (Durão) | 1 | 0 |
| Total | 13 | 0 |

## Correção limitada

- Ajustadas somente as 13 entradas de `contact_anchor` em
  `data/prop_visuals.json`, usando a base opaca medida de cada PNG.
- `tests/test_prop_visuals.gd` agora aplica a tolerância de 2 pixels a todo
  perfil, inclusive aos modos `none` e `embedded` quando existirem.
- Não foram alterados PNGs, cenas, posições lógicas, colisões, `block_radius`,
  y-sort, seeds ou combate.

## Validação

- Auditoria final: **0** perfis fora da tolerância; detalhes em
  [[EVID-112-bug-013-auditoria-final-2026-09-29]].
- `tests/run_all.gd` executado em modo headless e encerrou com código 0.
- Capturas automatizadas foram tentadas, mas este ambiente renderiza somente a
  HUD, sem o mundo 2D. Os arquivos inválidos foram descartados; permanece
  necessária a inspeção visual manual dos três cenários QA antes de fechar o
  BUG-013 e liberar a admissão do Lote 2.
