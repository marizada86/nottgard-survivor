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
- Verificação manual pendente (BUG-003 a 010) não conta como defeito: é dívida
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
| BUG-001 | P1 | Zumbi novo (SPEC-061) sem captura visual em run real: o renderer headless não gerou viewport | [EVID-104](../evidence/EVID-104-zumbi-admissao-2026-09-29.md) | **IMPLEMENTADO 2026-10-01 — verificado em run real** (janela do jogo, Dagruve): idle, andar, flash de acerto e morte (abates contabilizados) renderizam corretos; ataque não isolado em quadro. Fechar no próximo playtest se não reaparecer | SPEC-061 |
| BUG-002 | P2 | Possíveis assets animados com opacidade fraca (Sacerdote da Mente Derretida) | [PLAN-032](../vault/drafts/PLAN-032-proxima-atualizacao-pos-playtest-2026-09-28.md) | Auditado 2026-09-29: **sem evidência de defeito**; falta só o olho na run QA (PLAN-039). [Histórico](#bug-002) | — |

### Dívida de verificação manual (roteiro do [PLAN-033](../vault/drafts/PLAN-033-checklist-consolidado-pre-playtest-2026-09-28.md))

Suíte e smoke verdes, mas **sem checagem interativa numa run real** nas specs
abaixo. Cada item vira BUG-nnn se falhar.

| ID | Sev | Verificar | Spec |
|---|---|---|---|
| BUG-003 | P1 | Painel `C` / ficha de personagem, rolagem, fechar com `C` e `Esc` | SPEC-059 |
| BUG-004 | P1 | Escolha equipar/vender: moeda creditada, arma some ao vender | SPEC-060 |
| BUG-005 | P1 | Quebráveis por bioma, drop enviesado, respawn por tempo, poção só de elite. **Parcial (EVID-106):** quebrar funciona; faltam drop, respawn e poção | SPEC-063 |
| BUG-006 | P1 | Loja, ferreiro, curandeiro: preço, "Sair" sem custo, ouro histórico intacto. **Parcial (EVID-106):** ferreiro e curandeiro OK; faltam loja e "Sair" | SPEC-064 |
| BUG-007 | P1 | Segurar clique esquerdo para andar (sem mover ao clicar em painel) | SPEC-072 |
| BUG-008 | P1 | Nível de equipamento e super-upgrade (duplicata e ferreiro) | SPEC-073 |
| BUG-009 | P2 | Botão de menu do HUD encerra o sandbox QA; `qa.cenario` correto no manifesto | SPEC-074 |
| BUG-010 | P1 | Sinergias combinadas arma + acessório + magia | SPEC-075 |

### Defeitos relatados em playtest

| ID | Sev | Título | Origem | Situação | Spec |
|---|---|---|---|---|---|
| BUG-011 | P1 | Espelho de Shendilavri fora do mapa, sem interação | [EVID-106](../evidence/EVID-106-playtest-publico-t01-higor-2026-09-29.md) IN-015 | **IMPLEMENTADO 2026-09-29 (PLAN-038)**: Espelho movido para (22.5, 3.0); aguarda run real em Shendilavri. [Histórico](#bug-011) | — |
| BUG-012 | P1 | Inimigos travam em objetos e param de perseguir (deveriam deslizar) | EVID-106 IN-009 (Durão); confirmado por 3 de 3 testers | **IMPLEMENTADO 2026-09-29**: `hero.can_stand` no lugar de `is_free` + `Battle._enemy_move` contorna obstáculos; aguarda run real em Durão. [Histórico](#bug-012) | — |
| BUG-014 | P1 | Ritual: concluir não dá recompensa e a penalidade vira XP | EVID-106 IN-001 (Dagruve, regra `rituals`) | **Reclassificado como mecânica (D1, 2026-09-29):** recompensa em MEC-026 (SPEC-084); aguarda playtest. T03 discorda (contestado). [Histórico](#bug-014) | — |
| BUG-015 | P1 | Ferreiro: prévia Nv+1 mostra os mesmos mods e o +15 % é truncado | [EVID-107](../evidence/EVID-107-playtest-publico-t02-hiago-2026-09-29.md) IN-028 | **IMPLEMENTADO 2026-09-29**: `Items.scaled_mods`/`upgrade_preview`; `mods_text` não trunca mais. Reabre a verificação de BUG-008; aguarda run real. [Histórico](#bug-015) | — |
| BUG-020 | P1 | Bloco de notas (F5) aberto sobre HQ: espaço avança a HQ em vez de digitar; o bloco deve ficar em primeiro plano e capturar o foco | [EVID-139](../evidence/EVID-139-playtest-higor-qa-14b15e4-2026-10-01.md) IN-041 | **IMPLEMENTADO 2026-10-01** (`ui/hq_screen.gd` ignora entrada com o F5 aberto; `Playtest.is_note_open()`; teste em `tests/test_hqs.gd`). Falta conferir em run real | — |
| BUG-021 | P1 | Heróis (Brook, Durvall, Leoric, Kayron, Korrak…) esticam/alargam/afinam ao andar; Sylas não | [EVID-139](../evidence/EVID-139-playtest-higor-qa-14b15e4-2026-10-01.md) IN-044 | **Causa medida** (`audit_hero_motion`): cada tira foi encaixada na célula 256×384 com escala própria; altura da mesma figura varia de 215 a 368 px entre idle e direções. Plano: normalizar por escala única por herói (altura do idle) e mesma linha de base; regenerar só o que ficar fora. Antecedente: SPEC-101 / EVID-129. **PARCIAL 2026-10-01** ([SPEC-112](../specs/SPEC-112-normalizacao-base-e-bordas-dos-herois.md), [EVID-140](../evidence/EVID-140-normalizacao-base-e-bordas-dos-herois-2026-10-01.md)): base e bordas corrigidas (27 tiras, `edge_frames` = 0, suíte ok). **IMPLEMENTADO 2026-10-01 (altura entre direções):** `tools/normalize_hero_scale.gd` aplicado em Brook, Durvall, Leoric, Bromnor e Maelor (30 tiras; andar alinhado à altura e base do idle; Maelor `move_n`/`move_e` voltaram à base 364); `HERO_IDLE_ART_HEIGHT` atualizada (durvall 279, bromnor 284, leoric 270); `edge_frames` = 0, suíte ok. **2ª passada 2026-10-01** (relato do dono: "Leoric cresce ao andar para baixo"; as tiras Leste/Sudeste ficavam ~15% menores que Sul/Norte): `--residual=1.0` em Leoric, Durvall e Bromnor, partindo dos originais; todas as tiras de cada herói na mesma altura (Leoric 224, Durvall 231, Bromnor 241) e `HERO_IDLE_ART_HEIGHT` atualizada; o tamanho em tela não muda. **3ª passada 2026-10-01:** ao reduzir o idle, as tiras de ataque, habilidade e morte ficaram do tamanho antigo e os heróis "cresciam" ~20% ao atacar (Bromnor, Durvall, Korrak e Sylas; 11 a 14% em Kayron, Leoric e Maelor); aplicado a essas tiras o mesmo fator do idle (`--factor=`), relação ataque/idle de antes restaurada; Maelor `move_s` sem quadros na borda. Sobra a Nyrelia `move_e` (~15% menor, irregular; pipeline próprio com base fixa em 367). Falta olho no jogo e regerar o `ASSET-OFFICIAL-LOCK` | — |
| BUG-022 | P2 | HQ "A Peregrinação da Estrela", quadro 2: braço de Korrak fundido ao machado | [EVID-139](../evidence/EVID-139-playtest-higor-qa-14b15e4-2026-10-01.md) IN-042 | Aberto. Regenerar/retocar o quadro (restante da imagem aprovado) | — |

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
| BUG-024 | Minor-fix: número de dano fundido (MEC-031 D5) acusava "instância já liberada" no console quando o número flutuante anterior já tinha sumido; agora valida antes de tipar (`ui/run.gd` `_merge_damage_number`). Achado em captura de run de Dagruve | 2026-10-01 | **Corrigido 2026-10-01**; sem efeito visível, só erro de console |

## Histórico dos cartões

Texto integral da coluna "Situação" antes do enxugamento de 2026-09-30.

### BUG-002
Suspeita. SPEC-038 só checa "existe pixel visível"; conferir cobertura de opacidade nas folhas. **Auditado 2026-09-29:** `tools/audit_alpha_solidity.gd` (191 imagens): as folhas do Sacerdote têm 80–88 % de pixels sólidos e alfa médio 0,87–0,92, faixa igual à de Bromnor e Durvall. Nenhuma sprite de corpo abaixo de 0,79; só efeitos (altar, portal, ritual) e mortes/ativas de heróis ficam mais translúcidos, o que é esperado. **Sem evidência de defeito**; falta só o olho na run QA (PLAN-039). Falta auditar o Sacerdote da Mente Derretida (mesma classe do Leoric e do Zumbi antigos).

### BUG-011
Origem: [EVID-106](../evidence/EVID-106-playtest-publico-t01-higor-2026-09-29.md) IN-015 (print `S3-123817/screenshots/002-print.png`); T02 Q1 concorda (2 de 2, só questionário). Corrigir posicionamento, independente de ampliar o mapa (MEC-012); T03 Q1 "não notei" (não chegou a Shendilavri). **IMPLEMENTADO 2026-09-29 (PLAN-038, aguarda verificação em run real):** Espelho movido de chão (22.5, -0.5) para (22.5, 3.0); teste em `test_prop_grounding.gd`. Outros props de borda (Veu, Taca, Lanterna etc.) seguem na parede por serem decoração de contorno; rever se algum jogador reclamar.

### BUG-012
Origem: EVID-106 IN-009 (Durão). Já **confirmado**, falta só medir outros biomas: T02 nota espontânea N12 (Durão, "mobs presos em obstáculos") + Q2 (2 relatos independentes); T03 Q2 concorda, **prioridade 1ª** (3 de 3). **IMPLEMENTADO 2026-09-29 (aguarda run real em Durão):** duas causas. (1) inimigos usavam `hero.is_free`, que aplica o Esquecimento do Estige (restrição do herói) e travava o avanço; agora usam `hero.can_stand`. (2) obstáculo redondo (montanhas de Durão, props) exatamente no caminho: novo `Battle._enemy_move` contorna girando o passo. Teste em `test_battle.gd`.

### BUG-014
Origem: EVID-106 IN-001 (Dagruve, regra `rituals`). *Confirmar se é por design; se for, vira MEC.* Verificar regra de ritual em `data/stage_rules.json`; **2º relato**: T02 N1 (print com "Ritual interrompido." sem recompensa) + Q4, **prioridade 1ª** de T02. Severidade sobe P2 → P1; T03 Q4 **discorda** (2 C + 1 D): **contestado**. T03 vê dois "Ritual interrompido." sem relato de recompensa no log. **Reclassificado como mecânica em 2026-09-29 (D1):** recompensa implementada como MEC-026 (SPEC-084); aguarda playtest.

### BUG-015
Origem: [EVID-107](../evidence/EVID-107-playtest-publico-t02-hiago-2026-09-29.md) IN-028 (prints 003 e 005; código `core/battle.gd` `shop_item_up`, `core/hero.gd` `recalc`). **Confirmado** por print + leitura de código. Reabre a verificação de BUG-008. Corrigir a prévia (mostrar mods já escalados) e o arredondamento. **IMPLEMENTADO 2026-09-29 (aguarda run real):** `Items.scaled_mods`/`upgrade_preview` mostram "Nv atual" e "Nv seguinte" já escalados; `mods_text` deixou de truncar 4.6 para 4; armas passam a ter rótulo em português ("recarga (s)", "marca"…). O truncamento de CAM/CA inteiros somados segue (as frações acumulam entre itens).
