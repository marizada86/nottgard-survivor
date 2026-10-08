---
id: EVID-191
title: Linha de base de ouro por fonte (PLAN-075 B-001 e B-002 S-004)
date: 2026-10-07
spec: SPEC-142
plan: PLAN-075
cards: [BAL-023, BAL-003]
---

# EVID-191 — Linha de base de ouro

## Como foi medido
- Telemetria nova: `Battle.stats.gold_src` e `result().gold_src` (fontes: abate, elite, chefe, quebravel, evento, venda, oferta, arma, outro). **Nenhum valor do jogo mudou.**
- `tools/bot_curva.gd` imprime `GOLD;` por fase. Rodada: 10 heróis × 5 sementes × até 9 fases, mapa 60, dt 0,08, perfis **novato (meta 0)** e **veterano (meta 1)**, sem Marcas. Dados em `.atena/generated/gold-economy/v01/baseline/`; agregador `aggregate.awk`; script `run_baseline.sh`.
- Suíte inteira: 0 falhas (teste novo em `tests/test_battle.gd`: a soma por fonte fecha com o total).

## Resultado (bot, 50 runs por perfil, nenhuma vitória)

| Fase | Runs | Ouro bruto médio/fase (veterano) | Abate | Elite | Chefe | Quebrável | Venda | Arma |
|---|---|---|---|---|---|---|---|---|
| Dagruve | 50 | 86 | 41 % | 15 % | 14 % | 19 % | 11 % | 0 |
| Docas | 22 | 208 | 27 % | 21 % | 23 % | 8 % | 22 % | 0 |
| Shedaklah | 17 | 372 | 33 % | 26 % | 5 % | 15 % | 21 % | 0 |
| Molor | 6 | 1 384 | 46 % | 16 % | 7 % | 4 % | 7 % | 20 % |
| Durão | 5 | 672 | 39 % | 19 % | 4 % | 4 % | 14 % | 17 % |
| Feng-tu a Goranthis | 3 | 956 a 1 395 | n pequeno | | | | | |

Novato: Dagruve 89 · Docas 236 · Shedaklah 361. Ganho médio estimado no Quartel por run: **193 (novato) e 372 (veterano)**, mediana 24 e 32 (a maioria morre cedo).
Evento e oferta ficam em ~0 % porque o bot não abre baús nem eventos.

## Achados

1. **Escala por fase:** o ouro bruto sobe de 86 (fase 1) para 600 a 1 400 (fases 4 a 8), muito mais que o tempo gasto, confirmando F1 da SPEC-142.
2. **F7 (novo): Chicote Avarento (`gold_hit`) quebra a economia.** Dá +1 moeda **por acerto**, sem `coin_mult` e sem teto. Nos casos em que o Kayron e o Korrak o pegaram, a fonte "arma" chegou a **1 669 de 2 975 moedas** numa só fase (56 %); 1 630 de 2 588 em Molor (63 %). Só uma peça no jogo tem `gold_hit`, mas ela sozinha desfaz qualquer meta.
3. **Venda** pesa 11 a 22 % da renda do bot (sobe com a fase). Confirma F3: é fonte grande, entra no Quartel e não escala.
4. **Quebráveis** 4 a 19 % e **chefe** 4 a 23 %: peso razoável, sem distorção.
5. **Limite do bot:** nenhuma vitória, n pequeno depois de Shedaklah, sem baús, eventos, loja e aposta. **Os números absolutos subestimam o humano.** Referência humana: T02 ganhou +23 354 em uma vitória até Feng-tu (EVID-107) contra ~3 400 que o bot acumularia nas mesmas seis fases. Serve para forma e composição, não para o ritmo final.
6. O registro da run enviado no playtest (`core/run_record.gd`) **não leva ouro**. Hoje os playtesters não geram dado de economia.

## Proposta para B-002 S-004 (metas numéricas; aguardam confirmação do dono)

Âncora: meta D2 de ~20 vitórias → 228 800 / 20 ≈ **11 000 por vitória** até Feng-tu (perfil veterano, sem Marcas, descida 0). Dado humano antigo 23 000 a 30 000, ou seja, **corte de ~50 %** se ele continuar valendo.

| # | Aceite proposto | Hoje (melhor estimativa) |
|---|---|---|
| M1 | Vitória até Feng-tu, sem Marcas: **9 000 a 13 000** moedas do Quartel | ~23 000 (T02, dado antigo) |
| M2 | Run que morre na fase 2: **100 a 300** moedas | bot veterano: mediana 32, média 372 |
| M3 | Marcas no máximo e descida 3: **≤ 3 × M1** (≤ ~35 000) | teórico até ×4,75 sobre a base |
| M4 | Nenhuma fonte passa de **40 %** da renda média de uma fase | arma 56 a 63 % nos casos extremos |
| M5 | `gold_pct` +10 % ⇒ **+8 % a +12 %** de ouro esperado, em qualquer fase | ~0 % nas fases 1 e 2 |
| M6 | 1ª compra relevante (≥ 150 moedas) em até 2 runs | provável já hoje |

## Passos extras sugeridos (precisam de aprovação)
- **S-003b:** incluir `gold_src` e `raw_gold` no `core/run_record.gd` para que os playtests dêem a medida humana. Toca o contrato de dados do PLAN-071 e o servidor; só com sua aprovação.
- Rodar a base com Marcas no máximo (7º argumento do bot, SPEC-141) quando PLAN-074 B-004 terminar.
- Calibrar M1 com o primeiro playtest que levar o `gold_src`.

## Estado
B-001 concluída. B-002: S-004 feita; **S-005 aguarda o dono confirmar ou trocar M1 a M6**. B-003 não começa antes.

## Fechamento da B-002
- Dono confirmou M1 a M6 como propostas (2026-10-07).
- S-003b: não foi preciso editar `core/run_record.gd`; `snapshot()` já copia `Battle.result()`, que agora inclui `raw_gold` e `gold_src`. Teste novo em `tests/test_run_record.gd`. Suíte inteira: 0 falhas. **A aceitação da chave nova pelo servidor (`/api/playtest/runs`) não foi verificada aqui.**
- Próximo: B-003 (S-006 `gold_pct` proporcional, S-007 venda, S-008 curva e Chicote Avarento) só depois do fim da B-004 do PLAN-074.
