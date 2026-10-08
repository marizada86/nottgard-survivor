---
id: "SPEC-147"
title: "Correções e clareza da HUD após os playtests de Manzi (v0.3.2) e Daniel (v0.3.3)"
status: "IMPLEMENTADA localmente em 2026-10-08 (PLAN-080, EVID-201); sem commit, push, build ou exportação"
origin: planned
implementation_preceded_spec: false
request_classification: PLAN_DEVIATION
created: "2026-10-08"
relations: ["[[EVID-199-relato-t04-manzi-v032-2026-10-07]]", "[[EVID-200-relato-t03-daniel-v033-2026-10-07]]", "[[SPEC-130-ficha-c-em-abas-grade-e-detalhe]]", "[[SPEC-118]]", "[[SPEC-138]]"]
---

# SPEC-147 — Correções dos playtests v0.3.2 e v0.3.3

Fontes: IN-059 a IN-072 ([EVID-199](../evidence/EVID-199-relato-t04-manzi-v032-2026-10-07.md), [EVID-200](../evidence/EVID-200-relato-t03-daniel-v033-2026-10-07.md)).
Os dois relatos são de segunda mão e não foram reproduzidos em run real; cada item abaixo declara o que foi lido no código.

## Decisões do dono (2026-10-08)

| Tema | Decisão |
|---|---|
| Aprovação | Por plano |
| Rota | Fazer agora e voltar ao PLAN-071 (B-006/S-011) |
| Baú após trocar de mapa | **Atrasar** o primeiro interativo (45 s); o primeiro continua sendo baú |
| Ctrl (Manzi) | **Sem tecla nova.** O próximo nível e a evolução aparecem no detalhe da ficha C |
| Ranking (Daniel) | Só carregar a lista ao abrir a aba. O resto espera a resposta do Daniel e o PLAN-071 |

## Escopo

### A. Entrada e foco
1. **C fecha a ficha** (IN-067, BUG-003). Com a ficha aberta, `ui/hud.gd:335` retorna antes do ramo que fecha com C (`:348`) e `ui/run.gd` sai por `hud.has_modal()`. Fechar com C (teclado e botão do controle `run_items`) e com Esc; o botão "Fechar (C)" passa a fazer o que diz. A foco volta ao elemento que o tinha antes (comportamento atual de `_close_items_panel`).
2. **C nas ofertas** (IN-062). A HUD já abre a ficha em `levelup`, `altar`, `item_offer` e `shop` (`ui/hud.gd:337`, commit `14633e2`, posterior à base da v0.3.2). Esta etapa **verifica** em teste e em run que abrir, navegar e fechar a ficha numa oferta não perde a escolha, o foco nem a rerrolagem. Só vira correção se o teste falhar.
3. **Bloco de notas modal** (IN-066). Com F5 aberto: fundo de tela cheia que absorve o mouse; `hud.has_modal()` e `Run._unhandled_input` ignoram teclado, mouse e botões de controle enquanto `Playtest.is_overlay_open()`; o foco fica no campo de texto. A Central (F4) e o guia (F1) seguem a mesma regra. Fechar a nota (F5 ou Esc) devolve o estado de pausa anterior.

### B. HUD do topo e quests
4. **Sem sobreposição** (IN-069, IN-072). Hoje `ObjectiveLabel` (y=74), `BossPanel` (y=74) e `ToastBox` (y=130) disputam o topo central. Os objetivos viram um painel que mede a própria altura; `BossPanel` e `ToastBox` ancoram abaixo do que estiver visível; no máximo 4 linhas de objetivo, com "+N" para o resto; avisos continuam em no máximo 4. Teste de retângulos: nenhum par de blocos se interceptam com 1 a 6 linhas de objetivo, chefe vivo e 4 avisos, em 1280×720 e 1920×1080.
5. **Quests em destaque** (IN-070). Painel com moldura, ícone ◆, título, progresso e tempo; pulso curto ao iniciar, progredir, concluir e falhar. Sem arte nova: usa a moldura de `SheetArt` e ícones existentes.
6. **Itens e alvos da quest em destaque** (IN-071). Anel pulsante e rótulo reforçado sobre item, alvo, NPC e inimigo da quest **dentro** da tela (a seta de borda já cobre fora dela), dirigidos por `Happenings.markers()`. O item carregado entra no painel de quests.
7. **Debuff do lago** (IN-064). Indicador de status na HUD (chip com ícone existente e tempo) para o Estige: dentro da água com a exposição e a INT efetiva, e depois o Esquecimento. Substitui a linha de texto do `InfoLabel`. Confirmar com Manzi a fase.

