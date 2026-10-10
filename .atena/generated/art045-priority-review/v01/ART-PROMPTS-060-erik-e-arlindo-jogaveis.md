---
id: "ART-PROMPTS-060"
type: "prompts-de-arte"
title: "Erik Blackthorn e Arlindo Orlando: retrato e as nove tiras de animação (heróis jogáveis)"
status: "prompts prontos para o ChatGPT; nenhuma imagem gerada; candidatos ficam fora do runtime até admissão do dono"
priority: "alta (pedido do dono em 2026-10-09: assets e imagens de Erik e Arlindo em primeiro lugar)"
created: "2026-10-09"
relations: ["[[SPEC-160-arlindo-orlando-e-erik-blackthorn-jogaveis]]", "[[PROPOSTA-arlindo-e-erik-jogaveis-2026-10-09]]", "[[ART-PROMPTS-055-regerar-caminhadas-e-acoes-dos-herois]]", "[[SPEC-021-prompts-de-animacao-dos-herois]]"]
sources: ["F:\\dev\\nottcard\\assets\\portraits\\erik.png", "F:\\dev\\nottcard\\assets\\portraits\\arlindo.png", "Vault 03_NPCs/Erik Blackthorn.md e Arlindo Orlando.md"]
---

# Erik e Arlindo — prompts de arte

## Prontidão visual (DRAFT, antes de gerar)

| Item | Estado |
|---|---|
| Identidade | **DRAFT.** Fonte: os retratos do Nottcard (somente leitura): `F:\dev\nottcard\assets\portraits\erik.png` e `arlindo.png`. Anexar o retrato certo em **toda** conversa. O que está escrito abaixo é só o que se vê neles; o retrato prevalece sobre o texto. |
| Cânone visual do mundo | Sabor Nottgard: paleta fria e suja com um ponto de luz quente; nada de lore nova na arte. |
| Lacunas | Idade e porte exatos não estão no Vault: Erik adulto de 30 a 40 anos, forte; Arlindo de uns 60, magro. O Erik do Vault raspa cabeça e barba na S20 (parte 2); **aqui ele é o Erik de antes**, com cabelo e barba, como no retrato. |
| Contexto de cena | Herói isolado em jogo 2D isométrico, fundo com alfa real. Sem cenário. |
| Autoridade | O dono admite ou rejeita cada candidato; nada entra no jogo sem isso. |

## Bloco comum obrigatório (vale para todas as peças)

Use case: `stylized-concept`. Asset type: tira de animação de herói (ou retrato) para jogo 2D isométrico. Estilo: **pintura pixel-art detalhada**, câmera **três-quartos isométrica 2:1**, luz principal **no alto à esquerda**, mesmo acabamento dos heróis existentes (Maelor, Durvall, Brook). Anexar sempre o retrato do herói (Nottcard) e, a partir da segunda peça, o `idle` **aprovado** daquele herói (referência obrigatória de identidade, escala e acabamento).

Regras de dimensão (as mesmas do ART-PROMPTS-055):

1. Grade limpa de **uma linha**: **4 quadros** (`idle`, `attack`) ou **6 quadros** (`move_*`, `active`, `death`), cada quadro uma célula de **256 × 384 px** (4 quadros = 1024 × 384; 6 quadros = 1536 × 384), fundo com **alfa real**.
2. O herói inteiro, arma e capa incluídas, cabe na célula com **pelo menos 10 px de folga** em todos os lados. Nada atravessa a borda nem invade o quadro vizinho. Se a arma não couber, reduzir o herói inteiro; nunca cortar a arma.
3. **Altura do corpo constante** (cabeça aos pés) em todos os quadros: Erik **300 px**, Arlindo **290 px**. O passo é feito por pernas e braços, nunca por zoom. A pose de `death` pode terminar no chão.
4. **Massa constante**: mesma largura de ombros, tronco, casaco e arma em todas as direções.
5. **Linha de base fixa:** a sola do pé de apoio toca sempre a mesma linha horizontal, **y = 368** da célula, em todos os quadros e direções (exceto o salto explícito do `active` e a queda da `death`).
6. A mesma mão segura o mesmo objeto em todas as direções (Erik: tocha na **direita**, espada nas costas; Arlindo: mãos livres).
7. Primeiro e último quadro da caminhada fecham o loop sem salto.
8. **Sem** cenário, piso, sombra projetada, texto, rótulo, grade, borda, marca d'água, motion blur, halo preto/branco/vermelho, membro extra, objeto duplicado ou redesign. Efeitos (fogo, brilho) ficam **dentro da célula** e não contam para a altura.

