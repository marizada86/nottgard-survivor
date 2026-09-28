---
id: "PLAN-020"
type: "plano-de-voo"
title: "Shendilavri / Rivenheart — salão de mármore ilusório"
status: "executado e reconciliado"
created: "2026-09-27"
relations: ["[[SPEC-051-terreno-de-shendilavri]]"]
---

# PLAN-020 — Shendilavri: salão de mármore ilusório

## Direção recomendada

Shendilavri deve se ler como o exterior refinado e hostil de Rivenheart:
mármore violeta escuro, grandes placas quebradas, veios rubro-prateados quase
apagados e pequenos depósitos de poeira de cristal. O piso é deliberadamente
sóbrio para que cristais rosas, súcubos, cópias frágeis e telegráfos mantenham
prioridade visual.

O dono aprovou a presença de um único braço visual do Estige nas margens. Ele
é escuro, calmo e sem qualquer risco de Durao; a arena central continua sendo
mármore de Rivenheart. A regra `illusions` permanece exclusivamente de batalha.

## Plano de voo proposto

1. Criar macroterreno determinístico de mármore, veio apagado, pó de cristal,
   margem e braço visual do Estige, sem consumir RNG de batalha.
2. Gerar candidata plana para atlas modular e submetê-la à revisão humana antes
   de promover qualquer raster para `assets/`.
3. Após aprovação, derivar atlas opaco 128×64 com quatro variantes 64×32 e
   vinculá-lo somente aos materiais do piso.
4. Preservar cristais, inimigos, ilusões, chefe, ondas, colisão e progressão;
   validar determinismo, suíte, fumaça e runtime a 1280×720.
5. Registrar hash, evidência e aprovação canônica da arte final.

## Limites

Não muda a regra `illusions`, duração, Malcanthet, recompensas, eventos,
navegação, colisão ou qualquer outro mapa. O Estige é exclusivamente visual,
sem qualquer comportamento hídrico ou mental.
