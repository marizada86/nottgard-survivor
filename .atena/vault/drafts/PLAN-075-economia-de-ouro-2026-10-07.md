---
id: PLAN-075
title: Balanceamento da economia de ouro (Quartel e run)
spec: SPEC-142
cards: [BAL-023, BAL-003]
status: concluido localmente em 2026-10-07 (B-004 pulada pelo dono); sem commit
approval_mode: per-plan
route: PLAN_DEVIATION (DEV-007); PLAN-071 continua active_plan, PLAN-074 em execucao
---

# PLAN-075

Spec: [[SPEC-142-balanceamento-da-economia-de-ouro]]. Estado operacional: `.atena/state/plan-075-economia-de-ouro.yaml`.
Um commit por mecânica/ajuste (`add.yaml`); **nenhum commit, push, build ou exportação** sem aprovação à parte.
Princípio: **medir antes de mexer**, uma alavanca por vez, antes e depois anotados.

## Lotes

### B-001 Telemetria e linha de base
| Passo | O quê |
|---|---|
| S-001 | `core/battle.gd`: `stats.gold_src` por fonte (abate, elite, chefe, quebrável, evento, venda, oferta) sem mudar nenhum valor; `result()` expõe os campos. |
| S-002 | `tools/bot.gd`: imprime moedas brutas, do Quartel e por fonte, por fase e herói; argumentos de perfil (novato/veterano) e de marcas (0 e máx.). |
| S-003 | Rodada de base: 10 heróis × fases 1 a 9 × perfis; EVID com tabela e o ganho de uma vitória completa. Testes: telemetria não altera a run (mesma semente, mesmo resultado). |

### B-002 Metas numéricas (checkpoint do dono)
| Passo | O quê |
|---|---|
| S-004 | Compara a base com a meta D2; propõe teto por run com marcas máximas e a fração máxima por fonte. |
| S-005 | Dono confirma ou troca os números; eles entram na SPEC-142 como aceite 3 a 5. **Sem isso, B-003 não começa.** |

### B-003 Correções de escala (uma alavanca por vez, re-medindo)
| Passo | O quê |
|---|---|
| S-006 | F2: `gold_pct` proporcional (valor fracionário com sorteio no arredondamento, ou acumulador por run), sem mudar o valor esperado em 0 %. Teste de unidade. |
| S-007 | F3: venda de peças: escalar com `coin_mult` **ou** tirar de `stats.gold`; escolher pela medição e registrar. |
| S-008 | F1/F4: curva de `coin_mult` para o ganho do Quartel (fator de normalização por tier, ou ganho por fase com teto), multiplicador de descida e bônus de chefe `60 × (1 + tier)`; marcas somando em vez de multiplicando, se a medição mandar. |

### B-004 Custos e economia da run
| Passo | O quê |
|---|---|
| S-009 | `data/upgrades.json`: só se B-003 não alcançar a meta D2; ajuste de custo por faixa, perfil existente intocado. |
| S-010 | Economia da run: preço de loja, ferreiro, curandeiro e aposta contra a nova renda; só se a medição apontar distorção. |

### B-005 Validação e reconciliação
| Passo | O quê |
|---|---|
| S-011 | Importação Godot, suíte inteira, smoke das nove fases, contrato ADD e links. |
| S-012 | `BALANCEAMENTO.md` (BAL-023, BAL-003), `RELEASES.md` ("O que testar" com a pergunta de ritmo ao jogador), README (numeração), EVID, `plan.yaml`; retorno ao plano ativo. |

## Portões

Sem dependências novas · sem arte · `data/abilities.json`, `data/weapons.json` e demais edições de outras sessões **não entram** ·
`core/battle.gd` e `tools/bot.gd` em edição por PLAN-074: mexer só nos trechos de ouro · commit, push, build e exportação
exigem aprovação própria · perfil e moedas já guardadas dos jogadores **não são alterados**.

## Ordem sugerida com PLAN-074

B-001 e B-002 podem rodar já (só lê e mede). **B-003 em diante espera o fim da B-004 do PLAN-074** (Marcas do Abismo), porque as
marcas somam no ganho e mudam a base.

## Recuperação

Snapshot de `plan.yaml` antes de qualquer execução em `.atena/generated/gold-economy/v01/plan-before-075.yaml` (a criar na aprovação).
Cada alavanca é um commit separado e reverte sozinha; telemetria não muda valores.

## Perguntas a responder antes de executar

Rota (agora e voltar, ou depois), D1 (escopo), D2 (meta de ritmo) e D3 (alavanca principal), mais o nível de aprovação.
