---
id: "SPEC-176"
title: "Movimento dos heróis: marco M1 da demo (PLAN-103)"
status: "DRAFT r2 em 2026-10-14: escopo mudou de 'corrigir caminhos' para 'refazer as tiras de animação com contrato de prompt novo'; aguarda aprovação do lote B-002"
origin: planned
implementation_preceded_spec: false
request_classification: PLAN_CHANGE_REQUEST
created: "2026-10-14"
revision: "r2 (2026-10-14)"
relations: ["[[PLAN-103-demo-completa-e-polida-2026-10-14]]", "[[SPEC-123-revisao-da-movimentacao-dos-herois]]", "[[SPEC-144-diagnostico-do-patinar-ao-andar-bug-028]]", "[[SPEC-154-pixels-soltos-dos-herois-pre-reducao-das-tiras-bug-029]]", "[[SPEC-112-normalizacao-base-e-bordas-dos-herois]]", "[[SPEC-160-arlindo-orlando-e-erik-blackthorn-jogaveis]]"]
cards: ["BUG-025", "BUG-027", "BUG-028", "BUG-029", "ART-033", "ART-045", "ART-031"]
content_state: DRAFT
---

# SPEC-176 — Movimento dos heróis (M1), r2

Origem: PLAN-103, marco M1, decisão D7 do dono (2026-10-14): "marco próprio, com decisão sua pelo olho". **Revisão r2 (mesmo dia):** o dono decidiu **refazer as tiras de animação dos heróis do zero**, com prompts novos e mais assertivos, sem inimigos como referência, usando referências temáticas e do vault e o idle atual como base. Risco: **alto** em esforço de arte (≈144 tiras); **médio** em integração (reversível por herói); sem regras de jogo.

## Decisões do dono (2026-10-14)

| # | Decisão |
|---|---|
| D13 | **Escopo de arte:** só as tiras de animação (`idle`, 8 `move_*`, `attack`, `active`, `death`). O idle e o retrato atuais seguem como **base de identidade** |
| D14 | **Ordem:** piloto em **um herói** (Durvall), depois lotes de 3 a 4 heróis, com gate visual seu em cada lote |
| D15 | **Código em paralelo:** o laboratório de caminhos de código para o patinar (ritmo, velocidade, balanço procedural) e a coleta H5 continuam |
| D16 | **Referências por herói:** ficha do personagem no **Vault**, arte do **Nottcard** (somente leitura) e **imagens de referência do dono**; nenhum inimigo |

## Revisão do diagnóstico (lido nos prompts antigos em 2026-10-14)

| Ponto | Achado |
|---|---|
| Inimigos como imagem anexada | **Não houve.** Em ART-PROMPTS-055, 056 e 060, Zumbi e Bandido só aparecem como **faixa de métrica** (≤ 9 px de deslocamento, ≤ 16% de largura) e na SPEC-123 ("se baseie na movimentação deles") |
| O que foi anexado | O `idle.png` e a **tira defeituosa atual**, "apenas como referência de pose" |
| Hipótese de causa do insucesso de regerar | Anexar a tira defeituosa reinjeta corte, massa e base erradas; seis quadros por chamada com oito regras de dimensão misturadas ao desenho |
| Passada | A arte desenha pés lentos em **todas** as direções (EVID-197); nenhum prompt anterior trazia passada numérica |

Consequências r2: Zumbi e Bandido **deixam de ser referência** (nem de métrica); a régua passa a ser o **idle do próprio herói**; a tira defeituosa **não é mais anexada**; a passada entra no prompt como número.

## Estado de partida

