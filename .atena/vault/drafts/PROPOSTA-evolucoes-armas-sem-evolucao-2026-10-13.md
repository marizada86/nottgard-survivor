---
id: PROPOSTA-evolucoes-armas-sem-evolucao
title: Evoluções para as armas sem evolução, priorizando as mais fracas no fim do jogo
status: DRAFT v01 — proposta aguardando decisão do dono; nada codificado, data/weapons.json intacto
created: 2026-10-13
relations: ["[[SPEC-150]]", "[[SPEC-122-balanceamento-ritmo-inicial-xp-armas-e-raridade]]", "[[EVID-154-lotes-b003-a-b006-armas-eventos-raridade-2026-10-04]]", "[[EVID-190]]"]
---

# Evoluções para as armas sem evolução

> **Estado do conteúdo: DRAFT v01.** Números, nomes e passivas são hipóteses para o dono aprovar. Nada vira CANON nem entra em `data/weapons.json` sem aprovação explícita da revisão.
>
> **Revisão v02 (2026-10-13):** o dono aprovou o lote 1 com as 5 evoluções ("aprovo o plano com 5 evoluções"), pediu nome ligado a Sylvaris/Silva para a evolução do Sopro de Estrela e propôs um **atributo mínimo** para evoluir. A spec e o plano executável estão em [SPEC-174](../../specs/SPEC-174-evolucoes-das-armas-sem-evolucao-lote-1-e-atributo-minimo.md) e [PLAN-101](../../state/plan-101-evolucoes-armas-sem-evolucao.yaml). Onde esta proposta diz "Maré da Concha", vale o nome recomendado **Constelação de Silva** (checagem de lore na spec). O conteúdo aprovado continua DRAFT até a aprovação de revisão para canon.

## 1. Conclusão em quatro linhas

- Das 38 entradas de `data/weapons.json`, **18 armas não têm evolução**. As 10 evoluções existentes cobrem só 10 bases.
- **8 dos 12 heróis começam com uma arma sem evolução** (Sylas, Korrak, Leoric, Nyrelia, Zynara, Bromnor, Arlindo e Erik). Para eles o late-game não tem o pico que Durvall, Brook, Maelor e Kayron têm.
- Pela régua desta proposta, as mais fracas no fim do jogo são **Dominar Pessoa, Golpe Esmagador, Martelo da Glória, Raio Enfraquecedor e Sopro de Estrela**, e é com elas que sugiro começar (lote 1).
- Cinco passivas nunca são exigidas por evolução (Robe Arcano, Regeneração, Sabedoria, Ganância, Pele de Pedra); a proposta usa quatro delas e **evita de propósito a Regeneração**.

## 2. Como medi (e o que isto não prova)

Régua: [regua.js](../../generated/evolucoes-armas-2026-10-13/regua.js), só leitura de `data/weapons.json`, mesma conta de `tools/bal_conteudo_novo.gd`.

| Coluna | Significa |
|---|---|
| **ST** | DPS esperado em alvo único, nível 5 da arma, modificador de atributo +2, sem crítico nem erro. É o que importa contra **chefes e elites** |
| **MULTI 0,2 / 0,4** | ST × alvos atingidos, com 0,2 (grupo médio) e 0,4 (horda) inimigos por unidade². Projétil: 1 + `pierce` (máx. 4). É o que importa contra **ondas** |

Limites, para ninguém tomar isto por veredito:

1. **Não há dado de campo.** `damage_by_source` existe no `run_record`, mas não há nenhum registro de testers no repositório. A densidade de inimigos (0,2 e 0,4) é hipótese.
2. A régua ignora crítico, erro de d20, bônus de item e de bênção, sinergias e o efeito próprio das armas de item único.
3. **Chefe limita atordoamento a 0,6 s** (`core/battle.gd:869-872`: `stun × 0,3`, teto 0,6). Toda arma cujo valor é atordoar perde quase tudo contra chefe, e a régua de DPS não mostra isso.
4. `mark` (Marca da Retidão) multiplica **todo** dano que o alvo recebe por 5 s. A régua subestima essa arma; por isso ela não está na prioridade.
5. Bot e playtest não rodaram para esta proposta. Antes de aprovar números, rodar `tools/bot_curva.gd` e `tools/bal_conteudo_novo.gd` com as evoluções (§7).

## 3. Ranking de fraqueza (armas sem evolução, nível 5)

Ordem de prioridade = fraca nos **dois** eixos (ST e MULTI), depois por ser arma inicial de herói ou carta que qualquer um pega.

