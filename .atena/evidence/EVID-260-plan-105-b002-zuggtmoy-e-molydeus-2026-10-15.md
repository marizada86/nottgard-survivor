---
id: "EVID-260"
title: "PLAN-105 B-002: mecânicas de Zuggtmoy (Shedaklah) e Molydeus (Durao)"
created: "2026-10-15"
relations: ["[[PLAN-105-mecanicas-dos-outros-chefes-2026-10-15]]", "[[EVID-259-plan-105-b001-verbos-novos-das-mecanicas-de-chefe-2026-10-15]]", "[[EVID-257-l5-mecanicas-de-chefe-piloto-2026-10-15]]"]
content_state: DRAFT
---

# EVID-260 — PLAN-105, lote B-002 (aprovação por lote; gate G-L5-1 aprovado em 2026-10-15; sem commit)

## O que mudou
| Chefe (ordem, orçamento) | Fase de 70% | Fase de 35% (troca o conjunto) |
|---|---|---|
| **Zuggtmoy** (Shedaklah, 2, orçamento 2) | **Quadrantes de esporos**: 3 de 4 quadrantes acendem por 1,5 s (2d8) e deixam poça 8 s; `skip` das poças soltas antigas | **3 Cogumelos-mãe** (60 PV) que **curam o chefe** 1% do PV por segundo, **teto de 20% do PV máximo**; `skip` do invocar antigo |
| **Molydeus** (Durao, 4, orçamento 3) | **Marca de sentença**: o círculo (raio 3) segue por 2 s, trava por 1 s, explode (2d6) e retarda 1,2 s; as 2 "jaulas" (Molydeus menores) seguem | **Correntes**: varredura de 2 feixes a 180° (2d6, 2,8 s, 1,2 s de aviso, recarga 12 s); `skip` do anel antigo |

Mudanças de código que este lote exigiu:
- `boss_mech.off_bosses` (interruptor por chefe) e nome do totem por verbo (`name`).
- **Teto da cura dos totens** (`heal_cap_pct`): sem ele a cura de 2%/s (34 PV/s num chefe de 1700 PV) refazia a luta inteira (medido: o chefe voltava de 639 a 1685 PV em 40 s).
- **Mira automática prefere os totens** (e os servos quando o chefe está imune): `nearest()` consulta `boss_mech.priority_targets()`. Sem isso o "inimigo mais próximo" ignorava os totens. A mira no mouse não muda.
- Dados em `data/boss_mechanics.json` (reformatado em linhas compactas).

## Verificação
- `tests/test_l5_b002_bosses.gd`: orçamentos (2 e 3); substituição das ações antigas (poças e invocar de Zuggtmoy, anel de Molydeus); 3 quadrantes com poça; 3 Cogumelos-mãe que curam e não blindam; **teto de 20%**; marca com seguimento e retardo; correntes em 2 feixes; **preferência da mira**; interruptor por chefe. **4 mutações** (sem `skip`, cogumelo sem cura, 1 feixe e sem `skip`, e na preferência) falham no ponto certo. Suíte completa: **0 falhas**.
- Capturas em janela real (`tools/capture_l5_b002.tscn`, `.atena/generated/mariz-playtest/l5_b002_*.png`).

## Medição: herói que se desvia (`tools/probe_boss_fight.gd`)
O `bot_curva` **não serve** aqui: começando em Shedaklah ou Durao o herói de nível 1 morre em 52 a 67 s, igual com e sem as mecânicas (`bot-b002/resumo-b002.md`); ele nunca chega ao chefe. A sonda nova faz uma luta de chefe com um herói de nível 12, armas nível 4 e uma camada de meta, que mantém distância, desvia de zonas, projéteis, varredura, quadrantes e marca, e guarda a habilidade para interromper. O herói é curado a cada passo (mede a ameaça sem a morte encerrar a luta), 6 sementes, teto de 300 s.

| Camada | Chefe | Variante | Lutas terminadas | Duração média | Dano médio recebido |
|---|---|---|---|---|---|
| 1 (dano +100%, PV +60, CA +4) | Zuggtmoy | antes → depois | 4/6 → **3/6** | 252 s → 284 s | 611 → **1401** |
| 1 | Molydeus | antes → depois | 1/6 → **0/6** | 295 s → 299 s | 899 → **2029** |
| 2 (dano +200%, PV +100, CA +6) | Zuggtmoy | antes → depois | 5/6 → **5/6** | 177 s → 252 s | 520 → **891** |
| 2 | Molydeus | antes → depois | 6/6 → **4/6** | 279 s → 284 s | 668 → **1717** |

**Leitura honesta**
- **Zuggtmoy** ficou onde queríamos: a luta termina igual, dura ~40% mais e custa ~70% mais vida.
- **Molydeus** ficou **duro**: cerca de 2,5 vezes o dano, e a luta passa de 6/6 para 4/6. O enrage não explica (sem ele: 668 → 1601); são a marca e as correntes. O piloto desvia **mal** das correntes (um humano que lê o aviso fica no quadrante seguro, que é sempre o "à frente do fim do arco" ou "atrás do início"), então o número é um **teto de ameaça**.
- Os tempos de luta são **longos porque o herói da sonda causa pouco dano** (uns 10 a 30 PV/s); a luta com o seu herói de verdade é mais curta.
- **Não é aceite de equilíbrio**: 6 execuções por célula, herói sintético, sem a régua de 12 heróis.

**Botões** (em `data/boss_mechanics.json`): se o Molydeus pesar, do mais suave ao mais forte: `dice` das correntes de `2d6` para `1d8`, `dur` de 2,8 para 3,2 s, `beams` de 2 para 1, `cd` da marca de 12 para 16 s.

## Gate G-L5-2 (seu)
Jogar Shedaklah e Durao até o chefe e dizer:
1. **Zuggtmoy:** os quadrantes de esporos com poça e os Cogumelos-mãe curando estão claros? Quebrar os cogumelos é natural com a mira automática?
2. **Molydeus:** a marca (seguir 2 s e travar 1 s) e as correntes em 2 feixes são justas ou demais para o mapa 5?
3. **Caos:** com o orçamento 3 em Durao, a luta ficou "caótica na medida" ou passou do ponto?

## Pendências
- B-003 (Discípulo Pestilento e Malcanthet) só com o seu gate.
- Cogumelos-mãe usam a **arte provisória** do candelabro (junto do turíbulo): ART-049.
- Sem commit.
