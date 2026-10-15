---
id: PROPOSTA-M2-R5
title: M2 R5, estética sem imagem nova (HUD, atmosfera, feedback)
spec: SPEC-177
plan: PLAN-103 / B-003
content_state: DRAFT
status: proposta para o gate G-M2-3 do dono (2026-10-14)
---

# Proposta R5: estética que não depende de imagem

Leitura feita em 2026-10-14 sobre `ui/run.gd`, `ui/overlay.gd`, `ui/enemy_view.gd`, `ui/hero_view.gd`, `ui/hud.gd`, `ui/visual_filter.gdshader`, SPEC-173 e as capturas da auditoria.

## O que já existe (não refazer)
| Frente | Estado |
|---|---|
| Brilho aditivo | Todos os VFX de golpe, projétil, pulso e habilidade já usam `BLEND_MODE_ADD`. Não há bloom global. |
| Partículas | Sistema leve em `ui/overlay.gd` (limite por zona e por impacto): poças, rituais, fogo, correnteza de Pilares, faíscas de impacto divino, estouro de abate, moeda. |
| Flash de impacto | Inimigo pisca branco ao ser atingido (`enemy_view`), herói pisca avermelhado, hit-stop em crítico/elite/chefe, tremor. |
| Subida de nível | Efeito próprio (`vfx_subida_de_nivel.png`) e som. |
| Números de dano | Cor por tipo, agregação, crítico maior (SPEC-116 D5). |
| Filtro de tela | Paleta/dither e Gravura, desligado por padrão (SPEC-173). Pixel descartado. |
| HUD | Moldura dourada procedural; botão ART-047 depende de imagem (M5). |

## Lacunas reais (sem imagem)
1. **Vida baixa só tem fala do herói** (`_update_low_hp_bark`, a cada 20 s); nenhum sinal visual na tela. Receber dano é só tremor e número vermelho pequeno.
2. **Nenhuma atmosfera por bioma:** as 9 fases se diferenciam pelo chão e pelos props, mas nada se move no ar (cinza, esporo, névoa, bolha). Isso pesa no relato "enjoa depois do 3º ou 4º mapa" (BAL-016) e é a base do M4d.
3. **Sem gradação de cor por bioma** (adiado na SPEC-173 para o "lote 3"); só vinheta dentro da Gravura.
4. **Números de dano pequenos e de baixo contraste** sobre pedra clara (visto nas capturas da auditoria; ART-007 segue "a confirmar").
5. **MEC-031 D4 (Maré do Abismo) e D6 (revelação do loot) e as transições do MEC-003 estão marcados "aguardam conferência em run real"**; só os números (D5) foram conferidos nesta rodada.

## Opções (cada uma é um lote pequeno, com teste, captura e reversão por commit)

| # | Item | O que muda | Custo | Risco | Respeita "Reduzir efeitos de impacto" |
|---|---|---|---|---|---|
| **A** | **Aviso de vida baixa e de golpe recebido** | Vinheta vermelha nas bordas: pulsa devagar abaixo de 30% de vida; flash curto ao receber dano (atenuado em dano contínuo, ligado ao F-1). Camada entre o mundo e a HUD; invisível e sem custo quando a vida está boa | pequeno | baixo | sim: estática, sem pulso |
| **B** | **Números de dano mais legíveis** | Tamanho 14→16 (crítico 22→26), contorno mais forte, pequeno degradê de cor para valores altos; teto de 14 mantido | muito pequeno | baixo | n/a |
| **C** | **Atmosfera por bioma** | Partículas ambientais discretas por fase, no sistema existente e sob o mesmo limite: p.ex. cinza lenta em Dagruve, esporos em Molor, fagulhas em Shedaklah, névoa baixa nas Docas. Tabela de 9 perfis em dados | médio | médio (gosto e desempenho) | sim: desliga |
| **D** | **Gradação de cor por bioma** | Multiplicador de cor e vinheta leve por fase, passada própria opcional ("Atmosfera": Desligado, Leve), medida com `FrameStats` na máquina fraca emulada | médio | médio (desempenho em gl_compatibility) | sim |
| **E** | **Conferência em run real de D4/D6 e transições** | Capturas e checklist do MEC-031 D4, D6 e do MEC-003 (pausa, fades); nada muda se estiver certo | pequeno | nenhum | n/a |

## Recomendação
- **Já:** A + B + E (legibilidade e conferência; baixo risco; sem decisão de gosto).
- **Depois de ver amostras:** C e D. Gosto é seu: eu gero 2 ou 3 capturas por bioma (antes/depois) e você escolhe quais perfis ficam; D só entra se a medição na máquina fraca não perder quadros.
- Teto: C e D juntos já cobrem o que o plano chamava de "lote 3" da estética.

## Verificação prevista
- Testes: limiar e histerese da vida baixa (sem tremer na borda de 30%), tamanho e limite dos números, tabela de perfis de atmosfera completa para as 9 fases.
- Suíte, smoke das 9 fases, captura antes/depois e, para C e D, `FrameStats` p95/p99 na máquina fraca emulada.
- Pendente humano: sentir se a vinheta é útil ou irritante, e se a atmosfera "tem a cara" de cada fase.

## Decisões pedidas (G-M2-3)
1. Aprova A, B e E agora?
2. C e D: seguir para amostras (sim/não)? Quais biomas primeiro?
