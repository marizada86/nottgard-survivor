---
id: "AVALIACAO-playtest-t05-mariz-v040-2026-10-14"
title: "Avaliação do playtest do Mariz (T05, v0.4.0)"
created: "2026-10-14"
status: "DRAFT: L1 a L4 implementados e commitados local (EVID-253 a EVID-256); L5 e L6 aguardam decisão do dono"
content_state: DRAFT
relations: ["[[EVID-250-relato-t05-mariz-v040-2026-10-14]]", "[[EVID-252-avaliacao-medida-do-relatorio-t05-mariz-2026-10-14]]", "[[EVID-251-bug-044-e-bug-045-volume-e-tela-de-resultado-2026-10-14]]", "[[PLAN-103-demo-completa-e-polida-2026-10-14]]"]
---

# Avaliação do playtest do Mariz (v0.4.0)

Base: o relatório (EVID-250), a leitura do código e dos dados, quatro sondas e duas capturas em janela real (EVID-252). Onde eu medi está dito; onde é só leitura de código ou hipótese, também.

## 1. Veredito

O relatório é bom e **a maior parte é verdade, com causa que dá para apontar**. Três coisas se destacam:

1. **A "habilidade que não evolui" é, em boa parte, um bloqueio de regra**, não só falta de empolgação. A arma inicial só evolui com uma passiva específica, e as passivas têm 5 espaços entre 14. Sem sorte ou atenção, a evolução fica **impossível** (na sonda, 95% a 99% das runs aleatórias nunca evoluíram a arma inicial até o nível 25). No print do Mariz a Espada Sombria estava no Nv 5 sem a Cota de Malha e com os 5 espaços cheios. Isso é a queixa 7 do relatório, e é mais grave do que ela imagina.
2. **Os chefes são curtos por desenho do diretor**, não só por números: quando o chefe nasce, as ondas acabam e só entra 1 inimigo a cada 3,5 s. Todos usam os mesmos 6 verbos e as mesmas 2 fases (70% e 35%); 7 de 9 nem têm tela de abertura.
3. **O feedback de combate é plano em tudo**: número de 14 px, som do acerto a -14 dB, e todos os 350 efeitos sonoros no mesmo nível (~-14 dBFS). Não há hierarquia entre um golpe fraco, um crítico e um chefe caindo.

Não é verdade, ou não confirmei, que "o chefe cai parado" **em geral**: sem defesa o herói parado morre em 2 a 12 s em todos os chefes; só o primeiro cai para um herói forte (EVID-252 §4.3). Isso fecha com o relato do primeiro chefe e **não** com "chefes são fáceis".

## 2. Quadro por item

Legenda: ✅ feito (EVID-251) · 🔧 já em curso no PLAN-103 · 🆕 novo · ❓ falta dado

| # | Item do relatório | Veredito | Evidência | Proposta | Esforço |
|---|---|---|---|---|---|
| 1 | Volume | ✅ real, corrigido | `apply_settings` reaplicava a janela a cada passo | feito; conferir em tela cheia | — |
| 2 | 1º slot da ficha | ❓ não reproduzido | 4 abas e 9 itens do HUD fotografados | pedir o Print 1 e a resolução | — |
| 3 | Monstros presos | ❓ provavelmente atiradores `keep` | 0 perseguidores presos; todos os presos são `keep` | marcar visualmente quem "mantém distância" (§3.4) | baixo |
| 4 | Tela de morte | ✅ real, corrigido | print + código; captura nova | feito | — |
| 5 | Durvall anda com uma perna | 🔧 BUG-028/M1 | piloto v03 aprovado | seguir M1 | em curso |
| 6 | Fluxo inicial | 🆕 baixa | decisão de projeto | M3 | baixo |
| 7 | Mensagem de coleta | ❓ 3 candidatos | sem print | perguntar qual objeto | baixo |
| 8 | Ordem dos itens | 🆕 real | novo vem sempre primeiro | §3.5 | baixo |
| 9 | Avisos de missão no topo | 🔧 parcial | questlog já foi à direita | confirmar qual aviso | baixo |
| 10 | Iluminação uniforme | 🔧 R5-C/D | proposta aguarda G-M2-3 | decidir R5 | médio |
| 11 | Névoa/borda fraca | 🆕 | 3% a 9%/s, regen compensa | §3.6 | baixo |
| 12 | Dano e impacto | 🔧 R5-B + 🆕 | 14 px; -14 dB; hit-stop só crítico | §3.3 | médio |
| 13 | Inimigos parecidos / tentáculo | 🆕 | 2 movimentos em 40 tipos | §3.4 | médio/alto |
| 14 | Poças | 🆕 | dano fixo `2 + tier` | §3.6 | baixo |
| 15 | 1º chefe fácil | 🆕 real só para build forte | cai em 11 s, herói perde 35% | §3.2 | baixo |
| 16 | Guardião Alado maior | 🆕 real | escala 1,3, a menor; sem intro | §3.2 | baixíssimo |
| 17 | Chefes iguais | 🆕 real | 6 verbos, 2 fases iguais | §3.2 e M4a | alto |
| 18 | Elites sem comportamento | 🆕 real | afixos de número nas 2 primeiras fases | §3.4 | médio |
| 19 | Habilidade sem evolução | 🆕 **o mais forte** | §3.1 | §3.1 | baixo a médio |
| 20 | Sons cômicos | 🆕 plausível | tudo no mesmo nível | §3.3 | médio |

