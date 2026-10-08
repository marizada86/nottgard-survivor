---
id: "EVID-199"
title: "Relato do playtester T04 (Manzi) sobre a v0.3.2, repassado pelo dono"
created: "2026-10-07"
relations: ["[[EVID-163-relato-t04-manzi-sylas-2026-10-05]]", "[[SPEC-130-ficha-c-em-abas-grade-e-detalhe]]"]
cards: ["MEC-008", "MEC-027", "MEC-045", "MEC-048"]
---

# EVID-199 — T04 Manzi, segundo relato (v0.3.2)

**Natureza:** relato **de segunda mão**, colado pelo dono (Higor) em 2026-10-07. Sem pacote `evidencias/`, log nem prints; sem hash de build verificável. O texto cita a v0.3.2 (build local exportada em 2026-10-06, ver [RELEASES](../backlog/RELEASES.md)). Heróis e fases jogados não foram informados. Manzi não é de primeira vez (T04 já havia relatado a v0.3.0 em [EVID-163](EVID-163-relato-t04-manzi-sylas-2026-10-05.md)).

| # | Relato (resumo fiel) | Intake | Verificação no código (leitura; nada executado) | Destino sugerido |
|---|---|---|---|---|
| 1 | Mostrar as evoluções de arma e skill mais detalhadas e ver os próximos níveis | IN-059 | A ficha C mostra descrição, faixa de dano atual e a dica de evolução (`ui/character_sheet.gd:494-504`, `core/battle.gd:2375`). **Não** mostra o próximo nível nem o que a evolução vira. O cartão de level-up já mostra o ganho do próximo nível (`_level_desc`, `core/battle.gd:2389`) | MEC novo (próximo nível e evolução na ficha) |
| 2 | Ctrl deveria mostrar as melhorias dos próximos níveis de magias e armas, ou algo aproximado | IN-060 | Ctrl não está ligado a nada (só `Ctrl+Shift+P` em `core/playtest.gd:540`). **Shift** já mostra o detalhe das ofertas (`Game.ACTION_OFFER_DETAILS`, `core/game.gd:115`, MEC-027), mas só nas telas de oferta. Provável mesmo pedido do item 1 | Junto de IN-059 |
| 3 | Em "Sinergias e bônus" trocar nome e número de lugar: nome antes do valor (ex.: "Dano - 28%", "Crítico - 3%") | IN-061 | Hoje a linha é valor (coluna de 54 px) e depois o nome (`_bonus_row`, `ui/character_sheet.gd:618-621`) | MEC pequeno (inverter ordem) |
| 4 | Poder apertar C quando há escolha (magia ou item), para o menu ajudar a decidir | IN-062 | **Correção (2026-10-08):** a primeira leitura olhou só `ui/run.gd:299-310`, que de fato corta a tecla nas ofertas. Mas a HUD tem ramo próprio que abre a ficha nas ofertas (`ui/hud.gd:337-340`), criado no commit `14633e2` (2026-10-06 22:55), que **não é ancestral da base da v0.3.2** (`a09d460`). O relato procede para a v0.3.2 e **provavelmente já está corrigido no HEAD**; falta confirmar em run real (abrir a ficha numa oferta, usar o foco e fechar). O fechamento com C continua quebrado (ver EVID-200, item 2) | Verificar; sem BUG até reproduzir |
| 5 | Ao evoluir uma magia/arma, a antiga volta a aparecer nas opções ao subir de nível | IN-063 | **Causa encontrada.** A evolução troca a arma pela evoluída (`core/battle.gd:2498-2506`); a base deixa de ser "possuída". O filtro de "NOVA" só exclui fontes `Evolução` e `Item` (`:2294`), e a base tem fonte `Arma de Durvall` ou `Carta: ...`; logo é oferecida de novo (8 armas evoluem) | BUG novo (P1) |
| 6 | Ao entrar no lago, mostrar na HUD o debuff | IN-064 | O Estige já escreve uma linha de texto na HUD (`ui/hud.gd:376-379`, só com `styx_exposure > 0`), sem ícone nem destaque. **Não confirmado** que a linha aparece em run real; falta saber qual fase | MEC novo (indicador de status) + confirmar com Manzi |
| 7 | Ao passar de mapa, o baú cai instantaneamente | IN-065 | Intencional no código: cada fase começa com `_inter_t = 4.0` e `_first_inter = true`, e o primeiro interativo é sempre baú (`core/battle.gd:302`, `:2859-2861`). Surge a 6 a 12 tiles do herói, 4 s após a troca de mapa | Decisão do dono (BAL/MEC) |

## Sinais cruzados
- Itens 1 e 2 reforçam MEC-008 e MEC-027 (T01 e T02 já pediram clareza de evolução): o cartão de level-up resolveu na escolha, falta o mesmo na ficha.
- Item 4 liga com o pedido de EVID-163 #2 e #3 (ficha C como ferramenta de decisão).
- Item 7: T01 pediu menos tempo entre mapas (MEC-010); aqui o incômodo é o oposto (recompensa imediata demais). Pesa só esta fonte.

## Limites
Relato único e indireto. O item 5 é defeito lido no código, mas **ainda não reproduzido** em run real; o item 4 provavelmente já foi resolvido no HEAD (ver linha 4). O item 6 depende de saber a fase. O Ctrl do item 2 pode ser engano por Shift: perguntar a Manzi.
