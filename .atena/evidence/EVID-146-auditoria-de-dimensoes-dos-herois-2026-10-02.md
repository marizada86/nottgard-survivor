---
id: "EVID-146"
title: "Auditoria de dimensões das animações dos dez heróis"
created: "2026-10-02"
relations: ["[[BUG-025]]", "[[ART-PROMPTS-055-regerar-caminhadas-e-acoes-dos-herois]]", "[[CHATGPT-FILA-024-regerar-tiras-dos-herois]]"]
---

# EVID-146 — Auditoria de dimensões dos heróis

Pedido do dono (2026-10-02): revisar os erros de dimensionamento de todos os heróis; Kayron nas diagonais de baixo "estica, cresce, afina"; Korrak com machado cortado e tamanho mudando ao andar.

## Método

Métrica por quadro (bbox alfa ≥ 0,10, célula 256 × 384) de `idle`, `move_n/ne/e/se/s`, `attack`, `active`, `death` dos dez heróis (500 quadros). Comparação com o idle: altura, **massa** (pixels opacos), linha de base, colagem na borda e variação entre quadros. A altura mediana já estava igualada por passadas anteriores (BUG-021); o que sobrava era variação **quadro a quadro**, massa e corte.

## Categorias de erro

| Cat. | Erro | Corrigível por código? |
|---|---|---|
| E1 | Altura varia entre quadros da mesma tira (zoom involuntário) | Sim — `tools/equalize_hero_frames.gd` |
| E2 | Pés flutuam/afundam em alguns quadros | Sim — mesma ferramenta |
| E3 | Arma/capa cortada na borda da célula, lascas no quadro vizinho | **Não** (pixel perdido) — regerar |
| E4 | Massa/largura da tira diferente do idle (corpo "engorda/afina") | **Não** — regerar |
| E5 | Quadro de ação (`attack`/`active`) com altura incoerente | Parcial; regerar os piores |
| E6 | Flip espelhado "preso" após andar à esquerda: arma muda de lado no idle/ataque | Sim — código |
| E7 | Estilo da caminhada (pixelada) ≠ idle (pintura suave): parece trocar de tamanho | Regerar ou andar com o idle |

## O que foi corrigido neste lote

- **E1 + E2:** 29 tiras `move_*` de Bromnor, Brook, Durvall, Kayron, Korrak, Maelor, Nyrelia e Sylas igualadas quadro a quadro à altura e base do idle (fator ≤ 1,2, largura ≤ 238 px). Segunda passada em modo relatório: nenhuma pendência. Suíte: 0 falhas.
- **E6/E7 do Korrak:** anda com o idle e balanço procedural, sem espelhar (`PROCEDURAL_WALK_HEROES` em `ui/hero_view.gd`).

## O que ficou para regerar (ART-PROMPTS-055)

- E3/E4 P1: Kayron `move_se` (massa 1,39×, 2 quadros na borda); Korrak `move_e/se/ne/s` (machado cortado); Bromnor `move_e/se` (massa 1,36×, pernas e laterais cortadas); Sylas `move_ne` (6 quadros na borda).
- E4 P2: Kayron `move_n/s` (1,21–1,24×); Sylas `move_s` (1,20×); Maelor `move_*` (0,53–0,67×, silhueta fina); Brook, Durvall, Nyrelia (variação).
- E5: Zynara `attack` (massa 2,7× entre quadros), Korrak `active`, Sylas `active` (0,57×), e demais.

## Pendências

- Falta olho humano no jogo nas oito direções (as tiras `move_sw/w/nw` em disco não são usadas; o jogo espelha `se/e/ne`).
- Regerar o `ASSET-OFFICIAL-LOCK` depois de admitir arte nova.
