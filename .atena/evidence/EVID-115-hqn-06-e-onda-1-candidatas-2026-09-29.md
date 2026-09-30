---
id: "EVID-115"
type: "evidencia-de-geracao"
title: "HQN-06 e Onda 1 — candidatas aprovadas para admissão posterior"
date: "2026-09-29"
status: "onda 1 aprovada como candidatas; nao admitida"
relations: ["ART-PROMPTS-028", "CHATGPT-FILA-002", "SPEC-080"]
---

# HQN-06 — A Jaula de Durão

## Escopo executado

Foram gerados os quatro quadros da HQN-06 a partir dos prompts H17–H20. A
aprovação humana ocorreu quadro a quadro nesta conversa em 2026-09-29.

| Prompt | Candidata | Resultado da revisão humana |
|---|---|---|
| H17 | `.atena/generated/art-candidates/hq/hq_n06_q1_v01.png` | Aprovada |
| H18 | `.atena/generated/art-candidates/hq/hq_n06_q2_v01.png` | Aprovada |
| H19 | `.atena/generated/art-candidates/hq/hq_n06_q3_v01.png` | Aprovada |
| H20 | `.atena/generated/art-candidates/hq/hq_n06_q4_v01.png` | Aprovada |

## Correção registrada

A primeira tentativa não salva de H20 trouxe Korrak indevidamente. A candidata
registrada foi regenerada usando apenas as referências de Brook e Kayron; ela
foi aprovada pelo dono.

## Fechamento da Onda 1

As HQN-02 a HQN-06 (H01–H20) estão aprovadas como candidatas brutas. Todas
permanecem em `.atena/generated/art-candidates/hq/`; não houve
redimensionamento, admissão em `assets/` nem validação em runtime.

## Próximo gate

A admissão continua condicionada à SPEC-080 e a autorização explícita. A
geração pode avançar para a Onda 2 (H21–H52) sem atravessar esse gate.
