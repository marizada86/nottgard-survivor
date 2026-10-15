---
id: "EVID-250"
title: "Relatório de playtest do T05 (Mariz) sobre a v0.4.0, repassado pelo dono"
created: "2026-10-14"
relations: ["[[EVID-200-relato-t03-daniel-v033-2026-10-07]]", "[[EVID-249-m2-auditoria-de-game-feel-rodada-1-2026-10-14]]", "[[PLAN-103-demo-completa-e-polida-2026-10-14]]", "[[SPEC-176]]", "[[SPEC-177]]"]
cards: ["BUG-044", "BUG-045", "BUG-046", "BUG-012", "BUG-027", "BUG-028", "BAL-016", "MEC-040", "MEC-031"]
content_state: DRAFT
---

# EVID-250 — T05 Mariz, relatório de playtest da v0.4.0 (2026-10-14)

**Natureza:** relatório escrito (QA / avaliação de gameplay), **repassado pelo dono**. Bruto em [`EVID-250-relato-t05-mariz-v040-2026-10-14/relato-original.txt`](EVID-250-relato-t05-mariz-v040-2026-10-14/relato-original.txt) (cópia sem edição). Sem pacote `evidencias/`, sem log e sem hash de build; o dono informa "v0.4.0" (código em `602cef5`). Veio **1 imagem** (a do Print 2, tela de resultado); o **Print 1** (slot da ficha) **não chegou**. Perfil: primeira avaliação do T05; o próprio relato diz que o jogador vai bem ("talvez eu seja bom demais"), o que pesa nos itens de dificuldade.

**Aviso do dono:** parte do relatório **já foi corrigida** porque a revisão demorou; a coluna "Já feito?" separa o que é anterior à v0.4.0, o que é posterior (HEAD) e o que é novo.

## Conferência dos prints
O Print 2 (tela "Você caiu...", Durvall, Molor, nível 28, 2477 abates) mostra a **janela de resultado maior que a tela**: o título está cortado no topo, a lista "Conquistas:" tem 16 linhas e os botões "Jogar de novo" e "Voltar ao Quartel" ficam na borda inferior, só metade visível. Há linhas de conquista **sem texto de recompensa** ("Intocado —", "Sombra Sem Marca —", "Colecionador —", "Ecos de Dagruve —").

## Tabela nota → verificação → destino

Legenda "Já feito?": **0.4.0** = já estava na build jogada; **HEAD** = corrigido depois da 0.4.0 (commit local); **EM CURSO** = trabalho aberto do PLAN-103 (nem sempre commitado); **NOVO** = não havia cartão.

