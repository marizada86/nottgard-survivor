# EVID-195 — Marcas do Abismo, entrega 2 (B-001 a B-005)

Plano: PLAN-076 · Spec: SPEC-143 · Cartões: MEC-040, BAL-016 · Data: 2026-10-07 · Base: commit `78c6f39` (entrega 1). **Sem commit, push, build nem exportação.**

## B-001 Liberação por conquista
- `data/abyss_marks.json`: nove marcas na ordem da progressão (Carapaça, Pressa, Horda, Elites despertos, Fúria, Abismo vivo, Fome, Chefe desperto, Sem trégua), `requires` por marca, `max_level` por marca (Sem trégua = 1), parâmetros das novas.
- `data/achievements.json`: nove conquistas "Marca do Abismo: X" (`unlock_mark`, só liberação, nenhuma exige marcas) e as de pontuação **Coroa do Abismo** (20, 1.200 moedas) e **Abismo Desperto** (25, 2.000); texto de Abismo Sem Fundo (15) ajustado.
- `core/abyss_marks.gd` (`max_level(id)`, `requires(id)`, `keep_unlocked`), `core/profile.gd` (`abyss_mark_unlocked`, `abyss_unlocked_ids`; `abyss_unlocked(fase)` saiu), `core/game.gd` (`run_abyss_marks` descarta só as bloqueadas).

## B-002 Quatro marcas no combate (`core/battle.gd`)
- **Elites despertos:** +1 afixo por nível (sem repetir, no limite do conjunto, RNG própria `abyss_rng`); nível 3 solta 1 elite extra por minuto, só antes do chefe.
- **Chefe desperto:** PV ×(1 + 0,30·nível) e fase extra a 15 % (anel de 8 + 4·nível projéteis e fúria), uma vez só.
- **Abismo vivo:** intervalo da regra do andar ÷ (1 + 0,3334·nível) (×2 no nível 3), chance das ilusões ×, Estige intacto; a regra é copiada, o dado da fase não muda; vale na run inteira.
- **Sem trégua:** sem loja, ferreiro nem curandeiro nos sorteados e nos fixos do cenário (Oficina do Cais, das Docas).

## B-003 Interface
`ui/abyss_panel.gd` reescrito: nove linhas, cada bloqueada mostra a conquista e a condição (laranja), − e + desativados, resumo "Marcas liberadas: N de 9", total até 25 pontos; ao abrir a aba o foco automático rolava para o fim, corrigido (`_on_shown`). Capturas 1280×720: [topo](../generated/abyss-marks/v02/quartel-marcas-1280.png), [fim](../generated/abyss-marks/v02/quartel-marcas-fim-1280.png), [Jogar](../generated/abyss-marks/v02/quartel-jogar-1280.png).

## B-004 Medição com o bot (alarme, não veredito)
`tools/bot_curva.gd`: `all=max` e valor `max` por marca. Perfil veterano, mapa 60. Fases vencidas por run (dados em [sweep-6-sementes](../generated/abyss-marks/v02/sweep-6-sementes/) e [sweep-18-sementes](../generated/abyss-marks/v02/sweep-18-sementes/)).

| Configuração (6 sementes; Durvall, Maelor, Korrak) | Fases vencidas por run |
|---|---|
| Sem marcas | 1,11 |
| Elites despertos 3 | 1,61 |
| Chefe desperto 3 | 0,94 |
| Abismo vivo 3 | 1,61 |
| Sem trégua 1 | 1,28 |
| Todas no nível 3 / todas no máximo (25 pontos) | **0,00** / **0,00** |

Amostra maior (18 sementes; Maelor e Korrak, 36 runs por linha):

| Configuração | Fases vencidas por run | Dagruve vencida | PV mínimo médio | Dano recebido médio | Duração do chefe |
|---|---|---|---|---|---|
| Sem marcas | 2,00 | 31/36 | 35 % | 296 | 339 s |
| Elites despertos 3 | 2,14 | 33/36 | 35 % | 278 | 349 s |
| Abismo vivo 3 | 2,39 | 35/36 | 34 % | 369 | 378 s |
| Chefe desperto 3 | 1,92 | 32/36 | 32 % | 396 | **511 s** |

**Leitura:**
- Chefe desperto faz o que promete (luta +51 %, dano recebido +34 %), mas não mata o bot, que cai nas fases tardias por massa de inimigos.
- **Abismo vivo e Elites despertos não endurecem o bot** (sinal contrário, dentro do ruído; Abismo vivo ainda sobe por causa das bênçãos do ritual de Dagruve, que acontecem mais vezes). Sem trégua não pesa para o bot, que não usa loja nem curandeiro. O aceite 8 foi lido como "alarme": o conjunto máximo derruba a zero, sem marcas a run é a de antes. **Nenhum número foi ajustado.**
- Candidatas se o playtest confirmar: Elites despertos com elite extra já no nível 2 e menos XP do elite com a marca; Abismo vivo sem a bênção do ritual extra; Sem trégua com custo maior de loja fora dela (não existe).
- O jogo **sem marcas** deu 2,83 → 2,33 fases por run (Korrak, 6 sementes) e 1,83 → 1,00 (Maelor, 6 sementes) em relação à varredura da entrega 1: a causa está nos trechos da economia de ouro (PLAN-075) no `core/battle.gd` em trabalho (chance de moeda por abate sem o bônus de `gold_pct`, valor de venda ×`coin_mult`, ouro sem arredondar), **não** nas Marcas. Prova: com marcas desligadas, a run da árvore atual e a do HEAD têm a mesma RNG, os mesmos nascimentos, inimigos, PV e abates (600 passos, três fases, semente 11).

## B-005 Validação
| Verificação | Resultado |
|---|---|
| `tests/test_abyss_marks.gd` (liberação por conquista e mapa das nove, ordem, `max_level` por marca; Elites, Chefe, Abismo vivo, Sem trégua; pontos até 25; aba Marcas com bloqueio por marca, − e +, Sem trégua de um nível só; botão Jogar fixo; save real intacto) | 0 falhas |
| Suíte inteira | 0 falhas |
| Smoke das nove fases, sem marcas | 9 de 9 em `running` |
| Smoke das nove fases, nove marcas no máximo (perfil isolado) | 9 de 9 em `running`, nível 25 |
| Importação Godot | sem erro de script |

## Ponto aberto para o dono
O teto de moeda da economia de ouro (`reward_cap` 3,0 em `data/difficulty.json`, em trabalho no PLAN-075) **limita o bônus das Marcas acima de 20 pontos** (+250 % no máximo de 25 pontos viraria ×3,5, mas o multiplicador para em ×3,0). A aba e o resultado mostram o bônus sem o teto. Decidir entre subir o teto, excluir o bônus das Marcas dele ou aceitar.
