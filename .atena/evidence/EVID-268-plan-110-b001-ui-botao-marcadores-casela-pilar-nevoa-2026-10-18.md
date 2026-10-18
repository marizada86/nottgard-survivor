# EVID-268 — PLAN-110 / SPEC-185, lote B-001 (UI de alta visibilidade)

Data: 2026-10-18 · Estado: DRAFT (pacotes com aceite visual de direção; sem promoção a CANON) · Desvio: DEV-045.

## Fontes

Copiadas da branch `codex/art-production-lot12-14-2026-10-17` (`89a83520`) para `.atena/generated/chatgpt-integration-2026-10-17/b001/fontes/`, SHA-256 conferido contra os manifestos (8 de 8 iguais). Preparação técnica por `tools/prepare_ui_art.gd` (fundo magenta para alfa, erosão de 1 px, recorte pelo contorno, redução sem distorcer); relatório em `b001/preparacao.json`. Direção, silhueta e paleta não foram alteradas.

## O que entrou

| Peça | Fonte | Destino | Ligação |
|---|---|---|---|
| Botão de ação JOGAR / Ler HQ | FILA029 B01 v03 (retidas v01 e v02) | `assets/ui/ficha/botao_acao_moldura.png` (378×63) | `SheetArt.ACTION`, `UiKit.action_frame/style_action_button` (fatias 36/20); aplicado ao `PlayBtn` e `HqPlayBtn` em `ui/menu.gd`; estados normal, foco, pressionado e desabilitado por tinta; texto e glifo seguem do jogo |
| Marcadores da barra de progresso | LOT02 UI02-A (losango) e UI02-B (caveira) | `assets/ui/progresso/marcador_jogador.png`, `marcador_chefe.png` (64×64) | `ui/stage_progress.gd`: losango na ponta do preenchimento (14 px) e caveira na ponta direita (20 px); a barra segue com 4 px (SPEC-163) |
| Casela do catálogo | LOT02 UI03 (bloqueada) e UI04 (aberta) | `assets/ui/catalogo/casela_bloqueada.png`, `casela_aberta.png` (128×128) | `UiKit.catalog_slot`; grade do catálogo da pausa (`ui/pause_menu.gd`): aberta para o que já se viu, bloqueada (silhueta e cadeado) para o resto; tinta dourada marca o que apareceu na run; o "?" saiu |
| Pilar 01 refeito | LOT02 PR01 (ART-048) | `assets/props/pilar_01.png` (256×256; backup `b001/backup/pilar_01_antes.png`) | ruído de alfa baixo limpo (11 186 px), material sólido opaco, altura, base e centro iguais ao `pilar_02`; `ui/prop.gd` voltou a sortear as 3 variantes |
| Névoa de borda NB01 | FILA030 preparada | `assets/fx/nevoa_mundo_borda_01.png` | `ui/edge_fog.gd`: faixa rasteira por cima do gradiente (que segue marcando o limite do dano), 2,4× a profundidade da faixa, alfa 0,55; textura repetida ao longo da borda |
| Frente da Maré NB02 | FILA030 preparada | `assets/fx/nevoa_mundo_frente_01.png` | `ui/run.gd`: troca a textura das 4 bordas da Maré; `nevoa_borda_01.png` fica de reserva; dano, faixa e ritmo não mudaram |

## Retido, aguardando decisão do dono

- **UI01 (moldura de progresso):** não integrada. A barra tem 4 px (SPEC-163) e a moldura tem proporção ~9,2:1 com ornamentos nas pontas; encaixar exige aumentar a altura da barra (ordem de 12 a 16 px) ou desistir da moldura. A entrega diz que ela não autoriza mudar o layout.
- Contraste da névoa no fundo claro e o perigo percebido da Maré dependem de playtest.

## Verificação

- Importação headless sem erro; `tests/run_all.gd`: **0 falhas**; smoke das 9 fases `ok`; `controller_check` 94/0 e `mobile_buttons_check` 146/0 (iguais à linha de base).
- Capturas em janela real (`b001/capturas/`): menu com o botão, barra (fase e chefe), catálogo de inimigos e de armas, três pilares, névoa de borda e frente da Maré.
- Não verificado: leitura dos marcadores a 14 e 20 px em uso real, legibilidade em celular, sensação do botão e da névoa. Playtest humano pendente. Sem commit, push, build nem exportação.
