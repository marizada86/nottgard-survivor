---
id: "ART-PROMPTS-064"
type: "prompts-de-arte"
title: "Contrato de prompt v2 para refazer as tiras de animação dos heróis"
status: "DRAFT r1 em 2026-10-14 (SPEC-176 S-003 e S-004); nenhum prompt enviado; aguarda G-D1 e G-D3"
content_state: DRAFT
spec: "SPEC-176"
plan: "PLAN-103"
supersedes: ["ART-PROMPTS-055 (bloco comum)", "ART-PROMPTS-056 (costas)"]
relations: ["[[FICHAS-DE-IDENTIDADE-herois-m1-2026-10-14]]", "[[SPEC-176-movimento-dos-herois-marco-m1-do-plan-103]]"]
---

# Contrato de prompt v2 — tiras dos heróis

Este documento é o **contrato**, não o lote. Ele define o que cada chamada ao gerador de imagem precisa carregar. Os prompts por herói e por tira saem só depois do **G-D1** (fichas aprovadas) e usam o piloto do **G-D3** para validar o método.

## 1. O que muda em relação ao v1 (ART-PROMPTS-055)

| v1 | v2 | Motivo |
|---|---|---|
| Anexava a **tira defeituosa** como "referência de pose" | **Proibido.** Anexos: `idle.png`, ficha, referências temáticas e do dono, gabarito | A tira ruim reinjeta corte, massa e base erradas |
| Zumbi e Bandido como faixa de estabilidade | **Fora.** A régua é o idle do **próprio herói** | Decisão do dono (2026-10-14) |
| 8 regras de dimensão misturadas ao desenho, 6 quadros de uma vez | **Uma tira por chamada**, números separados do desenho, pose por quadro numa tabela | Menos ambiguidade por prompt |
| Sem passada numérica | **Passo-alvo em px por herói** e **ritmo (fps) acoplado** | Ver §2 |
| Base fixa em todos os quadros | Base fixa nos quadros de apoio; elevação controlada nos quadros de passagem alta | Uma corrida real tem fase aérea curta |

## 2. Por que o patinar não se resolve só com "passo maior"

Medido em 2026-10-14 (`reguas.csv`): o herói anda a **190 px/s** de tela e hoje o ciclo é de **6 quadros a 10 fps** (0,6 s). Em um ciclo o corpo avança 114 px de tela, ou **57 px por passo**:

| Herói | Altura em tela | Passo exigido a 10 fps (em alturas do corpo) |
|---|---:|---:|
| Kayron, Maelor, Sylas, Erik, Durvall, Zynara, Nyrelia, Arlindo | 60 a 66 px | 0,86 a 0,95 |
| Bromnor | 48 px | 1,19 |
| Brook, Leoric | 40 px | **1,43** |
| Korrak | 76 px | 0,67 |

Um passo humano de caminhada é ~0,4 a 0,5 da altura e de corrida ~0,5 a 0,65. Logo, **com 6 quadros a 10 fps nenhuma arte, por melhor que seja, deixa de patinar**: o passo exigido é quase uma altura inteira. Os heróis pequenos são os piores.

Isso conversa com o EVID-197 (passada desenhada de 9 a 61 px/s contra 190 px/s) e explica por que "regerar" não convergiu. A correção tem **duas metades acopladas**:

1. **Arte:** pose de contato com pés afastados por ≈ **0,55 × a altura do corpo** (faixa 0,45 a 0,62), pernas e braços marcando o passo, sem zoom.
2. **Ritmo:** o ciclo de 6 quadros passa a rodar a `fps = velocidade × 6 / (2 × 0,55 × altura em tela)`, **por herói** (coluna "fps do andar" abaixo). É uma mudança de código pequena (`ui/hero_view.gd`, onde hoje o andar é fixo em 10 fps) e **reversível**.

Sem a metade 2, a arte nova repete o defeito; sem a metade 1, o fps novo só acelera pés que mal se mexem. Isso entra como entrada do **G-D2**.

## 3. Régua numérica por herói (S-004)

Alturas em px da arte, na célula de entrega. "Passo-alvo" = distância horizontal entre os pontos de apoio dos dois pés no quadro de contato.

