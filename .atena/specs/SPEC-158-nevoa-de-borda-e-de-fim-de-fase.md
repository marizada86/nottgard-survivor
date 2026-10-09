---
id: "SPEC-158"
title: "Névoa punitiva: borda do mapa e Maré de fim de fase em todos os mapas (MEC-059, MEC-060)"
status: "APROVADA por plano em 2026-10-09 (DEV-019, PLAN-084); padroes P1 a P5 confirmados; em execucao"
origin: planned
implementation_preceded_spec: false
request_classification: PLAN_DEVIATION
created: "2026-10-09"
relations: ["[[SPEC-120]]", "[[SPEC-157-segredos-nas-outras-fases-v0-5-0]]"]
cards: ["MEC-059", "MEC-060"]
---

# SPEC-158 — Névoa punitiva (borda e fim de fase)

Pedido do dono (2026-10-09): jogadores estão se escondendo no canto do mapa. Punir com a névoa: (1) perto das bordas, o mesmo dano por segundo da névoa que avança em Dagruve; (2) névoa no fim de todas as fases, para apressar a troca de mapa, menos na última (Pilares). Risco: **médio** (mexe em dano e ritmo da run inteira), sem arte nova.

## O que existe (lido em 2026-10-09)

- A **Maré de Névoa** só existe após o chefe de Dagruve (`Battle._start_postboss_fog`, `core/battle.gd:1722`), lida de `data/boss_presentations.json` → `fog`: carência 8 s, aviso 2 s, avanço 28 s, dano de **2% a 6% da vida máxima por segundo** em 20 s, dano verdadeiro (`_hurt_hero(..., "mare_nevoa", true)`).
- Ela é chamada em `_on_boss_dead` só quando a fase tem `next`. **Pilares (`next: ""`) já fica de fora.** Os outros chefes não têm bloco `fog` (Docas tem entrada sem `fog`), então só Dagruve a recebe hoje.
- A fase dura `duration` (300 s em Dagruve); aos 300 s nasce o chefe, e a fase só termina ao matar o chefe. Nada pune a borda em nenhum momento.
- O visual atual (`ui/run.gd:_update_fog_overlay`) é um **vinheta nas bordas da tela**, não no mundo: não mostra onde fica a borda do mapa.
- O herói pode chegar a 0,4 tile da borda (`Hero.can_stand`).

## Regras

### MEC-059 — Borda punitiva (todas as 9 fases, a run inteira)

1. **Zona:** faixa de `edge_band_tiles` (padrão **3**) junto às quatro bordas do mapa (`map_size` da cena; vale para 60x60 e 84x84).
2. **Dano:** vida máxima × `dps_pct` × dt, **dano verdadeiro** (ignora CA, esquiva, barreira e invulnerabilidade, como a Maré), origem `borda_nevoa`.
3. **Valor:** o mesmo da Maré de Dagruve, lido de `data/fog.json`, sobe de `start_dps_pct` (2%) a `max_dps_pct` (6%) conforme a exposição contínua (`ramp_seconds` = 20). Fora da faixa a exposição cai ao dobro da velocidade com que sobe (sair e voltar não reinicia o castigo).
4. **Sem soma dupla:** se a Maré de fim de fase também estiver ferindo, vale o **maior** dos dois valores, não a soma.
5. **Aviso:** um toast na primeira entrada na faixa em cada fase ("A névoa queima junto às bordas: afaste-se") e a faixa fica visível no mundo (`ui/edge_fog.gd`: gradiente de névoa em polígonos, sem textura nem arte nova; forte na borda, leve no limite interno), mais forte quanto mais o herói se aproxima.
6. **Fora da punição:** herói morto, run pausada (ofertas, introdução do chefe, modais). Pilares **entra** (é onde o canto mais compensa).
7. **Nada necessário na faixa:** baús, altares, portal, POIs e câmaras de segredo não podem ficar dentro da faixa (teste de todas as fases). O portal que nasce na morte do chefe é empurrado para fora da faixa mais 1 tile.

### MEC-060 — Maré de Névoa em todas as fases com próximo mapa

1. A Maré passa a nascer após **qualquer** chefe cuja fase tem `next` (todas menos Pilares), com o padrão de Dagruve em `data/fog.json` (`postboss`); `boss_presentations.json` continua podendo sobrescrever por chefe.
2. **Velocidade da frente constante:** `advance_seconds` escala com o lado do mapa para a frente andar na mesma velocidade que em Dagruve (60x60 → 28 s; 84x84 → 39 s). Dano e carência não mudam.
3. Mantém: toast de aviso, portal (E/oeste) e extração (X/norte) abertos durante a Maré.
4. **Pilares:** sem Maré de fim de fase (continua a vitória final e o ciclo do chefe); só a borda.

### Dados

`data/fog.json` (novo, só JSON, sem dependência): `edge {edge_band_tiles, start_dps_pct, max_dps_pct, ramp_seconds, decay_mult}` e `postboss {grace_seconds, warning_seconds, advance_seconds_per_60_tiles, start_dps_pct, max_dps_pct, ramp_seconds}`. Tudo ajustável sem mexer em código.

## Padrões recomendados (RESOLVABLE; o dono confirma ou muda na aprovação)

| ID | Pergunta | Padrão recomendado |
|----|----------|--------------------|
| P1 | "Mesmo dano": 2%, 6% ou subindo? | Sobe de 2% a 6% com a exposição contínua |
| P2 | Largura da faixa | 3 tiles fixos |
| P3 | O "fim da fase" é depois do chefe? | Sim: após o chefe, como em Dagruve (a carência de 8 s deixa pegar o portal) |
| P4 | A borda vale em Pilares e durante o chefe? | Sim, em todas as fases e a run inteira |
| P5 | Faixa visível o tempo todo? | Só na proximidade (cresce quando o herói chega a 6 tiles da borda) |

## Não objetivos

Mudar o dano ou o ritmo da Maré de Dagruve; arte nova; punir inimigos; alterar o relógio da fase; Quartel e Marcas do Abismo (nenhuma marca muda).

## Critérios de aceite

1. Herói parado na faixa perde vida a 2% e chega a 6% em 20 s; parado fora da faixa, nada.
2. Dano ignora CA, esquiva, barreira e invulnerabilidade; Maré + borda juntas não somam.
3. Sair e voltar à faixa não zera a exposição; ficar fora a zera.
4. Todos os chefes de fases com `next` disparam a Maré (8 fases); o de Pilares, não.
5. A frente da Maré anda à mesma velocidade (tiles/s) em 60x60 e em 84x84.
6. Nenhum baú, altar, POI, câmara ou portal fica na faixa em nenhuma das 9 fases (teste de varredura).
7. O aviso aparece uma vez por fase; a faixa fica visível no mundo (captura de tela).
8. Mutação: sem a checagem da faixa (ou da exposição), o teste falha.
9. Suíte, smoke das 9 fases, `kit_test` e `backlog_check` sem falhas novas; bot por herói medido antes e depois (hoje o bot não acampa na borda; registrar se o resultado muda).
10. **Não verificável por modelo:** se a punição inibe o canto e se a frente da Maré dá tempo de chegar ao portal. Fica como pendência de playtest.

## Lacunas

Nenhuma `BLOCKING`. P1 a P5 são `RESOLVABLE` com padrão recomendado. `DEFERRED`: balancear a Maré por fase (grace e dano por tier) depois do playtest.
