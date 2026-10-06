---
id: "EVID-168"
title: "HUD da run no padrão da ficha C (SPEC-131, PLAN-064)"
created: "2026-10-06"
relations: ["[[SPEC-131-hud-da-run-no-padrao-da-ficha-c]]", "[[EVID-167-ficha-c-em-abas-spec-130-2026-10-06]]"]
cards: ["MEC-048"]
---

# EVID-168 — HUD do herói no padrão da ficha C

**Natureza:** implementação e verificação local, mesma sessão. Moldura desenhada por código; sem arte nova.

## O que mudou
- Novo `ui/hero_panel.gd` (`HeroPanel`): retrato quadrado, nome em ouro, `Nv N`, dica `[C] Ficha`, barra de PV com ícone de coração e faixa azul de barreira (`+N` no valor), barra de XP fina (pulso da SPEC-116 mantido), atributos FOR/INT/CON/CAR nas cores da ficha, chips de ícone e valor (moeda, abates, CA e CAM com % de esquiva) e fileira de ícones das bênçãos ativas (só aparece com bênção; sem ícone, quadrado com a inicial).
- Tooltips: CA e CAM com o texto da ficha C sem BBCode (`CharacterSheet.plain_text`, agora estática), atributos com o nome completo, bênçãos com nome, deus e descrição. Os controles com tooltip usam `MOUSE_FILTER_PASS` e o resto `IGNORE`, para o painel não roubar cliques da arena.
- `ui/hud.tscn` perdeu `NameLabel`, `HpBar`, `HpLabel`, `XpBar`, `ActiveLabel`, `ActiveIcon` e `ItemsHintLabel`; ficou só o `InfoLabel` (linhas do Estige, oculto quando vazio). `ui/hud.gd` monta o `HeroPanel` e delega a ele; `tools/build_scenes.gd` acompanha.
- `tests/test_ability_hud.gd`: removida a checagem dos nós antigos.

## Verificação
| Verificação | Resultado |
|---|---|
| `tests/run_all.gd` (inclui `tests/test_hero_panel.gd` novo: formatos de PV, barreira e CA/CAM, BBCode removido, nome, nível, PV, CA/CAM, moedas, abates e atributos em todos os heróis, retrato, tooltips de CA/CAM, fileira de bênçãos oculta e depois com 2 ícones, fallback sem ícone, pulso de XP) | 0 falhas |
| `tools/audit_projeto.gd` | erros=0, avisos=7 (os mesmos de antes) |
| Capturas `tools/capture_hero_panel.tscn` (Sylas, Durvall, Brook; início, herói cheio com barreira e 3 bênçãos, Estige) em `.atena/generated/spec-131/` | painel legível, sem corte; linha do Estige abaixo do painel |

## Limite da verificação
- **Só uma resolução:** a janela de captura ficou em 1280×720 mesmo com `--resolution` (o `stretch` do projeto mantém a base 1280×720), então a captura em segunda resolução do critério de aceite **não foi obtida**. O layout usa o mesmo canvas base nas duas.
- Tooltips só foram checados por teste (texto), não com o mouse em jogo.
- A HUD ficou mais alta (~170 px contra ~110 px); o fundo é translúcido (70%). Aguarda o olhar do dono em jogo.
