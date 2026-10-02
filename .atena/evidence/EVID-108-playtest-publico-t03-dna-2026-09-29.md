# EVID-108 — Playtest público, jogador T03 (Daniel / "DNA"), 2026-09-29

Origem: um pacote F7 do build **Playtest Público** (`v0.1.0`, Windows) e o
**Questionário rápido 002 — Notas do dev** preenchido em texto livre, em
[EVID-108-playtest-publico-t03-dna-2026-09-29/](EVID-108-playtest-publico-t03-dna-2026-09-29/).
Relacionado: [[EVID-106-playtest-publico-t01-higor-2026-09-29]] (origem das frases),
[[EVID-107-playtest-publico-t02-hiago-2026-09-29]] (mesmo questionário, T02),
[[PLAN-036-playtest-primeira-vez-guia-autossuficiente-2026-09-29]].

> **Perfil (confirmado pelo dono em 2026-09-29): primeira vez no Nottgard.** DNA respondeu **"Sim"** a "já jogou jogos parecidos". Não consta
> em EVID anterior, então é o **primeiro jogador que não é Higor nem Hiago**.
> Provável primeira vez no Nottgard (confirmar com o dono). Como T02, **não fez**
> o questionário do guia do playtester; só o rápido 002. Peso maior que T02 para
> onboarding e para independência da amostra.

## Pacote

| Sessão | Pasta (cópia bruta) | Notas | Prints | Run |
|---|---|---:|---:|---|
| S1 | `S1-152610` (`NS-EV-public-20260929-152610.zip`, 1,4 MB) | 6 | 5 | **Kayron Lioran** (mago, `sobrecarga_mistica`): Dagruve → Docas → Shedaklah → **Molor** (nv 8 → 38, prof. 0–3), ~56 min, run ainda em andamento no export |

- Mapa dos prints: 001 = nota 1, 002 = nota 2, 003 = nota 3, 004 = nota 4,
  005 = nota 5. A nota 6 não tem captura.
- **Log completo** (150 linhas, do "Jogo iniciado" 14:26:55 até 15:26:08).
  **Nenhuma linha de erro, aviso ou falha.** Sem crash.
- **Não chegou a Shendilavri**, então o espelho (BUG-011) e a progressão tardia
  (MEC-014, MEC-015) ficam sem exposição: os "Não notei" nas perguntas 1, 11 e
  13 são **coerentes com o que ele jogou**, não falta de atenção.
- Declarou "Kairon / Shedaklah"; o pacote traz **Kayron** e termina em
  **Molor** (chegou a Molor às 15:21). Só variação de grafia/fase, sem efeito.

## Validações positivas

- 56 min de run estável, 4 biomas, dois chefes vencidos (Sacerdote da Mente
  Derretida, Guardião Alado, Zuggtmoy) e portais usados, sem erro no log.
- Ferreiro, loja, mímicos, fontes, Sobrecarga Mística (habilidade ativa)
  funcionam sem falha registrada.
- **Kayron é um herói de vida baixa** (28–42 PV) e ainda assim não teve
  dificuldade: ver "Sinais cruzados".
- Vontade de continuar: **10/10**.

## Notas → triagem

ID `T03-S1-N<nota>`. Texto literal em `S1-152610/notas.md`. "IN" é o registro
no [INBOX](../backlog/INBOX.md).

