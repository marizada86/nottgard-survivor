---
id: "PLAN-021"
type: "plano-de-voo"
title: "Goranthis — terraços do falso paraíso e queda do Estige"
status: "executado e reconciliado"
created: "2026-09-27"
relations: ["[[SPEC-052-terreno-de-goranthis]]"]
---

# PLAN-021 — Goranthis: terraços do falso paraíso e queda do Estige

## Direção recomendada

Goranthis deve se ler como um paraíso enganoso: terraços de calcário dourado,
pedra clara envelhecida, musgo seco e veios de mármore pérola. As cachoeiras
existentes deixam de ser apenas props soltos e passam a sugerir, nas margens,
a chegada colossal do Estige. A arena central permanece ampla, clara e
legível para santuários verdadeiros ou falsos, ilusões e poças.

A referência externa registra que o Estige entra em Goranthis por uma grande
cachoeira. Propõe-se que essa queda seja **visual e periférica**: sem fluxo,
empurrão, Teste de Lucidez, Esquecimento, Chamado, buff ou outra mecânica de
Durao. As regras atuais `sanctuary`, `illusions` e `puddles` não mudam.

## Plano de voo proposto

1. Criar macroterreno determinístico de terraço, mármore claro, musgo seco,
   margem e queda visual do Estige.
2. Gerar candidata plana para atlas modular e submetê-la à revisão humana antes
   de promover qualquer raster para `assets/`.
3. Após aprovação, derivar atlas opaco 128×64 com quatro variantes 64×32 e
   vinculá-lo somente aos materiais terrestres.
4. Preservar cachoeiras, santuários, inimigos, ilusões, poças, chefe, ondas,
   colisão e progressão; validar determinismo, suíte, fumaça e runtime 1280×720.
5. Registrar hash, evidência e aprovação canônica da arte final.

## Limites

Não muda o comportamento de santuários, ilusões, poças, duração, Socothbenoth,
recompensas, navegação, colisão ou qualquer outro mapa. A queda do Estige não
cria regra ambiental nova.