| Tema | Estado |
|---|---|
| **BUG-028** patinar | Adiado; A+B (15 fps e `speed_scale`) testado no `.exe` e revertido; EVID-197: troca de tira e queda ao idle descartadas em campo livre com teclado; H5 e mouse/analógico dependem da coleta do dono |
| **BUG-027** costas | Zynara, Leoric e Nyrelia com `move_n` e `move_ne` de frente; ART-PROMPTS-056 pronto (será superado pelo contrato v2) |
| **BUG-029** pixels soltos | Causa medida (redução com vizinho mais próximo); mipmaps rejeitados; variante C não adotada; `HERO_STRIP_SET` vazio |
| **BUG-025** dimensões | PARCIAL; revisão completa de escala combinada para quando as imagens novas entrarem |
| **ART-045** | Erik e Arlindo com arte própria v04 integrada local; AO09, AO10, ER03 e ER06 pendentes |
| **Contrato de animação** (PLAN-001 §26) | Vale: 8 fontes de movimento independentes por herói; espelho só com simetria confirmada |
| Ferramentas prontas | `audit_hero_motion`, `equalize_hero_frames`, `normalize_hero_scale`, `measure_walk_stride`, `walk_trace_probe`, `reduce_hero_strips`, `ui/walk_trace.gd` e o lançador `.atena/generated/walk-debug/Abrir-jogo-com-diagnostico.cmd` |

**Heróis (12):** arlindo, bromnor, brook, durvall, erik, kayron, korrak, leoric, maelor, nyrelia, sylas, zynara. Inimigos, retratos e HQs ficam de fora.

## Achado da Fase A (2026-10-14, EVID-246)

A régua mostrou que, a 190 px/s e 6 quadros a 10 fps, o passo exigido vai de 0,67 a 1,43 alturas do corpo (heróis de 40 px são os piores). Por isso o contrato v2 (ART-PROMPTS-064) acopla **passo-alvo (≈ 0,55 × altura)** e **fps por herói** (12 a 26). O caminho C1 do laboratório (S-005) passa a incluir essa fórmula, e o G-D2 decide o ritmo antes do piloto.

## Princípios

1. **Identidade antes de produção.** Sem ficha de identidade revisada pelo dono, nenhum prompt do herói sai (regra de prontidão visual do projeto).
2. **Piloto antes de lote.** O contrato de prompt só vale para os demais depois do aceite visual do piloto.
3. **Referência limpa.** Anexos permitidos: idle atual (identidade), ficha do herói, arte temática do Vault/Nottcard e referências do dono. **Proibidos:** tira defeituosa e qualquer inimigo.
4. **Passada numérica.** O prompt carrega a passada-alvo em px e o ritmo do ciclo, derivados de `SPEED_PX` e do fps.
5. **Nada é apagado.** Originais ficam; cada herói tem entrada por tabela e volta ao estado anterior apagando a entrada.
6. **Código e arte em paralelo, sem dependência.** Se o laboratório de código resolver o patinar, a arte nova mantém o ganho (passada, costas, escala).
7. **Candidatas ficam DRAFT** em `.atena/generated/` até aceite do dono com evidência (PLAN-001 §17).

## Lotes e passos (B-002, aprovação por lote)

Portões do dono: **G-D1** a **G-D6**.

### Fase A — Preparação (sem alterar arquivos do jogo, sem gerar imagem)

| Passo | O que | Saída |
|---|---|---|
| S-001 | **Inventário enxuto** do que existe: por herói, as 12 tiras, quadros, altura e base do idle, margem de borda e o que será preservado até a substituição. Sem referência a inimigos | `.atena/generated/m1-movimento/inventario.csv` |
| S-002 | **Ficha de identidade por herói (DRAFT)** a partir do Vault, do Nottcard e do idle atual: aparência, rosto, cabelo, armadura, arma e **mão da arma**, capa, paleta, divindade e bioma de origem; lacunas explícitas; sem inventar lore; "cânone do mestre" não é revelado | 12 fichas em `.atena/vault/drafts/` |
| **G-D1** | **Dono revisa as fichas** (obrigatório: Durvall, Zynara, Leoric, Nyrelia; as outras antes do respectivo lote) e entrega suas imagens de referência | Fichas aprovadas por herói |
| S-003 | **Contrato de prompt v2**: bloco comum curto; uma tira por chamada; tabela de **poses-chave por quadro** (contato, descida, passagem, subida); **passada-alvo em px** e fps; âncora de base; margem; mão da arma; proibidos explícitos; saída 8 direções independentes | `ART-PROMPTS-064` (número reservado) |
| S-004 | **Régua por herói:** altura, base, largura de ombros, margem e passada-alvo medidos do **idle do próprio herói** | `reguas.csv` e checklist instanciado |

