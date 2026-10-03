---
id: "EVID-147"
title: "Auditoria Vault × jogo: divergências, ganchos por fase e proibidos"
created: "2026-10-03"
relations: ["[[PLAN-055-mapas-vivos-segredos-e-dificuldade-2026-10-03]]", "[[SPEC-117-alma-e-historia-na-run]]", "[[SPEC-118-acontecimentos-exclusivos-por-fase]]", "[[SPEC-119-segredos-ecos-e-mapa-maior]]"]
sources: ["nottgard-vault/10_Sessões/Arco 01 (Sessões 15 a 24)", "nottgard-vault/04_Locais (Dagruve, Docas, Camadas do Plano Abissal)", "nottgard-vault/06_Itens", "nottgard-vault/07_Criaturas/A Síntese Abissal", "nottgard-vault/12_Lore/Pilares Ativos e Plano Abissal", "data/stage_story.json", "data/chronicles.json", "data/stages.json", "data/enemies.json", "data/items.json", "data/hqs.json"]
---

# EVID-147 — Auditoria Vault × jogo (PLAN-055 F1)

Feita na noite de 2026-10-03, só leitura (Vault em `F:\dev\nottgard-vault`).
Regra: o registro de sessão vale mais que a prosa derivada. Nada aqui foi
aplicado ao jogo.

## Resumo

- **Os textos do jogo estão fiéis.** Epígrafes (`stage_story`), crônicas
  (`chronicles`) e a HQ da Síntese conferem com as sessões; os segredos do
  mestre (colar/amuleto → Adam, fusão Durvall + Astherion) **não vazam** em
  nenhum texto de `data/`.
- **A divergência real está nos chefes e em alguns inimigos.** Em três fases o
  chefe do jogo é uma entidade com quem o grupo **negociou** ou que **nunca
  enfrentou**. Fica para decisão do dono, porque é adaptação legítima de jogo.
- **Há muito gancho não usado**, sobretudo das sessões 15 a 20: objetos, NPCs,
  enigmas e pequenos acontecimentos que viram eventos exclusivos (SPEC-118) e
  segredos (SPEC-119) sem inventar lore.
- **29 itens e documentos de `06_Itens` não existem no jogo** (lista no fim):
  matéria-prima pronta para "Ecos" e relíquias.

## 1. Divergências

| # | Onde no jogo | O jogo diz | O Vault registra | Peso | Sugestão |
|---|---|---|---|---|---|
| D-01 | Shedaklah, chefe `zuggtmoy` | Zuggtmoy é o chefe a derrotar | O grupo **negociou** com Zuggtmoy no palácio dela; ela pediu ajuda **contra Juiblex**. Quem atacou o grupo foram criaturas fúngicas do território de Juiblex (S15, S16) | **alto** | (a) manter Zuggtmoy como adaptação; (b) trocar por uma manifestação de Juiblex e fazer de Zuggtmoy uma **aliada** (evento "Pacto com Zuggtmoy"); (c) Zuggtmoy luta "corrompida pelo limo". Recomendo (b) ou (c) |
| D-02 | Shendilavri, chefe `malcanthet` | Malcanthet é a chefe | O grupo **foi contratado** por Malcanthet; quem a enfrentou foi **Graz'zt**, que arrancou o chifre dela com a mão (S18, S19) | médio | Manter (o jogo já usa "Chifre de Súcubo" como essência, o que combina com o chifre arrancado). Opcional: a apresentação do chefe citar o contrato traído |
| D-03 | Feng-tu, chefe `lu_yueh` | Lu Yueh é o chefe | O grupo **não enfrentou Lu Yueh**; enfrentou **O Discípulo Pestilento** no templo de Tou Um (S18). No jogo o Discípulo é só elite | médio | Trocar a ordem: Discípulo vira chefe da fase, Lu Yueh fica para a Profundidade (SPEC-120) ou para os Pilares |
| D-04 | Feng-tu e Shendilavri, inimigo `Fanático de Ghaunadaur` | Fanáticos de Ghaunadaur nessas fases | Em Feng-tu os cultistas são **de Lu Yueh**; Ghaunadaur aparece em Molor/Thullgrime (S17, S18). Nada liga Ghaunadaur a Rivenheart | baixo | Renomear o inimigo nessas fases ("Cultista de Lu Yueh", "Escravo enfeitiçado") ou trocar por outro já existente |
| D-05 | Shedaklah, elite `Receptáculo de Juiblex` | O receptáculo aparece em Shedaklah | O receptáculo ("backup" de Juiblex) foi enfrentado em **Thullgrime, Molor** (S17) | baixo | Tirar de Shedaklah; deixar em Molor (e Goranthis, onde Juiblex é a âncora) |
| D-06 | Durao, chefe `Molydeus, Carcereiro-Chefe` | Há um carcereiro-chefe | São **três Molydeus** carcereiros, sem hierarquia registrada (S16) | baixo | Renomear para "Molydeus, um dos três carcereiros" ou só "Molydeus" |
| D-07 | Goranthis, chefe `Socothbenoth, Âncora de Juiblex` | Socothbenoth é o chefe | A batalha final foi **contra Juiblex**, com Socothbenoth como âncora, e **com Graz'zt lutando ao lado do grupo** (S20 p1) | baixo | Manter; o subtítulo já diz "Âncora de Juiblex". Ver gancho G-GOR-4 (Graz'zt aliado) |
| D-08 | Docas, chefe `guardiao_verdadeiro` | Guardião Alado | Sem página no Vault (já registrado em SPEC-117, decisão pendente). Nas Docas o Vault tem: ritual do porão (S2), Arch-hag e Kraken no navio (S13) e criaturas aquáticas (S20 p2) | médio | Já pendente. A Arch-hag ou o Kraken seriam chefes fiéis; o Kraken **não morreu** (S21: arrastado pelo portal de Thalion), o que cabe num chefe que "foge" |
| D-09 | `chronicles.molor` | "o Rio Estige voltou a correr ali" | Correto para a S16. Na S17 o grupo volta a Molor e o rio está **gelatinoso de novo** | nenhum | Sem ação; anotar se um evento de Molor usar o rio |

