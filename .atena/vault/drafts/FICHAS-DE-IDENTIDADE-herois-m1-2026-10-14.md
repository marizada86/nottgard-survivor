---
id: FICHAS-IDENTIDADE-M1
title: Fichas de identidade dos 12 heróis para refazer as tiras (SPEC-176, S-002)
status: DRAFT r1 em 2026-10-14; aguarda revisão do dono no portão G-D1
content_state: DRAFT
spec: SPEC-176
plan: PLAN-103
sources: ["data/heroes.json", "data/hero_bios.json", "assets/animations/heroes/<herói>/idle.png", "F:\\dev\\nottgard-vault\\02_Personagens e 03_NPCs (somente leitura)", "F:\\dev\\nottcard\\assets\\portraits (somente leitura)", "CHARACTER-IDENTITY-003, ASSET-APPROVAL-REGISTER-005/010/017/018"]
---

# Fichas de identidade dos heróis (M1)

Cada ficha diz **o que a arte nova precisa preservar**. Ela não inventa lore, não revela "cânone do mestre" e não altera nenhuma decisão aprovada. A coluna **Fonte** de cada traço diz de onde veio: `idle` (o sprite atual), `vault`, `nottcard` ou `canon` (registro aprovado pelo dono).

Convenção de lado: "lado da tela" é o lado do **quadro** em que o objeto aparece no `idle` atual (herói de frente em três-quartos). Não afirma mão direita ou esquerda do personagem. O Vault não registra lateralidade de nenhum herói; o lado vem do sprite e vale como decisão de arte, para o espelho não trocar a arma de mão.

## Pontos para decisão do dono (G-D1)

| # | Ponto | Situação | Recomendação |
|---|---|---|---|
| P1 | **Kayron: sprite × Nottcard × Vault** | Sprite: cabelo branco, armadura negra laminada e capa roxa rasgada, **sem asas**. Nottcard: **grandes asas negras e vermelhas**, olhos vermelhos, casaco branco com faixa vermelha. Vault: "asas brancas se manifestaram" (episódio da infância). Três versões diferentes | Manter o **sprite atual** (aprovado e já em jogo) e **não** pôr asas nas tiras; confirmar que a divergência com o Nottcard é aceita |
| P2 | **Brook: referência canônica ausente** | `CHARACTER-IDENTITY-003` exige `reference-staging/brook-canonical-2026-09-29.png` como base de todo asset. **O arquivo não está no repositório** (busca em `.atena/` e na árvore). O retrato do Nottcard é o legado (anão, martelo, escudo azul), superado | Dono reenvia a imagem canônica; até lá a ficha usa as invariantes escritas do registro 003 e o idle atual |
| P3 | **Leoric: chapéu e cristal** | Canon (registro 018, 2026-09-29): **cartola preta com faixa marrom** e sobretudo marrom; cajado com cristal azul. O Nottcard mostra chapéu de mago pontudo e cristal âmbar | Manter o canon (cartola, cristal azul); divergência com o Nottcard já decidida |
| P4 | **Nyrelia: rosto** | Idle: capuz e **máscara escura sem rosto visível**. Vault: "usa máscara e sua espécie não foi estabelecida". Não há retrato no Nottcard | Manter rosto oculto; nenhum rosto é inventado |
| P5 | **Grimholders × Greenholders** | O jogo (`hero_bios.json`) escreve **Grimholders** para Arlindo, Erik e Nyrelia; as fichas do Vault (03_NPCs) escrevem **Greenholders**; alguns dossiês do Vault usam Grimholders | Não afeta a arte. Decidir o nome oficial antes de qualquer texto novo (vault vale mais que o Nottcard) |
| P6 | **Erik: cicatriz** | O retrato do Nottcard mostra cicatriz na testa e antebraço enfaixado; o sprite não os mostra na escala de jogo | Opcional; só entra se o dono pedir (custa legibilidade a 64 px) |
| P7 | **Imagens de referência do dono (D16)** | Ainda não entregues | Pasta `.atena/generated/m1-movimento/refs/<herói>/` |

