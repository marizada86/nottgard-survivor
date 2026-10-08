---
id: "EVID-200"
title: "Relato do playtester T03 (Daniel, DNA) sobre a v0.3.3, repassado pelo dono"
created: "2026-10-07"
relations: ["[[EVID-108-playtest-publico-t03-dna-2026-09-29]]", "[[EVID-199-relato-t04-manzi-v032-2026-10-07]]", "[[EVID-187-playtest-ranking-local-2026-10-06]]", "[[SPEC-118]]"]
cards: ["BUG-003", "MEC-045", "SPEC-138"]
---

# EVID-200 — T03 Daniel ("DNA"), segundo relato (v0.3.3)

**Natureza:** relato **de segunda mão**, colado pelo dono (Higor) em 2026-10-07. Sem pacote `evidencias/`, log nem prints; sem hash de build. O texto cita a v0.3.3 de playtester (perfil de build com evidências). Heróis e fases jogados não foram informados. Daniel (T03) já jogou a v0.2.x ([EVID-108](EVID-108-playtest-publico-t03-dna-2026-09-29.md)); desta vez **não é de primeira vez**. "Quest" no relato = objetivos dos acontecimentos de fase (SPEC-118, `core/happenings.gd`); confirmar com Daniel.

| # | Relato (resumo fiel) | Intake | Verificação no código (leitura; nada executado) | Destino sugerido |
|---|---|---|---|---|
| 1 | Com o bloco de notas aberto, o jogador não pode interagir com o resto do jogo; o foco fica no bloco até fechar | IN-066 | **Procede.** `Playtest._pad` é só um painel central, sem fundo que bloqueie o mouse (`core/playtest.gd:121-123`). A HUD roda pausada (`ui/hud.gd:67`, `PROCESS_MODE_ALWAYS`) e continua clicável. O atalho de teclado da HUD só respeita o guia (`ui/hud.gd:335`, `has_modal` em `:224-225` testa `Playtest._guide_open`, não `_note_open` nem a central). Teclas só são engolidas pelo campo de texto enquanto ele tem foco; um clique fora o tira, e botões de controle nunca passam pelo campo. Só a ficha C já consulta `Playtest.is_overlay_open()` (`ui/character_sheet.gd:349`) | BUG novo P1 |
| 2 | O botão C (Fechar) não funciona na ficha do herói | IN-067 | **Confirmado.** Com a ficha aberta, `ui/hud.gd:335` retorna cedo (`items_panel.visible`) antes do ramo que fecha com C (`:348`), e `ui/run.gd` sai por `hud.has_modal()`, que também inclui `items_panel.visible` (`ui/hud.gd:225`). Resultado: a tecla C abre, mas não fecha; só Esc fecha (`ui/character_sheet.gd:352`). O botão exibe "Fechar (C)". É a dívida **BUG-003** ("fechar com C e Esc") e coincide com o pedido #4 do Manzi (C nas ofertas) | BUG novo P1 (relatos: 1; BUG-003) |
| 3 | O ranking não atualiza na tela inicial; verificar se só ocorre ao zerar a campanha | IN-068 | **Parcial, três fatos.** (a) Na tela inicial a lista só carrega ao clicar em "Atualizar" (`ui/leaderboard.gd:28-32`; `_ready` não chama `refresh`). (b) O cliente Windows **não envia nada** ao site: grava `logs/estatisticas.log` só quando a tentativa termina (`ui/run.gd:587`, `core/playtest.gd:921-930`); o ranking depende da importação do dono (EVID-187). (c) Fechar a janela no meio grava só o `-active.log`. "Só ao zerar a campanha" não se explica pelo código do cliente: fim por morte, extração ou vitória grava igual. Falta o que Daniel viu | Perguntar a Daniel; MEC pequeno (atualizar ao abrir a aba) |
| 4 | Textos aparecem um sobre o outro no meio da tela, mais com quest | IN-069 | **Causa encontrada.** Três blocos partilham o topo central: `ObjectiveLabel` em y=74 (`ui/hud.gd:113`, sem moldura, cresce para baixo), `BossPanel` em y=74 (`ui/hud.tscn`, mesma posição) e `ToastBox` em y=130 (até 4 avisos, largura 640). Cada objetivo, "Carregando: ...", juramento, buffs e Favor são uma linha: a partir da 3ª linha o rótulo invade os avisos (74 + 3×~22 > 130), e com chefe vivo colide com o nome e a barra | BUG novo P1 |
| 5 | Quests devem ter destaque visual maior | IN-070 | Hoje é uma linha de texto amarelo, 16 px, com contorno, sem painel nem ícone (`ui/hud.gd:108-120`, `core/happenings.gd:543-559`) | MEC novo |
| 6 | Itens necessários ou ligados às quests também com destaque | IN-071 | Há seta na borda só **fora da tela** (`ui/overlay.gd:542-575`, `markers()`); dentro da tela o item é um rótulo de 220 px colorido (`ui/overlay.gd:420,462`). Sem anel, brilho ou ícone fixo para item, alvo ou NPC da quest | MEC novo (junto de IN-070) |
| 7 | Revisar posição e espaçamento dos textos contra sobreposição, sobretudo com quests | IN-072 | Mesmo achado do item 4; cobre também o resto do HUD (prompt inferior, `WeaponsLabel`, `InfoLabel` do Estige) | Junto de IN-069 |

## Sinais cruzados
- Item 2 toca a mesma região do #4 do Manzi ([EVID-199](EVID-199-relato-t04-manzi-v032-2026-10-07.md)): abrir a ficha nas ofertas já existe no HEAD, mas fechar com C não; corrigir o fechamento e verificar a abertura nas ofertas no mesmo lote.
- Itens 4 e 7 são o mesmo defeito; item 6 reforça IN-064 do Manzi (estado do jogador pouco visível na HUD).
- Item 3 toca o PLAN-071 (SPEC-138, aceite de clientes finais ainda pendente): qualquer mudança no ranking é desvio do plano ativo.

## Limites
Relato único e indireto; reproduzir 1, 2 e 4 em run real antes de fechar o diagnóstico. "Quest" assumido como objetivo de acontecimento. O item 3 depende do que Daniel viu e do importador do dono (fora deste repositório).
