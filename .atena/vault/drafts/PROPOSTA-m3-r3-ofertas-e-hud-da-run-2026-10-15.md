---
id: PROPOSTA-M3-R3
title: M3 R3, ofertas e HUD da run no padrão da janela UiKit
spec: SPEC-179
plan: PLAN-103 / B-004
content_state: DRAFT
status: proposta para o gate G-M3-3 do dono (2026-10-15)
---

# Proposta R3: ofertas e HUD da run no padrão UiKit

Origem: lote 3 da SPEC-165 ("ofertas — level-up, altar, loja — e HUD da run") e critério do M3 ("um jogador novo explica sozinho level-up, bênção, extrair/descer e questlog"). Nenhuma imagem nova: a moldura ornamentada que já existe na pausa e na ficha (C) é reaproveitada.

## Ponto de partida (capturas em `.atena/generated/m3-onboarding/r3-atual/` e `ui-primeiros-encontros/`)
| Tela | Hoje | Diferença para o padrão |
|---|---|---|
| Pausa, ficha C, Quartel | `UiKit.apply_window`: fundo de textura, moldura ornamentada, margem de 40 px | é o padrão |
| Level-up, altar, troca de item, loja | `PanelContainer` liso com borda dourada fina; cartões `OfferCard` com ícone e detalhe (já bons) | sem moldura, título solto, rodapé de teclas pequeno |
| Reviver ("Você caiu…") | caixa lisa, dois botões, texto corrido | sem moldura; botão principal igual ao secundário |
| Vitória/derrota | caixa lisa com banner de arte (bom) | só a moldura externa difere |
| Portal aberto (Extrair ou Descer) | **uma linha no rodapé**, sem destaque (lacuna alta do R1) | não é uma decisão visível |
| HUD da run (status, relógio, fase, armas, habilidade) | painel do herói já no padrão da ficha; relógio e rótulos com contorno (F-13); slot Q/RMB legível | ok; só a lista de armas e o objetivo ficam soltos |

## O que um protótipo mostrou (`r3-prototipo/`, só a ferramenta, nada no jogo)
A moldura da janela padrão **estica sem deformar** em painéis de 600 a 800 px de largura. O que falta é a margem interna (hoje o conteúdo encosta na borda), então cada painel precisa de um `MarginContainer` de 28 a 40 px. Sem arte nova.

## Rodadas propostas (um lote pequeno cada, com teste, captura antes/depois e commit próprio)
| Rodada | O que muda | Risco | Decisão sua |
|---|---|---|---|
| **R3a Ofertas** | Level-up, altar, troca de item e loja ganham a moldura da janela com margem; título em fonte de título; bênção ▲ e maldição ▼ com cor e legenda curta no rodapé; rerrolagem como botão secundário alinhado à direita; as teclas em uma linha só | médio: telas centrais e navegação por teclado/controle (foco) | layout abaixo |
| **R3b Decisão do portal** | Quando o portal abre, um cartão não modal e pequeno, embaixo ao centro, substitui a linha do rodapé: **Extrair [X] ×1,00 (seguro, encerra)** e **Descer [E] ×1,25 (mais risco)**, cores distintas; some ao escolher ou se o herói se afastar do portal | baixo | texto e posição |
| **R3c Reviver e fim de run** | Reviver na moldura com "Reviver" como botão principal (dourado) e "Encerrar tentativa" secundário; vitória e derrota mantêm o banner, com a mesma moldura | baixo | nenhuma |
| **R3d HUD** | Lista de armas e objetivos num bloco único no padrão do painel do herói; nada novo na tela | baixo | só se achar necessário |

## Esboço do layout das ofertas (R3a)
```
╔══════════════════ Nível 2 — escolha ═══════════════════╗
║ [ícone]  1. NOVA: Golpe Rápido                       Nv 1 ║
║          A adaga: golpes rápidos e curtos.                ║
║ [ícone]  2. NOVA: Constituição                            ║
║ ...                                                       ║
║ ───────────────────────────────────────────────────────── ║
║ W/S escolhem · Enter confirma · Shift detalhes   [Rerrolar R ×2] ║
╚══════════════════════════════════════════════════════════╝
Altar: título "Altar", colunas  ▲ Bênção   ▼ Maldição, rodapé "Recusar apaga o altar".
```

## Restrições que vou respeitar
- Foco e navegação por teclado e controle iguais aos de hoje (existem testes do controller: 94 verificações) e toque (146); rodo as duas baterias a cada tela.
- O tamanho do toque mantém os alvos de 44 px (`TouchUI.adapt_sizes`).
- A decisão do portal não pode roubar `E` em outro contexto: só vale com o portal ao alcance, como hoje.
- Nada de texto novo de lore; só rótulos de interface.
- Cada tela entra com captura antes e depois e pode ser revertida por commit.

## Recomendação
Fazer **R3b primeiro** (resolve a lacuna alta do R1 com o menor risco e é o que mais move o critério de aceite), depois **R3a** (tela por tela: level-up, altar, troca, loja) e **R3c**. R3d só se o teste com jogador novo pedir.

## Decisões pedidas (G-M3-3)
1. Aprova a ordem R3b → R3a → R3c?
2. R3b: o cartão do portal deve **substituir** a linha do rodapé (recomendado) ou conviver com ela?
3. R3a: o rodapé de teclas de uma linha com o botão Rerrolar à direita serve, ou prefere o botão embaixo como hoje?
