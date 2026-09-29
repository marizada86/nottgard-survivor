# PLAN-001 — Nottgard Survivors (título de trabalho)

Status: **CANON — aprovado pelo dono em 2026-09-21** (aprovou todas as recomendações).
Data: 2026-09-21

## 1. Visão

Survivor-like **lento, legível e denso em conteúdo**, com visual sombrio e isométrico à la *Diablo II* / *Halls of Torment*, ambientado em Nottgard e centrado no **Plano Abissal**. **Sem história**: a lore entra só como sabor (nomes, descrições, bestiário, itens), nunca como narrativa ou spoiler.

Pilares:
1. **Ritmo Halls of Torment / Death Must Die** — dezenas de inimigos, não centenas; golpes com peso, telégrafos claros, elites e chefes que pedem posicionamento.
2. **Pouca poluição visual** — poucos efeitos por vez, números de dano discretos, paleta escura, névoa/vinheta. Legibilidade acima de espetáculo.
3. **Nottgard como banco de conteúdo** — personagens, cartas, equipamentos, inimigos, itens e locais vêm do Nottcard e do vault.
4. **Abismo como estrutura** — cada camada do Abismo é um bioma com regras próprias.
5. **Jogável cedo** — primeiro playtest antes de qualquer expansão de conteúdo.
6. **Laboratório de IA** — registrar (em `evidence/`) o que a IA fez bem/mal: geração de conteúdo, balanceamento por simulação, código.

## 2. Decisões já tomadas (respostas do dono, 2026-09-21)

| Tema | Decisão |
|---|---|
| Controle | **Alternável em opções**: (a) auto-ataque + mira no mouse; (b) auto-ataque total. Habilidades ativas em ambos. |
| Arte | **Placeholder + reaproveitar assets do Nottcard**; arte final entra por troca de `asset_id`, sem mexer em código. |
| Perspectiva | **Isométrico estilo Diablo II** já na fase 1. |
| Engine | Godot 4.7.2, GL Compatibility, GDScript (mesma do Nottcard). |

### Consequência técnica do isométrico (decisão de arquitetura)
Simular tudo em um **plano de chão plano** (x, y, top-down) e só **projetar para a tela** (2:1: `sx = (x − y)·w/2`, `sy = (x + y)·h/2`). Movimento, colisão, alcance, hitbox e mira ficam simples; o isométrico é só camada de render (Y-sort por profundidade, sombras, oclusão de props). Mira com mouse: inverter a projeção. Isso evita o custo clássico de colisão isométrica.

## 3. Regras herdadas do Nottcard (mapeamento)

Fonte: `games/godot/nottcard/data/core/*.json`, `core/*.gd`, vault. **Lore/fatos moram no vault**; este jogo guarda só decisões de mecânica em `.atena/vault/canon/`.

| Nottcard | Nottgard Survivors |
|---|---|
| 4 cores/atributos: Vermelho=Força, Amarelo=Inteligência, Azul=Constituição, Roxo=Carisma | 4 stats de build. Força→dano físico; Inteligência→dano/área mágica e cooldown; Constituição→PV/regeneração; Carisma→sorte, moedas, alcance de coleta |
| CA / CAM | **Armadura** (físico) e **Resistência mística** (mágico); armaduras já têm CA/CAM (Couro 1/0, Cota 3/−1, Placa 5/−3, Robe 0/2) |
| Cartas (ataque, reação, enfraquecer, localizar, atordoamento, cura, comunhão) | **Habilidades**. `enfraquecer` = debuff de armadura/CAM; `localizar` = marca (+dano); `atordoamento` = stun; `reação` = habilidade defensiva com gatilho; `cura` = "uso único" viram poções/relíquias |
| Poder Místico, Guarda, Corrente | Recursos de classe (Kayron: Poder; Brook: Guarda; Corrente = combo de acertos) |
| d20, crítico natural, falha crítica, Sorte | Chance de crítico/falha (pequena, em cascata), "usos de Sorte" = rerrolls de level-up |
| Armas (adaga, espada, maça, cajado, cetro) + armaduras | Slot de arma e armadura com identidade de golpe (ex.: adaga = rápida; maça = pode atordoar; cetro = marca) |
| XP, moedas, derrota mantém 50% do XP | Moedas por run; recusar o primeiro revive concede 30% da tentativa, e derrota após usar as ofertas mantém 50% |
| Upgrades (Força Bruta +4%, Vitalidade +2 PV, Mão Cheia, Rerrolagem, Sorte, Bolso Fundo, Ganância) | **Loja permanente do menu**, com os mesmos custos/curvas como ponto de partida |
| Conquistas com benefício (Dois Veteranos, Sorte de Sendrinah, O infeliz…) | Conquistas que **destravam bônus/personagens/itens** |
| HQ / QG | **Quartel** (hub em menu): loja, personagens, conquistas, códex |
| Eventos/salas aleatórias | Interações aleatórias no mapa (seção 6) |

