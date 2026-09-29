# PLAN-031 — Próximo playtest: pontos de reavaliação, questionários e sugestões

Status: **proposto — pronto para uso na próxima sessão de playtest.**

## Contexto

Desde a última evidência QA (sessão de 2026-09-27, [[EVID-088-qa-leoric-dagruve-2026-09-27]]),
três coisas mudaram no jogo:

1. O bug visual do Leoric (Nota 6 daquela sessão) foi **resolvido por uma spec
   anterior a SPEC-059/060** — tratado como encerrado em
   [[PLAN-029-triagem-evidencia-qa-leoric-e-ux-2026-09-27]], não é mais um
   item em aberto.
2. [[SPEC-059-descricao-de-itens-e-slots-visiveis]] — painel de itens/feitiços
   (tecla `C`) com descrição e contagem de slots.
3. [[SPEC-060-escolha-de-equipar-ou-vender-loot]] — baú com slot ocupado agora
   pausa e oferece escolher entre equipar o novo item ou manter o atual.

As duas specs novas passaram em suíte e smoke, mas **nenhuma das duas foi
verificada interativamente** (ver exceção registrada em
[[EVID-089-spec-059-descricao-itens-e-slots-2026-09-27]] e
[[EVID-090-spec-060-escolha-equipar-vender-2026-09-28]]). O próximo playtest é
a primeira vez que essas mudanças encontram um jogador de verdade.

## Pontos principais a reavaliar

1. **Leoric.** Já resolvido por spec anterior — não é mais um ponto em
   aberto. O checklist do desenvolvedor ainda inclui uma olhada rápida nele
   só como checagem de rotina, não como investigação de bug pendente.
2. **Checagem interativa antes de soltar pro playtester.** As duas specs novas
   só têm validação automatizada. Rodar o checklist de desenvolvedor abaixo
   *antes* de passar a build para o Hiago, para não gastar a sessão dele numa
   build quebrada.
3. **Descoberta e legibilidade do painel de itens (`C`).** É a primeira
   exposição real. Vale observar (não só perguntar) se o jogador acha a tecla
   sem ser avisado, se o texto cabe na tela com o herói cheio de itens/armas/
   passivas/bênçãos, e se a informação resolve o que a Nota 1 original pedia
   ("aparecer descrição dos itens") ou se faltou alguma coisa.
4. **Impacto de ritmo da escolha de equipar/vender.** Essa é a mudança de
   design mais arriscada do lote: o jogo agora *para* no meio da correria
   quando um baú de slot ocupado é aberto. Essa pausa foi uma decisão
   deliberada do dono ("decisão real, muda o ritmo da run"), mas só o
   playtester pode dizer se a pausa cai bem ou se atrapalha. Vale perguntar
   isso sem sugerir a resposta.
5. **A fórmula de venda (`8 * (rank+1)` moedas) parece justa?** A peça
   deslocada agora sempre vira moeda (antes, um upgrade silenciosamente a
   destruía sem gerar nada) — vale confirmar se o valor recebido parece
   proporcional ao que se perde.
6. **"Equipamento X/4" fez sentido para o Hiago?** A leitura de slot que
   implementei (4 categorias fixas: arma, armadura, amuleto, anel) foi uma
   interpretação minha da Nota 3 original — nunca confirmada diretamente com
   ele. Vale checar se era isso mesmo que ele tinha em mente.
7. **Prioridade dos itens 4 e 5 (Fase B) ainda de pé?** Quebráveis e item de
   dano temporário ainda não foram implementados. Depois de ver 1/2/3
   funcionando, o Hiago pode confirmar, reordenar ou descartar.
8. **Risco de amostra única.** Todo o feedback estruturado até agora veio de
   uma só pessoa (Hiago). Vale considerar incluir pelo menos mais um
   playtester nesta rodada, para não otimizar o jogo para o gosto de uma
   pessoa só.

## Checklist do desenvolvedor (antes de soltar a build)

Gate interno, roda antes do playtest — fecha as exceções de validação das
duas specs novas:

- [ ] Abrir uma run no perfil QA, apertar `C`: painel abre sem erro visual,
      texto legível, rolagem funciona com lista longa (herói com várias
      armas/passivas/itens/bênçãos).
- [ ] Fechar o painel com `C` e com `Esc`; confirmar que os dois funcionam e
      que o jogo não fica travado pausado.
- [ ] Achar um baú com o slot vazio: item equipa direto, sem pausar (sem
      regressão do comportamento antigo).
- [ ] Achar um baú com o slot ocupado: a run pausa, aparecem as 2 opções com
      nome/raridade/descrição de cada item; escolher cada opção ao menos uma
      vez e confirmar moeda creditada e troca de arma concedida quando
      aplicável.
