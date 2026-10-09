# BUGS — defeitos e dívida de verificação

Severidade: **P0** corrige na hora · **P1** acumula, quebra função · **P2** cosmético.
Estado (2026-09-30): há defeitos **confirmados por mais de um tester** (BUG-011 a 015), todos
**implementados e aguardando o próximo playtest**. O que resta de BUG-001 a 010 é
suspeita e **dívida de verificação manual**. Ciclo de vida e regra de fechamento
no [README](README.md); estado atual sai de `tools/backlog_check.ps1`.

## Regras

- **P0** (crash, save corrompido, impede jogar): corrige na hora, não espera lote.
- **P1** (quebra uma função, tem contorno) e **P2** (cosmético): acumulam.
- O lote de bugs fecha no **próximo playtest com versão nova** (regra do dono).
  O gatilho de 5 ou mais P1 continua servindo de **aviso**, não de bloqueio.
- Verificação manual pendente (hoje só o BUG-007; BUG-003 a 010 menos o 007 foram pagos por teste automático, EVID-224) não conta como defeito: é dívida
  a pagar no playtest.
- **Lembrete da Atena:** no início de cada sessão e antes de export/commit ela
  informa quantos P0/P1 estão abertos, rodando
  `powershell -ExecutionPolicy Bypass -File tools/backlog_check.ps1`. Um hook de
  início de sessão (`.claude/settings.json`) roda a versão curta sozinho.

