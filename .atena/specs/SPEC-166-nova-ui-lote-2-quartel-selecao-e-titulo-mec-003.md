---
id: "SPEC-166"
title: "Nova UI, lote 2: Quartel, seleção de herói e mapa, e título no UiKit (MEC-003)"
status: "IMPLEMENTADA em 2026-10-09 (PLAN-093, EVID-231); aguarda playtest; título sem mudança por escolha (P3)"
origin: planned
implementation_preceded_spec: false
request_classification: PLAN_DEVIATION
created: "2026-10-09"
relations: ["[[SPEC-165-sistema-de-ui-e-menu-de-pausa-mec-003]]", "[[SPEC-130-ficha-c-em-abas-grade-e-detalhe]]"]
cards: ["MEC-003"]
visual_direction: "a da SPEC-165 (ficha C generalizada); DRAFT até o dono aprovar"
---

# SPEC-166 — Nova UI, lote 2

Origem: pedido do dono em 2026-10-09 ("vamos para o item 2: Lote 2 da nova UI: Quartel, seleção de herói e mapa e título no UiKit, com o OptionsPanel e o Catalog no lugar das cópias do menu.gd"). Continua a [SPEC-165](SPEC-165-sistema-de-ui-e-menu-de-pausa-mec-003.md) (fase 1: `UiKit`, `Catalog`, `OptionsPanel` e a pausa em abas, já na `main`).

## O que existe (lido em 2026-10-09; capturas em `.atena/generated/plan-093/capturas/`)

- **Quartel** (`ui/menu.tscn`, `ui/menu.gd`, 574 linhas): `TabContainer` nativo com 8 abas (Jogar, Marcas, Melhorias, Conquistas, Códex, Opções, Diário, Ranking), fundo, título "Nottgard Survivors", moedas e versão; `PlayBtn` fixo embaixo à direita. Visual próprio: abas de texto simples e painéis translúcidos, **diferente da ficha C e da pausa**.
- **Cópias a eliminar:** o **Códex** (`_fill_codex`, `_show_codex`) repete o que o `Catalog` faz; as **Opções** (controles em `Tabs/Opções/Content` e `_save_*`) repetem o `OptionsPanel`.
- **Jogar** (seleção): `HeroList` e `StageList` (`ItemList`), retrato e texto de herói e de fase, botão `JOGAR`.
- **Título** (`ui/title.gd`, 140 linhas): fundo, logo (animado se houver sequência) e "Clique para jogar"; sem painéis nem abas.
- **O que as verificações exigem** (146 do celular, 90 do controle e `test_options_menu`): nomes e caminhos de nós e variáveis do `menu.gd` (`codex_cat`, `codex_list`, `codex_text`, `vol_opt`, `music_vol_opt`..., `upgrade_box`, `hq_list`, `play_btn`, `Tabs/Opções/Content/...`), a ordem das abas por nome e o fluxo de foco por controle.

## Desenho

1. **Moldura e abas no padrão da ficha C**, **sem trocar o `TabContainer`**: o `TabBar` recebe os estilos de aba do `UiKit` (as mesmas molduras `SheetArt`) e o conteúdo ganha a moldura do detalhe. Nomes de nós, ordem e navegação ficam idênticos.
2. **Códex no `Catalog`:** `menu.gd` passa a montar entradas e detalhe com `Catalog.entries`/`Catalog.detail` (a mesma conta da pausa); `codex_cat`, `codex_list` e `codex_text` continuam sendo os mesmos nós.
3. **Opções no `OptionsPanel`:** a aba Opções passa a hospedar o `OptionsPanel` (áudio, falas, impacto, tela) e mantém no `menu.gd` o que é só do Quartel (volume mestre, mira, maldição/dificuldade, painel de controles, guia e reset). As variáveis antigas (`music_vol_opt`...) viram **apelidos** dos controles do componente, então as verificações seguem valendo.
4. **Seleção de herói e mapa** com a moldura de detalhe do `UiKit` (retrato, texto e lista), mesmo conteúdo e mesmo foco; sem mudar a estrutura nem os dados.
5. **Título:** só o que o `UiKit` já resolve sem arte (fonte, cor e prompt de controle); logo, fundo e fluxo ficam como estão (P3).
6. **Sem arte nova, sem dependência nova**, nada em `assets/`.

## Padrões (não bloqueiam)

| # | Decisão | Padrão |
|---|---|---|
| P1 | Estrutura do Quartel | Mesma: restilizar, não reorganizar |
| P2 | Ordem das abas | A atual (Jogar, Marcas, Melhorias, Conquistas, Códex, Opções, Diário, Ranking) |
| P3 | Título | Quase intacto: já tem lettering próprio |
| P4 | Aba Marcas e Ranking | Só a moldura (conteúdo próprio de cada uma) |

## Verificação

Testes novos (modelo do Códex do Quartel igual ao do `Catalog`; as variáveis apelido apontam para o `OptionsPanel`; as 8 abas existem, na ordem e por nome), `test_options_menu` atualizado ao novo caminho, **`mobile_buttons_check` com 146 e `controller_check` com 90 verificações e 0 falhas** (regressão), suíte, smoke, kit_test, capturas antes e depois (desktop e celular), mutação nos testes novos. Se a captura mostrar sobreposição ou perda de foco que só se resolve mudando a estrutura, **paro e pergunto**. Julgar se o Quartel "ficou melhor" é do dono.

## Fora do escopo

Arte nova, mudança de regras, o conteúdo das abas Marcas, Ranking, Melhorias e Conquistas além da moldura, o fluxo de início de run, o lote 3 (ofertas e HUD da run).

## Portões

Direção visual aprovada pelo dono na primeira captura; commit só com aprovação explícita; push e exportação à parte; sem dependência nova; nada em `assets/`; mudanças de outras sessões preservadas; documentos dos testers só quando o dono liberar.
