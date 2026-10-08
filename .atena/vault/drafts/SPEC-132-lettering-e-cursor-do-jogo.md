---
id: SPEC-132
title: Lettering do jogo (logo, banners, placas) e cursor do mouse temáticos
status: approved-in-execution (aprovada por plano pelo dono em 2026-10-06; B-001 e B-002 feitas, EVID-172)
origin: pedido do dono (2026-10-06), "arte de lettering para estilo e imersão, também uma arte para o cursor do mouse"
cards: ART-039, ART-040, MEC-058
risk: baixo (UI e arte; sem efeito no combate nem em números). Atenção: o cursor da mira é lido pelo combate (hotspot errado desalinha a mira).
plan: PLAN-065 (por plano)
---

# SPEC-132

## Pedido
Dar identidade ao texto do jogo com **lettering desenhado** (hoje tudo é `Label` com a fonte Cinzel Decorative e contorno) e trocar o cursor do sistema por um **cursor temático**.

## Decisões do dono (2026-10-06)
| # | Decisão |
|---|---|
| D1 | Lettering nas **quatro frentes**: logo do título; banners de fim de fase; banners de momento; cabeçalhos de tela e HQ. |
| D2 | Cursor **menu + mira**: ponteiro de menu (normal e sobre botão) e mira para a run com mira por mouse. |
| D3 | Fila de imagens: **depois da ficha C** (CHATGPT-FILA-025) e antes dos VFX (FILA-021 em diante). |
| D4 | Aprovação **por plano** (PLAN-065). |

## Estado atual (lido no código, 2026-10-06)
- `ui/title.gd`: carrega `assets/ui/title/logo.png` ou `logo_00.png...` (animado a 12 fps), mas **a pasta só tem `title_background.png`**; hoje o logo é um `Label` Cinzel 72 pt. "Clique para jogar" é `Label` Cinzel 30 pt com pulso de alfa.
- Fim de fase: `ui/hud.gd` põe `"Vitória!"` / `"Você caiu..."` em `%ResultTitle` sobre `assets/ui/backgrounds/{victory,defeat}_background.png` (1920×1080).
- Momentos: `★  EVOLUÇÃO  ★` (`ui/hud.gd`, cinemática de evolução com `evolucao_painel_moldura.png`), apresentação de chefe em `ui/run.gd` (`_boss_intro_title`/`_subtitle`, arte em `assets/ui/boss-intros/`, hoje só o Sacerdote da Mente Derretida).
- Cabeçalhos: `ui/menu.gd` (quartel), `ui/hq_screen.gd` (`%HqTitle`, 14 HQs em `data/hqs.json`), `ui/character_sheet.gd` (ficha C, PLAN-063).
- Cursor: o projeto **não define cursor próprio** (nenhum `set_custom_mouse_cursor`, nenhum `MOUSE_MODE_*`). Viewport 1280×720, `stretch/mode = canvas_items`, Godot 4.7, GL Compatibility.
- Fontes em `assets/fonts/`: Cinzel Decorative Bold e Alegreya Sans (OFL). Paleta de UI: ferro escuro + ouro velho `(0.85, 0.72, 0.4)`; título em roxo abissal.

## Abordagem
**Lettering em duas camadas** (decisão de Atena para controlar o risco de erro de grafia do gerador de imagem):
1. **Peças fixas e curtas viram imagem de lettering completa:** logo, `Vitória!`, `Você caiu...`, `EVOLUÇÃO` e as que o inventário da B-001 confirmar. Cada uma passa por conferência de grafia letra a letra, com acentos.
2. **Texto dinâmico** (nome de chefe, título de HQ, nome de fase, cabeçalho de aba) **continua em fonte**, mas sobre **placas de título** desenhadas (largas e estreitas, de nove fatias) e com um **estilo de lettering** aplicado pelo código: Cinzel Decorative, contorno em duas camadas, ouro velho com gradiente vertical (se o `shader` por glifo passar na captura) e sombra.
3. Se uma peça de imagem falhar a grafia duas vezes, ela cai para **placa + fonte** (mesma camada 2). Sem esse recurso o jogo nunca fica com erro de português.

**Cursor:**
- Três PNGs com transparência: **ponteiro** (`CURSOR_ARROW`), **mão sobre botão** (`CURSOR_POINTING_HAND`) e **mira** (`CURSOR_CROSS`), registrados com `Input.set_custom_mouse_cursor(imagem, forma, hotspot)`. Mapear por *forma* evita lógica de estado: botões já pedem `POINTING_HAND`, modais e menus pedem `ARROW`, e a run pede `CROSS` só enquanto a mira é por mouse e nenhum modal está aberto.
- O cursor é do sistema operacional: **não escala** com `canvas_items` e **não aparece** em capturas do viewport. Tamanho-base 32 px (mira 40 px), gerado em 4× e reduzido por script; hotspots numa tabela de dados.
- Se o gerador não entregar legibilidade a 32 px, o plano prevê **cursor desenhado por script** (pixel art montada em código), sem depender do gerador.
- Helper estático (sem novo autoload) chamado por `Game` na inicialização; sem arte, cai no cursor do sistema.

