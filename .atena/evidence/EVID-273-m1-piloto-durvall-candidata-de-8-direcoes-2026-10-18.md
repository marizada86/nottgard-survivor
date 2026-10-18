# EVID-273 — M1, S-009: piloto Durvall, candidata v03 de 8 direções para o laboratório

Data: 2026-10-18 · PLAN-103 / B-002 / SPEC-176 · Estado: DRAFT; **sem admissão em `assets/`** (o laboratório lê a pasta por `--walk-candidate`) · Classificação: IN_PLAN (retomada do PLAN-103 depois do PLAN-110; decisão D22: "move_n, move_ne, move_w, move_sw, move_nw como tiras reais, sem espelho").

## Fontes

| Direção | Fonte | Observação |
|---|---|---|
| `move_n` | LOT16 P6 v01 (grade 3×2, 1536×1024) | de costas, sem rosto; espada na mão esquerda do personagem |
| `move_ne` | LOT16 P7 v01 | três-quartos de costas |
| `move_w` | LOT16 P8 v01 (1545×1018) | perfil real, sem espelho |
| `move_nw` | LOT16 P10 v01 | três-quartos de costas |
| `move_sw` | **LOT17**: SW00..SW05 (SW04 v03, demais v02), 6 PNGs individuais de 1254×1254 | candidata a **substituir a P9, que segue retida** (conflito de empunhadura e direção após três tentativas); a P9 não foi usada |

SHA-256 conferido contra os manifestos do LOT16 e do LOT17 (10 de 10). Brutos em `retorno/codex/`; os 6 quadros do SW foram juntos numa grade 3×2 por `tools/m1_compose_grid.gd` (sem mexer em pixel) para entrar no mesmo normalizador.

## Normalização

`tools/m1_normalize_strip.gd --grid=3x2` com os mesmos parâmetros do v03 aprovado (D22): altura média do corpo no chão 231 px, pé de apoio na linha 440, célula 512×512, âncora horizontal pela cabeça, uma escala por tira (0,59 a 0,62; SW 0,27 por vir de 1254 px). Nenhum pixel repintado. Saída em `.atena/generated/m1-movimento/piloto-durvall/candidata_v03/durvall/` (ao lado de `move_e`, `move_se`, `move_s` e `attack`).

| Tira | Altura por quadro (px) | Base (px) | Nota |
|---|---|---|---|
| move_n | 226 a 237 | 437 a 440 | ritmo regular, base estável |
| move_ne | 212 a 235 | 424 a 440 | 3 quadros no ar (base 424 a 430), como no contrato |
| move_w | 229 a 236 | 436 a 440 | passada longa (abertura dos pés 91 a 178 px) |
| move_nw | 207 a 235 | 418 a 440 | 3 quadros no ar; os quadros 5 e 6 sobem até 22 px |
| move_sw (LOT17) | 226 a 242 | 430 a 440 | quadros 4 e 5 mais altos (237 e 242); maior variação de contorno do pacote |

## Verificação

- `tools/check_m1_candidate.tscn` (novo): o laboratório carrega as 9 animações (8 `move_*` com 6 quadros e `attack` com 4) vindas da candidata, e `move_w`, `move_sw` e `move_nw` entram como reais (sem espelho): **0 falhas**. Folha de revisão: `avaliacao_v03/folha_8_direcoes.png`.
- Sem mudança de código do jogo (só ferramentas novas); o jogo normal e o `assets/` seguem iguais.

## Para ver no jogo (gate G-D4, seu)

`.atena/generated/walk-debug/Abrir-laboratorio-durvall-v03.cmd` abre o jogo no laboratório com a candidata completa a 10 fps (G-D2). Escolha o Durvall e ande nas 8 direções e ataque. Critérios: rosto não aparece ao andar para cima; espada sempre na mesma mão; sem salto de escala entre direções; passada sem patinar; SW serve ou não como substituta da P9. Observações a anotar por direção: serve, serve com ajuste ou refazer.

## Não verificado

Fluidez, sensação e o patinar (BUG-028) só pelo seu olho. BUG-025, 027, 028 e 029 seguem abertos. Admissão em `assets/` e migração do Durvall para a célula de 512 px só depois do seu aceite (D22). LOT15 (costas dos outros heróis) fica para os próximos lotes do M1, com a Nyrelia 03/04 retida.
