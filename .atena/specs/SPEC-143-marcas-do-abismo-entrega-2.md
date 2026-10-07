---
id: "SPEC-143"
title: "Marcas do Abismo, entrega 2 (liberação por conquista e as quatro marcas restantes)"
status: "IMPLEMENTADA LOCAL 2026-10-07 (PLAN-076, EVID-195); aguarda playtest; sem commit"
origin: planned
implementation_preceded_spec: false
request_classification: PLAN_DEVIATION
created: "2026-10-07"
cards: ["MEC-040", "BAL-016"]
relations: ["[[SPEC-141-marcas-do-abismo-entrega-1]]", "[[SPEC-120-curva-base-e-marcas-do-abismo]]", "[[PLAN-076-marcas-do-abismo-entrega-2-2026-10-07]]"]
---

# SPEC-143 — Marcas do Abismo, entrega 2

Continua a [[SPEC-141-marcas-do-abismo-entrega-1]] (commit `78c6f39`, local, nunca publicada). Duas coisas: **trocar a regra de
liberação** (da vitória na fase para **conquistas**, base da progressão do jogo) e **entregar as quatro marcas que faltam**.

## Decisões do dono (2026-10-07)

| # | Decisão | Resposta |
|---|---|---|
| D1 | Liberação das marcas | **Só por conquista.** Cada marca tem a sua conquista de liberação; a regra "vencer a fase inicial" deixa de valer. Quem tem a conquista usa a marca em qualquer fase. |
| D2 | Origem das conquistas | **Uma conquista nova por marca** (nove), temáticas, e não reaproveitamento das existentes. |
| D3 | Aprovação | **Por plano** (`per-plan`). |
| D4 | Escopo | Marcas Elites despertos, Chefe desperto, Abismo vivo e Sem trégua; relíquia **fora** (depende da SPEC-119). |

## Premissas a confirmar (não bloqueiam o rascunho)

- **B1:** nomes e limiares das nove conquistas de liberação (tabela abaixo) são proposta minha; o dono pode trocar na aprovação.
- **B2:** as conquistas de pontuação passam de 5/10/15 para **5/10/15/20/25** (o máximo agora é 25 pontos); a de 15 muda o texto ("cinco marcas no nível 3" deixa de ser o máximo).
- **B3:** o bônus de moeda segue **+10% por ponto**; com 25 pontos o teto é +250%.
- **B4:** a escolha salva das marcas continua global; marcas não liberadas são ignoradas **uma a uma** ao iniciar a run.

## Liberação por conquista

- Cada marca em `data/abyss_marks.json` ganha `requires: "<id da conquista>"` (mesmo padrão dos aprimoramentos, `upgrade_locked_by`).
- Cada conquista de liberação ganha `reward: {"unlock_mark": "<id>", "text": "Libera a Marca <nome>"}`; o texto aparece no resultado e na aba Conquistas.
- `Profile.abyss_mark_unlocked(id)` = a conquista está em `data.achievements`; `Game.run_abyss_marks()` descarta **só as marcas bloqueadas**.
- A aba **Marcas** mostra, em cada marca bloqueada, o **nome e a condição da conquista** e mantém − e + desativados; a linha de resumo da aba Jogar conta quantas marcas estão liberadas.
- Sem migração: a entrega 1 nunca foi publicada. Perfis de teste com marcas escolhidas e sem a conquista simplesmente têm as marcas ignoradas.
- O recorde e as conquistas de pontuação continuam exigindo **vencer o chefe da fase inicial com as marcas** (SPEC-141).

### As nove conquistas de liberação (nenhuma exige marcas), do mais fácil ao mais difícil

| Marca | Conquista | Condição (stat) |
|---|---|---|
| Carapaça | **Marca do Abismo: Carapaça** | Derrote o chefe de Dagruve (`boss_dagruve` ≥ 1) |
| Pressa | **Marca do Abismo: Pressa** | Sobreviva 10 minutos numa run (`run_time` ≥ 600) |
| Horda | **Marca do Abismo: Horda** | Derrote 1.000 inimigos (`kills_total` ≥ 1000) |
| Elites despertos | **Marca do Abismo: Elites despertos** | Derrote 25 elites (`elites_total` ≥ 25) |
| Fúria | **Marca do Abismo: Fúria** | 50 abates seguidos sem receber dano na mesma run (`run_clean_streak` ≥ 50) |
| Abismo vivo | **Marca do Abismo: Abismo vivo** | Complete 4 fases diferentes (`stages_cleared` ≥ 4) |
| Fome | **Marca do Abismo: Fome** | Chegue ao nível 20 numa run (`run_level` ≥ 20) |
| Chefe desperto | **Marca do Abismo: Chefe desperto** | Derrote 3 chefes (`bosses_total` ≥ 3) |
| Sem trégua | **Marca do Abismo: Sem trégua** | Derrote 4 chefes numa única run (`run_bosses` ≥ 4) |

Ordem das linhas na aba Marcas: a da tabela (a mesma da progressão). Convenção de nome igual à das "Biografia: X".
Todas só dão a liberação (sem moedas), porque a progressão é a recompensa.

## As quatro marcas novas

Todas valem na **run inteira**. Desligadas, não mudam a run (as novas usam uma RNG própria, `abyss_rng`, semeada da semente da run, para não deslocar a da batalha) e entram nos mesmos pontos da entrega 1.