## Proporções em jogo (medidas em 2026-10-14, `reguas.csv`)

| Herói | Altura em tela | Arte do idle | Célula | Escala | Base (y) |
|---|---:|---:|---|---:|---:|
| Korrak | 76 px | 267 | 256×384 | 0,285 | 350 |
| Kayron | 66 px | 316 | 256×384 | 0,209 | 376 |
| Sylas | 64 px | 304 | 256×384 | 0,211 | 376 |
| Maelor | 64 px | 299 | 256×384 | 0,214 | 364 |
| Erik | 64 px | 300 | 512×512 | 0,213 | 448 |
| Nyrelia | 62 px | 352 | 256×384 | 0,176 | 368 |
| Arlindo | 62 px | 290 | 512×512 | 0,214 | 448 |
| Durvall | 60 px | 231 | 256×384 | 0,260 | 376 |
| Zynara | 60 px | 368 | 256×384 | 0,163 | 376 |
| Bromnor | 48 px | 241 | 256×384 | 0,199 | 364 |
| Brook | 40 px | 259 | 256×384 | 0,154 | 368 |
| Leoric | 40 px | 224 | 256×384 | 0,179 | 368 |

---

## 1. Durvall

| Campo | Conteúdo | Fonte |
|---|---|---|
| Quem é | Drow, Durvall Gellad; receptáculo (título no jogo "Drow · Receptáculo"); capitão do 3º Batalhão de Thalion | vault, `heroes.json` |
| Traços fixos | Cabelo **branco longo** e solto; pele cinza-azulada; orelhas pontudas com tom avermelhado; rosto severo | vault, idle, nottcard |
| Roupa e armadura | **Armadura negra laminada**, ombreiras com espinhos, faixa/cinto vinho, pendente azul no peito, botas negras de ponteira | idle, nottcard |
| Arma | Espada de **lâmina azul-gelo luminosa**, no lado direito da tela; cabo escuro | idle |
| Paleta | Negro-azulado, branco-prata, vinho, azul-gelo (`color` [60,60,80], `hair` [230,230,240]) | `heroes.json`, idle |
| Divindade e bioma | Ghaunadaur é do **conjunto do jogo**; não aparece símbolo dela na arte; origem Docas e Dagruve | vault |
| Não pode | Trocar a cor do cabelo; tirar a lâmina azul; incluir símbolo ou aura de divindade; usar o "colar" do cânone do mestre | decisão |
| Referências | idle; retrato Nottcard (capa vinho, energia azul); registro 002 (aprovado em 2026-09-27) | — |

## 2. Brook França

| Campo | Conteúdo | Fonte |
|---|---|---|
| Quem é | **Halfling** paladino de Lliira, Fateridge; afilhado de Bromnor; entende língua de sinais | vault, canon 003 |
| Traços fixos | Corpo **baixo e compacto**; rosto maduro e determinado; **cabelo branco penteado para trás**; barba branca curta; orelhas pontudas | canon 003, idle |
| Roupa e armadura | **Armadura escura robusta** de aço gasto, detalhes dourados **muito discretos**, **capa escura** (no idle: vermelho-escuro com borda dourada) | canon 003, idle |
| Arma | **Maça de espinhos**, no lado esquerdo da tela, cabeça para baixo | canon 003, idle |
| Paleta | Aço envelhecido, vinho/escuro, ouro discreto (`color` [180,170,90]) | canon 003 |
| Divindade e bioma | Lliira: radiante contido; sem auréola, asas, brilho excessivo ou pose régia | canon 003 |
| Não pode | Alto ou "humano adulto"; martelo ou escudo azul (é o legado superado) | canon 003 |
| Referências | **Pendente (P2)**: `brook-canonical-2026-09-29.png`; idle atual regenerado em 2026-09-29 (registro 017) | — |