## 3. Detalhe e propostas

### 3.1 Progressão: tornar a evolução alcançável e visível (itens 19 e 12)

**O problema, em três camadas**
1. *Alcançável:* 14 passivas, 5 espaços; a evolução da arma inicial exige 1 delas. Sem prioridade, 95% a 99% das runs não evoluem até o nível 25; com um jogador atento, 21% a 43%.
2. *Visível:* o requisito só aparece na dica da oferta "arma → Nv N" e na ficha C. Na HUD (lista do canto) a arma aparece como "Espada Sombria Nv 5", sem dizer que falta algo.
3. *Ativa (Q/RMB):* 1 definição fixa por herói; só a recarga muda. O jogador espera "melhorar ou ganhar uma ultimate".

**Opções**
| | O que muda | Prós | Contras |
|---|---|---|---|
| A | A passiva exigida pela arma no nível máximo **ignora o teto de 5** (6º espaço só para ela) e entra na oferta com peso alto | mexe em 1 regra e 1 peso; resolve o bloqueio | passiva "grátis" altera o equilíbrio por herói |
| B | A passiva exigida é **garantida** na próxima oferta quando a arma chega ao nível máximo | simples de explicar; mantém o teto | pode tirar uma escolha do jogador |
| C | Marcar na HUD: "Espada Sombria Nv 5 · falta Cota de Malha" e um aviso ao chegar ao Nv 5 | resolve a invisibilidade, sem balanço | não resolve o bloqueio sozinha |
| D | **Aprimoramentos da habilidade ativa** no level-up (ex.: níveis 10, 20 e 30, 3 degraus: alcance, recarga, efeito extra) | dá a "evolução" que o Mariz pede | conteúdo novo para 12 heróis; é M4b |
| E | Ultimate por herói (bloqueada até o nível 25) | resposta literal ao pedido | maior; precisa de design por herói |

**Recomendação:** **A + C agora** (cartão MEC-070, código e testes, sem arte nova), e **D como proposta do M4b** com 1 herói piloto. E só depois de D provar valor. Verificar com a sonda `tools/probe_evolution_odds.gd` (alvo: política "aleatória" evoluindo em 60% ou mais até o nível 20 e a "atenta" em 85% ou mais).

### 3.2 Chefes: luta, presença e variedade (itens 15 a 17)

**Rápido, só dados e uma regra (baixíssimo risco)**
- **Guardião Alado:** `scale` 1,3 → 2,0 (hoje é o menor dos 11 chefes e o segundo da campanha) e criar a imagem de abertura (hoje vazia). *1 número + 1 arte já planejada pelo padrão dos outros.*
- **Apresentação dos 7 chefes sem tela:** título e subtítulo no mínimo (texto), a imagem entra no M5.
- **Campo vivo durante o chefe:** em vez do "pinga-pinga" de 1 inimigo a cada 3,5 s, manter 30% a 50% do ritmo da última onda enquanto o chefe vive, respeitando o teto. Faz a luta ter ritmo e dá motivo para andar.

**Médio**
- **PV do chefe acompanhar o poder do herói:** o escalonamento está zerado no código (`0.3 * tier() * 0.0`). Proposta: multiplicar por um fator do nível do herói e do dano por segundo medido (teto de +60%), assim o primeiro chefe não cai em 11 s para um herói forte e continua justo para o novato (a camada "nenhuma" da sonda morre em 9 s sem defesa, então o piso de dificuldade já existe).

