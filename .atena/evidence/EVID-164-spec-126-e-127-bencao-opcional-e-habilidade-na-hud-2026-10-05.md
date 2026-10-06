---
id: "EVID-164"
title: "SPEC-126 (bênção opcional) e SPEC-127 (habilidade na HUD e na ficha C)"
created: "2026-10-05"
relations: ["[[SPEC-126-bencao-opcional-no-altar]]", "[[SPEC-127-habilidade-ativa-na-hud-e-na-ficha]]", "[[EVID-163-relato-t04-manzi-sylas-2026-10-05]]"]
cards: ["MEC-043", "MEC-044", "MEC-046"]
---

# EVID-164

## SPEC-126 (commit `048832e`)
- `Battle._open_altar(allow_skip := true)` acrescenta a oferta `boon_skip` ("Recusar a bênção") por último; escolher não adiciona bênção, conta `stats.boons_declined` e mostra o aviso "Você recusou a bênção."; o altar fica consumido, sem prêmio (decisão do dono).
- **Achado na implementação:** o altar da doação (MEC-005) também chama `_open_altar` depois de gastar o item; lá a recusa **não** é oferecida (`allow_skip := false`), para o jogador não perder o item sem bênção. A spec foi escrita sem esse caso.
- HUD: título "Altar — escolha uma bênção (e sua maldição) ou recuse"; a recusa é um botão cinza simples (`ui/hud.gd`).
- Verificação de interface (headless, temporária, removida): 3 cartões de bênção + botão "4. Recusar a bênção"; o clique emite o índice 3. **Não vi a tela real do altar**; só a estrutura dos nós.
- Teste novo `tests/test_boon_skip.gd`.

## SPEC-127
- Novo `ui/ability_slot.gd` (`AbilitySlot`, 72 px): ícone de `assets/icons/abilities/` (os 10 já existiam), escurecido em recarga, varredura horária proporcional a `active_cd / active_cd_max`, segundos no centro (1 casa abaixo de 10 s, inteiro acima), borda dourada quando pronta, azul com a guarda ativa, brilho de 0,4 s ao ficar pronta, "Q/RMB" no canto, tooltip com nome e descrição, inicial da habilidade se faltar o ícone.
- `core/battle.gd`: `active_cd_max` (recarga efetiva da última vez usada) e `active_cooldown_effective()` (mesma conta de `use_active`).
- `ui/hud.gd`: o slot fica no centro inferior (acima do aviso de interação); some quando abre ficha, oferta, pausa, resultado ou reviver; o texto antigo e o ícone de 34 px da pilha de estatísticas ficam ocultos.
- Ficha C: seção "★ Habilidade [Q/RMB]: <nome>" no topo, com descrição, recarga efetiva (e a base quando difere) e faixa de dano para as habilidades com dado.
- Testes novos `tests/test_ability_hud.gd` (10 heróis têm habilidade com id, nome, recarga, descrição e ícone; formato do tempo; HUD de 3 heróis com slot, tooltip e seção na ficha).
- Capturas reais (janela, 1280×720; Sylas, Durvall e Brook; pronta, em recarga e ficha C): [.atena/generated/spec-127/](../generated/spec-127/). Ferramenta: `tools/capture_ability_hud.tscn`.
- **Limite:** a janela de 1920×1080 também renderizou a 1280×720 (esticamento do projeto), então só há uma resolução de verdade nas capturas.
- **Limite:** o ícone do Sylas é escuro e fica com pouco contraste sobre o slot; se o dono achar fraco, é o caso do ART-034.

## Verificação
`tests/run_all.gd` 0 falhas; `tools/audit_projeto.gd` 0 erros (7 avisos já conhecidos); `res://tools/smoke.tscn` ok.

## Fora do que foi pedido
Nada de balanceamento. Uma alteração do dono em `HIT_INVULN` (0,4 para 0,1) já estava no `core/battle.gd` sem commit; foi preservada e **não** entrou nesses commits.
