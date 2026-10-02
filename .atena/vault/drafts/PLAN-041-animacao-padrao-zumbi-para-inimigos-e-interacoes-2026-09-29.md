---
id: "PLAN-041"
title: "Animação no padrão Zumbi para todos os inimigos, baús e interações"
status: "decisões D-A1 a D-A6 aprovadas em 2026-09-29; piloto preparado (ART-PROMPTS-031 e CHATGPT-FILA-004); nada gerado nem implementado"
created: "2026-09-29"
relations:
  - "[[SPEC-061-preparacao-da-regeneracao-do-piloto-de-zumbi]]"
  - "[[EVID-104-zumbi-admissao-2026-09-29]]"
  - "[[SPEC-062-fila-de-geracao-externa-de-assets]]"
  - "[[CHATGPT-PROMPTS-ZUMBI-V01]]"
---

# PLAN-041 — Animação no padrão Zumbi

## Pedido do dono

O Zumbi ficou ótimo. Elaborar um plano para que **todos os inimigos** (e os
baús abrindo e outras interações) sigam esse padrão de qualidade de
animação e movimento, com prompts para o ChatGPT, mantendo a simplicidade.

## Diagnóstico (medido no projeto em 2026-09-29)

### Inimigos

`data/enemies.json` tem 59 entradas. Só **2** têm animação: Zumbi (20 quadros) e
Sacerdote da Mente Derretida (54 quadros). Os outros **47** ainda são uma
imagem estática, e os 10 quebráveis também.

| Categoria | Total | Animados | A fazer |
|---|---:|---:|---:|
| Comuns | 33 | 1 (Zumbi) | 32 |
| Elites | 7 | 0 | 7 |
| Chefes | 9 | 1 (Sacerdote) | 8 |
| Quebráveis | 10 | 0 | 10 |

Todas as artes estáticas foram feitas em tela 320×480 (2:3) e o jogo usa
`H_BASE × escala ÷ altura da célula` para dimensionar (`ui/enemy_view.gd`).

### Interações (qualidade medida por solidez de opacidade)

Solidez = fração dos pixels visíveis com alfa ≥ 0,9. O Zumbi novo tem **97 %**,
a arte estática do inimigo comum **97 %**, o Sacerdote **88 %**.

| Animação existente | Solidez | Leitura |
|---|---:|---|
| `chest_open` (baú abrindo, 6 quadros) | **43 %** | fraca: mesma classe de defeito do Leoric/Zumbi antigos |
| `altar_active` | **39 %** | fraca (é objeto, não efeito) |
| `portal` | 49 % | efeito; translucidez parcialmente esperada |
| `ritual` | 56 % | efeito; idem |
| `fountain_active` | 70 % | aceitável |

O baú fechado (`chest_closed`) tem 99 %. Ou seja: o **baú abrindo destoa do
resto** e é o primeiro candidato de qualidade. O baú de chefe (Lote 1) hoje não
tem animação própria e reutiliza `chest_open`.

## O que fez o Zumbi ficar bom (a receita a preservar)

1. **Vista 3/4 frontal** e movimento **sutil** (balanço, troca de peso). Sem
   perfil lateral, sem espelhamento e sem exigir direções diferentes.
2. **Um quadro de identidade aprovado primeiro** (`idle` 00); os outros 19
   nascem dele, na mesma conversa.
3. **Cada quadro é uma imagem independente** com cobertura **sólida**, fundo
   liso de cor única, base do personagem no rodapé.
4. **Montagem por script** (`tools/build_zumbi_candidate_strips.ps1`): recorta pelo
   alfa, ajusta ao tamanho da célula, ancora pela base, margem de 8 px.
5. **Aprovação humana numa prancha** (EVID-103) e admissão com backup (EVID-104).
6. **Contrato de quadros fixo**: idle 4, move 6, attack 4, death 6 (20).

Ressalva conhecida: a confirmação **em run real** ainda está pendente (BUG-001).
Este plano corrige isso tornando a run real parte do critério de aceite.

## Padrão proposto (v1)

### Célula

Todas as celas são 2:3, como a arte estática. **256×384** para comuns e elites
(igual ao Zumbi) e **320×480** para chefes (igual ao Sacerdote).

### Perfis de animação

