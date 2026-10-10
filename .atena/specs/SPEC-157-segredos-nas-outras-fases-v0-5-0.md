---
id: "SPEC-157"
title: "Segredos nas outras fases e lançamento da v0.5.0 (Major)"
status: "EXECUTADA em 2026-10-09 (PLAN-083, EVID-214 a EVID-218) e publicada; não houve 0.5.0: tudo virou a 0.4.0 refeita"
origin: planned
implementation_preceded_spec: false
request_classification: PLAN_DEVIATION
created: "2026-10-09"
relations: ["[[SPEC-152-fatia-piloto-de-segredos-ecos-e-reliquias]]", "[[SPEC-119-segredos-ecos-e-mapa-maior]]", "[[SPEC-148-lancamento-da-v0-4-0]]", "[[PROPOSTA-segredos-nas-outras-fases-v0-5-0-2026-10-09]]"]
cards: ["MEC-039", "MEC-012"]
---

# SPEC-157 — Segredos nas outras fases (v0.5.0)

Pedido do dono (2026-10-09, "siga para o item 8"). Reaproveita o que a 0.4.0 entregou em Shedaklah, Molor e Durao ([SPEC-152](SPEC-152-fatia-piloto-de-segredos-ecos-e-reliquias.md)): `data/secrets.json`, `Battle._place_secrets`, Ecos, câmara selada e relíquia, aba do Diário, conquistas "Ecos de <fase>", `tools/enlarge_stage_maps.gd`, `tools/bake_ground.gd` e `SceneryLayout` com `design_scale`. Conteúdo e fontes: [proposta](../vault/drafts/PROPOSTA-segredos-nas-outras-fases-v0-5-0-2026-10-09.md). Pela regra de tipos de [RELEASES](../backlog/RELEASES.md), `0.4.x → 0.5.0` é **Major** (changelog em PDF, guia, questionário 008).

## Escopo recomendado

| Fase | Mapa | Segredos | Relíquia | Chave |
|---|---|---|---|---|
| Dagruve | 60×60 | 3 POIs, 4 Ecos | Broche Celestial | `ritual_da_nevoa` |
| Docas | 60×60 | 3 POIs, 4 Ecos | Colar dos Tentáculos | `cais_atacado` |
| Feng-tu | 60 → 84×84 | 3 POIs, 4 Ecos | Sopro de Estrela | `escolta_do_peregrino` |
| Shendilavri | 60 → 84×84 | 3 POIs, 4 Ecos | Cajado dos Desejos Sussurrantes | `vitimas_drenadas` (passa a fixo) |
| Goranthis | 60 → 84×84 | 3 POIs, 4 Ecos | **Espelho das Almas Desejantes (novo)** | `do_trono_ao_lodo` |
| Pilares | 60×60 | fora da 0.5.0 | — | — |

## O que muda no código

1. **Dados:** `data/secrets.json` ganha as cinco fases; `_regras` e os testes valem para todas. Cada fase fixa seu acontecimento-chave com `reward.unlock_chamber`.
2. **Dagruve e Docas (60×60):** POIs e Ecos usam as posições de `data/scenery.json` como referência (destrutíveis, interativos e armadilhas já ocupam parte do mapa); sondagem de chão como na 0.4.0.
3. **Feng-tu, Shendilavri e Goranthis (84×84):** o mesmo caminho da SPEC-152: `enlarge_stage_maps.gd -- 60 84 <fase>`, `bake_ground.gd` com lado 84 (chão `*_ground_baked_v2.png`), escala de desenho, teste de mapa e medição de FPS.
4. **Espelho das Almas Desejantes:** novo único em `data/items.json` (amuleto, tier 5, carisma e sorte) com `icon_like` provisório; efeito opcional `free_reroll_per_stage` (uma rerrolagem grátis por fase) só se o dono aprovar.
5. **Covil:** elites por fase na proposta; `Enemy.lair` e o baú de chefe já existem.
6. **Acontecimento opcional que vira fixo** (Shendilavri, `vitimas_drenadas`) e eventuais ajustes de tempo (`at`) para o mapa maior.
7. **Conquistas** `ecos_<fase>` para as cinco fases; o Diário já lê `secrets.json` por fase.

## Não objetivos

Pilares; a cadeia da runa de Vhaerith (recomendada para a 0.6.0); exclusividade das relíquias (cópia garantida, como na 0.4.0); arte nova (Eco, câmara e ícones seguem provisórios, ART-043); qualquer segredo do mestre.

## Gates e riscos

- **Portão de conteúdo (independe do nível de aprovação):** os 20 Ecos, as relíquias, o Espelho e a lista de ganchos de Dagruve e Docas voltam ao dono antes do código. Dagruve e Docas só recebem texto depois da leitura da página do Vault e da conferência da etiqueta `conteudo-nao-revelado`.
- **Depende do relato da 0.4.0 (recomendado):** se os testers acharem os mapas grandes vazios ou os Ecos pouco úteis, o plano ajusta antes de ampliar mais três mapas.
- **Peso:** três chãos novos de 7 a 8 MB cada (~22 MB); o desempenho em 84×84 foi medido em janela na 0.4.0 (59,6 a 59,9 FPS).
- **Mistura de sessões** e **push publica o `latest`**: as regras de sempre (commit e push só com aprovação).

## Critérios de aceite

1. As cinco fases têm 3 POIs, 4 Ecos, relíquia, câmara e conquista, validados por `test_secrets` (posições, termos proibidos, fontes, chaves, relíquias).
2. Feng-tu, Shendilavri e Goranthis em 84×84 sem perda visível de desempenho; as outras fases seguem como estão.
3. O Espelho existe, equipa e (se aprovado) dá a rerrolagem grátis por fase, com teste.
4. Bot por herói sem regressão (EVID-208 como linha de base).
5. Suíte, smoke das nove fases, `kit_test` e `audit_projeto` sem falhas novas.
6. Versão 0.5.0, RELEASES, changelog 0.4.0 → 0.5.0 (PDF), guia e questionário 008 gerados; push e aviso aos testers só com aprovação.

## Lacunas

| Id | Lacuna | Classe | Tratamento |
|---|---|---|---|
| G1 | Textos dos Ecos de Dagruve e Docas | NON_BLOCKING | Escritos depois da leitura do Vault, no portão de conteúdo |
| G2 | Espelho: com ou sem a rerrolagem grátis | NON_BLOCKING | Decisão do dono; padrão: sem o efeito |
| G3 | Esperar o relato da 0.4.0 antes de executar | NON_BLOCKING | Recomendado esperar; o dono decide |

Zero lacunas `BLOCKING`.
