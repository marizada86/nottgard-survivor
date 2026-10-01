---
id: "ART-PROMPTS-051"
type: "prompts-de-arte"
title: "Piloto de VFX — corpo a corpo físico (kit base)"
status: "pronto para envio — nada gerado"
created: "2026-10-01"
relations: ["[[PLAN-051-vfx-de-ataques-e-magias-2026-10-01]]", "[[CHATGPT-FILA-020-piloto-vfx-corpo-a-corpo-fisico]]"]
sources: ["data/weapons.json", "ui/run.gd", "core/divine_visuals.gd"]
---

# ART-PROMPTS-051 — Piloto de VFX: corpo a corpo físico

Valida a receita do [[PLAN-051-vfx-de-ataques-e-magias-2026-10-01]] com duas formas de golpe físico: **A, corte médio** (adaga, esmagador, espada sombria, lâmina da digestão, rajada infinita; cone de 45 a 60°) e **B, arco largo** (golpe atordoante, espada do receptáculo; cone de 90 a 100°). A estocada longa (chicote, estocada) fica para a rodada seguinte.

As filas operacionais estão em [[CHATGPT-FILA-020-piloto-vfx-corpo-a-corpo-fisico]], com o texto completo de cada prompt.

## Contrato comum

- Fundo preto `#000000`, só o efeito, branco e cinza, sem cor, bordas suaves.
- Vista de cima, achatada; o jogo aplica a compressão isométrica 2:1.
- Tela 1024 × 1024, pivô no centro, golpe apontando para a direita, alcance até 45 % da largura.
- Sem personagem, arma, mão, texto, borda ou chão.
- Seis quadros de cerca de 0,2 s no total, cada um em imagem independente.

## Linha do tempo dos 6 quadros

| Quadro | Estado | O que se vê |
|---|---|---|
| 01 | start | lasca fina e brilhante no pivô, um quarto do comprimento final |
| 02 | sweep | crescente em expansão, ponta brilhante, rastro fraco, cerca de 60 % do alcance |
| 03 | peak | **gate de estilo**: comprimento e espessura máximos, núcleo branco, faíscas na ponta |
| 04 | hold | ainda estendido, afinando, bordas irregulares |
| 05 | fade | arco se quebra em estrias, cinza mais escuro |
| 06 | dissipate | só fiapos e pontos quase pretos |

## Formas

| Código | Forma | Arco | Largura relativa | Armas cobertas |
|---|---|---|---|---|
| A | corte médio | cerca de 110° | fina a média | adaga, esmagador, espada sombria, lâmina da digestão, rajada infinita |
| B | arco largo | cerca de 200° | espessa, pesada | golpe atordoante, espada do receptáculo |

## Critérios de aprovação

- Fundo realmente preto, sem degradê nem vinheta.
- Pivô no centro e golpe para a direita; o quadro 03 é o mais forte e o 06 o mais fraco.
- Os 6 quadros parecem a mesma espada: mesma espessura de linha, mesmo brilho, mesma textura.
- Sem cor, sem personagem, sem texto.
- Lê bem a 96 px de largura (o alcance de uma adaga na tela).

## Rejeição imediata

Cor saturada, fundo não preto, arma ou mão visível, efeito apontando para outra direção, quadros com estilos diferentes, desenho de perspectiva em vez de vista de cima.

## Prompts

Texto integral em [[CHATGPT-FILA-020-piloto-vfx-corpo-a-corpo-fisico]] (A01 a A06 e B01 a B06).
