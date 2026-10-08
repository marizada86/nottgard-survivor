---
id: PROPOSTA-ecos-v0-4-0
title: Ecos, pontos de interesse e relíquias da fatia piloto (Shedaklah, Molor, Durao) — portão de conteúdo do PLAN-081 B-006 S-017
status: proposta aguardando aprovação do dono; nada codificado
created: 2026-10-08
relations: ["[[SPEC-148-lancamento-da-v0-4-0]]", "[[SPEC-119-segredos-ecos-e-mapa-maior]]", "[[EVID-147-auditoria-vault-x-jogo-2026-10-03]]"]
---

# Fatia piloto do MEC-039: Ecos, POIs e relíquias

Escopo aprovado em 2026-10-08: Shedaklah, Molor e Durao, mapa 84×84 só nelas, Ecos, pontos de interesse (POIs), aba "Ecos" no Diário e **1 relíquia por fase**. Base: [SPEC-119](../specs/SPEC-119-segredos-ecos-e-mapa-maior.md).

**Regras que segui:** todo texto é **paráfrase curta** do "Resumo canônico" das Sessões 15, 16 e 17 do Vault (`10_Sessões/Arco 01`), com `fonte_vault`. Nada de "cânone do mestre", nada da lista de proibidos do EVID-147 §3 (Adam e o colar de Adam, fusão Durvall + Astherion, visão de Maelor, divindade adormecida das Docas, lore paralela dos Aetherion, ganchos do Arco 02) e nenhuma página com etiqueta `conteudo-nao-revelado`. Cada Eco tem 1 a 3 frases e cabe numa pausa de até 2 s; o texto vai inteiro para o Diário.

## 1. Mapa e pontos de interesse (3 por fase)

Mapa 84×84, centro (42, 42) continua arena aberta; POIs nas bordas, a no máximo ~12 s de caminhada do centro. Posições de partida (rascunho; ajustadas ao chão de cada fase):

| Fase | Ruína (2 Ecos + baú comum) | Câmara selada (relíquia) | Covil (elite opcional + baú melhor) |
|---|---|---|---|
| Shedaklah | bosque fúngico, ~(12, 66) | junto ao arco de pedra, ~(70, 14) | poço de lodo, ~(68, 68), guarda a Gárgula |
| Molor | gruta de estalactites, ~(40, 10) | barracas de Thullgrime, ~(12, 40) | ninho de parasitas, ~(72, 44), guarda o Pudim Negro |
| Durao | acampamento abandonado, ~(14, 70) | perto da jaula, ~(14, 18) | ossuário, ~(72, 62), guarda o Carcereiro de Pedra |

Os outros 2 Ecos de cada fase ficam: 1 no sítio do acontecimento-chave e 1 atrás de um destrutível. Posição fixa por fase, sem consumir a RNG da batalha.

## 2. Ecos (4 por fase; 12 no total)

| Id | Fase | Texto do Eco (rascunho) | Fonte no Vault | Onde fica |
|---|---|---|---|---|
| eco_she_1 | Shedaklah | Zuggtmoy não pode deixar o seu domínio. Cerca de quatrocentos, entre humanos e meio-orcs, a servem por escolha. | S15 | ruína |
| eco_she_2 | Shedaklah | Um Reaper conjura canoas em troca de ouro para cruzar o Rio Estige, hoje solidificado como gelatina. | S15 | ruína |
| eco_she_3 | Shedaklah | Para abrir o arco de pedra é preciso unir os dois opostos da camada: o fungo de Zuggtmoy e o limo de Juiblex. | S16 | sítio de "O portal sem vão" |
| eco_she_4 | Shedaklah | Um baixo-relevo humanoide, incompleto, marca o território coberto de limo de Juiblex. | S15 | atrás de um destrutível |
| eco_mol_1 | Molor | Em Thullgrime só vivem cultistas de Ghaunadaur. Carregam caixas de carne e falam "daquele que está aqui, mas não está". | S17 | ruína |
| eco_mol_2 | Molor | O ritual de Thullgrime não cria a massa de carne: serve para sustentá-la. | S17 | ruína |
| eco_mol_3 | Molor | O diário do chefe dos cultistas registra o ritual de estagnação do rio: "ele partiu e nos deixou só com uma casca vazia". | S17 (diário) | sítio de "O diário do chefe" |
| eco_mol_4 | Molor | O núcleo verde dentro do chefe é parte de Juiblex: um só ser dividido em muitos. As criaturas mortas também eram ele. | S16 | atrás de um destrutível |
| eco_dur_1 | Durao | A guerra daquele andar acabou, e ninguém sabe quem venceu. O andar inteiro desertou. | S16 | ruína |
| eco_dur_2 | Durao | Restam três Molydeus como carcereiros. Prendem desertores numa jaula imensa e são fracos a dano radiante e necrótico. | S16 | ruína |
| eco_dur_3 | Durao | Na jaula, o elfo Vhaerith Aetherion oferece o próprio sangue ao portal e pede, em troca, uma runa para poder sair. | S16 | sítio da jaula |
| eco_dur_4 | Durao | O machado de Xar'gath guarda a alma de um demônio e exige provações. A primeira é um duelo numa arena de fogo. | S16 | atrás de um destrutível |

