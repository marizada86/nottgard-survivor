---
id: "EVID-148"
title: "Curva de dificuldade por fase: bot em 9 fases, 10 heróis, 3 perfis de meta"
created: "2026-10-03"
relations: ["[[PLAN-055-mapas-vivos-segredos-e-dificuldade-2026-10-03]]", "[[SPEC-120-curva-base-e-marcas-do-abismo]]", "[[EVID-143-bot-travado-em-item-offer-e-chefe-das-docas-2026-10-01]]", "[[EVID-144-varredura-do-bot-corrigido-dagruve-docas-2026-10-01]]"]
cards: ["BAL-001", "BAL-016", "BAL-015", "MEC-040"]
---

# EVID-148 — Curva de dificuldade por fase (PLAN-055 F2)

Noite de 2026-10-03. Pergunta: **onde a curva achata?** T03 (Daniel) acha o
jogo fácil e o dono diz que enjoa depois do 3º ou 4º mapa.

## Método

- Ferramenta nova `tools/bot_curva.gd`: mesmo piloto do `tools/bot.gd` (kite,
  escolhas heurísticas, portal depois do chefe), mas grava **uma linha por
  fase**: nível de entrada e saída, PV mínimo, segundos abaixo de 50 % e 25 %
  de PV, dano recebido, duração do chefe e resultado.
- Mapa 60×60 (o do jogo), `dt` 0,08, até 9 fases, campanha a partir de Dagruve.
- **10 heróis × 6 sementes × 3 perfis de meta = 180 runs, 1 222 passagens de
  fase.** Perfis (`meta_mods` no `Battle.new`):
  - **novato:** nenhum aprimoramento;
  - **veterano:** +16 % de dano, +8 PV, +1 CA, +3 % de velocidade (≈ 4 níveis de Força Bruta e Vitalidade);
  - **loja cheia:** +40 % de dano, +20 PV, +3 CA, +9 % de velocidade, +1,2 de coleta (perto de T01, que comprou tudo).
- Dados brutos: [`curva.csv`](EVID-148-curva-de-dificuldade-por-fase-2026-10-03/curva.csv); tabelas: `node analisa.js curva.csv` na mesma pasta.

## Resultado

### Por fase (média de 10 heróis)

**Novato (60 runs)**

| Fase | Chegaram | Morreram nela | PV mín. médio | s abaixo de 50 % | Nível entrada→saída |
|---|---:|---:|---:|---:|---|
| Dagruve | 60 | **18 (30 %)** | **39 %** | 27 | 1→13 |
| Docas | 42 | 2 (5 %) | 76 % | 7 | 15→23 |
| Shedaklah | 40 | 1 (3 %) | 75 % | 1 | 23→35 |
| Molor | 39 | 0 | 85 % | 0 | 35→45 |
| Durao | 38 | 0 | 86 % | 0 | 45→51 |
| Feng-tu | 38 | 0 | 90 % | 0 | 51→57 |
| Shendilavri | 35 | 0 | 89 % | 0 | 57→62 |
| Goranthis | 33 | 0 | 85 % | 0 | 63→66 |
| Pilares | 25 | 0 | 82 % | 0 | 67→86 |

**Veterano (60 runs)**

| Fase | Chegaram | Morreram nela | PV mín. médio | s abaixo de 50 % | Nível |
|---|---:|---:|---:|---:|---|
| Dagruve | 60 | 11 (18 %) | 51 % | 38 | 1→14 |
| Docas | 49 | 0 | 85 % | 0 | 16→23 |
| Shedaklah | 47 | 1 (2 %) | 80 % | 1 | 23→33 |
| Molor | 45 | 0 | 86 % | 0 | 33→44 |
| Durao | 44 | 0 | 86 % | 0 | 44→50 |
| Feng-tu | 43 | 0 | 90 % | 0 | 50→56 |
| Shendilavri | 42 | 0 | 90 % | 0 | 56→62 |
| Goranthis | 39 | 1 (3 %) | 82 % | 0 | 62→67 |
| Pilares | 35 | 0 | 78 % | 1 | 67→86 |

