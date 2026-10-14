---
id: "EVID-248"
title: "M1, S-008: piloto Durvall, retorno do move_e v01 (auditoria e candidata local)"
spec: "SPEC-176"
plan: "PLAN-103"
batch: "B-002"
created: "2026-10-14"
status: "move_e v01 auditado; candidata local pronta para ver no jogo; sem admissão"
content_state: DRAFT
---

# EVID-248 — Piloto Durvall, `move_e` v01

Retorno bruto: `.atena/generated/m1-movimento/piloto-durvall/retorno/durvall_move_e_v01.png` (1774×887, **alfa real**, 6 quadros separados, nenhum encostado no vizinho).

## Auditoria (contrato v2, §9)

Normalizado por `tools/m1_normalize_strip.gd` (uma escala para todos: 0,6535; base do pé de apoio em y = 376; âncora pela cabeça). Nenhum pixel foi repintado.

| Critério | Medido | Alvo | Veredito |
|---|---|---|---|
| T1 alfa e quadros | alfa nativo; 6 componentes | 6 quadros, alfa real | Passa |
| T2 altura do corpo | 223 a 235 px (média 229; ±2,6%) | 231 ± 3% | Passa |
| T3 base do apoio (quadros 1, 2, 4, 5) | 376 nos quatro | 376 ± 1 | Passa |
| Fase aérea (quadros 3 e 6) | pé 18 px acima da base (7,8% da altura) | ≤ 6% | **Levemente acima**; aceitável em corrida, a olho |
| T4 passo no contato | abertura dos pés 186 e 187 px (ponta a ponta de bota), ≈ 145 px de passo | 127 (faixa 104 a 143) | **No limite alto**; passada longa, favorável contra o patinar |
| T5 folga (nas células do jogo) | esquerda 24 a 47, direita 7 a 28, topo 136 a 150, base 7 a 25 | ≥ 2 px na integração | Passa (direita do quadro 1 com 7 px: espada) |
| T6 massa e largura | 182 a 225 px de largura (idle 189) | idle ± 8% por quadro | Varia com a pose; quadro 1 largo (espada à frente) |
| T8 identidade | pele cinza-azulada, cabelo branco longo, armadura negra laminada, faixa vinho, pendente azul, espada azul-gelo | ficha 1 | Confere (olho do dono: "parece bom") |

Observações: a espada ficou na mesma mão em todos os quadros; quadros 1 e 4 são pernas trocadas (não são cópia espelhada); a faixa vinho e o cabelo acompanham o movimento sem cortar.

## Para ver no jogo (sem admitir nada)

`.atena/generated/walk-debug/Abrir-laboratorio-de-passada.cmd`, opções:

- **7:** candidata `move_e` com o ritmo por herói (Durvall 17 fps);
- **8:** candidata a 10 fps (ritmo atual).

Escolha o Durvall e ande para a direita (e para a esquerda, que usa o espelho). As demais direções seguem na arte atual. A candidata só existe em memória: `--walk-candidate=<pasta>` lê `<pasta>/<herói>/move_e.png`; nada é gravado em `assets/`.

## Mudanças de código desta etapa

`ui/hero_view.gd` (`_lab_apply_candidate`, ativo só com `--walk-debug --walk-candidate`), `tools/m1_normalize_strip.gd` (novo). Suíte: **0 falhas**. Sem a flag a textura de `move_e` continua `CompressedTexture2D` do `assets/`; com a flag vira a candidata (verificado).