## Peças (nomes provisórios; lista final fechada na B-001)
| Peça | Uso | Tamanho final (px) |
|---|---|---|
| L01 `logo` | `assets/ui/title/logo.png` (cabe na faixa 1280×176 do título) | até 1100×176 |
| L02 `prompt_clique` (opcional) | "Clique para jogar" | até 480×64 |
| L03 `banner_vitoria` | `Vitória!` | até 720×160 |
| L04 `banner_derrota` | `Você caiu...` | até 720×160 |
| L05 `banner_evolucao` | `EVOLUÇÃO` | até 640×110 |
| L06+ banners de momento extras | só os que o inventário confirmar (ex.: aviso de chefe) | a definir |
| P01 `placa_titulo_larga` | cabeçalho de telas e cartela de HQ (nove fatias) | 9-slice |
| P02 `placa_titulo_secao` | cabeçalho de abas e seções | 9-slice |
| P03 `placa_chefe` | nome do chefe na apresentação | 9-slice |
| C01 `cursor_ponteiro` | menus | 32×32, hotspot na ponta |
| C02 `cursor_mao` | sobre botões | 32×32, hotspot na ponta do dedo |
| C03 `cursor_mira` | run com mira por mouse | 40×40, hotspot no centro |

## Fora do escopo
- Logo animado (`logo_00...`): o código já suporta, fica para depois.
- Tradução ou troca de redação dos textos (mantêm-se `Vitória!`, `Você caiu...`, `EVOLUÇÃO`).
- Opção "cursor do sistema / cursor do jogo" no menu de opções (candidata a backlog se o playtest reclamar).
- Esconder o cursor ao usar joystick (só entra se o código já detectar o dispositivo; senão fica como está).
- Ícones, molduras e abas da ficha C (CHATGPT-FILA-025): as placas P01/P02 só se alinham ao estilo delas depois da aprovação da A01.

## Lacunas e padrões assumidos (nenhuma `BLOCKING`)
| # | Lacuna | Padrão assumido |
|---|---|---|
| G-1 | Redação dos banners | Manter a atual. |
| G-2 | Grafia e acentos no gerador | Conferência letra a letra; 2 falhas = placa + fonte. |
| G-3 | Cursor legível a 32 px | Fallback por script. |
| G-4 | Cursor em tela cheia 1080p/1440p | Tamanho fixo em px; conferir no playtest e, se pequeno, escalar pela altura da janela. |
| G-5 | Arquivos tocados por outras sessões (`ui/hud.gd`, `ui/character_sheet.gd`, `ui/hero_panel.gd`: PLAN-063 e PLAN-064) | A integração desses três só começa depois que essas mudanças estiverem commitadas; antes, tudo o mais segue. |

## Aceite
1. **Arte:** todas as peças aprovadas visualmente pelo dono em escala real (logo, banners e placas sobre captura do jogo; cursores compostos sobre captura no hotspot) antes de entrar em `assets/`; auditoria de alfa sem halo magenta; grafia conferida.
2. **Código:** título usa `logo.png`; fim de fase, evolução, chefe e cabeçalhos usam as peças; texto dinâmico recebe o estilo de lettering; sem arte, tudo continua funcionando como hoje (fallback).
3. **Cursor:** formas `ARROW`, `POINTING_HAND` e `CROSS` mapeadas; mira por mouse com hotspot no centro (teste numérico + composição visual); modais da run (nível, altar, ficha C, pausa) voltam ao ponteiro; troca de mira AUTO/MOUSE atualiza a forma.
4. **Testes:** `tests/test_cursor.gd` (arquivos, tamanhos ≤ 64 px, hotspots dentro da imagem, mapa forma→imagem) e `tests/test_lettering_assets.gd` (existência, dimensões, cantos transparentes, 9-slice válido) em `tests/run_all.gd`; suíte completa com 0 falhas.
5. **Evidência:** capturas de título, vitória, derrota, evolução, apresentação de chefe, HQ e quartel em 1280×720 e 1920×1080; EVID novo; itens na lista "O que testar" de `RELEASES.md` (cursor só se vê em janela real).
6. **Regras do projeto:** arte e código em commits separados (`mechanics_share_commit_with_other_tracks: false`); commit, push e build só com aprovação explícita.

## Reversão
Apagar o helper de cursor e os PNGs; as chamadas têm fallback e o título volta ao `Label` automaticamente.
