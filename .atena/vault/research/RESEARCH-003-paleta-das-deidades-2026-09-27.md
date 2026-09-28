---
id: "RESEARCH-003"
type: "research"
title: "Paleta das deidades — vault de Nottgard e referências de D&D"
status: "research — decisões incorporadas ao canon em 2026-09-27"
created: "2026-09-27"
relations:
  - "[[PLAN-001-nottgard-survivors]]"
  - "[[SPEC-033-legibilidade-visual-e-retorno-divino]]"
  - "[[PLAN-025-tema-de-combate-por-personagem-e-buff-2026-09-27]]"
---

# RESEARCH-003 — Paleta das deidades

## Escopo e precedência

Esta pesquisa recomenda paletas para dano, aura e VFX. Ela não altera canon,
dados, código, nomes ou a cor-base de nenhum herói.

1. O canon de Nottgard prevalece. Ele fixa Kayron em vermelho abissal e Maelor
   em dourado como identidades iniciais; não substituir essas cores por uma
   leitura literal de uma divindade.
2. A paleta de afinidade de altar deve ser distinta da cor-base do herói. Isso
   permite que o personagem seja reconhecido antes da primeira bênção e que a
   escolha posterior tenha uma leitura clara.
3. D&D orienta as divindades publicadas; entidades locais de Nottgard recebem
   direção própria, sem alegação de equivalência oficial.

## Estado encontrado no vault

`core/divine_visuals.gd` atualmente reduz cada afinidade a uma cor e um
contorno. `PLAN-001`, seção 19, define a cor inicial de identidade e a troca
da afinidade visual na última bênção. `SPEC-033` preserva Selûne como
azul-luar/prata.

O arquivo de pesquisa do Abismo mantém `Tou Um` como a grafia e a entidade
locais, informando que a referência de D&D é Tou Mu, ligada à Estrela Polar.
Ele também identifica `Helion.png` como **Mago Helion**; o vault não sustenta
a classificação de Helion como divindade de D&D.

## Matriz aprovada para afinidades divinas

As cores primárias são luminosas o bastante para números de dano e ataques em
cenários escuros. Contorno e sombra devem ser aplicados separadamente; preto
ou marrom muito escuro não são cores adequadas para o próprio número de dano.

| Afinidade | Base no vault / D&D | Cor de dano proposta | Acento / aura | Contorno | Direção visual |
|---|---|---:|---:|---:|---|
| **Shar** | Em D&D: disco preto com borda púrpura; violeta e preto. Kayron permanece vermelho abissal na identidade inicial local. | `#B56BFF` | `#6B2A91` | `#160D24` | eclipse violeta, névoa de sombra e fragmentos de lua escura; a afinidade de altar não apaga o vermelho-base de Kayron antes da bênção. |
| **Sendrinah** | Entidade local; Maelor já é devoto e o canon associa-o ao dourado. | `#F4C542` | `#FFF0B3` | `#8C5B12` | ouro cálido, cura, pequenas fagulhas ascendentes e halo solar contido. |
| **Mask** | Em D&D: máscara preta, ladrões e engano. Sylas e Nyrelia preservam as identidades próprias. | `#AEB8C8` | `#536174` | `#171C27` | prata-fumaça e azul-grafite; sombras em lâminas/fitas, sem transformar a legibilidade em preto absoluto. |
| **Lliira** | Em D&D: triângulo de estrelas laranja, amarela e vermelha; alegria, dança e celebração. | `#FFA12D` | `#FFE05C` e `#F04A3A` | `#9E2F37` | estrelas dançantes, trilhas rítmicas e pulso de três cores; o laranja atual já é uma boa âncora. |
| **Ghaunadaur** | Em D&D: olho violeta/malva em anéis púrpura e pretos; cores verde, púrpura e preta. O vault usa verde para a influência ritualística. | `#8AD14B` | `#A56BDA` | `#44205E` | verde como presença dominante; olho, névoa, tentáculos e impactos usam violeta/malva. |
| **Tou Um** | Adaptação local de Tou Mu, de Feng-tu; referência de D&D à deusa da Estrela Polar. | `#6FD4FF` | `#F1FBFF` | `#273C8F` | luz de estrela fria, raios geométricos e pontos de constelação; preserva o azul-ciano já usado pela regra de raios. |
| **Selûne** | Em D&D: olhos cercados por sete estrelas; lua, estrelas, azul e prata. A SPEC já fixa azul-luar/prata. | `#8CCBFF` | `#EAF4FF` | `#355F94` | poeira lunar, sete pontos estelares e prata perolada; a implementação atual está alinhada. |

