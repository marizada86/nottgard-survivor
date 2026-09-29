# EVID-089 — Execução da SPEC-059 (descrição de itens e slots visíveis)

Data: 2026-09-27
SPEC: [[SPEC-059-descricao-de-itens-e-slots-visiveis]]
PLAN: [[PLAN-030-backlog-hiago-itens-equipamento-e-economia-2026-09-27]] (Fase A)

## Alterações realizadas

- `ui/hud.tscn`: novo `ItemsPanel` (mesma família visual de `PausePanel`/
  `RevivePanel`), com título, `ItemsSlotsLabel` (contagem de slots),
  `ItemsScroll` + `ItemsDescLabel` (RichTextLabel com BBCode) e um botão
  `CloseItemsBtn`. Também um label de dica em `PausePanel` avisando que `C`
  abre o painel.
- `ui/hud.gd`: novo sinal `items_closed`; referências `%` para os nós novos;
  `_unhandled_input` estendido (mesmo padrão já usado para `KEY_ESCAPE`
  fechar a pausa) para `KEY_C` fechar o painel de itens quando visível;
  `show_items_panel(b)`/`hide_items_panel()` novos, que montam a descrição de
  cada arma/feitiço (`Weapon.def.desc`, já existente), passiva
  (`passives.json.desc`), item equipado (`Items.mods_text()` + `note`, ambos
  já existentes) e bênção (`boons.json.desc`), e o indicador
  `ocupados/limite` de armas (`hero.weapon_slots()`) e equipamento
  (`Items.SLOTS.size()`).
- `ui/run.gd`: `KEY_C` no `match` de `_unhandled_input` abre o painel (mesmo
  padrão de `_toggle_pause`); `_toggle_items_panel()`/`_close_items_panel()`
  novos; conectado a `hud.items_closed`.

Nenhum dado de jogo (`data/*.json`), economia, save ou o sistema de evolução
de armas foi alterado — só exibição de dado que já existia.

## Verificações executadas

| Comando | Resultado |
|---|---|
| `Godot_v4.7.2-stable_win64.exe --headless --path . -s tests/run_all.gd` | `testes: 0 falha(s)` |
| `Godot_v4.7.2-stable_win64.exe --headless --path . res://tools/smoke.tscn` | `smoke: ok` nas 8 fases (`dagruve`, `docas`, `shedaklah`, `molor`, `durao`, `feng_tu`, `shendilavri`, `goranthis`, `pilares` — 9 cenários no total do smoke atual) |

O smoke instancia `res://ui/run.tscn` (que carrega `hud.tscn`) para cada fase
sem erro, o que confirma que a cena nova (`ItemsPanel` e os `%` novos em
`hud.gd`) analisa e resolve corretamente — um nome único ausente ou uma cena
malformada teria falhado aqui.

## Exceção de validação

Não há binário do Godot com interface gráfica aberta nesta sessão para uma
checagem interativa real (apertar `C` numa run e olhar o painel). A suíte e o
smoke não simulam a tecla `C` nem chamam `show_items_panel()` — só provam que
a cena carrega e que a run roda. A lógica de `show_items_panel()` foi revisada
manualmente linha a linha e reaproveita exatamente os mesmos acessos
(`Items.mods_text`, `Data.table(...).desc`, `dict.campo`) já usados e
funcionando em `ui/menu.gd` (Códex) e no restante de `ui/hud.gd`.
**Recomenda-se uma checagem manual do dono** (abrir uma run, apertar `C`,
conferir a descrição e a contagem de slots, apertar `C`/`Esc` para fechar)
antes de considerar a SPEC-059 totalmente validada ponta a ponta.