Nada encontrado em `hero_bios`, `barks` e `hqs` que contradiga o Vault nas
amostras lidas; a revisão linha a linha das falas (H3) fica como pendência
pequena se o dono quiser.

## 2. Ganchos não usados, por fase

Formato: gancho → como vira jogo → fonte. "Evento" = SPEC-118; "Segredo" =
SPEC-119. Tudo é paráfrase do que foi registrado.

### Dagruve (já tem 2 eventos)
- G-DAG-1 Capela abandonada do outro lado do cemitério → **segredo** (POI com Eco) → S7-19.
- G-DAG-2 Moradores esqueléticos e desorientados na névoa que repetem "Adam irá salvá-los" → **evento** "Os que esperam": civis vagando; protegê-los dá bênção → S3. *Cuidado:* "Adam" só como nome que os moradores repetem (já usado na epígrafe).
- G-DAG-3 Greenhold/Grimhold, o nome antigo do distrito → **Eco** → S5, S9-37.
- G-DAG-4 Guardas Celestiais que não voltaram da fratura → **segredo**: corpo de guarda com o Broche Celestial → S7-08.

### Docas (já tem 3 eventos)
- G-DOC-1 Inscrição abissal "Seremos um só" e o caixão de pedra alimentado por sangue → **Eco** → S2.
- G-DOC-2 Navio abandonado com ritual autossustentável → **evento grande** (o navio ancora no meio da fase; destruir os focos antes da invocação) → S13; `12_Lore/Ritual de Invocação Autossustentável`.
- G-DOC-3 Erik incendiou navios nas docas → **evento** "Navios em chamas" (zona de fogo que fere todos) → S20 p2, S21.
- G-DOC-4 Diário de Willie, Jarra do Navio, Dispositivo das Docas → **Ecos/relíquia** → `06_Itens`.
- *Proibido:* a divindade adormecida das criaturas aquáticas (o Vault diz que só entra no próximo arco).

### Shedaklah (0 eventos hoje)
- G-SHE-1 **Arco de pedra que une os dois opostos**: cogumelo de Zuggtmoy + slime de Juiblex acendem as runas → **evento** "O portal sem vão": coletar 1 esporo e 1 limo e levar ao arco; abre um portal-atalho com recompensa → S16.
- G-SHE-2 **Pacto com Zuggtmoy**: guarnição de ~400 humanos e meio-orcs que a servem por escolha → **evento** "Guarnição fúngica": soldados aliados lutam 45 s → S15 (pede D-01).
- G-SHE-3 **O Reaper barqueiro**: em troca de ouro, conjura uma canoa para atravessar o Estige gelatinoso → **evento de risco** (paga moeda, atravessa para a outra margem com baú) → S15.
- G-SHE-4 Baixo-relevo humanoide incompleto no território de Juiblex → **segredo** → S15.
- G-SHE-5 O colar de retorno deixado no portal → **Eco** (sem revelar segredos do colar; só o fato de terem deixado) → S16.

