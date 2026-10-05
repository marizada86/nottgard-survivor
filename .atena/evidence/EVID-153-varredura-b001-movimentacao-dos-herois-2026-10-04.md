---
id: "EVID-153"
title: "B-001: varredura da movimentação dos heróis jogáveis (PLAN-057 / SPEC-123)"
created: "2026-10-04"
relations: ["[[SPEC-123-revisao-da-movimentacao-dos-herois]]", "[[PLAN-057-varredura-e-movimentacao-dos-herois-2026-10-04]]", "[[EVID-146-auditoria-de-dimensoes-dos-herois-2026-10-02]]"]
---

# EVID-153 — B-001: varredura da movimentação dos heróis

Nada do jogo foi alterado neste lote (só leitura e scripts de rascunho fora do projeto).

## Verificações

- `tests/run_all.gd`: **0 falhas** (o aviso de RIDs vazados ao sair já existia).
- `tools/audit_hero_motion.gd`: contrato 256×384 ok nas 50 tiras de caminhada, `edge_frames` = 0 em todas.
  Alturas já normalizadas; sobras: Nyrelia `move_n` 319–352 px (33), Brook idle 17, Brook `move_se` 11, Kayron `move_e` 11, Sylas `move_se` 11.

## Frente ou costas ao andar (olho nas tiras, quadros 0–5)

Esperado: ao andar para cima (N, NE, NO) o herói mostra as costas ou 3/4 de costas.

| Herói | N | NE | S/SE/E | Direções O, SO, NO |
|---|---|---|---|---|
| Bromnor | costas | costas | ok | espelhadas |
| Brook | costas | costas | ok | espelhadas |
| Durvall | costas | costas | ok | próprias |
| Kayron | costas | costas | ok | próprias |
| Korrak | costas | costas | ok | próprias |
| Maelor | costas | costas | ok | próprias |
| Sylas | costas | costas | ok | próprias |
| **Zynara** | **frente** (rosto e ampulheta) | **3/4 de frente** | ok | espelhadas (NO herda o erro) |
| **Leoric** | **frente** (rosto e barba) | **frente** | ok | espelhadas (NO herda o erro) |
| **Nyrelia** | **frente** (máscara e broche) | **3/4 de frente** | ok | espelhadas (NO herda o erro) |

Conclusão: o problema do dono (Zynara) vale também para **Leoric e Nyrelia**. Em todos eles N, NE e NO estão errados e N é quase igual a S.
Os outros 7 estão corretos nas direções para cima. Bromnor, Brook, Leoric, Nyrelia e Zynara não têm tiras O/SO/NO próprias (espelham as de leste); isso troca a arma de mão ao virar e é limite aceito.

## Referência dos inimigos (Zumbi e Bandido)

Zumbi e Bandido (`cultista_adaga`) têm uma tira `move` virada para a câmera (3/4 frontal), espelhada pelo sinal do movimento horizontal (`flip_h_for_move`, `ui/enemy_view.gd`), sem variação por direção vertical. Faixa medida em 6 quadros:

| Métrica | Zumbi | Bandido |
|---|---:|---:|
| variação de largura | 15,6 % | 0 % |
| variação de altura | 0 % | 8,1 % |
| deslocamento do centro (px / % da largura) | 9,1 / 4,9 % | 5,1 / 2,1 % |
| variação da base | 0 | 0 |
| variação da massa visível | 12,3 % | 14,9 % |

## Heróis fora dessa faixa (limiar: centro > 9,1 px ou largura > 15,6 % ou massa > 15 % ou base > 0)

| Tira | Medida fora da faixa |
|---|---|
| Sylas `move_se` | centro 25,6 px (11,6 %) |
| Sylas `move_n` | centro 19,2 px, base 2 |
| Sylas `move_e` | centro 17,7 px, base 6 |
| Zynara `move_e` | largura 19,9 %, centro 16,2 px |
| Nyrelia `move_s` | largura 18,9 %, centro 13,1 px |
| Nyrelia `move_n` | largura 16,5 %, altura 9,6 % |
| Nyrelia `move_ne` | centro 10,3 px |
| Leoric `move_n` | centro 14,1 px (7,3 %) |
| Leoric `move_s` | centro 10,2 px |
| Leoric `move_se` | centro 9,5 px |
| Kayron `move_e` | centro 12,5 px, base 3 |
| Kayron `move_ne` | base 6 |
| Durvall `move_n` | massa 28,5 % |
| Brook `move_s` | centro 8,0 px (dentro) |

Limitação: a faixa vem de apenas 2 inimigos e 6 quadros cada; é régua de alarme, não veredito. Quem decide é o olho do dono.

## Estado do repositório (para o B-004)

102 arquivos alterados sem commit. Gameplay: `core/battle.gd` e `data/difficulty.json` (XP, sessão de balanceamento, SPEC-122/EVID-152), `ui/run.gd` e `ui/enemy_view.gd` (Zuggtmoy e flip dos inimigos novos, PLAN-053), `tests/test_animation_assets.gd`, 6 pastas de inimigos novos em `assets/animations/enemies/` e ferramentas de Shedaklah. Backlog: P0 = 0; BUG-025 (P1) aberto; 7 P1 implementados aguardam playtest; BUG-026 (P2, `copias_do_guardiao` em `at: 400` numa fase de 300 s) aberto.

## Incidente de coordenação

Duas sessões criaram plano e spec com os mesmos números (PLAN-056 e SPEC-122) em 2026-10-04. A sessão de balanceamento chegou primeiro (SPEC-122 às 00:50). A sessão de movimentação renumerou o seu trabalho para PLAN-057 e SPEC-123 e **sobrescreveu `.atena/state/plan.yaml` sem reler antes**; o conteúdo anterior foi reconstruído em `plan.yaml` (marcado como reconstrução) e o plano de movimentação ficou em `.atena/state/plan-057-movimentacao.yaml`.
