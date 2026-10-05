# QUESTIONARIO-006 — Versão 0.3.0

Criado em 2026-10-03. Arquivo para os testers: `QUESTIONARIO Rápido - 006.pdf` (fonte em `.html`, mesma pasta; gerado com
`chrome --headless --print-to-pdf`). Cobre **0.2.3 → 0.3.0**: 4 linhas de dificuldade (Fácil demais · Na medida · Difícil demais · Não cheguei),
a pergunta "onde e quando morreu pela primeira vez", 9 frases com Concordo · Em parte · Discordo · Não notei, 3 prioridades, comentário livre e nota 0 a 10.
Os testers anteriores não responderam o questionário (só conversaram), então ele é curto de propósito, para novos testers.

## Uso principal: comparar jogadores com o bot
As linhas A a D e a morte inicial servem para comparar com o bot (EVID-148, 149 e 150). Mapeamento: A = Dagruve e Docas; B = Shedaklah e Molor;
C = Durao e Feng-tu; D = Shendilavri em diante. O bot (veterano) dá PV mínimo médio de 52 % e 20 % de mortes em Dagruve, 85 % em Docas,
66–71 % em Shedaklah a Durao, 77 % em Feng-tu, 72 % em Shendilavri e 50 % em Goranthis (EVID-150, antes do último ajuste de `dmg_mult`).
O bot não usa loja, ferreiro nem eventos: tratar como alarme, e a resposta humana como veredito.

## Regra de leitura
- Perguntas **2** e **6** são invertidas: na 2, Concordo = problema; na 6, Discordo = problema.
- Demais: "Concordo" e "Em parte" validam; "Discordo" pede ajuste. "Não notei" = sem exposição.
- Decidir só com duas respostas independentes.

## Mapa pergunta → cartão
| # | Tema | Cartão |
|--:|---|---|
| A–D | Dificuldade por faixa de mapas | BAL-016, BAL-001 |
| 1, 2 | Afixos de elite e de chefe | SPEC-120 parte A |
| 3 | Horda | SPEC-120 parte A |
| 4, 5 | Acontecimentos exclusivos por mapa | SPEC-118, MEC-038 |
| 6 | Chão e desenho de nível | PLAN-054, SPEC-116 |
| 7 | Animações novas | PLAN-053 |
| 8 | Sons reais | SFX-LISTA-001 |
| 9 | Variedade depois do 3º/4º mapa | BAL-016, PLAN-055 |

---
**Adendo 2026-10-04:** os números do bot desta nota são de antes da SPEC-122 (XP, armas, eventos e raridade). Para comparar com respostas novas, use a linha de base de [EVID-154](../../evidence/EVID-154-lotes-b003-a-b006-armas-eventos-raridade-2026-10-04.md); só vale para builds com a SPEC-122.
