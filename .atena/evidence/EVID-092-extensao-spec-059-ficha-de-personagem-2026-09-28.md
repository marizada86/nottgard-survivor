# EVID-092 — Extensão da SPEC-059: ficha de personagem e dica visível

Data: 2026-09-28
SPEC: [[SPEC-059-descricao-de-itens-e-slots-visiveis]]
PLAN: [[PLAN-032-proxima-atualizacao-pos-playtest-2026-09-28]]
Origem: respostas 1, 2 e 3 de [[EVID-091-playtest-higo-hiago-build-c-e-item-offer-2026-09-28]]

## Alterações realizadas

- `ui/hud.tscn`:
  - `StatBox` ganhou `ItemsHintLabel`, um label estático sempre visível
    durante a run ("[C] Itens e feitiços"), complementando a dica que só
    existia no menu de pausa.
  - `ItemsPanel/VBox` ganhou `ItemsHeader` (HBoxContainer) com
    `ItemsPortrait` (retrato do herói), e `ItemsHeaderText` com
    `ItemsHeroLine` (nome/nível), `ItemsAttrLine` (atributos e defesas
    finais) e `ItemsBonusLine` (bônus agregados).
- `ui/hud.gd`: `show_items_panel()` agora popula esse cabeçalho:
  - Retrato via `res://assets/portraits/<hero.id>.png` — mesmo arquivo já
    usado na tela de seleção de herói do Quartel (`ui/menu.gd:_refresh_hero`),
    carregado só quando o herói muda (evita releitura a cada frame).
  - Linha de atributos no mesmo formato já usado em `menu.gd` ("FOR %d ·
    INT %d · CON %d · CAR %d"), mas com valores **já somando todos os
    mods** (via `Hero.attr()`, que já inclui bônus, em vez dos atributos
    base estáticos que o Quartel mostra antes da run).
  - PV atual/máximo, CA e CAM com a evasão percentual já calculada por
    `Hero.typed_evasion()` (existente), sem nova fórmula.
  - Linha de bônus ativos: `Items.mods_text(hero.mods)` — a mesma função já
    usada para descrever itens individuais, aplicada ao dicionário agregado
    do herói (`hero.mods`, que `Hero.recalc()` já mantém atualizado com
    item + passiva + bênção + meta + conquista). Não foi necessário nenhum
    cálculo novo.

## Decisão de escopo registrada

A resposta 2 pedia "mais detalhe ao passar o mouse". Em vez de reestruturar a
lista compacta de itens em widgets individuais só para suportar tooltip por
linha, tratei a causa como a mesma da resposta 3: faltava o dado agregado
(atributos finais e bônus totais), não uma interação de hover. O cabeçalho
novo expõe essa informação diretamente, sem exigir passar o mouse — decisão
consciente, registrada em SPEC-059 para não ficar como pendência
não-documentada.

## Verificações executadas

| Comando | Resultado |
|---|---|
| `Godot_v4.7.2-stable_win64.exe --headless --path . -s tests/run_all.gd` | `testes: 0 falha(s)` |
| `Godot_v4.7.2-stable_win64.exe --headless --path . res://tools/smoke.tscn` | `smoke: ok` nas 8 fases |

O smoke confirma que `hud.tscn` com os nós novos carrega e a run instancia
sem erro nas nove cenas. Nenhum teste automatizado cobre a montagem visual do
cabeçalho em si (mesma limitação já registrada em EVID-089/090) — depende de
checagem manual do dono.

## Exceção de validação

Mesma exceção de SPEC-059/060: sem checagem manual interativa (abrir o
painel `C` numa run real e ver o retrato/atributos renderizados) nesta
sessão. Recomenda-se confirmar visualmente antes do próximo playtest.
