# SPEC-055 — Estige fiel à lore

Status: implementada e verificada; evidência EVID-085 em 2026-09-27  
Data: 2026-09-27

## Objetivo

Restaurar a fidelidade de localização e comportamento do Rio Estige: somente
Shedaklah, Durão, Shendilavri e Goranthis o usam; seus efeitos derivam do risco
de memória da fonte 3.5, não da implementação universal anterior.

## Escopo

- Remover o contrato universal de nove mapas.
- Criar um contrato compartilhado `styx_memory` somente para os quatro mapas
  documentados.
- Manter topologias distintas: dois braços, cais lento, afluente e cachoeira.
- Atualizar dados, layout, HUD, mensagens, QA, testes, cânone e evidência.

## Não objetivos

- Criar uma nova interpretação do curso irregular do Estige.
- Mudar regras de poças, bolhas, raios, ilusões, santuários ou rotação.
- Aplicar dano, push, buffs de raro, Chamado ou derrota por exposição ao rio.
- Alterar persistência do jogador.

## Aceite

1. Exatamente os quatro andares documentados têm água do Estige funcional.
2. Um contato usa o Teste de Lucidez já aprovado na SPEC-039: falha reduz INT
   efetiva da run com piso em 1; ao sair, Esquecimento impede a aproximação
   temporária da água, sem alterar dados persistentes.
3. A topologia de cada um está de acordo com sua referência publicada.
4. Os cinco mapas sem rio rejeitam a zona e não declaram o contrato ambiental.
5. A suíte demonstra as duas listas, as regras ambientais paralelas e a
   ausência de efeitos não canônicos.
6. PLAN-023, SPEC-054 e EVID-084 estão reconciliados como histórico
   supersedido, não apagado.

## Evidência planejada

- matriz de testes de presença/ausência e contato;
- smoke dos nove mapas;
- captura de Shedaklah, Durão, Shendilavri e Goranthis;
- decisão canônica e registro de reconciliação.
