---
id: "EVID-231"
title: "PLAN-093: nova UI, lote 2 (Quartel no UiKit; Códex no Catalog; Opções no OptionsPanel)"
created: "2026-10-09"
spec: "SPEC-166"
cards: ["MEC-003"]
status: "implementado e verificado local; aguarda playtest; direção visual aprovada pelo dono em 2026-10-09"
---

# EVID-231 — Nova UI, lote 2

Spec: [SPEC-166](../specs/SPEC-166-nova-ui-lote-2-quartel-selecao-e-titulo-mec-003.md). Decisões do dono (2026-10-09): direção visual aprovada (o padrão da ficha C e da pausa), escopo **restilizar e unificar** (mesma estrutura), aprovação **por plano**. Sem arte nova, sem dependência nova, nada em `assets/`.

## O que mudou

| Arquivo | Mudança |
|---|---|
| `ui/ui_kit.gd` | `style_tab_container` (abas com a moldura da ficha C e painel discreto de fundo escuro com borda fina), `style_list` (listas com seleção dourada) e `style_text` (texto de detalhe na moldura ornamentada) |
| `ui/menu.gd` (574 → 506 linhas) | Cria o `OptionsPanel` na aba Opções e as variáveis antigas (`music_vol_opt`, `barks_opt`...) viram **apelidos** dos controles dele; sai o código duplicado de conexão e de gravação (`_save_audio_setting`, `_save_barks`, `_save_reduced_impact`, `_save_audio_mute`); o Códex usa `Catalog.entries` e `Catalog.detail`; estilo do UiKit nas abas, nas listas e nos textos; o painel das abas sobe 18 px para a moldura não encostar no `JOGAR` |
| `ui/menu.tscn` | Saem os 21 nós de opções que o `OptionsPanel` substitui (áudio, falas, impacto, vídeo, mira); ficam `DiffOpt` (maldição), `GuideBtn`, `ResetBtn` e o painel de controles |
| `ui/options_panel.gd` | Ganha o **volume mestre** (o Quartel o mostra; a pausa o esconde porque já tem o `%VolSlider`) |
| `ui/pause_menu.gd` | Esconde o volume mestre do `OptionsPanel` |
| `tests/test_quartel.gd` (novo), `tests/test_options_menu.gd` (atualizado) | Abas por nome e na ordem, estilo do UiKit, apelidos, persistência pelo componente, Códex igual ao Catalog |
| `tools/capture_quartel.{gd,tscn}` (novos) | Capturas do título e das oito abas (desktop e celular), sempre com perfil e save descartáveis |

**Título:** sem mudança, por escolha (P3 da spec). O prompt "Clique para jogar" já tem tipografia e contorno próprios (Cinzel Decorative, lilás); trocá-los pelo UiKit seria piorar, não unificar.

## Verificação

| Verificação | Resultado |
|---|---|
| `test_quartel`, `test_options_menu` | 0 falhas |
| **Mutação** (sem o estilo do UiKit nas abas; apelido errado; Códex revela bloqueado; detalhe sempre conhecido; silenciar não grava; volume não grava) | 1, 3, 1, 1, 1 e 1 falhas (a de "silenciar não grava" só apareceu depois de eu acrescentar a asserção de mudo ao teste); restaurado, 0 |
| `tests/run_all.gd` | `testes: 0 falha(s)` |
| `tools/mobile_buttons_check.tscn` | **146 verificações, 0 falhas** (o mesmo número da linha de base corrigida; códex, opções, dificuldade, HQ e reset passam com os nós aliasados) |
| `tools/controller_check.tscn --headless` | **90 verificações, 0 falhas** (inclui Quartel por controle, foco e repouso de 60 s) |
| `res://tools/smoke.tscn` / `res://tools/kit_test.tscn` | `smoke: ok` / `kit: OK` |
| Save real (`user://profile.json`) antes e depois de tudo | Hash idêntico |
| Capturas 1280×720 em `.atena/generated/plan-093/` (`capturas` = antes; `depois` e `depois-mobile` = depois; guardadas só as principais, `tools/capture_quartel.tscn` gera todas) | Abas com moldura, painéis e detalhes no padrão da ficha C, sem sobreposição com o botão `JOGAR` |

## Observações

1. **Celular:** na aba Jogar, em fonte maior, a última linha da biografia bloqueada passa um pouco da moldura do texto (cosmético; o texto rola). Não mexi para não estourar a estrutura.
2. **`tools/build_scenes.gd`** é um gerador antigo de cenas que ainda monta os 21 nós removidos; não foi rodado nem alterado. Se for rodado de novo, vai recriar os controles antigos (o `menu.tscn` está editado à mão desde antes).
3. **Aba Marcas e Ranking:** receberam só a moldura (P4); conteúdo próprio de cada uma não mudou.
4. O que só o dono julga: se o Quartel "ficou melhor" e se a densidade dos detalhes está confortável.