| Herói | Altura tela | Altura idle (px) | Base y | Célula | Largura do idle | Passo-alvo | Faixa do passo | fps do andar |
|---|---:|---:|---:|---|---:|---:|---|---:|
| Durvall | 60 | 231 | 376 | 256×384 | 189 | 127 | 104 a 143 | 17 |
| Zynara | 60 | 368 | 376 | 256×384 | 166 | 202 | 166 a 228 | 17 |
| Leoric | 40 | 224 | 368 | 256×384 | 161 | 123 | 101 a 139 | 26 |
| Nyrelia | 62 | 352 | 368 | 256×384 | 180 | 194 | 158 a 218 | 17 |
| Kayron | 66 | 316 | 376 | 256×384 | 211 | 174 | 142 a 196 | 16 |
| Korrak | 76 | 267 | 350 | 256×384 | 208 | 147 | 120 a 166 | 12 |
| Bromnor | 48 | 241 | 364 | 256×384 | 172 | 133 | 108 a 149 | 22 |
| Sylas | 64 | 304 | 376 | 256×384 | 207 | 167 | 137 a 188 | 16 |
| Brook | 40 | 259 | 368 | 256×384 | 232 | 142 | 117 a 161 | 26 |
| Maelor | 64 | 299 | 364 | 256×384 | 222 | 164 | 135 a 185 | 16 |
| Arlindo | 62 | 290 | 448 | 512×512 | 123 | 160 | 131 a 180 | 17 |
| Erik | 64 | 300 | 448 | 512×512 | 167 | 165 | 135 a 186 | 16 |

Notas:
- `fps do andar` de Korrak já considera a velocidade dele (−10%).
- **Zynara (368) e Nyrelia (352)** têm arte muito mais alta que a média e o passo-alvo (194 a 202 px) quase enche a célula de 256 px de largura, com saia e manto. Recomendação para o G-D1/G-D3: **reduzir o idle por ferramenta a ≤ 300 px antes de gerar** (a altura em tela não muda; só sobe a escala de exibição) e usar o passo-alvo da faixa baixa.
- Leoric e Brook a **26 fps** pedem ciclo rápido (0,23 s). Para um halfling e um gnomo de 40 px isso lê como "passos curtos e velozes", coerente com a proporção; é a hipótese a validar no piloto ou no laboratório de código (C1).

## 4. Bloco comum do prompt (texto a enviar em toda chamada)

> **Papel:** você produz **uma única tira de animação** de um herói de jogo 2D isométrico, em pintura de pixel detalhada, câmera três-quartos, luz superior esquerda.
>
> **Anexos (use somente estes):** (1) `idle.png` do herói, **referência obrigatória** de rosto, cabelo, roupa, armadura, arma, paleta, proporção e acabamento; (2) a ficha de identidade; (3) o gabarito da tira; (4) referências temáticas indicadas. **Não há outras referências.**
>
> **Saída:** uma imagem **N × 1** (N colunas, 1 linha), cada quadro uma célula de **W × H px**, fundo com **alfa real** (transparente), nada fora das células.
>
> **Números (obrigatórios):** altura do corpo, do topo da cabeça à sola, **A px** em todos os quadros; **linha de base y = B** para o pé de apoio; **passo = P px** entre os pés no quadro de contato (faixa Pmin a Pmax); largura de ombros e massa do corpo iguais às do idle; **folga mínima de 10 px** em todos os lados, arma e capa incluídas. Não varie a escala entre quadros: o movimento é de pernas, braços e tronco, **nunca zoom**.
>
> **Pose por quadro:** siga a tabela abaixo, sem inverter a ordem.
>
> **Continuidade:** o último quadro deve voltar ao primeiro sem salto de base, escala ou posição.
>
> **Proibido:** cenário, piso, sombra projetada, texto, grade, rótulo, borda, marca d'água, desfoque de movimento, halo, membro extra, objeto duplicado, redesenho do herói, troca da mão da arma, arma cortada, símbolo ou aura de divindade que não esteja no idle.

## 5. Pose por quadro

### Andar (`move_*`, 6 quadros; fps da §3)

| Quadro | Pose | Pés | Observação |
|---|---|---|---|
| 1 | **Contato A** | Pé A à frente, calcanhar tocando; pé B atrás, ponta apoiada | Passo máximo (P); corpo na altura A |
| 2 | **Recuo / passagem** | Pé A sob o corpo, apoio total; pé B sai do chão | Corpo no ponto mais baixo (até −3% de A) |
| 3 | **Alto** | Pé A empurra; pé B à frente no ar | Elevação do corpo ≤ +6% de A |
| 4 | **Contato B** | Espelho do 1: pé B à frente | Passo máximo (P) |
| 5 | **Recuo / passagem** | Pé B sob o corpo; pé A sai | Corpo mais baixo |
| 6 | **Alto** | Pé B empurra; pé A à frente no ar | Volta ao quadro 1 |

Braços balançam em oposição às pernas, sem esticar o corpo; a arma segue na **mesma mão** do idle em todos os quadros.

### Ataque (`attack`, 4 quadros, 12 fps)

| Quadro | Pose |
|---|---|
| 1 | **Antecipação:** recolhe a arma e carrega o peso para trás |
| 2 | **Golpe:** transfere o peso, arma na linha do alvo (maior extensão) |
| 3 | **Impacto:** extensão final, sem ultrapassar a célula |
| 4 | **Recuperação:** volta à guarda do idle |

