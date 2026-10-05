---
id: "EVID-156"
title: "SPEC-122 lotes B-007 e B-008: recalibração das fases 4 a 9, Goranthis, preço por raridade e rótulos"
created: "2026-10-04"
relations: ["[[SPEC-122-balanceamento-ritmo-inicial-xp-armas-e-raridade]]", "[[EVID-154-lotes-b003-a-b006-armas-eventos-raridade-2026-10-04]]", "[[EVID-155-varredura-de-alinhamento-0-2-0-ate-agora-2026-10-04]]"]
cards: ["BAL-017"]
---

# EVID-156 — B-007 e B-008 (nada commitado)

## B-008 — preço por raridade e rótulos (decisões E5 e E6)
- `data/difficulty.json` bloco `prices`: loja `16/24/28/32/40` e venda `8/16/20/24/32` para comum/mágico/incomum/raro/único. São os preços antigos com o Incomum no meio; `Items.price(kind, raridade)` lê a tabela (com fallback na fórmula antiga).
- `Items.rarity_label()`: Comum, Mágico, Incomum, Raro, Único em loja, troca, doação, venda e avisos.
- Testes novos em `tests/test_rarity.gd` (rótulos com acento, preços crescentes por raridade).

## B-007 — recalibração (`data/stages.json`, fases 4 a 9; decisões E1 e E3)
Medição: `tools/bot_curva.gd`, bot **veterano** (meta 1), 10 heróis, mapa 60×60, `dt` 0,1, em paralelo. Rodada 0 com 3 sementes (n=110 passagens); rodadas 1 e 2 com 5 sementes (n≈250 e ≈200). Sem erro de script em nenhuma.

| Fase | Mult. antes (`hp`/`dmg`) | R0: curva do jogo antes | Mult. rodada 1 | R1 mortes | **Mult. final** | **R2 mortes final** |
|---|---|---:|---|---:|---|---:|
| Dagruve | 1,0 / 1,0 | 27 % | = | 22 % | = | 32 % |
| Docas | 1,35 / 1,0 | 0 % | = | 3 % | = | 3 % |
| Shedaklah | 1,5 / 1,4 | **45 %** | 1,4 / 1,2 | 27 % | 1,4 / 1,2 | 18 % |
| Molor | 2,1 / 1,75 | **42 %** | 1,85 / 1,45 | 15 % | **2,0 / 1,6** | 23 % |
| Durao | 2,8 / 1,9 | 0 % (n=7) | 2,5 / 1,7 | 5 % | **2,8 / 1,95** | 16 % |
| Feng-tu | 3,6 / 2,1 | 0 % (n=7) | 3,2 / 1,95 | 0 % | **3,5 / 2,2** | 6 % |
| Shendilavri | 4,5 / 2,3 | 40 % (n=5) | 4,1 / 2,2 | 0 % | **4,4 / 2,4** | 27 % |
| Goranthis | 5,5 / 2,25 | 0 % (n=3) | 5,2 / 2,3 | 13 % | **5,5 / 2,5** | 38 % (n=8) |
| Pilares | 6,5 / 2,5 | 50 % (n=2) | = | 30 % | = | 0 % (n=4) |

Leitura:
- Com o XP novo o Shedaklah e o Molor eram letais para o veterano (45 % e 42 %, contra 6 % e 5 % na EVID-150). A primeira rodada aliviou demais e as fases do meio voltaram a ficar fáceis (Durao 5 %, Feng-tu 0 %, Shendilavri 0 %); a segunda subiu essas fases em degraus.
- **Goranthis agora acima do Shendilavri** (`dmg` 2,5 contra 2,4; `hp` 5,5 contra 4,4): decisão E3 cumprida. `tests/test_affixes.gd` e o aviso de curva da auditoria acompanharam.
- Rampa observada (veterano): Shedaklah 18 % → Molor 23 % → Durao 16 % → Feng-tu 6 % → Shendilavri 27 % → Goranthis 38 %. Não é monótona. Com tantas fases tardias vistas só por quem sobrevive (n de 8 a 19), o ruído é grande.

## Pontos abertos (não resolvidos aqui)
1. **Docas é muito fácil** (3 % de morte, PV mínimo 76 %); Dagruve está em 32 %. A rampa começa no Dagruve e cai no Docas. Decidir se Docas sobe (`hp_mult`/`dmg_mult`) ou se Dagruve desce.
2. **Feng-tu** (6 %) está abaixo do que o vizinho Durao (16 %) e Shendilavri (27 %) sugerem.
3. As metas E1 eram para o bot **novato**. A calibração foi feita com o **veterano**, mais estável e com mais passagens nas fases finais; o novato morre mais (Dagruve 50 % na EVID-154). Vale uma rodada de novato nas fases finais se o dono quiser confirmar.
4. `tools/bot_curva.gd` usa `randf()` global (não semeado) em `_pick`: o resultado não é 100 % determinístico quando há empate de escolha. Semear o RNG do bot para reproduzir medições.

Testes: `tests/run_all.gd` 0 falhas; `audit_projeto.gd` 0 erros. Humano decide; o bot é alarme.
