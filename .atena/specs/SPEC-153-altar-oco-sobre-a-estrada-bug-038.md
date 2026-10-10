---
id: SPEC-153
title: Altar oco sobre a estrada (BUG-038)
status: "IMPLEMENTADA e publicada em 2026-10-08 (EVID-210, e1933be); aguarda a arte do altar animado (ART-044)"
origin: post-hoc
implementation_preceded_spec: true
created: 2026-10-08
approval: pedido direto do dono no chat em 2026-10-08 (Direct Execution); registro e reconciliação autorizados pelo dono ("atena sim, registre no backlog e reconcilie")
plan: nenhum plano próprio; desvio DEV-015 do PLAN-071
---

# SPEC-153

## Registro post-hoc
A correção de código precedeu esta spec. O dono enviou um print do altar sobre a estrada de Dagruve com a hipótese "ele deve vir à frente do asset da estrada". A Atena investigou, corrigiu como Direct Execution e só depois, a pedido do dono, registrou cartões, evidência e esta spec. Não há aprovação de spec ou plano anteriores a reconstruir.

## Pedido
O altar de bênção aparece "bugado" sobre a estrada. O dono supôs ordem de desenho (altar atrás da estrada).

## Diagnóstico
A hipótese de ordem de desenho não se sustenta: `ui/overlay.gd` desenha as interações no overlay `over` (`z_index` 60, `tools/build_scenes.gd`), e os decais e estradas ficam em `z_index` -90 (`ui/ground_decals.gd`). O defeito está na arte: no sheet `assets/animations/interactions/altar_active.png` (1152×192, 6 quadros) o corpo de pedra tem alfa 0; só poço, brasas e velas são opacos. O overlay prefere o sheet ao sprite estático, então o chão e a estrada apareciam através do altar. O sprite `assets/interactions/altar_active.png` (192×192) está íntegro.

## Escopo
- `ui/overlay.gd` (`_draw_over`): a animação em repouso não se aplica ao `kind == "altar"`; ele desenha o sprite estático completo, na mesma altura (80 px).
- Não muda: a animação de ativação em `ui/run.gd` (`_play_interaction`), fonte, ritual, portal e baús, `data/`, o sheet em si.

## Efeito e risco
O altar fica sólido sobre qualquer chão ou estrada e perde o brilho animado das chamas enquanto espera. Reverter: remover `or String(it.kind) == "altar"` da condição.

## Aceite
- `ui/overlay.gd` carrega sem erro no Godot 4.7.2 e `test_animation_assets` passa com 0 falhas (EVID-210).
- Captura de Dagruve com o altar sobre a estrada mostra o corpo de pedra opaco (EVID-210).
- Pendente: olho do dono numa run real (cartão BUG-038 fica "aguarda playtest"); suíte completa (`tests/run_all.gd`): 0 falhas em 2026-10-08 (EVID-210).
- Pendente: sheet novo com corpo opaco (ART-044) para devolver a animação.