| IN | Nota | Contexto | Resumo fiel | Destino |
|---|---|---|---|---|
| IN-033 | S1-N1 | Dagruve, nv 8, ferreiro aberto (print 001: só "Sair") | "O usuário não sabe que não tem nada para melhorar" | MEC-023 |
| IN-034 | S1-N2 | Dagruve, nv 17 | Objetos no mapa flutuando | BUG-013 (**relato espontâneo**; agora Dagruve, Docas e Durao) |
| IN-035 | S1-N3 | Docas, nv 26, 5 inimigos | Aumentar a quantidade de mobs no mapa | MEC-024 |
| IN-036 | S1-N4 | Docas, nv 27, oferta de item (print 004) | Melhorar as cores dos itens raros para diferenciar dos comuns. O jogador clica fácil no item novo porque ele está de outra cor, "destacado" | ART-016 |
| IN-037 | S1-N5 | Docas, nv 28, 1 inimigo | Além de mais mobs, aumentar a dificuldade no início: "esse tipo de jogo fica mais fácil ao evoluir; no início podemos aumentar bastante" | MEC-024 |
| IN-038 | S1-N6 | Docas, nv 28, oferta de item | "+1 redução: redução do quê?" Explicar melhor ao usuário | ART-017 |
| IN-039 | Texto livre | — | "Aumentar dificuldade do jogo no início da campanha. Aumentar quantidade de mobs no geral." | MEC-024 (mesmo pedido; conta como o mesmo relato) |

### Verificações no código (leitura)

1. **IN-033 / MEC-023:** `core/battle.gd` só adiciona à oferta da loja e do
   ferreiro as opções com `hero.gold >= price`. Com 25 moedas (print 001) nada
   passa e a janela mostra apenas **"Sair"**, sem dizer que o problema é falta
   de moedas nem que existem melhorias disponíveis. O mesmo vale para a loja.
2. **IN-036 / ART-016:** `ui/hud.gd` pinta de **verde** toda opção `item_swap`
   com `equips = true` (o item **novo**), sem olhar a raridade. A cor da
   raridade (`Items.rarity_color`) só é usada nos avisos (toast). No print 004 a
   **Placa Completa [comum]** aparece verde e destacada, e o **Robe Sábio da
   Vida [raro]** aparece em branco. Ou seja: a interface **empurra o jogador a
   trocar um item raro por um comum** (a placa dá +5 CA, mas tira −3 CAM e
   −5 % de velocidade em um mago). Não é erro de cálculo, é orientação errada.
3. **IN-038 / ART-017:** o rótulo vem de `Items.mods_text` (`"dr": "redução"`);
   é redução de **dano recebido** (`core/battle.gd`: `dmg − hero.m("dr")`), sem
   distinguir físico de mágico, e o texto na tela não diz isso.

## Questionário rápido 002 — respostas

C = Concordo · P = Em parte · D = Discordo · N = Não notei. A contagem do
cartão soma T01 (voto de partida, origem da frase) + T02 (EVID-107) + T03.

| # | Tema | Cartão(ões) | T03 | Cartão passa a |
|--:|---|---|:-:|---|
| 1 | Objeto fora da área andável | BUG-011 | N | 2 C + 1 N (não chegou lá) |
| 2 | Inimigos presos em objetos | BUG-012 | C | 3 de 3 |
| 3 | Cenário flutuando | BUG-013 | C | 3 de 3 (+ nota espontânea N2) |
| 4 | Ritual: recompensa e penalidade | BUG-014 | **D** | 2 C + 1 D → **contestado** |
| 5 | Quebráveis raros | MEC-007 | C | 2 C + 1 P |
| 6 | Evolução de arma pouco clara | MEC-008, MEC-009 | P | 2 C + 1 P (**prioridade 3ª**) |
| 7 | Impacto do level-up | ART-010 | **D** | 2 C + 1 D |
| 8 | Mapas apertados | MEC-012 | **D** | 2 C + 1 D |
| 9 | Jogar mais rápido em fases vencidas | MEC-010 | C | 3 de 3 (**prioridade 2ª**) |
| 10 | Baú de chefe | MEC-013, ART-011 | C | 3 de 3 |
| 11 | Progressão tardia estagna | MEC-014, MEC-005 | N | 2 C + 1 N (não chegou lá) |
| 12 | Cenário simples | ART-012 | P | 1 C + 2 P |
| 13 | Moedas sobrando | MEC-015 | N | 2 C + 1 N (não chegou lá) |
| 14 | Conquistas que desbloqueiam | MEC-016 | C | 3 de 3 |

