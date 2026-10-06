---
id: "EVID-164"
title: "Janela de invulnerabilidade após dano: 0,4 s para 0,1 s (SPEC-128, pós-hoc)"
created: "2026-10-05"
relations: ["[[SPEC-128-janela-de-invulnerabilidade-pos-dano]]", "[[EVID-162-b003-inimigos-por-fase-2026-10-05]]", "[[EVID-159-velocidade-dos-inimigos-mais-20-por-cento-2026-10-05]]"]
---

# EVID-164

## Mudança
- `core/battle.gd:12`: `HIT_INVULN := 0.4` passou a `0.1`.
- Mantidos: `shadow_dodge` em 0,45 s (`core/battle.gd`, esquiva) e `accept_revive` em 3,0 s.
- Reverter: `HIT_INVULN = 0.4`.

## Origem
Pedido direto do dono no chat em 2026-10-05, depois de perguntar qual era a janela vigente. Direct Execution: a mudança precedeu a spec (SPEC-128 é post-hoc, `implementation_preceded_spec: true`).

## Verificação
- `Godot_v4.7.2-stable_win64.exe --headless --path . -s tests/run_all.gd`: **0 falhas**. Os avisos de RIDs e objetos vazados no encerramento já existiam.
- Nenhum teste fixa o valor de `HIT_INVULN`; os testes que mexem em `invuln` só o zeram para isolar o dano.
- Sem rodada de bot: não há medição do efeito sobre sobrevivência.

## Pendente
- Playtest humano. Com 0,1 s o dano por segundo em horda sobe, somado a SPEC-124 (velocidade +20%) e SPEC-125 (`hp_mult`/`dmg_mult`), todas ainda sem playtest. Se ficar duro, ajustar a constante (0,15 a 0,25 s) ou o dano por fase.
- Nota operacional: o comando `godot ...` de FERRAMENTAS.md não está no PATH desta máquina; foi usado o executável na raiz do projeto.