### Fase B — Laboratório de código para o patinar (paralelo, sem arte nova)

| Passo | O que | Saída |
|---|---|---|
| S-005 | Flags só de desenvolvimento para comparar lado a lado no mesmo herói: **C0** atual; **C1** ritmo e velocidade (ex.: 10/12/15 fps e 190/160/140 px/s); **C2** reforço procedural da passada (balanço vertical, inclinação sutil e sombra sincronizados) | Lançador, capturas e clipes |
| S-006 | **Coleta opcional do dono** (5 min, modos 1, 3 e 5): fecha H5 e o caso mouse/analógico | CSVs triados |
| **G-D2** | **Escolha do dono pelo olho** entre C0, C1, C2 ou combinação (decisão de apresentação; `SPEED_PX` só muda depois do bot) | Decisão registrada |

### Fase C — Piloto de arte (Durvall)

| Passo | O que | Saída |
|---|---|---|
| S-007 | **Prompts do piloto:** `move_e`, `move_se`, `move_s` e `attack` do Durvall pelo contrato v2 | Prompts e fila `CHATGPT-FILA-031` (reservada) |
| S-008 | **Auditoria técnica** das candidatas que o dono gerar: alfa real, grade, margem, altura e base contra a régua, passada medida | Relatório e prancha |
| **G-D3** | **Aceite visual do piloto e do contrato v2** (ou revisão do contrato e novo piloto) | Contrato v2 aprovado ou revisado |

### Fase D — Lotes de heróis (um gate visual por lote)

| Lote | Heróis | Observação |
|---|---|---|
| L1 | Durvall (completar), Zynara, Leoric, Nyrelia | Fecha BUG-027 (costas) com o método novo |
| L2 | Kayron, Korrak, Bromnor | Korrak: figurino único entre idle e andar (ART-031 entra aqui, se o dono quiser) |
| L3 | Sylas, Brook, Maelor | — |
| L4 | Erik, Arlindo | Arte v04 própria: só o que faltar (AO09, AO10, ER03, ER06) ou refazer, a critério do dono |

Para cada lote: **S-009** prompts → dono gera → **S-010** auditoria → **G-D4 (um por lote)** aceite visual → **S-011** integração local DRAFT com tabela por herói, escala e testes. A recaptura de pixels soltos (BUG-029) acontece no L1, já com a arte nova na escala final, e vira **G-D5**: variante, outra ideia sua ou "conhecido".

### Fase E — Aceite

| Passo | O que | Saída |
|---|---|---|
| S-012 | **Revisão de escala (BUG-025):** `HERO_IDLE_ART_HEIGHT` e `HERO_FEET_Y` dos 12, altura em tela inalterada salvo decisão | Linha de base nova |
| S-013 | **Verificação técnica:** suíte, `test_animation_assets`, marcos de pés, `edge_frames` = 0, trace em campo livre nas 8 direções, smoke das nove fases, `controller_check`, `mobile_buttons_check` | Relatório |
| S-014 | **Checklist em janela real:** 12 heróis × 8 direções, clipes ou GIFs e prancha final | Checklist por herói |
| **G-D6** | **Aceite do dono** do movimento dos 12 heróis | Recibo |
| S-015 | EVID, cartões BUG-025/027/028/029, ART-033/045/031, índices e "O que testar"; commit, push e build só com aprovação | Documentos |

## Critérios de aceite (checklist M1)

