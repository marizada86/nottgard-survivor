# SPEC-087 — Fidelidade do item e eventos de risco (MEC-021 e MEC-005)

Status: **implementada (2026-09-29); validação em playtest.**

Origens: T02 nota 7 (MEC-021, leitura do dono: "recusar a troca 3 vezes sobe o nível"), T01 S3-N1 e EVID-091
resposta 10 (MEC-005, eventos de risco e recompensa: doar item por bênção). Plano:
[[PLAN-038-atualizacao-pos-playtests-t01-t02-t03-2026-09-29]].

## MEC-021 — Fidelidade

Na oferta "equipar ou manter", escolher **manter** o item atual **3 vezes seguidas no mesmo slot** sobe o nível
dele (só itens com nível, isto é, com `base` e abaixo do máximo). Equipar um item novo zera a sequência.
A opção "manter" mostra `Fidelidade n/3`; cada recusa avisa o progresso. `Battle._register_keep`, `keep_streak`.

## MEC-005 — Dois eventos novos (E, todas as fases)

| Evento | Regra |
|---|---|
| **Altar da Doação** (peso 0,7) | Lista os equipamentos vestidos; doar um o remove (e a arma que ele concedia) e abre a **escolha de bênção** do altar (3 opções). Sem equipamento ou sem bênção restante: "Nada a trocar" |
| **Mesa de Aposta** (peso 0,8) | Três apostas (20%, 50% e 100% das moedas, mínimo 20): **45% dobra, 55% perde**. O ganho **não** entra no ouro histórico da run (não infla a recompensa). Sem moedas, a aposta fica travada |

Dados em `data/difficulty.json` (`risk_events`). Reaproveita a tela de loja (`shop`, linhas travadas de
[[SPEC-082-loja-e-ferreiro-mostram-todas-as-opcoes]]). Arte provisória (quadrado colorido com rótulo):
**ART-019** (doação) e **ART-020** (aposta).

## Testes

`tests/test_battle.gd`: 3 recusas sobem para Nv 2 e o progresso aparece; equipar zera; doar remove o item e abre a
bênção; aposta termina em 120 ou 80 e não mexe no ouro histórico; sem moedas fica travada.

## Limites

- A Mesa de Aposta é um sumidouro de moedas de run, não do meta.
- A bênção da doação não é proporcional à raridade doada (sempre 3 opções).
