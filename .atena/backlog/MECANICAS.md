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
| MEC-006 | — | *Absorvido por MEC-019 (T02, EVID-107).* Era: hover com mais detalhe no painel de itens (resposta 2 do EVID-091). Pode já estar coberto pela ficha da SPEC-059 | EVID-091 resposta 2 | — | — |
| MEC-007 | baixo | Aumentar a frequência de quebráveis (spawn) e balancear recompensas; possível escala com o atributo Carisma (Cha) | [EVID-106](../evidence/EVID-106-playtest-publico-t01-higor-2026-09-29.md) IN-004, IN-005 · **2 relatos + 1 "em parte" (T02)** | —; T03 Q5 concorda | — |
| MEC-008 | médio | Destacar evoluções de arma entre as opções de level-up e indicar como evoluir (dica das condições) | [EVID-106](../evidence/EVID-106-playtest-publico-t01-higor-2026-09-29.md) IN-006, IN-008 | —; T02 Q6 concorda; T03 Q6 "em parte", **prioridade 3ª** | — |
| MEC-009 | médio | Mini-cinemática que pausa o jogo ao evoluir arma, mostrando as condições envolvidas | [EVID-106](../evidence/EVID-106-playtest-publico-t01-higor-2026-09-29.md) IN-008 | ART-014 | — |
| MEC-010 | alto | Acelerar rejogabilidade: opção **2x** em mapas já vencidos, evento que adianta o tempo do mapa (punição: spawns acumulados de uma vez), reduzir o tempo entre mapas | [EVID-106](../evidence/EVID-106-playtest-publico-t01-higor-2026-09-29.md) IN-007, IN-012 | —; T02 Q9 concorda (**prioridade 3ª**); T03 Q9 concorda, **prioridade 2ª** (3 de 3) | — |
| MEC-011 | alto | IA dos inimigos: circular, flanquear, cercar (o travamento em objetos é o BUG-012) | [EVID-106](../evidence/EVID-106-playtest-publico-t01-higor-2026-09-29.md) IN-009 | — | — |
| MEC-012 | alto | Mapas maiores ou com loop, contra a sensação "claustrofóbica"; permite melhor distribuição de objetos | [EVID-106](../evidence/EVID-106-playtest-publico-t01-higor-2026-09-29.md) IN-011 | —; T02 Q8 concorda (**prioridade 2ª**); T03 Q8 **discorda** | — |
| MEC-013 | médio | Baú de chefe com recompensa melhor que os baús comuns | [EVID-106](../evidence/EVID-106-playtest-publico-t01-higor-2026-09-29.md) IN-013; T02 Q10 confirma, "apenas 1 baú"  | ART-011; T03 Q10 concorda | — |
| MEC-014 | médio | Progressão tardia estagna (de Shendilavri em diante o herói não melhora); rebalancear e dar variáveis que ajudem ou atrapalhem | [EVID-106](../evidence/EVID-106-playtest-publico-t01-higor-2026-09-29.md) IN-014; T02 Q11 confirma e propõe **aumento de status e de HP máx.** entre fases | —; T03 Q11 não notei (não chegou lá) | — |
| MEC-015 | alto | Novos sumidouros de moeda no meta: T01 comprou a loja inteira com ~30 000 moedas. Aprimoramentos, desbloquear eventos, comprar HQ (cutscene de imagens estilo "Nottcard") | [EVID-106](../evidence/EVID-106-playtest-publico-t01-higor-2026-09-29.md) IN-016 | ART-013; T02 Q13: +23 354 moedas na run; propõe **upgrades mais caros ou moedas menos frequentes**; T03 Q13 não notei (não chegou lá) | — |
| MEC-016 | alto | Ampliar conquistas com recompensas balanceadas (lojas, catálogo de armas, biografias dos personagens) e travar mecânicas por conquista (ex.: melhoria "Mão cheia"). Pede recomendações da Atena | [EVID-106](../evidence/EVID-106-playtest-publico-t01-higor-2026-09-29.md) IN-017 | ART-013; T02 Q14 concorda; T03 Q14 concorda | — |
| MEC-017 | baixo | Dano da névoa baixo demais (ajuste de números) | [EVID-106](../evidence/EVID-106-playtest-publico-t01-higor-2026-09-29.md) IN-002 | ART-008 | — |
| MEC-018 | médio | Mostrar o **dano real** de arma e magia com os atributos do herói (mín./máx.) e **evidenciar se escala por FOR ou INT** (físico ou mágico), na ficha `C` e nas ofertas de arma | [EVID-107](../evidence/EVID-107-playtest-publico-t02-hiago-2026-09-29.md) IN-020, IN-029 · **2 relatos** | ART-007 (números/UI) | — |
| MEC-019 | médio | **Comparação de equipamento:** na loja, forja e oferta de item, marcar o slot ocupado e mostrar o que ganha/perde ao trocar (equipado → novo); detalhe também ao passar o mouse. Absorve MEC-006 | [EVID-107](../evidence/EVID-107-playtest-publico-t02-hiago-2026-09-29.md) IN-021, IN-023, IN-027 + texto livre · [EVID-091](../evidence/EVID-091-playtest-higo-hiago-build-c-e-item-offer-2026-09-28.md) resposta 2 · **5 relatos** | —. **IMPLEMENTADO 2026-09-29** ([[SPEC-081-comparacao-de-equipamento]]), validação em playtest | — |
| MEC-020 | baixo | Fontes ("+% PV") menos frequentes, "mas não muito" (ajuste de números) | [EVID-107](../evidence/EVID-107-playtest-publico-t02-hiago-2026-09-29.md) IN-024 | — | — |
| MEC-021 | médio | *A confirmar:* manter um item 3 vezes consecutivas aumenta o nível dele. Significado da nota é ambíguo; perguntar a Hiago | [EVID-107](../evidence/EVID-107-playtest-publico-t02-hiago-2026-09-29.md) IN-025 | — | — |
| MEC-022 | baixo | Perda de INT do Estige **temporária (5 min)**. Hoje é permanente na run: `styx_lucidity_loss` só zera ao iniciar (`core/battle.gd:166`) | [EVID-107](../evidence/EVID-107-playtest-publico-t02-hiago-2026-09-29.md) IN-031 | — | — |
| MEC-023 | médio | Loja e ferreiro **mostram todas as opções**, inclusive as sem moeda (esmaecidas, com preço), e explicam quando não há nada a comprar/melhorar. Hoje só entram na lista as opções que o herói pode pagar (`core/battle.gd`), e a janela fica só com "Sair" | [EVID-108](../evidence/EVID-108-playtest-publico-t03-dna-2026-09-29.md) IN-033 (print 001) | —. **IMPLEMENTADO 2026-09-29** ([[SPEC-082-loja-e-ferreiro-mostram-todas-as-opcoes]]), validação em playtest | — |
| MEC-025 | médio | HQs de transição do Nottcard: tela de HQ (Esc pula), `hqs_seen` no perfil, gatilho na primeira vitória de cada fase e Diário no Quartel. Sem efeito no combate. Aguarda decisões D1 a D5 | [SPEC-080](../specs/SPEC-080-hqs-de-transicao-do-nottcard.md) · [EVID-109](../evidence/EVID-109-importacao-das-hqs-do-nottcard-2026-09-29.md) | ART-013 (arte já existe) | — |
| MEC-024 | médio | Mais dificuldade e mais mobs **no início da campanha** (curva mais dura no começo, mais fácil ao evoluir). T03 pede **mais mobs, mais dano e menos PV** (confirmado pelo dono). Exige rodada do bot **por herói**: sinais divergem entre T02 e T03. Ver PLAN-038 | [EVID-108](../evidence/EVID-108-playtest-publico-t03-dna-2026-09-29.md) IN-035, IN-037, IN-039 · 1 relato | —. **IMPLEMENTADO 2026-09-29** ([[SPEC-083-abertura-de-fase-mais-cheia]]), só mais mobs nos primeiros minutos, por decisão do dono | — |
| MEC-026 | médio | Regra do ritual (BUG-014): interromper o ritual dá **Bênção do Selo** temporária (+20% dano, +15% velocidade, +1,0 coleta por 20 s). **IMPLEMENTADO 2026-09-29** ([[SPEC-084-bencao-do-selo-no-ritual]]) | [EVID-107](../evidence/EVID-107-playtest-publico-t02-hiago-2026-09-29.md) IN-019, EVID-106 IN-001 · T03 discordou | — | [[SPEC-084-bencao-do-selo-no-ritual]] |

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