### Molor (0 eventos)
- G-MOL-1 **Thullgrime**: cultistas carregam caixas de carne para sustentar a massa; quando atacados, cortam a própria garganta e o sangue desperta o receptáculo → **evento grande** "Ritual de estagnação": matar os carregadores antes que cheguem; cada um que chega fortalece o receptáculo → S17.
- G-MOL-2 Três gnolls demoníacos emboscam o descanso na caverna → **evento** "Emboscada na vigília" (elite triplo vindo de um lado só) → S17.
- G-MOL-3 Itens de Thullgrime (Lâmina da Digestão, Manto do Pântano, Anel da Resistência Abissal; os três **já existem** no jogo) → baú das barracas como **segredo** de Molor → S17.
- G-MOL-4 Diário do chefe dos cultistas ("ele partiu e nos deixou só com uma casca vazia") → **Eco** → S17, S18.

### Durao (0 eventos)
- G-DUR-1 **Desertores espiões** atrás de um morro → **evento** "Desertores": três NPCs fogem; o Molydeus os caça; protegê-los dá recompensa → S16.
- G-DUR-2 **Molydeus em patrulha**: fraco a radiante e necrótico → **evento** "Patrulha do carcereiro" (mini-chefe errante; reforça dano radiante) → S16.
- G-DUR-3 **Vhaerith Aetherion na jaula** pede uma runa para sair → **segredo encadeado**: a runa achada em Feng-tu "não é a que ele pediu" (S18). Encontrar a runa certa nas fases seguintes e voltar a Durao = relíquia → S16, S18.
- G-DUR-4 **Provação do Machado de Xar'gath**: arena de fogo, duelo 1×1 → **evento** "Arena do Testador" (círculo que prende o herói com um elite; vencer dá bênção); fala especial para Korrak → S16, S17.
- G-DUR-5 Acampamentos abandonados → POIs com baú → S16.

### Feng-tu (0 eventos)
- G-FEN-1 **João Barbosa** guia até o templo → **evento** "Escolta do peregrino" (NPC lento que segue a estrela) → S17.
- G-FEN-2 **Larvas com rosto de gente** que espalham epidemia ao toque e explodem em pestilência → **evento** "Enxame pestilento" → S17, S18.
- G-FEN-3 **A larva que vira gente e foge** (Kūkan Shito, uma cópia) → **segredo**: perseguir e pegar a larva que foge = Eco sobre Amatsu-Mikaboshi → S18.
- G-FEN-4 **Doença + peregrinação da estrela**: depois do Discípulo, o herói adoece; seguir a estrela (miragem que não se aproxima) cura → **evento** "Peregrinação": debuff que some ao andar X metros na direção da estrela → S18; `08_Eventos/Peregrinação da Estrela`.
- G-FEN-5 Runa no baú do templo (d6 = 5, **não é** a de Vhaerith) → elo da cadeia G-DUR-3 → S18.

### Shendilavri (0 eventos)
- G-SHN-1 **Loja de itens falsos** em Rivenheart → **evento de risco** "Mercador de Rivenheart": itens baratos; parte é ilusão sem efeito (o jogo já tem a regra de ilusões) → S18.
- G-SHN-2 **Convite de Malcanthet** → **evento** "O convite": aceitar = encantamento (controles trocados/lentidão por X s) e recompensa grande → S18.
- G-SHN-3 **Irmãs Radiantes (Nyxara e Vaelis)** como guias → **aliadas** temporárias → S18.
- G-SHN-4 **Passagem pela masmorra** até o Castelo Argento, aberta com sangue de Malcanthet ou de uma irmã → **segredo/área escondida** → S18.
- G-SHN-5 Vítimas enfeitiçadas drenadas → **evento de resgate** → S18.

