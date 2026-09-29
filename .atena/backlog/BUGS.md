# BUGS — defeitos e dívida de verificação

Severidade: **P0** corrige na hora · **P1** acumula, quebra função · **P2** cosmético.
Estado da semeadura (2026-09-29): nenhum defeito **confirmado** aberto nos
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
| BUG-011 | P1 | Espelho de Shendilavri fica fora do mapa e não dá para interagir | [EVID-106](../evidence/EVID-106-playtest-publico-t01-higor-2026-09-29.md) IN-015 (print `S3-123817/screenshots/002-print.png`) | Corrigir posicionamento, independente de ampliar o mapa (MEC-012) | — |
| BUG-012 | P1 | Inimigos travam ao encostar em objetos e param de perseguir; deveriam deslizar | EVID-106 IN-009 (Durão) | Confirmar em outros biomas | — |
| BUG-013 | P2 | Assets "flutuando" no ar no cenário (Durão) | EVID-106 IN-010 | Relaciona-se a SPEC-041 e SPEC-042 (ancoragem); identificar quais props | — |
| BUG-014 | P2 | Ritual: concluir não dá recompensa e a penalidade (monstros extras) vira ganho de XP. *Confirmar se é por design; se for, vira MEC* | EVID-106 IN-001 (Dagruve, regra `rituals`) | Verificar regra de ritual em `data/stage_rules.json` | — |


> Sugestão da Atena: as verificações BUG-003 a 010 cabem em **uma única run QA**
> (roteiro do PLAN-033). Fazê-las antes de exportar novo playtest ou de abrir
> mecânica nova.

## Fechados

| ID | Título | Fechado em | Evidência |
|---|---|---|---|
| — | Regressão do Leoric transparente (nota 6 do EVID-088) | 2026-09-27 | [EVID-081](../evidence/EVID-081-leoric-admissao-oficial-2026-09-27.md) |
| — | Vazamento do sandbox QA para run normal | 2026-09-28 (implementado; verificação em BUG-009) | [EVID-098-spec-074](../evidence/EVID-098-spec-074-vazamento-do-sandbox-qa-2026-09-28.md) |
