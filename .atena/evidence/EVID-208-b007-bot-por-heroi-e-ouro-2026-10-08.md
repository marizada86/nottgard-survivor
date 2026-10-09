---
id: "EVID-208"
title: "PLAN-081 B-007: bot por herói antes e depois do conteúdo novo, e ouro por fonte"
created: "2026-10-08"
plan: "PLAN-081"
spec: "SPEC-148"
cards: ["BAL-018", "BAL-023", "BAL-025", "MEC-041", "MEC-042"]
status: "medido; nenhum ajuste de número necessário; sem commit dos dados brutos até aprovação"
---

# EVID-208 — Bot por herói e ouro (B-007)

## Método

Mesma rodada do [EVID-193](EVID-193-b003-correcoes-de-escala-do-ouro-2026-10-07.md): `tools/bot_curva.gd`, dt 0,08, 9 fases, lado 60, dez heróis, meta 0 (novato) e meta 1 (veterano), sem Marcas. Duas medições:

| Medição | Antes | Depois | Sementes |
|---|---|---|---|
| Rodada curta | `5953d44` (fim do B-001, cópia limpa) | HEAD da 0.4.0 (`ea9100f`, árvore igual) | 5 por herói |
| Rodada longa | idem | idem | **15 por herói** |

"Antes" = sem Arcanista, sem as 3 armas, sem os 7 equipamentos e sem os segredos; "depois" = tudo isso (o mapa 84×84 e os segredos não entram no bot, que usa um lado único e não chama `place_scenery`). Scripts, CSVs brutos e as tabelas em `.atena/generated/v040-release/bot/` (`run_b007.sh`, `aggregate.js`, `resultado-n5.md`, `resultado-n15.md`).

## Resultado (15 sementes por herói; fases vencidas, nível ao morrer, tempo)

| Meta | Média antes | Média depois |
|---|---|---|
| Novato | 0,63 fases · nv 9,3 · 13,7 min | 0,59 fases · nv 9,2 · 12,7 min |
| Veterano | 0,78 fases · nv 10,7 · 15,6 min | 0,96 fases · nv 11,7 · 17,7 min |

Por herói (veterano, antes → depois): Durvall 0,0 → 0,2 fases; Brook 0,9 → 0,9; Maelor 1,2 → 1,3; Sylas 0,7 → 1,1 (nv 12,3 → 14,3); Kayron 0,5 → 1,0 (nv 8,7 → 11,5); Korrak 2,2 → 2,3; Leoric 0,2 → 0,3; Nyrelia 0,1 → 0,3; Zynara 0,3 → 0,1 (nv 7,3 → 6,7); Bromnor 1,6 → 2,1. Novato: nenhum herói muda de patamar; Bromnor (1,1 → 0,9) e Brook (0,5 → 0,3) descem um pouco, Sylas e Durvall sobem um pouco. Os intervalos com 15 sementes são largos: a rodada curta (5 sementes) deu sinais opostos em vários heróis (por exemplo, Brook novato 1,0 → 0,2 e Sylas veterano 0,4 → 1,6), o que mostra ruído, não efeito.

**Conclusão:** **sem regressão que peça decisão.** O conteúdo novo não derruba nenhum herói de forma sistemática e dá um empurrão pequeno ao veterano (Sylas, Kayron, Bromnor); o ganho aparece em heróis de magia (Sylas, Kayron), compatível com o Arcanista e as magias novas, mas a rodada não isola a causa. **Zynara** segue a mais fraca (nível 5 a 7, 0 a 0,3 fase), já registrada no BAL-008/BAL-014 e sem mudança nesta rodada; **Nyrelia novato** (nv 3,5) idem. Nenhum número de `data/` foi mexido além dos dois ajustes do BAL-025 (EVID-206).

## Ouro por fonte (BAL-023, `gold_src`)

| | Antes | Depois |
|---|---|---|
| Ouro bruto por run, veterano (150 runs) | 193 | 278 (corridas mais longas, mais fases) |
| Ouro bruto por run, novato (150 runs) | 163 | 153 |
| Fontes (veterano, depois) | abate 36%, elite 18%, chefe 8%, quebrável 10%, venda 28% | |

O conteúdo novo **não criou fonte nova de ouro**; a proporção das fontes é a mesma. O ganho do veterano acompanha as fases vencidas, não o preço. **S-022:** nenhum pacote de tester traz `gold_src` (o Daniel jogou a 0.3.3 e o Manzi a 0.3.2; os relatos EVID-199 e EVID-200 não citam moedas), então a meta de ouro (M1 e M6 da EVID-191) continua **projetada** e fica para o primeiro playtest com `gold_src`.

## Limites

- O bot não explora nem usa Ecos, câmaras ou relíquias, e não joga em 84×84; só playtest humano mede isso.
- O bot escolhe armas e níveis por heurística; as armas novas entram no sorteio de todos, o que reembaralha as sementes. Por isso a comparação é estatística, não por semente.
- Rodada de 15 sementes em dois perfis de meta; sem Marcas do Abismo.
