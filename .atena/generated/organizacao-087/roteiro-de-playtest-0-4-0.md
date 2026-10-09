# Roteiro de playtest da 0.4.0 refeita (PLAN-087 B-005)

Quem joga e julga é o dono (ou os testers). A Atena verificou só o funcionamento (suíte `0 falha(s)`, smoke, kit_test, audit, bot). **Nada abaixo foi jogado por uma pessoa ainda**: sensação, dificuldade e diversão seguem não verificadas.

## Build e escopo

- **Build:** ainda não há `.exe` da árvore de trabalho. Dois caminhos, ambos com aprovação à parte: (1) exportar um `.exe` local de um commit limpo; (2) push na `main`, que republica o release `latest` (o `.exe` dos testers vem do CI).
- **Antes de jogar:** os grupos de commit 1 a 4 do `mapa-de-pendencias.md` precisam estar commitados; sem eles o `.exe` não traz Arlindo, Erik nem a seta de evento.
- **Escopo:** só o que entrou desde a última sessão com playtest. O roteiro completo de 18 itens continua em `backlog/RELEASES.md` ("O que testar").

## Rota de 30 minutos (ordem sugerida)

| # | O que fazer | O que observar | Passa se | Cartão |
|--:|---|---|---|---|
| 1 | Dagruve com qualquer herói: ir até uma borda e ficar | O toast de aviso aparece uma vez; a faixa de névoa é visível; a vida cai de 2% a 6% por segundo; sair da faixa alivia | Você entende o que está acontecendo sem ler nada e sente que acampar deixou de compensar | MEC-059 |
| 2 | Vencer o chefe de Docas (ou outro mapa com próximo) | A Maré de Névoa avança; dá tempo de pegar o portal ou a saída | Apressa a troca sem parecer injusta | MEC-060 |
| 3 | Qualquer fase com quest ativa: andar para longe do alvo | Seta na borda com nome curto e distância (`Nome · 24 m`); some ao entrar na tela; não cobre HUD nem botões de toque | A seta ajuda e não atrapalha | MEC-061 |
| 4 | Completar os Ecos de Dagruve e de Docas | Arlindo e Erik liberam na seleção | Conquista libera; texto de desbloqueio claro | MEC-062, MEC-063 |
| 5 | Jogar de **Arlindo** em Dagruve | Modify Memory faz inimigos próximos pararem de atacar; Olhos de Andarilho mostra Ecos de mais longe e dá XP por Eco | Parece suporte útil, não inútil nem forte demais | MEC-062, BAL-027 |
| 6 | Jogar de **Erik** em Docas | Navios em Chamas deixa uma faixa de fogo à frente por 8 s; a Tocha queima; o dano de fogo sobe | Parece guerreiro de fogo coerente | MEC-063 |
| 7 | Em qualquer run, escolher ofertas só com W/A, S/D e Enter | Level-up, altar, loja e recompensas respondem ao teclado | Dá para jogar sem mouse | MEC-001 |
| 8 | Altar da Doação | Cada linha "Doar" mostra o ícone do item | Ícones corretos | MEC-050 |

## Perguntas ao dono depois de jogar

1. **Arlindo** ficou fraco? (O bot o mede entre os mais fracos, 0,1 a 0,3 fases, mas o bot não usa o controle como uma pessoa.) A resposta decide se o BAL-027 vira ajuste de números.
2. A faixa de 3 casas e o dano de 2% a 6% estão no ponto, ou é cedo/forte demais para quem só se afasta um pouco do mapa?
3. A arte provisória de Arlindo e Erik (animação de Sylas e Durvall) atrapalha a leitura do jogo ou dá para testar assim?

## O que fica sem teste humano

Controle físico (MEC-052), celular (MEC-049), ranking nos clientes finais (PLAN-071), e todos os itens de arte e movimentação (BUG-025, 027, 028, 029), fora deste plano.
