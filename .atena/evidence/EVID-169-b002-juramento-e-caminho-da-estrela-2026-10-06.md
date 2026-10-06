---
id: "EVID-169"
title: "B-002: Juramento de Lliira e Caminho da Estrela (motor, testes e medição com o bot)"
created: "2026-10-06"
relations: ["[[SPEC-129-dinamismo-bencaos-divinas-e-eventos]]", "[[EVID-166-b001-medicao-das-bencaos-2026-10-06]]"]
cards: ["MEC-047", "BAL-019"]
---

# EVID-169 — B-002 (famílias `oath` e `path`)

## O que entrou
- **Motor:** `core/boon_kinds.gd` (`BoonKinds`), com estado e regras; ganchos em `core/battle.gd` (`step`, `_hurt_hero`, `load_stage`, texto da oferta), `core/hero.gd` (`kind_buffs`, bônus temporários que expiram) e interface em `ui/hud.gd` (linhas de juramento, fé e buffs) e `ui/overlay.gd` (estrela e seta na borda; arte provisória: losango dourado).
- **Dados:** `lliira_juramento` (família `oath`) e `tou_um_caminho` (família `path`) em `data/boons.json`; efeitos em `data/boon_effects.json`. A descrição do cartão é **gerada dos parâmetros** (`BoonKinds.describe`).
- **Juramento:** a cada 75 s abre um juramento de 40 s, "no máximo 3 golpes"; cumprido: Glória (+25% de dano, +10% de velocidade, 30 s); quebrado: Julgamento (−12% de dano, 20 s), **sem perda de PV e sem morte**. Contam como golpe só `hit`, `aoe` e `trap` (poça, névoa e custo de pacto não quebram).
- **Estrela:** nasce a 14 tiles, recua quando o herói chega a 4; andar na direção dela (±60°) cura; a cada 60 s acumulados seguindo vem a Exaustão (−10% de velocidade, 15 s). RNG própria (semente da run `^ 0x57A2`), sem deslocar a da batalha.
- **Ferramentas:** `tools/bal_bencaos.gd` agora segue a estrela quando calmo e imprime `KIND;` com juramentos cumpridos e quebrados e exaustões; `tools/shot.gd` ganhou `boon=<id>`.

## Verificação
- `tests/test_boon_kinds.gd` (novo): dados e descrição, juramento cumprido, quebrado (nunca tira PV nem mata), poça não quebra, reinício no ciclo seguinte; estrela dentro do mapa e a ≥ 10 tiles, parado não cura, andar na direção cura, recua perto, Exaustão aos 60 s e zera o contador, expira; sem as bênçãos nada muda.
- **`tests/run_all.gd`: 0 falhas.** **`tools/audit_projeto.gd`: 0 erros, 7 avisos** (os mesmos de antes: apresentações de chefe).
- Captura real (`tools/shot.gd`, Dagruve, Durvall): linha "Próximo juramento", "Estrela — fé 0/60 s", marcador "Estrela do Norte" e seta na borda aparecem no HUD.
- Primeira execução: o cache de classes do Godot precisou de `--import` para registrar `BoonKinds`; em cópia limpa, rodar uma vez `godot --headless --path . --import`.

## Medição com o bot
Mesma matriz do EVID-166 (10 heróis × novato/veterano × 6 sementes = 60 runs por célula, 4 primeiras fases). **Controle: 0,72 fases** nas duas metas, erro-padrão ≈ 0,12; uma diferença só conta acima de ≈ 0,3. Dados: `curva_*.csv` e `resumo_*.txt` na pasta `EVID-169-…/`.

| Configuração | Novato | Veterano | Observação |
|---|---|---|---|
| **Juramento de Lliira** | 0,63 | 0,93 | neutro; o bot **cumpre 63–64%** dos juramentos (378 cumpridos, 224 quebrados no novato) |
| Caminho da Estrela, cura **1,2** PV/s | 1,45 | 1,58 | forte demais (+0,73 e +0,86) |
| Caminho da Estrela, cura **0,6** PV/s (**valor adotado**) | 1,37 | 1,50 | ainda acima do teto de +0,5 (+0,65 e +0,78) |
| Diagnóstico: cura **0,0** (só seguir a estrela), novato | 1,03 | — | **+0,31 sem curar nada** |

### Leitura
- **Juramento:** dentro do aceite (não passa de +0,5, não fica 0,3 abaixo do controle). O limite de 3 golpes dá um equilíbrio que o bot cumpre perto de dois terços das vezes.
- **Caminho da Estrela:** a cura pouco muda o resultado (1,2 → 0,6 PV/s tira só 0,08 fase). **Cerca de +0,31 vem só de o bot andar atrás da estrela** (sem cura), efeito de movimento (o piloto "kita" em vez de ficar parado), **não da bênção**; é um artefato do bot. A cura de 0,6 PV/s soma ≈ +0,34 sobre isso, comparável a Vida Nova (+0,23 / +0,56) e abaixo da Bênção da Cura (+0,53 / +1,00).
- **Exaustão:** 884 acionamentos em 60 runs (≈ 15 por run) mostram que o bot segue a estrela quase o tempo todo; um jogador de verdade luta e se afasta, então o valor real deve ficar abaixo do medido.
- **Decisão do aceite:** o critério "sem passar de +0,5" foi **violado** pelo Caminho da Estrela na medição bruta (+0,65 / +0,78), mas ≈ +0,34 depois de descontar o efeito do bot. Mantive **cura 0,6** e deixo a decisão final ao dono; ajuste posterior é só número em `data/boons.json`.

## Limites
Bot não simula o jogador (não luta e foge da estrela; não vê o juramento); só 4 fases; bênção forçada desde o início da run (no jogo vem do altar); sem playtest. A estrela e o juramento usam arte provisória (ART a registrar).

## Reversão
`git revert` do commit do motor (inclui as duas bênçãos); as 14 bênçãos antigas não foram alteradas.
