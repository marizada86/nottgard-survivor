---
id: "EVID-251"
title: "BUG-044 (volume) e BUG-045 (tela de resultado) corrigidos"
created: "2026-10-14"
relations: ["[[EVID-250-relato-t05-mariz-v040-2026-10-14]]"]
cards: ["BUG-044", "BUG-045"]
content_state: DRAFT
---

# EVID-251 — BUG-044 e BUG-045 (lote aprovado pelo dono em 2026-10-14, por plano, sem commit)

Origem: relatório do T05 (Mariz), [EVID-250](EVID-250-relato-t05-mariz-v040-2026-10-14.md) IN-077 e IN-080.

## BUG-044 — volume
- `core/game.gd`: `apply_settings()` virou `apply_audio()` (volume mestre e canais) + `apply_window()` (modo, borda, resolução). Contador `window_apply_count` só para teste.
- `ui/options_panel.gd`: sliders e mudos chamam `Game.apply_audio()`; o save (com backup) é gravado uma vez, 0,4 s depois do último passo, ao esconder o painel ou ao sair da árvore (`flush_save`).
- `ui/hud.gd`: o volume da pausa chama `apply_audio()` e grava ao soltar o slider (`drag_ended`); antes só aplicava e não gravava.
- Modo de tela e resolução continuam reaplicando a janela.

## BUG-045 — tela de resultado
- `ui/hud.gd`: a lista do resultado fica num `ScrollContainer` com altura limitada à tela (menos título, botões e folga de 140 px); título e botões ficam sempre visíveis.
- `achievement_line`: conquista só de moedas mostra "+N moedas"; sem recompensa não deixa travessão solto.

## Verificação
- Teste novo `tests/test_volume_and_result_panel.gd`: 80 passos de slider não reaplicam a janela; save fica pendente e `flush_save` zera; trocar o modo reaplica uma vez; resultado com 16 conquistas cabe na tela (painel, botão e título); linhas de conquista.
- **Mutação:** sem o teto de altura e com o áudio reaplicando a janela, o teste falha (76 reaplicações; painel de 100151 px); restaurado, passa.
- Suíte completa: 0 falhas.

## Não verificado
- Humano: arrastar o volume em tela cheia e ver que a janela não pisca; ver a tela de derrota com muitas conquistas em 1280x720 e 1920x1080 (o teste usa o viewport de teste). Causa do BUG-044 vinha de leitura de código; o relato original era vago.
