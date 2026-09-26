# EVID-034 - Idle e movimentos de Bromnor

Data: 2026-09-25

## Escopo executado

Com aprovacao humana por lote, foram integradas as seis folhas-fonte de
Bromnor:

- `assets/animations/heroes/bromnor/idle.png` - 1024x384, quatro quadros;
- `assets/animations/heroes/bromnor/move_n.png` - 1536x384, seis quadros;
- `assets/animations/heroes/bromnor/move_ne.png` - 1536x384, seis quadros;
- `assets/animations/heroes/bromnor/move_e.png` - 1536x384, seis quadros;
- `assets/animations/heroes/bromnor/move_se.png` - 1536x384, seis quadros;
- `assets/animations/heroes/bromnor/move_s.png` - 1536x384, seis quadros.

Cada arquivo final foi derivado por interpolacao nearest-neighbor da candidata
aprovada, de modo que as celulas finais tenham 256x384. Os cantos das seis
folhas possuem alfa zero.

## Identidade e direcoes

As fontes preservam Bromnor como anao idoso largo, com cabelo e barba brancos,
armadura de bronze e aco, tecido azul profundo e Martelo da Gloria. A regra de
orelhas curtas e arredondadas prevaleceu sobre a referencia de staging que
possuia orelhas pontudas.

`move_n` usa a candidata `v02`, corrigida para uma vista traseira que comunica
movimento para cima na tela. Os espelhamentos do runtime continuam derivando
`move_nw`, `move_w` e `move_sw` de `move_ne`, `move_e` e `move_se`; nenhuma
folha inversa foi gerada.

## Rastreabilidade

- Plano: `../vault/drafts/PLAN-007-geracao-controlada-das-animacoes-de-bromnor-2026-09-25.md`.
- Manifesto: `../generated/HERO-ANIMATION-PROMPT-MANIFEST-001.json`.
- Registros: `../generated/prompt-execution/HERO-bromnor-{idle,move_n,move_ne,move_e,move_se,move_s}.json`.
- Candidatas: `../generated/asset-candidates/animations/heroes/bromnor/`.

## Verificacao

1. Importacao local do Godot para as novas seis texturas concluida.
2. `D:\Godot\Godot_v4.7.2-stable_win64.exe --headless --path . -s tests/run_all.gd`: **0 falhas**.
3. `D:\Godot\Godot_v4.7.2-stable_win64.exe --headless --path . -s tools/audit_prompt_execution.gd`: **0 falhas**.

## Pendencias

`attack`, `active` e `death` de Bromnor permanecem fora deste lote e exigem a
proxima aprovacao de geracao.
