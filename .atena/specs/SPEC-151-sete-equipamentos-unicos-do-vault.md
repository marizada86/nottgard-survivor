---
id: "SPEC-151"
title: "Sete equipamentos únicos do Vault, com o Coração da Dominância (MEC-042)"
status: "EM EXECUCAO em 2026-10-08 (PLAN-081 B-005)"
origin: planned
implementation_preceded_spec: false
request_classification: PLAN_DEVIATION
created: "2026-10-08"
relations: ["[[SPEC-148-lancamento-da-v0-4-0]]", "[[SPEC-150-tres-armas-e-magias-novas-do-nottcard]]", "[[PROPOSTA-conteudo-novo-v0-4-0-armas-magias-e-equipamentos-2026-10-08]]"]
cards: ["MEC-042"]
---

# SPEC-151 — Sete equipamentos únicos (MEC-042)

Aprovado pelo dono em 2026-10-08: E1 a E6 da proposta como recomendado, **mais o E7 Coração da Dominância**, pedido de Manzi (a SPEC-148 previa 6; passam a 7, uma mudança dentro do plano, `IN_PLAN`, pedida pelo dono no portão de conteúdo). Cada um entra em `data/items.json` (`uniques`) com um commit e um teste. Risco: **baixo** (dados); o E7 acrescenta uma arma concedida.

## Itens

| Id | Nome | Slot / tier | Bônus | Maldição | Fonte |
|---|---|---|---|---|---|
| `cajado_familia_infernum` | Cajado da Família Infernum | arma, 3 | INT +2, CAM +1, área +10% | — | Vault, S21 |
| `wave_of_terror` | Wave of Terror | arma, 5 | FOR +1, dano +15% | −8 PV máximos (Maldição da Ambição Sombria, só numérica) | Vault, S19/20 |
| `colar_visao_verdadeira` | Colar de visão verdadeira do Santuário | amuleto, 2 | precisão +2, crítico +3% | — (o Vault diz que a maldição não foi esclarecida) | Vault, Arco 01 |
| `detector_arcano` | Detector Arcano | anel, 1 | coleta +1,5, sorte +2 | — | Vault, S21 |
| `dispositivo_antimagia_gilly` | Dispositivo Antimagia de Gilly | armadura, 4 | CAM +3 | INT −1 | Vault (Gilly, escolta de Bella) |
| `dispositivo_das_docas` | Dispositivo das Docas | amuleto, 1 | redução de dano +1, CA +1 | — | Vault, S21 |
| `coracao_da_dominancia` | **Coração da Dominância** | arma, 5 | precisão +2 (bônus de ataque de magia), CAM +1 (Vontade Inquebrável), CAR +1; **concede a arma Domínio da Vontade** | — | texto do dono (2026-10-08), informações do Vault; pedido de Manzi |

### E7 — Coração da Dominância (recebido por Sylas da Rainha das Súcubos)

Texto-base (dono): cajado de osso branco perolado envolto por filamentos roxos e carmesim, com um coração cristalino que pulsa; troféu forjado quando o portador resistiu aos encantos da Rainha das Súcubos e conquistou seu respeito. Propriedades originais: +2 em ataques de magia e +1 na CD (→ `hit` +2 e CAR +1); Vontade Inquebrável, repetir teste de resistência mental (→ `cam` +1); Domínio da Vontade, conjurar Sugestão em quem falha, e a vítima acredita que a ideia foi dela (→ arma concedida).

Arma concedida `dominio_da_vontade` (`src: "Item: Coração da Dominância"`): `bolt` / `magico` / `carisma`, `1d6`, recarga 4,5 s, alcance 9, velocidade 12, `stun` 3,0 ("o alvo perde os ataques e obedece"), `levels: []`. Não é melhorável (concedida) e conta como magia pela regra da SPEC-149. Sintonia e cargas do original não existem no jogo e ficam de fora.

Referência visual do dono: `.atena/generated/item-refs/coracao-da-dominancia-referencia.webp` (cajado de osso, coração rosa cristalino, filamentos roxos). Não entra no jogo sem aprovação visual (ART-042).

## Provisórios

Sem PNG em `assets/icons/items/` para os sete: o ícone passa a cair no ícone da base do slot (cajado, anel simples, amuleto simples, couro). O código do fallback é um commit à parte (arte). ART-042 registra os ícones próprios.

## Critérios de aceite

1. Os sete existem em `uniques` com `slot`, `tier`, `mods` e nota; `weapon` válido nos que concedem arma; todo `mods` usa chaves conhecidas de `MOD_LABELS`.
2. Equipar cada um aplica os bônus (precisão, CAM, FOR etc.) e a maldição quando houver.
3. O E7 concede `dominio_da_vontade` ao equipar e a retira ao trocar; a arma atordoa um alvo comum por 3,0 s (não chefes).
4. Cada um pode cair em baú ou loja a partir do seu `tier` (teste de sorteio), e o ferreiro não o melhora (únicos, regra existente).
5. Ícone: o item sem PNG usa o da base do slot.
6. Suíte, smoke e `audit_projeto` sem falhas novas; `tools/bal_itens.gd` antes → depois no EVID.

## Lacunas

| Id | Lacuna | Classe | Tratamento |
|---|---|---|---|
| G1 | Números de partida | NON_BLOCKING | Medidos pelo bot em B-007; só JSON |
| G2 | Página própria do Coração da Dominância no Vault | NON_BLOCKING | Só existe na importação do Discord; a fonte é o texto do dono |
