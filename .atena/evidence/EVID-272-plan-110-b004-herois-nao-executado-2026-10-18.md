# EVID-272 — PLAN-110 / SPEC-185, lote B-004 (heróis, LOT15 a LOT17): analisado, NÃO executado

Data: 2026-10-18 · Rota: o lote devolve o escopo ao PLAN-103/M1 (SPEC-176), "parar nas retenções" (decisão do dono, 2026-10-18).

## Por que não é uma admissão de arte

Os três pacotes são insumos do M1 (movimento dos heróis), com gates e retenções próprios:

- **LOT15 (costas e passos N/NE de seis heróis, 36 revisões):** o pacote pede, antes de qualquer importação, corrigir registro e escala, montar células de 256×384 contra os alvos do ART-056 (bases 376/368/368, spread ≤ 12 px, centro ≤ 9 px, largura ≤ 16 %) e validar oito direções, NW/flip, cadência e laboratório (`ui/hero_view.gd`). **Nyrelia03/04 está retida** depois de três tentativas (ciclo saltando). O BUG-027 só pode ser reavaliado após implementação e teste.
- **LOT16 (Durvall, cinco direções, 30 poses):** **P9 retida** por conflito de empunhadura e direção após três tentativas ("não integrar nem espelhar"); exige decisão do dono sobre correção de arte ou método. P6, P7, P8 e P10 dependem do aceite humano no laboratório e do gate D22 do PLAN-103; fontes novas não herdam o aceite do piloto v03.
- **LOT17 (candidata SW de Durvall, 6 poses):** candidata a substituir a P9, mas a retenção antiga só se libera por decisão e admissão explícitas; SW04 v03 tem a maior variação de contorno (base 60 px, centro 48 px, largura 114 px) e registro pendente.

Isso é preparação de ciclos de caminhada em oito direções com validação no laboratório, não cópia de PNG; está sob o PLAN-103 (B-002/S-008, `G-D2`/`G-D3`/D22), que continua suspenso no checkpoint `B-002/S-008_AWAITING_RETURN`. Nada foi copiado, preparado ou ligado; `assets/animations/heroes/` e `ui/hero_view.gd` não mudaram.

## Próximo passo sugerido (decisão do dono)

Retomar o PLAN-103/M1 com estes insumos: Durvall com os cinco retornos (P6, P7, P8, P10 e a candidata SW do LOT17 no lugar da P9, se o dono admitir a substituição), depois LOT15 por herói, sempre com laboratório e sem fechar o BUG-027 por aceite de fontes.
