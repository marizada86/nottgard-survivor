# EVID-192 — Marcas do Abismo, B-002 a B-005 (perfil, interface, bot e validação)

Plano: PLAN-074 · Spec: SPEC-141 · Cartões: MEC-040, BAL-016 · Data: 2026-10-07 · Continua [EVID-196](EVID-196-marcas-do-abismo-b001-nucleo-de-combate-2026-10-07.md). **Sem commit, push, build nem exportação.**

## B-002 Perfil, recompensa e conquistas
- `core/profile.gd`: `record_abyss` (recorde por herói e fase inicial, só com vitória nela), `abyss_best_for`, `abyss_best_level`, `abyss_unlocked`; `apply_run` devolve `abyss_record`; stat `abyss_best_level`; `settings.abyss_marks` no perfil novo.
- `core/game.gd`: `abyss_marks()`, `run_abyss_marks()` (ignora as marcas se a fase inicial não foi vencida), `set_abyss_marks()` (grava no perfil); `battle_ctx()` entrega `abyss_marks`.
- `data/achievements.json`: Marcado pelo Abismo (5, 200 moedas), Selo do Abismo (10, 400) e Abismo Sem Fundo (15, 800); só moedas.

## B-003 Interface
- `ui/abyss_panel.gd` (novo): aba **Marcas**, logo depois de **Jogar**; cinco linhas com − / +, nível, descrição, total, bônus de moeda, recorde, "Zerar marcas" e aviso de bloqueio; mouse, controle (foco nativo dos botões) e toque (`TouchUI.adapt_sizes`).
- `ui/menu.gd`: cria a aba, atualiza ao trocar herói ou fase e acrescenta o resumo em "Fase". **Decisão de implementação:** aba própria, e não painel dentro de Jogar, para não mexer no layout de Jogar nem no botão fixo (BUG-033).
- `ui/hero_panel.gd`: selo roxo "Marcas N" no painel da HUD, com tooltip das marcas. `ui/hud.gd`: linha "Marcas do Abismo: nível N (moedas +X%)" e "★ novo recorde" no resultado.
- `tools/controller_check.gd`: a aba de Opções agora é achada pelo nome, porque a nova aba deslocou os índices (**ferramenta não reexecutada**: ela grava em `.atena/generated/controller-experience/v02/` e não quis sobrescrever aquela evidência).
- Capturas 1280×720: [aba Marcas](../generated/abyss-marks/v01/quartel-marcas-1280.png), [aba Jogar](../generated/abyss-marks/v01/quartel-jogar-1280.png), [HUD](../generated/abyss-marks/v01/hud-marcas-1280.png). Tudo cabe, sem corte.

## B-004 Medição com o bot
`tools/bot_curva.gd` ganhou o 7º argumento (`all=3` ou `horda=2,fome=1`). Perfil **veterano** (meta 1), Durvall, Maelor e Korrak, 6 sementes cada (18 runs por configuração), `dt` 0,08, mapa 60. Dados brutos em [sweep/](../generated/abyss-marks/v01/sweep/).

| Configuração | Fases vencidas por run (todos) | Maelor | Korrak | Dagruve vencida |
|---|---|---|---|---|
| Sem marcas | 1,56 | 1,83 | 2,83 | 10/18 |
| Todas no nível 1 (5 pontos) | 0,72 | 1,33 | 0,83 | 9/18 |
| Todas no nível 3 (15 pontos) | **0,00** | 0,00 | 0,00 | 0/18 |
| Só Horda 3 | 1,11 | 1,00 | 2,33 | 11/18 |
| Só Fúria 3 | 0,61 | 0,67 | 1,17 | 9/18 |
| Só Carapaça 3 | 1,33 | 2,00 | 2,00 | 12/18 |
| Só Pressa 3 | 1,17 | 1,33 | 2,17 | 11/18 |
| Só Fome 3 | 0,56 | 0,50 | 1,00 | 8/18 |

Durvall não vence nem Dagruve sem marcas (0,00 em todas as linhas, exceto 0,17 na Fome): é o BAL-015 já aberto, não efeito das marcas.

- **Meta do aceite 8:** atingida. As cinco marcas no nível 3 derrubam as fases vencidas de 1,56 para 0,00 (menos da metade); sem marcas a run é idêntica à de antes (EVID-196).
- **Ordem de dureza (nível 3, isolada):** Fome ≈ Fúria (−64 % e −61 %) > Horda (−29 %) > Pressa (−25 %) > Carapaça (−15 %). Cada marca isolada pesa menos que o conjunto; 5 pontos (todas no nível 1) já cortam 54 %.
- **Limitações:** o bot não usa loja, ferreiro nem curandeiro e não explora eventos, então a Fome e a Fúria tendem a parecer piores para ele do que para uma pessoa (alarme, não veredito). A amostra de fases 3+ ficou pequena (18 passagens sem marcas), por isso a taxa de passagem dessas fases não foi usada como critério.
- **S-009:** sem ajuste de número (meta atingida; nenhuma alavanca mexida). Candidata se o playtest achar o nível 3 injusto: reduzir `per_level` de Fome e Fúria em `data/abyss_marks.json`, uma marca por vez.

## B-005 Validação
| Verificação | Resultado |
|---|---|
| `tests/test_abyss_marks.gd` (dados, identidade sem marcas, efeito por marca, Horda, Fome e seus pontos de cura, moeda, perfil, recorde, conquistas, liberação, aba Marcas, aba no menu, botão Jogar fixo, save real intacto) | 0 falhas |
| Suíte inteira | 0 falhas (avisos de limpeza ao sair já existiam) |
| Importação Godot | sem erro de script |
| Smoke das nove fases, sem marcas (`tools/smoke.tscn`) | ok |
| Smoke das nove fases com as cinco marcas no nível 3 (perfil isolado) | ok, nível 15 em todas |
| `tools/backlog_check.ps1` | mesmos 3 alertas de antes (ART-036, ART-037 e MEC-049 duplicados), nenhum novo |

## Para o commit (quando você aprovar)
Arquivos **só desta mecânica**: `core/abyss_marks.gd`, `data/abyss_marks.json`, `ui/abyss_panel.gd`, `tests/test_abyss_marks.gd` e os `.uid`. Arquivos **compartilhados com a economia de ouro (PLAN-075, outra sessão)**, que pedem `git add -p`: `core/battle.gd` (os trechos de `_add_gold`, `_drop` e `_collect` são dela; no `_collect` ela e eu tocamos o evento de poção, em linhas vizinhas), `tools/bot_curva.gd` (as linhas `GOLD;` são dela; o `_parse_marks` é meu). Arquivos meus nos demais: `core/profile.gd`, `core/game.gd`, `ui/menu.gd`, `ui/hud.gd`, `ui/hero_panel.gd`, `data/achievements.json`, `tools/controller_check.gd` e os registros `.atena/`.