A direção é a direção visual **na tela**. O jogo espelha as direções do oeste (`move_w`, `move_sw`, `move_nw`) a partir das do leste, então só se geram `move_n`, `move_ne`, `move_e`, `move_se` e `move_s`. **O `idle` olha para baixo e à direita** (sudeste na tela).

## Identidade

**Erik Blackthorn** (humano, batedor dos Grimholders, guerreiro de fogo). Do retrato: cabelo escuro e revolto, barba curta escura, **cicatriz vermelha na testa**, olhos azul-acinzentados, olhar duro; **cachecol/capuz de lã creme** no pescoço, **ombreira de pelo** num ombro, couraça de couro desgastado com **fivelas e correias** em diagonal, antebraços enfaixados e luvas sem dedos; **espada de cabo escuro nas costas**; no peito, o **medalhão redondo com uma estrela de luz** (o Amuleto da Luz), que brilha em dourado. Paleta: marrom couro, cinza-azul, creme; **luz quente laranja** do medalhão e da tocha. Em jogo ele segura uma **tocha acesa** na mão direita (a Tocha do Incendiário).

**Arlindo Orlando** (humano andarilho, líder dos Grimholders, suporte e controle). Do retrato: homem de uns 60 anos, rosto marcado, **barba curta grisalha**, cabelo grisalho sob um **chapéu de aba larga marrom-escuro com fita**, **sobretudo longo marrom-escuro** de gola alta e ombros molhados, **cachecol vinho/marrom-avermelhado**, **luvas de couro escuro**, postura calma, meio sorriso cansado. Paleta: marrons e preto, vinho, **um ponto de luz âmbar** de lampião. **Sem arma**: a magia dele é de memória. Brilho de feitiço: **azul-esverdeado pálido com fiapos violeta**, como lembranças que se desfazem.

## Alvos

| | Erik | Arlindo |
|---|---|---|
| Altura-alvo (px, cabeça aos pés, no `idle`) | 300 | 290 |
| Linha de base (y na célula) | 368 | 368 |
| Altura em tela no jogo | 64 (humano 1,75 m) | 62 (humano um pouco curvado) |
| Referência de porte | Maelor (humano, 299) | Maelor, um pouco menor e mais magro |

Depois da admissão, os valores entram em `HERO_IDLE_ART_HEIGHT`, `HERO_FEET_Y` e `HERO_DISPLAY_HEIGHT` de `ui/hero_view.gd`.

## Ordem de envio (uma peça por chamada, **na mesma conversa por herói**)

Enviar **primeiro o retrato e o `idle`** de cada um: tudo o mais depende deles.

### Erik Blackthorn — ER

