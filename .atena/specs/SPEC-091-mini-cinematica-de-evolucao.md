# SPEC-091 — Mini-cinemática de evolução de arma (MEC-009)

Status: **implementada (2026-09-29); validação em playtest.**

Origem: T01 S2-N4 ("falta indicação de como evoluir a arma; ao evoluir, mini-cinemática pausando e mostrando
as condições") e a pergunta 6 do questionário 002, prioridade nº 3 de T03
([[EVID-106-playtest-publico-t01-higor-2026-09-29]], [[EVID-108-playtest-publico-t03-dna-2026-09-29]]).
Complementa a dica de evolução da [[SPEC-086-ajustes-pos-playtest-numeros-e-clareza]]. Versão **procedural**,
sem depender de arte: **ART-014** continua aberto para uma versão com efeitos próprios.

## Regra

Ao escolher uma **evolução** no level-up, o jogo entra no estado `evolve_cine` por **2,6 s** (dados:
`evolve_cinematic_seconds`, `data/difficulty.json`): a partida **fica parada** e o HUD mostra um painel com
`★ EVOLUÇÃO ★`, o ícone da arma antiga, a seta, o ícone da nova (maior), os nomes, as **condições cumpridas**
("nível 5 (máximo) + passiva X") e a descrição da nova arma. **Qualquer tecla ou clique pula.**

## Implementação

- `Battle._cine_queue`, `evolve_cine`, `evolve_cine_t` e `skip_cine()`; `step` trata o estado antes do bloqueio
  de estados não `running` (`core/battle.gd`). Se houver mais de uma evolução, entram em fila.
- `Hud.show_evolution` / `hide_evolution` montam o painel em código (fade e "pop" com tween) (`ui/hud.gd`).
- `ui/run.gd` mostra o painel enquanto o estado for `evolve_cine` e pula com tecla ou clique.
- `tools/shot.gd`: flag `evolve` para captura de QA.

## Testes

`tests/test_battle.gd`: evoluir abre a cinemática, o relógio não corre durante ela, ela acaba sozinha, e pular
volta ao jogo.

## Limites

- Sem som próprio nem efeitos de partícula (ART-014).
- Não muda a regra de evolução nem os números das armas.
