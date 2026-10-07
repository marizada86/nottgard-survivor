---
id: "SPEC-141"
title: "Marcas do Abismo, entrega 1 (cinco marcas, run inteira)"
status: "IMPLEMENTADA LOCAL 2026-10-07 (PLAN-074, EVID-196 e EVID-192); aguarda playtest; sem commit"
origin: planned
implementation_preceded_spec: false
request_classification: PLAN_DEVIATION
created: "2026-10-07"
cards: ["MEC-040", "BAL-016"]
relations: ["[[SPEC-120-curva-base-e-marcas-do-abismo]]", "[[PLAN-074-marcas-do-abismo-2026-10-07]]", "[[EVID-148-curva-de-dificuldade-por-fase-2026-10-03]]"]
---

# SPEC-141 — Marcas do Abismo, entrega 1

Refina a **Parte B da SPEC-120** (dificuldade opcional com recompensa maior). A Parte A
(curva base, afixos, horda, `dmg_mult`) já está implementada e não muda aqui.

## Decisões do dono (2026-10-07)

| # | Decisão | Resposta |
|---|---|---|
| D1 | Onde as marcas valem | **Acompanham a run inteira.** Ligadas no Quartel, valem na fase inicial e em todas as seguintes da mesma run. |
| D2 | Tamanho da entrega | **Fatia de 5 marcas:** Horda, Fúria, Carapaça, Pressa e Fome. |
| D3 | Liberação | **Depois da 1ª vitória na fase** escolhida no Quartel (`profile.cleared`), "atribuir a conquistas": ver premissa A1. |
| D4 | Aprovação | **Por plano** (`per-plan`). |

## Premissas a confirmar (não bloqueiam o rascunho)

- **A1 (D3, "atribuir a conquistas"):** lido como **liberação por vitória + conquistas de nível das Marcas**
  (5, 10 e 15 pontos) **dentro desta entrega**, em vez de adiá-las. Recompensa das conquistas: **só moedas**
  (200, 400, 800), nunca poder permanente, para não tornar o jogo mais fácil, que é o oposto do objetivo.
  Se a intenção era outra (por exemplo, uma conquista por fase liberada), corrigir antes da execução.
- **A2:** relíquia e Elites despertos / Chefe desperto / Abismo vivo / Sem trégua ficam para a entrega 2.
- **A3:** a liberação olha só a **fase inicial** da run. Fases seguintes herdam as marcas mesmo sem vitória prévia nelas.

## Regras

Nível das Marcas = soma dos níveis das marcas ligadas (cada marca 0 a 3; máximo 15).

| Marca | Por nível | Onde aplica | Exclusões |
|---|---|---|---|
| **Horda** | +20 % de inimigos | `cap` de cada fase e **taxa** de nascimento (`every` dividido por 1+0,20·nível, para valer também nas ondas com `n` = 1) | chefe, elites, quebráveis, hordas de evento já existentes mantêm o próprio `HORDE_CAP_MULT` e somam por cima |
| **Fúria** | +15 % de dano inimigo | mesmo ponto de `_stage_dmg_mult` (golpe e área); poças, armadilhas e névoa não escalam, como hoje | — |
| **Carapaça** | +20 % de PV inimigo | `hp_mult` em `Battle._spawn` | quebráveis e ilusões (1 PV) |
| **Pressa** | +10 % de velocidade inimiga | `Battle._spawn`, junto de `happenings.enemy_speed_mult` | chefes (como o evento) |
| **Fome** | −25 % de cura | `Battle._heal_hero` e os pontos que hoje somam PV direto (roubo de vida, cura de arma, evento); nível 3 = −75 % | reviver e restauração de PV cheio ao iniciar não contam como cura; barreira por excesso é calculada depois |

- **Combinação com a dificuldade dos ajustes** (`Game.difficulty()`): as Marcas somam **por cima**, multiplicando.
- **Marcas desligadas = run idêntica à de hoje** (mesma semente, mesmos eventos, mesma RNG). As marcas não consomem a RNG da run.
- **Recompensa:** o multiplicador de moedas da run vira `reward_multiplier() × (1 + 0,10 × nível)`. Vale sobre o ouro da run inteira
  (decisão D1), igual à profundidade do portal; o bônus de chefe (`boss_bonus`) não muda.
- **Recorde:** `stats.abyss_best[herói][fase_inicial]` = maior nível com que o chefe da fase inicial foi derrotado.
- **Conquistas** (stat `abyss_best_level`, o maior nível entre todos os recordes): 5, 10 e 15 pontos; moedas 200 / 400 / 800 (números iniciais, revisáveis).
- **Liberação:** `profile.data.cleared` contém a fase inicial. `Game.battle_ctx()` **ignora** as marcas se a fase estiver bloqueada.
- **Persistência da escolha:** `settings.abyss_marks` guarda a última combinação; é descartada se a fase estiver bloqueada.