## 3. Maelor

| Campo | Conteúdo | Fonte |
|---|---|---|
| Quem é | Devoto de Sendrinah, parceiro de investigação de Sylas; filho de Marciela e Aranis Vellen | vault |
| Traços fixos | Humano jovem, cabelo **castanho-dourado** desgrenhado, expressão atenta, barba rala | idle, nottcard |
| Roupa e armadura | Casaco claro com golas marrons, **capa azul-marinho com bordas douradas**, cinto com **bolsas e frascos azuis**, calça escura, botas marrons com fivelas, medalhão dourado de estrela | idle, nottcard |
| Arma | **Chama azul** conjurada na palma, no lado esquerdo da tela; a outra mão estendida para o lado oposto | idle |
| Paleta | Marfim, azul-marinho, marrom, dourado, azul-gelo (`color` [80,130,190]) | idle |
| Divindade e bioma | Sendrinah, dourado | `heroes.json` |
| Não pode | Trocar a mão que conjura; apagar os frascos e as bolsas (leitura de silhueta) | decisão |
| Referências | idle; retrato Nottcard (medalhão de estrela, mão aberta com luz) | — |

## 4. Sylas Malafaia

| Campo | Conteúdo | Fonte |
|---|---|---|
| Quem é | Tiefling devoto de Mask, antes humano; usa máscara desde que Nyrelia o libertou | vault |
| Traços fixos | **Dois chifres curvos** para cima; capuz; **máscara de bico** escura com olhos violeta; silhueta alta e fechada | idle, nottcard |
| Roupa e armadura | Armadura negra com **detalhes violeta**, faixa central roxa, capa roxa rasgada, colar com pedra violeta, ombreiras | idle |
| Arma | **Adaga violeta**, no lado esquerdo da tela, apontada para baixo | idle |
| Paleta | Negro, roxo, violeta (`color` [120,50,110]) | idle |
| Divindade e bioma | Mask; sombra | `heroes.json` |
| Não pode | Remover os chifres ou a máscara de bico | decisão |
| Referências | idle; retrato Nottcard (olhos violeta, mão com chama roxa) | — |

## 5. Kayron Lioran

| Campo | Conteúdo | Fonte |
|---|---|---|
| Quem é | Aasimar, leitor abissal; serve a Zynara; ligado a Shar | vault |
| Traços fixos | Cabelo **branco-prateado curto e desgrenhado**; olhos claros; rosto jovem e sério | idle, nottcard |
| Roupa e armadura | **Armadura negra laminada** com fivelas, capa **roxa rasgada**, pano roxo no pescoço, faixa central escura com emblema | idle |
| Arma | **Descarga Estelar** (magia); sem arma de mão visível no idle | `heroes.json`, idle |
| Paleta | Negro, roxo, branco-prateado (`color` [200,200,230]) | idle |
| Divindade e bioma | Shar, violeta e preto; vermelho abissal inicial de Kayron (PLAN-001 §19) | canon |
| Não pode | Incluir asas sem decisão (**P1**); mudar o cabelo para escuro | decisão |
| Referências | idle; Nottcard (divergente, P1) | — |

## 6. Korrak Nammat

| Campo | Conteúdo | Fonte |
|---|---|---|
| Quem é | Goliath que empunha o Machado de Xar'gath | vault, `heroes.json` |
| Traços fixos | **Pele cinza**, corpo muito largo e musculoso; cabelo **raspado em crista**; **barba escura** cheia; olhar fechado | idle, nottcard |
| Roupa e armadura | **Pele de fera marrom** nos ombros, **ombreira com espinhos**, peitoral de couro com cintos, braçadeiras e joelheiras de metal gasto | idle, nottcard |
| Arma | **Machado duplo de lâmina escura com rachaduras de lava**, nas duas mãos, cabeça no lado direito da tela | idle |
| Paleta | Marrom, cinza, vermelho-lava (`color` [130,130,130]) | idle |
| Divindade e bioma | Xar'gath | `heroes.json` |
| Não pode | Cortar o machado na borda (defeito já visto); trocar o lado da cabeça da arma ao espelhar | BUG-025 |
| Referências | idle; retrato Nottcard (duas armas às costas) | — |