| # | Critério | Como se mede |
|---|---|---|
| CK-1 | **Costas ao andar para cima:** N e NE mostram costas ou 3/4 de costas; NO vem do espelho da mesma tira | Olho do dono; inventário |
| CK-2 | **Sem patinar perceptível** de lado e nas diagonais | Olho do dono (G-D2/G-D6) |
| CK-3 | **Altura estável** entre direções e entre idle, andar e ataque: ±3% da altura do idle **do próprio herói** | `audit_hero_motion` |
| CK-4 | **Base estável:** pés na mesma linha (±1 px) | `audit_hero_motion` |
| CK-5 | **Sem corte:** `edge_frames` = 0 e margem ≥ 2 px (≥ 10 px na entrega do gerador) | Auditoria |
| CK-6 | **Sem troca de tira nem queda ao idle** em campo livre | `walk_trace_probe` |
| CK-7 | **Pixels soltos:** ausentes em 1280×720 e 1920×1080, ou "conhecidos" por decisão (G-D5) | Prancha |
| CK-8 | **Espelho só com simetria**: nada espelhado que troque a mão da arma ou o lado do emblema | Ficha de identidade |
| CK-9 | **Altura em tela inalterada** (±1 px) salvo decisão registrada | Teste de escala |
| CK-10 | **Passada coerente com a velocidade:** passada desenhada por ciclo dentro da faixa calibrada na S-004 | `measure_walk_stride` |
| CK-11 | **Identidade fiel à ficha** aprovada em G-D1 (rosto, equipamento, mão da arma, paleta) | Olho do dono |

## Não objetivos

Retratos, HQs, inimigos e chefes; VFX de ataque e habilidade; balanceamento (a velocidade, se mudar, passa pelo bot antes de commit); mobile; arte fora das tiras de herói; promover qualquer coisa a canon.

## Lacunas

| Id | Lacuna | Classe | Tratamento recomendado |
|---|---|---|---|
| G1 | Imagens de referência do dono (D16) | RESOLVABLE | Dono entrega por herói em uma pasta (`.atena/generated/m1-movimento/refs/`); sem elas a ficha usa só Vault e Nottcard |
| G2 | Fichas de identidade pendentes de revisão | RESOLVABLE | G-D1 exige os quatro heróis do piloto e do L1; as outras antes de cada lote |
| G3 | Cota do gerador de imagem (≈144 tiras) | RESOLVABLE | Por lote; ordem do L1 ao L4; nada de lote em série antes do G-D3 |
| G4 | Mudar `SPEED_PX` | RESOLVABLE | Bot por herói antes de commit; se regredir, preferir C2 |
| G5 | Erik e Arlindo já têm arte própria v04 | RESOLVABLE | L4 decide por tira: manter, completar ou refazer |
| G6 | Resolução de entrega do gerador vs. tamanho em tela (BUG-029) | RESOLVABLE | Decidir no piloto: o contrato v2 pode pedir arte já próxima da escala final |
| — | Lacunas `BLOCKING` | — | **Nenhuma** |

## Salvaguardas

Sem dependências novas; nada em `assets/` é substituído sem aceite visual do dono e evidência; candidatas permanecem DRAFT; "cânone do mestre" não é revelado em ficha nem prompt; commit, push, exportação e aviso exigem aprovação à parte; alterações de outras sessões intactas.

## Riscos

| Risco | Mitigação |
|---|---|
| Novo contrato também não converge | O piloto (G-D3) barra o lote; o contrato é revisado antes de gastar cota |
| Arte nova com identidade diferente do idle | Ficha aprovada (G-D1) e CK-11; idle atual como base obrigatória |
| 144 tiras são muita cota | Lotes de 3 a 4; ordem por visibilidade; o resto pode ser "provisório aceito" (M5) |
| O patinar não é da arte | C1/C2 e H5 correm em paralelo (D15) |
| Escala nova invalida a redução de pixels | Recaptura só no L1, com a escala final; a ferramenta regera por herói |
