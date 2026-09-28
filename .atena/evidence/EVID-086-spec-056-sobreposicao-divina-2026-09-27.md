---
id: "EVID-086"
type: "evidence"
title: "Validação da SPEC-056 — sobreposição visual das divindades"
status: "passed"
created: "2026-09-27"
relations:
  - "[[SPEC-056-sobreposicao-visual-das-divindades]]"
  - "[[PLAN-026-sobreposicao-visual-das-divindades-2026-09-27]]"
---

# EVID-086 — Sobreposição visual das divindades

## Resultado

A SPEC-056 foi executada localmente dentro do escopo aprovado. As sete
afinidades resolvem uma paleta visual própria após bênção de altar; a base de
Kayron e Maelor permanece preservada antes da bênção; Helion não habilita aura
nem afinidade divina. Não houve mudança de dano, atributos, colisão, RNG, loot,
save, progressão ou comportamento de buffs.

## Verificações executadas

| Verificação | Resultado |
|---|---|
| `godot --headless --path . -s tests/run_all.gd` | passou, `testes: 0 falha(s)` |
| `godot --headless --path . res://tools/smoke.tscn` | passou, nove fases em `running`, `smoke: ok` |
| revisão de espaços com `git diff --check` nos arquivos do escopo | passou, sem erro de whitespace |
| inspeção visual de Shar e Ghaunadaur | passada: anel violeta legível para Shar; verde dominante e leitura roxa de suporte para Ghaunadaur |

O ambiente headless emitiu avisos já conhecidos sobre log em `user://`,
certificados locais e recursos de renderização na saída; ambos os processos
retornaram código zero e as verificações declaradas passaram. As capturas foram
produzidas com o renderizador NVIDIA, sem esses bloqueios.

## Cobertura de teste

`tests/test_battle.gd` verifica:

- base de Kayron em `#D13E54` antes da bênção;
- sobreposição violeta de Shar e seu contorno;
- Ghaunadaur verde `#8AD14B` com acento roxo `#A56BDA`;
- cor primária exata das sete afinidades aprovadas;
- exclusão de Helion como afinidade e ausência de aura divina ao selecionar seu
  conteúdo.

## Capturas

- `SPEC-056-shar-2026-09-27.png`
- `SPEC-056-sendrinah-2026-09-27.png`
- `SPEC-056-mask-2026-09-27.png`
- `SPEC-056-lliira-2026-09-27.png`
- `SPEC-056-ghaunadaur-2026-09-27.png`
- `SPEC-056-tou-um-2026-09-27.png`
- `SPEC-056-selune-2026-09-27.png`

## Reconciliação de fatos operacionais

- `core/divine_visuals.gd` resolve tema-base e sobreposição divina, sem incluir
  Helion.
- `core/battle.gd` aceita sobreposição somente ao escolher altar de uma das sete
  divindades e fixa snapshots nos projéteis e zonas do herói.
- `ui/run.gd` e `ui/overlay.gd` usam os snapshots em números, aura, ataques,
  trilhas, projéteis e impactos.
- `tools/shot.gd` recebeu somente um parâmetro de QA para capturar uma afinidade
  elegível; ele não muda uma run normal.
