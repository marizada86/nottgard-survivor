# BALANCEAMENTO — herois, armas, itens, inimigos, economia e dificuldade

Aqui ficam **todos os problemas de equilíbrio**: personagem fraco ou forte demais,
item que domina ou nunca vale a pena, inimigo injusto ou inofensivo, economia
que sobra ou falta, curva de dificuldade. Prefixo `BAL-nnn`.

A ideia é **acumular informação antes de mexer nos números**: um cartão junta
relatos de vários jogadores, medições do bot e leitura dos dados, e só então a
melhor solução aparece.

## Fronteira com as outras trilhas

| Se o problema é... | Trilha |
|---|---|
| **Números** de conteúdo que já existe (dano, PV, custo, taxa de drop, frequência, curva de dificuldade, ganho de XP) | **Balanceamento** |
| Uma **regra ou sistema novo** (evento, item novo, forma de jogar) | Mecânicas |
| Algo que **não funciona como foi projetado** | Bugs |
| Só a **aparência ou o som** | Arte & Áudio |

Um relato pode gerar cartões em duas trilhas (ex.: "moedas sobrando" = `BAL` para
os custos e `MEC` para novos usos do dinheiro). Ligar os dois na coluna "Ligado a".

## Como registrar (um cartão por entidade e sintoma)

| Campo | O que vai |
|---|---|
| **Entidade** | herói, arma, passiva, item, bênção, inimigo, chefe, fase, evento ou economia |
| **Sintoma** | forte demais, fraco demais, frequente demais, raro demais, caro demais, barato demais... |
| **Evidências** | relatos por tester (quem, onde, nível, build), medições do bot, números lidos dos dados |
| **Alavanca** | arquivo e campo onde se mexe (`data/difficulty.json`, `data/heroes.json`, `data/weapons.json`...) |
| **Hipótese** | por que acontece |
| **Medição** | como confirmar (bot, seeds, herói, fase) |
| **Decisão** | valor antes → depois, a spec e a EVID (só depois de reunir informação) |

## Quando decidir (guia, não bloqueio)

- Duas fontes independentes (dois jogadores, ou um jogador + o bot) → pode ir para
  a decisão.
- Relato único de um só jogador fica em **observação**, salvo se for P0 (jogo
  impossível ou trivial de quebrar).
- Sinais **divergentes por herói** (ex.: fácil para um, difícil para outro) pedem
  rodada do bot por herói antes de mexer em número global.
- Mude **uma alavanca por vez** por entidade sempre que possível, e anote o antes e o
  depois: assim cada ajuste se desfaz sozinho.
- Não confundir dificuldade com falta de clareza: jogador que morreu sem entender
  vai para Arte/UX, não para cá.

## Medir com o bot

```bash
godot --headless --path . -s tools/bot.gd -- <heroi> <seeds> [fase_inicial] [dt] [maxfases]
```

Rodar por herói, com as mesmas seeds, e registrar num EVID: fases alcançadas,
nível, tempo e causa da morte. **Linha de base:** registrada em [EVID-110](../evidence/EVID-110-linha-de-base-do-bot-por-heroi-2026-09-29.md) (build 0.2.0). O ideal é
tirá-la logo depois que os ajustes em andamento de `data/difficulty.json` forem
commitados, para não medir uma versão no meio da mudança.

O bot joga com kite e escolhas heurísticas; serve para comparar **heróis e versões
entre si**, não para dizer se um jogador humano vai achar difícil.

## Abertos

