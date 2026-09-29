# BUGS — defeitos e dívida de verificação

Severidade: **P0** corrige na hora · **P1** acumula, quebra função · **P2** cosmético.
Estado da semeadura (2026-09-29; atualizado com EVID-107): nenhum defeito **confirmado** aberto nos
registros. Abaixo ficam os suspeitos e a dívida de verificação manual.

## Abertos

| ID | Sev | Título | Origem | Situação | Spec |
|---|---|---|---|---|---|
| BUG-001 | P1 | Zumbi novo (SPEC-061) sem captura visual em run real: o renderer headless não gerou viewport | [EVID-104](../evidence/EVID-104-zumbi-admissao-2026-09-29.md) | Só a prancha foi aprovada; abrir uma run em Dagruve e conferir idle/move/attack/death | SPEC-061 |
| BUG-002 | P2 | Pode haver outros assets animados com opacidade fraca (mesma classe do Leoric e do Zumbi antigos): falta auditar Sacerdote da Mente Derretida | [PLAN-032](../vault/drafts/PLAN-032-proxima-atualizacao-pos-playtest-2026-09-28.md) (risco em aberto) | Suspeita. SPEC-038 só checa "existe pixel visível"; conferir cobertura de opacidade nas folhas | — |

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
| BUG-011 | P1 | Espelho de Shendilavri fica fora do mapa e não dá para interagir | [EVID-106](../evidence/EVID-106-playtest-publico-t01-higor-2026-09-29.md) IN-015 (print `S3-123817/screenshots/002-print.png`); T02 Q1 concorda (2 de 2, só questionário) | Corrigir posicionamento, independente de ampliar o mapa (MEC-012); T03 Q1 "não notei" (não chegou a Shendilavri). **IMPLEMENTADO 2026-09-29 (PLAN-038, aguarda verificação em run real):** Espelho movido de chão (22.5, -0.5) para (22.5, 3.0); teste em `test_prop_grounding.gd`. Outros props de borda (Veu, Taca, Lanterna etc.) seguem na parede por serem decoração de contorno; rever se algum jogador reclamar | — |
| BUG-012 | P1 | Inimigos travam ao encostar em objetos e param de perseguir; deveriam deslizar | EVID-106 IN-009 (Durão) | Já **confirmado**, falta só medir outros biomas: T02 nota espontânea N12 (Durão, "mobs presos em obstáculos") + Q2 (2 relatos independentes); T03 Q2 concorda, **prioridade 1ª** (3 de 3). **IMPLEMENTADO 2026-09-29 (aguarda run real em Durão):** duas causas. (1) inimigos usavam `hero.is_free`, que aplica o Esquecimento do Estige (restrição do herói) e travava o avanço; agora usam `hero.can_stand`. (2) obstáculo redondo (montanhas de Durão, props) exatamente no caminho: novo `Battle._enemy_move` contorna girando o passo. Teste em `test_battle.gd` | — |
| BUG-013 | P2 | Assets "flutuando" no ar no cenário (Durão) | EVID-106 IN-010 | Relaciona-se a SPEC-041 e SPEC-042 (ancoragem); identificar quais props; T02 Q3 concorda (2 de 2, só questionário); **confirmado**: T03 N2 espontânea (Dagruve; print 003 em Docas com sombras descoladas) + Q3 (3 de 3, em 3 biomas). **IMPLEMENTADO 2026-09-29 (aguarda verificação visual):** auditoria `tools/audit_prop_grounding.gd` achou 29 fichas em `data/prop_visuals.json` com contato acima da base opaca (até 20 px). Corrigidas as 17 com sombra dinâmica (barril, braseiro, caixote_02, carga, livros, velas, rocha_02). **Pendentes para olho humano:** doca, margem, ossos e rede (props planos, sem sombra; a âncora pode ser proposital). Teste de regressão em `test_prop_visuals.gd` | — |
| BUG-014 | P1 | Ritual: concluir não dá recompensa e a penalidade (monstros extras) vira ganho de XP. *Confirmar se é por design; se for, vira MEC* | EVID-106 IN-001 (Dagruve, regra `rituals`) | Verificar regra de ritual em `data/stage_rules.json`; **2º relato**: T02 N1 (print com "Ritual interrompido." sem recompensa) + Q4, **prioridade 1ª** de T02. Severidade sobe P2 → P1; T03 Q4 **discorda** (2 C + 1 D): **contestado**. T03 vê dois "Ritual interrompido." sem relato de recompensa no log | — |
| BUG-015 | P1 | Ferreiro: prévia de equipamento Nv+1 mostra os **mesmos** mods do nível atual (a escala +15 % só entra na agregação) e, com valores inteiros pequenos, o +15 % é truncado (`Hero.cam()` usa `int()`): "Nv 2 não melhora nada" | [EVID-107](../evidence/EVID-107-playtest-publico-t02-hiago-2026-09-29.md) IN-028 (prints 003 e 005; código `core/battle.gd` `shop_item_up`, `core/hero.gd` `recalc`) | **Confirmado** por print + leitura de código. Reabre a verificação de BUG-008. Corrigir a prévia (mostrar mods já escalados) e o arredondamento. **IMPLEMENTADO 2026-09-29 (aguarda run real):** `Items.scaled_mods`/`upgrade_preview` mostram "Nv atual" e "Nv seguinte" já escalados; `mods_text` deixou de truncar 4.6 para 4; armas passam a ter rótulo em português ("recarga (s)", "marca"…). O truncamento de CAM/CA inteiros somados segue (as frações acumulam entre itens) | — |


> Sugestão da Atena: as verificações BUG-003 a 010 cabem em **uma única run QA**
> (roteiro do PLAN-033). Fazê-las antes de exportar novo playtest ou de abrir
> mecânica nova.

## Fechados

| ID | Título | Fechado em | Evidência |
|---|---|---|---|
| — | Regressão do Leoric transparente (nota 6 do EVID-088) | 2026-09-27 | [EVID-081](../evidence/EVID-081-leoric-admissao-oficial-2026-09-27.md) |
| — | Vazamento do sandbox QA para run normal | 2026-09-28 (implementado; verificação em BUG-009) | [EVID-098-spec-074](../evidence/EVID-098-spec-074-vazamento-do-sandbox-qa-2026-09-28.md) |
