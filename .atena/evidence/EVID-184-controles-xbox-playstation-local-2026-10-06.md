---
id: EVID-184
title: Experiência Xbox e PlayStation implementada localmente
created: 2026-10-06
kind: implementation-validation
origin: guided-add
implementation_preceded_spec: false
spec: "../specs/SPEC-135-experiencia-controles-xbox-playstation-2026-10-06.md"
plan: "../vault/drafts/PLAN-068-experiencia-controles-xbox-playstation-2026-10-06.md"
state: "../state/plan-068-controles-xbox-playstation.yaml"
---

# Entrega local P068-v01

O dono aprovou o escopo por plano, incluindo a revisão da convenção canônica e as abas L1/LB anterior, R1/RB próxima. Depois de escolher execução após mobile, disse “vamos lá” neste chat em 2026-10-06. A entrega mobile local já estava commitada em `503ccec4003efff9260821214e75bf49c1b6ab0b`; seu aceite nativo continua pendente. PLAN-068 foi ativado com suspensão recuperável desse checkpoint e preservação do retorno a Durvall e de DEV-003. Nenhum commit, export, publicação ou instalação foi executado neste plano.

## Resultado por lote

- B-001/S-001–003: baseline preservada de 108 arquivos em [recovery](../generated/controller-experience/v01/recovery/), com [hashes](../generated/controller-experience/v01/baseline-files.json). Helper local filho de Game centraliza dispositivos, zonas mortas, bindings e prompts, sem novo autoload. Padrão sul confirma/leste volta e Legado invertido. Y/△ alterna mira; direcional move/navega; extração e velocidade têm caminhos pela pausa. Desconexão ou perda de foco limpa comandos; retorno explícito mantém contexto de oferta.
- B-002/S-004–006: 52 SVGs locais em Xbox, DS4, DualSense e Genérico, incluindo movimento, mira e direcional; sem pack externo ou dependência. Prompts no título, HQ, habilidade, ficha, HUD, pausa, ofertas, opções e guia. Override visual é independente da função. Share/Create têm desenhos distintos; dispositivo emulado como XInput não comprova o fabricante físico.
- B-003/S-007–009: abas dos detalhes têm prioridade sobre habilidade/rerrolagem, inclusive sobre oferta; foco retorna à oferta ou pausa anterior. Direcional atravessa Herói → Fase → Jogar; listas conservam navegação interna, códex/conquistas podem rolar e opções acompanham foco. R3/RS alterna detalhes. Abandono, extração e recusa/venda exigem confirmação. Captura/remapeamento limita botões, rejeita conflitos e reserva recuperação; ajustes opcionais persistem em perfil separado.
- B-004/S-010 e parte local de S-012: verificações descritas abaixo, piloto e documentação reconciliados. S-011 e conclusão de S-012 dependem de playtest físico. Estado **AWAITING_HARDWARE_PLAYTEST**, sem declarar o plano completamente aceito.

## Validação local

Godot instalado: **4.7.2 stable**, `D:\Godot\godot.exe`. Perfil real preservado nos verificadores; cenários e preferências usam perfis descartáveis. Os testes de integração injetam eventos e preparam cenários determinísticos: não são um jogador realizando uma tentativa física completa.

| Verificação | Resultado e evidência |
|---|---|
| Suíte completa | Zero falhas; [suite.log](../generated/controller-experience/v01/suite.log) |
| Jornada por controle | 90 verificações, zero falhas; [relatório](../generated/controller-experience/v01/integration-report.json), [log](../generated/controller-experience/v01/integration.log). Título, Quartel, HQ, foco, quatro famílias/abas, pausa, confirmação, desconexão, oferta, dez habilidades/recarga, inventário sobre oferta, escolhas, revive, persistência/reload, repouso de 60 s, resultado e nova tentativa |
| Mobile e mouse emulado | 144 verificações, zero falhas; [relatório desta regressão](../generated/controller-experience/v01/mobile-buttons-report.json), [log](../generated/controller-experience/v01/mobile-buttons.log). Snapshot do relatório mobile anterior preservado; esta execução não reabre seu aceite nativo |
| Nove fases desktop | Smoke OK; [log](../generated/controller-experience/v01/desktop-smoke.log) |
| Nove fases mobile | Smoke OK; [log](../generated/controller-experience/v01/mobile-smoke.log) |
| Importação de SVG e compilação | Importação concluída com exit 0; [log](../generated/controller-experience/v01/import-final.log). Runtime e suíte compilaram as mudanças |
| Lançador local | Cena do piloto iniciou com exit 0 em prova limitada; [log](../generated/controller-experience/v01/pilot-launch-check.log) |

