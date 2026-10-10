# EVID-235 — Transição jogo ↔ janela mais suave: fade e fundo translúcido (2026-10-10)

**Origem:** dono, com o print da ficha C: "agora vamos melhorar a opacidade para deixar a troca entre jogo e menu mais suave".
**Escolhas do dono (2026-10-10):** efeito = fade na troca **e** fundo mais translúcido; telas = ficha do herói (C), menu de pausa (Esc), resultado da fase e revive. Ofertas de level-up ficaram de fora.
**Desvio:** DEV-033 (PLAN_DEVIATION do PLAN-071); rota "fazer agora e voltar".

## Mudança
- `UiKit` ([ui/ui_kit.gd](../../ui/ui_kit.gd)): `FADE_IN = 0,14 s`, `FADE_OUT = 0,18 s`, `WINDOW_ALPHA = 0,9` (fundo da janela padrão; a moldura segue opaca), `DIM_ALPHA = 0,5` (era 0,7).
- `UiKit.fade_in(node)`: a janela sai de transparente a opaca; o `visible` muda na hora. O fade começa dois quadros depois (abrir é o quadro mais pesado e o delta dele comeria o fade). Funciona com o jogo pausado. Cancela o fade anterior; janela escondida antes de começar volta a alfa 1.
- `UiKit.dissolve_from_screen(tree)`: antes de esconder a janela, tira uma foto da tela e a dissolve por cima do jogo, que já voltou ao vivo (`CanvasLayer` 90, some sozinho). Não altera `visible` nem a lógica que consulta as janelas.
- `ui/hud.gd`: ficha, pausa, revive e resultado abrem com fade (só quando não estavam abertos); ficha, pausa e revive fecham com dissolução.
- `fades_enabled()` é falso em `qa_sandbox`: capturas e verificações não pegam janela pela metade; `dissolve_from_screen` não faz nada em `--headless`.
- Resultado e revive não usam o `UiKit.window`: ganham só o fade (sem fundo mais translúcido).

## Verificação
- Sonda `tools/probe_fade.tscn` (quadro a quadro): alfa 0,00 → 0,00 → 0,12 → … → 1,00 em ~140 ms, `visible` verdadeiro desde o primeiro quadro.
- Capturas em `.atena/generated/dev-033/capturas/` (`tools/capture_transition.tscn`): ficha fechando mostra a ficha dissolvendo sobre o jogo ao vivo; pausa aberta mostra o jogo atrás do fundo translúcido.
- Suite 0 falhas; smoke ok; `kit_test` OK; `mobile_buttons_check` 146/0; `controller_check` 90/0.

## Pendências / honestidade
- Suavidade e legibilidade com o fundo a 90% são **subjetivas**: aguardam o playtest do dono. Os números (0,14 s, 0,18 s, 0,9, 0,5) ficam no topo do `UiKit` para ajuste.
- A dissolução usa uma foto da tela inteira (HUD incluída): se o HUD mudar durante os 0,18 s, a foto fica levemente defasada. Leitura da imagem custa alguns ms uma vez por fechamento; não medi em celular.
- Não cobertos: ofertas de level-up, Quartel (troca de abas) e título.
- Não observei a transição ao vivo com controle ou toque.
