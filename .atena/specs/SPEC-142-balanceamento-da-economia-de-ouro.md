---
id: "SPEC-142"
title: "Balanceamento da economia de ouro (moedas da run e moedas do Quartel)"
status: "IMPLEMENTADA localmente em 2026-10-07 (PLAN-075, B-004 pulada); aguarda playtest com gold_src; sem commit"
origin: planned
implementation_preceded_spec: false
request_classification: PLAN_DEVIATION
created: "2026-10-07"
cards: ["BAL-023", "BAL-003", "MEC-015"]
relations: ["[[SPEC-088-economia-do-meta-e-crescimento-tardio]]", "[[SPEC-141-marcas-do-abismo-entrega-1]]", "[[PLAN-075-economia-de-ouro-2026-10-07]]", "[[EVID-106-playtest-publico-t01-higor-2026-09-29]]", "[[EVID-107-playtest-publico-t02-hiago-2026-09-29]]"]
---

# SPEC-142 — Balanceamento da economia de ouro

Pedido do dono (2026-10-07): "faça um plano para balancear a obtenção de ouro no jogo". Esta spec fecha o que
BAL-003 deixou em "observação" desde 2026-09-29: decidir entre subir custo, reduzir ganho ou criar usos, **com
medição**, o que nunca foi feito (o bot não registra moedas).

## Como o ouro funciona hoje (levantado no código)

**Duas bolsas.** `hero.gold` (moedas da run: loja, ferreiro, curandeiro, Mesa de Aposta, pactos) e `stats.gold`
(acumulado bruto da run, nunca diminui). `Battle._add_gold` soma nas duas. Só `stats.gold` vira moeda do Quartel.

**Entradas da run** (`core/battle.gd`, `core/happenings.gd`), todas multiplicadas por `stage.coin_mult`
(1,0 · 1,35 · 1,4 · 1,8 · 2,2 · 2,7 · 3,2 · 4,0 · 5,0 da fase 1 à 9):

| Fonte | Valor base | Onde |
|---|---|---|
| Abate comum | 22 % + 5 % × `gold_pct` de largar `round(coin_mult × (1 + gold_pct))`, mínimo 1 (×5 em afixo avaro) | `battle.gd:1393` |
| Elite ou afixo | +12 | `battle.gd:1406` |
| Chefe | +60 | `battle.gd:1524` |
| Quebrável | 6 (65 % da tabela de loot × 30–90 % de chance) | `battle.gd:1451` |
| Eventos e acontecimentos | `reward.gold`, deus esgotado 40 | `happenings.gd:490, 538` |
| Venda de peça trocada | 8 a 32 por raridade, **sem** `coin_mult` | `battle.gd:2090`, `difficulty.json` |
| Bolsa de Moedas (oferta) | 40 | `battle.gd:2239, 2432` |

**Saídas da run:** loja `16 a 40 × coin_mult` por raridade, armas `(20 + 10·nv) × coin_mult`, ferreiro
`(25 + 15·nv) × coin_mult`, curandeiro `max(8, faltante × 0,5 × coin_mult)`, Mesa de Aposta (45 % de chance, aposta de
20 % / 50 % / 100 % do saldo), pactos.

**Para o Quartel:** `ganho = (stats.gold × multiplicador_de_descida + 60 × (1 + tier) por fase vencida) × taxa`, com taxa
0,5 na morte e 1,0 no resto. Multiplicador de descida 1,00 · 1,25 · 1,55 · 1,90, depois +0,35 por nível; **Marcas do
Abismo somam +10 % por ponto** (até +150 %, SPEC-141). Conquistas pagam moedas à parte (11 hoje).

**Sumidouro do Quartel** (`data/upgrades.json`): ~228 800 moedas no total (Força Bruta 57 500, Vitalidade 55 160, quatro
atributos 19 500 cada, Sangue Vivo 15 600, resto ~21 000).

## Achados que justificam a spec

| # | Achado | Efeito |
|---|---|---|
| F1 | `coin_mult` escala **entrada e preço** da run, então o poder de compra dentro da run é quase constante, mas o `stats.gold` bruto cresce ×5 até a fase 9. **O Quartel paga muito mais por uma run longa** que por duas curtas, sem que o custo dos aprimoramentos acompanhe. | Inflação no meta |
| F2 | `round(coin_mult × (1 + gold_pct))` faz o bônus de moedas **valer zero** abaixo de ~+50 % nas fases 1 e 2 (1,0 × 1,3 = 1; 1,35 × 1,1 = 1) e sobe em degraus nas demais. Ganância (+10 % por nível), Anel de Prata, Carisma e Aura Amarela são quase inertes cedo. A parte `gold_pct × 5 %` de chance soma 0,5 ponto por +10 %. | Bônus injusto e ilegível |
| F3 | A venda de peças soma em `stats.gold` (vira moeda do Quartel) e não escala com `coin_mult`; já a Mesa de Aposta foi deliberadamente isolada (comentário em `battle.gd:2383`). | Fonte inconsistente |
| F4 | Marcas do Abismo (+até 150 %) e descida (até ×1,9 e além) **se multiplicam** com `gold_pct`, `coin_mult` e Ganância. O teto da run nunca foi medido. | Risco de explosão no veterano |
| F5 | Dados antigos: ~30 000 moedas (T01) e +23 354 numa vitória (T02), ambos de 2026-09-29, **antes** de SPEC-088 (sumidouros), fases de 5 min, `kill_mult` 0,75 e SPEC-122. **Não existe medição atual.** | Baseline ausente |
| F6 | `tools/bot.gd` não registra moedas; `stats.gold` não separa a fonte. | Não mede |

