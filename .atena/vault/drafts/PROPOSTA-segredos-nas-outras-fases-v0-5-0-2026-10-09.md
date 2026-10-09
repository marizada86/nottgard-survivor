---
id: PROPOSTA-segredos-v0-5-0
title: Segredos nas outras fases (v0.5.0) — escopo, pontos de interesse, relíquias e Ecos (portão de conteúdo do PLAN-083)
status: proposta aguardando decisão do dono; nada codificado
created: 2026-10-09
relations: ["[[SPEC-157-segredos-nas-outras-fases-v0-5-0]]", "[[SPEC-152-fatia-piloto-de-segredos-ecos-e-reliquias]]", "[[SPEC-119-segredos-ecos-e-mapa-maior]]", "[[EVID-147-auditoria-vault-x-jogo-2026-10-03]]"]
---

# Segredos nas outras seis fases

Base: o que a fatia piloto da 0.4.0 entregou em Shedaklah, Molor e Durao (mapa 84×84, 3 POIs, 4 Ecos, relíquia numa câmara selada, aba no Diário e conquista). Faltam seis fases. Textos abaixo são **paráfrase curta** do "Resumo canônico" das Sessões 17 a 19 do Vault (lidas em 2026-10-09) e dos ganchos do [EVID-147](../evidence/EVID-147-auditoria-vault-x-jogo-2026-10-03.md); nada de cânone do mestre, nem das proibições do EVID-147 §3 (Adam e o colar, fusão Durvall + Astherion, visão de Maelor, divindade adormecida das Docas, lore paralela dos Aetherion, Arco 02). O texto do Vault que cita "o amuleto do grupo" **não é usado** (toca o segredo do colar).

## 1. Escopo por fase (recomendação em negrito)

| Fase | Mapa | Segredos | Observação |
|---|---|---|---|
| **Feng-tu** | 60 → **84×84** | 3 POIs, 4 Ecos, relíquia | acontecimentos-chave já existem (escolta, peregrinação) |
| **Shendilavri** | 60 → **84×84** | 3 POIs, 4 Ecos, relíquia | "O convite" e as vítimas drenadas são as chaves |
| **Goranthis** | 60 → **84×84** | 3 POIs, 4 Ecos, relíquia nova (Espelho) | enigma das sete runas como chave |
| **Dagruve** | **fica 60×60** | 3 POIs, 4 Ecos, relíquia | SPEC-119: o início continua rápido; já tem cenário por dados |
| **Docas** | **fica 60×60** | 3 POIs, 4 Ecos, relíquia | idem; evitar a divindade adormecida |
| **Pilares** | **fica 60×60** (arena do modo infinito) | **fora da 0.5.0** | só há um gancho seguro e o resto toca o segredo da Síntese |

## 2. Relíquias (um item por fase, cópia garantida na câmara, como na 0.4.0)

| Fase | Relíquia | Origem no Vault | Chave (abre a câmara) |
|---|---|---|---|
| Dagruve | **Broche Celestial** (já existe) | corpo de guarda celestial com o broche (S7) | Ritual da névoa (`ritual_da_nevoa`) |
| Docas | **Colar dos Tentáculos** (já existe) | "Colar encontrado no navio das Docas" | Cais atacado (`cais_atacado`) |
| Feng-tu | **Sopro de Estrela** (já existe) | a concha que João entrega no templo (S18) | Escolta do peregrino (`escolta_do_peregrino`) |
| Shendilavri | **Cajado dos Desejos Sussurrantes** (já existe) | cajado amaldiçoado emprestado por Malcanthet (S18) | Vítimas drenadas (`vitimas_drenadas`; hoje opcional, passa a fixo) |
| Goranthis | **Espelho das Almas Desejantes** (**novo**) | guardado na sala de música do Castelo Argento (S19) | Do trono ao lodo (`do_trono_ao_lodo`) |

**Espelho das Almas Desejantes (novo):** pelo que o Vault registra (S19), "mostra o maior desejo". Proposta de números (rascunho, a medir): amuleto de tier 5, carisma +2 e sorte +3; **efeito opcional** `free_reroll_per_stage` (uma rerrolagem grátis por fase, como a SPEC-119 sugeriu): é pequeno, mas exige código novo; decisão sua.

## 3. Ecos, 4 por fase

### Feng-tu (fontes S17 e S18)

