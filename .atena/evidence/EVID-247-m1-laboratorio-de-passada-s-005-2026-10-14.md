---
id: "EVID-247"
title: "M1, S-005: laboratório de passada (BUG-028), opções só de desenvolvimento"
spec: "SPEC-176"
plan: "PLAN-103"
batch: "B-002"
created: "2026-10-14"
status: "S-005 concluído local; sem commit; aguarda o olho do dono (G-D2)"
content_state: DRAFT
---

# EVID-247 — Laboratório de passada

## O que entrou

Quatro opções novas, **todas inertes sem `--walk-debug`** (o código existente só lê as opções nesse modo):

| Opção | Efeito | Onde |
|---|---|---|
| `--walk-fps=auto` | ritmo do ciclo por herói: `fps = velocidade × 6 / (2 × 0,55 × altura em tela)`, entre 8 e 30 | `ui/hero_view.gd` (`lab_walk_fps`) |
| `--walk-speed=N` | velocidade do herói em px/s, no lugar de 190 | `core/hero.gd` (`dev_speed_override`) |
| `--walk-bob=px` | balanço vertical sincronizado aos quadros (dois apoios por ciclo) | `ui/hero_view.gd` (`_lab_stride`) |
| `--walk-lean=rad` | inclinação sincronizada aos quadros | `ui/hero_view.gd` (`_lab_stride`) |

`--walk-fps=N` e as demais do SPEC-144 seguem como eram. Lançador: `.atena/generated/walk-debug/Abrir-laboratorio-de-passada.cmd`.

## Os seis caminhos do lançador

| # | Caminho | Opções |
|---|---|---|
| 1 | **C0** atual | `--walk-debug` |
| 2 | **C1a** ritmo por herói | `--walk-fps=auto` |
| 3 | **C1b** ritmo por herói + 160 px/s | `--walk-fps=auto --walk-speed=160` |
| 4 | **C1c** 15 fps fixo + 150 px/s | `--walk-fps=15 --walk-speed=150` |
| 5 | **C2** balanço e inclinação | `--walk-bob=2 --walk-lean=0.04` |
| 6 | **C1a + C2** | `--walk-fps=auto --walk-bob=2 --walk-lean=0.04` |

A tabela de passo por altura de cada caminho e herói está em `.atena/generated/m1-movimento/caminhos-passo-por-altura.md` (calculada, não medida em jogo).

## Verificação

- `tests/test_walk_lab.gd` (novo): fps esperado dos 12 heróis, limites 8 a 30, velocidade explícita, `dev_speed_override` (normal 190; com 120, 120), reforço desligado não mexe o sprite, ligado sobe e inclina no quadro 1, e assenta em zero ao parar.
- Suíte completa: **0 falhas**. **Mutação:** com `LAB_STEP_TO_HEIGHT` 0,55 → 0,40 o teste falha em 12 heróis; constante restaurada.
- Sem a flag o jogo é idêntico: `dev_speed_override` fica em 0 e `_dbg_bob` e `_dbg_lean` em 0.

## Limite honesto

O laboratório roda sobre a **arte atual**, cujos pés se movem pouco em todas as direções (EVID-197). Subir o fps (C1) acelera esse movimento curto, então o efeito esperado é **melhora parcial**: o ritmo e o balanço (C2) ajudam o olho, mas só a arte nova com passo ≈ 0,55 × altura (contrato v2) fecha o patinar. A escolha do G-D2 define o **ritmo** que a arte nova vai assumir.

## Para o dono (G-D2)

1. Jogar o lançador com 2 ou 3 heróis, incluindo um pequeno (Brook ou Leoric) e um grande (Korrak ou Zynara), andando de lado e nas diagonais.
2. Dizer qual caminho agradou e se o ritmo por herói (1 vs 2) parece natural.
3. Opcional (S-006): a coleta H5, rodando os modos do lançador de diagnóstico antigo.