**Loja cheia (60 runs):** Dagruve 5 % de mortes e PV mín. 65 %; da Docas em
diante PV mín. entre 75 % e 92 %, 2 mortes em Shedaklah e 2 nos Pilares.

### Agregado das fases 3 a 9 (os três perfis)

- **894 passagens de fase, 7 mortes (0,8 %).**
- Só **28 (3 %)** passaram **algum** segundo abaixo de 50 % de PV.
- PV mínimo médio por herói nas fases 3+: de 77 % (Nyrelia) a 90 % (Bromnor).

### Por herói

| Herói | Morreu em Dagruve (de 18) | Chegou a Goranthis (de 18) | PV mín. médio, fase 3+ |
|---|---:|---:|---:|
| Bromnor | 0 | 15 | 90 % |
| Korrak | 0 | 15 | 88 % |
| Kayron | 4 | 13 | 87 % |
| Leoric | 3 | 12 | 86 % |
| Zynara | 5 | 13 | 85 % |
| Brook | 4 | 7 | 84 % |
| Maelor | 0 | 16 | 83 % |
| Sylas | 4 | 12 | 82 % |
| Durvall | 7 | 6 | 81 % |
| Nyrelia | 5 | 8 | 77 % |

(Brook e Durvall chegam menos a Goranthis por bater no teto de tempo da run em
lutas longas de chefe, não por morrer.)

## Leitura

1. **A curva tem um degrau só: Dagruve.** É a única fase que mata (30 % dos
   novatos) e deixa o herói abaixo de 50 % de PV. Quem passa por ela entra nas
   Docas com nível 15 e **nunca mais corre perigo**. Isso bate com T03 ("fica
   mais fácil ao evoluir") e com o "enjoa depois do 3º ou 4º mapa".
2. **O meta quase não muda nada da fase 3 em diante.** Novato e loja cheia têm
   o mesmo PV mínimo (85 a 92 %). O que carrega o herói é o nível da run, não
   a loja do Quartel.
3. **Causa provável no código:** o PV dos inimigos multiplica por fase
   (`hp_mult` de 1,0 a 6,5), mas **o dano deles não**: só ganha +1 por camada
   (`tier`) e +1 a cada 4 minutos (`core/enemy.gd:60`), além do dado próprio de
   cada inimigo. Enquanto isso, o herói ganha PV (+1 por nível a partir do 15),
   CA e cura. O inimigo fica uma esponja que não ameaça.
4. **O chefe não é pico.** A luta tem mediana de 35 a 120 s de Docas a Durao, e
   o PV do herói quase não cai nela.
5. **Dagruve não pode ficar mais dura** sem piorar BAL-015: o problema é o
   contrário (duro demais no começo, fácil demais depois).

## Recomendações para a SPEC-120 (números a validar)

- **Escala de dano por fase** (`dmg_mult` novo em `stages.json`, aplicado ao
  dano do inimigo): 1,0 · 1,0 · 1,25 · 1,45 · 1,65 · 1,85 · 2,05 · 2,25 · 2,5.
  É a alavanca que falta; mexe pouco em Dagruve e Docas.
- **Alvo** com o perfil veterano, fases 3+: PV mínimo médio entre **45 % e
  65 %**, **pelo menos 30 %** das passagens com algum tempo abaixo de 50 %, e
  mortes por fase entre **3 % e 10 %**. Rodar `tools/bot_curva.gd` com os
  números novos e iterar.
- Afixos de elite e uma horda por fase (SPEC-120 Parte A) por cima disso.
- Dagruve: **suavizar** o começo (BAL-015) em vez de endurecer, para a
  campanha ter uma curva só, subindo.

## Limites

- O bot não usa loja, ferreiro, curandeiro, fontes nem eventos, e não explora:
  um humano tende a ficar **ainda mais forte** que o bot. A curva real é pelo
  menos tão plana quanto esta.
- O bot luta mal contra chefes (kite longo); a duração do chefe aqui é teto, não
  medida fiel.
- "cap_tempo" nos Pilares é o modo infinito batendo no teto de 9 000 s da
  ferramenta, não falha.
- Amostra de 6 sementes por herói e perfil: bom para tendência, não para
  diferenças finas entre heróis (para isso, PLAN-052).
