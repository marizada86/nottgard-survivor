# MECÂNICAS — o que muda o comportamento do jogo

Limite: **2 mecânicas por lote de lançamento**. Risco: **baixo** (só JSON) ·
**médio** · **alto** (nova forma de jogar). Só abre spec com o lote de bugs
anterior fechado (ver [README](README.md)).

## Abertos

| ID | Risco | Mecânica | Origem | Depende de (arte) | Spec |
|---|---|---|---|---|---|
| MEC-001 | baixo | Navegar decisões de run só com teclado: WASD escolhe, Enter confirma (level-up, altar, recompensas, ofertas) | [EVID-088](../evidence/EVID-088-qa-leoric-dagruve-2026-09-27.md) nota 1 · [PLAN-029](../vault/drafts/PLAN-029-triagem-evidencia-qa-leoric-e-ux-2026-09-27.md) | — | — |
| MEC-002 | baixo | Barra de progresso da fase: quanto falta até o fim do mapa | EVID-088 nota 3 | ART-002 (layout do HUD) | — |
| MEC-003 | médio | Menu de pausa (Esc) ampliado: catálogo de itens (desbloqueados visíveis, bloqueados escuros sem info) e tela de configurações. O guia `?` já existe (SPEC-057) | EVID-088 nota 2 | ART-003 (layout do catálogo) | — |
| MEC-004 | médio | Item/consumível de dano temporário (ex.: lança-chamas por 15 s), reaproveitando o padrão de habilidade ativa | [PLAN-030](../vault/drafts/PLAN-030-backlog-hiago-itens-equipamento-e-economia-2026-09-27.md) item 5 | ART-004 (ícone + efeito) | — |
| MEC-005 | médio | Mais eventos aleatórios além de loja, ferreiro e curandeiro. **Reforço:** ideia de evento de risco/recompensa (doar item/arma/habilidade por bênção diferente ou melhorada). Refs: Spell Brigade, Death Must Die, Vampire Survivors, eventos de Diablo IV | [EVID-091](../evidence/EVID-091-playtest-higo-hiago-build-c-e-item-offer-2026-09-28.md) resposta 10 · PLAN-032; [EVID-106](../evidence/EVID-106-playtest-publico-t01-higor-2026-09-29.md) IN-014 · **3 relatos** | ART-005 (prop/ícone por evento) | — |
| MEC-006 | — | *A confirmar:* hover com mais detalhe no painel de itens (resposta 2 do EVID-091). Pode já estar coberto pela ficha da SPEC-059 | EVID-091 resposta 2 | — | — |
| MEC-007 | baixo | Aumentar a frequência de quebráveis (spawn) e balancear recompensas; possível escala com o atributo Carisma (Cha) | [EVID-106](../evidence/EVID-106-playtest-publico-t01-higor-2026-09-29.md) IN-004, IN-005 · **2 relatos** | — | — |
| MEC-008 | médio | Destacar evoluções de arma entre as opções de level-up e indicar como evoluir (dica das condições) | [EVID-106](../evidence/EVID-106-playtest-publico-t01-higor-2026-09-29.md) IN-006, IN-008 | — | — |
| MEC-009 | médio | Mini-cinemática que pausa o jogo ao evoluir arma, mostrando as condições envolvidas | [EVID-106](../evidence/EVID-106-playtest-publico-t01-higor-2026-09-29.md) IN-008 | ART-014 | — |
| MEC-010 | alto | Acelerar rejogabilidade: opção **2x** em mapas já vencidos, evento que adianta o tempo do mapa (punição: spawns acumulados de uma vez), reduzir o tempo entre mapas | [EVID-106](../evidence/EVID-106-playtest-publico-t01-higor-2026-09-29.md) IN-007, IN-012 | — | — |
| MEC-011 | alto | IA dos inimigos: circular, flanquear, cercar (o travamento em objetos é o BUG-012) | [EVID-106](../evidence/EVID-106-playtest-publico-t01-higor-2026-09-29.md) IN-009 | — | — |
| MEC-012 | alto | Mapas maiores ou com loop, contra a sensação "claustrofóbica"; permite melhor distribuição de objetos | [EVID-106](../evidence/EVID-106-playtest-publico-t01-higor-2026-09-29.md) IN-011 | — | — |
| MEC-013 | médio | Baú de chefe com recompensa melhor que os baús comuns | [EVID-106](../evidence/EVID-106-playtest-publico-t01-higor-2026-09-29.md) IN-013 | ART-011 | — |
| MEC-014 | médio | Progressão tardia estagna (de Shendilavri em diante o herói não melhora); rebalancear e dar variáveis que ajudem ou atrapalhem | [EVID-106](../evidence/EVID-106-playtest-publico-t01-higor-2026-09-29.md) IN-014 | — | — |
| MEC-015 | alto | Novos sumidouros de moeda no meta: T01 comprou a loja inteira com ~30 000 moedas. Aprimoramentos, desbloquear eventos, comprar HQ (cutscene de imagens estilo "Nottcard") | [EVID-106](../evidence/EVID-106-playtest-publico-t01-higor-2026-09-29.md) IN-016 | ART-013 | — |
| MEC-016 | alto | Ampliar conquistas com recompensas balanceadas (lojas, catálogo de armas, biografias dos personagens) e travar mecânicas por conquista (ex.: melhoria "Mão cheia"). Pede recomendações da Atena | [EVID-106](../evidence/EVID-106-playtest-publico-t01-higor-2026-09-29.md) IN-017 | ART-013 | — |
| MEC-017 | baixo | Dano da névoa baixo demais (ajuste de números) | [EVID-106](../evidence/EVID-106-playtest-publico-t01-higor-2026-09-29.md) IN-002 | ART-008 | — |

### Sugestão de lotes (Atena)

1. **Lote M1 — baixo risco:** MEC-001 + MEC-002 (ou MEC-007 no lugar de um deles, que só mexe em JSON). Só
   mexem em entrada, HUD e números simples.
2. **Lote M2 — conteúdo novo:** MEC-004 + MEC-005, depois de o playtest público
   (PLAN-036) trazer dados. MEC-003 fica para um lote M3, porque toca Quartel e
   Códex.
3. Não decidir M2 antes das respostas: evita reagir a uma amostra única.

## Fechados (histórico do backlog do Hiago, [PLAN-030](../vault/drafts/PLAN-030-backlog-hiago-itens-equipamento-e-economia-2026-09-27.md))

| Mecânica | Spec | Evidência |
|---|---|---|
| Descrição de itens e slots visíveis + ficha de personagem (tecla `C`) | SPEC-059 | EVID-089, EVID-092 |
| Escolha de equipar ou vender loot | SPEC-060 | EVID-090 |
| Quebráveis por bioma + rebalanceamento de poção | SPEC-063 | EVID-093, EVID-095 |
| Loja, ferreiro e curandeiro | SPEC-064 | EVID-094 |
| Segurar clique para andar | SPEC-072 | EVID-096 |
| Nível de equipamento e super-upgrade | SPEC-073 | EVID-097 |
| Sinergias combinadas | SPEC-075 | EVID-099-spec-075 |
| Save resiliente e ajuda `?` | SPEC-057 | EVID-087-save |

Todos estão *implementados*; a verificação manual de cada um está em
[BUGS.md](BUGS.md) (BUG-003 a 010).
