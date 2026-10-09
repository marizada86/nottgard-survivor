---
id: "SPEC-165"
title: "Sistema de UI e novo menu de pausa (MEC-003, fase 1)"
status: "IMPLEMENTADA em branch atena/eventos-e-ui-fase1 em 2026-10-09 (EVID-229); direção visual ainda DRAFT; aguarda conferência, merge e aprovação do dono"
origin: planned
implementation_preceded_spec: false
request_classification: PLAN_DEVIATION
created: "2026-10-09"
relations: ["[[SPEC-130-ficha-c-em-abas-grade-e-detalhe]]", "[[SPEC-131-hud-da-run-no-padrao-da-ficha-c]]", "[[SPEC-147]]"]
cards: ["MEC-003"]
visual_direction: "DRAFT: padrão da ficha C (SPEC-130) generalizado; ver 'Direção visual (hipótese)'"
---

# SPEC-165 — Sistema de UI e novo menu de pausa (fase 1)

Origem: MEC-003 (EVID-088 nota 2: "menu de pausa ampliado: catálogo de itens e tela de configurações"), ampliada pelo dono em 2026-10-09: "o jogo está maior e recebeu muitas atualizações, considerar uma nova UI". Entrevista: o que incomoda é **telas diferentes entre si**, **difícil achar as coisas** e **fluxo e navegação**; escopo escolhido: **sistema de UI + menu de pausa** primeiro; **UI por código, sem arte nova**.

## O que existe (lido em 2026-10-09)

- ~8 mil linhas em 25 arquivos de `ui/`; a ficha C (`ui/character_sheet.gd`, 655 linhas) tem o padrão visual mais maduro (cores, moldura fina, abas, grade, detalhe, foco por controle), aceito pelo dono em 2026-10-06 e adotado na HUD (SPEC-131).
- O **menu de pausa** da run é um `PanelContainer` (`%PausePanel`) com botões montados em `ui/hud.gd` (`_setup_controller_pause`): Continuar, Ficha, velocidade, Extrair, Controles. **Sem catálogo e sem configurações** (áudio, tela, mira, falas, impacto) durante a run.
- O **Quartel** (`ui/menu.gd`, `menu.tscn`) tem abas (melhorias, conquistas, **códex de inimigos, armas e únicos**, HQs, **Opções**) com estilo próprio; o códex lê `profile.codex`.
- `tests/test_options_menu.gd` garante os controles da aba Opções do Quartel.

## Fase 1: o que entrega

1. **`UiKit` (`ui/ui_kit.gd`)**: o padrão visual em um lugar só, extraído da ficha C: paleta (ouro, ouro apagado, ferro, mudo, cores de atributo), `box()` (fundo, borda, raio), `label()`, barra de abas (com L1/LB e R1/RB, mouse e toque), slot de grade, rodapé de dicas de controle e regras de foco. **A ficha C passa a usar o UiKit sem mudar o que o jogador vê** (captura antes e depois, comparação por pixel dentro da tolerância).
2. **`PauseMenu` (`ui/pause_menu.gd`)** no lugar do painel de botões, com 4 abas:
   | Aba | Conteúdo |
   |---|---|
   | **Jogo** | Continuar, Ficha do herói, velocidade 1x/2x, Extrair e encerrar (com a confirmação que já existe) |
   | **Catálogo** | Inimigos, Armas, Itens únicos, Passivas e Bênçãos: grade de ícones, **desbloqueados visíveis, bloqueados escuros e sem informação ("???")**, detalhe ao lado; marca "visto nesta run". Lê `profile.codex` e os dados do jogo |
   | **Configurações** | Áudio (música, efeitos, ambiente), exibição (modo e resolução), mira, falas e impacto reduzido: o mesmo conjunto da aba Opções do Quartel, via **componente compartilhado** (`ui/options_panel.gd`) para não ter duas telas |
   | **Controles** | O painel de controles que já existe (mapa Padrão/Legado, prompts) |
3. **Fluxo único:** Esc ou B fecham; voltar sempre sobe um nível; L1/R1 trocam de aba; foco inicial previsível; no celular, as abas viram botões grandes.
4. **Núcleo testável:** `Catalog.entries(category, profile)` (puro) devolve as entradas com `known`, `seen_this_run` e dados; `PauseMenu.tab_model` guarda aba atual e regras de navegação.

## Direção visual (hipótese, DRAFT)

Generalizar a ficha C: painel quase opaco com moldura fina dourada, abas por texto, grade de slots, detalhe à direita, rodapé com dicas de botão. Sem arte nova: tudo desenhado por código com as fontes e ícones existentes. A arte final (molduras e ícones) troca depois **sem mexer na estrutura**. **Aguarda sua aprovação da direção na primeira captura.**

## Padrões (não bloqueiam)

| # | Decisão | Padrão |
|---|---|---|
| P1 | Tamanho do menu de pausa | Mesmo painel e proporção da ficha C (1088×612 em 1280×720) |
| P2 | Quartel nesta fase | Não muda (migra no lote 2, usando o `OptionsPanel` compartilhado) |
| P3 | Aba "Catálogo" mostra bênçãos e passivas | Sim, só as que o herói já viu no perfil |

## Fases seguintes (fora desta spec)

Lote 2: Quartel, seleção de herói e mapa, título, no UiKit. Lote 3: ofertas (level-up, altar, loja) e HUD da run. Cada lote tem spec e aprovação própria.

## Verificação

Testes do `Catalog` (bloqueado vs. desbloqueado, "visto nesta run", categorias), do modelo de abas e da navegação com controle (reaproveitando os testes de controle); teste de que a ficha C com o UiKit mantém as mesmas cores e tamanhos (valores) e captura antes e depois; o `OptionsPanel` cobre os mesmos controles do `test_options_menu`; capturas de desktop, celular e foco por controle; suíte, smoke, kit_test. **Se a captura mostrar que a direção não funciona, paro e pergunto.** Julgar se a UI "ficou melhor" e navegável é do dono.

## Fora do escopo

Arte nova, sons, mudança no Quartel e na HUD, mudança de regra de jogo, qualquer migração além da pausa e da ficha C.

## Portões

Commit só com aprovação explícita; push e exportação à parte; sem dependência nova; nada em `assets/`; mudanças de outras sessões preservadas; documentos dos testers só quando o dono liberar.
