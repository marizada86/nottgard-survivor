---
id: "ART-PROMPTS-056"
type: "prompts-de-arte"
title: "Costas ao andar para cima: Zynara, Leoric e Nyrelia (move_n e move_ne)"
status: "prompts prontos; nenhuma imagem gerada (sem gerador de imagem na sessão)"
priority: "alta"
created: "2026-10-04"
relations: ["[[SPEC-123-revisao-da-movimentacao-dos-herois]]", "[[EVID-153-varredura-b001-movimentacao-dos-herois-2026-10-04]]", "[[ART-PROMPTS-055-regerar-caminhadas-e-acoes-dos-herois]]"]
cards: ["ART-033", "BUG-027"]
---

# ART-PROMPTS-056 — costas ao andar para cima

Origem: pedido do dono em 2026-10-04 ("Zynara, ao andar para trás, não vira de costas") e a varredura do [[EVID-153-varredura-b001-movimentacao-dos-herois-2026-10-04]]: Zynara, Leoric e Nyrelia mostram o **rosto** em `move_n` e `move_ne` (e, por espelho, em `move_nw`). Os outros 7 heróis estão corretos.

Prompts prontos em `.atena/generated/heroes-back-walk-prompts-2026-10-04.json` (6 entradas: `hero`, `sequence`, `version`, `prompt`), no formato do `heroes-walk-prompts-correcoes-2026-10-02.json`.

## Como executar

Mesmo fluxo da [[ART-PROMPTS-055-regerar-caminhadas-e-acoes-dos-herois]]: uma tira por chamada, anexando (1) `assets/animations/heroes/<heroi>/idle.png`, identidade e massa obrigatórias, e (2) a tira atual `move_n` ou `move_ne`, só como ritmo de passo e escala (ela está errada na direção). Empacotar com `tools/pack_hero_candidate_strip.gd` e auditar com `tools/audit_hero_candidate_strip.gd` e `tools/check_hero_candidate_acceptance.gd`.

| Código | Herói | Sequência | Altura-alvo | Base-alvo | Item que deve continuar visível |
|---|---|---|---:|---:|---|
| B01 | Zynara | `move_n` | 368 | 376 | ampulheta na mão esquerda dela (esquerda da tela) |
| B02 | Zynara | `move_ne` | 368 | 376 | ampulheta, esquerda da tela |
| B03 | Leoric | `move_n` | 224 | 368 | cajado com cristal azul na mão direita dele (direita da tela) |
| B04 | Leoric | `move_ne` | 224 | 368 | cajado, direita da tela |
| B05 | Nyrelia | `move_n` | 352 | 368 | capa com painel dourado bordado nas costas |
| B06 | Nyrelia | `move_ne` | 352 | 368 | idem, de três quartos de costas |

## Decisão de design que o dono precisa ver

Não existe arte das costas desses três heróis (idle, retrato e todas as tiras são de frente ou perfil). Os prompts pedem as costas **inventadas a partir da frente**: cabelo longo caindo nas costas e bordado da barra (Zynara), traseira do casaco e chapéu (Leoric), painel dourado vertical nas costas da capa (Nyrelia). Antes de integrar, o dono aprova o primeiro quadro de cada herói.

## Aceite

1. Em `move_n` e `move_ne`: nenhum rosto, olho, nariz, máscara frontal ou broche frontal em nenhum dos 6 quadros (olho do dono).
2. Item na mesma mão do idle em todos os quadros.
3. `tools/audit_hero_motion.gd`: altura mediana = idle (±3%), `height_spread` ≤ 12 px, `edge_frames` = 0, base = `HERO_FEET_Y`.
4. Estabilidade dentro da faixa de Zumbi e Bandido ([[EVID-153-varredura-b001-movimentacao-dos-herois-2026-10-04]]): deslocamento do centro ≤ 9 px, variação de largura ≤ 16%.
5. `move_nw` (espelho de `move_ne`) conferido no jogo: o item troca de lado ao espelhar, limite já aceito.
6. Suíte com 0 falhas; `HERO_IDLE_ART_HEIGHT` só muda se a altura do idle mudar.

Marque `[x]` ao gerar e `[a]` ao aprovar.

- [ ] gerada · [ ] aprovada — B01 Zynara `move_n`
- [ ] gerada · [ ] aprovada — B02 Zynara `move_ne`
- [ ] gerada · [ ] aprovada — B03 Leoric `move_n`
- [ ] gerada · [ ] aprovada — B04 Leoric `move_ne`
- [ ] gerada · [ ] aprovada — B05 Nyrelia `move_n`
- [ ] gerada · [ ] aprovada — B06 Nyrelia `move_ne`
