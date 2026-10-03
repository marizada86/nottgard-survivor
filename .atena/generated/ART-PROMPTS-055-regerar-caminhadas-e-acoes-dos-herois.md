---
id: "ART-PROMPTS-055"
type: "prompts-de-arte"
title: "Regerar tiras de caminhada e ação dos heróis com defeito de dimensão"
status: "W01–W15 e A01–A10 integrados após auditoria; lote concluído localmente; EVID-145"
priority: "alta"
created: "2026-10-02"
relations: ["[[EVID-146-auditoria-de-dimensoes-dos-herois-2026-10-02]]", "[[CHATGPT-FILA-024-regerar-tiras-dos-herois]]"]
sources: ["assets/animations/heroes/<heroi>/idle.png"]
---

# Regerar tiras dos heróis com defeito de dimensão

Origem: [[EVID-146-auditoria-de-dimensoes-dos-herois-2026-10-02]]. Estas tiras têm defeito **na própria arte** (corpo cortado na borda da célula, massa/largura diferente do idle, quadro de ação com altura incoerente). Normalização por código não recupera pixel cortado nem redesenha corpo.

## Bloco comum obrigatório

Use case: `stylized-concept`. Asset type: tira de animação de herói para jogo 2D isométrico. Anexar (1) o `idle.png` atual do herói, que é a referência **obrigatória** de identidade, escala, proporção do corpo e acabamento, e (2) a tira defeituosa atual, apenas como referência de pose/direção. Preservar exatamente rosto, cabelo, roupa, armadura, arma, paleta, pintura pixel-art detalhada, câmera três-quartos isométrica e luz superior esquerda do idle.

Regras de dimensão (as que faltaram nas tiras antigas):

1. Saída: grade limpa **6 colunas × 1 linha** (caminhada, `active`, `death`) ou **4 × 1** (`attack`), cada quadro uma célula de **256 × 384 px**, fundo com alfa real.
2. **O herói inteiro, arma e capa incluídas, cabe dentro da célula com pelo menos 10 px de folga em todos os lados.** Nada encosta nem atravessa a borda; nada vaza para o quadro vizinho. Se a arma não couber, reduzir o herói inteiro, nunca cortar a arma.
3. **Altura do corpo constante:** do topo da cabeça à sola dos pés, a altura é a do idle (valor-alvo abaixo, em px) em **todos** os quadros. Não variar a escala entre quadros; o passo é feito por pernas e braços, não por zoom.
4. **Massa constante:** mesma largura de ombros, tronco, capa e arma do idle. Não engordar, afinar, esticar ou alargar o corpo ao mudar de direção.
5. **Linha de base fixa:** a sola do pé de apoio toca sempre a mesma linha horizontal (valor-alvo abaixo), em todos os quadros e em todas as direções. Nenhum quadro com pés flutuando ou afundando; salto só onde o estado pede (`active`/`death`).
6. Mesma mão segurando a arma que no idle, em todas as direções. Não trocar o lado da arma.
7. Primeiro e último quadro conectam em loop sem salto de base ou escala (caminhada).
8. Sem cenário, piso, sombra projetada, texto, rótulo, grade, borda, watermark, motion blur, halo preto/branco/vermelho, membro extra, objeto duplicado ou redesign.

Cada linha da tabela é uma chamada independente. A direção é a direção visual **na tela**.

## Alvos por herói

Altura-alvo = `HERO_IDLE_ART_HEIGHT`; base-alvo = `HERO_FEET_Y` (ver `ui/hero_view.gd`).

| Herói | Altura-alvo | Base-alvo (y) | Identidade (confirmar no idle anexado) |
|---|---|---|---|
| Kayron | 316 | 376 | cabelo branco desgrenhado, armadura negra laminada, capa roxa rasgada |
| Korrak | 267 | 350 | goliath de pele cinza, pelugem marrom, ombreiras com espinhos, machado duplo de lava |
| Bromnor | 241 | 364 | anão de barba branca longa, armadura azul e dourada, martelo de guerra |
| Sylas | 304 | 376 | conforme `sylas/idle.png` |
| Brook | 259 | 368 | conforme `brook/idle.png` |
| Durvall | 231 | 376 | elfo sombrio de cabelo branco, armadura preta, capa vinho, espada azul |
| Nyrelia | 352 | 368 | encapuzada de verde, vestido negro com bordado dourado |
| Maelor | 299 | 364 | conforme `maelor/idle.png` |
| Zynara | 368 | 376 | conforme `zynara/idle.png` |
| Leoric | 224 | 368 | conforme `leoric/idle.png` |