### Goranthis (0 eventos)
- G-GOR-1 **Sala de música do Castelo Argento**: sete runas, ordem do mural (dor, luta, fúria que se acalma, alegria da vitória, conhecimento, paz, esperança) → **segredo-enigma**: ativar 7 pedras na ordem certa → Espelho das Almas Desejantes → S19.
- G-GOR-2 **Luz prateada que testa a intenção** (ganância → esquecimento; curiosidade → inspiração) → **evento**: escolher pegar o tesouro todo (maldição) ou só um item (bênção) → S19.
- G-GOR-3 **Festa ilusória** com tudo de graça → já parecido com a regra "Falso Paraíso"; reforçar com o texto → S19.
- G-GOR-4 **Graz'zt aliado**: o anel o invoca uma vez, ao dizer o nome três vezes → **ativo raro** ou evento de chefe (Graz'zt entra na luta contra Socothbenoth/Juiblex) → S19, S20 p1; `06_Itens/Anéis de Invocação de Graz'zt` (o item já existe no jogo).
- G-GOR-5 Tirar Socothbenoth do trono quebra a ilusão: paredes de carne → **mudança de mapa** no meio da fase → S19.

### Os Pilares (modo infinito)
- G-PIL-1 Castelo da Fome erguido como "elevador" (teste de Força ou cair) → **evento** periódico → `07_Criaturas/A Síntese Abissal`.
- G-PIL-2 Morro Zapomoni com metade da encosta apodrecida → cenário. *Cuidado:* a visão de Maelor (S17) mostra Adam, Astherion e Durvall juntos; **não usar** (toca no segredo da fusão).
- G-PIL-3 Ganchos do próximo arco (Mystralia, mãos e pilares, ameaça do mar) → **não usar** até o dono abrir o Arco 02.

## 3. Proibidos (só a referência)

| Tema | Por quê | Fonte |
|---|---|---|
| Colar/amuleto faz o portador virar Adam; amuleto é metade da Síntese | Cânone do mestre, segredo | memória do dono 2026-10-01; SPEC-117 |
| Fusão Durvall + Astherion como origem da Síntese | Segredo (Durvall é herói jogável) | `07_Criaturas/A Síntese Abissal` (o Vault registra; o jogo não revela) |
| Visão de Maelor com Adam, Astherion e Durvall (S17) | Expõe o elo do segredo acima | S17 |
| Divindade adormecida das criaturas aquáticas | Vault: só no próximo arco | `04_Locais/Docas` (S20 p2) |
| Lore paralela dos Aetherion (Luna, Vanimelda) | Tema pesado (suicídio de menor) e sem ligação com os heróis | S17 |
| Páginas com etiqueta `conteudo-nao-revelado` (Dagruve, Docas, Morro Zapomoni e outras 24) | Usar só "Base canônica" e consolidações aprovadas | grep no Vault |

## 4. Itens e documentos do Vault que o jogo não usa

Bons para **Ecos** (documento lido) ou **relíquias** (item): Carta de Trégua
de 1400, Carta do Cerco de Aluris, Carta de Bromnor para Brook, Um breve conto
sobre Bromnor do Martelo da Luz, Diário Vinculado de Bromnor, Diário de Willie,
Diário de Manutenção das Gárgulas, Diário do Chefe dos Cultistas de Thullgrime,
Diários dos Guardiões, Cadernos Vinculados de Helion, Papiro Diário (7-10-1690
e 11 de outubro), Relatório de Zynara sobre Elias, Bella e Kein, Livrinho,
Plantas do Túmulo, O Véu Rasgado, Espelho das Almas Desejantes, Wave of Terror,
Baralho de Muitas Coisas, Poção de Sopro de Fogo, Detector Arcano, Jarra do
Navio das Docas, Dispositivo das Docas, Dispositivo Antimagia de Gilly, Luz Mais
Pura de Thalion, Cajado da Família Infernum, Colar de visão verdadeira do
Santuário, Ateliê de Mystra. **Fora:** Colar de Ghaunadaur (toca no segredo).

Antes de usar cada um, ler a página e conferir a etiqueta
`conteudo-nao-revelado`.

## Limites

- Li inteiras as sessões 15 a 20 e a continuidade de 21, 23 e 24; das
  sessões 1 a 14 usei as páginas de local consolidadas. Ganchos de Dagruve e
  Docas podem crescer com uma leitura das sessões 3, 7, 8, 9 e 13.
- Divergência de chefe é escolha de design: listei, não decidi.