Os cartões trazem só o **estado atual**; o texto integral de cada um está em
[Histórico](#histórico-dos-cartões) no fim do arquivo.

## Abertos

| ID | Sev | Título | Origem | Situação | Spec |
|---|---|---|---|---|---|
| BUG-033 | P1 | Botão Jogar não encontrado no Quartel com heróis/fases; dono não conseguiu iniciar tentativa com Xbox | Dono, 2026-10-06; [EVID-185](../evidence/EVID-185-quartel-botao-jogar-2026-10-06.md) | **Alias histórico BUG-030 (controles); acompanhamento atual BUG-033. IMPLEMENTADO LOCAL 2026-10-06 — P068-v03:** botão fixado fora das colunas, ícone de confirmação e área reservada; confirmação no mapa direciona o foco para Jogar; 38 verificações de acesso e início sem falhas. Causa exata na tela do dono não confirmada; aguarda reteste físico; [EVID-186](../evidence/EVID-186-quartel-confirmar-mapa-para-jogar-2026-10-06.md) | SPEC-135 |
| BUG-001 | P1 | Zumbi novo (SPEC-061) sem captura visual em run real: o renderer headless não gerou viewport | [EVID-104](../evidence/EVID-104-zumbi-admissao-2026-09-29.md) | **IMPLEMENTADO 2026-10-01 — verificado em run real** (janela do jogo, Dagruve): idle, andar, flash de acerto e morte (abates contabilizados) renderizam corretos; ataque não isolado em quadro. Fechar no próximo playtest se não reaparecer | SPEC-061 |
| BUG-002 | P2 | Possíveis assets animados com opacidade fraca (Sacerdote da Mente Derretida) | [PLAN-032](../vault/drafts/PLAN-032-proxima-atualizacao-pos-playtest-2026-09-28.md) | Auditado 2026-09-29: **sem evidência de defeito**; falta só o olho na run QA (PLAN-039). [Histórico](#bug-002) | — |

### Dívida de verificação manual (roteiro do [PLAN-033](../vault/drafts/PLAN-033-checklist-consolidado-pre-playtest-2026-09-28.md))

Suíte e smoke verdes, mas **sem checagem interativa numa run real** nas specs
abaixo. Cada item vira BUG-nnn se falhar.

| ID | Sev | Verificar | Spec |
|---|---|---|---|
| BUG-007 | P1 | Segurar clique esquerdo para andar (sem mover ao clicar em painel) | SPEC-072 |

### Conhecidos na v0.4.0 (PLAN-081 / SPEC-148, 2026-10-08)

Decisão do dono: estes defeitos **não entram** na 0.4.0 e vão para a caixa "Conhecidos" do changelog, para o tester não gastar relato neles. O que muda é só se o especialista Caio devolver uma correção do BUG-028 antes do fechamento: ela entra como minor-fix com teste.

- Zynara, Leoric e Nyrelia mostram o rosto ao andar para cima (BUG-027, P1).
- Heróis patinam ao andar de lado e nas diagonais (BUG-028, P1); o pacote para o Caio fica em `.atena/generated/caio-durvall/`, só local.
- Pixels soltos nos heróis (BUG-029, P1) e dimensões ao andar e atacar (BUG-025, P1, parcial).
- HQ "A Peregrinação da Estrela", quadro 2: braço do Korrak fundido ao machado (BUG-022, P2).

Reteste em run real exigido antes do fechamento (S-006): BUG-033 (botão Jogar com controle) e as verificações BUG-003 a BUG-010; o que não for visto entra em "O que testar".

### Defeitos relatados em playtest

| ID | Sev | Título | Origem | Situação | Spec |
|---|---|---|---|---|---|
| BUG-034 | P1 | **C não fecha a ficha** (o botão diz "Fechar (C)"; só Esc fecha). Causa: `ui/hud.gd` retornava antes do ramo de fechamento e `Run` saía por `has_modal` | Daniel (T03, v0.3.3), [EVID-200](../evidence/EVID-200-relato-t03-daniel-v033-2026-10-07.md) IN-067; BUG-003 | **IMPLEMENTADO LOCAL 2026-10-08 (PLAN-080); aguarda playtest.** O teste falha 4x no HEAD e passa com a correção | [SPEC-147](../specs/SPEC-147-correcoes-dos-playtests-v032-e-v033.md) |
| BUG-035 | P1 | **Bloco de notas (F5) deixa o resto do jogo interativo** (HUD clicável, atalhos sem foco no campo) | Daniel (T03), EVID-200 IN-066 | **IMPLEMENTADO LOCAL 2026-10-08 (PLAN-080); aguarda playtest.** Fundo que absorve o mouse, foco preso no campo; HUD e mobile ignoram tudo com nota, guia ou Central abertos | SPEC-147 |
| BUG-036 | P1 | **Textos sobrepostos no topo da tela, mais com quests** (objetivos, barra do chefe e avisos disputavam o mesmo espaço; o aviso do Playtest cobria o relógio) | Daniel (T03), EVID-200 IN-069, IN-072 | **IMPLEMENTADO LOCAL 2026-10-08 (PLAN-080); aguarda playtest.** Pilha vertical no topo (chefe, quests, status, avisos); aviso do Playtest movido para baixo; teste de retângulos | SPEC-147 |
| BUG-037 | P1 | **Arma base reaparece como "NOVA" depois de evoluir** (as 8 armas que evoluem) | Manzi (T04, v0.3.2), [EVID-199](../evidence/EVID-199-relato-t04-manzi-v032-2026-10-07.md) IN-063 | **IMPLEMENTADO LOCAL 2026-10-08 (PLAN-080); aguarda playtest.** Sem o filtro as 8 bases voltam; com ele nenhuma | SPEC-147 |
| BUG-038 | P2 | **Altar de bênção parece oco: o chão e a estrada aparecem através do corpo de pedra** (só poço, brasas e velas eram visíveis). Não era ordem de desenho (o overlay do altar é z=60, a estrada z=-90): o sheet animado `assets/animations/interactions/altar_active.png` tem o corpo com alfa 0 | Dono, 2026-10-08 (print do altar sobre a estrada); [EVID-210](../evidence/EVID-210-bug-038-altar-oco-sobre-a-estrada-2026-10-08.md) | **IMPLEMENTADO LOCAL 2026-10-08 (Direct Execution, post-hoc); aguarda playtest.** `ui/overlay.gd`: o altar usa o sprite estático completo (`assets/interactions/altar_active.png`); perde o brilho animado no repouso até o sheet ser refeito ([ART-044](ARTE.md)). Conferido em captura de Dagruve com o altar sobre a estrada | [SPEC-153](../specs/SPEC-153-altar-oco-sobre-a-estrada-bug-038.md) |
| BUG-011 | P1 | Espelho de Shendilavri fora do mapa, sem interação | [EVID-106](../evidence/EVID-106-playtest-publico-t01-higor-2026-09-29.md) IN-015 | **IMPLEMENTADO 2026-09-29 (PLAN-038)**: Espelho movido para (22.5, 3.0); aguarda run real em Shendilavri. [Histórico](#bug-011) | — |
| BUG-012 | P1 | Inimigos travam em objetos e param de perseguir (deveriam deslizar) | EVID-106 IN-009 (Durao); confirmado por 3 de 3 testers | **IMPLEMENTADO 2026-09-29**: `hero.can_stand` no lugar de `is_free` + `Battle._enemy_move` contorna obstáculos; aguarda run real em Durao. [Histórico](#bug-012) | — |
| BUG-014 | P1 | Ritual: concluir não dá recompensa e a penalidade vira XP | EVID-106 IN-001 (Dagruve, regra `rituals`) | **Reclassificado como mecânica (D1, 2026-09-29):** recompensa em MEC-026 (SPEC-084); aguarda playtest. T03 discorda (contestado). [Histórico](#bug-014) | — |
| BUG-015 | P1 | Ferreiro: prévia Nv+1 mostra os mesmos mods e o +15 % é truncado | [EVID-107](../evidence/EVID-107-playtest-publico-t02-hiago-2026-09-29.md) IN-028 | **IMPLEMENTADO 2026-09-29**: `Items.scaled_mods`/`upgrade_preview`; `mods_text` não trunca mais. Reabre a verificação de BUG-008; aguarda run real. [Histórico](#bug-015) | — |
| BUG-020 | P1 | Bloco de notas (F5) aberto sobre HQ: espaço avança a HQ em vez de digitar; o bloco deve ficar em primeiro plano e capturar o foco | [EVID-139](../evidence/EVID-139-playtest-higor-qa-14b15e4-2026-10-01.md) IN-041 | **IMPLEMENTADO 2026-10-01** (`ui/hq_screen.gd` ignora entrada com o F5 aberto; `Playtest.is_note_open()`; teste em `tests/test_hqs.gd`). Falta conferir em run real | — |
| BUG-021 | P1 | Heróis (Brook, Durvall, Leoric, Kayron, Korrak…) esticam/alargam/afinam ao andar; Sylas não | [EVID-139](../evidence/EVID-139-playtest-higor-qa-14b15e4-2026-10-01.md) IN-044 | **Causa medida** (`audit_hero_motion`): cada tira foi encaixada na célula 256×384 com escala própria; altura da mesma figura varia de 215 a 368 px entre idle e direções. Plano: normalizar por escala única por herói (altura do idle) e mesma linha de base; regenerar só o que ficar fora. Antecedente: SPEC-101 / EVID-129. **PARCIAL 2026-10-01** ([SPEC-112](../specs/SPEC-112-normalizacao-base-e-bordas-dos-herois.md), [EVID-140](../evidence/EVID-140-normalizacao-base-e-bordas-dos-herois-2026-10-01.md)): base e bordas corrigidas (27 tiras, `edge_frames` = 0, suíte ok). **IMPLEMENTADO 2026-10-01 (altura entre direções):** `tools/normalize_hero_scale.gd` aplicado em Brook, Durvall, Leoric, Bromnor e Maelor (30 tiras; andar alinhado à altura e base do idle; Maelor `move_n`/`move_e` voltaram à base 364); `HERO_IDLE_ART_HEIGHT` atualizada (durvall 279, bromnor 284, leoric 270); `edge_frames` = 0, suíte ok. **2ª passada 2026-10-01** (relato do dono: "Leoric cresce ao andar para baixo"; as tiras Leste/Sudeste ficavam ~15% menores que Sul/Norte): `--residual=1.0` em Leoric, Durvall e Bromnor, partindo dos originais; todas as tiras de cada herói na mesma altura (Leoric 224, Durvall 231, Bromnor 241) e `HERO_IDLE_ART_HEIGHT` atualizada; o tamanho em tela não muda. **3ª passada 2026-10-01:** ao reduzir o idle, as tiras de ataque, habilidade e morte ficaram do tamanho antigo e os heróis "cresciam" ~20% ao atacar (Bromnor, Durvall, Korrak e Sylas; 11 a 14% em Kayron, Leoric e Maelor); aplicado a essas tiras o mesmo fator do idle (`--factor=`), relação ataque/idle de antes restaurada; Maelor `move_s` sem quadros na borda. Sobra a Nyrelia `move_e` (~15% menor, irregular; pipeline próprio com base fixa em 367). Falta olho no jogo e regerar o `ASSET-OFFICIAL-LOCK` | — |
| BUG-025 | P1 | Dimensões dos heróis ao andar/atacar: estica, cresce, afina (Kayron diagonais de baixo; Korrak machado cortado e flip preso; Bromnor, Sylas e outros) | [EVID-146](../evidence/EVID-146-auditoria-de-dimensoes-dos-herois-2026-10-02.md) | **PARCIAL 2026-10-02:** 29 tiras igualadas quadro a quadro por código (`tools/equalize_hero_frames.gd`); Korrak anda com o idle e balanço procedural sem espelhar. Resto é erro de arte (corte na borda, massa ≠ idle): prompts de prioridade alta em [CHATGPT-FILA-024](../generated/CHATGPT-FILA-024-regerar-tiras-dos-herois.md) / [ART-PROMPTS-055](../generated/ART-PROMPTS-055-regerar-caminhadas-e-acoes-dos-herois.md). Falta olho no jogo | — |
| BUG-022 | P2 | HQ "A Peregrinação da Estrela", quadro 2: braço de Korrak fundido ao machado | [EVID-139](../evidence/EVID-139-playtest-higor-qa-14b15e4-2026-10-01.md) IN-042 | Aberto. Regenerar/retocar o quadro (restante da imagem aprovado) | — |
| BUG-026 | P2 | Docas: o evento `copias_do_guardiao` está em `at: 400`, mas a fase dura 300 s desde a BAL-011; só dispara se a luta com o chefe passar de 100 s | [EVID-147](../evidence/EVID-147-auditoria-vault-x-jogo-2026-10-03.md) (achado em leitura de `data/stage_events.json` e `core/battle.gd:2331`) | **Implementado 2026-10-05:** `at` movido de 400 para 225 em `data/stage_events.json`; suíte verde; aguarda playtest | [SPEC-118](../specs/SPEC-118-acontecimentos-exclusivos-por-fase.md) |
| BUG-027 | P1 | Zynara, Leoric e Nyrelia mostram o rosto ao andar para cima (N, NE e, por espelho, NO); o herói não "vira de costas". Os outros 7 estão corretos | Dono, 2026-10-04 (Zynara); [EVID-153](../evidence/EVID-153-varredura-b001-movimentacao-dos-herois-2026-10-04.md) confirmou os outros dois | **Causa medida:** as tiras `move_n` e `move_ne` desses três foram geradas de frente. Código não resolve. Plano: regerar 6 tiras ([ART-PROMPTS-056](../generated/ART-PROMPTS-056-costas-ao-andar-para-cima-zynara-leoric-nyrelia.md), [SPEC-123](../specs/SPEC-123-revisao-da-movimentacao-dos-herois.md)). Aberto; aguarda gerador de imagem e aprovação do dono | ART-033 |
| BUG-028 | P1 | Heróis "patinam" ao andar de lado e nas diagonais (E, SE, NE e espelhos); para cima e para baixo está bom. Vale para todos os heróis, no `.exe` do playtest, sem inimigos por perto | Dono, 2026-10-05 | **Adiado pelo dono (2026-10-05).** Diagnóstico: não é falha de código nem tira ausente (6 quadros distintos, tocam em jogo). Suspeita: passo curto para a velocidade (190 px/s de tela, `SPEED_PX`; ciclo de 6 quadros a 10 fps cobre ~114 px, passada da arte ~40 a 55 px; estimativa, sem medir quadro a quadro). **Tentativa A+B (2026-10-05) não resolveu**, testada no `.exe`: `WALK_FPS` 15 e `speed_scale` ligado à velocidade do herói (`ui/hero_view.gd`, `ui/run.gd`, teste `_validate_walk_pace`); **revertida a pedido do dono**. **Diagnóstico instrumentado (PLAN-077, [EVID-197](../evidence/EVID-197-diagnostico-instrumentado-do-patinar-bug-028-2026-10-07.md), 2026-10-07):** log CSV e breakpoint opt-in (`--walk-debug`; lançador em `.atena/generated/walk-debug/`). Troca de tira e queda ao idle **descartadas em campo livre com teclado**; a arte desenha pés lentos demais em todas as direções (inclusive N e S); **aguarda coleta do dono** (modos 1, 3 e 5) para fechar a H5 (descompasso física × renderização) e o caso mouse/analógico. Pistas para retomar: medir a passada real por quadro, tentar fps mais alto, regerar as tiras E/SE/NE com passada maior ou 8 quadros (C), baixar `SPEED_PX` (D); pode haver outra causa além do ritmo | BUG-025 |
| BUG-029 | P1 | **Reincidência:** heróis jogáveis voltaram a ter pixels soltos (provável erro de dimensionamento/escala, de novo) | Dono, 2026-10-05 | **Causa medida (2026-10-05):** a arte do herói é grande (~316 px de altura na célula 256x384) e aparece em ~40 a 76 px (escala ~0,21) com filtro `nearest` (`default_texture_filter=0`) e sem mipmaps: ao reduzir, cada pixel de tela amostra um texel e o resto é descartado, então detalhes finos da armadura viram ruído. Não é transparência (solidez 0,89 a 0,95, `tools/audit_alpha_solidity.gd`). **Teste:** com mipmaps (`mipmaps/generate=true`) + `TEXTURE_FILTER_LINEAR_WITH_MIPMAPS` no sprite, o Kayron sai limpo, sem ruído ([antes](../generated/bug-029/kayron-antes-nearest.png), [depois](../generated/bug-029/kayron-teste-mipmaps.png)); teste revertido. **Correção proposta:** ligar mipmaps nas ~100 tiras de herói e o filtro no `hero_view.gd` (visual fica mais suave, menos "pixel crisp"); alternativa: pré-reduzir as tiras para o tamanho de tela. **Mipmaps + filtro linear testados no `.exe` em 2026-10-05: o dono não gostou do visual suave; revertido.** Resta a alternativa de pré-reduzir as tiras para o tamanho de tela (reamostragem limpa, mantendo pixel nítido) ou outra ideia do dono | BUG-025, BUG-028 |
| BUG-030 | P1 | Baú virou Mímico, virou baú, virou Mímico 3 vezes seguidas; um baú deveria virar Mímico uma vez só e, ao morrer, virar baú de verdade | Manzi (playtest), 2026-10-06 | **IMPLEMENTADO 2026-10-06 (aguarda playtest):** o baú largado pelo Mímico nasce `safe` (`core/battle.gd` `_kill`); teste em `test_battle.gd` | [SPEC-134](../specs/SPEC-134-bau-mimico-unico-e-pausa-ao-pegar-item.md) |
| BUG-031 | P1 | Item pego em baú era equipado sem aviso; faltava pausar e mostrar o item | Manzi (playtest), 2026-10-06 | **IMPLEMENTADO 2026-10-06 (aguarda playtest):** com o slot vazio, `give_item(item, true)` abre painel de 1 opção (Equipar) e só equipa ao confirmar; vale só para baús (decisão do dono); [EVID-173](../evidence/EVID-173-bau-mimico-e-pausa-ao-pegar-item-2026-10-06.md) | [SPEC-134](../specs/SPEC-134-bau-mimico-unico-e-pausa-ao-pegar-item.md) |
| BUG-032 | **P0** | Ao matar o chefe, baú do chefe e portal nasceram em cima de um objeto do cenário, sem alcance: impossível pegar o baú e passar de fase | Vitão (playtest), 2026-10-06 | **IMPLEMENTADO 2026-10-06 (aguarda playtest):** `_add_interaction` resolve um ponto onde o herói cabe (`core/battle.gd`); teste em `test_battle.gd`; [EVID-174](../evidence/EVID-174-bau-e-portal-fora-de-bloqueio-2026-10-06.md), adendo de alcance a pé em [EVID-176](../evidence/EVID-176-interativos-alcancaveis-2026-10-06.md) (não commitado) | [SPEC-135](../specs/SPEC-135-bau-e-portal-fora-de-bloqueio.md) |

> Decisão do dono (2026-09-29): as verificações BUG-003 a 010 são pagas **no
> próximo playtest** (a versão 0.2.0 traz a lista "O que testar"); não bloqueiam
> exportação nem mecânica nova.

## Minor-fix

Correções triviais (texto, margem, rótulo): **sem P0/P1, sem spec e sem EVID**; uma
linha por cartão e o commit. Fluxo curto decidido pelo dono em 2026-09-30. Se o
conserto crescer, o cartão sobe para a tabela "Abertos" acima. Ao fechar uma versão,
os cartões Minor-fix do período viram o bloco "Pequenos ajustes" do changelog
(escrito à mão, em linguagem de jogador).

| ID | Título | Origem | Situação |
|---|---|---|---|
| BUG-018 | Minor-fix: Manto do Pântano mostrava "+1 puddle_immune"; agora "+1 imune a poças" (`MOD_LABELS`) | Auditoria de rótulos 2026-09-30 | **Fechado 2026-09-30**; `core/items.gd` |

## Fechados

| ID | Título | Fechado em | Evidência |
|---|---|---|---|
| — | Regressão do Leoric transparente (nota 6 do EVID-088) | 2026-09-27 | [EVID-081](../evidence/EVID-081-leoric-admissao-oficial-2026-09-27.md) |
| — | Vazamento do sandbox QA para run normal | 2026-09-28 (implementado; verificação em BUG-009) | [EVID-098-spec-074](../evidence/EVID-098-spec-074-vazamento-do-sandbox-qa-2026-09-28.md) |
| BUG-013 | Props flutuando no cenário | 2026-09-29 | [EVID-121](../evidence/EVID-121-aprovacao-visual-de-decais-e-bug-013-2026-09-29.md) |
| BUG-016 | Minor-fix: lista de feitiços/equipamentos cortada no canto inferior esquerdo do HUD quando é longa (`WeaponsLabel` crescia para baixo; agora `grow_vertical` para cima e base -24) | 2026-09-30 | Relato do dono (print); `ui/hud.tscn`, `tools/build_scenes.gd` |
| BUG-017 | Minor-fix: cartão da bênção Sorriso da Sorte mostrava "-1 dmg_flat"; agora "-1 dano por acerto" (`MOD_LABELS` sem `dmg_flat`) | 2026-09-30 | Relato do dono (print); `core/items.gd` |
| BUG-003 | Verificação: ficha `C` (abrir e fechar com `C` e `Esc`). A rolagem antiga foi substituída pela ficha em abas e grade (SPEC-130) | 2026-10-09 (teste automático) | [EVID-224](../evidence/EVID-224-plan-088-divida-de-verificacao-manual-2026-10-09.md): `test_playtest_fixes.gd` `_entrada` |
| BUG-004 | Verificação: equipar ou vender na oferta de item (moeda creditada, arma some) | 2026-10-09 (teste automático) | EVID-224: `test_battle.gd` 9b e 9c |
| BUG-005 | Verificação: quebráveis por bioma, drop, respawn por tempo e poção só de elite | 2026-10-09 (teste automático) | EVID-224: `test_battle.gd` 9c a 9d-2 e `test_manual_debt.gd` (respawn) |
| BUG-006 | Verificação: loja, ferreiro e curandeiro (preço, "Sair" sem custo, ouro do Quartel intacto) | 2026-10-09 (teste automático) | EVID-224: `test_battle.gd` 9e e `test_manual_debt.gd` (stats.gold) |
| BUG-008 | Verificação: nível de equipamento e super-upgrade (duplicata e ferreiro) | 2026-10-09 (teste automático) | EVID-224: `test_battle.gd` 9f |
| BUG-009 | Verificação: o botão de menu encerra o sandbox QA sem vazar para a run normal | 2026-10-09 (teste automático) | EVID-224: `test_qa_sandbox.gd` |
| BUG-010 | Verificação: sinergias arma evoluída + acessório no nível máximo + magia | 2026-10-09 (teste automático) | EVID-224: `test_battle.gd` 10b |
| BUG-024 | Minor-fix: número de dano fundido (MEC-031 D5) acusava "instância já liberada" no console quando o número flutuante anterior já tinha sumido; agora valida antes de tipar (`ui/run.gd` `_merge_damage_number`). Achado em captura de run de Dagruve | 2026-10-01 | **Corrigido 2026-10-01**; sem efeito visível, só erro de console |

## Histórico dos cartões

Texto integral da coluna "Situação" antes do enxugamento de 2026-09-30.

### BUG-002
Suspeita. SPEC-038 só checa "existe pixel visível"; conferir cobertura de opacidade nas folhas. **Auditado 2026-09-29:** `tools/audit_alpha_solidity.gd` (191 imagens): as folhas do Sacerdote têm 80–88 % de pixels sólidos e alfa médio 0,87–0,92, faixa igual à de Bromnor e Durvall. Nenhuma sprite de corpo abaixo de 0,79; só efeitos (altar, portal, ritual) e mortes/ativas de heróis ficam mais translúcidos, o que é esperado. **Sem evidência de defeito**; falta só o olho na run QA (PLAN-039). Falta auditar o Sacerdote da Mente Derretida (mesma classe do Leoric e do Zumbi antigos).

### BUG-011
Origem: [EVID-106](../evidence/EVID-106-playtest-publico-t01-higor-2026-09-29.md) IN-015 (print `S3-123817/screenshots/002-print.png`); T02 Q1 concorda (2 de 2, só questionário). Corrigir posicionamento, independente de ampliar o mapa (MEC-012); T03 Q1 "não notei" (não chegou a Shendilavri). **IMPLEMENTADO 2026-09-29 (PLAN-038, aguarda verificação em run real):** Espelho movido de chão (22.5, -0.5) para (22.5, 3.0); teste em `test_prop_grounding.gd`. Outros props de borda (Veu, Taca, Lanterna etc.) seguem na parede por serem decoração de contorno; rever se algum jogador reclamar.

### BUG-012
Origem: EVID-106 IN-009 (Durao). Já **confirmado**, falta só medir outros biomas: T02 nota espontânea N12 (Durao, "mobs presos em obstáculos") + Q2 (2 relatos independentes); T03 Q2 concorda, **prioridade 1ª** (3 de 3). **IMPLEMENTADO 2026-09-29 (aguarda run real em Durao):** duas causas. (1) inimigos usavam `hero.is_free`, que aplica o Esquecimento do Estige (restrição do herói) e travava o avanço; agora usam `hero.can_stand`. (2) obstáculo redondo (montanhas de Durao, props) exatamente no caminho: novo `Battle._enemy_move` contorna girando o passo. Teste em `test_battle.gd`.

### BUG-014
Origem: EVID-106 IN-001 (Dagruve, regra `rituals`). *Confirmar se é por design; se for, vira MEC.* Verificar regra de ritual em `data/stage_rules.json`; **2º relato**: T02 N1 (print com "Ritual interrompido." sem recompensa) + Q4, **prioridade 1ª** de T02. Severidade sobe P2 → P1; T03 Q4 **discorda** (2 C + 1 D): **contestado**. T03 vê dois "Ritual interrompido." sem relato de recompensa no log. **Reclassificado como mecânica em 2026-09-29 (D1):** recompensa implementada como MEC-026 (SPEC-084); aguarda playtest.

### BUG-015
Origem: [EVID-107](../evidence/EVID-107-playtest-publico-t02-hiago-2026-09-29.md) IN-028 (prints 003 e 005; código `core/battle.gd` `shop_item_up`, `core/hero.gd` `recalc`). **Confirmado** por print + leitura de código. Reabre a verificação de BUG-008. Corrigir a prévia (mostrar mods já escalados) e o arredondamento. **IMPLEMENTADO 2026-09-29 (aguarda run real):** `Items.scaled_mods`/`upgrade_preview` mostram "Nv atual" e "Nv seguinte" já escalados; `mods_text` deixou de truncar 4.6 para 4; armas passam a ter rótulo em português ("recarga (s)", "marca"…). O truncamento de CAM/CA inteiros somados segue (as frações acumulam entre itens).
