# EVID-041 — Revive manual e recompensa de derrota

Data: 2026-09-26

## Implementação

- `Battle` agora para em `revive_offer` na primeira morte, expõe as decisões
  `accept_revive()` e `decline_revive()` e mantém uma oferta extra por cada
  unidade da melhoria Segunda Chance.
- A recusa registra `reward_rate=0.3`; mortes após esgotar as ofertas mantêm
  `reward_rate=0.5`. `Profile` liquida por essa taxa explícita.
- O HUD mostra o modal com a previsão calculada pela mesma regra de perfil e a
  cena da run bloqueia os controles enquanto a decisão está pendente.
- O Navegador QA recebeu o destino `revive_offer`; testes de batalha e perfil
  cobrem as duas escolhas, a oferta extra e as taxas de 30%/50%.

## Verificações executadas

| Verificação | Resultado |
|---|---|
| `git diff --check` | passou |
| Parse de `data/upgrades.json` com Node | passou |
| Busca por consumidores do contrato `half` removido | passou |
| `D:\Godot\godot.exe --headless --path . -s tests/run_all.gd` | passou: 0 falhas |
| `D:\Godot\godot.exe --headless --path . res://tools/smoke.tscn` | passou: oito fases, `smoke: ok` |

## Reconciliação

O contrato canônico de recompensa foi atualizado com a decisão aprovada: 30%
ao recusar a primeira oferta, 50% depois de esgotar as ofertas. A suíte e o
smoke passaram com Godot 4.7.2. A engine emitiu avisos do ambiente para gravar
`user://logs/godot.log`, ler certificados do Windows e liberar objetos/recursos
ao encerrar o smoke; eles não produziram falha de teste nem alteraram o resultado
das oito fases e ficam registrados para acompanhamento separado.
