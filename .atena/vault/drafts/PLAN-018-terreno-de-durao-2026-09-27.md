---
id: "PLAN-018"
type: "plano-de-voo"
title: "Durao — atualização visual do planalto e Estige gelatinoso"
status: "superado; não executar"
created: "2026-09-27"
relations: ["[[SPEC-049-terreno-de-durao]]", "[[SPEC-039-macroterreno-abissal-montanhas-e-rio-estige]]", "[[SPEC-040-estige-gelatinoso-imovel]]"]
---

# PLAN-018 — Durao: atualização visual sem alterar a regra do Estige

> Superado em 2026-09-27: o dono confirmou que Durao já está concluído e
> determinou seguir para Feng-tu. Este rascunho não é autorização de execução.

## Direção recomendada

Durao já possui a macroforma correta: deserto pós-guerra, penhascos,
planaltos, margens e Rio Estige. A intervenção é somente de acabamento do
piso: substituir a aparência de tile único por quatro variantes modulares de
basalto queimado, cinza compactada e poeira de ferro oxidado. A arena central
deve permanecer silenciosa e navegável; os penhascos existentes continuam
props e módulos procedurais y-sorted.

O Estige continua uma faixa gelatinosa, imóvel e atravessável. Sua água,
margens, testes de lucidez, Esquecimento, Chamado e demais regras existentes
não serão modificados. Em particular, a arte não acrescentará setas, espuma
ou outros sinais de correnteza.

## Plano de voo proposto

1. Gerar uma candidata de textura-base plana e discreta, sem rio, props ou
   estruturas altas.
2. Submetê-la à revisão humana; nenhuma raster entra em `assets/` antes de
   aprovação explícita.
3. Após aprovação, derivar atlas opaco 128×64 (quatro variantes 64×32) e
   vinculá-lo somente ao piso terrestre de Durao.
4. Preservar o desenho procedural do Estige, das margens e dos penhascos;
   executar testes, fumaça e captura runtime 1280×720.
5. Registrar hash, evidência e aprovação canônica do asset.

## Limites

Não há mudança de lore, ondas, chefe, duração, colisão, recompensas, RNG de
batalha ou comportamento do Estige. Este plano não se estende a Feng-tu.