**Alto (já é o M4a do plano)**
- **1 mecânica própria por chefe**, em vez de combinar os mesmos 6 verbos. Rascunho para o M4a, **sem canon, para você escolher**: Sacerdote (turíbulos que curam o chefe e precisam ser quebrados), Guardião Alado (voo em investidas em linha com aviso longo), Zuggtmoy (zonas de esporo que tomam o mapa em quadrantes), Blogbog (divide-se ao perder PV e as partes se reúnem), Molydeus (jaulas que prendem o herói por 2 s se ele ficar parado), e assim por diante. **Preciso da lore do Vault por chefe antes de especificar**; respeitando as "seções de cânone do mestre" como segredo.
- **Fases 70% e 35% diferentes entre si**, hoje todas são "invoca/faz anel/enfurece".

### 3.3 Impacto e áudio (itens 12 e 20)

Complementa a proposta R5 do M2 (que já tem R5-B: 14 → 16 e 22 → 26). Minha leitura é que isso é **pouco**: 16 px continua pequeno numa tela de 1280×720.

| Camada | Proposta | Verificável por mim |
|---|---|---|
| Número | 3 faixas por % do PV do alvo: pequeno (< 5%), médio, grande (≥ 20% ou crítico) com tamanho 14 / 20 / 28, cor e um "pop" maior; fundir acertos só até 120 ms | sim (teste e captura) |
| Hit-stop | também em elite e chefe, 0,03 s a 0,06 s; respeita "Impacto reduzido" | sim |
| Reação | recuo curto do inimigo no acerto forte (empurrão de 0,15 tile) | sim |
| Som | **dinâmica**: crítico e golpe forte +4 a +6 dB sobre o comum; avaliar um som de queda para elite (o chefe já tem `boss.*.defeat`, mas os 59 arquivos de chefe têm todos 1,25 s e o mesmo nível) | parcial: nível e duração sim, **timbre é seu** |
| Peso do som | filtro grave (low-shelf) e cauda mais longa nos acertos grandes, por pitch e filtro no manifesto (sem arquivo novo), no mesmo mecanismo do F-6 | parcial |

**Atenção:** você **recusou o F-4/F-5 hoje** (sem prompts de SFX por ora). Este item **não os reabre**: usa só nível, pitch e filtro de arquivos já existentes. Sons novos de verdade ficam como decisão sua.

### 3.4 Variedade de inimigos e elites (itens 3, 13 e 18)

- **O tentáculo:** é o caso mais barato e mais citado. Ele tem golpe em área (aviso de 0,9 s, raio 1,5), mas não é lido como ataque. Proposta: telégrafo longo, bem visível (anel que enche e cor própria) e animação de golpe; avaliar um 2º ataque (varredura em linha).
- **Atiradores que mantêm distância** passam por "presos". Proposta: pequeno indicador (a cor do aro na base ou uma animação de "armar") para ensinar que parados é intencional; e fazê-los **reposicionar** (strafe) em vez de ficarem estáticos.
- **Novos movimentos** (hoje 2 em 40): `charge` (investida em linha com aviso) já existe como habilidade em 8 tipos, mas não como *movimento*; propor `flank` (cerca o herói), `ambush` (espera escondido), `swarm` (grupo que se move junto). Um por fase de 2 a 4, a começar pelas que hoje só têm perseguidores (Dagruve, Durao, Shendilavri).
- **Elites com um traço próprio já nas duas primeiras fases:** os 4 afixos de Dagruve/Docas (veloz, resistente, mortal, avaro) são só número. Propor que `explosivo` e `escudeiro` entrem na fase 1 e 2 de forma leve.
- **Reflexo:** além de desviar de círculos, 1 ataque por fase com **janela curta** (0,5 s) e **direcional**, que ensine esquiva de verdade.

Isso é o conteúdo do M4a e M4d; **a proposta por frente com teto de 2 mecânicas** (D6 do plano) cobre isto.

### 3.5 Itens e mensagens (itens 7 e 8)

