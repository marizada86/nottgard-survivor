---
id: "EVID-256"
title: "L4: telégrafo do Tentáculo, atiradores legíveis e movimentos novos de inimigo"
created: "2026-10-14"
relations: ["[[EVID-250-relato-t05-mariz-v040-2026-10-14]]", "[[EVID-252-avaliacao-medida-do-relatorio-t05-mariz-2026-10-14]]", "[[EVID-254-l2-campo-vivo-pv-do-chefe-poca-e-nevoa-2026-10-14]]", "[[PROPOSTA-l4-inimigos-legiveis-e-movimentos-2026-10-14]]"]
cards: ["IN-079", "IN-089", "IN-094", "BAL-001", "BAL-028"]
content_state: DRAFT
---

# EVID-256 — Lote L4 (aprovado pelo dono em 2026-10-14, com testes; commit `ff6bb4b1`)

Proposta por frente escrita **antes** do código: [PROPOSTA-l4](../vault/drafts/PROPOSTA-l4-inimigos-legiveis-e-movimentos-2026-10-14.md). Tudo atrás de `l4.enabled` em `data/difficulty.json` (e um `enabled` por mecânica); desligado, o jogo é igual ao anterior.

## O que mudou
| Frente | Mecânica | Regra |
|---|---|---|
| A1 | Emerge ao alcance | Elite imóvel com golpe em área (hoje só o Tentáculo) nasce a `alcance − 1,2` tiles do herói, em ponto livre. Antes nascia no anel de 8 a 11 tiles, fora dos 6 de alcance, e nunca atacava |
| A2 | Linha do golpe e aviso no corpo | Todo `aoe` inimigo liga quem lançou ao círculo por uma linha; o sprite de quem lançou fica quente enquanto o golpe está armado; o aviso do Tentáculo vai de 0,9 s a 1,3 s |
| B1 | Mira com aviso | `shoot` de inimigo comum: 0,4 s de mira com linha fina e sprite quente; o tiro sai na direção **travada** no início (dá para desviar de lado). Chefes seguem como antes |
| B2 | Passo lateral | Dentro da faixa de manter distância o atirador anda de lado a 0,5 da velocidade e troca de lado a cada 2 a 3 s (antes ficava parado) |
| C1 | Bote (`lunge`) | Entre 1,6 e 4,2 tiles: arma 0,45 s com a linha vermelha de investida e salta 3 tiles; recarga 4 s. Reaproveita `charge`. Em `cultista_adaga`, `alma_penada`, `escravo_de_rivenheart` |
| C2 | Bando (`pack`) | 85% da velocidade sozinho, 125% com 2 ou mais aliados do mesmo tipo a 3 tiles. Em `zumbi`, `larva_de_lu_yueh` |

Arquivos: `core/battle.gd` (`l4_section`, `_emerge_in_reach`, `_enemy_shot`, `_l4_strafe`, `_l4_lunge_step`, `_l4_pack_mult`), `core/enemy.gd` (campos), `ui/overlay.gd` (linhas), `ui/enemy_view.gd` (tinta quente), `data/enemies.json` (5 `move` novos), `data/difficulty.json`.

## Verificação
- `tests/test_l4_readable_enemies.gd`: Tentáculo nasce ao alcance (8 de 8) e sem o L4 não; aviso de 1,3 s com origem e tinta; mira com tiro na direção travada mesmo se o herói sai; passo lateral; bote com evento `windup` e salto; bando mais rápido que o isolado. **Mutação:** desligar emerge, mira, passo lateral e bote faz o teste falhar em 6 pontos; restaurado, passa. Suíte completa: **0 falhas**.
- Captura em janela real (`tools/capture_l4.tscn`, `.atena/generated/mariz-playtest/l4_telegrafo_mira_bote.png`): círculo do Tentáculo no herói com a linha ligando ao Tentáculo.
- `tools/bot_curva.gd` ganhou o 9º argumento (`0` desliga o L4).

## `bot_curva` antes e depois do L4 (L2 ligado nos dois; lado 60, dt 0,08, 4 heróis × 6 sementes, metas 0 e 1)
Tabela completa: `.atena/generated/mariz-playtest/bot-l4/resumo-l4.md`.

| | antes → depois |
|---|---|
| Fases alcançadas por execução, meta 0 (novato) | 1,88 → **1,63** |
| Fases alcançadas por execução, meta 1 (veterano) | 1,83 → **2,29** |
| Dagruve passou, meta 0 / meta 1 | 42% → 33% / 54% → 46% |
| Dagruve chefe caiu em, meta 0 / meta 1 | 886 s → 685 s / 836 s → 401 s |
| Docas passou, meta 0 / meta 1 | 80% → 63% / 46% → 91% |

**Leitura honesta:** são 24 execuções por célula (diferença de ±10 pontos é ruído). O sinal **não é uniforme**: o novato piora um pouco (Dagruve 42% → 33%, 1,88 → 1,63 fases) e o veterano melhora (1,83 → 2,29). A luta do chefe fica mais curta nos dois (o L4 tira do bot o "pinga" de atiradores parados e reduz a duração da Dagruve). **Não é aceite de equilíbrio**: faltam a rodada de 12 heróis e 15 sementes (EVID-225) e o olho de um jogador. Se o novato sofrer, os botões são `pack.solo`/`pack.group` (0,85/1,25) e `lunge.cd` (4 s); o interruptor geral é `l4.enabled`.

## Pendências
- **Humano:** achar a mira legível e justa (0,4 s é o primeiro palpite), ver se o bote lê como "vai pular" e se o bando não irrita; o Tentáculo agora é uma ameaça de fato na Docas.
- **Fora desta rodada:** `ambush`, 2º ataque do Tentáculo, afixos de comportamento já na fase 1.