- [ ] Confirmar visualmente que Leoric renderiza certo (idle, movimento,
      ataque) numa run real.
- [ ] Rodar `tests/run_all.gd` e `tools/smoke.tscn` uma última vez na build
      que vai para o playtester.
- [ ] Confirmar que o perfil QA não contaminou `user://profile.json` (mesma
      checagem de sandbox já coberta por SPEC-020) depois de mexer em
      `hero.items`/moedas.

## Questionário para o playtester (Hiago)

Curto, concreto, sem sugerir a resposta certa. Sugestão de aplicação: depois
de uma run normal, sem briefing detalhado — só avisar que existe uma tecla
nova (`C`) e que baús podem agora perguntar algo, sem explicar o mecanismo.

1. Você percebeu a tecla `C` sozinho, ou só usou porque eu avisei que existia?
2. O que apareceu no painel de itens explicou o que você queria quando pediu
   "aparecer descrição dos itens"? Faltou alguma informação?
3. A contagem de slots ("Equipamento X/4", "Feitiços/armas X/Y") fez sentido
   pra você? Era isso que você tinha em mente quando pediu pra "deixar
   evidente quantos slots estão disponíveis"?
4. Quando um baú te perguntou se você queria equipar ou manter o item, como
   foi parar pra decidir no meio da correria? Muito, pouco, ou na medida
   certa?
5. A quantidade de moeda que você recebeu ao vender um item pareceu justa
   pelo que você perdeu?
6. Alguma vez essa pausa te pegou desprevenido ou te custou a run (por
   exemplo, morrer enquanto decidia)?
7. Notou algum problema visual em algum herói (skin bugada, transparência,
   pixels soltos)?
8. Você ainda quer, na mesma prioridade, os itens que pediu sobre baús
   quebráveis (com poção/ouro/ímã) e magia de dano temporário (tipo
   lança-chamas)? Mudou de ideia depois de ver o resto funcionando?
9. Nota de 0 a 10 pra sensação geral da run comparado à última vez que você
   jogou — e por quê.
10. Alguma coisa nova que você queira pedir, depois de ver essas mudanças?

## Questionário para os desenvolvedores (retrospectiva interna)

Para o dono (e qualquer outro dev) revisar depois da sessão, antes de decidir
o próximo lote:

1. O checklist de desenvolvedor acima passou sem ressalvas? Alguma marcação
   ficou pendente ou com exceção?
2. A pausa de `item_offer` se comportou bem sob teste de verdade — sem
   travar input, sem deixar o herói vulnerável de forma injusta enquanto
   pausado?
3. A leitura de slots ("4 categorias fixas") deveria mudar com base na
   resposta do Hiago, ou está confirmada?
4. A fórmula de venda (`8 * (rank+1)`) deveria ser revisada com base na
   reação dele, ou segue como está?
5. Dado o feedback sobre ritmo (pergunta 4 do playtester), a pausa por baú
   ocupado deveria ficar como está, virar opcional (configurável), ou mudar
   de forma?
6. Com base na resposta sobre prioridade (pergunta 8), a ordem da Fase B
   (itens 4 e 5) e da Fase C continua a mesma definida em
   [[PLAN-030-backlog-hiago-itens-equipamento-e-economia-2026-09-27]]?
7. Vale registrar essa sessão via o kit de evidências (F7) para reaproveitar
   o mesmo fluxo zip → EVID → PLAN desta vez?
8. Já é hora de trazer um segundo playtester, dado o risco de amostra única
   (ponto 8 da lista de reavaliação)?

## Sugestões

1. **Capturar a sessão pelo kit de evidências (F7)** de novo, para manter o
   mesmo fluxo de análise usado nesta sessão (zip → EVID → PLAN) e comparar
   diretamente com [[EVID-088-qa-leoric-dagruve-2026-09-27]].
2. **Não explicar o mecanismo novo de antemão** — só avisar que existe uma
   tecla nova e que baús podem perguntar algo. A reação de descoberta é dado
   real; explicar tudo antes contamina a resposta às perguntas 1 e 4.
3. **Considerar um segundo playtester** nesta rodada ou na próxima, para não
   seguir otimizando só pelo gosto do Hiago.
4. **Decidir a ordem seguinte só depois das respostas** — em especial a
   pergunta 8 do playtester e a pergunta 6 dos desenvolvedores — antes de
   abrir a próxima spec (itens 4/5 da Fase B, ou pular para a Fase C).

## Limites

- Este plano não abre, aprova nem executa nenhuma spec por conta própria.
- Não substitui o checklist de desenvolvedor por confirmação automatizada —
  os itens marcados `[ ]` exigem checagem manual antes do playtest.
