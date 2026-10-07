---
id: EVID-183
plan: PLAN-067
spec: SPEC-134
created: 2026-10-06
request_classification: IN_PLAN
status: LOCAL_CORRECTION_VALIDATED_NATIVE_PENDING
---

# Joystick nos dois lados e verificação dos botões

O dono relatou que o joystick não funcionava à direita, autorizou a correção e pediu teste de todos os botões. Ajuste IN_PLAN no escopo mobile per-plan: joystick exclusivamente para andar na arena livre de qualquer lado. SPEC-134 recebeu o esclarecimento antes da correção. Plano limitado: reproduzir a restrição, corrigir entrada, testar comandos/botões e reconciliar. Sem canon ou mudança material de arquitetura; gates nativos preservados.

## Causa e correção

ui/mobile_controls.gd restringia a origem aos 45% da esquerda. A prova nova reproduziu três falhas relacionadas ao joystick direito antes da correção ([before-fix-tests.log](../generated/mobile-controls/v02/before-fix-tests.log)). A condição lateral foi removida; permanecem a região inferior utilizável, a prioridade da UI e um único dedo de movimento. Mira, velocidade de gameplay e disposição dos botões mantêm suas regras. A ajuda em ui/run.gd indica qualquer lado.

O teste ampliado encontrou também: consulta do viewport após um botão trocar a cena e duplicação touch/mouse emulado em seletores e Fechar ajuda. ui/touch_ui.gd conserva o viewport durante o callback e intercepta OptionButton, abrindo o popup após a sequência do toque. core/playtest.gd prepara o router da ajuda global; o router distingue esse modal da UI de fundo.

Arquivos da revisão: ui/mobile_controls.gd, ui/touch_ui.gd, ui/run.gd, core/playtest.gd, tests/test_mobile_controls.gd, tools/mobile_preview.gd; novo harness tools/mobile_buttons_check.gd/.tscn. Piloto P067-v02 com perfil separado. Launcher v01 encaminha ao piloto atualizado; capturas e evidências anteriores preservadas. Recovery v02 conserva os arquivos anteriores; run.gd/touch_ui.gd foram reconstruídos revertendo apenas esta revisão e comparados aos hashes v01.

## Validação

Godot 4.7.2 em D:/Godot/godot.exe. Prova com renderização OpenGL Compatibility injeta touch/drag e mouse emulado intercalados no viewport, verificando callbacks reais e emissão única. Diálogos embutidos recebem o caminho de mouse emulado do toque. São eventos sintetizados no PC, não dedos em aparelho físico.

[buttons-report.json](../generated/mobile-controls/v02/buttons-report.json): **144 verificações, zero falhas**; [capture-stdout.log](../generated/mobile-controls/v02/capture-stdout.log), [capture.log](../generated/mobile-controls/v02/capture.log), stderr final vazio. O harness reaproveita a integração anterior, incluindo os dez heróis, modais, foco e layouts; suas falhas entram no mesmo resultado.

| Grupo | Efeito verificado |
|---|---|
| Joystick | Ambos os lados, habilidade simultânea, posse do dedo, soltura/cancelamento e recarga |
| Combate | Habilidade, interação/loja, Ficha, Pausa, Ajuda e ciclo 1x/1,5x/2x em fase vencida |
| Ficha | Quatro abas, detalhes CA/CAM e Fechar |
| Pausa | Continuar, ajuda/Fechar, volume, abandono com Confirmar/Cancelar |
| Ofertas | Rerrolar, selecionar/confirmar melhoria, aceitar/recusar bênção, compra/saída de loja, equipar/manter com venda |
| Reviver/resultado | Reviver/encerrar, extrair com Confirmar/Cancelar, Jogar de novo e voltar ao Quartel |
| Quartel | Entrada pelo título, Jogar, seis abas, herói/fase, melhoria, Códex/categoria/detalhe, Diário/HQ |
| Opções | Quatro volumes, três silenciadores, impacto/falas, dificuldade, guia/Fechar e opções desktop intencionalmente inativas |
| Apagar progresso | Confirmação em dois toques, exclusivamente no perfil descartável; save real preservado |
| HQ | Abrir, Próximo e Fechar |

Os sete comandos do overlay são testados também na suíte de entrada, com prioridade sobre movimento e emissão única. Listas/ofertas mantêm prova de arrasto sem compra e confirmação única. Suíte completa final zero falhas ([tests.log](../generated/mobile-controls/v02/tests.log)); mantém avisos de limpeza já presentes na linha de base, sem novo erro de script. Smoke mobile nove fases running, smoke ok ([smoke-mobile.log](../generated/mobile-controls/v02/smoke-mobile.log)). Contrato/links e hashes em [reconciliation.json](../generated/mobile-controls/v02/reconciliation.json) e [manifest.json](../generated/mobile-controls/v02/manifest.json).

Capturas 16:9/20:9/4:3 regeneradas; [joystick direito](../generated/mobile-controls/v02/joystick-direita.png) inspecionado visualmente. [Abrir piloto](../generated/mobile-controls/v02/Abrir-teste-mobile.cmd).

Referência técnica usada no diagnóstico de duplicação: código oficial de [BaseButton 4.7](https://github.com/godotengine/godot/blob/4.7/scene/gui/base_button.cpp) e [OptionButton](https://github.com/godotengine/godot/blob/4.7/scene/gui/option_button.cpp), que encaminham eventos touch e abrem o seletor. A prova local confirma o efeito das correções.

## Aceite e limites

A correção e os testes pedidos estão concluídos localmente; cobertura dos caminhos do critério 5 ampliada. Tentativa completa com dedos reais, ergonomia/dp/recortes e desempenho de dez minutos em celular seguem pendentes. PLAN-067 permanece AWAITING_DEVICE_VALIDATION; Durvall e demais pedidos pós-mobile preservados. Sem ferramenta nova, APK, instalação, publicação, canon ou commit.