| Perfil | Quem | Estados (quadros) | Total |
|---|---|---|---:|
| **A — Padrão Zumbi** | comuns e elites que andam | idle 4, move 6, attack 4, death 6 | 20 |
| **B — Chefe** | 8 chefes | perfil A + `special` 6 (habilidade de assinatura) | 26 |
| **C — Estático** | Tentáculo do Kraken (velocidade 0) | idle 4, attack 4, death 6 | 14 |
| **D — Quebrável** | 10 quebráveis | arte estática atual + `death` 5 (romper) | 5 |
| **E — Interação** | baús, NPCs, altar | por caso (ver abaixo) | 4–6 |

Regra de simplicidade: **habilidades à distância, de área e de invocação
reutilizam o estado `attack`** (o jogo já cai em `attack` quando não existe o
estado pedido). Só chefes ganham um `special` extra. O Sacerdote fica como está
(7 estados).

### Direção e pernas (acréscimo do dono em D-A3)

O dono pediu o **básico de movimento de pernas e de virar para a esquerda e
para a direita**. Regra adotada (mesma lógica de EVID-029 dos heróis):

- A arte-base é gerada **voltada para a direita**, com pernas e botas **visíveis e
  alternando** no `move`.
- O jogo espelha (`flip_h`) quando o inimigo anda para a esquerda. Idle, attack e
  death não são espelhados por esta regra.
- Cada inimigo declara a direção-base no dado (`data/enemy_animations.json`); o
  Zumbi atual precisa ter a sua confirmada (a arte parece virada para a esquerda).
- Direções norte/sul e as oito direções dos heróis **ficam fora** do básico.

### Contrato de qualidade (critérios de aceite por inimigo)

1. Cada quadro é RGBA da célula certa, base ancorada, margem lateral ≥ 8 px.
2. **Solidez ≥ 0,90** (mínimo absoluto 0,79 para cores translúcidas por design,
   como fantasmas e ilusões), medida com `tools/audit_alpha_solidity.gd`.
3. Identidade igual à arte estática oficial (`assets/enemies/<id>.png`): cabelo,
   roupa, cor, silhueta e escala.
4. Sem pulos de escala entre quadros do mesmo estado (verificado na prancha).
5. **Verificado numa run real em movimento**, e não só na prancha.
6. Nenhum arquivo oficial é substituído sem aprovação explícita e sem backup.

## Como gerar com o ChatGPT

### Referências a anexar em toda mensagem

- a arte estática oficial `assets/enemies/<id>.png` (identidade e cores);
- o quadro de identidade já aprovado (a partir do 2º quadro);
- para calibrar a qualidade: um quadro do Zumbi (`assets/animations/enemies/zumbi/idle.png`).

### Dois métodos (decidir por um piloto)

| | Método 1 — quadro a quadro | Método 2 — fileira por estado |
|---|---|---|
| O que é | 1 imagem por quadro (como o Zumbi) | 1 imagem com todos os quadros do estado lado a lado |
| Imagens por inimigo (perfil A) | 20 | 4 |
| Consistência | média (o ChatGPT reinventa entre mensagens) | **melhor** (mesmo contexto na mesma imagem) |
| Risco | trabalho manual e volume | quadros colados ou desalinhados; exige recorte automático |
| Montagem | script atual | script novo com **detecção de figuras por espaço vazio** |

**Recomendação:** rodar um piloto com um inimigo simples em **ambos** os
métodos e comparar com a régua do Zumbi. O método 2 reduz a remessa de ~1 050
para ~210 imagens (ver orçamento), então vale o teste.

### Modelos de prompt (a preencher por inimigo)