| Id | Texto (rascunho) | Fonte |
|---|---|---|
| eco_fen_1 | Feng-tu, o andar 300, é dominado por dois deuses: Tou Um, a deusa da Estrela do Norte, e Lu Yueh, o deus das epidemias. | S17 |
| eco_fen_2 | Um demônio passou por Feng-tu e desequilibrou tudo; Lu Yueh aproveitou para destruir o templo de Tou Um e tomar o andar. | S17 |
| eco_fen_3 | Na fé de Tou Um não se fala com a deusa: segue-se a estrela. Quem confia nela é curado, mas quem a segue por tempo demais acaba derrotado, no tempo dela. | S18 |
| eco_fen_4 | A estrela da peregrinação é uma miragem: não se aproxima, só se caminha atrás dela. | S18 |

Opcional: a runa achada no baú do templo "não é a que Vhaerith pediu" (S18), ponte para a cadeia da runa (ver §5).

### Shendilavri (fonte S18)

| Id | Texto (rascunho) | Fonte |
|---|---|---|
| eco_shn_1 | Shendilavri é o reino de Malcanthet, a Rainha das Súcubos: colinas de um lado, um oceano de pôr do sol eterno do outro, e a cidade murada de Rivenheart. | S18 |
| eco_shn_2 | Em Rivenheart quase todos são súcubos e íncubos, e há vítimas humanoides enfeitiçadas sendo drenadas até quase raquíticas. | S18 |
| eco_shn_3 | Na loja de itens mágicos de Rivenheart, os itens não tinham magia nenhuma. | S18 |
| eco_shn_4 | Malcanthet empresta duas guerreiras, as Irmãs Radiantes Nyxara e Vaelis, como guias, e revelam uma passagem pela masmorra até o Castelo Argento. | S18 |

### Goranthis (fonte S19)

| Id | Texto (rascunho) | Fonte |
|---|---|---|
| eco_gor_1 | Goranthis, a camada 597, é o verdadeiro Paraíso: o Rio Estige corre normalmente e há uma cachoeira altíssima. | S19 |
| eco_gor_2 | O castelo de Socothbenoth está em festa, com bebida e comida de graça e sem guardas, mas tudo é ilusão; para quebrá-la, é preciso tirá-lo do trono. | S19 |
| eco_gor_3 | Na sala de música do Castelo Argento, um mural indica a ordem das sete runas: a dor, a luta, a fúria que se acalma, a alegria da vitória, o conhecimento, a paz e a esperança. | S19 |
| eco_gor_4 | Uma luz prateada testa a intenção: a mente gananciosa é amaldiçoada com esquecimento, e a curiosidade genuína recebe inspiração. | S19 |

### Dagruve e Docas (ganchos do EVID-147; texto a escrever depois de ler a página do Vault)

| Fase | Ganchos | Fonte (EVID-147) |
|---|---|---|
| Dagruve | Capela abandonada do outro lado do cemitério; "Greenhold/Grimhold", o nome antigo do distrito; os Guardas Celestiais que foram à fratura e não voltaram | S7-19, S5, S9-37, S7-08 |
| Docas | Inscrição abissal junto ao porão ("Seremos um só" e o caixão de pedra); o navio abandonado com ritual autossustentável; Erik incendiou navios nas docas | S2, S13, S20 parte 2, S21 |

Os 8 Ecos de Dagruve e Docas só entram depois de eu ler cada página do Vault e conferir a etiqueta `conteudo-nao-revelado`: ficam como **rascunho pendente** nesta proposta.

## 4. Pontos de interesse (3 por fase, como na 0.4.0)

Ruína (2 Ecos e baú seguro), covil (elite dormente e baú de chefe) e câmara selada. Elites do covil: Feng-tu **Estátua do Templo**, Shendilavri **Guarda do Castelo**, Goranthis **Death Tyrant**, Dagruve **Cultista de Cajado**, Docas **Arch Hag**. Posições: as mesmas regras (dentro do mapa, em chão livre, a pé do início, até ~40 tiles do centro), sondadas com o chão de cada fase.

## 5. Segredo grande opcional: a runa de Vhaerith (cadeia entre runs)

Em Durao, Vhaerith pede uma runa; a de Feng-tu "não é a que ele pediu" (S18). Proposta: uma runa errada em Feng-tu, a certa escondida em Goranthis (câmara) e, **numa run seguinte**, levá-la a Durao: conquista, Eco final e um aprimoramento novo no Quartel. Exige estado entre runs no perfil e uma conquista nova. **Recomendação: ficar para a 0.6.0**, para a 0.5.0 não depender de duas runs encadeadas.

## 6. O que preciso de você (portão de conteúdo)

