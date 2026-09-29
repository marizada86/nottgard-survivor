# SPEC-094 — Ofertas em cartão resumido (MEC-027)

Status: **implementada (2026-09-29); validação em playtest.**

Origem: pedido do dono (2026-09-29) após ver a tela "Item encontrado — equipar ou
manter?" com atributos repetidos. Plano: [[PLAN-043-ofertas-resumidas-com-detalhes-ao-passar-o-mouse-2026-09-29]].
Amplia [[SPEC-081-comparacao-de-equipamento]] e [[SPEC-082-loja-e-ferreiro-mostram-todas-as-opcoes]].

## Decisão

O cartão mostra **só o principal**; detalhes e comparação ficam no hover ou
segurando Shift. Sem mudança de regra, número ou economia.

## Escopo

1. **Cartão** (`ui/offer_card.gd`): ícone, nome na cor da raridade, linha de
   destaque (até 3 atributos, por `Items.STAT_WEIGHT`), selo à direita
   (`▲ n ▼ m`, `Slot livre`, `Nv a → b`) e preço ou valor de venda.
2. **Hover:** tooltip customizado com tabela novo × atual × diferença (verde/vermelho)
   e rodapé (venda, saldo, Fidelidade). Atraso do tooltip: 0,15 s (`project.godot`).
3. **Shift (segurar):** abre o detalhe de todas as opções dentro do painel.
4. **Telas cobertas:** item achado, loja, ferreiro, curandeiro, subida de nível
   (arma, passiva, nova, evolução, sinergia), altar (bênção **e** maldição sempre
   visíveis), doação e aposta. Opção travada mostra `faltam N`.
5. **Compatibilidade:** `desc` e `tooltip` antigos preservados nas ofertas.

## Correção incluída

`Items.diff_mods` ignorava diferenças menores que 0,05, o que descartava
percentuais pequenos (+4% de recarga aparecia como "sem diferença"). Agora o
limiar é por tipo (`Items.mod_epsilon`: 0,005 para percentuais, 0,05 para os demais).
O texto `Contra o atual` passa a mostrar essas diferenças.

## Implementação

- `core/items.gd`: `brief_text`, `verdict`, `compare_table`, `ranked_keys`, `mod_epsilon`, `MOD_LABELS`, `STAT_WEIGHT`.
- `core/battle.gd`: campos `brief`, `badge`, `price_text`, `detail` nas ofertas; `_decorate_offer`, `_swap_detail`, `_shop_item_detail`, `_forge_detail`, `_boon_brief`.
- `ui/offer_card.gd` (novo) e `ui/hud.gd` (`show_offer`, modo Shift em `_process`).
- `tools/shot.gd`: flags `altar`, `donate`, `bet`, `shift` para as capturas.
- Testes: `tests/test_battle.gd` (destaques, veredito, tabela, badge, percentuais).

## Aceite

- Um jogador novo diz, sem ler texto longo, se o item novo é melhor ou pior; o hover confirma o porquê.
- A maldição do altar continua visível sem interação.
- Nenhuma mudança em `hero.recalc()` ou nos valores de itens.

## Limites

- Hover só com mouse real; sem mouse, Shift. Toque não é escopo.
- Destaques usam peso fixo por atributo, não por herói.
- Arma concedida por item ainda não aparece na tabela de comparação.
