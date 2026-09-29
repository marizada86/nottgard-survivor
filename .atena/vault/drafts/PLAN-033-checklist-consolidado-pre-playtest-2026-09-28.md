# PLAN-033 — Checklist consolidado de verificação manual (SPEC-059 a 064)

Status: **pronto para uso — recomendado antes de qualquer novo playtest ou
antes de abrir mais specs de gameplay.**

## Por que este documento existe

Seis specs de gameplay foram implementadas nesta sessão (SPEC-059, 060, 061,
063 + amendment, 064) e todas têm a mesma exceção registrada: **suíte e
smoke verdes, mas nenhuma checagem manual interativa numa run real.** Cada
EVID (089, 090, 092, 093, 094, 095) registra isso separadamente. Em vez de
abrir mais uma spec de gameplay em cima dessa pilha, este documento junta
tudo num roteiro só, pra rodar de uma vez numa run real (perfil QA) antes do
próximo passo.

## Roteiro (uma run só, perfil QA)

### 1. Abertura e HUD básico
- [ ] Abrir uma run qualquer no perfil QA. Confirmar que o HUD normal (vida,
      XP, moedas, armas) aparece sem erro.
- [ ] Ver o hint fixo `[C] Itens e feitiços` no canto da tela.

### 2. Painel de itens / ficha de personagem (SPEC-059 + extensão)
- [ ] Apertar `C`: painel abre, retrato do herói aparece, atributos
      (FOR/INT/CON/CAR, PV, CA, CAM) e a linha de bônus agregados fazem
      sentido.
- [ ] Rolar a lista se o herói tiver várias armas/passivas/itens/bênçãos —
      confirmar que nada corta ou sobrepõe.
- [ ] Fechar com `C` e de novo com `Esc` — os dois devem funcionar, sem
      travar o jogo pausado.

### 3. Escolha de equipar/vender (SPEC-060)
- [ ] Achar um baú com o slot correspondente **vazio**: item equipa direto,
      sem pausar.
- [ ] Achar um segundo baú para o **mesmo slot**: a run pausa, aparecem as 2
      opções com nome/raridade/descrição e quanto cada venda rende.
- [ ] Escolher "equipar novo" uma vez e "manter atual" em outra ocasião —
      confirmar moeda creditada nos dois casos e, se a peça vendida concedia
      uma arma, que ela some do herói.

### 4. Zumbi (SPEC-061) — checagem de rotina, não bug pendente
- [ ] Ver o Zumbi numa run em Dagruve: idle, movimento e ataque devem
      renderizar normalmente (o bug antigo já foi corrigido por spec
      anterior; isso é só confirmação de rotina).
- [ ] Nota: a arte ainda não foi regenerada (fila em SPEC-062, aguardando o
      dono gerar externamente) — o Zumbi atual é o oficial já corrigido, não
      o lote novo.

### 5. Quebráveis (SPEC-063 + amendment)
- [ ] Em Dagruve/Docas: confirmar que candelabro e caixote aparecem (arte
      real, reaproveitada de props existentes).
- [ ] Em pelo menos duas outras fases (ex.: Shedaklah e Molor): confirmar
      que aparece o quebrável temático daquela fase (saco de esporos,
      casulo viscoso etc.) — **arte é placeholder reaproveitado**, vai
      parecer "errada" tematicamente até a geração da fila (SPEC-062/
      ART-PROMPTS-024); isso é esperado, não é bug.
- [ ] Quebrar 5–10 deles: nenhum se move nem ataca; cada um larga
      exatamente um item. Ao longo de várias quebras, moeda deve aparecer
      claramente mais que poção/ímã/item — se parecer 50/50, é um sinal de
      que o enviesamento não está funcionando como esperado.
- [ ] Esperar ~1 minuto parado numa área explorada: um quebrável novo deve
      aparecer perto do herói sozinho (respawn por tempo).

### 6. Rebalanceamento de poção (SPEC-063)
- [ ] Matar uns 20–30 inimigos comuns: nenhum deve largar poção.
- [ ] Matar um elite (aura colorida ao redor): ocasionalmente deve largar
      poção além do baú/moeda já esperado — não vai acontecer toda vez (6%
      de chance), então não estranhar se não aparecer em poucos elites.

### 7. Eventos econômicos (SPEC-064)
- [ ] Achar uma **loja**: interagir com `E`, ver até 2 itens à venda com
      preço, e a opção "Sair" sempre presente.
- [ ] Comprar um item: moeda desconta o preço mostrado; se o slot já
      estiver ocupado, a escolha de equipar/vender (item 3 acima) deve
      abrir na sequência.
- [ ] Achar um **ferreiro**: se houver arma elegível (nível abaixo do
      máximo), oferece subir 1 nível por um preço; comprar sobe o nível
      visivelmente (HUD/painel `C`).
- [ ] Achar um **curandeiro**: com vida não cheia, oferece cura completa por
      um preço; com vida cheia, só mostra "Sair".
- [ ] Em qualquer um dos três, apertar "Sair" — não deve custar nada nem
      deixar o jogo travado.
- [ ] Ao final da run, conferir que a recompensa em moedas mostrada na tela
      de resultado não caiu por causa das compras feitas durante a run
      (`stats.gold` histórico não deve ser afetado por gasto — ver
      discovery de SPEC-064).

## Se algo falhar

Cada item com problema deve virar uma nota rápida (F5/F6 do próprio kit de
evidências) com: o que você esperava, o que aconteceu, em qual fase/herói.
Isso vira uma EVID de regressão específica, referenciando a spec original
(059/060/061/063/064), em vez de uma spec nova do zero.

## Depois deste checklist

Só depois de rodar isso uma vez é que faz sentido:
1. Abrir specs novas de gameplay (a Fase C do backlog original — nível
   máximo de equipamento e sinergias — continua não iniciada).
2. Gerar a arte da fila (SPEC-062: Zumbi + 7 quebráveis + props de cenário
   de SPEC-065 a SPEC-071).
3. Rodar o próximo playtest externo (Hiago) com o questionário de
   [[PLAN-031-proximo-playtest-reavaliacao-e-questionarios-2026-09-28]],
   atualizado para cobrir loja/ferreiro/curandeiro e os quebráveis por
   bioma, que ainda não estavam prontos quando aquele questionário foi
   escrito.

## Limites

- Este documento não substitui as evidências já registradas (EVID-089 a
  095) — só consolida os itens pendentes delas num roteiro único.
- Não é um teste automatizado; exige uma pessoa jogando de verdade.