### Habilidade (`active`, 6 quadros, 12 fps) e morte (`death`, 6 quadros, 9 fps)

Descritas **por herói** na ficha e na chamada do lote (a habilidade de cada um é diferente). `death` termina no chão, dentro da célula, com a base no mesmo `y`.

### Idle (`idle`, 4 quadros, 8 fps)

Não é refeito (D13). Se o dono pedir, segue o mesmo contrato com respiração leve.

## 6. As 8 direções (cada uma é uma tira independente, PLAN-001 §26)

| Tira | Para onde o herói **olha** na tela |
|---|---|
| `move_e` | direita, perfil |
| `move_se` | baixo e direita, três-quartos de frente |
| `move_s` | baixo, de frente |
| `move_sw` | baixo e esquerda, três-quartos de frente |
| `move_w` | esquerda, perfil |
| `move_nw` | cima e esquerda, **três-quartos de costas** |
| `move_n` | cima, **de costas** |
| `move_ne` | cima e direita, **três-quartos de costas** |

Regras de costas (BUG-027): em `move_n`, `move_ne` e `move_nw` **o rosto não aparece**; vê-se nuca, capa, costas da armadura e a arma pelo lado correto. `move_w`, `move_nw` e `move_sw` só podem ser espelhos de `move_e`, `move_ne` e `move_se` quando a ficha confirmar simetria (sem emblema ou arma que troque de lado).

## 7. Mão da arma (derivada do `idle` de frente)

Convenção: o herói de frente; o lado direito da **tela** é a **mão esquerda** do personagem. Valores a confirmar no G-D1.

| Herói | Arma | Mão |
|---|---|---|
| Durvall | Espada de lâmina azul | esquerda |
| Zynara | Ampulheta | esquerda |
| Korrak | Machado duplo | duas mãos |
| Leoric | Cajado com cristal | direita |
| Sylas | Adaga violeta | direita |
| Maelor | Chama azul | direita |
| Brook | Maça de espinhos | direita |
| Bromnor | Martelo no ombro | direita |
| Erik | Tocha | direita (espada às costas) |
| Kayron, Nyrelia, Arlindo | sem arma de mão | — |

## 8. Gabarito (anexo 3)

Um PNG por herói e tira, gerado por ferramenta (**sem desenho do herói**), com: N células de W × H; linha de base `y = B`; linha de topo `y = B − A`; marcas verticais nos pontos de apoio esperados dos quadros 1 e 4 afastadas por P; margem de 10 px; uma silhueta cinza do idle ao centro de cada célula como escala. O gabarito é produzido no **S-007** para o piloto.

## 9. Critérios de aceite técnico (S-008)

| # | Critério | Limite |
|---|---|---|
| T1 | Células e alfa real | N × W × H exatos; alfa nativo |
| T2 | Altura do corpo | A ± 3% em todos os quadros |
| T3 | Base do pé de apoio (quadros 1, 2, 4, 5) | B ± 1 px |
| T4 | Passo no contato (quadros 1 e 4) | dentro da faixa Pmin a Pmax |
| T5 | Folga | ≥ 10 px na entrega; ≥ 2 px após integração |
| T6 | Largura de ombros e massa | ± 8% do idle |
| T7 | Costas nas direções N | sem rosto visível |
| T8 | Identidade | confere com a ficha (olho do dono) |

## 10. Exemplo preenchido (não enviado): Durvall, `move_e`

> Papel e anexos: ver §4 (anexos: `durvall/idle.png`, ficha 1, gabarito `durvall_move_e`, nenhuma outra).
> Saída: 6 × 1, células de 256 × 384 px, alfa real.
> Números: altura do corpo **231 px**; base **y = 376**; passo **127 px** (faixa 104 a 143); largura de ombros e massa do idle (≈ 189 px de largura total com capa e espada); folga ≥ 10 px.
> Direção: `move_e`, **perfil voltado para a direita** da tela.
> Identidade: drow, **cabelo branco longo**, pele cinza-azulada, **armadura negra laminada** com ombreiras de espinhos, faixa vinho no cinto, pendente azul, **espada de lâmina azul-gelo na mão esquerda**.
> Quadros: tabela de **andar** da §5.
> Proibido: §4.

## 11. Aberto para decisão (G-D1, G-D2 e G-D3)

1. **Ritmo por herói** (§2): adotar a fórmula, ou manter 10 fps e baixar a exigência (menos fiel ao chão).
2. **Escala de entrega** de Zynara e Nyrelia (§3).
3. **Mão da arma** (§7).
4. **Quantos quadros por ciclo:** 6 (mantém o runtime) ou 8 (mais suave, pede mudança de código nos contadores de quadros).
