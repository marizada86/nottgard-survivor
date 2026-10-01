# EVID-143 — Bot travado em `item_offer` e ajuste do chefe das Docas (BAL-012)

Data: 2026-10-01 · `tools/bot.gd`, `data/enemies.json` · 10 heróis × 10 sementes, Dagruve → Docas → Shedaklah (5 min por fase), dt 0,05.

## Achado 1: a varredura de EVID-142 estava truncada
Desde a troca de item (MEC-021/027, 2026-09-29) o bot não respondia ao estado `item_offer`: a run parava no primeiro item oferecido e o log gravava "tempo". Também tratava `revive_offer` como run viva. Consequências:
- A "passagem de fase" de 4 % (Dagruve) e 11 % (Docas) do EVID-142 é **artefato do bot**, não dificuldade de chefe.
- Os níveis médios do EVID-142 (e as comparações de BAL-013 e BAL-014, inclusive a calibragem de Nyrelia e Zynara) medem **até o primeiro item oferecido**, não a run inteira. A ordem dos heróis precisa ser refeita.

Correção (`tools/bot.gd`): escolhe a opção de troca com melhor saldo de modificadores; `revive_offer` conta como morte (sem Segunda Chance, como antes); o log traz o motivo real do fim da run e, por chefe, `duração/PV mínimo do herói`.

## Achado 2: números corretos (bot corrigido, build base)
Dagruve → Docas, 10 sementes por herói (100 runs):
- 67 de 100 vencem o Sacerdote de Dagruve e entram nas Docas; **todas as 64 que chegam ao chefe das Docas o vencem**.
- **Guardião Alado (60 PV × 1,35):** luta de mediana **11 s** (p90 33 s, máx. 110 s), PV mínimo médio do herói 95 %, nenhuma luta abaixo de 60 %.
- **Sacerdote (260 PV):** mediana 202 s, p90 1 279 s (extremos de até 45 min com herói de pouco dano), PV mínimo médio 74 %, 11 de 67 lutas abaixo de 50 %.
- A maior perda está **no começo de Dagruve** (morte antes do chefe): Kayron 7/10, Zynara 6/10, Durvall e Leoric 5/10, Sylas 4/10. Aberto como BAL-015.

## Ajuste do Guardião Alado (verdadeiro)
| Versão | Luta nas Docas (mediana / p90) | PV mínimo médio do herói | Lutas < 60 % |
|---|---|---|---:|
| Base: 60 PV, bônus 4, grito 1d8 | 11 s / 33 s | 95 % | 0 |
| 360 PV | 41 s / 142 s | 91 % | 0 |
| **480 PV, bônus 6, investida 1d10+6, grito 2d6** | **51 s / 156 s** | **87 %** | 2 |

Adotada a terceira. Com `hp_mult` 1,35 fica em ~650 PV efetivos, abaixo de Zuggtmoy (520 × 1,5 = 780), preservando a progressão de chefes. Ainda é bem mais fácil que o Sacerdote para o bot, porque ele chega às Docas com nível ~20; um humano em nível menor deve achar mais duro. **Confirmar no playtest humano.**

Não mexi no Sacerdote: o problema dele é a cauda longa para heróis de pouco dano, não a morte; fica como decisão do dono.

## Testes
`tests/run_all.gd`: 0 falhas com a mudança.
