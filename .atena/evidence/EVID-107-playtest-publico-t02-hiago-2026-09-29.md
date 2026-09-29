# EVID-107 — Playtest público, jogador T02 (Hiago / "Hiagola"), 2026-09-29

Origem: dois pacotes F7 do build **Playtest Público** (`v0.1.0`, Windows) e o
**Questionário rápido 002 — Notas do dev** preenchido, em
[EVID-107-playtest-publico-t02-hiago-2026-09-29/](EVID-107-playtest-publico-t02-hiago-2026-09-29/).
Relacionado: [[EVID-106-playtest-publico-t01-higor-2026-09-29]] (as frases do
questionário vêm dele), [[EVID-091-playtest-higo-hiago-build-c-e-item-offer-2026-09-28]]
(rodada anterior com o mesmo jogador), [[PLAN-036-playtest-primeira-vez-guia-autossuficiente-2026-09-29]].

> **Perfil e peso da amostra:** Hiago é o playtester original do projeto
> (já opinou em EVID-091 e no backlog do PLAN-030), joga "Vampire Survivors /
> Death Must Die" e conhece o dev. **Não é de primeira vez**: serve para achar
> defeitos e validar as frases de T01, **não** para medir onboarding.
> Ele **não fez** o questionário do guia do playtester (só o rápido 002).
> Ele e T01 **não são independentes** (o dev acompanhou a rodada de EVID-091).

## Pacotes

| Sessão | Pasta (cópia bruta) | Notas | Prints | Run |
|---|---|---:|---:|---|
| S1 | `S1-151737` (`NS-EV-public-20260929-151737.zip`, 8,3 MB) | 13 | 6 | **Brook França**, `guarda_de_lliira`: Dagruve → Docas → Shedaklah → Molor → Durão → **Feng-tu, vitória** (nv 3 → 46+, prof. 0–5). Fim da run: *vitória, 3 954 abates, +23 354 moedas* |
| S2 | `S2-151759` (`NS-EV-public-20260929-151759.zip`, 1,4 MB) | 0 | 1 | **Bromnor Martelo da Luz**, `concordia`, Dagruve, nv 5, 00:48, PV 10/60 (run nova iniciada às 15:15:30) |

- Os `.zip` não foram copiados. `log.txt` de S1 e S2 é praticamente o mesmo
  (200 linhas, 13:52 → 15:15); S2 só acrescenta a linha *"Evidência exportada"*.
  Como o log guarda só as últimas 200 linhas, **as notas 1–3 (13:43–13:52) e a
  Dagruve inicial não têm log**; valem o `notas.md` e os prints.
- Prints de S1 não têm o `006` (a nota 6 não tem captura): 001 = nota 1,
  002 = nota 2, 003 = nota 3, 004 = nota 4, 005 = nota 5, 007 = nota 7. As
  notas 6 e 8–13 não têm print.
- **Logs:** nenhuma linha de erro, aviso ou falha; nenhum crash relatado.
- **Sessão longa e estável:** ~1 h 30 de jogo (13:43 → 15:15) do Dagruve à
  vitória em Feng-tu, sem travamento. Sinal positivo de estabilidade.

## Discrepância a confirmar com Hiago

O questionário diz **herói mais jogado: Leoric** e **fase: Feng-tu**. Os
pacotes trazem **Brook França** (run completa, chega a Feng-tu e vence) e
**Bromnor** (run nova). Leoric não aparece em nenhuma evidência. Provável:
jogou Leoric em outra sessão sem exportar. **Não** afeta a triagem, mas conta
para saber quantos heróis foram realmente testados (Brook, Bromnor).

## Validações positivas

- Run completa de 7 biomas até a vitória final, sem crash (S1).
- Loja, ferreiro, fontes, baús-mímico e "Segunda Chance" **usados sem erro**
  (log: vendas, "Fonte: +11% PV", "Era um Mímico!", "Segunda Chance!").
- Chefes e portais funcionaram: Sacerdote da Mente Derretida, Blogbog,
  Molydeus, Lu Yueh (log). Cobre parcialmente BUG-006 (loja e ferreiro
  abertos com preço e "Sair", prints 003 e 005).
- "Vontade de continuar": **10/10**.

## Notas → triagem

ID `T02-S1-N<nota>`. Texto literal em `S1-151737/notas.md`. "IN" é o registro
no [INBOX](../backlog/INBOX.md).

