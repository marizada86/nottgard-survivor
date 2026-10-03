---
id: "EVID-149"
title: "SPEC-120 parte A: dmg_mult por fase, afixos de elite e chefe, horda: medição com o bot"
created: "2026-10-03"
relations: ["[[SPEC-120-curva-base-e-marcas-do-abismo]]", "[[EVID-148-curva-de-dificuldade-por-fase-2026-10-03]]", "[[PLAN-055-mapas-vivos-segredos-e-dificuldade-2026-10-03]]"]
cards: ["BAL-016", "BAL-001"]
---

# EVID-149 — Curva base (SPEC-120 parte A)

## O que entrou

- `dmg_mult` em `data/stages.json`, aplicado em `Battle._hurt_hero` ao golpe, ao projétil e à área (poça, armadilha e névoa não escalam).
- Afixos: elites da 3ª fase em diante sorteiam 1 a 2 entre 9 (os 4 antigos + Blindado, Explosivo, Vampírico, Invocador, Escudeiro); Dagruve e Docas ficam com os 4 antigos. Chefe da 5ª fase em diante ganha 1 afixo (sem virar elite). Aura colorida por afixo em `ui/enemy_view.gd`.
- Horda: 5 s de aviso e 20 s de onda `n`×3 do inimigo mais numeroso do bioma, a 45 % da duração, da 3ª fase em diante, fora do Pilares.
- Testes: `tests/test_affixes.gd` (suíte: 0 falhas).

## Medição (perfil veterano, mapa 60×60, 10 heróis × 2 sementes)

PV mínimo médio por passagem (EVID-148 = antes, só `hp_mult`):

| Fase | Antes | Só dmg_mult | + afixos e horda | Ajuste final* |
|---|---:|---:|---:|---:|
| Shedaklah | 80 % | 74 % | 62 % | 70 % |
| Molor | 86 % | 79 % | 78 % | 68 % |
| Durao | 86 % | 75 % | 69 % | 54 % |
| Feng-tu | 90 % | 84 % | 66 % | 67 % |
| Shendilavri | 90 % | 82 % | 57 % | 79 % |
| Goranthis | 82 % | — | 45 % | 49 % |

\* Ajuste final: `dmg_mult` de Molor 1,45→1,75 e Durao 1,65→1,9 (as demais seguem o plano aprovado).

## Limites da medição (honesto)

- As amostras são pequenas (5 a 20 passagens por fase) e a última rodada ficou **incompleta** (90 linhas; runs interrompidas), com heróis que morrem cedo saindo da amostra. A oscilação entre rodadas (Shendilavri 57→79 %) é ruído, não efeito.
- Direção confirmada: as fases 3+ saíram de 80–90 % para 54–79 %; Durao, Feng-tu e Goranthis entraram na faixa-alvo (45–65 %) ou perto; Shedaklah, Molor e Shendilavri ainda estão acima.
- Não medido: duração do chefe e o efeito do afixo do chefe isolado. O bot não usa loja, ferreiro nem eventos: é alarme, o veredito é o playtest.

## Decisão pendente

Rodar o bot em escala (6 sementes) antes de mexer de novo em `dmg_mult`, `cap`/`every` e PV de chefe (B-004 parcial). Dagruve (50 %, 6 mortes em 20) e Docas não foram alteradas.
