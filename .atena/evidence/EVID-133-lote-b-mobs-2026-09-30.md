---
id: "EVID-133"
title: "Ciclos de animação candidatos — Onda 1, Lote B"
date: "2026-09-30"
status: "40 quadros candidatos aprovados pelo dono em 2026-09-30"
relations: ["[[PLAN-048-geracao-animacoes-mobs-onda-1-2026-09-30]]", "[[ART-PROMPTS-034-mobs-onda-1-lote-b]]", "[[CHATGPT-FILA-007-mobs-onda-1-lote-b]]", "[[CANDIDATES-MANIFEST-003]]"]
---

# EVID-133 — Lote B de animações

## Entrega

Foram organizados 20 quadros candidatos para cada mob. Os dois `idle_00` já
aprovados no gate de identidade foram reaproveitados em células nativas; 38
quadros restantes foram gerados individualmente. As imagens finais são PNG RGBA
de 256×384 e permanecem em `.atena/generated/art-candidates/`.

## Pranchas por mob

### Criatura corrompida

![Ciclo da criatura corrompida](EVID-133-lote-b-criatura_corrompida-2026-09-30.png)

### Arch-hag

![Ciclo da Arch-hag](EVID-133-lote-b-arch_hag-2026-09-30.png)

## QA realizado

- 20 células por mob: 4 idle, 6 move, 4 attack e 6 death; 40 no total.
- Todos os quadros têm 256×384, canal alfa e transparência nos quatro cantos.
- Auditoria de opacidade: pior solidez observada **0,928**, acima do mínimo
  0,90 do plano. A menor alfa médio observada foi 0,948.
- As candidatas são imagens individuais reduzidas de 1024×1536 por
  nearest-neighbor; não foram usados sprite strips.
- Identidades I05 e I06 já tinham aprovação do dono; esta evidência não aprova
  ainda os ciclos de idle, movimento, ataque e morte.
- Nenhum asset oficial, arquivo de runtime, cena, dado ou código foi alterado.

## Decisão do dono

Em 2026-09-30, o dono aprovou os ciclos de `criatura_corrompida` e `arch_hag`.
Eles permanecem candidatos isolados até o gate separado de admissão.
