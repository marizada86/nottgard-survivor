---
id: "PLAN-052"
title: "Padrão de qualidade do balanceamento dos heróis"
status: "decisões registradas em 2026-10-02; EXECUÇÃO ADIADA para depois do próximo playtest humano (ordem do dono, 2026-10-02)"
created: "2026-10-02"
relations: ["[[EVID-143-bot-travado-em-item-offer-e-chefe-das-docas-2026-10-01]]", "[[EVID-144-varredura-do-bot-corrigido-dagruve-docas-2026-10-01]]"]
---

# PLAN-052 — Padrão de qualidade do balanceamento dos heróis

Resultado da entrevista com o dono em 2026-10-02. Este documento é a régua: todo ajuste de herói (BAL-nnn) se mede contra ele.

## Decisões do dono
| # | Tema | Decisão |
|---|---|---|
| D1 | Piso inicial | Nenhum herói passa de **30 %** de mortes nos primeiros 2:30 de Dagruve (bot) |
| D2 | Distância entre heróis | Diferença entre o mais forte e o mais fraco na vitória do chefe de Dagruve: **até ~40 pontos** |
| D3 | Desbloqueio | Heróis de desbloqueio **um pouco mais fortes** que os iniciais; os iniciais continuam competitivos |
| D4 | Fim da run | Herói de início difícil deve ter **teto mais alto** que os estáveis (quem engrena chega mais longe) |
| D5 | Alavancas permitidas | **PV base, CA e passiva** do herói. Arma inicial, habilidade ativa e dados globais ficam fora sem nova decisão |
| D6 | Identidade | Cada herói tem **ficha de papel** (abaixo); ajuste nenhum pode apagar o papel |
| D7 | Medição | **Bot como alarme, playtest humano decide.** Mudança só se firma depois de feedback humano |
| D8 | Alcance | **Dagruve e Docas** por enquanto |

Diretriz anterior mantida: diversidade vale mais que igualdade; um herói pior no começo e melhor no fim é desejado.

## Métricas e limiares (bot corrigido, 30 sementes, `tools/overnight.ps1`)
- **Morte inicial:** runs que morrem antes de 150 s em Dagruve. Alvo ≤ 30 % (erro de ~8 pontos; só agir acima de ~38 %).
- **Vitória em Dagruve:** runs que derrotam o Sacerdote. A distância entre o maior e o menor valor ≤ 40 pontos.
- **Vitória nas Docas** (entrando por Dagruve): mesma lógica.
- **Teto (D4):** profundidade/nível das runs que engrenam. Ainda **não medido por herói**; precisa de uma métrica de "fases alcançadas" na varredura longa (3 fases).
- Alarme: qualquer herói fora do limiar abre um cartão BAL. Mudanças de uma só passada nunca passam de 2 alavancas por herói.

## Situação atual contra o padrão (EVID-144, depois dos ajustes de 2026-10-02)
| Herói | Origem | Morte inicial | Vitória em Dagruve | Observação |
|---|---|---:|---:|---|
| Korrak | desbloqueio | 0 % | 100 % | topo |
| Bromnor | desbloqueio | 0 % | 97 % | topo |
| Maelor | **inicial** | 7 % | 93 % | **viola D3**: inicial mais forte que Leoric, Nyrelia e Zynara (desbloqueio) |
| Brook | inicial | 10 % | 77 % | ok |
| Sylas | inicial | 23 % | 73 % | ok |
| Zynara | desbloqueio | 23 % | 66 % | ok |
| Leoric | desbloqueio | 30 % | 63 % | no limite |
| Nyrelia | desbloqueio | 13 % | 60 % | ok |
| Durvall | inicial | 20 % | 46 % | ok |
| Kayron | inicial | 33 % | 40 % | **viola D2**: 60 pontos abaixo do Korrak |

Desvios do padrão: **D2** (Korrak 100 % contra Kayron 40 %, distância 60) e **D3** (Maelor, inicial, passa de três heróis de desbloqueio). **D4** ainda sem medição.

## Fichas de papel (rascunho para aprovação do dono)
Cada ficha: papel, ponto forte, ponto fraco, faixa-alvo (morte inicial / vitória em Dagruve). Os papéis abaixo saem dos dados atuais (arma, ativa, passiva); o dono corrige o que não bater.

| Herói | Papel | Ponto forte | Ponto fraco | Faixa-alvo |
|---|---|---|---|---|
| Brook | Tanque paladino | CA 5, −1 de dano recebido, nova de 2d6, escudo ativo | Dano baixo no fim; lento para limpar horda | 5–15 % / 70–80 % |
| Durvall | Duelista ferido | Melee forte; +25 % de dano abaixo de 50 % de PV | Precisa estar perto; arrisca vida de propósito | 15–25 % / 45–60 % |
| Maelor | Curandeiro de apoio | Cura contínua (+0,6 PV/s) e aura ativa | Dano baixo; depende do regen | 5–15 % / 70–85 % |
| Sylas | Debuff e isca | Raio que reduz CA, cópia-isca que explode | Frágil de CA; dano individual baixo | 15–25 % / 60–75 % |
| Kayron | Canhão de vidro | Nova de 2d6 com −18 % de recarga e +20 % de dano | Pouca defesa; precisa de espaço | 25–35 % / 45–60 % |
| Korrak | Bruto de desbloqueio | +20 % de dano, 40 PV, machado e impacto | −10 % de velocidade | 0–10 % / 85–95 % |
| Bromnor | Tanque de desbloqueio | 42 PV, CA 5, −2 de dano, martelo 2d8 | Lento (cd 2,6) | 0–10 % / 85–95 % |
| Leoric | Controle de área | Nova de slow, coleta e área +25 %, constelação | Dano por acerto baixo; recarga longa | 25–30 % / 60–70 % |
| Nyrelia | Controle e economia | Domina inimigos; +10 % de moedas e XP | Dano de projétil baixo; fraca sem nível acumulado | 10–20 % / 60–70 % |
| Zynara | Controle de tempo | Para o tempo, +1 opção por level-up | Frágil no começo, escala com escolhas | 20–30 % / 60–70 % |

## Próximos passos

> **Adiado por ordem do dono (2026-10-02):** nenhum destes passos roda antes do próximo playtest humano. Depois dele, retomar do passo 1 com o feedback em mãos.
1. Dono aprova ou corrige as fichas.
2. Corrigir **D2** (Kayron sobe um pouco, Korrak ou Bromnor descem um pouco) e **D3** (Maelor desce ou os desbloqueios sobem), com as alavancas permitidas.
3. Acrescentar à varredura longa a métrica de teto por herói (D4).
4. Rodar a varredura completa de novo (≈ 6 h) e abrir/fechar cartões BAL contra esta régua.
5. Playtest humano confirma (D7) antes de fechar BAL-015.
