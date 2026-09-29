# SPEC-086 — Ajustes pós-playtest: números e clareza (MEC-007, 008, 013, 017, 018, 020, 022)

Status: **implementada (2026-09-29); validação em playtest.**

Lote de mecânicas pequenas pedidas nos playtests T01, T02 e T03
([[EVID-106-playtest-publico-t01-higor-2026-09-29]], [[EVID-107-playtest-publico-t02-hiago-2026-09-29]],
[[EVID-108-playtest-publico-t03-dna-2026-09-29]]). Plano: [[PLAN-038-atualizacao-pos-playtests-t01-t02-t03-2026-09-29]].
Números em `data/difficulty.json`, `data/stages.json` e `data/boss_presentations.json`.

| Cartão | Mudança |
|---|---|
| **MEC-007** quebráveis | Intervalo entre quebráveis de 35–55 s para **22–36 s**; cada ponto de modificador de Carisma encurta **6%** (até −40%). `Battle._breakable_interval` |
| **MEC-013** baú do chefe | Além dos 2 baús comuns, o chefe deixa o **Baú do Chefe**: nunca é mímico e entrega item **raro ou único** (Carisma +4 na sorte, um nível de tier acima). Reaproveita a arte do baú com rótulo dourado até existir `assets/interactions/boss_chest.png` (**ART-011**) |
| **MEC-017** névoa | Dano da Maré de Névoa dobrado: **2% → 6%** da vida máxima por segundo |
| **MEC-020** fontes | Peso das fontes nos eventos aleatórios de **2 para 1,4** (a fase com peso 3 passa a 2) |
| **MEC-022** INT do Estige | Cada perda de INT no Estige **expira em 300 s** (`styx_lucidity_seconds`); antes durava até o fim do mapa |
| **MEC-018** dano | Painel `C` e ofertas de arma mostram a **faixa de dano** com atributos e bônus (`Dano 6–19 (físico, escala com FOR)`); a oferta de nível mostra `Dano atual → próximo` |
| **MEC-008** evolução | Painel `C` e ofertas de nível trazem a dica: `Evolui em X com nível 5 + passiva Y. Falta: …` ou `Pronta para evoluir`. A oferta de evolução ganha `★` |

## Testes

`tests/test_battle.gd`: intervalo de quebráveis menor e encurtado pelo Carisma; expiração da INT; baú do chefe
nunca abaixo de raro; faixa de dano e `Dice.bounds`; dica de evolução; dano da névoa reescrito (2% e 6%).

## Limites

- A faixa de dano ignora crítico (dobra) e efeitos condicionais.
- MEC-018 não mostra dano por magia com escala especial; só armas com dado.
- Sem medição do bot para o efeito de quebráveis e fontes; validar em playtest.
- MEC-021 (manter item 3 vezes) ficou de fora por ser ambíguo; MEC-009 (mini-cinemática) depende de arte.