1. **Escopo:** as 5 fases recomendadas (Dagruve, Docas, Feng-tu, Shendilavri, Goranthis), Pilares fora, 84×84 só nas três de Abismo profundo.
2. **Relíquias** da tabela §2, incluindo o **Espelho** novo (com ou sem o efeito de rerrolagem).
3. **Ecos** de Feng-tu, Shendilavri e Goranthis como estão (12), e a leitura do Vault para os de Dagruve e Docas.
4. **Cadeia da runa de Vhaerith:** 0.6.0 (recomendado), agora ou nunca.
5. **Exclusividade das relíquias:** manter a cópia garantida sem retirar do sorteio (recomendado, como na 0.4.0).
6. **Tempo de execução:** começar já, ou **esperar o relato dos testers da 0.4.0** (recomendado: o que eles disserem sobre os mapas grandes e os Ecos decide se vale ampliar mais três mapas).

## 7. Ecos de Dagruve e Docas — rascunho (S-003, 2026-10-09; DRAFT, aguarda o dono)

Páginas lidas em 2026-10-09: `04_Locais/Dagruve.md` e `04_Locais/Docas.md`, ambas com a etiqueta `conteudo-nao-revelado`. Regra do EVID-147: nessas páginas só valem a **Base canônica** e as **consolidações aprovadas**. Dagruve tem o bloco "Consolidação aprovada — Sessões 01–09" (S7-08, S7-19, S7-26, S9-37), e é dele que saem os quatro Ecos. **Docas não tem bloco de consolidação aprovada**: só a Base canônica do prólogo (G-26) é inequívoca; os trechos das Sessões 02 e 13 estão na página, mas sem o marcador de aprovação. Os Ecos 2 a 4 abaixo dependem de você aceitá-los assim (ou trocá-los por Ecos da Base canônica).

Fora de uso, de propósito: "Adam irá salvá-los" (Dagruve, S3), a Sylas/Tarn além do que o bloco aprovado diz, Willie, a Profecia da Última Estrela, a divindade adormecida das criaturas aquáticas (S20 p2) e a fusão do EVID-147 §3. A Carta de Trégua (Grimhold) **não** é fundida a Greenhold, como a página manda.

### Dagruve

| Id | Onde | Texto (rascunho) | Fonte |
|---|---|---|---|
| eco_dag_1 | ruína (capela) | No cemitério de Dagruve, do outro lado do caminho das lápides, há uma capela abandonada. A névoa ali é a mais densa. | S7-19 |
| eco_dag_2 | ruína (capela) | Os Guardas Celestiais enviados ao último ponto de névoa não voltaram. Helion pediu que alguém fechasse a abertura. | S7-08 |
| eco_dag_3 | câmara | Perto da fratura, um portal leva a névoa de uma dimensão que contém só um santuário. O cão de caça chama essa fonte de "seu pulmão". | S7-26 |
| eco_dag_4 | destrutível | Os Grimholders dizem que, muito antes de existir Dagruve, "aqui era nosso": a cidade se chamava Grimhold. | S9-37 (nome corrigido pelo dono) |

### Docas

| Id | Onde | Texto (rascunho) | Fonte |
|---|---|---|---|
| eco_doc_1 | ruína | As Docas movem o comércio de Nottgard: manutenção de barcos, galpões de suprimentos e carroças para os outros distritos. Gilly é o conselheiro. | Base canônica (G-26) |
| eco_doc_2 | ruína | No porão de um galpão, junto a uma porta, uma inscrição abissal diz: "Seremos um só". | S2 (sem marcador) |
| eco_doc_3 | câmara | No porão havia um caixão de pedra vazio, alimentado por sangue que descia de uma abertura no andar de cima. | S2 (sem marcador) |
| eco_doc_4 | destrutível | Num navio abandonado, uma Arch-hag sustentava um ritual de invocação para trazer um Kraken. | S13 (sem marcador; redação corrigida pelo dono) |

### Decisões pedidas

1. Aprovar (ou ajustar) os 8 textos acima.
2. Docas: aceitar os Ecos 2 a 4 mesmo sem o marcador de consolidação aprovada, ou trocá-los por algo da Base canônica.
3. Os 12 Ecos de Feng-tu, Shendilavri e Goranthis (§3), as relíquias (§2) e o Espelho (com ou sem rerrolagem grátis) seguem pendentes do mesmo portão.

### Correções e aprovação do dono (2026-10-09)

- Não existem Greenhold nem Greenholders: só **Grimhold** e **Grimholders**. O Vault (`Dagruve.md`, S9-37) ainda grafa Greenhold/Greenholders; o texto do jogo segue o dono, e o Vault, somente leitura aqui, fica para ele corrigir.
- O eco_doc_4 passa a dizer que a **Arch-hag sustentava o ritual** que invocava o Kraken.
- "O restante está aprovado": os demais 6 textos de Dagruve e Docas (inclui os Ecos 2 a 4 de Docas sem marcador), os 12 Ecos da seção 3, as relíquias da seção 2 e o Espelho. **Pendente de esclarecimento:** o Espelho com ou sem rerrolagem (padrão registrado: sem).
