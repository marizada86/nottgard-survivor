---
id: "EVID-172"
title: "Lettering e cursor: B-001 (prompts) e B-002 (esqueleto de código) do PLAN-065"
created: "2026-10-06"
relations: ["[[SPEC-132-lettering-e-cursor-do-jogo]]", "[[PLAN-065-lettering-e-cursor-2026-10-06]]", "[[ART-PROMPTS-058-lettering-placas-e-cursor]]", "[[CHATGPT-FILA-026-lettering-placas-e-cursor]]"]
cards: ["ART-039", "ART-040", "MEC-058"]
---

# EVID-172 — B-001 e B-002 do PLAN-065

**Natureza:** implementação e verificação local, mesma sessão. Aprovação do dono: plano inteiro (por plano), "começa pela B-001 e B-002", 2026-10-06. **Sem arte nova**: o esqueleto roda com fallback.

## B-001 — direção, inventário e prompts
- Inventário das strings de UI (código e `.tscn`) fechou **11 peças**: L01 logo, L02 prompt do título (opcional), L03 `Vitória!`, L04 `Você caiu...`, L05 `EVOLUÇÃO`, P01 a P03 (placas) e C01 a C03 (cursores). **Não há** banner de momento fixo além de `EVOLUÇÃO`: o resto é dinâmico e vai para placa + fonte. `CHEFE` (rótulo do relógio) e botões ficam fora.
- [ART-PROMPTS-058](../generated/ART-PROMPTS-058-lettering-placas-e-cursor.md): inventário, quadro de estilo, prompts completos, tamanhos finais, margens de nove fatias, hotspots e critérios de aceite. [CHATGPT-FILA-026](../generated/CHATGPT-FILA-026-lettering-placas-e-cursor.md): fila com a L01 primeiro.
- Cartões ART-039, ART-040 e MEC-058 e numeração do README (próximos livres: SPEC-134, PLAN-067, ART-PROMPTS-059, ART-038, MEC-050, BAL-022, EVID-173).

## B-002 — código com fallback
| Item | Arquivo | Resultado |
|---|---|---|
| Cursor por forma (`ARROW`, `POINTING_HAND`, `CROSS`), hotspots em tabela, mão em todo botão novo na árvore, mira só com mira por mouse e sem modal | `ui/cursor_skin.gd`, `data/cursor.json`, ligação em `core/game.gd` (`CursorSkin.install`) e `ui/run.gd` (`_sync_cursor` no sinal `process_frame`, que dispara com a árvore pausada; `_exit_tree` restaura) | sem PNG em `assets/ui/cursor/` nada muda |
| Lettering: banner, placa de nove fatias, estilo de `Label` (Cinzel, contorno, sombra, gradiente de ouro), `plate_label` com fallback | `ui/lettering.gd`, `ui/lettering_gradient.gdshader`, `data/lettering.json` | sem PNG devolve `null`/`Label` estilizado |
| Testes | `tests/test_cursor.gd`, `tests/test_lettering_assets.gd` (tolerantes à arte ausente; validam tamanho, hotspot, margens, cantos transparentes quando a arte existir) | ver abaixo |
| Prévia do estilo | `tools/capture_lettering.gd/.tscn` → `.atena/generated/spec-132/lettering_estilo.png` | gradiente por posição local legível sobre o fundo do título |

Decisão técnica: o gradiente usa a **posição local do vértice**, não `UV`, porque em texto o UV é a região do atlas da fonte; a fonte vai em branco e o shader multiplica, então contorno e sombra (escuros) continuam escuros.

## Verificação
| Verificação | Resultado |
|---|---|
| `godot --headless --path . -s tests/run_all.gd` | **0 falhas** (inclui os dois testes novos) |
| `tools/audit_projeto.gd` | 0 erros; 7 avisos de apresentação de chefes sem entrada (já existiam) |
| `tools/backlog_check.ps1` | 0 alertas de organização |
| Captura do estilo em janela real 1280×720 | gradiente visível, versão sem gradiente preservada para comparação |

## Não verificado
- **Cursor em janela real**: não há PNG ainda e o cursor do sistema não aparece em captura; fica para a B-003/B-004 (composição por script e item "O que testar").
- Troca AUTO/MOUSE e modais da run com a mira ativa dependem da arte da mira (B-004).

## Próximo
B-003 depende do gerador de imagem (dono/Codex) e da ordem da fila (FILA-025 antes). Commits (arte e código) só com aprovação explícita; as mudanças desta etapa estão **no working tree, sem commit**.
