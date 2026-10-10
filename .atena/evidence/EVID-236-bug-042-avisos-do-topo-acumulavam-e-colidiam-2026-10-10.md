# EVID-236 — BUG-042: avisos do topo acumulavam e colidiam (2026-10-10)

**Origem:** dono, "vamos tentar arrumar isso: BUG-036 / PLAN-080 / SPEC-147"; sintoma escolhido: "avisos sobre avisos".
**Desvio:** DEV-034 (PLAN_DEVIATION do PLAN-071); rota "fazer agora e voltar"; aprovação por plano (PLAN-094, SPEC-167).

## Causa (reproduzida em 1280×720; capturas em `.atena/generated/bug-036-diag/`)
O `TopStack` do PLAN-080 impede que chefe, quests, status e avisos se cubram *dentro* da pilha. Ficaram quatro falhas fora dela:

| # | Falha | Medido antes |
|---|---|---|
| F1 | `toast()` testava `get_child_count() >= 4` e liberava só o filho 0 com `queue_free()` (efetivo no fim do quadro); chamadas do mesmo quadro liberavam o mesmo nó | rajada de 6 + epígrafe + rumor + 1 = 8 avisos vivos, 234 px |
| F2 | Sem teto de altura, a pilha descia até o centro da tela | avisos de y=90 a y=324, herói em y≈330 |
| F3 | A fala do herói (`hero_node.position + (−95, −118)`, y≈215–245) caía dentro da zona dos avisos | "Mais um rito contra a névoa." no meio da epígrafe (`c_longas_1280x720.png`) |
| F4 | Aviso longo de 640 px saía da pilha de 680 px (x 300–980) e invadia a ficha (até x=385) | epígrafe começando em x=336 (`a_abertura_1280x720.png`) |

## Correção
- `ui/hud.gd`: `toast()` passou a `_show_toast()` com `_trim_toasts()`: conta só os avisos vivos, remove o mais antigo na hora (`remove_child` + `queue_free`) até `TOAST_MAX_COUNT = 4` e `TOAST_MAX_HEIGHT = 120` px; largura `TOAST_WIDTH = 470` (o bloco encolheu de 680 para 470 e ficou `SHRINK_CENTER`, x 405–875); aviso com mais de 60 caracteres entra numa fila e só um longo fica vivo; `toast_rect()` devolve o retângulo dos avisos vivos.
- `ui/run.gd`: `_bark()` só registra o pedido; `_update_pending_bark()` (no `_process`, depois do layout) mostra a fala quando o retângulo dela não intercepta o dos avisos, ou depois de 6 s mesmo assim. A posição da fala não mudou.
- `tests/test_playtest_fixes.gd`: `_avisos()`.

## Verificação
| Verificação | Resultado |
|---|---|
| Suíte (`tests/run_all.gd`) | 0 falhas |
| `test_playtest_fixes` isolado | 0 falhas; **mutação** (`_trim_toasts` sem efeito): 3 falhas (6 vivos, 6 filhos, 140 px) |
| Smoke das 9 fases | ok |
| `kit_test` | OK |
| `mobile_buttons_check` | 146/0 |
| `controller_check --headless` | 90/0 |
| Run real, Docas, sem quests, rajada de 6 avisos | 4 avisos, 92 px, fala livre, herói descoberto (`e_rajada_limpa_1280x720.png`) |

## Pendências e limites (não resolvidos)
1. **Com 3 quests e chefe vivos** a pilha de avisos começa em y=247 (abaixo do painel de quests) e vai até y≈340, sobre a cabeça do herói (`e_rajada_quests_1280x720.png`). Não há sobreposição entre avisos, mas ocupam o centro da tela. Decisão do dono pendente: avisos acima do painel de quests, limite menor com quests, ou deixar para o plano de "mensagens ao centro".
2. Uma fala **já visível** quando um aviso chega por cima não cede; sobrepõe por até 2,6 s (só acontece com quests, onde a pilha começa em y=247 e a fala vai de y≈224 a y≈260).
3. A medição em 1920×1080 não foi feita: com `stretch/aspect="expand"` a base é 1280×720 e o layout do topo é o mesmo; o teste cobre só 1280×720.
4. Subjetivo (a leitura em jogo ficou boa? o tempo de cada aviso?) aguarda playtest.

## Atualização (2026-10-10)
A pendência 1 foi resolvida pelo questlog à direita (MEC-064, [SPEC-168](../specs/SPEC-168-questlog-a-direita-sem-moldura-mec-064.md), [EVID-237](EVID-237-mec-064-questlog-a-direita-sem-moldura-2026-10-10.md)): o painel de quests saiu da pilha do topo e os avisos voltam a começar em y=90 com quests e chefe. As opções (a) e (b) não foram implementadas.