## 7. Leoric

| Campo | Conteúdo | Fonte |
|---|---|---|
| Quem é | Gnomo; Modo de Constelação; resiste a Ghaunadaur | vault |
| Traços fixos | **Gnomo adulto baixo e compacto**; **barba grisalha volumosa**; orelhas pontudas; olhar de lado, carrancudo | idle, canon 018 |
| Roupa e armadura | **Cartola preta com faixa marrom**; **sobretudo marrom** aberto sobre colete escuro, cinto com bolsos, livro na cintura, botas marrons | canon 018, idle |
| Arma | **Cajado retorcido de madeira com cristal azul**, no lado esquerdo da tela | idle |
| Paleta | Marrom, preto, grisalho, azul do cristal (`color` [140,90,50]) | canon 018 |
| Divindade e bioma | Constelação radiante; sem aura | `heroes.json` |
| Não pode | Chapéu pontudo de mago ou manto verde (supersedidos pelo registro 018) | canon 018 |
| Referências | idle; registro 018 | — |

## 8. Nyrelia

| Campo | Conteúdo | Fonte |
|---|---|---|
| Quem é | Sacerdotisa de Mask; referência maternal de Sylas; "usa máscara e sua espécie não foi estabelecida" | vault |
| Traços fixos | **Rosto oculto**: capuz verde-escuro e máscara escura lisa; silhueta alta e longa | idle, vault |
| Roupa e armadura | Manto verde com **bordas douradas**, broche dourado no ombro, véu sobre o peito, **faixa vertical verde bordada** na frente, vestido negro, luvas | idle |
| Arma | **Dominar Pessoa** (magia): mãos juntas na frente; esfera verde luminosa quando conjura | idle, `heroes.json` |
| Paleta | Verde-musgo, negro, ouro (`color` [200,180,60]; cabelo não visível) | idle |
| Divindade e bioma | Mask; Aura Amarela é passiva do jogo, não visual | `heroes.json` |
| Não pode | **Mostrar rosto, cabelo ou espécie** | vault |
| Referências | idle; registro 010 (regenerada em 2026-09-27) | — |

## 9. Zynara Vellen

| Campo | Conteúdo | Fonte |
|---|---|---|
| Quem é | Alta Conselheira de Rodhe's Bridge; ligada à realeza élfica | vault |
| Traços fixos | Elfa de **cabelo branco longo e ondulado**, coque alto com adorno dourado, orelhas pontudas; expressão serena | idle |
| Roupa e armadura | **Vestido negro longo com bordados dourados**, corpete e mangas bufantes, cinto com **cantil/tubo** e **pingente de estrela**, botas de salto | idle |
| Arma | **Ampulheta**, segurada no lado direito da tela | idle |
| Paleta | Negro, ouro, branco-prateado (`color` [110,70,150], `hair` [220,220,230]) | idle |
| Divindade e bioma | Sem divindade registrada | — |
| Não pode | Trocar o lado da ampulheta; tirar a ampulheta (identidade da habilidade) | decisão |
| Referências | idle; registro 005 | — |

## 10. Bromnor Martelo da Luz

| Campo | Conteúdo | Fonte |
|---|---|---|
| Quem é | **Anão**, Alto Conselheiro de Fateridge, líder de batalha; defende a cooperação entre as raças | vault |
| Traços fixos | **Barba branca longa e ondulada**, cabelo branco, sobrancelhas fortes, corpo largo e baixo | idle |
| Roupa e armadura | Armadura **dourada com gravuras de nó** e **manto azul**, ombreira alta decorada, joelheiras e botas com ponteira de aço | idle |
| Arma | **Martelo da Glória** (cabeça dourada, haste longa) apoiado no ombro, no lado esquerdo da tela | idle |
| Paleta | Dourado, azul-real, branco (`color` [150,120,80]) | idle |
| Divindade e bioma | Concórdia Eterna (passiva) | `heroes.json` |
| Não pode | Alterar a barba; o vault diz que ele morreu e o espírito habita o martelo: **não representar isso** na arte | vault |
| Referências | idle; registro 005 | — |

