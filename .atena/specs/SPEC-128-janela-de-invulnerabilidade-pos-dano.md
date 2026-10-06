---
id: SPEC-128
title: Janela de invulnerabilidade após dano (0,4 s para 0,1 s)
status: implemented-committed
origin: post-hoc
implementation_preceded_spec: true
created: 2026-10-05
approval: pedido direto do dono no chat em 2026-10-05 (Direct Execution); commit aprovado explicitamente pelo dono
plan: nenhum (sem plano ativo; fora de PLAN-059)
---

# SPEC-128

## Registro post-hoc
A mudança de código precedeu esta spec: o dono perguntou qual era a janela, depois pediu "diminua a janela de invulnerabilidade para 0,1 s" e a alteração foi feita como Direct Execution, antes de qualquer spec. Esta spec foi gravada depois, a pedido do dono, só para registrar o que de fato ocorreu. Não há aprovação de spec nem plano anteriores a reconstruir.

## Pedido
Reduzir a invulnerabilidade concedida ao herói ao sofrer dano, de 0,4 s para 0,1 s. Bênção `shadow_dodge` (0,45 s) e reviver (3,0 s) ficam como estão.

## Escopo
- `core/battle.gd`: constante `HIT_INVULN` de `0.4` para `0.1` (usada em `_hurt_hero`, que só a concede quando o dano realmente entra: não dispara se a Guarda ou a Barreira absorvem tudo).
- Não muda: `shadow_dodge` (0,45 s), `accept_revive` (3,0 s), dano da Maré e demais fontes que ignoram defesas genéricas, `data/difficulty.json`, dados de inimigos.

## Efeito esperado e risco
Com 0,1 s, golpes, projéteis e áreas de vários inimigos podem acertar em sequência quase sem pausa; o dano por segundo sofrido em horda sobe. Soma-se ao aumento de `hp_mult`/`dmg_mult` por fase (SPEC-125) e à velocidade dos inimigos (SPEC-124), ainda sem playtest. Se ficar duro demais, o ajuste é a própria constante (0,15 a 0,25 s) ou o dano por fase.

## Aceite
- `tests/run_all.gd`: 0 falhas (registrado em EVID-164).
- Sem medição do bot; leitura de dificuldade fica para o playtest humano.
- Reverter: `HIT_INVULN = 0.4`.
