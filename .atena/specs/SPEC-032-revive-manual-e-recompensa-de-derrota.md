# SPEC-032 — Revive manual e recompensa de derrota

Status: executada e validada em 2026-09-26.

## Escopo

Corrigir a primeira morte em uma run: abrir uma escolha explícita de revive em
vez de encerrar imediatamente. Reviver restaura 50% dos PV. Recusar paga 30% das
moedas da tentativa, substituindo os 50% de derrota usuais. A melhoria Segunda
Chance fornece uma oferta manual adicional; uma morte após esgotar as ofertas
mantém os 50% usuais.

## Não objetivos

Não alterar valores de armas, inimigos, fases, custos, progressão permanente ou
o formato do save.

## Critérios de aceite

1. A primeira morte abre o modal e não registra resultado nem salva a run.
2. Aceitar fecha o modal, restaura 50% dos PV, aplica a proteção existente e
   retoma a simulação.
3. Recusar encerra e concede exatamente 30% das moedas da tentativa.
4. Segunda Chance acrescenta uma escolha manual; ao esgotá-la, a derrota concede
   50%.
5. Os testes de batalha, perfil e a suíte headless continuam verdes; o navegador
   QA expõe a Oferta de revive.

## Impactos e plano de voo

1. Modelar `revive_offer` e decisões explícitas em `Battle`.
2. Liquidar recompensas pelo campo explícito `reward_rate` em `Profile`.
3. Exibir e conectar o modal no HUD e na cena da run.
4. Atualizar a melhoria, o destino QA e os testes determinísticos.
5. Rodar a suíte, o smoke e registrar evidência com os resultados.
