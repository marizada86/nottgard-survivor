---
id: "EVID-124"
type: "evidencia-de-geracao-visual"
title: "HQN-11 a HQN-14 — candidatas aprovadas"
date: "2026-09-30"
status: "concluída — 16 quadros finais aprovados explicitamente pelo dono"
relations: ["[[SPEC-098-geracao-de-hqs-trilha-b]]", "[[ART-PROMPTS-029-hqs-onda-2]]"]
---

# Resultado

Os 16 quadros de HQN-11 a HQN-14 foram gerados com a ferramenta integrada de
imagem, inspecionados e aprovados pelo dono um por vez. As candidatas finais
ficam em `.atena/generated/art-candidates/hq/`.

| HQ | Quadro | Candidata final | Decisão |
|---|---:|---|---|
| HQN-11 | Q1 | `hq_n11_q1_v01.png` | Aprovada |
| HQN-11 | Q2 | `hq_n11_q2_v01.png` | Aprovada |
| HQN-11 | Q3 | `hq_n11_q3_v01.png` | Aprovada |
| HQN-11 | Q4 | `hq_n11_q4_v01.png` | Aprovada |
| HQN-12 | Q1 | `hq_n12_q1_v01.png` | Aprovada |
| HQN-12 | Q2 | `hq_n12_q2_v01.png` | Aprovada |
| HQN-12 | Q3 | `hq_n12_q3_v01.png` | Aprovada |
| HQN-12 | Q4 | `hq_n12_q4_v01.png` | Aprovada |
| HQN-13 | Q1 | `hq_n13_q1_v01.png` | Aprovada |
| HQN-13 | Q2 | `hq_n13_q2_v01.png` | Aprovada |
| HQN-13 | Q3 | `hq_n13_q3_v01.png` | Aprovada |
| HQN-13 | Q4 | `hq_n13_q4_v01.png` | Aprovada |
| HQN-14 | Q1 | `hq_n14_q1_v02.png` | Aprovada; v01 anterior preservada |
| HQN-14 | Q2 | `hq_n14_q2_v01.png` | Aprovada |
| HQN-14 | Q3 | `hq_n14_q3_v01.png` | Aprovada |
| HQN-14 | Q4 | `hq_n14_q4_v01.png` | Aprovada |

## Revisão e exceções

- A correção de HQN-14 Q1 decorre da clarificação do dono de que a figura
  encapuzada é Nyrelia, personagem já existente. A v02 usa o retrato oficial
  como referência e foi aprovada; `hq_n14_q1_v01.png` foi mantida sem
  sobrescrita. Por isso há 17 arquivos físicos para os 16 quadros finais.
- O prompt-fonte de HQN-14 Q1 ainda descreve uma máscara pálida simples. Seu
  texto não foi alterado nesta execução; a candidata final segue a identidade
  de Nyrelia esclarecida pelo dono e sua referência oficial. Não se inferiram
  revelações além da Sessão 09.
- A revisão final confirmou 17 arquivos existentes para HQN-11 a HQN-14:
  exatamente 16 versões finais aprovadas e a v01 preservada de HQN-14 Q1.
  Todos medem 1672×941 pixels (razão 1,7768, praticamente 16:9).
- As candidatas permanecem no diretório de geração. Nenhuma foi promovida a
  `assets/`; código, dados e lore canônica não foram modificados.

## Reconciliação

O estado de geração em [[ART-PROMPTS-029-hqs-onda-2]] foi atualizado para
registrar HQN-07 a HQN-14 como candidatas locais aprovadas e remover a indicação
obsoleta de que a onda inteira ainda aguardava geração externa. Os textos dos
prompts foram preservados. [[SPEC-098-geracao-de-hqs-trilha-b]] foi concluída.