| Marca | Níveis | Efeito | Onde aplica |
|---|---|---|---|
| **Elites despertos** | 1 a 3 | cada nível soma **1 afixo** ao elite (sem repetir, no limite do conjunto); no **nível 3** nasce também **1 elite extra por minuto** (antes do chefe) | `_spawn_elite`; diretor de ondas |
| **Chefe desperto** | 1 a 3 | **+30% de PV do chefe por nível** e uma **fase extra a 15% de PV** (anel de projéteis e fúria; mais forte por nível), valendo para todos os chefes | `_director` (nascimento do chefe), `phase_defs` |
| **Abismo vivo** | 1 a 3 | a regra ambiental da fase fica **+33% mais frequente por nível** (×2 no nível 3): intervalo ÷ (1 + 0,333·nível); em Corte das Ilusões (sem intervalo) vale a chance ×; Rio Estige não muda | `_stage_rule_step` e timers de poça e raio |
| **Sem trégua** | só 1 | **sem loja, ferreiro nem curandeiro** na run inteira, nos sorteados e nos fixos do cenário | `_spawn_random_interaction`, interativos fixos |

- `max_level` passa a poder ser **por marca** (`data/abyss_marks.json`); Sem trégua tem 1. Total máximo: 5·3 + 3 + 3 + 3 + 1 = **25**.
- Os dados de cada marca (por nível, textos, fase extra do chefe, requisito) ficam em `data/abyss_marks.json`.

## Dados e código

- `data/abyss_marks.json`: ordem nova (9 marcas), `requires`, `max_level` por marca, parâmetros das quatro novas e a fase extra do chefe.
- `data/achievements.json`: 9 conquistas de liberação + 2 de pontuação (20: **Coroa do Abismo**, 1200 moedas; 25: **Abismo Desperto**, 2000 moedas); ajuste do texto de **Abismo Sem Fundo** (15).
- `core/abyss_marks.gd`: `max_level(id)`, `requires(id)`, normalização por marca.
- `core/profile.gd`: `abyss_mark_unlocked`, `abyss_unlocked_ids`; `abyss_unlocked(stage)` (entrega 1) sai de cena.
- `core/game.gd`: `run_abyss_marks()` filtra por marca liberada.
- `core/battle.gd`: as quatro marcas (ganchos pequenos, sem refatorar).
- `ui/abyss_panel.gd`: nove linhas, bloqueio por marca com a condição da conquista, resumo.
- `tools/bot_curva.gd`: `all=max` e nível por marca limitado ao máximo da marca.
- `tests/test_abyss_marks.gd` e testes de conquista.

## Aceite

1. **Liberação:** com perfil novo, nenhuma marca liberada e todas bloqueadas na aba; ao ganhar a conquista, só aquela marca libera; `battle_ctx` ignora marcas bloqueadas individualmente; as nove conquistas existem, não exigem marcas e liberam a marca certa.
2. **Elites despertos:** nível n soma n afixos (limite do conjunto); no nível 3 o elite extra nasce a cada 60 s e só antes do chefe; marcas desligadas = run idêntica.
3. **Chefe desperto:** PV do chefe ×(1 + 0,30·nível) e a fase a 15% dispara uma única vez, também em chefes que já têm fases próprias.
4. **Abismo vivo:** o intervalo da regra ambiental cai conforme o nível (teste numérico por fase com regra de intervalo); Estige sem mudança; ilusões com chance maior.
5. **Sem trégua:** nenhuma loja, ferreiro ou curandeiro nasce, nem os fixos do cenário; o resto das interações continua.
6. **Pontos:** soma até 25; moeda ×(1 + 0,10·pontos); conquistas 5/10/15/20/25 pelo recorde; bônus de moeda correto no HUD, no resultado e na aba.
7. **Interface:** nove linhas cabem com rolagem, operáveis por mouse, controle (foco segue a rolagem) e toque; bloqueadas mostram a condição.
8. **Bot (alarme, não veredito):** cada marca nova no máximo, isolada, e as nove no máximo, perfil veterano, três heróis; sem marcas continua idêntico ao HEAD.
9. Suíte inteira, smoke das nove fases (sem marcas e com as nove no máximo) sem falha.

## Fora de escopo

Relíquia (SPEC-119), ícones novos por marca, qualquer arte nova, commit, push, build e exportação.

## Riscos

- Marcas novas se somam às da entrega 1 na run inteira: o nível 25 deve ser quase intransponível (opcional; o bot mede).
- Chefe desperto mexe nos `phase_defs` de todos os chefes: uma fase extra a 15% precisa conviver com chefes que já têm fase final.
- Sem trégua + Fome pode travar builds sem cura (aceito e avisado na aba).
- `core/battle.gd` é partilhado com a sessão da economia de ouro (PLAN-075): tocar só nos pontos listados e usar `git add -p`.

## Como ficou (2026-10-07, EVID-195)

Tudo como na spec, com estes detalhes:
- **Medição:** Chefe desperto cumpre o que promete (luta +51 %, dano recebido +34 %); Abismo vivo e Elites despertos **não endurecem o bot** (alarme, não veredito) e nenhum número foi ajustado; candidatas de ajuste ficam na EVID-195.
- **Aba Marcas:** ao abrir, o foco automático rolava para o fim; corrigido com `_on_shown`.
- **Ponto aberto:** o `reward_cap` 3,0 da economia de ouro (PLAN-075) limita o bônus das Marcas acima de 20 pontos; decisão do dono pendente.
- Premissas B1 a B4 mantidas como propostas.