## Dados e código

- `data/abyss_marks.json` (novo): marcas, nível máximo, valor por nível, `reward_per_point`, conquistas.
- `core/abyss_marks.gd` (novo, estático): normaliza e limita níveis, soma o nível total, valida liberação; sem estado.
- `core/battle.gd`: `ctx.abyss_marks` → `abyss_marks` e `abyss_level`; ganchos em `_spawn`, `_stage_dmg_mult`/`_hurt_hero`, `_heal_hero`, spawn por onda, `reward_multiplier`, `result()` (novos campos `abyss_level`, `abyss_marks`, `abyss_start_stage`).
- `core/profile.gd`: `abyss_best`, `stat_value("abyss_best_level")`; `core/game.gd`: `run_marks` e `battle_ctx()`.
- `data/achievements.json`: três conquistas.
- `ui/menu.gd` (e `tools/build_scenes.gd` se a cena for gerada por ele): painel de marcas no Quartel, com foco de controle, toque e mouse.
- `ui/hud.gd`: chip "Marcas N" na run e linha no resultado.
- `tools/bot.gd`: argumento para ligar marcas na varredura.

## Aceite

1. Marcas desligadas: run idêntica (estado de herói, inimigos e RNG iguais após N passos com a mesma semente).
2. Cada marca, isolada, produz o efeito da tabela (testes numéricos com semente fixa; Horda contada em tempo fixo, ≥ +15 % por nível).
3. Fome cobre **todos** os pontos de cura de herói (teste que falha se um ponto novo somar PV sem passar pelo ajuste).
4. Soma dos níveis, limite 0 a 3 por marca e máximo 15; nível sai igual no HUD e no resultado.
5. Moeda: ×(1 + 0,10·nível) sobre o ouro da run; recorde e conquistas gravados só com vitória na fase inicial.
6. Fase não vencida: marcas bloqueadas no Quartel e ignoradas em `battle_ctx()`.
7. Quartel operável por **mouse, controle e toque** (alvos de toque do `Game.touch_target_size()`), sem mexer no botão Jogar fixo (BUG-033).
8. Suíte inteira e smoke das nove fases sem falha; **bot** (alarme, não veredito): com as cinco marcas no nível 3 a taxa de passagem da fase 3 em diante cai de forma clara (meta inicial: menos da metade da taxa sem marcas, perfil veterano) e sem marcas não piora.

## Fora de escopo

Elites despertos, Chefe desperto, Abismo vivo, Sem trégua, relíquia (SPEC-119), qualquer arte nova (ícones por marca usam texto e os componentes atuais), commit, push, build e exportação.

## Riscos

- Marcas na run inteira se acumulam com `dmg_mult` até ×2,5 e `hp_mult` até ×6,5 das fases tardias: o nível máximo pode ser quase intransponível (aceito: é opcional, e o bot mede).
- Fome no nível 3 pode travar builds sem fonte de cura (aceito e sinalizado no Quartel).
- `core/battle.gd` é um arquivo grande e partilhado: tocar só nos pontos listados, sem refatorar.

## Como ficou (2026-10-07, EVID-196 e EVID-192)

Diferenças em relação ao rascunho, todas dentro do escopo aprovado:
- **Interface:** aba própria **Marcas** (logo depois de Jogar) em vez de painel dentro de Jogar; a aba Jogar mostra só o resumo. Motivo: não mexer no layout de Jogar nem no botão fixo (BUG-033).
- **Fome:** a recuperação ao descer pelo portal também é reduzida, porque passa por `_heal_hero`; reviver e a restauração de PV ao iniciar não são.
- **Bot:** a medição usa `tools/bot_curva.gd` (já tinha o perfil veterano e o CSV por fase), não `tools/bot.gd`.
- **Números:** nenhum ajuste; a meta do aceite 8 foi atingida (todas no nível 3 = 0,00 fases vencidas contra 1,56 sem marcas). Candidatas se o playtest achar injusto: `per_level` de Fome e Fúria.
- Premissas A1 a A3 mantidas como propostas.

## Atualização (2026-10-07, SPEC-143)
A **regra de liberação** desta spec (vitória na fase inicial) foi **substituída** pela SPEC-143: cada marca é liberada por uma conquista própria, em qualquer fase. O recorde e as conquistas de pontuação continuam exigindo vencer o chefe da fase inicial com as marcas (agora 5, 10, 15, 20 e 25 pontos). O restante desta spec segue valendo.
