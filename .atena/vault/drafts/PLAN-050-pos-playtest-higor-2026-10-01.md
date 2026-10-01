# PLAN-050 — Plano pós-playtest do dono (2026-10-01)

Origem: [EVID-139](../../evidence/EVID-139-playtest-higor-qa-14b15e4-2026-10-01.md).
Decisões do dono (2026-10-01): Dagruve e Docas em 5:00 com chefe incluso; cópia-isca do Sylas **explode**;
sprites por **normalização via script**; cenário com **piloto em Dagruve + Docas**.

Regra de commit: um commit por item; mecânica nunca no mesmo commit de arte ou bug.

## Onda 1 — correções rápidas (sem dependência)
1. **BUG-020** F5 sobre HQ: foco e entrada. Teste em `tests/`.
2. **ART-024** miniatura das Docas (lote `ART-PROMPTS-038`, já aberto para o fundo do título; avaliar juntar).
3. **BAL-011** duração 300 s em Dagruve e Docas, chefe a 5:00, escalar spawn/cap/HP; rodar o bot.
   Conferir recordes e conquistas que dependam da duração.

## Onda 2 — sprites
4. **BUG-021** script de normalização: escala única por herói (altura do idle), linha de base fixa, sem corte na borda.
   Reaplicar em Brook, Durvall, Leoric, Kayron, Korrak, depois conferir os demais com `audit_hero_motion`.
   Critério: variação de altura entre idle e andar ≤ 10%; `edge_frames` = 0. O que não passar volta para regeneração.
   Partir de SPEC-101 / EVID-129.
5. **BUG-022** quadro 2 da HQ: novo prompt ou retoque.

## Onda 3 — Sylas
6. **ART-027** sprite e VFX da cópia e da explosão.
7. **MEC-029** cópia-isca: spec (duração, raio, dano, recarga, regra de aggro), teste e rodada do bot (BAL).

## Onda 4 — cenário (piloto Dagruve + Docas)
8. Spec de **MEC-030**: tema por bioma, mapa de zonas (estrada, cais, praça), lista de destrutíveis e interativos,
   1 armadilha por bioma, regras de colocação (sem props flutuando, ver BUG-013).
9. **ART-025/026** fundos e props, em lotes de prompt pelo Sabor Nottgard (Vault como fonte).
10. Implementação e playtest do piloto; o resultado vira molde para os outros biomas.

## Onda 5 — alma e dopamina (pesquisa antes de código)
11. **MEC-031**: levantamento de feedback e recompensa (referências Vampire Survivors, Death Must Die) e proposta
    com 3 a 5 itens de baixo risco (números de dano, drops, pausa de acerto, picos de progressão).
12. **MEC-032**: mapa de história por fase e chefe a partir do Vault; segredos de "cânone do mestre" ficam fora até decisão do dono.

## Fora do plano
- Novos inimigos (o dono aprovou o movimento atual): entra pelo fluxo de mobs já existente quando pedido.

## Perguntas em aberto
- Menu mostra PV 26 para Sylas e a run 42/42: confirmar origem.
- Mais algum herói além dos listados com deformação? A auditoria cobre todos.
