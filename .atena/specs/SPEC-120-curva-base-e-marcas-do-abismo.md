---
id: "SPEC-120"
title: "Curva base da fase 3 em diante e Marcas do Abismo"
status: "rascunho para aprovação do dono (2026-10-03)"
created: "2026-10-03"
relations: ["[[PLAN-055-mapas-vivos-segredos-e-dificuldade-2026-10-03]]", "[[EVID-148-curva-de-dificuldade-por-fase-2026-10-03]]", "[[PLAN-052-padrao-de-qualidade-do-balanceamento-dos-herois-2026-10-02]]"]
cards: ["BAL-001", "BAL-016", "MEC-040"]
---

# SPEC-120 — Curva base e Marcas do Abismo (PLAN-055 F5)

Origem: T03 (Daniel), 2026-10-03: "o jogo está muito fácil". Decisão D2 do
dono: **as duas coisas**: endurecer um pouco a base da fase 3 em diante **e**
criar dificuldade opcional com recompensa maior.

**Rascunho:** nada implementado. Números finais dependem de EVID-148.

> Nome: o jogo já chama de **profundidade** a camada descida pelo portal depois
> do chefe (`descent_depth`, multiplicador ×1,25 / ×1,55 / ×1,90). Para não
> confundir, a dificuldade opcional se chama **Marcas do Abismo**.

## Parte A — Curva base (fase 3 em diante)

O problema não é só número: de Shedaklah em diante a dificuldade sobe apenas
por `hp_mult` e `cap`. Os inimigos ficam com mais vida, mas **jogam igual**. A
proposta é subir a pressão com **variedade**, e só um pouco com números.

1. **Afixos de elite.** Os elites que já existem ganham afixos sorteados,
   visíveis (cor da aura e nome: "Molydeus Vampírico").
   - Rápido (+40 % de velocidade), Blindado (+3 CA), Explosivo (explode ao
     morrer, com aviso no chão), Vampírico (cura 20 % do dano que causa),
     Invocador (chama 3 servos do bioma a cada 8 s), Escudeiro (aura que reduz
     25 % do dano em aliados próximos).
   - Fases 3 e 4: 1 afixo. Fases 5 e 6: 1 ou 2. Fases 7 e 8: 2. O chefe ganha 1
     afixo a partir da fase 5.
2. **Uma horda por fase** (fase 3 em diante): aviso de 5 s e depois 20 s de
   onda densa (`n` ×3) de um inimigo do bioma. Fácil de ler, sobe a pressão no
   meio da fase, que é onde o jogo "esvazia".
3. **Dano inimigo por fase (achado do EVID-148, a alavanca principal).** Hoje o
   PV inimigo multiplica até ×6,5, mas o dano só ganha +1 por camada e +1 a
   cada 4 min (`core/enemy.gd:60`). Resultado medido: das fases 3 a 9, 894
   passagens com 0,8 % de mortes e PV mínimo médio de 85 %. Proposta:
   `dmg_mult` em `data/stages.json`, aplicado ao dano do inimigo em
   `core/battle.gd` (golpe, projétil e área): 1,0 · 1,0 · 1,25 · 1,45 ·
   1,65 · 1,85 · 2,05 · 2,25 · 2,5. Alvo com o perfil veterano: PV mínimo médio
   entre 45 % e 65 % nas fases 3+, 3 a 10 % de mortes por fase.
4. **Números** (só onde o bot mostrar folga, ver EVID-148): `cap` e `every` das
   ondas tardias; PV dos chefes para que a luta dure pelo menos ~45 s com um
   herói bem montado (hoje 10 a 25 s com meta alto).
5. **Dagruve e Docas não mudam** nesta parte (EVID-148: Dagruve é a única fase que mata hoje, 30 % dos novatos; o certo é suavizá-la em BAL-015). BAL-015 mostra heróis frágeis
   morrendo cedo ali. O começo continua sendo onde se aprende.

## Parte B — Marcas do Abismo (opcional)

- Liberadas **por fase**, depois da primeira vitória nela (não exige terminar a
  campanha: Daniel enjoou antes disso).
- No Quartel, antes da run, o jogador **liga marcas** (cada uma com 1 a 3
  níveis). A soma é o **nível das Marcas** e aparece no HUD e no resultado.
- Recompensa: +10 % de moeda por ponto e chance maior de relíquia (SPEC-119).
  Recorde por herói e fase; conquistas em 5, 10 e 15 pontos.

| Marca | Por nível | Ideia |
|---|---|---|
| Horda | +20 % de inimigos (`n` e `cap`) | mais mobs (pedido de T03) |
| Fúria | +15 % de dano inimigo | mais dano (pedido de T03) |
| Carapaça | +20 % de PV inimigo | — |
| Elites despertos | +1 afixo em elites; nível 3 = elites a cada minuto | variedade |
| Fome | −25 % de cura (fontes, poções, regeneração) | menos PV de sobra (pedido de T03) |
| Pressa | +10 % de velocidade inimiga | — |
| Chefe desperto | chefe com +30 % de PV e uma fase extra a 15 % | luta final mais longa |
| Abismo vivo | regra ambiental com o dobro da frequência | usa o que cada bioma já tem |
| Sem trégua | sem loja e sem ferreiro na fase (1 nível só) | economia apertada |

Implementação: um dicionário `abyss_marks` no `ctx` de `Battle.new`, aplicado
nos mesmos pontos que já usam `hp_mult`, `cap` e as taxas de cura; sem estado
novo em cena.

## Medição

- `tools/bot_curva.gd` (novo, PLAN-055 F2): CSV por fase com nível de entrada e
  saída, PV mínimo, segundos abaixo de 50 % e 25 % de PV, dano recebido e
  duração do chefe; 3 perfis de meta (novato, veterano, loja cheia).
- Alvo para a base, perfil **veterano**: da fase 3 em diante, PV mínimo
  médio entre 45 % e 65 %, pelo menos 30 % das passagens com algum tempo abaixo de 50 % e 3 a 10 % de mortes por fase (hoje 85 %, 3 % e 0,8 %;
  ver EVID-148). Perfil **novato** não pode piorar em Dagruve e Docas.
- O bot não usa loja, ferreiro nem eventos e não explora; é alarme. O veredito
  é o playtest de T03.

## Testes

- `tests/`: afixos aplicados com semente fixa; Marcas somam corretamente e
  multiplicam a moeda; marca desligada = run idêntica à de hoje.
