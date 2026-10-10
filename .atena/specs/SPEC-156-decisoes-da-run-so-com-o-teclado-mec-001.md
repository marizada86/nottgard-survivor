---
id: "SPEC-156"
title: "Decisões da run só com o teclado: W/S escolhem, Enter confirma (MEC-001)"
status: "IMPLEMENTADA e publicada em 2026-10-09 (EVID-213, f8111ec); aguarda playtest"
origin: planned
implementation_preceded_spec: false
request_classification: PLAN_DEVIATION
created: "2026-10-09"
relations: ["[[SPEC-135-experiencia-controles-xbox-playstation-2026-10-06]]", "[[SPEC-094-ofertas-em-cartao-resumido]]"]
cards: ["MEC-001"]
---

# SPEC-156 — Decisões da run só com o teclado (MEC-001)

Pedido do dono (2026-10-09, "siga para o item 7"); origem do cartão: nota 1 do [EVID-088](../evidence/EVID-088-qa-leoric-dagruve-2026-09-27.md). Risco: **baixo** (entrada), sem arte.

## O que já existia (lido em 2026-10-09)

- As teclas **1 a 9** escolhem a opção direto (`ui/run.gd`), e **R** rerrola.
- A primeira opção nasce focada; as **setas** movem o foco pelo próprio Godot; **Enter** e **Espaço** confirmam o botão focado (`ui_accept`).
- **W e S não faziam nada** nas ofertas (WASD só anda, e a run está pausada nessas telas).

## Lacuna

O cartão pedia WASD para escolher e Enter para confirmar: faltava o WASD.

## Regra

1. Nos estados `levelup`, `altar`, `item_offer` e `shop`, **W e A** voltam uma opção e **S e D** avançam, dando a volta no fim da lista (`Hud.offer_key_step` e `Hud.offer_focus_step`).
2. Opções **travadas** (sem moeda) nunca recebem o foco; sem opção que aceite foco, nada acontece.
3. **Enter e Espaço** confirmam a opção focada (comportamento existente); **1 a 9** continuam escolhendo direto.
4. A dica da oferta no teclado passa a dizer "W/S ou setas escolhem, Enter confirma, 1 a 9 escolhem direto"; a dica do controle não muda.
5. Controle, toque e mouse não mudam.

## Não objetivos

Navegar pelo Quartel e pelos menus com WASD (continua com setas, como já funciona); remapear teclas; mudar o atalho de rerrolagem.

## Critérios de aceite

1. W/A e S/D movem o foco por todas as opções e dão a volta; as demais teclas não mexem (`offer_key_step`).
2. Opções travadas nunca recebem o foco.
3. Uma tecla real (S, D, W) enviada à cena da run muda o foco e Enter fecha a oferta de nível e volta ao jogo.
4. Mutação: sem a troca de foco, o teste falha.
5. Suíte, smoke e `kit_test` sem falhas novas.

## Lacunas

Nenhuma `BLOCKING`.
