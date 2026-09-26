# EVID-029 — Regra global de espelhamento de animações de heróis

Data: 2026-09-24  
Autorização: dono aprovou explicitamente a regra global de geração reduzida.

## Decisão aplicada

Todo herói novo produz nove sequências-fonte: `idle`, `move_n`, `move_ne`, `move_e`, `move_se`, `move_s`, `attack`, `active` e `death`.

O runtime preserva as oito direções lógicas de deslocamento e espelha somente:

| Direção lógica | Folha-fonte | `flip_h` |
|---|---|---|
| `move_nw` | `move_ne` | sim |
| `move_w` | `move_e` | sim |
| `move_sw` | `move_se` | sim |

Norte e sul continuam distintos. Idle, ataque, habilidade e morte não são espelhados por esta regra.
As folhas inversas preexistentes foram preservadas, mas deixam de ser carregadas e de ser exigidas para novos lotes.

## Validação

- `ui/hero_view.gd` carrega apenas as cinco folhas-fonte de movimento e aplica o espelhamento no `AnimatedSprite2D`;
- os testes confirmam tanto o mapeamento das oito direções lógicas quanto as três conversões por espelhamento;
- o manifesto e o catálogo de prompts registram que as três chamadas inversas antigas são legadas e não devem ser geradas novamente.

Verificado em 2026-09-24: `tools/validate_generated_assets.ps1` aprovou 266 arquivos sem erro; a suíte headless do Godot terminou com 0 falhas.
