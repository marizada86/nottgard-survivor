---
id: "EVID-161"
title: "SPEC-125 B-002: ajustes nos heróis do filtro de Dagruve (resultado negativo, revertido)"
created: "2026-10-05"
relations: ["[[SPEC-125-balanceamento-desafio-e-entretenimento]]", "[[EVID-160-linha-de-base-bal-018-2026-10-05]]"]
cards: ["BAL-018", "BAL-015"]
---

# EVID-161 — B-002: nada ficou no jogo

Bot novato (meta 0), Dagruve apenas (`maxfases 1`), 8 sementes por herói, RNG semeado. Dados: [dagruve8.csv](EVID-161-b002-herois-de-dagruve-resultado-negativo-2026-10-05/dagruve8.csv) (tags `base`, `a`, `b`, `c`).

| Tentativa | Mudança | Resultado (morte em Dagruve) |
|---|---|---|
| a | `base_hp` Durvall 36→42, Leoric 30→34, Nyrelia 30→36, Sylas 32→35, Zynara 32→35 | Durvall 87→75 %, Leoric 62→50 %, Nyrelia 87→75 %, Sylas 62→62 %, Zynara 62→62 % |
| b | + Espada Sombria `cd` 1,4→1,3; Dominar Pessoa `cd` 3,5→3,0 | Durvall 75 %, Nyrelia 75 % (sem ganho) |
| c | abertura `n_mult` 1,25→1,1 e `max_mult` 1,2→1,1 (todos os 10 heróis) | média 51 %→45 %, mas por herói oscila nos dois sentidos (Brook 50→75, Nyrelia 87→50, Sylas 62→25, Bromnor 25→0) |

## Leitura
- Com 8 sementes, uma morte vale 12,5 pontos; todas as diferenças estão dentro do ruído. Nenhuma alavanca provou efeito.
- As mortes de Durvall, Kayron e Nyrelia ocorrem cedo (cerca de 2:40, PV mínimo 2 a 9 %): é o pico da abertura somado ao piloto do bot, não falta de PV nem de dano.
- **O bot novato morre 45 a 52 % em Dagruve, enquanto os humanos (T03, Hiago, dono) acham o início fácil.** Calibrar Dagruve por esse número contraria o feedback humano. Decisão E2 (manter Dagruve, esperar o playtest) se mantém.

## Decisão
Reverti `heroes.json`, `weapons.json` e `difficulty.json` (`git checkout`); nenhuma mudança de jogo neste lote. O foco de desafio passa para **Docas em diante**, onde o bot e os humanos concordam que está fácil (Docas 0 %, PV mínimo 79 %).