| Código | Peça | Arquivo-destino | Pedido |
|---|---|---|---|
| ER01 | Retrato de seleção | `er01-retrato.png` | Anexar `erik.png` do Nottcard. Refazer o retrato em **1536 × 1024 px (3:2)**, mesmo rosto, cicatriz, barba, cachecol, ombreira de pelo, espada nas costas e medalhão aceso, **mesmo acabamento pictórico dos retratos de Brook e Leoric**, fundo escuro de floresta com névoa azulada, **sem texto**. |
| ER02 | `idle` (4 quadros, olha para sudeste) | `er02-idle.png` | Corpo inteiro de pé, **tocha acesa na mão direita**, espada nas costas, medalhão brilhando; respiração leve e a chama oscilando. Anexar o retrato. |
| ER03 | `move_e` | `er03-move_e.png` | Andando para a **direita**; 6 quadros, passada firme, tocha à direita, capa/cachecol balançando dentro da folga. Anexar o `idle` aprovado. |
| ER04 | `move_se` | `er04-move_se.png` | Andando para baixo e à direita. |
| ER05 | `move_s` | `er05-move_s.png` | Andando para baixo, de frente. |
| ER06 | `move_ne` | `er06-move_ne.png` | Andando para cima e à direita; espada nas costas visível. |
| ER07 | `move_n` | `er07-move_n.png` | Andando para cima, **de costas** (não de frente). |
| ER08 | `attack` (4 quadros, golpe de tocha em cone) | `er08-attack.png` | Golpe amplo de tocha à frente (sudeste), arco de fogo curto no quadro 2 e 3, volta à guarda no 4. O corpo avança na horizontal; a altura não muda. |
| ER09 | `active` (6 quadros, "Navios em Chamas") | `er09-active.png` | Ele crava a tocha no chão à frente e uma **faixa de fogo** corre para a frente; no quadro 4 o fogo está no pico. O fogo fica dentro da célula. |
| ER10 | `death` (6 quadros) | `er10-death.png` | Cai de joelhos e tomba de lado, tocha rolando; o medalhão apaga no último quadro. |

### Arlindo Orlando — AO

| Código | Peça | Arquivo-destino | Pedido |
|---|---|---|---|
| AO01 | Retrato de seleção | `ao01-retrato.png` | Anexar `arlindo.png` do Nottcard. Refazer em **1536 × 1024 px (3:2)**, mesmo rosto, chapéu, sobretudo, cachecol vinho, luvas e mãos juntas, **mesmo acabamento pictórico dos retratos de Brook e Leoric**, becos de pedra molhados com **um lampião âmbar**, **sem texto**. |
| AO02 | `idle` (4 quadros, olha para sudeste) | `ao02-idle.png` | Corpo inteiro de pé, mãos às costas ou juntas na frente, leve balanço do casaco e da fita do chapéu; fiapos azul-esverdeados quase invisíveis perto das mãos. |
| AO03 | `move_e` | `ao03-move_e.png` | Andando para a **direita**, passo curto de andarilho, casaco e cachecol balançando dentro da folga. |
| AO04 | `move_se` | `ao04-move_se.png` | Para baixo e à direita. |
| AO05 | `move_s` | `ao05-move_s.png` | Para baixo, de frente. |
| AO06 | `move_ne` | `ao06-move_ne.png` | Para cima e à direita. |
| AO07 | `move_n` | `ao07-move_n.png` | Para cima, **de costas**; o chapéu e a gola alta dominam a silhueta. |
| AO08 | `attack` (4 quadros, "Memória Alterada") | `ao08-attack.png` | Ele estende a mão direita à frente (sudeste) e solta um **projétil de luz azul-esverdeada** com fiapos violeta no quadro 3; o projétil sai do quadro ou termina dentro da folga. |
| AO09 | `active` (6 quadros, "Modify Memory") | `ao09-active.png` | Duas mãos às têmporas/à frente, **anel de luz azul-esverdeada** se expande ao redor dele até o quadro 4 e se desfaz. O anel fica dentro da célula. |
| AO10 | `death` (6 quadros) | `ao10-death.png` | Cai devagar de joelhos, o chapéu rola, as luvas soltam fiapos de luz que se apagam. |

## Aceite (antes da admissão)

1. Rodar `tools/audit_hero_motion.gd` e `tools/audit_strip_edges.gd` nas tiras: altura mediana = `idle` (±3%), `height_spread` ≤ 12 px, `edge_frames` = 0, base mediana = 368.
2. Revisão do dono no jogo (com `art_like` trocado pelos sprites novos): andar nas oito direções sem crescer, afinar, esticar nem trocar a mão da tocha.
3. Candidatos ficam em `.atena/generated/art-candidates/heroes-novos/<erik|arlindo>/` até a admissão explícita.

## Enquanto a arte não chega

Os dois entram com `art_like` provisório (Arlindo → Sylas; Erik → Durvall) e marca "arte provisória" na seleção (SPEC-160). Os retratos de seleção são o único item que o menu usa sem fallback.