| # | Relato (resumo fiel) | Intake | Verificação (leitura de código; nada executado em run) | Já feito? | Destino |
|---|---|---|---|---|---|
| 1 | Mexer em qualquer volume (menu e opções em jogo) causa um bug (prioridade alta) | IN-077 | **Causa provável encontrada.** Cada passo do slider chama `Game.apply_settings()` (`ui/options_panel.gd:149-168`), e este reaplica **a janela inteira** a cada passo: `window_set_size`, borda e, em tela cheia, volta para janela e para tela cheia (`core/game.gd:368-385`); ainda grava o save e o backup a cada passo (`Game.save`). O "bug" descrito de forma vaga bate com tela piscando/redimensionando ao arrastar o volume. **Não reproduzido em run.** | NOVO | **BUG-044** (P1) |
| 2 | Passar o mouse no 1º slot da ficha do herói esconde parte do lado esquerdo (Print 1) | IN-078 | Print 1 ausente. **Sintoma igual ao BUG-041** (anel de foco do 1º slot cortado pelo scroll da ficha C), mas BUG-041 já estava corrigido **antes** da 0.4.0 (`60fd1fff`, 2026-10-10). Ou é outro slot (HUD, não a ficha C) ou o conserto não cobriu todos os casos | 0.4.0 (suspeita de reincidência) | **BUG-046** (P2, confirmar com o Print 1) |
| 3 | Monstros ficam presos em objetos do cenário | IN-079 | BUG-012 (desde 2026-09-29) cobre a perseguição; é **reincidência** do relato de Daniel, Hiago e Higor. Falta saber o mapa. Parte do que parece "preso" é o **Tentáculo do Kraken**, imóvel de propósito (`speed 0.0`, Docas) | 0.4.0 | BUG-012 (+1 relato; pedir o mapa) |
| 4 | Após a morte a tela teve problema visual (Print 2) | IN-080 | **Confirmado pelo print e pelo código.** `ResultPanel` é um `PanelContainer` sem rolagem (`ui/hud.tscn:286-329`); `ResultText` é um `Label` que cresce com as conquistas (`ui/hud.gd:1008-1015`); com 16 conquistas passa de 1080 px. Reduzir o banner em 30% (`6815cfc5`, 2026-10-13) ajuda, mas **não resolve** com tantas conquistas. Acompanha as recompensas sem texto (coins-only em `data/achievements.json`) | parcial (banner HEAD) | **BUG-045** (P1; o relato sugere P0, mas há saída por teclado e o foco vai para "Jogar de novo") |
| 5 | Durvall anda com uma perna só na horizontal e para cima | IN-081 | É BUG-028 (patinar) + BUG-027/025 (tiras). O M1 (SPEC-176) refaz as tiras do Durvall; piloto v03 em grade aprovado, faltam as direções N, NE, O, SO e NO | EM CURSO | BUG-028 (+1 relato), SPEC-176 |
| 6 | Esperava menu principal; só há tela inicial que leva à seleção | IN-082 | Fluxo como desenhado; o relato admite que não é erro | NOVO | M3 (onboarding), sem cartão |
| 7 | Mensagem ao coletar objeto tem destaque que parece esperar interação | IN-083 | Há painel de 1 opção ao pegar item de baú (BUG-031, decisão do dono) que **pausa e espera** a confirmação; o tester pode estar descrevendo isso ou o toast | 0.4.0 | M3 (clareza); confirmar qual objeto |
| 8 | Item novo sempre na 1ª posição da lista parece "o melhor"; induziu a equipar o que não queria | IN-084 | Coerente com a oferta que destaca a novidade (ART-016); falta checar a ordem | NOVO | MEC-070 (a propor), M3 |
| 9 | Avisos de missão no topo central chamam atenção demais e tapam o jogo | IN-085 | O questlog **já foi para a direita** em 602cef5 (MEC-064) e ganhou cabeçalho, fonte maior e posição mais baixa depois (HEAD). O que sobra no topo são avisos de acontecimento e chefe. Confirmar quais | 0.4.0 + HEAD | MEC-064 (acompanhar), M3 |
| 10 | Iluminação uniforme; falta variação para sensação de megadungeon | IN-086 | Sem cartão. Névoa do mundo em preparação (NB01/NB02, prompts) | EM CURSO | M5/M2 (atmosfera), ART |
| 11 | Dano da borda do mapa baixo; névoa poderia empurrar o jogador a avançar | IN-087 | BAL-004 (6%/s), BAL-028 e MEC-059 (faixa de borda). O relato diz que não ameaça; é o primeiro dado de **jogador forte** (nível 28) | 0.4.0 | BALANCEAMENTO (+1 relato); M4d |
| 12 | Números de dano pouco legíveis e ataques sem impacto; críticos sem resposta marcante | IN-088 | Em curso no M2: F-1/F-2 (HEAD, não commitado) tira o spam de "-0" da névoa (44 a 51 rótulos); R5-B da proposta aumenta o número de dano e o contorno; VFX de projéteis e habilidades admitidos em 2026-10-13 | EM CURSO | SPEC-177 (R5), MEC-031 |
| 13 | Inimigos parecidos (aproximação lenta); tentáculo parado sem ataque perceptível; falta reflexo além de desviar de círculos | IN-089 | O tentáculo **tem** golpe (`aoe` d10, raio 1,5, atraso 0,9 s, alcance 6); o telégrafo não foi percebido. Variedade é decisão D6 (chefes marcantes) | parcial | M4 (comportamentos); **telégrafo do tentáculo** vai para M2 |
| 14 | Poças de dano só preocupam no início | IN-090 | Dano de poça é fixo; jogador forte ignora. Já há MEC-040 (marcas) e BAL-016 | 0.4.0 | BALANCEAMENTO (+1 relato) |
| 15 | 1º chefe muito fácil; derrotado quase parado, com poucos monstros | IN-091 | BAL-012 deu 480 PV ao Guardião Alado; o 1º chefe (Dagruve) não foi mexido nessa linha. Um relato de jogador forte; **não decide sozinho** | 0.4.0 | BALANCEAMENTO (+1 relato) |
| 16 | Guardião Alado deveria ser maior | IN-092 | Sem cartão de escala do chefe | NOVO | ART (escala do chefe), M5 |
| 17 | Chefes são versões maiores com ataques simples (projéteis em direções) | IN-093 | É a decisão D6 do PLAN-103 (M4a chefes marcantes) | EM CURSO (planejado) | M4a |
| 18 | Elites sem comportamento próprio (investida, ataque direcional, controle de área) | IN-094 | M4a; há elites por afixo hoje | planejado | M4a |
| 19 | Habilidade principal sem evolução; esperava melhorar ou ultimate | IN-095 | Habilidades ativas (`data/abilities.json`) têm recarga e dado fixos, sem níveis. Armas evoluem (MEC-067, HEAD) mas **a ativa não**. **Sem cartão** | NOVO | MEC-070 (a propor, M4b builds) |
| 20 | Alguns sons são mais cômicos que impactantes | IN-096 | Em 2026-10-14 o dono **recusou** F-4/F-5 (sem prompts de SFX por ora). Esta é a primeira queixa de tom; mixagem prevista no M2 | parcial | SPEC-177 (reabrir F-4/F-5 só com decisão do dono) |

## Pontos positivos do tester (preservar)
HUD clara e bem apresentada; jogabilidade fluida e acessível; "base sólida e divertida".

## Sinais cruzados
- Itens 1 a 4 são **bugs de código** e cabem num lote pequeno sem arte nova.
- Item 12 junta **uma causa de código** (spam de "-0" na névoa, já corrigida no M2 mas não commitada) com **escala visual do número**; as duas pontas estão no M2.
- Itens 13, 15, 17 e 18 são o mesmo pedido: dificuldade e variedade para jogador forte. Uma amostra, de alguém que se diz "bom demais": indício, não veredito (INTAKE passo 5).
- Item 19 é a lacuna nova de mecânica mais clara do relatório.

## Limites
Relato único e de segunda mão; sem build hash, sem log, sem print 1. Nenhum item foi **reproduzido em run**: as causas acima vêm de leitura de código. O diagnóstico do volume (item 1) é hipótese forte, mas só vira fato depois de o ajuste ser testado em tela cheia.