| # | Arma | Origem | ST | MULTI 0,2 | MULTI 0,4 | Por que é fraca no fim do jogo |
|--:|---|---|--:|--:|--:|---|
| 1 | **Dominar Pessoa** (Nyrelia) | carta | 6,2 | 6,2 | 6,2 | Sem `pierce`, 2 projéteis; atordoar 4 s vira 0,6 s no chefe |
| 2 | **Golpe Esmagador** | carta | 7,0 | 7,0 | 7,0 | Cone de 55°, dado pequeno; atordoar 1 s vira 0,3 s no chefe |
| 3 | **Martelo da Glória** (Bromnor) | item inicial | 8,5 | 8,5 | 13,0 | Recarga 2,3 s; o empurrão tira o inimigo do cone |
| 4 | **Raio Enfraquecedor** (Sylas) | carta | 13,1 | 13,1 | 13,1 | Zero `pierce`; já registrada como a inicial mais fraca (EVID-154); Sylas está liberado desde o começo |
| 5 | **Sopro de Estrela** (Leoric) | item inicial | 2,7 | 27,1 | 54,1 | Bom em onda, mas ST de 2,7 não mata chefe |
| 6 | Ampulheta do Silêncio Eterno (Zynara) | item inicial | 2,8 | 43,2 | 86,4 | Igual ao Sopro; o controle some no chefe |
| 7 | Vela Sagrada | carta | 2,2 | 7,8 | 15,7 | Raio 2,4 e dado 1d8; a cura está congelada (§5) |
| 8 | Machado de Xar'gath (Korrak) | item inicial | 11,5 | 11,5 | 17,8 | Intermediária; a vida roubada está congelada |

Fora do ranking, de propósito: **Marca da Retidão** (a régua subestima o `mark`), **Lâmina de Sombra**, **Memória Alterada** e **Tocha do Incendiário** (conteúdo novo ainda sem playtest), **Domínio da Vontade** (sem níveis, não evolui) e as de item único (Chicote, Lâmina da Digestão, Colar, Cajado, que só aparecem com o item).

Referência das evoluções que já existem (ST / MULTI 0,2): Espada do Receptáculo 15,5 / 18,3; Esmagar Defesas 14,1 / 14,1; Rajada de Golpes 24,3 / 24,3; Tormenta de Fogo 6,1 / 96,2; Chuva de Estrelas 5,7 / 89,8; Luz Mais Pura 34,1 / 170,5; Tempestade 44,3 / 221,4.

## 4. Lote 1 proposto (5 evoluções)

Todas com `levels: []`, `src: "Evolução"` e `icon_like` apontando para o ícone da base (mesmo caminho da Tormenta de Fogo e do Esmagar Defesas). **Nomes provisórios; checar no vault antes de aprovar.**

| Base | Evolução | Passiva | Parâmetros (nv5 da base → evolução) | ST | MULTI 0,2 | × ST |
|---|---|---|---|--:|--:|--:|
| Dominar Pessoa | **Domínio Coletivo** | Sabedoria | 2d6 cd 2,9 count 2 stun 4 → **2d8 cd 2,6 count 3 pierce 1 stun 3** | 6,2 → 12,7 | 6,2 → 25,4 | 2,0 |
| Golpe Esmagador | **Maça Demolidora** | Pele de Pedra | 1d10 cd 1,5 cone 55 alc. 1,8 stun 1 → **3d10 cd 1,3 cone 80 alc. 2,2 stun 1,5** | 7,0 → 14,2 | 7,0 → 14,2 | 2,0 |
| Martelo da Glória | **Martelo do Alvorecer** | Cota de Malha | 3d8 cd 2,3 cone 110 knock 2,5 → **4d10 cd 1,8 cone 130 knock 2,0 stun 1** | 8,5 → 13,3 | 8,5 → 16,0 | 1,6 |
| Raio Enfraquecedor | **Raio da Ruína** | Robe Arcano | 1d8 cd 1,3 count 2 pierce 0 weaken 3 → **2d6 cd 1,2 count 3 pierce 2 weaken 4** | 13,1 → 22,5 | 13,1 → 67,5 | 1,7 |
| Sopro de Estrela | **Maré da Concha** | Sabedoria | 2d8 cd 5,2 r 4,0 slow 3 weaken 1 → **5d8 cd 4,6 r 4,8 slow 3 weaken 2** | 2,7 → 5,3 | 27,1 → 77,1 | 2,0 |

Leitura:

- **Nenhuma passa de uma evolução existente.** O maior ST do lote (22,5) fica abaixo de Rajada de Golpes (24,3) e Tempestade (44,3); o maior MULTI (77,1) fica abaixo de Chuva de Estrelas (89,8).
- A relação evolução ÷ base (1,6× a 2,0× em ST) fica na faixa das últimas duas evoluções (Esmagar Defesas 1,7×, Tormenta 1,5×) e abaixo das originais.
- **Dominar Pessoa** troca 1 s de atordoamento por mais alvos (3 projéteis, atravessa 1). Contra chefe continua limitado em 0,6 s; o ganho é de ST (6,2 → 12,7) e de onda.
- **Martelo**: o `knock` cai de 2,5 para 2,0 e o cone sobe para 130° para o inimigo empurrado continuar acertável; ganha `stun 1`.
- **Raio da Ruína** é o maior salto de MULTI (5,2×) porque a base tem `pierce 0`. É o ponto a vigiar no bot, mas está bem abaixo de Luz Mais Pura.
- **Sopro de Estrela**: o ST continua baixo de propósito (5,3, quase igual à Tormenta de Fogo, 6,1). O papel dele é controle em área, e a Maré da Concha só deixa de ser inofensiva contra chefe.

### Pareamento de passivas (sugestão, aberta)

