---
id: EVID-261
title: M2 R5, opção E (conferência em run real) e amostras de C e D
spec: SPEC-177
plan: PLAN-103 / B-003
date: 2026-10-15
content_state: DRAFT
---

# EVID-261 — M2 R5: E (conferência) e amostras C/D

Gate G-M2-3 (2026-10-15): "1. aprovo; 2. selecione 3 para teste, sendo um deles um dos 3 primeiros". A e B já tinham sido feitos e commitados por outra sessão (EVID-257, `798ef398` e `bd0356c4`); não foram refeitos aqui. Nenhum arquivo do jogo foi alterado nesta rodada, só ferramentas e capturas.

## E — conferência em run real (`tools/capture_juice_check.tscn`, `tools/capture_transition.tscn`)
Capturas: `.atena/generated/m2-game-feel/r5-e/` (mare_010/025/050, loot_comum/magico/raro/unico, transicao/00 a 07).

| Item | Resultado |
|---|---|
| D4 Maré do Abismo | Marcos 10, 25 e 50 disparam o aviso e o bônus de XP (2%, 4%, 6%); os nomes "Maré Cinzenta" e "Maré Negra" aparecem. **Legibilidade ruim:** texto violeta escuro, sem contorno, sobre a pedra (ver F-11). Abates injetados pela mesma função do jogo, não mortes reais. |
| D6 Revelação do loot | Anel e nome na cor da raridade aparecem acima do herói; legível no único (laranja, 18 px). Não conferidos: comum e mágico em fase clara. |
| Transições (MEC-003) | Ficha (C) e pausa abrem, ficam abertas e fecham sem quadro quebrado nas 8 capturas. O fundo translúcido da pausa deixa o texto da HUD aparecer atrás do título "PAUSA" (F-12, leve). |

## Achados novos
| # | Achado | Proposta |
|---|---|---|
| F-11 | **Textos de aviso e de introdução sem contraste:** o aviso da Maré (violeta), o nome do item equipado ("Anel de Prata Blindado [Mágico]", azul) e a introdução de Molor ("Molor — …o Estige corre…", cinza escuro sobre verde escuro) ficam quase ilegíveis sobre o chão. Dagruve se salva por ter texto claro | Contorno escuro de 2 a 3 px e cor mais clara nos avisos (toast), e cor clara na introdução das fases escuras. Só código, mesmo padrão dos números de dano |
| F-12 | A HUD aparece por trás do painel translúcido da pausa, sobre o título | Escurecer um pouco mais o fundo do painel ou esconder a HUD enquanto a pausa está aberta (baixa prioridade) |

## Amostras C e D (`tools/capture_atmosphere_samples.tscn`, protótipo só da ferramenta)
Fases: **Dagruve** (uma das três primeiras), **Molor** e **Durao**. Para cada uma: base, C (partículas), D (gradação), C+D em `.atena/generated/m2-game-feel/r5-cd-amostras/`.

| Fase | C: partículas ambientais | D: gradação (tom, saturação, vinheta) |
|---|---|---|
| Dagruve | cinza lenta de cemitério, cinza-lilás | frio, saturação 0,88, vinheta 0,28 |
| Molor | esporos verdes subindo | verde quente, saturação 1,08, vinheta 0,22 |
| Durao | fagulhas frias à deriva, ciano | azulado, saturação 0,94, vinheta 0,26 |

Leitura minha (não é aceite): as partículas ficam discretas e não poluem; em Molor o efeito aparece bem, em Dagruve é sutil. A gradação muda o clima em Molor e quase nada em Dagruve. **Desempenho não medido** na máquina fraca emulada; é pré-condição de D.

## Pendente humano
Escolher quais das 3 amostras (C, D, ambas ou nenhuma) valem virar recurso, e dizer se a intensidade está certa.

## R5 F-11, F-12, F-13 e C+D implementados (G-M2-4, 2026-10-15)
Decisão do dono: "aprovo F-11 e F-12, e C só em ambos" (C e D entram juntos como uma opção, nunca separados). Grafia confirmada: **Durao**, sem til.

| Item | O que mudou |
|---|---|
| **F-11** | `ui/hud.gd`: `legible_toast_color` garante luminância mínima 0,68 (a cor entra como cor da fonte, não como modulate sobre a fonte creme do tema) e o contorno vai a 6 px. Aviso da Maré e nome de item deixam de sumir sobre a pedra. A introdução de Molor que parecia ilegível estava em fade na hora da captura; o contraste dela já era bom |
| **F-12** | `ui/hud.gd`: com a pausa aberta, o painel do herói e os avisos ficam ocultos (não aparecem atrás do título) |
| **F-13 (novo)** | Relógio, nome da fase, lista de armas e nome do chefe somem em piso claro (Goranthis). Contorno preto de 5 a 6 px em `_outline_world_labels` |
| **C + D (Atmosfera)** | `ui/atmosphere.gd`, `ui/atmosphere.gdshader`, `data/atmosphere.json` (9 fases). Opção "Atmosfera: Desligada / Leve" em Opções → TELA (`settings.atmosphere`, padrão Leve, valor inválido volta para Leve; `Game.set_atmosphere`). Partículas na camada do texto e gradação na camada do filtro, criadas antes do filtro de tela. Impacto reduzido tira as partículas e mantém a gradação; aparelho de toque fica desligado. Desligada não desenha nem processa nada |

**Verificação:** `tests/test_toast_legibility.gd` e `tests/test_atmosphere.gd` novos; suíte 0 falhas; smoke das 9 fases ok. Capturas: `.atena/generated/m2-game-feel/r5-cd-nove-fases/` (9 fases, Desligada e Leve), `r5-cd-contraste/` (Goranthis, Feng Tu, Durao com o contorno), `r5-f11-f12/` (Maré e pausa depois da correção).

**Custo (GTX 1660 Super, vsync desligado, 240 quadros por modo):** +0,0 a +0,3 ms por quadro (média de +0,08 ms; a maior diferença foi Goranthis, +0,3 ms, que pode ser ruído). **Máquina fraca emulada não medida**: segue pendente (`FrameStats` do PLAN-099).

**Não verificado (humano):** se a intensidade da gradação e das partículas está boa em cada fase; se a vinheta da gradação soma demais com a vinheta de vida baixa (A). Os perfis das 6 fases novas (Docas, Shedaklah, Feng Tu, Shendilavri, Goranthis, Pilares) são palpites meus (DRAFT).
