---
id: "SPEC-167"
title: "Avisos do topo sem acumular nem colidir com a ficha e a fala do herói (BUG-042, continua o BUG-036)"
status: "IMPLEMENTADA LOCAL em 2026-10-10 (PLAN-094, EVID-236); aguarda playtest; a pendência com quests foi resolvida pelo MEC-064 (SPEC-168)"
origin: planned
implementation_preceded_spec: false
request_classification: PLAN_DEVIATION
created: "2026-10-10"
relations: ["[[SPEC-147-correcoes-dos-playtests-v032-e-v033]]"]
cards: ["BUG-042", "BUG-036"]
visual_direction: "nenhuma mudança de estilo; só posição, largura, limite e ordem dos avisos"
---

# SPEC-167 — Avisos do topo sem acumular nem colidir

Origem: pedido do dono em 2026-10-10 ("vamos tentar arrumar isso: BUG-036 / PLAN-080 / SPEC-147"; sintoma escolhido: "avisos sobre avisos"). A pilha do topo (`TopStack`, SPEC-147) impede que chefe, quests, status e avisos se cubram **dentro** da pilha, mas a reprodução de 2026-10-10 achou quatro falhas que ela não cobre.

## Reprodução (1280×720; capturas em `.atena/generated/bug-036-diag/`)

| # | Falha | Medido |
|---|---|---|
| F1 | O limite de 4 avisos não vale: `toast()` testa `get_child_count() >= 4` e libera só o filho 0 com `queue_free()` (efetivo no fim do quadro); chamadas no mesmo quadro liberam o mesmo nó | rajada de 6 + epígrafe + rumor + 1 = 8 visíveis, pilha de 234 px |
| F2 | A pilha cresce sem teto de altura e desce até o centro da tela (herói em y≈330) | avisos de y=90 a y=324 |
| F3 | A fala do herói (`_bark`, `hero_node.position + (−95, −118)`, y≈215–245) cai dentro da zona da pilha | "Mais um rito contra a névoa." no meio das linhas da epígrafe |
| F4 | Avisos longos (640 px) saem da largura da pilha (680 px, x 300–980) e invadem a ficha do herói (até x=385) | epígrafe começa em x=336, sobre a moldura da ficha |

## Decisões do dono (2026-10-10)

| # | Decisão |
|---|---|
| D1 | Aprovação **por plano**. |
| D2 | Avisos longos (epígrafe da fase e rumor de Adam) entram **um de cada vez**; os curtos seguem empilhando no teto de altura. |
| D3 | A fala do herói **espera a pilha liberar** (no máximo 6 s), sem mudar de posição. |
| D4 | Rota: **fazer agora e voltar** ao PLAN-071 (B-006/S-011). |

## Comportamento novo

1. **Limite real.** Só contam avisos vivos (não marcados para remoção). Ao entrar um aviso, os mais antigos saem **na hora** (`remove_child` + `queue_free`) até caber em `TOAST_MAX_COUNT = 4` e `TOAST_MAX_HEIGHT = 120` px (cabe a epígrafe de 2 linhas e mais 3 avisos curtos).
2. **Largura.** Avisos quebram em `TOAST_WIDTH = 470` px (a pilha do topo fica em 480 para o aviso; a ficha termina em x=385, então `640 − 235 = 405 > 385`).
3. **Um longo por vez.** Aviso com mais de 60 caracteres entra numa fila; o próximo longo só aparece quando o anterior terminou. Curtos não esperam.
4. **Fala do herói.** `_bark` consulta o retângulo da pilha de avisos; a decisão é tomada no `_process` seguinte (o layout da pilha só assenta no quadro depois do aviso); se a fala cair dentro dele, fica pendente até 6 s e mostra quando liberar; passado o prazo, mostra mesmo assim.

## Fora do escopo

- Prioridade entre avisos, agrupamento de avisos repetidos, lettering e placas (ART-039), o plano de "mensagens ao centro" mais amplo.
- Faixa do Eco, apresentação do chefe, painéis modais: não mudam.
- Estilo (cor, fonte, contorno) dos avisos.

## Aceite

1. Rajada de 6 avisos curtos no mesmo quadro deixa no máximo 4 vivos, com altura ≤ 120 px (hoje 6).
2. Epígrafe + rumor + 1 curto: nunca dois longos vivos ao mesmo tempo; altura ≤ 120 px.
3. Nenhum aviso intercepta o retângulo da ficha do herói (`hero_panel`) em 1280×720 (a base do `expand`; 1920×1080 tem o mesmo layout); a fala não nasce sobre os avisos (medido na run real).
4. Fala pendente aparece ao liberar, ou ao fim de 6 s.
5. Suíte completa com 0 falhas; smoke; `mobile_buttons_check`; `controller_check`; uma mutação do teste novo (volta o `queue_free` sem contar vivos ⇒ o teste falha).
6. Subjetivo (a leitura em jogo ficou boa?) fica pendente de playtest.

## Reversão

Reverter o commit local; nada em dados, save ou assets.
