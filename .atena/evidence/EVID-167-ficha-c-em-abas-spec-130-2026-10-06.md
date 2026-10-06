---
id: "EVID-167"
title: "Ficha C em abas, grade de ícones e detalhe (SPEC-130, PLAN-063)"
created: "2026-10-06"
relations: ["[[SPEC-130-ficha-c-em-abas-grade-e-detalhe]]", "[[EVID-163-relato-t04-manzi-sylas-2026-10-05]]"]
cards: ["MEC-045", "ART-035"]
---

# EVID-167 — Ficha C reorganizada (layout primeiro)

**Natureza:** implementação e verificação local, mesma sessão. Molduras desenhadas por código; **sem arte nova** (ART-035 continua a escrever, ver abaixo).

## O que mudou
- Novo `ui/character_sheet.gd` (`CharacterSheet`) e `ui/sheet_slot.gd` (`SheetSlot`). `ui/hud.tscn` perdeu os nós antigos do `ItemsPanel`; `ui/hud.gd` cria a ficha em `_ready` e mantém `show_items_panel`/`hide_items_panel`/`items_closed`.
- Decisões D1 a D12 da SPEC-130 implementadas: coluna do herói fixa (retrato, FOR/INT/CON/CAR, PV, CA e CAM com ícone e % de esquiva, cartão da habilidade), 4 abas (Armas e feitiços, Equipamento, Passivas e bênçãos, Sinergias e bônus), grade com slots vazios, borda por raridade, selo de nível (dourado no máximo), seta pulsante de evolução, detalhe embaixo em largura total, bônus totais agrupados (Ofensivo, Defensivo, Utilidade).
- Navegação: Q/E e LB/RB trocam de aba (`_input` da ficha); setas/direcional movem o foco entre slots; mouse sobre o slot passa o foco; clique troca de aba.
- CA e CAM: botões focáveis na coluna do herói; ao focar ou passar o mouse, o painel de detalhe mostra o texto de ajuda (`CharacterSheet.defense_tip`), com `tooltip_text` nativo para o mouse. **Texto da ajuda ainda precisa de validação do dono (lacuna G1).**
- Equipamento passou a mostrar os mods **escalados pelo nível** (`Items.scaled_mods`) e o bônus de nível máximo; antes a ficha mostrava os mods base.
- `tests/test_ability_hud.gd` ajustado: lê o cartão da habilidade da nova ficha em vez do `RichTextLabel` antigo.

## Verificação
| Verificação | Resultado |
|---|---|
| `tests/run_all.gd` (inclui `test_character_sheet.gd` novo: 4 abas, ciclo Q/E, slots vazios por herói em 10 heróis, equipamento cheio com borda por raridade e selo de nível máximo, passivas e bênçãos, bônus sem repetição, textos de CA/CAM e de recarga, fallback de ícone) | 0 falhas |
| `tools/audit_projeto.gd` | erros=0, avisos=7 (os mesmos 7 de antes; nenhum novo) |
| Capturas (`tools/capture_character_sheet.tscn`, `.atena/generated/spec-130/`) | herói em início de run e herói cheio, 4 abas cada, em Sylas; Durvall (aba 0 cheia) e Brook (aba 3 início); foco em CA mostrando a ajuda |

**Resoluções:** o projeto usa `stretch/mode=canvas_items` com aspecto padrão (`keep`), então o espaço lógico fica sempre em 1280×720 e a ficha (1090×610) escala com a janela. As execuções com `--resolution 1920x1080` e `1024x768` produziram o mesmo tamanho lógico; **não há captura em janela real de outra proporção**. Fica para o playtest (BUG/QA).

## Limites e pontos para decisão do dono
1. Espaço vazio entre a grade e o detalhe nas abas com poucos itens (ex.: início de run). Opções: aumentar o slot (76 → 88 px), ou deixar o detalhe crescer.
2. Foco na CA/CAM só mostra a ajuda no painel de detalhe (à direita), não um balão ao lado do número.
3. Aba de passivas com 9 passivas e 3 bênçãos cabe em 1280×720 sem rolagem; mais que isso rola (a rolagem segue o foco).
4. Não testado com controle físico (LB/RB, direcional); só por leitura do código e do mapa de ações.
5. ART-035: prompts de moldura, slot, ícones de aba e fundo do detalhe ainda não escritos (decisão do dono: layout primeiro).
