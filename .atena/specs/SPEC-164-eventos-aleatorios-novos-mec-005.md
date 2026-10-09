---
id: "SPEC-164"
title: "Seis eventos aleatórios novos (MEC-005)"
status: "APROVADA por plano em 2026-10-09 (DEV-026, PLAN-091); conteúdo aprovado como está; em execução em branch isolada"
origin: planned
implementation_preceded_spec: false
request_classification: PLAN_DEVIATION
created: "2026-10-09"
relations: ["[[SPEC-087-fidelidade-e-eventos-de-risco]]", "[[SPEC-118-acontecimentos-exclusivos-por-fase]]", "[[SPEC-129-dinamismo-bencaos-divinas-e-eventos]]"]
cards: ["MEC-005"]
content_proposal: "vault/drafts/PROPOSTA-eventos-aleatorios-mec-005-2026-10-09.md (DRAFT, revisão 1)"
---

# SPEC-164 — Seis eventos aleatórios novos

Origem: MEC-005 (EVID-091 r10, EVID-106 IN-014; "enjoa depois do 3º ou 4º mapa", IN-052). Entrevista com o dono em 2026-10-09: **6 eventos genéricos, em todas as fases, cobrindo risco e recompensa, NPC e lore, emboscada e mudança da run**. O conteúdo está na [proposta](../vault/drafts/PROPOSTA-eventos-aleatorios-mec-005-2026-10-09.md); **nada vira código antes de o dono aprovar a proposta**.

## O que existe (lido em 2026-10-09)

- 11 tipos sorteados por fase em `data/stages.json` → `interactions` (baú, fonte, altar, ritual, loja, ferreiro, arcanista, curandeiro, ampulheta, doação, aposta); `Battle._spawn_random_interaction` sorteia por peso, a cada 80 a 115 s, máximo 3 vivos (`data/difficulty.json`).
- `Battle.interact()` abre cada tipo; `_open_shop_event` e `_open_risk_event` montam `offer` (linhas com `t`, `name`, `desc`, `price`, `locked`) e `choose()` resolve por `t`. Sempre há "Sair" sem custo (MEC-023). Doação e Aposta (SPEC-087) são o molde.
- Sem PNG, o overlay desenha um losango colorido com rótulo (caso do Arcanista, SPEC-149).
- Acontecimentos por fase (`data/stage_events.json`, SPEC-118) são outra camada e **não** mudam.

## Desenho

1. **Dados:** `data/random_events.json` descreve cada evento (id, tipo de interação, cor, rótulo, peso, opções com efeitos tipados: `max_hp_pct`, `damage_pct`, `hp_cost_pct`, `gold_cost_pct`, `grant_item`, `temp_mod`, `xp`, `ambush`, `world_mod`, `permanent_mod`). Pesos entram em `stages.json` apontando para o id.
2. **Motor:** `core/random_events.gd` (`RandomEvents`): `open(battle, kind)` devolve as linhas da oferta; `apply(battle, option)` aplica o efeito; contas puras e testadas (cap de 45% da vida máxima, piso de 20, vida atual proporcional, sorteio 60/40). O `Battle` só chama.
3. **Mundo:** `world_mod` (Pedra do Eclipse) é um campo do `Battle` com multiplicadores de velocidade e dano dos inimigos comuns e de XP e ouro, e um relógio de 90 s; chefes ficam de fora. Um chip na HUD mostra o eclipse.
4. **Arte provisória:** losango colorido com rótulo; ART registrada para as props e ícones.
5. **Bot:** o bot escolhe "Sair" em evento desconhecido (sem travar), como já faz com `item_offer`.

## Padrões (não bloqueiam)

| # | Decisão | Padrão |
|---|---|---|
| P1 | Lore do Contador de Histórias | Frases já aprovadas em `stage_story.json`; frases novas por fase em segunda rodada |
| P2 | Pesos | Total novo 4,3; ajusto no JSON se pesar |
| P3 | Aviso da emboscada | O texto avisa que pode ser emboscada |

## Verificação

Testes por evento (efeitos, caps, recusas, "Sair" sem custo, Eclipse não afeta chefe e não empilha, piso de vida), teste de dados (todo evento tem "Sair"; pesos existem em todas as fases), teste de integração (o sorteio entrega os novos tipos), prova por mutação por efeito, suíte, smoke, kit_test e uma rodada do bot por herói (45 sementes em 2 heróis) para ver que nada trava nem desequilibra de forma gritante. Números de balanceamento: só os da proposta aprovada. Jogabilidade e diversão: só o dono, no playtest.

## Fora do escopo

Arte final, sons, lore novo do Vault, mudança dos acontecimentos por fase, qualquer evento além dos seis.

## Portões

Conteúdo aprovado antes do código; commit só com aprovação explícita; push e exportação à parte; sem dependência nova; nada em `assets/`; mudanças de outras sessões preservadas.
