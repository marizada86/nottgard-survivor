# PLAN-032 — Próxima atualização com base no playtest (Higo/Hiago, 2026-09-28)

Status: **ordem combinada concluída** (Zumbi → ficha de personagem →
quebráveis+drop → loja) **— só falta a geração externa de arte do Zumbi
(fila em SPEC-062) e a checagem manual interativa do dono em todas as
specs desta leva (059/060/061/063/064).**

## Addendum: riqueza de cenário e quebráveis por bioma (2026-09-28)

A pedido do dono, depois da ordem combinada fechada: quebrável temático por
bioma (em vez de um genérico fora de Dagruve/Docas) e drop enviesado (ouro
comum, item raro). Ver amendment em
[[SPEC-063-objetos-quebraveis-e-rebalanceamento-de-pocao]],
[[EVID-095-spec-063-amend-quebraveis-por-bioma-2026-09-28]] e os prompts de
arte em [[ART-PROMPTS-024-cenario-e-quebraveis-por-bioma]] (7 quebráveis
definitivos + 21 props de cenário para as 7 fases que nunca tiveram um lote
de props dedicado como Dagruve/Docas tiveram).

## Progresso

1. **Zumbi**: [[SPEC-061-preparacao-da-regeneracao-do-piloto-de-zumbi]]
   aprovada, brief local pronto, geração autorizada. Sem ferramenta de
   imagem nesta sessão — fica na fila de
   [[SPEC-062-fila-de-geracao-externa-de-assets]], o dono gera externamente
   e devolve os PNGs.
2. **Ficha de personagem**: entrou como extensão de
   [[SPEC-059-descricao-de-itens-e-slots-visiveis]] (decisão do dono) —
   **executada em 2026-09-28**, suíte e smoke verdes. Evidência em
   [[EVID-092-extensao-spec-059-ficha-de-personagem-2026-09-28]].
3. **Quebráveis + rebalanceamento de drop de poção**:
   [[SPEC-063-objetos-quebraveis-e-rebalanceamento-de-pocao]] aprovada e
   **executada em 2026-09-28** — suíte e smoke verdes; checagem manual
   interativa do dono pendente. Evidência em
   [[EVID-093-spec-063-quebraveis-e-rebalanceamento-2026-09-28]].
4. **Loja/eventos aleatórios**:
   [[SPEC-064-eventos-economicos-loja-ferreiro-curandeiro]] aprovada e
   **executada em 2026-09-28** — suíte e smoke verdes; checagem manual
   interativa do dono pendente. Evidência em
   [[EVID-094-spec-064-eventos-economicos-2026-09-28]]. **Ordem combinada
   completa.**

## Contexto

Análise das 10 respostas do questionário em
[[EVID-091-playtest-higo-hiago-build-c-e-item-offer-2026-09-28]], primeiro
contato real com [[SPEC-059-descricao-de-itens-e-slots-visiveis]] e
[[SPEC-060-escolha-de-equipar-ou-vender-loot]]. Nota geral: **9/10**.

## Análise por resposta

| # | Resposta (resumo) | Leitura |
|---|---|---|
| 1 | Achou a tecla `C` sozinho, mas sugere uma dica visível em algum lugar | A dica que coloquei só no menu de pausa não é suficiente — precisa de algo visível durante o próprio jogo. |
| 2 | Entendeu, mas achou raso; quer mais detalhe ao passar o mouse | O painel atual (nome + `mods_text`) é bom como resumo, mas não é a informação completa que ele queria. Confirma que a Fase A ficou incompleta, não errada. |
| 3 | Faltou retrato/asset do herói e um total agregado de atributos com itens/efeitos aplicados | Pedido maior: não é só "mais detalhe por item", é uma **ficha de personagem** de verdade — retrato + números finais (FOR/INT/CON/CAR, CA, CAM, PV, dano etc. já somando tudo). Isso é bem mais que o que SPEC-059 entregou. |
| 4 | "Até gostei" da pausa de equipar/vender | Valida a decisão de design mais arriscada do lote (SPEC-060). Sem ressalva. |
| 5 | Moeda da venda parece justa "por enquanto" | Sem urgência de mexer na fórmula agora; “por enquanto” sinaliza que pode precisar de revisão conforme a economia evolui (ponto já registrado como risco em [[PLAN-030-backlog-hiago-itens-equipamento-e-economia-2026-09-27]]). |
| 6 | Nunca morreu por causa da pausa | Sem problema de segurança/frustração com o novo fluxo. |
| 7 | **Zumbi com o mesmo bug visual que Leoric tinha** | Achado técnico novo — ver seção própria abaixo. |
| 8 | Confirma quebráveis (candelabro, caixa, arbusto), com variação por bioma; reforça o pedido de loja | Item 4 da Fase B ganha especificação concreta; item 8 (Fase C) é pedido de novo, duas vezes nesta rodada (aqui e na pergunta 10). |
| 9 | Nota 9/10 | Alta satisfação geral com a build. |
| 10 | Mais eventos aleatórios; poções só de quebráveis + elites (chance baixa), não de monstro comum; segurar clique esquerdo pra andar | Três pedidos novos — ver seções abaixo. |

## Achado técnico: Zumbi com o mesmo padrão do Leoric antigo

