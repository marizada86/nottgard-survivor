---
id: SPEC-127
title: Habilidade ativa (Q/RMB) com recarga visível na HUD e descrição na ficha C
status: implemented-uncommitted
origin: playtest-t04-manzi-2026-10-05
cards: MEC-043, MEC-044
evidence: EVID-163
risk: médio
plan: PLAN-061 (por plano)
---

# SPEC-127

## Pedido
Manzi (T04): (1) a habilidade Q/RMB deveria ter ícone e indicação de recarga; (2) a tecla C deveria mostrar o que a habilidade faz. Dono: juntar MEC-043 e MEC-044.

## Estado atual (lido no código)
- HUD: `ActiveLabel` com `[Q/RMB/RB] <nome> — <N>s` (`core/battle.gd:363`), cinza durante a recarga (`ui/hud.gd:133`), e `ActiveIcon` de 34 px na pilha de estatísticas (`ui/hud.tscn`); arte em `assets/icons/abilities/<id>.png`, existente para os 10 heróis.
- Ficha C (`Hud.show_items_panel`, `ui/hud.gd:435`): sem seção de habilidade; `data/abilities.json` já tem `desc`, `cooldown`, `kind` e dados por herói.
- Recarga efetiva: `active_cd = max(3, cooldown × (1 − cd_pct × 0,5))` (`core/battle.gd:474`).

## Decisões do dono (2026-10-05)
- Recarga: **ícone grande com varredura e segundos** (sem gerar arte nova; usa os ícones existentes). ART-034 fica dispensado.
- Aprovação por plano.

## Escopo
**A. Slot da habilidade na HUD (MEC-043)**
1. Slot de ~56 px com o ícone da habilidade do herói, tecla `Q`/`RMB` em um canto (e o botão do controle quando houver), no canto inferior da HUD de combate (posição final a validar com captura de tela).
2. Em recarga: ícone escurecido com varredura radial (sentido horário) proporcional a `active_cd / recarga efetiva` e **número de segundos** no centro (1 casa abaixo de 10 s, inteiro acima).
3. Pronta: sem sombra, borda destacada e um brilho curto ao ficar pronta (some em ≤ 0,4 s).
4. O texto longo `[Q/RMB/RB] nome — Ns` deixa de ser a indicação principal; o nome da habilidade vira dica ao passar o mouse ou linha pequena sob o slot.
5. Sem ícone para a habilidade (`ResourceLoader.exists` falso): usa quadrado neutro com a inicial, sem erro.

**B. Descrição na ficha C (MEC-044)**
6. `show_items_panel` ganha, no topo da lista, a seção **"Habilidade [Q/RMB]: <nome>"** com ícone pequeno, `desc` de `abilities.json`, recarga efetiva atual em segundos e o dano ou efeito principal quando o tipo tiver (reaproveitar `weapon_damage_text` ou equivalente; se não existir para habilidades, mostrar só o texto e a recarga).

## Fora do escopo
Reorganização geral da ficha C em categorias e novo layout (MEC-045/ART-035), nova arte de ícones (ART-034), mudança de números das habilidades, mudança de teclas.

## Critérios de aceite
- Em combate, para cada um dos 10 heróis: ícone visível, varredura e segundos coerentes com `active_cd` ao usar a habilidade; ao chegar a 0, brilho e sem sombra.
- Ficha C mostra a seção de habilidade com nome, descrição e recarga efetiva; valores batem com `abilities.json` e `cd_pct` do herói.
- Sem ícone: sem erro de script (testar removendo um ícone em teste).
- Teste novo (dados: todos os heróis têm habilidade com `desc`, `cooldown` e ícone; função de texto da recarga); `tests/run_all.gd` 0 falhas; `tools/audit_projeto.gd` 0 erros.
- Verificação visual por captura em 3 heróis e em 2 resoluções (a registrar na EVID).

## Riscos e reversão
Médio (HUD). Um commit isolado, separado do commit da SPEC-126. Se o layout conflitar com outros elementos da HUD, ajustar posição antes de commitar.

## Resultado (2026-10-05)
Implementada; evidência e capturas em EVID-164. Slot de 72 px no centro inferior da HUD, escondido sob painéis; seção da habilidade no topo da ficha C. Só uma resolução de captura (1280×720).