- **Troca de item:** manter "Equipar o novo" e "Manter o atual" em posição **fixa** (ex.: o atual à esquerda, o novo à direita), colocar o selo de veredito (melhor / pior / igual) bem visível, e o foco inicial no que for **melhor**; ou, no mínimo, deixar o foco em "Manter" quando o selo é "pior". Hoje o novo é sempre o primeiro e fica em foco. *Baixo esforço, com teste.*
- **Mensagem de coleta:** preciso saber qual objeto era (item de baú, fonte, poção?). Hipótese mais forte: o painel de 1 opção "Equipar X" do BUG-031, que **pausa e espera um clique** por decisão do dono em 2026-10-06. Se for isso, proponho trocar a janela por um aviso sem pausa e equipar sozinho quando o item é melhor.

### 3.6 Névoa, poças e dificuldade (itens 11, 14 e 15)

- **Poça:** `2 + tier` fixo por 0,9 s. Proposta: parte fixa + 1,5% do PV máximo por tique, e **sem regeneração enquanto dentro** (efeito legível: "Corroído"). Assim a poça continua relevante no nível 28.
- **Névoa de borda:** a regeneração e a cura anulam 3% a 9%/s. Proposta: **suprimir regeneração e cura passiva dentro da faixa** (mantém poção e bênção ativa) e subir a rampa final de 9% para 12%. Medir com `bot_curva` (EVID-225) para não punir só o veterano (BAL-028).
- **Dificuldade para jogador forte:** o relato do Mariz soma-se a Daniel (IN-049), Manzi (IN-057) e ao dono (BAL-001): **"fácil demais" já tem 4 relatos independentes**. A dificuldade como um todo é **BAL-001/BAL-016/MEC-040 (Marcas do Abismo)**; sugiro a decisão de que o *modo padrão* pode ficar como está (acessível) e que a pressão para o forte venha das **Marcas e da profundidade**, que já existem e já recompensam. Um dado a pedir ao Mariz: se ele usou Marcas do Abismo ou profundidade 0.

## 4. Ordem de trabalho sugerida

| Lote | Conteúdo | Tipo | Risco | Depende de |
|---|---|---|---|---|
| L1 | Evolução alcançável e visível (§3.1 A+C); troca de item (§3.5); Guardião Alado maior e aberturas (§3.2 rápido) | código e dados, sem arte nova | baixo | nada |
| L2 | Campo vivo durante o chefe; PV do chefe com o poder do herói; poça e névoa (§3.2, §3.6) | balanceamento | médio | rodar `bot_curva` antes e depois |
| L3 | Impacto: faixas de número, hit-stop, dinâmica de som (§3.3) | game feel | baixo/médio | decisão sobre R5-B (M2) |
| L4 | Tentáculo, atiradores legíveis, 2 movimentos novos (§3.4) | mecânica | médio | M4d |
| L5 | Chefes: 1 mecânica própria por chefe, fases distintas (§3.2) | mecânica | alto | lore do Vault; M4a |
| L6 | Aprimoramento da ativa (§3.1 D) | mecânica | médio | piloto em 1 herói; M4b |

L1 e L2 cabem no que o B-001 (M0, base e validação contínua) do PLAN-103 já prevê; L3 conversa com o B-003 (M2); L4 a L6 são B-005 (M4) e exigem proposta por frente.

## 5. O que preciso de você

1. **Aprova L1 como lote próprio?** (código e testes, sem commit; aprovação por plano.)
2. **Opção para a evolução:** A (6º espaço só para a passiva da evolução), B (oferta garantida) ou A+B. Recomendo A + C.
3. **Chefe com poder do herói** (§3.2): quer que o PV do chefe acompanhe o poder do herói? É decisão de design, não só de número.
4. **Reabrir o F-4/F-5 (SFX novos)?** O relato do Mariz é o primeiro sobre o tom. Eu sugiro **não** por enquanto (§3.3 usa só nível, pitch e filtro).
5. **Para o Mariz:** (a) o Print 1 e a resolução da janela; (b) o mapa onde viu monstros presos; (c) qual objeto gerou "mensagem que espera interação"; (d) se estava com Marcas do Abismo ou profundidade 0; (e) o `evidencias/relato.txt` e o `jogo.log` da partida (para conferir a build e o hash).

## 6. Limites desta avaliação

- Sondas em **HEAD**, não na build 0.4.0 do Mariz; headless, sem renderização; herói sem equipamento (chefe) ou sem combate (evolução).
- Cenário "herói parado" não representa quem se move; os números dizem o que é **possível**, não o que o Mariz viveu.
- Som: medi nível, duração e brilho. **Não ouvi** o que o Mariz achou cômico.
- Nada aqui é canon. Propostas de chefe (§3.2) são rascunho e não consultam o Vault.