| Passiva | Usada hoje por | Passa a usar |
|---|---|---|
| Sabedoria | nenhuma | Domínio Coletivo, Maré da Concha |
| Pele de Pedra | nenhuma | Maça Demolidora |
| Robe Arcano | nenhuma | Raio da Ruína |
| Cota de Malha | Espada do Receptáculo, Esmagar Defesas | + Martelo do Alvorecer (arma física pesada, mesmo tema) |
| Regeneração | nenhuma | **ninguém, de propósito** (§5) |
| Ganância | nenhuma | reservada para o Chicote Avarento (item, `gold_hit`), fora do lote 1 |

A evolução só aparece no level-up se a arma estiver no nível 5 **e** o herói tiver a passiva (nível ≥ 1), e a passiva ocupa um dos 5 espaços de passiva. Escolher passiva pouco usada diversifica o build; a contrapartida é que o jogador precisa **encontrá-la** (peso 2 de oferta, contra 9 da própria evolução).

## 5. Restrições que a proposta respeita

- **Cura: nunca melhorar** (decisão do dono, BAL-022/EVID-190). Nenhuma evolução do lote tem `heal` ou `lifesteal`. Na reserva, a Vela Sagrada mantém `heal 1,5` e o Machado **reduz** a vida roubada (4,5 % → 3 %).
- **Sem Regeneração.** Parear evolução com Regeneração empurraria o jogador a empilhar sustain, que é o caminho para a imortalidade que você já cortou.
- **Conteúdo novo espera playtest:** Lâmina de Sombra, Memória Alterada, Tocha do Incendiário, e também as duas evoluções da 0.4.0 (Tormenta de Fogo e Esmagar Defesas) ainda sem veredito na pergunta 4 do questionário.
- **Dados de gameplay, não de lore:** descrições abaixo são mecânicas. Nenhum texto de lore foi inventado; nomes dependem de checagem no vault de Nottgard.

## 6. Reserva (fora do lote 1)

| Base | Evolução | Passiva | Parâmetros | ST | MULTI 0,2 | Motivo de ficar na reserva |
|---|---|---|---|--:|--:|---|
| Ampulheta do Silêncio Eterno | Silêncio Absoluto | Robe Arcano | **4d8 cd 4,0 r 5,0 stun 3** (de 2d8) | 2,8 → 5,0 | 43,2 → 78,5 | Já é forte em onda; precisa antes de playtest de controle |
| Vela Sagrada | Círio Eterno | Pele de Pedra | **3d8 cd 2,8 r 3,2 heal 1,5** (de 1d8 cd 3 r 2,4, mesma cura) | 2,2 → 5,5 | 7,8 → 35,6 | A cura segue congelada; o salto de área (4,5×) pede cautela |
| Machado de Xar'gath | Machado do Abismo | Pele de Pedra | **3d10 cd 1,2 alc. 2,4 cone 120 burn 4 lifesteal 0,03** | 11,5 → 15,4 | 11,5 → 18,6 | Intermediária; já nerfada três vezes |

## 7. Se o dono aprovar: o que muda e como verifico

Mudança de **dados**, sem código novo (o mecanismo `evolve` / `can_evolve` / oferta com peso 9 já existe):

1. `data/weapons.json`: um bloco `evolve` por base e uma entrada nova `src: "Evolução"` por evolução (mesma forma de `tormenta_de_fogo` e `esmagar_defesas`; `levels: []` e `icon_like` da base).
2. Som: entrada clonada em `data/audio_manifest.json` (mesmo caminho do ART-042). Ícone próprio fica como arte pendente, provisório via `icon_like`.
3. `tools/bal_conteudo_novo.gd`: incluir as evoluções em `NEW_WEAPONS`.
4. Testes: `tests/test_data.gd` e `tests/test_new_content.gd` (contagem de evoluções, alvo existente, passiva existente, `icon_like` válido).

Verificação planejada: suíte e smoke; `bal_conteudo_novo.gd` antes e depois; `bot_curva.gd` com Nyrelia, Sylas, Bromnor e Leoric em duas fases (alarme, não veredito); e um **playtest humano** de sensação, que fica pendente por definição (o dono joga).

## 8. Pendências por tipo

| Tipo | Item |
|---|---|
| BLOCKING | nenhum para a proposta; **todo** o resto depende da aprovação do dono antes de qualquer código |
| RESOLVABLE | nomes das evoluções (checar vault e Nottcard); pareamento de passivas; tamanho do lote (3, 5 ou 8) |
| DEFERRED | ícones e sons próprios; evoluções de Arlindo, Erik, Lâmina de Sombra e itens únicos, depois do playtest; número final de cada evolução depois do bot e do playtest |

## 9. Pergunta que mais muda o resultado

Chefe limita atordoamento a 0,6 s. Dominar Pessoa, Ampulheta e Golpe Esmagador vivem de atordoar. Duas saídas, que **não** estão nesta proposta e pedem decisão própria: (a) deixar como está e aceitar que armas de controle são de onda, não de chefe; (b) subir o teto contra chefe (0,6 s → 1,0 s), que é mudança de regra de combate, não de evolução.