- **Prioridades (2, 9, 6):** inimigos presos (BUG-012), jogar mais rápido
  (MEC-010), evolução de arma (MEC-008/009). Nota **10/10**.
- Diferente de T02 (12 C, 2 P), T03 usou **as quatro respostas** (6 C, 2 P,
  3 D, 3 N). É o sinal mais confiável de que respondeu pelo que viu.
- **Ranking de prioridades acumulado (T02 + T03):** pergunta 9 (**2 votos**);
  perguntas 2, 4, 6 e 8 (1 voto cada).

### Força da evidência por cartão

| Nível | Cartões |
|---|---|
| **Espontânea + questionário, de 2 ou mais jogadores** | BUG-012 (3 de 3; T02 N12), BUG-013 (3 de 3; T03 N2), ART-009 (T02 N4) |
| **Espontânea de um jogador** | MEC-019, MEC-018, MEC-023, MEC-024, ART-015, ART-016, ART-017, BUG-015 |
| **3 de 3 só no questionário** | MEC-010, MEC-013, MEC-016 |
| **Contestado** (um discorda) | BUG-014, MEC-012, ART-010 |
| **Sem exposição** (não jogou até lá) | BUG-011, MEC-014, MEC-015 |

## Sinais cruzados

- **Dificuldade (MEC-024) vs T02.** DNA pede **mais dificuldade e mais mobs no
  início**; Hiago aparece em Dagruve com PV 10/42 (nv 3) e 10/60 (0:48, Bromnor), e Higor
  notou dano da névoa baixo (MEC-017). Os sinais divergem porque os heróis e o
  estilo de jogo são outros. Nos prints de DNA há **1 a 5 inimigos na tela em
  nv 26–28** com **28/28 PV** (print 003 e 005), sem nenhum dano. Uma amostra
  com três heróis (Brook, Bromnor, Kayron) e três jogadores não decide
  balanceamento: exige rodada do bot por herói antes de mexer.
- **Item novo verde vs. raro branco (ART-016)** reforça MEC-019: quem recebe a
  oferta vê **cor** e não **diferença de atributos**. Somam-se ART-016,
  MEC-019 e IN-023/IN-027 de T02 (mesma tela).
- **Loja/ferreiro que somem opções (MEC-023)** explica por que Hiago e Higor
  falam de "loja sem clareza": ninguém vê o que falta comprar.
- **Objetos flutuando (BUG-013):** no print 003 (Docas) barris, caixas e
  cordas aparecem com a **sombra descolada** do objeto; a nota 2 (Dagruve) relata o mesmo, mas o print 002 não
  foi conferido objeto a objeto. Três biomas, três jogadores.
- **Ritual (BUG-014):** o log mostra dois "Ritual interrompido." (14:31:26 e
  14:44:54) e nenhum "recompensa". DNA **discorda** da pergunta 4, provavelmente
  porque a penalidade (reforços) o incomodou menos com um mago de área. Fica
  como **contestado**; a decisão pede definir a regra do ritual.

## Respostas do dono às perguntas (2026-09-29)

1. DNA jogou pela **primeira vez**: sim. A amostra vale para onboarding.
2. Dificuldade que ele imagina: **mais mobs, mais dano e menos PV do herói**, os três.

## Perguntas para o dono / DNA (1 e 3 respondidas acima; a 2 segue aberta)

1. DNA jogou o Nottgard pela primeira vez neste teste? (define se vale para
   onboarding)
2. Nota 4: o "destaque" verde do item novo foi visto como **ajuda** ou como
   **armadilha**? O texto pode ser lido nos dois sentidos.
3. Nota 3/5: em qual dificuldade ele imagina "mais difícil": mais mobs, mais
   dano ou menos PV do herói?

## Limites

- Só arquivamento, verificação de código por leitura e triagem. Nenhum arquivo
  de jogo foi alterado, nada foi implementado.
- Uma sessão de ~56 min, run incompleta (Molor). Sem exposição à segunda metade.
- Balanceamento: três jogadores e três heróis não bastam; ver MEC-024.