### C. Armas
8. **Arma base não reaparece** (IN-063). `_build_offer` (`core/battle.gd:2291-2298`) oferece "NOVA" qualquer arma sem fonte `Evolução` ou `Item` que o herói não possua; depois de evoluir, a base some do inventário e volta. Excluir da oferta toda arma cuja evolução o herói possui (mapa reverso base→evolução a partir de `weapons.json`), inclusive quando ela é concedida por item.

### D. Primeiro interativo
9. **Baú atrasado** (IN-065). `load_stage` define `_inter_t = 4.0` (`core/battle.gd:302`). Passa a 45 s, em constante nomeada; o primeiro interativo da fase segue sendo baú (`_first_inter`). Testes que dependiam de 4 s são atualizados.

### E. Ficha C: leitura
10. **Próximo nível e evolução** (IN-059, IN-060). No detalhe da ficha: para armas, "Próximo nível" com o ganho de `_level_desc` e a faixa de dano antes→depois, e "Evolui em X" com descrição, dado e condição; para passivas, o efeito do nível seguinte; para itens base, o bônus do nível seguinte. Sem tecla nova.
11. **Nome antes do valor** (IN-061). Em "Bônus totais" a linha vira "Dano 28%", "Crítico 3%" (`_bonus_row`, `ui/character_sheet.gd:602-622`); sinal e cores preservados.

### F. Ranking (mínimo)
12. **Atualizar ao abrir a aba** (IN-068). `ui/leaderboard.gd` chama `refresh()` na primeira vez que a aba fica visível, sem tirar o botão "Atualizar". Falha de rede mantém a mensagem atual. Nada muda no envio, no importador nem no PLAN-071.

## Não objetivos

Ctrl como atalho; mudar o envio de estatísticas ou o importador do ranking; o resto do IN-068 antes da resposta do Daniel; arte nova; rebalancear itens ou fases; commit, push, exportação ou nova versão.

## Lacunas

| Id | Lacuna | Classe | Tratamento |
|---|---|---|---|
| G1 | Fase do lago e se a linha do Estige apareceu (Manzi) | NON_BLOCKING | Chip vale para todas as fases com `styx_memory` |
| G2 | O que o Daniel viu no ranking | NON_BLOCKING | Item 12 é o mínimo; o resto fica no INBOX |
| G3 | "Quest" = objetivo de acontecimento | NON_BLOCKING | Assumido; confirmar com Daniel |
| G4 | Hash da build do Daniel (C nas ofertas já estava corrigido?) | NON_BLOCKING | O item 2 verifica no HEAD |

Zero lacunas `BLOCKING`.

## Critérios de aceite

1. C fecha a ficha por teclado e controle, com a ficha aberta durante a corrida e durante `levelup`, `altar`, `item_offer` e `shop`; Esc continua fechando.
2. Com F5, F4 ou F1 abertos, nenhum clique, tecla ou botão de controle atinge a HUD ou a corrida; ao fechar, a pausa anterior volta.
3. Nos dois tamanhos de tela, sem par de blocos do topo interceptados em todos os cenários do item 4.
4. Painel de quests e destaques dentro da tela presentes com pelo menos 1 objetivo de cada tipo (`collect`, `escort`, `intercept`, `rescue`).
5. Chip do Estige aparece dentro da água e some depois do Esquecimento.
6. Para cada uma das 8 armas que evoluem: depois da evolução, a base não aparece em 200 ofertas sorteadas.
7. O primeiro interativo de qualquer fase surge depois de 45 s e é baú.
8. A ficha mostra próximo nível e evolução para arma, passiva e item base; a ordem das linhas de bônus é nome antes do valor.
9. A aba do ranking dispara uma requisição ao abrir, uma só por abertura.
10. Suíte completa, smoke das nove fases e `tools/kit_test.gd` sem falhas novas; capturas da HUD e da ficha anexadas ao EVID.
11. Cartões BUG/MEC criados e o `backlog_check.ps1` rodado; nenhum commit, push, build ou exportação.

## Plano de voo

B-001 Entrada e ficha C (S-001 a S-003) · B-002 HUD do topo e quests (S-004 a S-007) · B-003 Armas e primeiro interativo (S-008, S-009) · B-004 Ficha C e ranking (S-010 a S-012) · B-005 Validação e retorno (S-013 a S-015). Detalhes em [PLAN-080](../vault/drafts/PLAN-080-correcoes-dos-playtests-v032-e-v033-2026-10-08.md).

## Riscos

- A árvore tem alterações não commitadas de outras sessões em `core/battle.gd`, `core/playtest.gd`, `ui/character_sheet.gd` e seus testes. Editar só os trechos próprios, sem reverter nada, e conferir `git diff` antes de cada lote.
- O PLAN-079 (pacote Durvall) está em execução em outra sessão; não toca estes arquivos.
- Mudar `has_modal` altera a entrada em toda a corrida: o teste de regressão cobre pausa, confirmação, controles e mobile.
