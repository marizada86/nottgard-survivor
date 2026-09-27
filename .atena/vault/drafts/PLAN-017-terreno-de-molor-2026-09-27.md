# PLAN-017 — Terreno de Molor

Status: **executado e reconciliado em 2026-09-27**.

## Descoberta

Molor é o próximo mapa após Shedaklah: Andar 528, caverna de bolhas, domínio
visual de Juiblex e arena de Blogbog. O cânone e os dados já estabelecem
bolhas de slime, lodo de Juiblex, Pudim Negro, cultistas de Thullgrime e o
Núcleo Verde. A pesquisa pede decomposição, lixo e parasitas, deixando fungo
como presença secundária.

## Recomendação de direção

Tratar Molor como uma **caverna de detrito comprimido**. O centro deve ser
rocha escura e lixo mineralizado navegável; bolsões grossos de slime formam
depressões e ilhas rasas; tubos quebrados, parasitas e bolhas grandes compõem
as bordas. O verde ácido só aparece nos bolsões e nos perigos, nunca em todo o
piso. Assim Molor sucede a disputa fungo×slime de Shedaklah e prepara Durao
sem repetir nem o pântano fúngico nem o Estige.

## Plano de voo proposto

1. Registrar uma SPEC sem mudar fatos, ondas ou a regra `puddles` existente.
2. Estender o macroterreno determinístico com rocha de caverna, detrito,
   bolsão de ooze e borda orgânica.
3. Gerar uma candidata de textura de piso, inspecioná-la e solicitar a decisão
   de admissão antes de copiá-la para `assets/`.
4. Integrar apenas após aprovação, testar, capturar em 1280×720 e reconciliar
   evidências.

## Limites

Não criar inimigos novos, trocar o chefe, mudar duração, loot, colisão ou
mecânica de poças. A presença do Estige em Molor permanece **indefinida**:
nenhum braço, fluxo ou risco foi implementado. As regras exclusivas de Durao
seguem fora deste escopo. A candidata aprovada foi promovida ao atlas
`assets/tiles/molor_ground_atlas_v1.png`.
