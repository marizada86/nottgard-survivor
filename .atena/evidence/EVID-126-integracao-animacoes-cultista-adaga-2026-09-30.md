---
id: "EVID-126"
title: "Integração das animações do cultista de adaga"
date: "2026-09-30"
relations:
  - "[[SPEC-099-integracao-animacoes-cultista-adaga]]"
  - "[[PLAN-046-integracao-animacoes-cultista-adaga-2026-09-30]]"
  - "[[EVID-125-piloto-cultista-aprovacao-alfa-comparacao-2026-09-30]]"
---

# EVID-126 — Integração das animações do cultista de adaga

## Assets integrados

Os quadros individuais aprovados E01–E20 foram recortados pelo alfa,
redimensionados por vizinho mais próximo e montados em células RGBA de
256×384, com conteúdo dentro de 8 px e base alinhada em y=375:

| Estado | Quadros | Arquivo de runtime | Dimensão |
|---|---:|---|---:|
| idle | 4 | `assets/animations/enemies/cultista_adaga/idle.png` | 1024×384 |
| move | 6 | `assets/animations/enemies/cultista_adaga/move.png` | 1536×384 |
| attack | 4 | `assets/animations/enemies/cultista_adaga/attack.png` | 1024×384 |
| death | 6 | `assets/animations/enemies/cultista_adaga/death.png` | 1536×384 |

Os PNGs de `assets/enemies/cultista_adaga.png` não foram alterados. E21–E24
continuam apenas como candidatas de comparação; o recorte automático que falhou
não foi usado no jogo.

## Ligação ao jogo e validação

- `ui/enemy_view.gd` agora carrega os quatro estados do cultista e mantém o
  fallback estático já existente.
- O movimento espelha o sprite quando se desloca visualmente para a esquerda;
  idle, ataque e morte voltam à orientação-base aprovada.
- `tests/test_animation_assets.gd` valida presença, importação, dimensões,
  alfa, contagens de quadros e orientação durante movimento/ação/morte.
- Godot 4.7.2 reimportou os quatro PNGs. `godot --headless --path . -s
  tests/run_all.gd` terminou com `testes: 0 falha(s)` e código de saída 0.
- O processo do Godot ainda reporta falha ao ler o armazenamento de certificados
  do Windows e vazamentos de recursos ao encerrar a suíte; não houve falhas de
  teste. As quatro tiras foram também inspecionadas visualmente.
- Prancha de verificação final: `EVID-126-cultista-adaga-runtime-strips.png`.

## Push

Implementação isolada na branch `codex/cultista-adaga-animation`, conforme
pedido do dono. O resultado do envio é reportado ao dono junto com a conclusão.