## 11. Arlindo Orlando

| Campo | Conteúdo | Fonte |
|---|---|---|
| Quem é | Humano andarilho, líder do grupo local (nome do grupo: ver **P5**), usa magia de memória | vault |
| Traços fixos | Homem **maduro**, rosto marcado, **barba curta grisalha**, olhar para baixo, postura curvada | idle, nottcard |
| Roupa e armadura | **Chapéu de feltro marrom** de aba, **sobretudo marrom longo**, **cachecol vermelho-escuro**, luvas escuras, botas marrons | idle, nottcard |
| Arma | **Memória Alterada** (magia): mãos juntas na frente, sem objeto | idle, `heroes.json` |
| Paleta | Marrom, vinho, cinza (`color` [90,60,45], `hair` [170,170,170]) | idle |
| Divindade e bioma | Sem divindade; Dagruve | vault |
| Não pode | Rejuvenescer, tirar o chapéu ou o cachecol | idle |
| Referências | idle (arte própria v04, célula 512×512); retrato Nottcard; 4 tiras ainda pendentes (AO09, AO10, e as de Erik) | ART-045 |

## 12. Erik Blackthorn

| Campo | Conteúdo | Fonte |
|---|---|---|
| Quem é | Humano batedor; imune à névoa pelo Amuleto da Luz; procurado por incendiar navios | vault, `hero_bios.json` |
| Traços fixos | Homem **robusto**, cabelo **preto desgrenhado**, barba cheia, olhar duro | idle, nottcard |
| Roupa e armadura | **Gola de pele clara** e cachecol de lã, casaco azul-escuro com **cintos de couro cruzados**, **medalhão luminoso** no peito, calça escura, botas altas marrons, **espada às costas** (cabo visível acima do ombro) | idle, nottcard |
| Arma | **Tocha acesa** (Tocha do Incendiário), no lado esquerdo da tela | idle |
| Paleta | Marrom, azul-escuro, creme, chama laranja (`color` [110,75,45], `hair` [30,30,40]) | idle |
| Divindade e bioma | Sem divindade; Docas | vault |
| Não pode | Tirar o medalhão ou a espada das costas; o fogo da tocha precisa **caber na célula** (célula 512×512 por isso) | ART-045 |
| Referências | idle (arte própria v04); retrato Nottcard (cicatriz, P6) | — |

---

## Conferência rápida do que vem do Vault, do Nottcard e do sprite

| Herói | Vault (02/03) | Nottcard (retrato) | Idle atual |
|---|---|---|---|
| Durvall | ficha com aparência | consistente | aprovado (reg. 002) |
| Brook | canon 003 | **legado**, superado | aprovado (reg. 017) |
| Maelor | sem aparência escrita | consistente | aprovado |
| Sylas | sem aparência (máscara) | consistente | aprovado |
| Kayron | "asas brancas" na infância | **asas negras e vermelhas** (P1) | sem asas |
| Korrak | sem aparência | consistente | aprovado |
| Leoric | sem aparência | chapéu pontudo (P3) | cartola (reg. 018) |
| Nyrelia | "usa máscara" | não existe | máscara, rosto oculto |
| Zynara | "elfa", realeza | não existe | aprovado (reg. 005) |
| Bromnor | anão | não existe | aprovado (reg. 005) |
| Arlindo | sem aparência | consistente | arte própria v04 |
| Erik | sem aparência | consistente (cicatriz) | arte própria v04 |
