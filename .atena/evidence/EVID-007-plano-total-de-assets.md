# EVID-007 — Plano total de assets visuais

Data: 2026-09-22  
Resultado: **planejamento concluído; nenhuma arte de jogo gerada**

## Fontes inspecionadas

- jogo atual: cenas, scripts, `assets/` e 14 arquivos de dados;
- ADD: `PLAN-001`, `PLAN-002`, `SPEC-011..014`, `ART-PROMPTS-001..010` e `ASSET-MATRIX-001`;
- vault canônico: `D:\dev\nottgard\vault`, incluindo personagens, NPCs, itens e camadas do Plano Abissal;
- biblioteca visual: 27 imagens em `C:\Users\gui-m\Desktop\nottgard`;
- prancha de inspeção: `EVID-006-reference-board.png`.

## Contagens verificadas nos dados

| Domínio | Quantidade |
|---|---:|
| Heróis | 10 |
| Habilidades ativas | 10 |
| Inimigos | 49 |
| Armas/evoluções | 30 |
| Passivas | 14 |
| Bênçãos | 12 |
| Camadas | 8 |
| Itens-base | 13 |
| Itens únicos | 18 |
| Conquistas | 18 |
| Upgrades permanentes | 12 |

## Estado visual verificado

- 5 retratos e 10 sprites de inimigo existem no repositório.
- Não há sprites finais de herói, pisos, props, interações, pickups ou ícones de conteúdo.
- Os prompts existentes cobrem as 39 lacunas de inimigo, 5 retratos faltantes, biomas, props, interações e ícones anteriores à `SPEC-012`.
- Faltavam prompts para 10 sprites de herói, 10 remasters de inimigo legado, 10 habilidades ativas, 8 regras de camada, 3 pickups e 3 fundos de tela.
- A pasta do Desktop tem 9 referências diretas dos 10 heróis; Nyrelia depende do vault.
- As referências do Desktop têm estilos incompatíveis entre si; foram classificadas como âncoras de identidade/composição, não como um style guide pronto.

## Resultado do plano

- alvo: 236 PNGs finais + 1 ícone vetorial;
- piso de produção recomendado: 228 chamadas distintas, devido a 8 aliases entre arma e item homônimo;
- alternativa econômica: 213 chamadas, mantendo 15 assets legados, com perda esperada de coerência;
- candidatas ficam fora de `assets/`, em `.atena/generated/art-candidates/`, para evitar importação pelo Godot;
- ImageGen é reservado para identidade; VFX, telegráfos e UI estrutural permanecem procedurais.

## Arquivos produzidos

- `../vault/research/RESEARCH-002-biblioteca-visual-desktop-2026-09-21.md`;
- `../generated/ASSET-MATRIX-002-total-2026-09-21.md`;
- `../vault/drafts/PLAN-003-geracao-total-assets-2026-09-21.md`;
- `EVID-006-reference-board.png`.

## Gate

O próximo passo é aprovação do `PLAN-003`. Essa aprovação permitirá criar/reconciliar os prompts e o manifesto da Fase 1. A geração de imagens continuará bloqueada até aprovação separada da Fase 2 e do envio das referências locais necessárias.