Investiguei o código antes de trazer isso pra você (detalhe completo em
EVID-091). Resumo: **não é bug de renderização** — a grade de frames de Zumbi
em `ui/enemy_view.gd` bate exatamente com as dimensões dos quatro PNGs em
`assets/animations/enemies/zumbi/`, e
[[SPEC-038-integridade-visual-dos-inimigos]] já audita alfa/conteúdo visível
de Zumbi sem falha. Ou seja: a mesma classe de problema que Leoric tinha —
cobertura de opacidade fraca dentro da arte já gerada, que um teste
automatizado de "existe pixel visível" não detecta, mas o olho humano vê como
"quase transparente com pixel solto". O caminho já validado neste projeto pra
esse tipo de problema é o pipeline de regeneração usado em
[[SPEC-049-preparacao-da-regeneracao-do-piloto-de-leoric]] (piloto → geração
→ candidatos → admissão explícita), não uma correção de código.

**Risco em aberto:** se Leoric e Zumbi tiveram o mesmo defeito
independentemente, pode não ser coincidência — vale considerar uma auditoria
rápida dos outros assets animados (heróis e os dois inimigos com folha:
Zumbi e Sacerdote da Mente Derretida) antes de tratar isso caso a caso.

## Pedidos novos identificados nesta rodada

1. **Dica de tecla `C` visível durante o jogo** (resposta 1) — pequeno, provável
   extensão de SPEC-059.
2. **Mais detalhe ao passar o mouse no painel de itens** (resposta 2) —
   provável extensão de SPEC-059.
3. **Ficha de personagem com retrato e totais agregados** (resposta 3) — maior
   que SPEC-059; decisão de escopo abaixo.
4. **Quebráveis com variação por bioma** (resposta 8) — refina o item 4 da
   Fase B já mapeado em PLAN-030, com tipos concretos (candelabro, caixa,
   arbusto) e a regra de que nem todo tipo cabe em todo bioma (abismo não
   combina com caixa/candelabro).
5. **Reforço do evento de loja** (respostas 8 e 10) — item 8 da Fase C
   (PLAN-030), agora pedido duas vezes.
6. **Mais eventos aleatórios em geral** (resposta 10) — expande o escopo do
   item 8 além só de loja/ferreiro/curandeiro.
7. **Rebalancear drop de poção**: monstro comum não deveria dropar poção;
   poção viria só de itens quebráveis e de elites, com chance baixa nos
   elites (resposta 10) — amarra diretamente ao item 4 (quebráveis), porque
   troca a fonte primária de cura de "monstro comum" pra "quebrável".
8. **Segurar clique esquerdo pra andar**, como em Vampire Survivors
   (resposta 10) — pedido de controle novo, não estava em nenhum backlog
   anterior. Verifiquei o código: hoje o mouse já mira continuamente por
   posição (sem precisar de clique) no modo Mira MOUSE, então segurar o botão
   pra andar não deveria conflitar com a mira — dá pra somar como uma entrada
   alternativa ao WASD sem mexer no sistema de mira.

## Recomendações

- **Zumbi primeiro, isolado.** É o único item desta rodada que é claramente
  um bug (não uma melhoria), tem precedente de solução validado (SPEC-049) e
  afeta a percepção de qualidade visual do jogo. Sugiro tratar antes do resto,
  como uma spec pequena e isolada — mas com uma checagem rápida de auditoria
  nos outros assets animados antes de fechar, dado o risco de não ser um caso
  isolado.
- **Ficha de personagem (resposta 3) é grande o bastante para ser spec
  própria**, não só um ajuste de SPEC-059 — envolve retrato/asset do herói e
  agregação de todos os atributos/mods já calculados (`Hero.mods`,
  `Hero.attr()`, `Hero.ca()`/`cam()`, etc., que já existem no código, só não
  são exibidos juntos em lugar nenhum hoje).
- **Dica de tecla + hover de detalhe (respostas 1 e 2)** são pequenas e podem
  entrar como uma extensão curta de SPEC-059, possivelmente junto da ficha de
  personagem já que mexem na mesma tela.
- **Quebráveis (item 4) e o rebalanceamento de drop de poção (resposta 10)
  deveriam ser a mesma spec** — o rebalanceamento só faz sentido junto da
  fonte de reposição (quebráveis), senão o jogo fica com menos cura
  disponível no meio do caminho.
- **Loja/eventos aleatórios (item 8 + "mais eventos")** continua sendo o
  maior item do lote (novo sistema econômico); mantenho a recomendação
  anterior de deixar para depois de equipamento/sinergia (Fase C) — mas note
  que já foi pedido duas vezes por dois playtesters diferentes agora
  (Hiago, e a própria dupla Higo/Hiago nesta rodada), o que é um sinal de
  prioridade mais forte do que eu tinha antes.
- **Segurar clique pra andar** é isolado, de baixo risco técnico (não mexe em
  mira/combate) e pode entrar em paralelo com qualquer outra coisa, inclusive
  antes das specs maiores, se você preferir algo rápido de ganho perceptível.

## Perguntas para alinhar

Ver interação de escolha múltipla a seguir — cobre: ordem de prioridade,
como tratar o Zumbi, o tamanho da ficha de personagem e onde entra o
rebalanceamento de drop de poção.

## Limites

- Nenhuma spec foi aberta a partir deste plano ainda. Este documento só
  organiza e prioriza o que veio do playtest.
- Nenhum arquivo de jogo foi alterado nesta análise — só leitura/comparação
  de código para embasar o achado do Zumbi.
