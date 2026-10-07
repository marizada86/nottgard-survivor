---
id: EVID-180
plan: PLAN-067
spec: SPEC-134
batch: B-001
created: 2026-10-06
status: LOCAL_PASS_DEVICE_PENDING
---

# Combate por toque — prova local

Execução autorizada por plano: escolha 1 e confirmação "sim, mobile agora". PLAN-066 foi suspenso com retorno em B-002/S-005 antes da implementação. SPEC-134 precedeu o código; não é spec post-hoc.

Joystick flutuante com raio 72 e zona morta 15%, exclusivamente para andar. Cada dedo tem proprietário; normalização impede aceleração diagonal. Habilidade, interação contextual, ficha, pausa, ajuda, velocidade e extração têm comandos independentes. Habilidade usa mira automática sem alterar a preferência desktop salva. Extração e abandono pedem confirmação. Modais, segundo plano, perda de foco e saída da cena limpam a entrada.

Arquivos envolvidos: core/game.gd, ui/mobile_controls.gd, ui/run.gd, ui/hud.gd e ui/ability_slot.gd. São uma camada local de entrada e encaminhamento para regras existentes; não há alteração de números de combate ou dependências. A mira das habilidades foi verificada nos dez heróis com alvo válido.

## Provas

- Suíte completa com Godot 4.7.2: `testes: 0 falha(s)`; [tests.log](../generated/mobile-controls/v01/tests.log). O encerramento mantém avisos já observados na linha de base: 3 CanvasItem RIDs, 22 ObjectDB e 4 recursos em uso. Um aviso de foco introduzido na iteração foi corrigido com checagem de existência/visibilidade antes do foco adiado; não reaparece no resultado final.
- tests/test_mobile_controls.gd cobre dois dedos, habilidade uma vez por toque, soltura, zona morta, modal sem reutilizar dedo, interface sem movimento, área segura com recortes simulados, preferência de mira e desktop sem controles touch.
- Integração com InputEventScreenTouch/Drag enviados ao viewport: deslocamento real via run, habilidade simultânea, dez habilidades, ficha abrindo/fechando por toque, loja contextual, extração com confirmação/cancelamento e perda de foco. Resultado `mobile integration: 0 falha(s)`; [capture-stdout.log](../generated/mobile-controls/v01/capture-stdout.log) e [capture.log](../generated/mobile-controls/v01/capture.log).
- Smoke mobile nas nove fases: todas abertas em estado running, `smoke: ok`; [smoke-mobile.log](../generated/mobile-controls/v01/smoke-mobile.log).
- Perfil descartável em generated/mobile-controls/v01; a integração compara a assinatura do save real antes/depois e passou sem alteração. Snapshots dos arquivos anteriores estão em recovery/; nenhum descarte global da árvore.

Os eventos multitouch são sintetizados no PC. Não comprovam hardware de celular, ergonomia, sistema operacional ou desempenho nativo. Teclado/controle têm regressão automatizada; teste com controle físico real permanece parte do playtest humano.

## Aceite

Critérios 1–4 e 8 passam no cenário local. Critério 7 passa na regressão automatizada (inclui oferta desktop direta e mira salva); ergonomia física permanece pendente. Critérios 5–6 têm implementação e prova parcial local descritas em [EVID-181](EVID-181-mobile-menus-local-2026-10-06.md). Critério 9 permanece pendente. Sem canon, commit, exportação nativa ou instalação.
