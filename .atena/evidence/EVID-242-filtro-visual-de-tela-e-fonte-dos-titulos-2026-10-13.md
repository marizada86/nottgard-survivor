# EVID-242 — Filtro visual de tela e fonte dos títulos (2026-10-13)

**Origem:** dono, "faça sugestões do que pode ser melhorado esteticamente…", depois "abre a spec do lote 1, aprovação por lote".
**Desvio:** DEV-040; PLAN-100 / SPEC-173; modo por lote (B-001, B-002, B-003 aprovados em 2026-10-13); conteúdo DRAFT.
**Estado medido:** HEAD `9c1a6d5` + árvore de trabalho (sem commit); Godot 4.7.2.

## 1. Entregue (local)
| Peça | O que faz |
|---|---|
| `ui/visual_filter.gdshader`, `ui/visual_filter.gd` | Filtro de tela do mundo: Desligado (padrão), Pixel do mundo, Paleta e dither, Gravura. Camada própria; desligado não desenha |
| `ui/run.gd`, `ui/overlay.gd` | Camadas: mundo 0 < filtro 1 < texto do mundo 2 (segue a câmera) < HUD 3 < encontros 20. `Overlay` ganhou o modo "text" para os rótulos |
| `core/profile.gd`, `core/game.gd`, `ui/options_panel.gd` | `settings.visual_filter` e `settings.ui_font` (migração para valor desconhecido), `Game.set_visual_filter`, `Game.set_ui_font`, opções **Visual** e **Fonte dos títulos** em Opções → TELA |
| `ui/ui_fonts.gd`, `ui/lettering.gd`, `ui/title.gd` | Fonte dos títulos com fallback para a Cinzel; compensação de tamanho, contorno e peso por fonte |
| `assets/fonts/` | Almendra Display, Uncial Antiqua, Pirata One e IM Fell English (OFL, 4 TTF e 4 licenças; download aprovado em 2026-10-13) |
| `tests/test_visual_filter.gd`, `tests/test_ui_fonts.gd`, `tools/capture_visual_filter.*`, `tools/capture_ui_fonts.*` | Testes e ferramentas de captura |

Nenhuma arte própria foi criada ou alterada; sem mudança de jogabilidade, balanceamento, dados ou versão (0.4.0).

## 2. Achados durante a execução
- O texto do mundo (números de dano, falas, rótulos) ficava ilegível sob o filtro Pixel; foi movido para uma camada acima do filtro (HUD de 1 para 3).
- A Gravura saiu pesada em Goranthis (vitral); limiar 0,10 → 0,22 e força 0,65 → 0,5.
- A Almendra Display ficou ilegível com o contorno do lettering; engrossada (embolden 0,9) e contorno 0,5. A Pirata One ficou pequena (tamanho 1,3).
- "À" maiúsculo ausente na Almendra: não aparece em texto algum do jogo; o fallback cobre.

## 3. Verificação (estado final, 2026-10-13)
| Verificação | Resultado |
|---|---|
| `tests/run_all.gd` | 0 falhas |
| `tools/smoke.tscn` (9 fases) | ok |
| `controller_check` | 94/0 |
| `mobile_buttons_check` | 146/0 |
| `kit_test` (com janela) | OK |
| `backlog_check` | P0=0; 1 alerta de organização preexistente (ART-045 duplicado em ARTE.md, não é deste plano) |

Custo de quadro do filtro: +0,0 a +0,15 ms nesta GPU, VSync desligado, mundo parado (b001-resultado.md). Não representa máquina fraca.

Nota de processo: uma rodada do `controller_check` e uma do `mobile_buttons_check` acusaram 1 falha cada, `save_real_preservado`. O save real foi escrito por outro processo (o mtime caiu dentro da janela da verificação); repetidas sem interferência, as duas deram 0 falhas e o save real ficou intocado. Os arquivos de perfil regenerados por essas ferramentas foram restaurados ao estado do Git.

## 4. Retorno do dono (2026-10-13, subjetivo)
- **Gravura:** "ficou bom". **Desligado:** "ficou bom". **Pixel do mundo:** "ficou ruim". Paleta e dither: sem retorno ainda.
- **Fonte:** gostou da **IM Fell English**; a **Uncial Antiqua** é "interessante também" e pode servir para outros usos que precisem de uma fonte diferente. Nenhuma foi definida como padrão (Cinzel segue padrão até decisão explícita).

## 5. Decisões do dono depois do fechamento (2026-10-13)
1. **Pixel do mundo: descartado.** Removido do shader, das opções e dos testes; perfil com `pixel` volta para `off` (teste novo).
2. **Paleta e dither: fica como opção.**
3. **IM Fell English: padrão dos títulos.** A Cinzel Decorative vira opção e fallback; id antigo `padrao` migra para o padrão novo. Teste do lettering ajustado: o tamanho agora é o pedido × a escala da fonte.
4. **Uncial Antiqua:** opção, candidata a outros usos.
5. **Fonte do jogo inteiro:** avaliar a IM Fell English no corpo; análise registrada separadamente (não commitada).
6. **Commits locais separados autorizados** ("faça os commits separados"). Push e exportação continuam não autorizados.

Verificação após as decisões: suíte 0 falhas, smoke ok.

## 6. Pendências
- Capturas de fonte só do Quartel; pausa, ficha C e HUD de partida não foram capturadas com as fontes novas.
- As capturas em `.atena/generated/plan-100/capturas*` ficam locais (não commitadas; ~15 MB).
