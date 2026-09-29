# SPEC-082 — Loja e ferreiro mostram todas as opções (MEC-023)

Status: **implementada (2026-09-29); validação em playtest.**

Origem: T03 nota 1 ("o usuário não sabe que não tem nada para melhorar", print
001 com o ferreiro mostrando só "Sair"), em
[[EVID-108-playtest-publico-t03-dna-2026-09-29]]. Antes, só entravam na lista as
opções que o herói podia pagar. Plano: [[PLAN-038-atualizacao-pos-playtests-t01-t02-t03-2026-09-29]].

## Decisão

O jogador vê **tudo o que o evento oferece**; o que ele não paga aparece
**esmaecido, sem efeito e com o que falta**, em vez de sumir.

## Escopo

1. Loja, ferreiro e curandeiro listam todas as opções com preço. Sem moedas
   suficientes: botão desativado e linha `(faltam N moedas)`.
2. Escolher uma linha travada **não compra e não fecha** a loja (`choose`).
3. Ferreiro sem nada forjável mostra **"Nada para melhorar"** com o motivo.
4. Curandeiro com vida cheia mostra **"Vida cheia"**.
5. "Sair" continua sempre disponível, sem custo.

## Implementação

- `Battle._shop_row`, `Battle._shop_info`, `Battle._open_shop_event` e o desvio
  `locked` em `Battle.choose` (`core/battle.gd`); `ui/hud.gd` desativa e
  esmaece linhas travadas.
- Testes em `tests/test_battle.gd`: item travado com "faltam", compra bloqueada
  sem fechar a loja, ferreiro vazio, curandeiro com vida cheia.
  Três testes antigos foram reescritos para a nova regra.

## Aceite

- Com 0 moedas, a loja mostra os itens travados e "Sair".
- O jogador nunca vê só "Sair" sem saber o motivo.

## Limites

- Não muda preços nem probabilidades de item.
