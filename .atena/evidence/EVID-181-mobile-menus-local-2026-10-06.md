---
id: EVID-181
plan: PLAN-067
spec: SPEC-134
batch: B-002
created: 2026-10-06
status: LOCAL_IMPLEMENTED_DEVICE_PENDING
---

# Menus e layouts por toque

TouchUI prepara áreas de toque e confirma botões/listas na soltura. Arrastar mais de 12 pixels rola e cancela seleção/compra; o mouse emulado não duplica comandos interceptados. OptionButton, sliders, abas e janelas continuam com entrada padrão do Godot. Modais globais de ajuda/anotação/QA mantêm a propriedade de seus eventos.

No perfil mobile, ofertas selecionam uma carta e mostram detalhes antes de Confirmar escolha; nova oferta limpa a seleção. Desktop mantém escolha direta. A ficha tem Fechar acessível e dispensa dicas Q/RMB/LB/RB. HQs ganham Próximo/Fechar. Menus preservam opções e custos existentes; preferências de mira/janela desktop não são sobrescritas. Listas e botões reconstruídos recebem novamente o dimensionamento touch.

Arquivos: ui/touch_ui.gd, ui/menu.gd, ui/character_sheet.gd, ui/hq_screen.gd, ui/hero_panel.gd e ui/hud.gd; project.godot usa canvas_items com aspect expand e emulação de mouse para menus. Sem assets novos ou redesign de arte.

## Validação

[EVID-180](EVID-180-mobile-combate-local-2026-10-06.md) registra a suíte e a integração. Testes verificam seleção sem aplicação, confirmação única, nova oferta limpa, arrasto sem compra, toque com compra única e ausência de duplicação por mouse emulado. Integração verifica oferta, ficha e avanço/fechamento de HQ por eventos touch.

Capturas reais via OpenGL Compatibility/GTX 1650, inspecionadas visualmente em 1280×720 (16:9), 1600×720 (20:9) e 1280×960 (4:3), com viewport expandido:

- [Combate 16:9](../generated/mobile-controls/v01/combate-16x9.png), [20:9](../generated/mobile-controls/v01/combate-1600x720.png), [4:3](../generated/mobile-controls/v01/combate-1280x960.png).
- [Ficha 16:9](../generated/mobile-controls/v01/ficha-16x9.png), [20:9](../generated/mobile-controls/v01/ficha-1600x720.png), [4:3](../generated/mobile-controls/v01/ficha-1280x960.png).
- [Menu 16:9](../generated/mobile-controls/v01/menu-1280x720.png), [20:9](../generated/mobile-controls/v01/menu-1600x720.png), [4:3](../generated/mobile-controls/v01/menu-1280x960.png).
- [Oferta selecionada](../generated/mobile-controls/v01/oferta-16x9.png).

Controles de combate também passam em retângulos seguros com margens assimétricas simuladas. A área segura nativa é consultada pelo código; recortes reais e dimensionamento mínimo em dp ainda precisam de aparelho. As abas, sliders, diálogos nativos e textos densos exigem avaliação de conforto nessa etapa.

Critério 5: caminhos implementados para título, Quartel, opções, ajuda, decisão, compras/equipar/vender, reviver/recusar e resultado, reutilizando regras existentes. A prova local cobre cenas principais e os casos acima; não equivale a uma tentativa inteira somente por toque nem a cada estado raro no aparelho. Critério 6: layouts locais aprovados tecnicamente, aceite humano de legibilidade/conforto e recortes reais pendente. Não declarar esses dois critérios encerrados.

## Piloto disponível

[Abrir-teste-mobile.cmd](../generated/mobile-controls/v01/Abrir-teste-mobile.cmd) abre o jogo pelo Godot instalado com perfil separado e versão local P067-v01. Mouse permite experimentar o gesto do joystick com um dedo; simultaneidade foi testada por eventos sintetizados. [LEIA-ME](../generated/mobile-controls/v01/LEIA-ME.txt) explica limites e recuperação. Esse launcher não é um executável exportado nem APK.