| ID | Entidade | Sintoma e evidências | Alavanca | Ligado a | Estado |
|---|---|---|---|---|---|
| BAL-001 | Dificuldade inicial da campanha | T03 (Kayron): início fácil, quer **mais mobs, mais dano e menos PV**, "fica mais fácil ao evoluir" (EVID-108, IN-035, IN-037, IN-039). T01 (Brook): "fácil até Feng-tu" (EVID-106). T02: PV baixo em Dagruve (10/60 a 00:48 com Bromnor, IN-032). **Sinais divergem por herói** | `data/difficulty.json`, `data/stages.json` | MEC-024 · SPEC-083 | **IMPLEMENTADO 2026-09-29** só a parte de mais mobs nos primeiros minutos; aguarda playtest. Falta a rodada do bot por herói |
| BAL-002 | Progressão tardia (Shendilavri em diante) | T01: o herói "perdeu a progressão", não melhora mais (EVID-106, IN-014). T02 Q11 confirma e propõe **mais status e PV máx. entre fases** (EVID-107). T03 não chegou lá | `data/upgrades.json`, `data/passives.json`, `data/stage_rules.json` | MEC-014, MEC-005 | observação: 2 fontes; falta medir com o bot até a fase 7. **Parcial 2026-09-29:** +1 PV por nível a partir do 15 e meta ampliado (SPEC-088); aguarda playtest |
| BAL-003 | Economia de moedas | T01 comprou a loja inteira com ~30 000 moedas (EVID-106, IN-016). T02: +23 354 moedas numa run e propõe **upgrades mais caros ou moedas menos frequentes** (EVID-107) | preços de loja e forja em `data/`, ganho de moeda por inimigo e chefe, multiplicador de risco | MEC-015 | observação: 2 fontes independentes; decidir entre subir custo, reduzir ganho ou criar novos usos (MEC-015). **Parcial 2026-09-29:** 5 aprimoramentos novos e Força/Vitalidade até nível 10 (SPEC-088), mais Mesa de Aposta (SPEC-087); aguarda playtest |
| BAL-004 | Dano da Maré de Névoa | T01: "dano causado pela névoa está baixo" (EVID-106, IN-002) | dano em % da vida máxima por segundo | MEC-017 | **IMPLEMENTADO 2026-09-29** (2% → 6%, SPEC-086); aguarda playtest |
| BAL-005 | Frequência e recompensa dos quebráveis | T01 ×2 e T02: aparecem pouco (EVID-106, IN-004, IN-005); T03 concorda | intervalo de spawn e escala por Carisma | MEC-007 | **IMPLEMENTADO 2026-09-29** (35–55 s → 22–36 s, −6% por ponto de Carisma, SPEC-086); aguarda playtest |
| BAL-006 | Frequência das fontes "+% PV" | T02: "menos frequentes, mas não muito" (EVID-107, IN-024) | peso das fontes nos eventos aleatórios | MEC-020 | **IMPLEMENTADO 2026-09-29** (peso 2 → 1,4, SPEC-086); aguarda playtest |
| BAL-007 | Baú do chefe | T01 e T02: iguais aos baús comuns; T02 "apenas 1 baú" (EVID-106, EVID-107) | qualidade e número de baús | MEC-013 | **IMPLEMENTADO 2026-09-29** (raro ou único, SPEC-086); aguarda playtest |
| BAL-008 | Zynara Vellen | **Só o bot:** nível médio 1,0 em 5 sementes (2,4 mesmo sem abertura e flanqueio); a mais fraca dos 10 heróis (EVID-110). Nenhum tester a usou | `data/heroes.json` (PV base, armadura, arma inicial), arma inicial de Zynara em `data/weapons.json` | — | **IMPLEMENTADO 2026-09-29** ([[SPEC-092-arma-inicial-de-zynara]]): a arma inicial não causava dano; agora 2d6 a cada 5,5 s. Bot: nível médio 1,0 → 5,0. Aguarda playtest com Zynara |
| BAL-009 | Nyrelia | **Só o bot:** nível médio 6,0 (7,6 sem abertura e flanqueio); segunda mais frágil (EVID-110) | `data/heroes.json`, passiva e arma inicial | — | **Observação** |
| BAL-011 | Duração de Dagruve e Docas | Relato do dono: encurtar os dois primeiros mapas para **5 min**. Hoje 480 s e 600 s em `data/stages.json`. Decisão 2026-10-01: **tudo em 5:00, chefe incluso** | duration 300, tempo do chefe, cap/spawn/HP_mult para a curva comprimida | [EVID-139](../evidence/EVID-139-playtest-higor-qa-14b15e4-2026-10-01.md) IN-045; ligado a BAL-001 | **IMPLEMENTADO 2026-10-01**: `duration` 300 e `t0`/`t1`/`at` de ondas e elites escalados (Dagruve ×0,625; Docas ×0,5); chefe a 5:00. Bot: igual antes e depois (níveis 3–4 em Dagruve, não passa da fase). Falta playtest humano; avaliar intervalo do ritual (55 s) e conquista "Sobrevivente" (480 s) |

### Painel de heróis

Medição do bot em 2026-09-29 (5 sementes, EVID-110) ao lado dos relatos:

| Herói | Sinais | Medição do bot |
|---|---|---|
| Brook França | T01: run longa até Shendilavri (nv 57, 66 PV), fácil até Feng-tu, estagna depois | nível médio 7,0 (EVID-110) |
| Bromnor Martelo da Luz | T02: PV 10/60 aos 00:48 em Dagruve (IN-032; falta saber o contexto) | nível médio 11,6 |
| Kayron Lioran | T03: 56 min até Molor, início fácil | nível médio 10,2 |
| Maelor | sem relatos | nível médio 14,4 |
| Korrak Nammat | sem relatos | nível médio 14,4 |
| Sylas Malafaia | sem relatos | nível médio 9,6 |
| Leoric | sem relatos | nível médio 7,6 |
| Durvall | sem relatos | nível médio 5,8 |
| Nyrelia | sem relatos | nível médio 6,0 (BAL-009) |
| **Zynara Vellen** | sem relatos | nível médio 1,0 → **5,0** depois do SPEC-092 (BAL-008) |

Preencher a coluna do bot na primeira rodada por herói e acrescentar linha de
armas, itens e inimigos quando aparecerem sinais.

## Decididos e validados

| ID | Resumo | Antes → depois | Spec | Evidência |
|---|---|---|---|---|
| — | Perda de INT do Estige passou a expirar | permanente na run → 300 s | SPEC-086 (regra, MEC-022) | — |
| — | Poção deixou de cair de inimigo comum | inimigo comum → quebráveis e elites (6%) | SPEC-063 | EVID-093, EVID-095 |

Cartão fechado só depois que um playtest com a versão nova **não repetir** o
sintoma (regra do dono, ver README).
