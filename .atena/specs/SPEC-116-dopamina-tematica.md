---
id: "SPEC-116"
title: "Dopamina temática: feedback e recompensa"
status: "proposta para escolha do dono (2026-10-01)"
created: "2026-10-01"
relations: ["[[EVID-139-playtest-higor-qa-14b15e4-2026-10-01]]", "[[PLAN-050-pos-playtest-higor-2026-10-01]]", "[[SPEC-115-riqueza-de-cenario-piloto-dagruve-docas]]"]
---

# SPEC-116 — Dopamina temática (MEC-031)

Origem: relato do dono (IN-048, 2026-10-01): o jogo está "cru, sem alma", pouco divertido; pede mais "dopamina" **de um jeito que combine com a temática**.
Esta SPEC é pesquisa + proposta. **Nada foi implementado.** Referências (Vampire Survivors, Death Must Die) vêm de conhecimento geral, não de consulta online.

## O que o jogo já tem (inventário em `ui/run.gd`, `ui/hud.gd`, `core/battle.gd`)
| Momento | Hoje |
|---|---|
| Acerto | Número flutuante colorido pela afinidade divina (limite de 14 na tela), crítico maior; som de impacto/crítico; faíscas só com tema divino |
| Dano no herói | Tremor de tela (0,6), número vermelho |
| Abate | **Só o som de morte** (tremor 1,5 se for chefe). Sem partículas, sem efeito de ouro/XP |
| Coleta | **Só o som** (poção, moeda, ímã, XP) |
| Subir de nível | Tela de escolha; sem explosão visual (ART-010 pendente) |
| Evolução de arma | Mini-cinemática de 2,6 s (MEC-009) |
| Baú / evento | Som e animação do objeto |
| Progresso | Contador "Abates N" no HUD, sem marcos |
| Armadilha, explosão | Tremor e anel (novos, MEC-029/034) |

Diagnóstico: o jogo comunica **perda** (dano, tremor) melhor que **ganho**. Matar e coletar, as ações mais repetidas, quase não têm retorno visual.

## Princípios
1. Ganho precisa ser visto e ouvido no instante da ação, em até 100 ms.
2. Escala com o evento: abate comum pequeno, elite médio, chefe grande.
3. Sempre temático: o Abismo cobra e devolve em sombra, brasa, ossos e névoa, não em confete.
4. Orçamento: respeitar `_numbers` (14) e o limite de partículas do `overlay`; nada de novo que pese em 60 inimigos.
5. Acessibilidade: tudo que treme ou pisca respeita uma opção **Efeitos de impacto** (Padrão / Reduzido / Desligado) em Opções.

## Proposta (do menor risco ao maior)

### D1 — Estouro de abate (visual, risco baixo)
Ao morrer, o inimigo solta uma pequena rajada de partículas na cor do tipo de dano que o matou (sombra, brasa, osso), com encolhimento rápido do sprite.
Elite e chefe ganham anel e rajada maiores. Reaproveita `spawn_impact` e `_ring`; sem arte nova (arte opcional depois).
Teste: evento `kill` já existe; checar contagem de partículas dentro do limite.

### D2 — Peso nos acertos importantes (risco baixo)
- Crítico e abate de elite: **hit-stop** de 40 ms (jogo em pausa curta) e tremor proporcional.
- Abate de chefe: 120 ms de hit-stop + flash da cor do chefe.
- Obedece à opção de acessibilidade. Teste: tempo de pausa limitado e nunca acumulado (máximo 1 por 0,3 s).

### D3 — Coleta com ritmo (risco baixo)
- Pitch do som sobe a cada coleta encadeada em até 0,6 s (estilo "combo" de moedas), reinicia depois.
- Orbes de XP com cor por valor; barra de XP pulsa ao receber; moeda faz um pequeno brilho âmbar.
- Teste: função pura do pitch por encadeamento.

### D4 — "Maré do Abismo": sequência de abates (mecânica, risco médio)
Contador de abates com janela de 3 s sem matar para reiniciar. Marcos em **10 / 25 / 50 / 100 / 200** disparam um aviso temático
(ex.: "Maré Cinzenta", "Maré Negra"; nomes a aprovar pelo dono) e uma recompensa **pequena**: +2% de XP por 5 s por marco, sem empilhar além de 10%.
Entra em `Battle` (contador e evento `streak`) e no HUD (texto discreto). Impacta o balanceamento (medir com o bot; novo cartão BAL se mexer em números).
Teste: contador, janela, marcos e teto da recompensa em `tests/test_battle.gd`.

### D5 — Números de dano legíveis (ART-007, risco baixo)
Cor por tipo de dano (físico, mágico, fogo, radiante), crítico maior com contorno, **agregação** de acertos rápidos no mesmo alvo ("+34") em vez de vários números, para reduzir o ruído e manter o limite de 14.