## Decisões do dono (BLOQUEANTES até responder)

| # | Pergunta | Recomendação |
|---|---|---|
| D1 | Escopo: moedas do Quartel, da run, ou as duas? | **As duas, Quartel primeiro** (a evidência de playtest é toda do Quartel; a economia da run entra com a mesma medição). |
| D2 | Meta de ritmo do Quartel | **Aposta de partida (confirmar ou trocar):** 1ª compra relevante em 1–2 runs; ~20 vitórias completas para comprar tudo (hoje ~8 a 10 pelo dado antigo); run curta (morrer na fase 2) rende ~5 % de uma vitória. |
| D3 | Alavanca principal quando faltar ajuste | **Corrigir a escala (F1–F4) antes de mexer em custo ou ganho cru.** Subir custo só se sobrar. Novos sumidouros são outro card (MEC), fora desta spec. |

Critérios numéricos de aceite ficam **fixados em B-002** com a medição na mão; o PLAN-056 foi aceito sem critérios
numéricos e a lição vale aqui.

## Escopo

**Dentro:** telemetria de moedas por fonte; medição por herói/fase/perfil; correção do arredondamento de `gold_pct`;
decisão sobre venda e `coin_mult`; curva do multiplicador de descida e do bônus de chefe; custos de
`data/upgrades.json` e da run; testes e EVID.

**Fora:** novos sumidouros e conteúdo à venda (MEC-015 segue), conquistas, preços de arte/HQ, Marcas do Abismo além de
ler o bônus delas, cura (regra do dono: nenhuma cura é melhorada).

## Aceite (proposto; números fecham em B-002)

1. Existe linha de base: moedas por fonte, por fase e por herói, perfis novato e veterano, marcas 0 e máxima. EVID registrada.
2. `gold_pct` tem efeito proporcional e visível em qualquer fase (teste de unidade com `coin_mult` 1,0 e +10 %).
3. A razão "moeda do Quartel por vitória completa" cai dentro da faixa de D2 para o perfil veterano sem marcas.
4. Com marcas no máximo e descida profunda, o ganho por run fica abaixo de um teto numérico definido em B-002.
5. Uma run que morre cedo rende parte pequena e previsível; nenhuma fonte isolada passa de uma fração do total (a fixar).
6. Suíte inteira em zero falhas; smoke das nove fases; mudanças com antes e depois por alavanca.

## Riscos

- `core/battle.gd` e `tools/bot.gd` estão em edição por PLAN-074 e outras sessões: **mudar só os trechos de ouro e
  conferir `git diff` antes de gravar.**
- Reduzir ganho pode parecer retrocesso a quem já tem moedas no perfil. **Perfil existente não é tocado**; só ganhos futuros.
- O bot não é humano: números de ritmo são estimativa até um playtest.

## Atualização 2026-10-07 (B-001 feita, EVID-191)

- Decisões tomadas: rota "medir já, corrigir depois"; D1 = ambos, Quartel primeiro; D2 = ~20 vitórias; aprovação por plano. D3 segue como padrão recomendado (corrigir a escala antes de custo).
- **F7 (novo):** o Chicote Avarento (`gold_hit`, +1 por acerto, sem `coin_mult`, sem teto) chegou a 56–63 % da renda de uma fase. Entra em B-003 (S-008: escalar, limitar por golpe ou por segundo).
- Metas numéricas M1 a M6 propostas em EVID-191; aguardam confirmação (B-002/S-005). Aceite 3 a 5 desta spec fica fechado por elas.
- Limite do bot: sem vitória, baú, evento ou loja; absolutos subestimam o humano. S-003b (ouro no registro da run) proposta, depende de aprovação.

## B-002 fechada (2026-10-07)

Dono confirmou **M1 a M6 como propostas** (EVID-191): vitória até Feng-tu 9 000–13 000; run morta na fase 2 100–300; Marcas máx. + descida 3 ≤ 3× M1; nenhuma fonte > 40 % da renda de uma fase; `gold_pct` +10 % ⇒ +8–12 %; 1ª compra relevante em ≤ 2 runs. Elas passam a ser os aceites 3 a 5.
O registro da run dos playtests já leva `result.raw_gold` e `result.gold_src` (vem de `Battle.result()`, sem mudar `core/run_record.gd`; teste em `tests/test_run_record.gd`). **Pendente de checar com quem mantém o servidor** que ele aceita a chave nova dentro de `result`.

## B-003 feita (2026-10-07, EVID-193)

Seis alavancas, todas por parâmetro em `data/difficulty.json` (bloco `gold`): `gold_pct` proporcional (F2), venda escalada e só da run (F3), ouro no Quartel em valor-base (F1), teto de 0,15 moeda/s no Chicote (F7), teto 3,0 no multiplicador de recompensa (F4). Ganho médio no Quartel do bot: −55 % (veterano) e −52 % (novato). M3 e M5 verificadas por teste; M1 e M6 projetadas; M4 pede interpretação (abate é a fonte natural).
