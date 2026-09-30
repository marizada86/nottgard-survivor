# QUESTIONARIO-003 — Verificação da versão 0.2.0

Criado em 2026-09-29. Arquivo para os testers: `QUESTIONARIO Rápido - 003.pdf` (fonte em `.html`, mesma pasta;
gerado com o Chrome em modo headless: `chrome --headless --print-to-pdf`). Mesmo formato do
[questionário 002](QUESTIONARIO-002-validacao-EVID-106.md): 18 frases com **Concordo · Em parte · Discordo · Não
notei**, 3 prioridades, comentário livre e nota 0 a 10. Serve para saber se as **correções e novidades da 0.2.0**
funcionaram. Playtest da versão publicada em `latest` (commit `fce670d`), ver [RELEASES](../RELEASES.md).

## Regra de leitura

- Perguntas 1 a 5 são **defeitos**: **"Concordo" = o problema ainda acontece**; "Não notei" ou "Discordo" nos
  cartões corrigidos conta como sinal de que foi resolvido (regra do dono: bug não mencionado de novo = corrigido).
- Perguntas 6 a 18 são **novidades**: "Concordo" e "Em parte" validam; "Discordo" pede ajuste do cartão.
- "Não notei" na maioria = sem exposição, manter o cartão em aberto.
- Amostra pequena e afirmativa: só decidir com **duas respostas independentes** e cruzar com as notas F5.

## Mapa pergunta → cartão

| # | Tema | Cartão(ões) | Como ler |
|--:|---|---|---|
| 1 | Objeto fora da área andável | BUG-011 | Concordo = ainda ocorre |
| 2 | Inimigos presos em objetos | BUG-012 | Concordo = ainda ocorre |
| 3 | Objetos flutuando | BUG-013 (fechado, EVID-121), ART | Concordo = reabrir |
| 4 | Ferreiro: nível sem diferença visível | BUG-015 | Concordo = ainda ocorre |
| 5 | Ritual sem recompensa | BUG-014 → MEC-026 | Concordo = a bênção não apareceu ou não foi percebida |
| 6 | Comparação de equipamento | MEC-019 · SPEC-081 | Concordo = validado |
| 7 | Loja e ferreiro mostram o que falta | MEC-023 · SPEC-082 | Concordo = validado |
| 8 | Bênção do Selo | MEC-026 · SPEC-084 | Concordo = validado |
| 9 | Começo das fases mais cheio | MEC-024 · SPEC-083, BAL-001 | Discordo = ficou fácil ou difícil demais (ver comentário) |
| 10 | Inimigos por vários lados | MEC-011 · SPEC-090 | Concordo = validado |
| 11 | Tela de evolução | MEC-009 · SPEC-091, MEC-008 | Concordo = validado |
| 12 | 2x e Ampulheta | MEC-010 · SPEC-085 | Concordo = validado |
| 13 | Altar da Doação e Mesa de Aposta | MEC-005 · SPEC-087 | Concordo = validado |
| 14 | Mapas menos apertados | MEC-012 · SPEC-093 | Concordo = validado |
| 15 | Mapas vazios demais | MEC-012 · SPEC-093 | **Concordo = problema** (pergunta invertida) |
| 16 | Progressão na fase tardia | MEC-014 · SPEC-088, BAL-002 | Concordo = validado |
| 17 | Meta, conquistas e biografias | MEC-015, MEC-016 · SPEC-088, SPEC-089 | Concordo = validado |
| 18 | Eventos distinguíveis e cores de raridade | ART-009, ART-016 | Concordo = validado |

## Fora do questionário (de propósito)

BUG-001 (Zumbi), ART-018 a 020 (eventos sem arte), MEC-025 (HQs), BAL-008 (Zynara) e BAL-009: ou não são percebidos
sem uma situação específica, ou ainda não estão na build. Pedir nas notas F5 se o tester usou Zynara ou Nyrelia.

## Como assimilar

Seguir o [INTAKE](../INTAKE.md) (T04, T05...). Cada resposta soma no cartão como "N de M"; as 3 prioridades somam
pontos por número de pergunta e alimentam o próximo lote.
