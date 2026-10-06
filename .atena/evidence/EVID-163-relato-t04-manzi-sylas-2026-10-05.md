---
id: "EVID-163"
title: "Relato do playtester T04 (Manzi, Sylas) sobre a v0.3.0, escrito e interpretado por Higor"
created: "2026-10-05"
relations: ["[[EVID-108-playtest-publico-t03-dna-2026-09-29]]", "[[SPEC-125-balanceamento-desafio-e-entretenimento]]"]
cards: ["MEC-043", "MEC-044", "MEC-045", "MEC-046", "MEC-047", "ART-034", "ART-035", "BAL-019", "BAL-001"]
---

# EVID-163 — T04 Manzi ("manzera"), herói Sylas

**Natureza:** relato **de segunda mão**. O dono (Higor) escreveu e interpretou as considerações do Manzi; não há pacote `evidencias/` (sem `relato.txt`, log nem prints), então não há hash de build verificável. O texto cita a v0.3.0.

| # | Relato (resumo fiel) | Intake | Destino |
|---|---|---|---|
| 1 | Usar a habilidade (Q/RMB) deveria ter um ícone e algo que indique a recarga (imagem ou similar) | IN-053 | MEC-043, ART-034 |
| 2 | Ao apertar C devia aparecer a descrição da habilidade (Q/RMB) | IN-054 | MEC-044 |
| 3 | HUD de itens, equipamentos e magias com informação demais ao apertar C: melhorar o espaçamento, distribuir melhor, separar em categorias; aproveitar para criar prompts que deixem tudo mais bonito | IN-055 | MEC-045, ART-035 |
| 4 | Bênção não permite não escolher nenhuma; considerar balancear e adicionar bênçãos novas e entidades que concedem | IN-056 | MEC-046, MEC-047, BAL-019 |
| 5 | v0.3.0 muito fácil (o dono: já em andamento) | IN-057 | BAL-001 (+1 relato), BAL-018 |

## Verificação no código (leitura, nada executado)
- A habilidade ativa hoje aparece como **texto** `[Q/RMB/RB] <nome> — <N>s` (`core/battle.gd:363`, cinza em recarga, `ui/hud.gd:133`) **mais um ícone de 34 px** (`ActiveIcon` em `ui/hud.tscn`, arte em `assets/icons/abilities/`, existe para os 10 heróis). Ou seja: o ícone existe, mas é pequeno, fica na pilha de estatísticas e não mostra a recarga (só o texto cinza). O relato 1 procede em parte: falta destaque e indicação visual de recarga, não o ícone em si.
- Os itens 2 e 3 dependem da ficha `C` (SPEC-059); MEC-018 e MEC-006 já tocam esse painel e devem ser reavaliados junto.

## Sinais cruzados
- Item 5 coincide com T03 (IN-035, IN-037, IN-049), T01 e o dono: o consenso "fácil" é de quatro fontes. A 0.3.1 (SPEC-122, 124 e 125) é a resposta em curso.
- Item 4 e a lista "novas bênçãos" ligam ao backlog de conteúdo novo (MEC-042).

## Limites
Relato único e indireto; as mudanças de bênção e de HUD pedem decisão do dono antes de virar spec.