### D6 — Revelação do loot (risco baixo)
Ao quebrar um destrutível ou abrir um baú, o item "salta" com brilho conforme a raridade (comum, mágico, raro, único) e um aviso curto.
Casa com a **Sorte** (MEC-033): quando a Sorte melhora o resultado, mostrar o trevo ao lado do item.

## Ordem sugerida
D1 + D2 + D3 (visual, sem balanceamento, juntos num lote "Impacto") → D5 → D6 → D4 (mecânica, mede com o bot e entra num lote próprio).
O nível de feedback do Passo pelas Sombras e das armadilhas já segue o mesmo padrão e serve de molde.

## Não objetivos
Nova moeda, nova tela, loja de cosméticos, ou mudar o dano das armas. D4 não é um sistema de combo de dano.

## Perguntas para o dono
- Quais itens entram (D1 a D6)? Proposta: D1, D2, D3 e D5 já; D6 e D4 depois.
- Nomes dos marcos da Maré do Abismo (D4): usar lore do Vault ou termos genéricos?
- Opção **Efeitos de impacto** em Opções: confirmar o padrão (proposta: Padrão ligado).

## Decisão do dono (2026-10-01) e implementação
Itens escolhidos: **D1 + D2 + D3 (lote Impacto)**. Implementados 2026-10-01:
- **D1 Estouro de abate** (`ui/run.gd` `_kill_burst`): partículas na cor do inimigo (5 no comum, 10 no elite com anel âmbar, 16 no chefe com anel grande). Reaproveita `spawn_impact` e `_ring`; sem arte nova.
- **D2 Hit-stop** (`_hit_stop`): 40 ms no crítico, 50 ms no abate de elite, 120 ms no de chefe; no máximo uma pausa a cada 0,3 s, teto de 150 ms.
- **D3 Coleta com ritmo** (`_pickup_feedback`, `Sfx.chain_pitch`): o tom sobe 5% por coleta encadeada em até 0,6 s (teto de 8 passos, +40%); faísca âmbar ao pegar moeda; a barra de XP pisca (`Hud.pulse_xp`).
- **Opção de acessibilidade** (Opções → "Reduzir efeitos de impacto"): desliga o hit-stop, reduz as partículas e a faísca da moeda. Padrão: desligada (`settings.reduced_impact`).
- Testes em `tests/test_impact_fx.gd` (tom encadeado, teto, padrão da opção). Visual e hit-stop não têm teste automático; conferir em run real.
- Ficam para depois: D5 (números de dano), D6 (revelação do loot), D4 (Maré do Abismo).

## D5 implementado (2026-10-01)
- Evento `hit` do herói agora leva `dtype` e `tid` (alvo). `ui/run.gd`: cor do número por tipo de dano (`_dcol`: físico cinza, mágico roxo, fogo laranja, radiante dourado); crítico em 22 pt, mais claro e com contorno.
- **Agregação:** acertos não críticos no mesmo alvo dentro de 350 ms somam no mesmo número (`_merge_damage_number`), com leve pulso; críticos sempre aparecem sozinhos. O limite de 14 números simultâneos continua.
- Testes automáticos passam (0 falhas, fumaça ok); o visual precisa de conferência em run real.

## D6 implementado (2026-10-01)
`ui/run.gd` `_loot_reveal`, disparado pelos eventos `item` e `item_offer` (baú, destrutível, Mímico, chefe): anel e faíscas na cor da raridade (comum só faíscas; mágico, raro e único com anel crescente 1,1 / 1,5 / 2,0) e o nome do item flutuando acima do herói, maior e em destaque para raro e único. A marca "(sorte)" aparece em itens acima de comum quando a Sorte do herói é positiva (aproximação: o jogo não registra se a Sorte mudou o sorteio). "Reduzir efeitos de impacto" corta as faíscas pela metade. O item não "salta" fisicamente: ele já vai direto para o herói. Sem teste automático; conferir em run real.

## D4 implementado (2026-10-01)
- `core/battle.gd` (`_tide_kill`, `tide_xp_bonus`, evento `streak`): janela de 3 s sem matar zera a sequência; marcos em 10 / 25 / 50 / 100 / 200 com os nomes **Maré Cinzenta, Maré Negra, Maré de Gehenna, Maré do Abismo, Maré Sem Fundo** (propostos a partir do Vault, ajustáveis na constante `TIDE_MARKS`). Cada marco dá +2% de XP coletado por 5 s, com teto de +10%. Aviso via `hud.toast` em `ui/run.gd`. Não consome a RNG. Testes em `tests/test_tide.gd`.
- **Ainda não medido com o bot** (o XP extra pode mudar o ritmo de nível); abrir cartão BAL se o bot indicar desvio.
- **Conquistas de sequência sem dano** (pedido do dono): `Intocado` (25, +100 moedas), `Sombra Sem Marca` (75, +250) e `Maré Sem Rastro` (200, +600), por run, via `stats.clean_kills` (zera em `_hurt_hero`; guarda o melhor em `clean_streak_best`) e `run_clean_streak` em `core/profile.gd`. Dano absorvido por guarda ou barreira não zera.
