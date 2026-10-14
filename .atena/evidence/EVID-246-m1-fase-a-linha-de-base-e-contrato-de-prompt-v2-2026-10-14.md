---
id: "EVID-246"
title: "M1, Fase A: inventário, fichas de identidade, contrato de prompt v2 e régua dos heróis"
spec: "SPEC-176"
plan: "PLAN-103"
batch: "B-002"
created: "2026-10-14"
status: "Fase A concluída (S-001 a S-004); parada no portão G-D1; nada alterado no jogo"
content_state: DRAFT
---

# EVID-246 — Fase A do M1

## O que foi feito

| Passo | Resultado | Arquivo |
|---|---|---|
| S-001 Inventário | 12 heróis × 13 sequências, medidos por quadro (caixa de alfa, altura, base, margem) | `.atena/generated/m1-movimento/inventario.csv` |
| S-004 Régua | Altura em tela, altura do idle, base, escala, passo exigido a 10 fps e fps necessário por herói | `.atena/generated/m1-movimento/reguas.csv` |
| S-002 Fichas | 12 fichas DRAFT (Vault, Nottcard, idle e registros canônicos) e 7 pontos para o dono | `.atena/vault/drafts/FICHAS-DE-IDENTIDADE-herois-m1-2026-10-14.md` |
| S-003 Contrato v2 | Bloco comum, pose por quadro, 8 direções, mão da arma, gabarito, critérios T1 a T8 | `.atena/generated/ART-PROMPTS-064-contrato-de-prompt-v2-tiras-dos-herois.md` |

Ferramenta nova, somente leitura: `tools/m1_inventory.gd` (`godot --headless --path . -s tools/m1_inventory.gd`). Nenhum PNG, dado ou código do jogo foi alterado.

## Achados

1. **O patinar não é só de arte.** Com 190 px/s de tela e ciclo de 6 quadros a 10 fps, o corpo avança 57 px por passo, de 0,67 a 1,43 vez a altura do herói (Brook e Leoric, 40 px de tela, são os piores: 1,43). Um passo real é 0,4 a 0,65 da altura. Nenhuma tira, por melhor que seja, deixa de patinar nesse ritmo. A correção é arte (passo ≈ 0,55 × altura) **e** ritmo (fps por herói de 12 a 26).
2. **Os prompts antigos não usaram inimigos como imagem.** Zumbi e Bandido entraram só como faixa de métrica e na SPEC-123. O que foi anexado como referência de pose foi a **tira defeituosa**, que reinjeta o defeito.
3. **Tiras ausentes.** `move_w`, `move_sw` e `move_nw` não existem para arlindo, bromnor, brook, erik, leoric, nyrelia e zynara; o runtime carrega só 5 fontes (`WALK_SOURCE_DIRECTIONS`) e espelha o resto, em desacordo com o contrato de 8 fontes (PLAN-001 §26).
4. **Estabilidade da arte atual:** vários `move_w`, `move_sw`, `move_nw` legados (não carregados) têm margem 0 e base variando até 38 px (kayron, maelor, sylas, korrak); a maior parte das tiras em uso tem altura dentro de 5%, exceto `durvall attack` (24,7%), `durvall move_nw` (16,8%) e `nyrelia move_n` (9,6%).
5. **Fichas × fontes:** Kayron diverge entre sprite, Nottcard (asas negras e vermelhas) e Vault (asas brancas); a referência canônica de Brook (`brook-canonical-2026-09-29.png`) **não está no repositório**; "Grimholders" (jogo) × "Greenholders" (Vault).

## Pendências do dono (G-D1)

Revisar as fichas (Durvall, Zynara, Leoric e Nyrelia no mínimo), resolver P1 a P7 da ficha, entregar as referências em `.atena/generated/m1-movimento/refs/<herói>/` e dar a entrada do G-D2 sobre o ritmo por herói.

## Verificação

`tools/m1_inventory.gd` executado em modo headless sem erro; `reguas.csv` e `inventario.csv` gravados; nenhuma outra alteração fora de `.atena/` e `tools/m1_inventory.gd`.