| IN | Nota | Contexto | Resumo fiel | Destino |
|---|---|---|---|---|
| IN-019 | S1-N1 | Dagruve, `rituals`, nv 3, PV 10/42 (print: toast "Ritual interrompido.") | Oferecer recompensa ao interromper um ritual | BUG-014 (**2º relato**, independente de T01) |
| IN-020 | S1-N2 | Dagruve, nv 7 (print do painel `C`) | Evidenciar quando um ataque escala com dano físico ou mágico (INT/FOR) | MEC-018 |
| IN-021 | S1-N3 | Dagruve, loja aberta (print 003) | Na loja, evidenciar quando já existe um item equipado no slot | MEC-019 |
| IN-022 | S1-N4 | Dagruve, nv 15 (print 004) | Diferenciar os eventos aleatórios que estão sem asset: curandeiro, loja, ferreiro | ART-009 (**2º relato**) |
| IN-023 | S1-N5 | Docas, loja/forja aberta (print 005) | Quando já há item equipado, mostrar por qual ele está sendo trocado | MEC-019 |
| IN-024 | S1-N6 | Docas, `puddles`, nv 25 | Fontes menos frequentes, "mas não muito" | MEC-020 |
| IN-025 | S1-N7 | Shedaklah, nv 26 (print 007) | Ao escolher manter um item 3 vezes consecutivas, o nível dele aumenta | MEC-021 (**a confirmar** o significado) |
| IN-026 | S1-N8 | Shedaklah, nv 28 | Asset mais evidente para o "ímã" de experiência | ART-015 |
| IN-027 | S1-N9 | Shedaklah, nv 29 | Mostrar na loja **e na forja** as melhorias/pioras de um item para o outro quando já possui um equipado; ao passar o mouse; uma comparação | MEC-019 |
| IN-028 | S1-N10 | Shedaklah, nv 31 | Alguns Nv 2 de equipamentos não apresentam melhorias | **BUG-015** (confirmado por print + código, ver abaixo) |
| IN-029 | S1-N11 | Molor, nv 36 | Mostrar o dano da arma ou magia com os atributos que já possui (dano máx./mín.) | MEC-018 |
| IN-030 | S1-N12 | Durão, `styx_memory`, nv 45, tela `item_offer` | Mobs estão ficando presos em obstáculos | BUG-012 (**2º relato**, Durão de novo) |
| IN-031 | S1-N13 | Durão, nv 46 | A perda de INT do rio Estige deve durar apenas 5 min | MEC-022 |
| IN-032 | S2-P1 | Bromnor, Dagruve, 00:48, PV 10/60 (print sem nota) | Sem texto; intenção do print desconhecida | Confirmar com Hiago (ver "Sinais cruzados") |

### Verificação de IN-028 (nota 10, Nv 2 sem melhoria) → BUG-015

O jogador apontou o sintoma; a causa vem do código e dos prints:

1. **Prévia do ferreiro não mostra o ganho.** `core/battle.gd` (oferta
   `shop_item_up`) monta `next_desc` com `Items.mods_text(it.mods)`, os mods
   **sem escala**. O bônus de nível é aplicado só na agregação
   (`core/hero.gd` `recalc()`, `Items.level_scale` = +15 % por nível acima de 1).
   Resultado visível: o print 005 mostra *"Amuleto Abissal da Fortuna → Nv 2 —
   +4 PV, +13% moedas, +0.7 PV/s, +1 CAM"*, **idêntico** ao texto da loja no
   print 003. Para o jogador, subir de nível "não muda nada".
2. **Valores pequenos sofrem truncamento.** `Hero.cam()` faz `int(m("cam"))`:
   +1 CAM × 1,15 = 1,15 → continua +1. Só passa a valer com nível 3 ou mais mods
   somados. O mesmo vale para outros modificadores inteiros (redução, precisão).
3. **Armas seguem outra regra** (`_level_desc`): "cd -0.6", "mark +0.1" são
   ganhos reais, mas pequenos e sem unidade; o Nv 2 da Marca da Retidão (+0.1)
   é o candidato a "sem melhoria" para quem lê o número.

Isto reabre a verificação do BUG-008 (nível de equipamento) e é defeito de
**informação + arredondamento**, não de cálculo interno.

## Questionário rápido 002 — respostas

Escala: C = Concordo · P = Em parte · D = Discordo · N = Não notei.
Contagem do cartão = **T01 (voto de partida, origem da frase) + T02**.

| # | Tema | Cartão(ões) | T02 | Comentário literal | Cartão passa a |
|--:|---|---|:-:|---|---|
| 1 | Objeto fora da área andável | BUG-011 | C | — | 2 de 2 |
| 2 | Inimigos presos em objetos | BUG-012 | C | (+ nota espontânea N12) | 2 de 2 · **confirmado** |
| 3 | Cenário flutuando | BUG-013 | C | — | 2 de 2 |
| 4 | Ritual: recompensa e penalidade | BUG-014 | C | (+ nota espontânea N1; **prioridade 1ª**) | 2 de 2 · **confirmado** |
| 5 | Quebráveis raros | MEC-007 | **P** | — | 1 C + 1 P |
| 6 | Evolução de arma pouco clara | MEC-008, MEC-009 | C | — | 2 de 2 |
| 7 | Impacto do level-up | ART-010 | C | — | 2 de 2 |
| 8 | Mapas apertados | MEC-012 | C | **prioridade 2ª** | 2 de 2 |
| 9 | Jogar mais rápido em fases vencidas | MEC-010 | C | **prioridade 3ª** | 2 de 2 |
| 10 | Baú de chefe | MEC-013, ART-011 | C | "no caso apenas 1 baú" | 2 de 2 (+ detalhe) |
| 11 | Progressão tardia estagna | MEC-014, MEC-005 | C | "falta aumento de status, aumento de hp max, etc." | 2 de 2 (+ proposta) |
| 12 | Cenário simples | ART-012 | **P** | — | 1 C + 1 P |
| 13 | Moedas sobrando | MEC-015 | C | "os upgrades deveriam ser mais caros ou as moedas serem menos frequentes" | 2 de 2 (+ proposta) |
| 14 | Conquistas que desbloqueiam | MEC-016 | C | — | 2 de 2 |

