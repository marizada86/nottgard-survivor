---
id: "EVID-229"
title: "PLAN-092: sistema de UI (UiKit) e novo menu de pausa em abas (MEC-003, fase 1)"
created: "2026-10-09"
spec: "SPEC-165"
cards: ["MEC-003"]
status: "implementado na branch atena/eventos-e-ui-fase1; aguarda a conferência e a aprovação da direção visual pelo dono"
---

# EVID-229 — UiKit e menu de pausa em abas

Spec: [SPEC-165](../specs/SPEC-165-sistema-de-ui-e-menu-de-pausa-mec-003.md). Entrevista de 2026-10-09: dores = telas diferentes entre si, difícil achar as coisas, fluxo e navegação; escopo = sistema de UI + menu de pausa; arte = por código, sem arte nova. Aprovação por plano. Feito na branch local isolada `atena/eventos-e-ui-fase1` (worktree `F:\dev\_wt_work`) porque o dono estava ausente e quis conferir antes: nada na `main`.

**A direção visual continua DRAFT:** é a ficha C generalizada, e só o dono a aprova olhando as capturas.

## O que mudou

| Arquivo | Mudança |
|---|---|
| `ui/ui_kit.gd` (novo) | `UiKit`: paleta da ficha C, `box`, `label`, `dim`, `window`/`apply_window` (fundo e moldura), `margin`, `tab_button`, `hint_button`, `update_tab_hints`, `tab_step` (Q/E e LB/RB) |
| `ui/character_sheet.gd` | A ficha C passa a usar o UiKit (paleta, janela, abas, dicas, troca de aba). **Sem mudança visual** (captura confere) |
| `core/catalog.gd` (novo) | `Catalog`: entradas por categoria (inimigos, armas e feitiços, itens únicos), bloqueados "???" sem ícone e sem informação, marca "visto nesta run", contagem e detalhe |
| `ui/options_panel.gd` (novo) | `OptionsPanel`: áudio (volume e mudo por canal), falas, impacto reduzido, modo de tela e resolução, no mesmo perfil e com as mesmas funções da aba Opções do Quartel |
| `ui/pause_menu.gd` (novo) | `PauseMenu`: abas **Jogo**, **Catálogo** e **Configurações**; Q/E e LB/RB trocam; Esc e B seguem fechando; a grade do catálogo tem foco por controle |
| `ui/hud.gd` | O `PausePanel` ganha o estilo da janela padrão e o `PauseMenu`; a caixa antiga de botões (`%ResumeBtn`, ficha, velocidade, extrair, controles, mira, ajuda, abandonar) vai inteira para a aba Jogo e a linha de volume para Configurações; sinais e foco inalterados |
| `tests/test_catalog.gd`, `test_ui_kit.gd`, `test_pause_menu.gd` (novos) | Catálogo, valores do kit (a ficha C não pode mudar sem querer) e o menu dentro da HUD real |
| `tools/capture_pause_menu.{gd,tscn}` (novos) | Capturas desktop e celular |

## Desvios da spec (decisões minhas, para o dono confirmar)

1. **"Controles" não virou a 4ª aba:** continua o botão da aba Jogo que abre o painel de controles que já existe. Motivo: as 92 verificações de controle dependem desse fluxo (`_controls_panel`, foco de volta à pausa); mudar o fluxo e a navegação juntas era risco sem ganho agora.
2. **Catálogo sem Passivas e Bênçãos:** o perfil não guarda o que o jogador já viu delas (`profile.codex` só tem inimigos, armas e itens únicos). Incluí as três categorias que existem; as outras pedem um campo novo no perfil (segunda rodada).
3. **A mira ficou só na aba Jogo** (botão com Tab); o `OptionsPanel` a esconde na pausa.
4. **Sem ícones nas abas** da pausa (o kit os aceita; a ficha C continua com os dela). Sem arte nova.
5. O `OptionsPanel` só é usado na pausa por enquanto; o Quartel passa a usá-lo no lote 2 (P2 da spec).

## Verificação

| Verificação | Resultado |
|---|---|
| `test_catalog`, `test_ui_kit`, `test_pause_menu` | 0 falhas |
| **Mutação** (10: catálogo revela bloqueado; "false" do Battle conta como visto; paleta muda; Q e E trocados; páginas não se escondem; Q/E ignora o bloqueio; `show_menu` não volta à aba 0; abas não dão a volta; mira visível nas configurações; dono não restaurado ao mover) | 9 derrubaram o teste (1 a 3 falhas). A 10ª, "não restaurar o dono", **não** derruba nada: `reparent` dentro da mesma árvore já preserva o dono; o código é só defensivo. O que importa é mover **depois** de as páginas estarem na árvore (antes disso o `%ResumeBtn` sumia e o teste real pegou) |
| `tests/run_all.gd` | `testes: 0 falha(s)` |
| `res://tools/smoke.tscn` | `smoke: ok` |
| `res://tools/kit_test.tscn` | `kit: OK` |
| `tools/controller_check.tscn` (92 verificações) | 3 falhas, **as mesmas da linha de base** da branch antes das mudanças (`recusa_bencao_exige_confirmacao`, `cancelar_recusa_preserva_bencao`, `save_real_preservado`); os fluxos da pausa (`pausa_options`, `ficha_pela_pausa`, `ficha_retorna_pausa`, `opcoes_volta_a_pausa`, `pausa_volta_sem_abandonar`) passam |
| `tools/mobile_buttons_check.tscn` (142 verificações) | 34 falhas, **as mesmas da linha de base** (todas no Quartel: códex, opções, dificuldade, HQ; a única "diferente" é o mesmo botão com outro número de instância) |
| Capturas 1280×720 em `.atena/generated/plan-092/capturas/` (guardadas só as principais; `tools/capture_pause_menu.tscn` gera todas, inclusive a ficha C e o celular) | ficha C conferida visualmente igual à de antes; pausa nas três abas; catálogo com bloqueados escuros e detalhe ao lado; celular sem sobreposição |

As falhas da linha de base existem antes de qualquer mudança minha neste plano (listas em `.atena/generated/plan-092/base_*_falhas.txt`); não investiguei a causa (parecem do ambiente do worktree e do Quartel, não da pausa). Vale conferir se também acontecem na `main`.

## O que só o dono julga

Se a direção visual (a ficha C generalizada) é a certa para o resto do jogo; se as três abas e a grade do catálogo ajudam a achar as coisas; se o fluxo com controle e celular está confortável. Ajustes de espaçamento ou nomes de aba são de uma linha em `ui/pause_menu.gd`.

## Próximos lotes (fora deste plano)

Lote 2: Quartel, seleção de herói e mapa e título no UiKit (com o `OptionsPanel` e o `Catalog` no lugar das cópias do `menu.gd`). Lote 3: ofertas (level-up, altar, loja) e a HUD da run. Cada um com spec e aprovação próprias.