As execuções da suíte ainda exibem os avisos de encerramento já observados na baseline: 3 CanvasItem RIDs, 30 objetos e 5 recursos. Smoke exibe 4 objetos/2 recursos; regressão mobile exibe 6/3. Estes diagnósticos de encerramento ficam visíveis, separados do resultado das verificações. O ambiente restrito também impede cache de shader e gravação das preferências globais do editor em AppData; a importação e as capturas locais terminaram. Nenhuma alteração de permissão foi feita para contornar isso.

## Capturas e aceite visual

HUD, ficha, oferta, pausa, controles, Quartel e resultado foram capturados em janela 1280×720 e 1920×1080; ficha também com as quatro famílias. Inspeção visual verificou ícones, categorias, contador, foco e legibilidade. A rolagem dos ajustes mantém Fechar controles acessível; itens abaixo da dobra são alcançados pela rolagem. Exemplos:

- [Ficha PlayStation 720p](../generated/controller-experience/v01/ficha_ps5_1280x720.png), [1080p](../generated/controller-experience/v01/ficha_ps5_1920x1080.png).
- [Ficha Xbox](../generated/controller-experience/v01/ficha_xbox.png), [HUD Xbox](../generated/controller-experience/v01/hud_xbox_1280x720.png).
- [Controles 720p](../generated/controller-experience/v01/opcoes_ps5_1280x720.png), [1080p](../generated/controller-experience/v01/opcoes_ps5_1920x1080.png).
- [Pausa](../generated/controller-experience/v01/pausa_ps5_1280x720.png), [oferta](../generated/controller-experience/v01/oferta_ps5_1280x720.png), [resultado](../generated/controller-experience/v01/resultado_xbox_1280x720.png).

Estas capturas usam override visual PlayStation e eventos sintetizados, não um DualSense físico. Tela cheia e ergonomia no monitor do dono permanecem parte do playtest físico; não atribuir essas provas a uma conexão USB/Bluetooth.

## Cobertura dos critérios da SPEC-135

1–3: jornada sintética e consequências protegidas, com Padrão/Legado e colisões removidas. 4: dez habilidades/recarga e norma/zona morta testadas; intensidade/última mira percebida aguardam hardware. 5–6: catálogo, bindings, override e repouso local de 60 s; reconhecimento físico por modelo pendente. 7: quatro abas e foco de retorno testados, com oferta de fundo preservada; ergonomia de grades/sliders/repetição aguardam o dono. 8: conexão/foco e segundo dispositivo simulados; reconexão USB/Bluetooth real pendente. 9: defaults, conflitos e reload testados com perfil separado. 10: suíte/mobile/smoke aprovados. 11: capturas em janela aprovadas; tela cheia do dono pendente. 12: **não realizado**. O conjunto permite entregar o piloto, sem inventar aceite físico.

## Matriz física e retorno

O dono informou **“xbox”**. Godot detectou ID 0, nome `XInput Controller`, GUID `0300fa675e0400008e02000010017801`. Isso comprova enumeração pelo Godot, sem comprovar modelo, transporte ou botões operados fisicamente. Modelo Xbox, USB/Bluetooth e resultados continuam a informar; DS4 e DualSense não testados. Alvo é Windows PC.

Piloto [Abrir-teste-Xbox.cmd](../generated/controller-experience/v01/Abrir-teste-Xbox.cmd), [guia](../generated/controller-experience/v01/Como-testar-Xbox.md), [manifesto](../generated/controller-experience/v01/pilot-manifest.json). Identificação P068-v01 com fingerprint dos fontes locais; não é versão exportada nem commit novo. Ajustes/progresso em `pilot-profile.json`, separados do save real.

MEC-050/ART-037 ficam IMPLEMENTADO LOCAL, aguardando playtest. INPUT-CONTROL-001 foi reconciliado somente no escopo aprovado. O estado mantém retorno a PLAN-067 no checkpoint nativo e a PLAN-066/Durvall; DEV-003 permanece pendente. Não há autorização de Git/publicação neste checkpoint.

Validação documental/fingerprint da entrega: [delivery-validation.json](../generated/controller-experience/v01/delivery-validation.json), contrato e links aprovados. YAML conferido por verificações estruturais limitadas, sem parser YAML completo. Backlog: P0=0, P1 abertos=4 (BUG-025/027/028/029), P1 implementados aguardando playtest=7, verificações manuais=8 e zero alertas de organização; estes bugs preexistentes continuam visíveis.