**Opcionais, só se você quiser:** `eco_she_5` "O grupo deixou o colar de retorno no portal de Shedaklah" (S16; o EVID-147 admite o fato sem o que o colar é) e `eco_mol_5` "Molor é uma caverna fechada de bolhas de slime que crescem e explodem" (S16). Fora: tudo o que toca o segredo do mestre.

## 3. Relíquias (1 por fase)

Cada relíquia é um **único que já existe** no jogo, ligado à lore da fase, num baú de **câmara selada**, com o selo "Relíquia" no nome do evento. Ficam também no sorteio normal (não mexo nas tabelas de drop de outras fases); a câmara é a cópia **garantida**.

| Fase | Relíquia | Por que | Chave (abre a câmara) |
|---|---|---|---|
| Shedaklah | **Manto do Pântano** (CA +2, CAM +2, imune a poças) | "Imune ao ácido dos limos": é o item da fase dos limos | Concluir "O portal sem vão" (levar esporo e limo ao arco) |
| Molor | **Lâmina da Digestão** ou **Anel da Resistência Abissal** (sorteio) | Itens achados nas barracas de Thullgrime (S17) | Impedir o "Ritual de estagnação" |
| Durao | **Machado de Xar'gath** | Recolhido perto da jaula de Durao (S16) | Vencer a "Arena do Testador" |

Observações: (a) a SPEC-119 pedia relíquia "não sai em baú comum"; para não desmontar as tabelas de drop de todas as fases a relíquia aqui é uma cópia garantida, sem retirar o item do sorteio. Se preferir exclusividade, é uma segunda mudança (afeta o drop em todo o jogo). (b) A "Arena do Testador" é do pool opcional (sorteia 1 ou 2); para a câmara não ficar trancada, o evento-chave passa a ser sempre sorteado em Durao enquanto a relíquia estiver pendente (detalhe da SPEC-152). (c) **A cadeia da runa de Vhaerith** (Durao → Feng-tu → Shendilavri/Goranthis) **não entra**: atravessa fases fora da fatia piloto.

## 4. Conquista e Quartel

Aba "Ecos" no Diário do Quartel, por fase: "Ecos 3/4 · Relíquia ✓". Concluir os quatro Ecos e a relíquia de uma fase dá uma conquista e moedas (valor a medir; acompanha a economia da BAL-023). Pista: Eco a até 6 tiles brilha de leve; contador "Ecos 1/4" na HUD só depois do primeiro achado.

## 5. O que preciso de você

1. **Os 12 Ecos** como estão, ou troca/corte de algum (e os 2 opcionais: sim ou não).
2. **As 3 relíquias** como propostas, incluindo a cópia garantida sem exclusividade (recomendado), e o sorteio entre Lâmina e Anel em Molor.
3. **Chaves** das câmaras (portal, ritual, arena) e o evento-chave de Durao sempre presente.
4. **84×84** nas 3 fases. Plano B: se o desempenho cair de 60 fps de forma visível no `.exe`, a fatia reduz para 72×72 sem nova consulta.

Se aprovado: SPEC-152 (mapas, POIs, Ecos, relíquias, aba do Diário) → testes de mapa e de dados (`fonte_vault` e lista de termos proibidos) → um commit por mecânica.
