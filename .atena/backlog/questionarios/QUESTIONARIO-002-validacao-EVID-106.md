# QUESTIONARIO-002 — Validação das análises do EVID-106

Criado em 2026-09-29. Arquivo para os testers: `QUESTIONARIO-002-validacao-EVID-106.pdf`
(fonte em `.html`, mesma pasta). Serve para saber se **outros jogadores concordam**
com o que T01 (Higor) relatou em
[EVID-106](../../evidence/EVID-106-playtest-publico-t01-higor-2026-09-29.md).

Escala por frase: **Concordo · Em parte · Discordo · Não notei**. Mais: 3
prioridades (números), comentário livre e nota 0 a 10 de vontade de continuar.

## Mapa pergunta → cartão

| Pergunta | Tema | Cartão(ões) | Nota de origem |
|---:|---|---|---|
| 1 | Objeto fora da área andável | BUG-011 | IN-015 |
| 2 | Inimigos presos em objetos | BUG-012 | IN-009 |
| 3 | Cenário flutuando | BUG-013 | IN-010 |
| 4 | Ritual: recompensa e penalidade | BUG-014 | IN-001 |
| 5 | Quebráveis raros | MEC-007 | IN-004, IN-005 |
| 6 | Evolução de arma pouco clara | MEC-008, MEC-009 | IN-006, IN-008 |
| 7 | Impacto do level-up | ART-010 | IN-006 |
| 8 | Mapas apertados | MEC-012 | IN-011 |
| 9 | Jogar mais rápido em fases vencidas | MEC-010 | IN-007, IN-012 |
| 10 | Baú de chefe | MEC-013, ART-011 | IN-013 |
| 11 | Progressão tardia estagna | MEC-014, MEC-005 | IN-014 |
| 12 | Cenário simples | ART-012 | IN-010, IN-018 |
| 13 | Moedas sobrando | MEC-015 | IN-016 |
| 14 | Conquistas que desbloqueiam | MEC-016 | IN-017 |

Fora do questionário (não perguntado de propósito): BUG-014 além do sintoma,
MEC-011 (IA de flanquear), MEC-017 (dano da névoa), ART-008, ART-009, ART-013,
ART-014. Ou não são percebidos por jogador novo, ou dependem de o jogador ter
visto os eventos.

## Como assimilar as respostas

1. Cada respondente segue o [INTAKE](../INTAKE.md) (código T02, T03…).
2. Para cada pergunta, contar as respostas e anotar **no cartão** como
   `N de M concordam` (somando T01 como voto de partida). Não criar cartão novo.
3. **Regra de decisão sugerida:**
   - Concordo + Em parte na maioria e **2 ou mais jogadores** → confirmado, pode
     entrar em lote.
   - "Não notei" na maioria → ainda sem evidência; manter em aberto.
   - Discordo na maioria → rebaixar ou fechar o cartão com a justificativa.
4. As **3 prioridades** de cada pessoa somam pontos por número de pergunta; o
   ranking ajuda a escolher o próximo lote de bugs e de mecânicas.
5. Perguntas 1 a 4 são defeitos: um único "Concordo" de alguém que não seja T01
   já basta para subir a severidade a partir de "confirmar".

## Cuidados

- Amostra pequena: tratar como indício, não veredito.
- O PDF não usa códigos internos (BUG/MEC/ART) nem revela a origem das frases,
  para não induzir a resposta.
- Frases afirmativas favorecem "Concordo"; por isso o PDF inclui a escolha das 3
  prioridades e a opção "Não notei".

## Respostas recebidas

| Respondente | Herói/fase declarados | Prioridades | Nota | Registro |
|---|---|---|---:|---|
| T02 Hiago | Leoric · Feng-tu (pacotes mostram Brook e Bromnor; confirmar) | 4, 8, 9 | 10 | [EVID-107](../../evidence/EVID-107-playtest-publico-t02-hiago-2026-09-29.md) |
| T03 DNA | Kayron · Shedaklah (pacote termina em Molor) | 2, 9, 6 | 10 | [EVID-108](../../evidence/EVID-108-playtest-publico-t03-dna-2026-09-29.md) |

Tabela pergunta a pergunta (C/P/D/N) no EVID-107 (T02) e EVID-108 (T03). T03 usou as quatro respostas (6 C, 2 P, 3 D, 3 N); ranking de prioridades T02+T03: pergunta 9 (2 votos); 2, 4, 6, 8 (1 voto).

T02: 12 Concordo, 2 Em parte
(perguntas 5 e 12), 0 Discordo, 0 Não notei. Pelo viés das frases afirmativas,
só BUG-012 e BUG-014 contam como confirmados de fato (têm nota espontânea junto).
