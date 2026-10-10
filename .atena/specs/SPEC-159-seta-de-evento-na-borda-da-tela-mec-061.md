---
id: "SPEC-159"
title: "Seta de evento na borda da tela, com distância (MEC-061)"
status: "IMPLEMENTADA e publicada (2d929b0, EVID-221); aceite subjetivo pendente do playtest"
origin: planned
implementation_preceded_spec: false
request_classification: PLAN_DEVIATION
deviation_id: DEV-020
created: "2026-10-09"
relations: ["[[SPEC-147-correcoes-dos-playtests-v032-e-v033]]", "[[SPEC-118-acontecimentos-exclusivos-por-fase]]", "[[SPEC-129-caminho-de-tou-um]]"]
cards: ["MEC-061"]
---

# SPEC-159 — Seta de evento na borda da tela (MEC-061)

Pedido do dono (2026-10-09, "Atena, vamos fazer um plano para adicionar um indicador de evento"): quando houver um evento no mapa e ele não estiver na parte visível da tela, aparece uma seta mostrando onde ele está. Decisões do dono no mesmo dia: seta na borda com distância; todos os eventos de quest com posição; a mudança entra na **v0.4.0**, que ainda não foi divulgada (sem trocar a versão; os testers recebem a build atualizada e testam as novidades). Risco: **baixo** (só desenho de HUD e uma função pura), sem arte nova.

## O que já existe (lido em 2026-10-09)

- `Happenings.markers(b)` ([core/happenings.gd:578](../../core/happenings.gd)) devolve `{pos, color}` para itens, alvos, NPCs e estrela de quest (`event_*` não usados), escoltas e inimigos de quest marcados.
- `Overlay._draw_happenings` ([ui/overlay.gd:583](../../ui/overlay.gd)) já realça o marcador **dentro** da tela (anel pulsante e seta que balança, SPEC-147) e desenha uma seta **fora** dela, mas em coordenadas do mundo, a 240 px do herói, com 14 px de ponta: não fica na borda, não diz a distância nem o nome e se perde no cenário.
- A Estrela do Norte (`Overlay._draw_star_path`, SPEC-129) tem uma seta própria idêntica; o círculo da arena (`Happenings.arena`) não tem seta.

## Lacuna

A seta atual não cumpre o pedido: não indica a borda da tela nem quanto falta, e há eventos com posição sem seta (arena, Estrela do Norte usa um desenho à parte).

## Regra

1. **Fonte única.** `Happenings.markers(b)` passa a devolver também `label` (nome curto, até 18 caracteres) e `kind`, e inclui o centro da arena e a Estrela do Norte (`battle.kinds.star_pos()`). Escolta, NPC, item, alvo, altar de pacto, estrela de quest, inimigo marcado e arena entram; **segredos (Ecos, altares da fase) não entram**, para não quebrar a regra de pista (`eco_pista`).
2. **Função pura e testável.** `EventPointer.edge_point(view: Rect2, hero_screen: Vector2, target_screen: Vector2) -> Dictionary` devolve `{visible: bool, pos: Vector2, angle: float}`: `visible` quando o alvo está dentro de `view`; senão, o ponto onde o raio herói→alvo cruza a borda de `view` (já encolhida pela margem) e o ângulo da seta.
3. **Desenho em espaço de tela** (nó de HUD, não do mundo): seta triangular na cor do marcador (brilho mínimo como o anel), contorno escuro, ancorada à borda; ao lado, texto `Nome · 24 m` com a distância em tiles do herói, arredondada de 1 em 1. A seta fica inteira dentro da tela com margem de 28 px; o texto vira para dentro quando a seta está na borda direita ou inferior.
4. **Dentro da tela** nenhuma seta de borda: o anel e a seta balançando da SPEC-147 continuam como estão.
5. **Sem empilhar.** Marcadores a menos de 40 px entre si na borda se fundem numa seta com contagem (`×2`); no máximo 6 setas ao mesmo tempo (as mais próximas).
6. **Evita a HUD.** A margem respeita o painel de quests (topo), a barra de vida e, no celular, os controles de toque (`Game.controls`/`mobile_controls`); as setas deslizam ao longo da borda, nunca entram nesses retângulos.
7. As setas antigas do mundo (`_draw_happenings`, fora da tela, e `_draw_star_path`) são removidas, sem duplicar. Pausa, oferta, baú e telas de fim: as setas somem junto com a HUD da run.
8. Pulso suave de 0,6 s na entrada de um evento novo (a seta aparece com um halo e cresce por 0,6 s). Sem som novo; sem opção nas configurações nesta entrega.

## Não objetivos

Setas para segredos, Ecos, inimigos comuns, chefe (já tem barra), saída da fase; minimapa; som; arte nova; mudar a versão do jogo; alterar o balanceamento ou a lógica dos eventos.

## Critérios de aceite

1. `edge_point`: alvo dentro de `view` devolve `visible=true`; alvos nas oito direções devolvem um ponto sobre a borda encolhida e o ângulo certo; alvo coincidente com o herói não gera divisão por zero.
2. `markers()` devolve um item por evento aberto, com `label` e `kind`; um evento concluído, falhado ou já usado some; a arena e a Estrela do Norte aparecem; Ecos não aparecem.
3. Em uma run real (bot/smoke) com um evento a 15 tiles do herói, a seta aparece na borda; quando o herói chega perto, a seta some e o anel assume; a distância diminui ao andar.
4. A seta não sobrepõe o painel de quests nem os controles de toque (teste com `mobile_preview` em 1280×720 e 375×812).
5. Mutação: sem o `clamp` à borda ou sem a fusão, o teste falha.
6. Suíte completa, smoke e `kit_test` sem falhas novas; capturas antes/depois em 1280×720 e 1920×1080 registradas no EVID.
7. Aceite subjetivo (legibilidade, incômodo, clareza) fica **pendente do playtest** do dono; nenhuma métrica o substitui.

## Playtest (a explicar antes de entregar)

O que testar: uma run de Dagruve com evento de coleta, escolta e arena, olhando se a seta aponta certo, se atrapalha a HUD e se a distância ajuda. Procedimento, build e critérios saem no aviso de entrega, antes de qualquer teste.

## Lacunas

- `G1` (não bloqueante): o dono disse "tratar tudo como v0.4.0". Esta spec entra na 0.4.0 sem trocar a versão. Falta confirmar se o PLAN-083 (hoje chamado v0.5.0) também deve ser reclassificado; **não toco nele** sem decisão.
- `G2` (não bloqueante, adiado): opção de ligar/desligar as setas nas configurações.
- `G3` (não bloqueante): exportar o `.exe`, commit e push exigem aprovação explícita à parte (o push publica o release `latest`).

Nenhuma `BLOCKING`.