## P1 — caminhadas (erro visível no jogo)

Sequência por chamada: 6 quadros cronológicos, passada controlada e legível, arma segura.

| Código | Herói | Sequência | Direção na tela | Defeito atual |
|---|---|---|---|---|
| W01 | Kayron | `move_se` | para baixo e direita | corpo/capa 39% mais pesado que o idle, quadros 3–5 com pés 20 px acima da base, 2 quadros na borda (reportado pelo dono: "estica/cresce/afina" nas diagonais de baixo) |
| W02 | Korrak | `move_e` | direita | machado cortado na borda direita nos 6 quadros, lascas no vizinho |
| W03 | Korrak | `move_se` | baixo e direita | machado cortado, massa 29% acima do idle |
| W04 | Korrak | `move_ne` | cima e direita | cabeça do machado separada/cortada |
| W05 | Korrak | `move_s` | para baixo | machado cortado na direita nos quadros 1–5 |
| W06 | Bromnor | `move_e` | direita | massa 36% acima do idle, 6 quadros na borda, pés até 77 px fora da base |
| W07 | Bromnor | `move_se` | baixo e direita | pernas e laterais cortadas, altura varia 38 px |
| W08 | Sylas | `move_ne` | cima e direita | 6 quadros colados na borda, pés até 24 px fora da base |

Para Kayron W01, reforço: o corpo na diagonal deve ter a **mesma largura de ombros e capa do `move_s`/idle**; a capa pode balançar, mas dentro de 10 px de folga.

## P2 — caminhadas com variação entre quadros

| Código | Herói | Sequência | Defeito atual |
|---|---|---|---|
| W09 | Kayron | `move_n`, `move_s` | massa 21–24% acima do idle |
| W10 | Sylas | `move_s` | massa 20% acima do idle |
| W11 | Brook | `move_n`, `move_ne` | altura varia 40–43 px e massa até 46% entre quadros |
| W12 | Durvall | `move_ne`, `move_e` | altura varia 31–45 px, massa 30% acima do idle |
| W13 | Nyrelia | `move_e` | 15% menor que o idle, altura varia 57 px |
| W14 | Maelor | `move_n`, `move_ne`, `move_e`, `move_se` | massa 53–67% do idle (silhueta fina demais); `move_s` com pés a 38 px da base |
| W15 | Bromnor | `move_n`, `move_ne`, `move_s` | pés a 30–68 px da base (pode já estar corrigido por código; reauditar antes) |

## P2 — ação (`attack` 4 quadros, `active` 6 quadros)

Mesmas regras. O ataque pode estender a arma e deslocar o corpo **horizontalmente**, mas a altura do corpo e a linha de base seguem as do idle, exceto no salto explícito do `active`. Efeito de VFX (rastro, faíscas) fica **fora** do corpo e dentro da célula; não conta para a altura.

| Código | Herói | Sequência | Defeito atual |
|---|---|---|---|
| A01 | Zynara | `attack` | altura varia 157 px e massa 2,7× entre quadros |
| A02 | Korrak | `active` | altura varia 106 px entre quadros |
| A03 | Sylas | `active` | altura 0,57× do idle, pés a 89 px da base |
| A04 | Bromnor | `attack`, `active` | altura 0,88× e 0,74×, varia 61 px |
| A05 | Durvall | `attack`, `active` | altura 0,81–0,86×, massa varia 1,6×, 2 quadros na borda |
| A06 | Brook | `attack`, `active` | altura 1,07× e 0,86×, varia 40–50 px |
| A07 | Leoric | `attack`, `active` | altura 0,82–0,85× |
| A08 | Kayron | `active` | altura 0,86×, pés a 23 px da base |
| A09 | Maelor | `active` | altura 0,91×, pés a 30 px da base |
| A10 | Nyrelia | `active` | altura varia 50 px |

## Aceite

- Rodar `tools/audit_hero_motion.gd`: altura mediana igual ao idle (±3%), `height_spread` ≤ 12 px, `edge_frames` = 0, base mediana = base do idle.
- Rodar `tools/equalize_hero_frames.gd` em modo relatório: nenhuma linha para a tira.
- Revisão no jogo: andar nas oito direções sem crescer, afinar, esticar ou trocar o lado da arma.