## Leitura da paleta atual

- **Manter sem mudança de direção:** Sendrinah, Lliira, Tou Um e Selûne. Só
  precisam da paleta expandida de primária, acento e contorno.
- **Ajustar na implementação delimitada:** Shar desloca a afinidade de altar
  para violeta/preto, preservando o vermelho abissal como identidade inicial
  de Kayron. Ghaunadaur usa verde dominante e violeta/malva nos efeitos.
- **Manter como contraste funcional:** Mask pode usar prata-fumaça para dano e
  efeitos, pois o símbolo preto oficial seria ilegível nos cenários do jogo.

## Implicações para o sistema de tema de combate

1. Substituir o mapa de uma única cor por uma paleta com `damage_primary`,
   `aura_accent`, `outline` e motivos de emissão.
2. Separar `HeroBaseTheme` de `DivineAffinityTheme`; os dados do herói seguem
   responsáveis pela identidade inicial e a afinidade escolhida pelo altar é
   uma sobreposição posterior.
3. Fazer buffs usarem a mesma estrutura de paleta, mas sem reescrever a
   definição canônica da deidade. Um buff pode dominar a emissão durante sua
   duração; ao expirar, volta à paleta divina ou base resolvida.
4. Reservar branco quase puro apenas para brilho/impacto, não para texto de
   dano contínuo; manter contorno escuro garante leitura em 1280×720.

## Decisões resolvidas pelo dono

1. Esta fase cobre somente divindades aplicadas como sobreposição; buffs não
   participam do tema de combate ainda.
2. Ghaunadaur é verde, com efeitos roxos.
3. Helion é um mago local, não uma divindade. Ele fica fora da matriz divina;
   sua paleta arcana poderá ser definida em um sistema próprio quando houver
   escopo aprovado.

## Fontes externas consultadas

- Regras Básicas oficiais de D&D 5e: a tabela de divindades de Forgotten Realms
  lista Mask, Lliira, Selûne e Shar e seus símbolos.
  https://www.dndbeyond.com/sources/dnd/basic-rules-2014/appendix-b-gods-of-the-multiverse
- Documento oficial espelhado das Regras Básicas, para a confirmação do símbolo
  de Mask como máscara preta.
  https://media.wizards.com/2015/downloads/dnd/BasicRules_Playerv3.4_PF.pdf
- Pesquisa de referência de Forgotten Realms para cores e iconografia legadas:
  Shar (púrpura/preto), Lliira (laranja/amarelo/vermelho), Selûne (azul/prata) e
  Ghaunadaur (verde/púrpura/preto, olho malva).
  https://forgottenrealms.fandom.com/wiki/Shar
  https://forgottenrealms.fandom.com/wiki/Lliira
  https://forgottenrealms.fandom.com/wiki/Sel%C3%BBne
  https://forgottenrealms.fandom.com/wiki/Ghaunadaur
- Referência legada de Feng-tu/Tou Mu como lar da deusa da Estrela Polar:
  https://files.spawningpool.net/docs/Vault2.0.-.TTRPG-Gamebooks/Dungeons%20%26%20Dragons%20%5Bmulti%5D/AD%26D%201e-2e%2C%20D%26D%2C%20OD%26D%20%28TSR%29/AD%26D%2C%20D%26D%20Adventures%20%26%20Settings/H4%20the%20Throne%20of%20Bloodstone%20%281e%29.pdf

As fontes externas são repertório e validação visual. O canon local de
Nottgard prevalece e nenhuma recomendação acima constitui alteração aprovada.
