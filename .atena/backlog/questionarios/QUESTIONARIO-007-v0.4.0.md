# QUESTIONARIO-007 — Versão 0.4.0

Criado em 2026-10-08 (PLAN-081 B-008). Arquivo para os testers: `QUESTIONARIO Rápido - 007.pdf` (fonte em `.html`, mesma pasta; gerado com
`chrome --headless --print-to-pdf`; uma página A4). Cobre **0.3.1 → 0.4.0**: 4 linhas de dificuldade por faixa de mapas (Fácil demais · Na medida · Difícil demais · Não cheguei),
"onde e quando morreu pela primeira vez", 11 frases com Concordo · Em parte · Discordo · Não notei, 3 prioridades, comentário livre e nota 0 a 10.
Pergunta nova no cabeçalho: com o que jogou (teclado e mouse, controle, celular).

## Regra de leitura
- Perguntas **2, 5, 7 e 9** são invertidas: Concordo = problema.
- Demais: "Concordo" e "Em parte" validam; "Discordo" pede ajuste. "Não notei" = sem exposição.
- Decidir só com duas respostas independentes. Mudar número de balanceamento só com a rodada do bot por herói (EVID-208 é a linha de base).
- A pergunta 11 mistura controle e celular de propósito (aceite físico pendente, MEC-049 e MEC-052): se vier "Discordo", perguntar qual dos dois.

## Mapa pergunta → cartão
| # | Tema | Cartão |
|--:|---|---|
| A–D | Dificuldade por faixa de mapas (comparar com o bot, EVID-208) | BAL-016, BAL-001, BAL-018 |
| 1, 2 | Mapas 84×84, Ecos, ruína, covil, câmara selada | MEC-039, MEC-012 (SPEC-152) |
| 3 | Arcanista e ferreiro | MEC-041 (SPEC-149) |
| 4 | Bola de Fogo, Lâmina de Sombra, Romper Armadura | MEC-042 (SPEC-150), BAL-025 |
| 5 | Equipamentos únicos novos, Coração da Dominância | MEC-042 (SPEC-151), BAL-025 |
| 6, 7 | Marcas do Abismo | MEC-040 (SPEC-141, SPEC-143) |
| 8 | Moedas | BAL-023 (SPEC-142), `gold_src` das estatísticas |
| 9 | Curas mais fracas | BAL-022 |
| 10 | Ficha C, quests, HUD sem sobreposição | BUG-034 a BUG-037, MEC-053 a MEC-056 (SPEC-147) |
| 11 | Controle Xbox/PlayStation e toque no celular | MEC-052, MEC-049, ART-037 (ícones de controle) |

Perguntas abertas para a conversa: a fase em que o Manzi viu o lago (indicador do Estige, MEC-056); se o Daniel viu o ranking atualizar (MEC-057).