- **Prioridades (4, 8, 9):** ritual (defeito), mapas apertados, jogar mais
  rápido. Nota final **10/10**.
- **Zero "Não notei" e zero "Discordo".** O próprio PDF avisa do viés das frases
  afirmativas. Trate 12 "Concordo" seguidos como **acordo**, não como prova;
  vale mais o que ele **escreveu por conta própria** nas notas.

### Força da evidência por cartão

| Nível | Cartões |
|---|---|
| **Espontânea + questionário** (mais forte) | BUG-012 (N12 + Q2), BUG-014 (N1 + Q4), ART-009 (N4 + texto livre) |
| **Espontânea sem T01** (novos) | MEC-018, MEC-019 (5 relatos no total), MEC-020, MEC-021, MEC-022, ART-015, BUG-015 |
| **Só questionário** (acordo, sem fato novo) | BUG-011, BUG-013, MEC-008/009/010/012/013/014/015/016, ART-010/011/012 |
| **Concordância parcial** | MEC-007 (P), ART-012 (P) |

## "Algo que me incomodou" (texto livre)

1. **Nv 2 dos equipamentos sem bônus** → BUG-015.
2. **Sem clareza de slot ocupado e sem diferença de atributos ao substituir**
   → MEC-019 (sobe para 5 relatos, contando N3, N5, N9, este item e o pedido de
   hover de EVID-091 resposta 2).
3. **Eventos aleatórios (loja, ferreiro, curandeiro) indistinguíveis** → ART-009.

## Sinais cruzados

- **MEC-019 é o pedido mais repetido de T02** (N3, N5, N9 + texto livre) e
  reforça a resposta 2 de EVID-091. MEC-006 ("hover com mais detalhe") fica
  absorvido por ele.
- **Economia (MEC-015):** T02 terminou a run com **+23 354 moedas** (T01: ~30 000)
  e comprou tudo. Duas runs independentes, mesmo sintoma; T02 propõe dois
  caminhos (upgrades mais caros **ou** menos moedas). Decisão de balanceamento
  em PLAN próprio, com o bot.
- **Ritual (BUG-014):** o print 001 mostra o toast **"Ritual interrompido."** sem
  recompensa e o log traz *"O ritual trouxe reforços!"* 7 a 20 s depois de cada
  *"permaneça no selo"*. O print de S2 (Bromnor, PV 10/60 em 00:48, com o log
  "Ritual da Névoa" às 15:15:39 e reforços às 15:15:49) e o print 001
  (PV 10/42 em 01:07) mostram **PV muito baixo no início de Dagruve logo
  depois de rituais**. Hipótese: ritual + reforços derrubam a vida no começo
  da fase. Sem prova; perguntar a Hiago o que o print S2 queria mostrar.
- **Quebráveis (MEC-007):** T02 respondeu "Em parte" e não escreveu nota sobre
  o tema; o log não registra quebráveis. O tema fica com
  2 relatos de T01 e 1 "Em parte".
- **INT do Estige (IN-031):** `hero.styx_lucidity_loss` **só zera no início da
  run** (`core/battle.gd:166`); a perda é permanente, sem prazo. Hiago pede que
  dure **5 minutos**. É ajuste pequeno (temporizador) mas muda o desafio do
  bioma; ver MEC-022.

## Pedidos de recomendação em aberto

Nenhum novo pedido explícito. Segue tudo o de EVID-106 (ambientação, QoL de
rejogabilidade, conquistas). O único novo: T02 pede **decisão de economia**
(upgrades mais caros ou menos moedas) → entra no PLAN de MEC-015.

## Perguntas para Hiago

1. Herói mais jogado foi Leoric? (os pacotes só têm Brook e Bromnor)
2. O print da run de Bromnor (PV 10/60) queria mostrar o quê?
3. Nota 7: "manter um item 3 vezes consecutivas" = escolher **equipar** o item
   já equipado (ou recusar a troca) 3 vezes seguidas? Ou é sobre a tela de
   oferta de item?
4. Nota 13: "durar apenas 5 min" é o tempo da **perda de INT** (hoje
   permanente na run)? Confirmar que não é "5 s" do Esquecimento.
5. Nota 6: "fontes menos frequentes": eram as fontes de "+11 % PV" (log)?

## Limites

- Nada foi implementado nem aprovado; só arquivamento, verificação de código
  (leitura) e triagem. Nenhum arquivo de jogo foi alterado.
- Amostra de dois jogadores **não independentes**, ambos conhecem o projeto.
  Serve para priorizar o backlog, não para decidir design.
- O `log.txt` só retém 200 linhas: não cobre o início da run.
