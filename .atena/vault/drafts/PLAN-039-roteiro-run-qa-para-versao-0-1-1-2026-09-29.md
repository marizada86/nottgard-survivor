---
id: "PLAN-039"
title: "Roteiro da run QA para fechar o lote de bugs da versão 0.1.1"
status: "pronto para uso pelo dono; Etapa 0 do PLAN-038"
created: "2026-09-29"
relations:
  - "[[PLAN-038-atualizacao-pos-playtests-t01-t02-t03-2026-09-29]]"
  - "[[PLAN-033-checklist-consolidado-pre-playtest-2026-09-28]]"
---

# PLAN-039 — Roteiro da run QA (Etapa 0 e verificação das correções)

Uma sessão só, perfil QA, cerca de 40 a 60 minutos. **Marque o que passou;
o que falhar vira uma nota F5 com "esperava / aconteceu / fase e herói".**
As caixas com **(novo)** verificam o que foi implementado em 2026-09-29 e ainda
não foi visto numa run real. As demais são a dívida antiga (BUG-001 a 010).

## A. Correções novas (PLAN-038, Etapa 1 e 2)

### BUG-015 — prévia do ferreiro (novo)
- [ ] No ferreiro, com um equipamento comum no nível 1: a linha mostra
      **"Nv 1: …" e "Nv 2: …" com valores diferentes** (o de baixo maior, com
      decimais tipo `+4.6 PV`).
- [ ] Comprar o upgrade: o painel `C` mostra o total subindo.
- [ ] Armas no ferreiro: rótulos em português ("recarga (s)", "marca"), sem
      `cd` ou `mark` crus.

### BUG-012 — inimigos presos (novo)
- [ ] **Durao** (montanhas): deixe uma montanha entre você e um grupo de
      inimigos; eles devem **contornar** e voltar a perseguir, não ficar parados.
- [ ] **Durao** logo depois de sair da água do Estige (Esquecimento ativo):
      os inimigos continuam avançando normalmente.
- [ ] Dagruve e Docas: passar por perto de barris, caixotes e braseiros; ninguém
      deve ficar grudado nos objetos por mais de 2 ou 3 segundos.

### BUG-013 — props flutuando (novo)
- [ ] **Docas**: barris, caixotes, cargas, livros e velas **apoiados no chão**,
      sombra encostada na base.
- [ ] **Dagruve**: braseiros, velas, livros, barris idem.
- [ ] Atenção: **docas, margens, ossos e redes** (props planos) **não foram
      alterados**. Diga se ainda parecem flutuar; se sim, anote qual.

### BUG-011 — espelho de Shendilavri (novo)
- [ ] Em Shendilavri (ou pelo cenário QA), o espelho aparece **dentro da área
      andável**, você consegue chegar ao lado dele. Ele é decoração, não
      interage.

### ART-016 e ART-017 — cor de raridade e texto (novo)
- [ ] Oferta de item (equipar ou manter): o nome vem na **cor da raridade**
      (comum cinza, mágico azul, raro amarelo, único laranja). **Nenhuma
      opção fica verde** só por ser a nova.
- [ ] Loja e ferreiro: itens também na cor da raridade.
- [ ] O bônus de redução aparece como **"redução de dano"**.

### ART-009 e ART-015 — provisórios (novo)
- [ ] Loja, ferreiro e curandeiro aparecem com **cor e nome** (`loja [E]`
      dourado, `ferreiro [E]` laranja, `curandeiro [E]` verde). São
      **quadrados provisórios** até as imagens do ART-PROMPTS-025 serem geradas.
- [ ] O ímã de XP (após matar o inimigo que o larga) aparece como uma
      **ferradura vermelha pulsante**, diferente do cristal de XP.

### Ritual (novo, só texto)
- [ ] Início: "fique no selo para impedir os reforços!". Ficar no selo até o
      fim mostra "Ritual interrompido: os reforços foram impedidos."

## B. Dívida antiga (BUG-001 a 010)

Fazer como no [[PLAN-033-checklist-consolidado-pre-playtest-2026-09-28]]
(seções 1 a 7) e mais:

- [ ] **BUG-001** Zumbi em Dagruve: parado, andando, atacando e morrendo
      renderizam sem transparência estranha.
- [ ] **BUG-002** Sacerdote da Mente Derretida: silhueta sólida, sem pixels
      soltos (auditoria de opacidade).
- [ ] **BUG-003** Painel `C`: abre, rola, fecha com `C` e com `Esc`.
- [ ] **BUG-004** Equipar ou vender: moeda creditada; arma concedida some ao vender.
- [ ] **BUG-005** Quebráveis: dropam, respawnam, poção só de elite.
- [ ] **BUG-006** Loja, ferreiro, curandeiro: preço correto, "Sair" sem custo,
      moeda histórica da recompensa intacta.
- [ ] **BUG-007** Segurar o botão esquerdo para andar; clicar num painel não move o herói.
- [ ] **BUG-008** Equipamento sobe de nível (duplicata e ferreiro); no nível 3
      aparece o "bônus final".
- [ ] **BUG-009** Botão de menu do HUD encerra o sandbox QA; `qa.cenario`
      correto no manifesto.
- [ ] **BUG-010** Sinergia arma + acessório + magia ativa e aparece no painel.

## C. Como registrar

Usar F5 (nota) e F6 (print) do próprio jogo e mandar o zip pelo Discord, como
nos playtests. Para cada caixa: passou, falhou (com nota) ou "não consegui
testar" (diga o motivo). A Atena transforma o resultado em `EVID-110`.

## D. O que fica de fora

- Regra do ritual (recompensa ao interromper): decisão D1, vira MEC-026.
- Comparação de equipamento e opções sem moeda na loja: versão 0.2.0.
- Dificuldade e quantidade de mobs: versão 0.3.0.
