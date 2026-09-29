# EVID-094 — Execução da SPEC-064 (loja, ferreiro, curandeiro)

Data: 2026-09-28
SPEC: [[SPEC-064-eventos-economicos-loja-ferreiro-curandeiro]]
PLAN: [[PLAN-032-proxima-atualizacao-pos-playtest-2026-09-28]] (último item da ordem combinada)

## Alterações realizadas

- `data/stages.json`: as 9 fases jogáveis ganharam pesos `"loja": 1,
  "ferreiro": 1, "curandeiro": 1` em `interactions`, mais raros que baú.
- `core/battle.gd`:
  - `_open_shop_event(kind)` novo: monta a oferta por subtipo, sempre com
    "Sair" grátis ao final; opções cujo preço o jogador não pode pagar
    simplesmente não aparecem (em vez de aparecer desabilitadas).
    - `loja`: 2 itens via `Items.roll()` (mesmo gerador dos baús), preço por
      raridade.
    - `ferreiro`: até 2 armas equipadas elegíveis (`level < max_level()`,
      excluindo armas concedidas por item) para subir 1 nível, preço
      crescente pelo nível atual.
    - `curandeiro`: cura completa por preço proporcional ao PV faltante; sem
      PV faltando, não oferece nada além de "Sair".
  - `interact()` (tecla `E`) estendido para os três novos tipos, no mesmo
    grupo de `altar`/`ritual`/`portal`.
  - `choose()` ganhou um ramo dedicado para `state == "shop"`: deduz
    `hero.gold` (nunca `stats.gold` — a recompensa final continua calculada
    do histórico, intacta) e aplica o efeito; comprar um item da loja chama
    `give_item()` diretamente, então se o slot já estiver ocupado, a escolha
    de equipar/vender da SPEC-060 assume o controle normalmente (o código
    detecta `state == "item_offer"` e não interfere).
- `ui/hud.gd`: `show_offer()` reconhece os três `offer_kind` novos (título
  próprio, ícone por tipo de oferta, cor de destaque); prompt de interação
  (`[E] ...`) ganhou as três entradas novas.
- `ui/run.gd`: estado `"shop"` roteado pelo mesmo caminho de
  `levelup`/`altar`/`item_offer` (teclas numeradas, painel de oferta,
  refresh de estado).
- `tests/test_battle.gd`: bloco novo (9e) cobrindo compra bem-sucedida de
  cada subtipo (loja, ferreiro, curandeiro), "Sair" sem custo, e ausência da
  opção quando a moeda é insuficiente.

Nenhuma mudança em `stats.gold`, no cálculo de `result()`, no sistema de
armas/evolução além do incremento de nível já suportado, ou em arte/animação
de ativação (o jogo já ignora graciosamente tipos de interação sem folha de
animação mapeada).

## Verificações executadas

| Comando | Resultado |
|---|---|
| `Godot_v4.7.2-stable_win64.exe --headless --path . -s tests/run_all.gd` | `testes: 0 falha(s)` |
| `Godot_v4.7.2-stable_win64.exe --headless --path . res://tools/smoke.tscn` | `smoke: ok` nas 8 fases |

Suíte e smoke passaram já na primeira execução desta vez.

## Exceção de validação

Sem checagem manual interativa (ver os três eventos aparecerem numa run
real, interagir com `E`, comprar e conferir visualmente o resultado) nesta
sessão — mesma limitação já registrada nas evidências anteriores desta leva
(EVID-089/090/092/093). Preços, quantidade de itens na loja e a força da
cura do curandeiro são estimativas de execução, explicitamente deixadas
revisáveis pela spec.