## 4. Personagens

Jogáveis iniciais (atributos do Nottcard): **Durvall** (FOR16 INT14), **Brook França** (halfling, CON16 CAR14, paladino de Lliira; identidade visual definida por `CHARACTER-IDENTITY-003-brook-2026-09-29.md`), **Maelor** (CON16, devoto de Sendrinah, cura/localizar), **Sylas Malafaia** (INT16, devoto de Mask, controle/enfraquecer), **Kayron** (CAR14, aasimar, Poder Místico/radiante).
Desbloqueáveis por conquista: **Korrak** (Machado de Xar'gath), **Leoric** (Modo de Constelação), e depois NPCs de apoio como "heróis alternativos" (ex.: Nyrelia, Zynara, Bromnor) — a definir com o dono.
Cada herói tem: arma inicial, 1 habilidade de classe (as `class_ability` das cartas existentes), stats base, passiva.

## 5. Inimigos e chefes

**Já existem no Nottcard (com stats):** Cultista (adaga/cajado/arqueiro), Zumbi/Notívago, Slime corrosivo, Mímico, Criatura corrompida pela névoa, Guardião alado (cópia/verdadeiro), Sacerdote da Mente Derretida (invoca zumbis).
**Do vault, para criar:** Gárgulas da Biblioteca Corrompida, Arch-hag e tentáculos de Kraken (Docas), Molydeus (carcereiros de Durao), Reaper do Estige, Blogbog, Death Tyrant, Master of Cruelties, Shu, Ezro, Receptáculo de Juiblex, súcubos/ilusões de Rivenheart, fungos de Zuggtmoy, cultistas de Ghaunadaur.
**Chefe final / modo infinito:** **A Síntese Abissal** (resistência a físico/psíquico, só radiante fura → *diversidade de build obrigatória*).

Arquétipos de comportamento (poucos, bem distintos): perseguidor, atirador, investida telegrafada, invocador, área persistente, agarrador, kamikaze/slime que divide, elite com afixos.

## 6. Mapa e interações aleatórias

Mapa procedural por chunks dentro de um bioma; **inimigos por ondas pré-definidas** (tabela por minuto) + elites em pontos fixos do tempo.
Interações aleatórias: baú (ou **Mímico**), altar de divindade (bênção com custo — Sendrinah, Mask, Lliira, Shar, Ghaunadaur), poço/fonte, ritual de cultistas (elite + recompensa), **portal** (exige essência da camada → puxa para a camada seguinte), Rio Estige (rio de almas: risco/recompensa; a corrente só existe quando a água flui), mercador raro, "Baralho de Muitas Coisas" (evento aleatório de alto impacto).

## 7. Camadas do Abismo = biomas/fases

Progressão de fases (todas do vault, "Camadas do Plano Abissal"):
0. **Dagruve / Docas** (plano material) — tutorial/fase 1 do MVP: cultistas, zumbis, slimes, Arch-hag/Kraken.
1. **Shedaklah** — fungo (Zuggtmoy) × slime (Juiblex).
2. **Molor** — caverna de bolhas de slime; chefe **Blogbog**.
3. **Durao** — deserto árido, rio de almas gelatinoso pela passagem de **Juiblex**, jaula; **Molydeus**. O Estige está parado nesta fase, embora retenha seu risco mental.
4. **Feng-tu** — estética oriental (Tou Um, Lu Yueh).
5. **Shendilavri / Rivenheart** — súcubos, ilusões; Castelo Argento (Graz'zt).
6. **Goranthis** — "o verdadeiro Paraíso", cachoeira, ilusão; palco final.
7. **Pilares / Síntese Abissal** — endgame e modo infinito.

Cada camada: paleta, inimigos, regra ambiental própria (ex.: slime deixa poça; ilusão revela falsos inimigos; rio de almas pode empurrar quando flui; em Durao gelatinoso ele não empurra), 1 chefe, 1 tipo de essência.

## 8. Loop de run e progressão

- **Run**: 12–15 min por camada (MVP: 1 camada); level-up com **escolha de 3** (arma/habilidade, passiva, evolução); **evoluções** de arma combinando item + passiva (à Vampire Survivors; conecta com "Corrente" do Nottcard); chefe no fim.
- **Ritmo lento**: cooldowns longos, ataques com anticipation, teto de inimigos vivos baixo, sem chuva de projéteis.
- **Menu / meta**: loja (upgrades permanentes), seleção de herói, conquistas, códex (bestiário/itens desbloqueados — só sabor, sem spoilers), dificuldade/“Maldição” opcional.
- **Itens**: equipamento com raridade e afixos estilo Diablo II (mágico/raro/único). Únicos vêm do vault: Machado de Xar'gath, Martelo da Glória, Lâmina da Digestão, Chicote Avarento, Cajado dos Desejos Sussurrantes, Olho de Ghaunadaur, Colar dos Tentáculos, Anéis de Graz'zt, Manto do Pântano, Anel da Passagem Sombria, Sopro de Estrela, Ampulheta do Silêncio Eterno, Lasca de Ailalore, Luneta de Korrak, Broche Celestial, Amuleto da Luz etc. (vault `06_Itens`, filtrando o que for "canônico").

## 9. Referências de mecânicas a copiar

- **Halls of Torment**: auto-ataque, upgrades curtos por habilidade, campeões/elites, hub de progressão, ritmo lento, visual sombrio.
- **Death Must Die**: chefes de peso, bênçãos de divindades (→ nossos altares), builds com sinergia, telegrafia.
- **Vampire Survivors**: evoluções, passivas, baús, "maldição" de dificuldade.
- **Diablo II**: raridades/afixos, resistências por tipo, atmosfera, poções.

## 10. Arquitetura técnica

- Godot 4.7.2 (mesmo do Nottcard), estrutura `core/ ui/ data/ tests/ tools/ assets/`.
- **Data-driven**: heróis, inimigos, ondas, itens, habilidades, conquistas em JSON/Resource; conteúdo novo = dado novo.
- **Inimigos sem `RigidBody`**: movimento próprio + separação por spatial hash, pooling; meta de 300 entidades a 60 fps (mesmo com design para ~80 simultâneos).
- Simulação **determinística por seed** (RNG próprio), habilitando testes headless e **bots de balanceamento**.
- `asset_id` como ponte de arte (placeholder → definitivo).
- Save em JSON (perfil, upgrades, conquistas, códex).
- Testes: runner headless como `nottcard/tests/run_all.gd`; portão de aceite por spec.

## 11. Fases e specs (proposta)

| Fase | Entrega | Critério de aceite | Marco |
|---|---|---|---|
| F0 | Bootstrap Godot + estrutura + runner de teste | import headless ok, 0 falhas | — |
| F1 | Mundo isométrico (projeção, câmera, Y-sort), herói move (WASD), mapa tilado placeholder | anda por um chão isométrico a 60 fps | — |
| F2 | Combate: auto-ataque, 2 modos de mira, 1 habilidade ativa, dano/CA/CAM | Durvall mata inimigos parados/andando | — |
| F3 | Inimigos + ondas + XP + level-up (escolha de 3) | run de 5 min completável | **PLAYTEST 0** |
| F4 | Itens/equipamento, baús, interações aleatórias, poções | drop e equipar funcionando | — |
| F5 | Menu: loja permanente, seleção de herói, conquistas, save | progressão persiste entre runs | — |
| F6 | Fase 1 completa (Dagruve/Docas) + 1 chefe + 5 heróis | run de 12–15 min do início ao chefe | **PLAYTEST 1 (MVP)** |
| F7 | Camadas do Abismo 1–3, portais/essências, mais inimigos/itens/conquistas | 4 fases jogáveis | Playtest 2 |
| F8 | Camadas 4–6, Síntese Abissal, modo infinito, evoluções completas | jogo fechado | Playtest 3 |
| F9 | Polimento: áudio, VFX contidos, arte definitiva, balanceamento por bot | build exportável | — |

Cada fase vira uma `SPEC-00N` aprovada antes de implementar; evidências em `.atena/evidence/`.

## 12. Uso da IA como teste (registrar em evidence)

- Geração em lote de conteúdo **a partir do vault** (inimigos, itens, descrições) como draft → revisão do dono → canon.
- Bot de simulação headless para balancear ondas/dano (curva de morte por minuto).
- Agentes paralelos por área (dados, UI, testes), com relatório de acertos/erros.
- Geração de sprites/arte: pós-MVP, pipeline separado.

## 13. Riscos

| Risco | Mitigação |
|---|---|
| Arte isométrica não existe (assets do Nottcard são retratos/cenas, não sprites de 8 direções) | Placeholder por formas/sprites simples; `asset_id`; arte na F9 |
| Escopo de conteúdo explode | Data-driven + gate por fase; MVP só 1 camada |
| Isométrico complica mira/colisão | Simular no plano, projetar só no render |
| Balanceamento lento sem dados | Bot headless por seed |
| Spoiler/lore incerta | Só itens/locais com status canônico; sem narrativa |

## 14. Decisões finais (2026-09-21)

1. Nome: **Nottgard Survivors**.
2. Godot 4.7.2: extrair de `Downloads/Godot_v4.7.2-stable_win64.exe.zip`.
3. `git init` aprovado; **commits seguem exigindo aprovação explícita** (`add.yaml`).
4. **NPCs entram como heróis jogáveis** desbloqueáveis (Nyrelia, Zynara, Bromnor e outros), além de Korrak e Leoric. Lista final definida por conquista ao longo das fases F5–F8.
5. O vault é fonte para extração de conteúdo (sempre como draft → revisão → canon).

## 15. Mecânicas de aprofundamento aprovadas (2026-09-22)

O dono aprovou a implementação integral das recomendações de game design registradas nas SPEC-012 a SPEC-014:

1. habilidade ativa própria para cada herói;
2. level-up estruturado entre sinergia, defesa e nova direção;
3. escolha explícita entre extrair e descer, com risco e recompensa crescentes;
4. uma regra principal e legível por camada;
5. chefes com transições de fase em 70% e 35% de vida;
6. altares com consequências jogáveis além de modificadores numéricos;
7. itens únicos capazes de alterar comportamento, usando eventos limitados e sem recursão.

Implementação verificada em 2026-09-22 pelos testes automatizados, smoke das oito fases e bot determinístico. Evidência: `EVID-007-mecanicas-game-design.md`.

## 16. Regra global de geração de animações direcionais (2026-09-24)

Para cada novo herói, a produção de imagem deve criar somente cinco folhas de movimento: `move_n`, `move_ne`, `move_e`, `move_se` e `move_s`.
O runtime mantém as oito direções lógicas e obtém `move_nw` espelhando `move_ne`, `move_w` espelhando `move_e` e `move_sw` espelhando `move_se` horizontalmente.
`idle`, `attack`, `active` e `death` continuam folhas próprias: cada herói novo requer portanto nove sequências-fonte, não doze.

Folhas inversas já existentes são legadas válidas e não devem ser apagadas, mas não são requisito de geração nem são carregadas pelo runtime.
Não se espelha norte/sul; nem se aplica a regra a ataque, habilidade, morte ou idle.

## 17. Contrato durável de produção visual (2026-09-26)

1. IDs de dados e regras de jogo não mudam para acomodar uma imagem. A arte final
   é integrada pelo caminho e pelo `asset_id` previstos pelo consumidor.
2. Arquivos finais aprovados pertencem a `assets/` e são versionados com o
   projeto. Candidatas, matrizes e cópias de validação são material de trabalho;
   nunca substituem um final sem uma decisão registrada.

## 18. Contrato de revive e recompensa por derrota (2026-09-26)

Na primeira vez que os PV chegam a zero em uma run, o jogo interrompe a simulação
e oferece ao jogador reviver com 50% dos PV. Recusar encerra a tentativa e concede
30% das moedas da tentativa; essa taxa substitui a recompensa de derrota usual,
não se soma a ela. A melhoria permanente **Segunda Chance** acrescenta uma oferta
manual de revive à run, sem automatizar a escolha. Depois que todas as ofertas são
usadas, a morte encerra a run com a recompensa usual de 50%.
3. Antes da integração, cada folha ou imagem final deve passar pela verificação
   técnica aplicável: dimensões e grade previstas, RGBA/alfa real quando for
   sprite, leitura na escala de jogo e ausência dos artefatos proibidos.
4. A decisão de integrar uma candidata exige aprovação humana e evidência que
   vincule o asset, sua versão e a validação. O manifesto de produção registra
   cobertura operacional; ele não cria ou altera canon de personagens, lore ou
   mecânicas.

## 19. Retorno visual das escolhas divinas (2026-09-26)

Cada herói começa com a cor de sua identidade visual; Kayron inicia associado a
Shar em vermelho abissal e Maelor a Sendrinah em dourado. Uma escolha divina
altera a cor dos números de dano para a última divindade escolhida. A aura é
somente informativa, não existe no início e passa a existir somente após a
primeira bênção de altar; ela substitui, em vez de acumular, a afinidade visual
anterior. Selûne integra o conjunto de divindades disponíveis, com azul-luar e
prata.

**Decisão do dono — 2026-09-27.** A primeira entrega do tema de combate cobre
somente as divindades e funciona como uma sobreposição visual sobre a identidade
do herói: não há tema de buff nesta entrega. A paleta aprovada é Shar
violeta/preto (sem alterar o vermelho abissal inicial de Kayron), Sendrinah
dourado, Mask prata-fumaça/grafite, Lliira laranja/amarelo/vermelho,
Ghaunadaur verde com efeitos roxos, Tou Um azul de estrela/prata e Selûne
azul-luar/prata. Helion é um mago local, não uma divindade, e fica fora deste
sistema de afinidades divinas.

## 20. Dagruve e Docas como fases sequenciais (2026-09-27)

**CANON — aprovado pelo dono em 2026-09-27.** A antiga fase composta
"Dagruve / Docas" passa a ser duas fases jogáveis, sequenciais e distintas:

1. **Dagruve** — primeira fase, com duração-alvo de 8 minutos. Representa o
   distrito sob névoa, culto e rituais; seu chefe é o **Sacerdote da Mente
   Derretida**.
2. **Docas** — segunda fase, com duração-alvo de 10 minutos. Representa o
   porto, o cais, a fenda e o porão ritual da referência M1 de Nottcard; seu
   chefe é o **Guardião Alado Verdadeiro**.
3. **Shedaklah** passa a seguir Docas. As demais fases preservam suas
   identidades e avançam uma posição na ordem de progressão.

As duas fases regulares permanecem abaixo do teto temporário de 15 minutos.
Seus eventos ambientais precisam derivar de fatos canônicos e oferecer sinais
ambientais, aviso visível, telegráfo e janela de reação; não devem narrar ou
revelar fatos não estabelecidos. O jogador pode testar esses eventos, chefes e
suas fases por um Navegador de Cenários disponível somente na build de
desenvolvimento, em sandbox que preserve o save real. O cenário inicia alguns
segundos antes do gatilho e permite escolher herói, nível, armas, itens e seed.

Esta decisão substitui a composição única descrita na seção 7 e o recorte de
uma única fase/chefe do marco F6; ela não aprova arte nova, publicação ou
alteração de lore além da separação e da alocação de chefes acima.

## 21. Shedaklah e os dois braços do Estige (2026-09-27)

**CANON — aprovado pelo dono em 2026-09-27.** Shedaklah, o Andar 222, é um
pântano fúngico disputado por Zuggtmoy e Juiblex, situado entre **dois braços
lentos do Rio Estige**. O terreno jogável permanece predominantemente fúngico:
solo compacto escuro, micélio e pedra arroxeada, com slime de Juiblex em
manchas locais. Os dois braços aparecem nas bordas opostas da arena, com
margens orgânicas legíveis, e não convertem a arena em uma caverna de slime.

Nesta fase, o Estige é uma macroforma visual e um limite de composição, sem
fluxo, empurrão, teste de lucidez, Chamado ou buff. Esses riscos continuam
exclusivos de Durao, onde a passagem de Juiblex o tornou gelatinoso e imóvel.
O piso, os decais e os props devem preservar a leitura de herói, inimigos,
itens e telegráfos em 1280×720. Esta decisão substitui, somente para
Shedaklah, o não objetivo de extensão do Estige presente na SPEC-039.

## 22. Shendilavri e o braço visual do Estige (2026-09-27)

**CANON — aprovado pelo dono em 2026-09-27.** Shendilavri / Rivenheart, a
Camada 570 de Malcanthet, recebe um **único braço do Rio Estige** nas margens
da arena. Ele ecoa a referência planar de uma ramificação vinda de Pazunia,
mas não domina o salão refinado de mármore violeta, cristais e ilusões.

O braço é uma macroforma visual: água calma e escura, margem de mármore
legível e nenhum fluxo, empurrão, Teste de Lucidez, Esquecimento, Chamado,
buff ou regra hídrica. A regra ambiental da camada continua exclusivamente
`illusions`. O piso, os decais e os props devem preservar a leitura de herói,
inimigos, itens e telegráfos em 1280×720. Esta decisão não altera ondas,
chefe, duração, colisão, recompensas ou os comportamentos de Durao.

## 23. Goranthis e a queda visual do Estige (2026-09-27)

**CANON — aprovado pelo dono em 2026-09-27.** Goranthis, a Camada 597 e o
“verdadeiro Paraíso” de Socothbenoth, recebe nas margens a **queda colossal do
Rio Estige**. Ela enquadra os terraços claros, o mármore pérola, os santuários
e as cachoeiras da camada sem ocupar a arena central.

A queda é uma macroforma visual e periférica: água luminosa e impossível,
margem legível e nenhum fluxo, empurrão, Teste de Lucidez, Esquecimento,
Chamado, buff ou regra hídrica. As regras da camada continuam `sanctuary`,
`illusions` e `puddles`. Esta decisão não altera ondas, chefe, duração,
colisão, recompensas, sementes ou os comportamentos de Durao.

## 24. Contrato universal do Estige (2026-09-27)

**CANON — aprovado pelo dono em 2026-09-27, pelo PLAN-023.** Todo andar
jogável — Dagruve, Docas de Nottgard, Shedaklah, Molor, Durao, Feng-tu,
Shendilavri, Goranthis e Pilares — contém uma zona marginal, acessível e
determinística do Rio Estige. Em todos eles a água é gelatinosa, imóvel e
atravessável; aplica o mesmo Teste de Lucidez por INT/CAM, Esquecimento ao
sair, Chamado por exposição prolongada, derrota no limiar e imbuimento
temporário de raros. O Estige nunca empurra o jogador, inimigos, itens ou
projéteis.

O contrato é uma única camada ambiental compartilhada, executada em paralelo à
regra principal de cada andar. Portanto, rituais, poças, bolhas, raios,
ilusões, santuários e a rotação dos Pilares permanecem distintos e ativos.
Os canais não podem cobrir ponto inicial, rotas essenciais, portal,
telegráficos ou arena de chefe.

Esta decisão substitui as limitações incompatíveis das seções 21, 22 e 23,
bem como os limites operacionais de Estige apenas visual/ausente registrados
nos planos de terreno e nos registros de ativo 011 a 016. Esses documentos
permanecem como histórico de aprovação de seus atlas; sua restrição de
comportamento do rio não é mais vigente.

## 25. Correção fiel do Rio Estige (2026-09-27)

**CANON — aprovado pelo dono em 2026-09-27, pelo PLAN-027 e SPEC-055.** A
seção 24 está supersedida. O Rio Estige funcional aparece somente onde há
presença documentada na campanha: **Shedaklah** (dois braços lentos),
**Durão** (canal lento junto aos cais), **Shendilavri** (afluente marginal) e
**Goranthis** (queda e bacia marginal). Dagruve, Docas, Molor, Feng-tu e
Pilares não recebem rio nem contrato ambiental do Estige.

O único efeito jogável comum é a tradução já aprovada de perda de memória: ao
entrar e a cada segundo completo, Teste de Lucidez `d20 + mod. INT +
max(0, CAM - 10)` contra CDs 11–16. Cada falha reduz apenas a Inteligência
efetiva da run, com piso 1. Após dois ou mais segundos e ao sair da água,
**Esquecimento** impede aproximar-se do rio por `min(segundos completos, 6)`
segundos. Não altera perfil, desbloqueios, itens ou ficha persistente.

Gelatina de Juiblex, Chamado, derrota por exposição, bônus de raros e empurrão
não são propriedades deste rio e não fazem parte do jogo. As regras próprias
dos quatro andares continuam em paralelo; a corrente rotativa dos Pilares é
uma mecânica autoral separada. PLAN-023, SPEC-054 e EVID-084 permanecem como
histórico de uma implementação corrigida, não como intenção vigente.
