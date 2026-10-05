---
id: "EVID-157"
title: "B-004: prontidão do próximo playtest (PLAN-057 / SPEC-123)"
created: "2026-10-04"
relations: ["[[SPEC-123-revisao-da-movimentacao-dos-herois]]", "[[EVID-153-varredura-b001-movimentacao-dos-herois-2026-10-04]]", "[[EVID-152-b002-xp-ritmo-de-nivel-2026-10-04]]"]
---

# EVID-157 — prontidão do próximo playtest

Só leitura. Nenhum commit, merge, push ou exportação foi feito.

## Estado

- Último commit: `8307924` (0.3.0). Árvore com **184 itens sem commit**: 147 em `.atena/`, 14 em `tools/`, 9 pastas de `assets/`, 6 em `tests/`, 6 em `core/` e `data/`, 2 em `ui/`.
- Backlog: P0 = 0; P1 abertos = 2 (**BUG-025** dimensões dos heróis, **BUG-027** costas de Zynara, Leoric e Nyrelia); P1 implementados aguardando playtest = 7; verificações manuais pendentes = 8; `backlog_check` sem alertas de organização.
- Suíte: 0 falhas na varredura do B-001 (EVID-153), antes das mudanças de balanceamento da outra sessão. **Rodar de novo antes de qualquer commit.**

## Três frentes misturadas na mesma árvore

| Frente | Arquivos | Regra do projeto |
|---|---|---|
| Balanceamento, SPEC-122 / PLAN-056 (outra sessão): XP, armas iniciais, frequência de eventos, raridade e Incomum | `core/battle.gd`, `core/items.gd`, `core/happenings.gd`, `data/difficulty.json`, `data/weapons.json`, `data/stages.json`, `tests/test_rarity.gd`, `test_battle.gd`, `test_affixes.gd`, `test_happenings.gd`, `tools/bal_*.gd` | um commit por mecânica; a outra sessão sugere 0.3.1 (XP, armas, eventos, fases) e 0.4.0 (raridade) |
| Imagens, PLAN-053 / SPEC-121: Shedaklah, Durão, Molor, Shu, Ezro, Molydeus | 9 pastas novas em `assets/animations/enemies/`, `ui/enemy_view.gd`, `ui/run.gd`, `tests/test_animation_assets.gd`, `tools/*shedaklah*` | arte não se mistura com mecânica nem com bug-fix |
| Movimentação dos heróis, SPEC-123 / PLAN-057 (esta sessão) | só documentos e prompts em `.atena/` | nenhuma arte entrou |

Risco concreto: `core/battle.gd` tem 15 trechos alterados e `data/stages.json` mexe em `hp_mult` de fases. Separar por mecânica exige escolher trecho a trecho (`git add -p`), que não dá para fazer sem a outra sessão dizer qual trecho é de qual mecânica. **Não commitei nada por causa disso.**

## O que a build de playtest levaria hoje

- Do 0.3.0 em diante, já no disco e sem commit: XP mais lento (EVID-152), armas iniciais, frequência de eventos e props, raridade, inimigos novos animados (Zuggtmoy, Alma Penada, Gehenna, Carcereiro, Gárgula, Receptáculo, Shu, Ezro, Molydeus).
- Questionário: `QUESTIONARIO-006-v0.3.0` existe; **não cobre** XP, armas, eventos nem raridade novos. A sessão de balanceamento planejou atualizá-lo (B-006).
- Defeitos conhecidos que a build levaria: BUG-027 (Zynara, Leoric e Nyrelia de frente ao andar para cima) e BUG-025 (dimensões ao andar e atacar, parcial).

## Pendências que dependem do dono

1. **Gerador de imagem:** as 6 tiras do ART-PROMPTS-056 (BUG-027) precisam ser geradas fora desta sessão (sem gerador aqui). Gate: aprovar o primeiro quadro de cada herói.
2. **Gate das identidades de Feng Tu v02** (PLAN-053 está em `AWAITING_OWNER_REVIEW`).
3. **SPEC-120 parte B (Marcas do Abismo)** segue rascunho; decidir se entra neste playtest ou fica para o seguinte.
4. **Ordem de commits** e quem separa o `core/battle.gd` (outra sessão ou esta, com `git add -p`).
5. **Exportar a build** em `build/` e **push** (o push na `main` solta o release `latest`): exigem aprovação explícita.
6. **Tipo da versão:** a regra de `RELEASES.md` diz que mudança de dificuldade global não cabe em Minor-update; XP, raridade e Incomum parecem Major (0.4.0), com changelog em PDF e questionário novo. A outra sessão propôs 0.3.1 para XP, armas, eventos e fases; vale o dono confirmar.

## Recomendação de ordem

1. Fechar o balanceamento (commits por mecânica) antes de misturar arte.
2. Commit de arte do PLAN-053 separado.
3. Gerar as 6 tiras de costas; auditar; integrar; commit próprio (`fix`, fecha BUG-027 no playtest).
4. Rodar a suíte e o bot de novo, atualizar o questionário, exportar a build e só então pedir o push.
