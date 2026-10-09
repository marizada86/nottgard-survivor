---
id: "EVID-221"
title: "PLAN-085: seta de evento na borda da tela, com distância (MEC-061)"
created: "2026-10-09"
spec: "SPEC-159"
cards: ["MEC-061"]
status: "implementado local; sem commit; sem exportação; aceite subjetivo pendente do playtest"
---

# EVID-221 — PLAN-085 (SPEC-159)

Pedido do dono (2026-10-09): quando houver um evento no mapa e ele estiver fora da parte visível da tela, uma seta indica onde ele está. Decisões: seta na borda com distância; todos os eventos de quest com posição; entra na **v0.4.0** (sem trocar a versão); em paralelo ao PLAN-084.

## O que mudou

| Arquivo | Mudança |
|---|---|
| `ui/event_pointer.gd` (novo) | `EventPointer`: `edge_point` (ponto na borda e ângulo), `box_rect`/`avoid` (a caixa seta + legenda foge da HUD e dos botões de toque, vira a legenda de lado e, sem vaga, fica onde a sobreposição é menor), `group` (fusão a menos de 40 px, no máximo 6 setas), `caption` (`Nome · 24 m`). Desenho em espaço de tela com pulso de 0,6 s na entrada |
| `ui/hud.gd` | cria o `EventPointer` (sob os painéis), passa o que ele deve evitar (pilha do topo, painel do herói, relógio, nome da fase, ícone da regra, slot de habilidade, botões de toque) e o esconde em pausa, oferta, ficha, fim e reviver |
| `core/happenings.gd` | `markers()` devolve `kind`, `label` (até 18 letras, sem o "[E/oeste]") e `key`; passa a incluir o centro da arena e a Estrela do Norte; Ecos e altares de segredos seguem fora |
| `ui/overlay.gd` | removidas as setas antigas do mundo (a 240 px do herói) de `_draw_happenings` e `_draw_star_path`; o anel e a seta que balança dentro da tela (SPEC-147) ficam, exceto em arena e Estrela do Norte, que têm desenho próprio |
| `tests/test_event_pointer.gd` (novo) | oito direções, alvo dentro, alvo sobre o herói, desvio (topo, esquerda, sem vaga, legenda à direita), fusão e limite de 6, legenda, `markers()` (itens, destino, usado, arena, estrela, Ecos fora, sem eventos) |
| `tools/capture_event_pointer.gd/.tscn` (novo) | captura em uma run real de Dagruve com eventos a 15 e 21 tiles (`-- --mobile` liga o toque; `-- --debug` imprime caixas) |

## Verificação (2026-10-09)

| Verificação | Resultado |
|---|---|
| `tests/test_event_pointer.gd` | 0 falhas |
| Mutação 1: fusão desligada (`< 0.0`) | o teste falha (1 falha) |
| Mutação 2: ponto da borda sem o `clamp` (×1,3) | o teste falha (9 falhas) |
| Suíte completa (`tests/run_all.gd`) | `testes: 0 falha(s)` |
| `tools/smoke.tscn` | `smoke: ok`, nove fases |
| `tools/kit_test.tscn` (janela) | `kit: OK` |
| `tools/audit_projeto.gd` | `erros=0; avisos=7` (os avisos já existiam: chefes sem entrada) |
| Run real, 1280×720 desktop | três setas: Altar do poço · 15 m (topo), Sobrevivente · 21 m (esquerda), Fragmento sagrado +1 · 15 m (base, fusão de dois); o item a 2,5 tiles não tem seta de borda, só o anel |
| Run real, 1280×720 com toque (`--mobile`) | a legenda do topo vira para a esquerda e a da base também, nenhuma cobre os botões 1x/Ajuda/Ficha/Pausa nem o slot de habilidade |

Capturas em `.atena/generated/mec-061-seta-de-evento/`: `setas_na_borda_1280x720.png`, `pulso_de_entrada_1280x720.png`, `mobile_setas_na_borda_1280x720.png`, `mobile_pulso_de_entrada_1280x720.png`. O instantâneo do `plan.yaml` antes do início está em `plan-before-085-start.yaml`.

## Limites desta evidência

- A janela de captura mantém a base 1280×720 mesmo com `--resolution 1920x1080` (esticamento da projeto); portanto **1920×1080 e proporção de celular (812×375) não têm captura própria**. A conta usa o retângulo da janela, então deve valer, mas está sem foto.
- Run real com evento nascido da própria lógica de `Happenings` (não colocado à mão) coberto por `markers()` no teste com o "portal sem vão"; a seta em uma partida inteira (andar até o evento e vê-la sumir) **não foi jogada**: depende do playtest do dono.
- Legibilidade, incômodo e clareza da seta são subjetivos e seguem **não verificados** até o playtest.

## Playtest que falta (explicado antes de entregar)

- **O que testar:** uma run de Dagruve (ou outra fase com evento) olhando se, com um evento fora da tela, aparece uma seta na borda com o nome e a distância; se ela some quando o evento entra na tela (e o anel assume); se atrapalha a HUD no PC e no celular; se a fusão de eventos próximos faz sentido.
- **Build:** exportação local da 0.4.0 refeita (ainda não feita; exportar, commitar e dar push exigem aprovação à parte).
- **Observar:** a seta aponta para onde o evento realmente está; a distância encurta ao andar; setas demais ou rápidas demais; legenda cortada ou sobre botão.
- **Critério de aceite:** o dono acha que a seta ajuda a achar o evento sem poluir a tela.
