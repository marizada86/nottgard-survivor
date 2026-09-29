# EVID-093 — Execução da SPEC-063 (quebráveis + rebalanceamento de poção)

Data: 2026-09-28
SPEC: [[SPEC-063-objetos-quebraveis-e-rebalanceamento-de-pocao]]
PLAN: [[PLAN-032-proxima-atualizacao-pos-playtest-2026-09-28]] (Fase B, item 4)

## Alterações realizadas

- `core/battle.gd`:
  - Novo guard em `_enemy_step()`: inimigo com `flags.has("inerte")` nunca
    entra no bloco de ataque automático (antes, até um inimigo com
    `speed=0` atacava se o herói chegasse a 1.4 de distância).
  - `_kill()`: removida a chance de poção (2,5%) para qualquer inimigo
    comum. Elite (`affix != "" or drops_chest`) ganhou 6% de chance própria
    de poção, além do baú/moeda que já tinha. Inimigo com
    `flags.has("quebravel")` sempre larga exatamente um item, sorteado entre
    poção/moeda/ímã.
  - `_collect()`: novo pickup `"magnet"` — ativa `magnet = true` em todos os
    pickups presentes no mapa no momento da coleta, reaproveitando o campo
    que já existia em cada pickup.
  - Novo timer `_breakable_t` (resetado em `load_stage()`) e
    `_spawn_random_breakable()`, chamado a cada ~35–55 s a partir de
    `_director()`, no mesmo padrão já usado por `_spawn_random_interaction()`
    (aparece perto do herói, não em ponto fixo do mapa).
  - `BREAKABLE_TYPES_BY_STAGE`: `candelabro_quebravel`/`caixote_quebravel`
    só em `dagruve`/`docas`; qualquer outra fase cai em
    `BREAKABLE_DEFAULT_TYPES` (`arbusto_quebravel`).
- `data/enemies.json`: três novos IDs (`candelabro_quebravel`,
  `caixote_quebravel`, `arbusto_quebravel`) — `xp=0`, `speed=0.0`, `ca=0`,
  `cam=0` (nunca esquiva do ataque do herói), `flags: ["inerte", "quebravel"]`.
- `assets/enemies/`: três PNGs novos, **reaproveitados de arte já
  existente** (nenhuma geração nova, conforme não objetivo da spec):
  `candelabro_quebravel.png` ← `assets/props/velas_01.png`,
  `caixote_quebravel.png` ← `assets/props/caixote_01.png`,
  `arbusto_quebravel.png` ← `assets/enemies/cogumelo_fungico.png` (placeholder
  provisório até a arte de arbusto entrar pela fila de
  [[SPEC-062-fila-de-geracao-externa-de-assets]]).
- `data/audio_manifest.json`: eventos `enemy.<id>.action`/`.death` para os
  três novos IDs, reaproveitando arquivos de áudio já existentes
  (`combat.impact_*`, `world.chest_*`) — exigido por `tests/test_audio.gd`,
  que audita todo `data/enemies.json` contra o manifesto.
- `tests/test_battle.gd`: `_quiet()` agora também zera `_breakable_t`, para
  não interferir em testes de unidade não relacionados. Dois blocos novos:
  - 9c: um `caixote_quebravel` não se move nem ataca o herói parado ao lado
    por 15 s simulados; ao morrer, larga exatamente um item entre
    poção/moeda/ímã.
  - 9d: 400 mortes de `zumbi` (inimigo comum) não produzem nenhum drop de
    poção.

## Verificações executadas

| Comando | Resultado |
|---|---|
| `Godot_v4.7.2-stable_win64.exe --headless --editor --path . --quit` | Reimportou os 3 PNGs novos (necessário antes da suíte — sem isso, `test_animation_assets.gd` falha com "imagem estática não importada") |
| `Godot_v4.7.2-stable_win64.exe --headless --path . -s tests/run_all.gd` | `testes: 0 falha(s)` |
| `Godot_v4.7.2-stable_win64.exe --headless --path . res://tools/smoke.tscn` | `smoke: ok` nas 8 fases |

Antes de chegar a zero falhas, a primeira rodada da suíte pegou 10 falhas
reais que guiaram a correção: import pendente dos 3 PNGs, ausência de
assinatura sonora dos 3 novos IDs em `test_audio.gd`, e um teste próprio mal
desenhado (o herói ainda tinha a arma inicial equipada e matava o quebrável
antes da asserção explícita — corrigido zerando `hero.weapons` nesse teste).

## Exceção de validação

Sem checagem manual interativa (ver um quebrável aparecer numa run real,
quebrar e confirmar visualmente qual dos três drops caiu) nesta sessão —
mesma limitação já registrada nas evidências anteriores desta leva
(EVID-089/090/092). A cadência de spawn (35–55 s por quebrável) e a
proporção do sorteio de drop (⅓ poção, ⅓ moeda, ⅓ ímã) são escolhas de
execução, explicitamente deixadas como revisáveis pela spec — vale confirmar
a sensação no próximo playtest antes de travar os números.
