---
id: "PROPOSTA-l4-inimigos-legiveis-e-movimentos-2026-10-14"
title: "L4: telégrafo do Tentáculo, atiradores legíveis e movimentos novos (proposta por frente)"
created: "2026-10-14"
status: "DRAFT: proposta escrita antes do código, por pedido do dono (regra do PLAN-103 M4: proposta por frente, teto de 2 mecânicas por frente)"
content_state: DRAFT
relations: ["[[AVALIACAO-playtest-t05-mariz-v040-2026-10-14]]", "[[EVID-252-avaliacao-medida-do-relatorio-t05-mariz-2026-10-14]]", "[[PLAN-103-demo-completa-e-polida-2026-10-14]]"]
---

# L4: inimigos legíveis e movimentos novos

Pedido do relatório do T05 (IN-079, IN-089, IN-094): inimigos parecidos, tentáculo "parado sem ataque perceptível", atiradores "presos", pouca coisa que exija reflexo além de desviar de círculos.

## O que a leitura do código mostra (causa de cada queixa)
| Queixa | Causa | Onde |
|---|---|---|
| Tentáculo "parado" | É elite (`elite_only`) e nasce em `_ring_pos()`, longe do herói; sua habilidade `aoe` só dispara com o herói a 6 tiles (`range`). Ele nasce, não alcança ninguém e nunca "ataca" | `core/battle.gd` `_spawn_elite`, `_use_ability` |
| Golpe sem origem | O aviso `telegraph` é um círculo no chão, sem ligação com quem o lançou; o inimigo não muda de aparência ao armar | `ui/overlay.gd` `_draw_telegraph`, `ui/enemy_view.gd` |
| Atirador "preso" | `keep`: dentro da faixa [`keep` − 1,2; `keep` + 0,6] o inimigo **fica parado**; e o `shoot` sai **na hora**, sem aviso | `core/battle.gd` `_enemy_step`, `_use_ability` |
| Só desviar de círculo | Só existem 2 movimentos (`chase`, `keep`) em 40 tipos; `charge` existe só como habilidade de 8 tipos | `data/enemies.json` |

## Frente A: telégrafo do Tentáculo (e de todo golpe em área)
| # | Mecânica | Como é | Risco |
|---|---|---|---|
| A1 | **Emerge ao alcance** | Inimigo imóvel com `aoe` (hoje só o Tentáculo) nasce a `range − 1` tiles do herói, em ponto livre, em vez de no anel distante | baixo |
| A2 | **Linha do golpe e aviso no corpo** | Enquanto um `aoe` inimigo está armado, uma linha liga quem lançou ao círculo, e o sprite de quem lançou fica quente (laranja); o golpe do Tentáculo ganha 1,3 s de aviso (era 0,9 s) | baixo |

## Frente B: atiradores legíveis
| # | Mecânica | Como é | Risco |
|---|---|---|---|
| B1 | **Mira com aviso** | Antes de cada `shoot`, 0,4 s de mira: uma linha fina aponta a direção travada e o sprite acende; o tiro sai na direção travada (dá para desviar de lado) | médio |
| B2 | **Passo lateral** | Dentro da faixa `keep`, o atirador anda de lado (metade da velocidade, troca de lado a cada 2 a 3 s) em vez de ficar parado; não anda durante a mira | baixo |

## Frente C: movimentos novos (2)
| # | Mecânica | Como é | Quem | Risco |
|---|---|---|---|---|
| C1 | **Bote** (`lunge`) | Entre 1,6 e 4,2 tiles do herói, o inimigo arma 0,45 s com a linha vermelha de investida e salta 3 tiles; recarga 4 s. Reaproveita a investida (`charge`) que já existe | `cultista_adaga`, `alma_penada`, `escravo_de_rivenheart` (comuns que hoje só perseguem) | médio |
| C2 | **Bando** (`pack`) | Anda a 85% da velocidade sozinho e a 125% com 3 ou mais aliados do mesmo tipo a 3 tiles: o grupo acelera, o isolado hesita | `zumbi`, `larva_de_lu_yueh` | médio: mexe em velocidade |

**Fora desta proposta (para outro lote):** `ambush` (emboscada com sprite escondido), 2º ataque do Tentáculo (varredura em linha), afixos de comportamento já na fase 1.

## Segurança
- **Interruptor único:** bloco `l4` em `data/difficulty.json` (`enabled` e um botão por mecânica). Desligado, o jogo é igual ao anterior.
- Tudo vale para o `bot_curva` (mede), e **a régua de 12 heróis não foi refeita**.
- B1 muda de fato o dano de atiradores (dá para evitar); C2 muda a velocidade: se o dono achar demais, desliga-se pela chave.