Bloco fixo (estilo): *Dark-fantasy isometric pixel-art game character, viewed from a
three-quarter frontal angle tilted about 30 degrees from above, soft light from
the upper left, crisp pixel-art rendering with controlled dithering, no blur.*
Restrições fixas: *Background: a single flat solid magenta color (#FF00FF), no
ground, cast shadow, gradient or scenery. No text, logo, watermark, frame or UI.
Feet at the bottom of the frame with roughly 8% side margin. The whole silhouette
is solid and fully opaque — no translucent, ghostly or speckled areas.*
(O ciano `#00FFFF` substitui o magenta em criaturas magenta, roxas ou vinho.)

- **Identidade:** `[descrição curta do inimigo, da arte estática]` + pose parada neutra.
- **Idle (4):** parado; leve balanço; mudança de peso; retorno.
- **Move (6):** contato do pé; transferência de peso; passada; novo contato; transferência; fechamento.
- **Attack (4):** preparo; início do golpe; ponto de impacto; recuperação. A pose do golpe
  varia por tipo: **corpo a corpo** (investida/mordida), **arco** (puxar e soltar),
  **cajado** (erguer e lançar), **investida** (cabeça baixa, corrida), **invocação**
  (braços abertos), **poça/ácido** (cuspir ou verter).
- **Death (6):** impacto; joelhos dobram; queda parcial; semi-caído; colapso; imóvel.
- **Special (chefes, 6):** a habilidade de assinatura (ex.: círculo de anéis, invocação, sopro).

Para o método 2, o mesmo texto vira "N quadros da mesma figura, lado a lado, em
uma faixa horizontal, com espaço vazio entre eles, mesma escala e mesma linha de
chão" (N = 4 ou 6).

## Reuso para cortar custo (decisão do dono)

Quatro entradas são, por conceito, derivadas de outra. Podem **reaproveitar a
animação do original** com o ajuste de escala e de transparência que o jogo já
aplica, economizando ~100 quadros:

| Derivado | Original | Justificativa |
|---|---|---|
| `guardiao_copia` | `guardiao_verdadeiro` | é literalmente a cópia (Sessão 2) |
| `ilusao_de_sucubo` | `sucubo` | já roda com alfa 0,45 (`illusory`) |
| `ilusao_de_socothbenoth` | `cultista_de_socothbenoth` ou `socothbenoth` | idem |
| `molydeus_menor` | `molydeus_chefe` | versão menor; escala 1,6 contra 1,9 |

## Orçamento

Sem reuso, com as 47 entradas que faltam:

| Item | Entradas | Método 1 (quadros) | Método 2 (imagens) |
|---|---:|---:|---:|
| Comuns (perfil A) | 32 | 640 | 128 |
| Elites | 6 perfil A + Kraken (C) | 120 + 14 = 134 | 24 + 3 = 27 |
| Chefes (perfil B) | 8 | 208 | 40 |
| Quebráveis (perfil D) | 10 | 50 | 10 |
| Interações | ~6 | ~36 | ~6 |
| **Total** | | **~1 070** | **~210** |

Com o reuso da tabela acima: **~100 quadros a menos no método 1** e
**~16 imagens a menos no método 2**.

## Interações (baús e afins)

| Item | Estado hoje | Proposta |
|---|---|---|
| **Baú abrindo** (`chest_open`) | 6 quadros, solidez 43 % | **Regerar**, 6 quadros: fechado, destrava, tampa levanta, abre, brilho, aberto |
| **Baú de chefe** (Lote 1) | reutiliza o baú comum | 6 quadros próprios, mesmo modelo |
| **Altar ativo** | 6 quadros, solidez 39 % | Regerar, 6 quadros, objeto sólido com brilho separado |
| **Loja, ferreiro, curandeiro** (Lote 1, estáticos) | sem animação | `idle` 4 quadros cada (respiração, martelo, vapor) |
| **Mímico** (inimigo de baú) | estático | Perfil A; ligar a abertura do baú |
| Portal, ritual, fonte | efeitos, solidez 49–70 % | Manter; regerar só se a run real mostrar falha |

Dependência: o baú de chefe e os NPCs precisam antes da **admissão do Lote 1**.

## Ondas de produção

Ordem pela exposição do jogador (fases iniciais primeiro):

| Onda | O que | Inimigos novos |
|---|---|---:|
| **0 — Piloto** | comparar método 1 e 2 em um inimigo simples | 1 |
| **1 — Dagruve e Docas** | slime_corrosivo, cultista_adaga, cultista_arqueiro, cultista_cajado, notivago, criatura_corrompida, guardiao_copia, arch_hag, tentaculo_kraken, guardiao_verdadeiro (chefe) | 10 |
| **2 — Interações e quebráveis** | baús, altar, NPCs, mímico, 10 quebráveis | 11 |
| **3 — Shedaklah e Molor** | servo_de_zuggtmoy, cogumelo_fungico, esporo_voador, slime_de_juiblex, pudim_negro, gargula, receptaculo_de_juiblex, zuggtmoy, bolha_de_slime, cultista_thullgrime, blogbog | 11 |
| **4 — Durao e Feng-tu** | alma_penada, demonio_de_gehenna, carcereiro_de_pedra, aberracao_shu, ezro, molydeus_menor, molydeus_chefe, larva_de_lu_yueh, cultista_de_feng_tu, estatua_do_templo, cultista_ghaunadaur, discipulo_pestilento, lu_yueh | 13 |
| **5 — Shendilavri, Goranthis e Pilares** | escravo_de_rivenheart, sucubo, ilusao_de_sucubo, guarda_do_castelo, master_of_cruelties, malcanthet, ilusao_de_socothbenoth, guardiao_de_goranthis, cultista_de_socothbenoth, death_tyrant, socothbenoth, sintese_abissal | 12 |

Cada onda vira **um** `ART-PROMPTS-NNN` e **uma** fila `CHATGPT-FILA-NNN`, como
foi feito com as HQs, para nunca misturar remessas.

## Ferramentas e código (trabalho técnico separado)

1. **`tools/build_enemy_strips.ps1`**: generaliza o script do Zumbi, lê um
   manifesto por inimigo, aceita quadros avulsos (método 1) e fileiras (método 2,
   com detecção por espaço vazio), ancora pela base e gera o relatório.
2. **`tools/check_candidates.ps1`**: acrescentar a checagem de solidez e de
   consistência de escala por estado.
3. **`ui/enemy_view.gd`**: hoje o dicionário `ANIMATED` está no código. Mover para
   `data/enemy_animations.json`, para que **acrescentar um inimigo seja só uma
   linha de dados**, e mapear as habilidades (`shoot`, `aoe`, `summon`, `charge`)
   para `attack` ou `special`. Isso é **mecânica/técnica**, com spec própria,
   testes e commit separado da arte.
4. **Quebráveis**: tocar `death` quando o objeto é destruído (hoje some).
5. **Facing**: o padrão frontal dispensa espelhamento; se a run real mostrar
   personagens andando "de lado errado", avaliar `flip_h` por direção, como nos heróis.

## Riscos

- **Consistência** entre mensagens do ChatGPT (maior risco): mitigada por
  identidade primeiro, anexar a arte estática e a régua do Zumbi, e o método 2.
- **Volume**: mitigado por reuso, método 2 e ondas.
- **Criaturas baixas e largas** (slimes, bolhas, cogumelo, pudim, tentáculo):
  o ajuste por altura pode encolher ou esticar a figura. Prompt pede "figura alta
  na composição" ou usa escala única por inimigo; conferir na prancha.
- **Fantasmas e ilusões** têm translucidez por design (alfa 0,45 no jogo); a régua
  de solidez vale para a arte-base, não para o alfa aplicado em runtime.
- **Verificação em run real** depende de renderer com viewport (BUG-001).

## Decisões (dono, 2026-09-29): todas aprovadas

D-A1 sim (piloto `cultista_adaga` nos dois métodos) · D-A2 sim · D-A3 aprovado,
**com** movimento das pernas e virar para a esquerda e a direita (acima) · D-A4
sim · D-A5 sim · D-A6 sim. O piloto está em
[[ART-PROMPTS-031-piloto-animacao-cultista-adaga]] e
[[CHATGPT-FILA-004-piloto-cultista-adaga]]. A tabela abaixo é a proposta original.

## Proposta original das decisões

| ID | Pergunta | Recomendação |
|---|---|---|
| D-A1 | Piloto em qual inimigo, e método 1 ou 2 | Piloto com `cultista_adaga` nos dois métodos |
| D-A2 | Aprovar o perfil B (chefe = 20 + 6 `special`) | Aprovar |
| D-A3 | Aprovar o reuso das 4 derivações | Aprovar `guardiao_copia` e as duas ilusões; decidir `molydeus_menor` |
| D-A4 | Regerar `chest_open` e `altar_active` (solidez 43 % e 39 %) | Regerar já, na Onda 2 |
| D-A5 | Mover `ANIMATED` para dados (spec de integração) | Aprovar |
| D-A6 | Ordem das ondas | Onda 1 antes de tudo, por ser o que todo jogador vê |

## Próximos passos

1. Dono responde D-A1 a D-A6.
2. Escrever o prompt e a fila do **piloto** (Onda 0).
3. Rodar o piloto, comparar com a régua do Zumbi e escolher o método.
4. Escrever a Onda 1 (prompts + fila) e a spec de integração.
5. Implementar `tools/build_enemy_strips.ps1` e o `data/enemy_animations.json`.

## Gate

Proposta. Nenhum arquivo do jogo foi alterado e nenhuma imagem foi gerada.
