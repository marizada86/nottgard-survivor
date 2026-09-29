---
id: "SPEC-062"
title: "Fila de geração externa de assets pendentes"
status: "aprovada — em aberto, fila viva sem data de encerramento"
created: "2026-09-28"
relations:
  - "[[SPEC-061-preparacao-da-regeneracao-do-piloto-de-zumbi]]"
  - "[[PLAN-032-proxima-atualizacao-pos-playtest-2026-09-28]]"
---

# SPEC-062 — Fila de geração externa de assets pendentes

## Intenção

Esta sessão do Claude Code não tem ferramenta de geração de imagem — o
Leoric foi gerado em outra sessão/ambiente que tinha essa integração. Em vez
de bloquear cada asset individualmente esperando acesso a essa ferramenta,
esta spec mantém uma **fila única**: toda vez que um brief de regeneração é
preparado e a geração é autorizada pelo dono, ele entra aqui como uma linha
pendente. Quando o dono tiver acesso a uma sessão com geração de imagem,
processa a fila inteira de uma vez, em vez de uma spec isolada por asset.

Esta spec não gera nada sozinha e não substitui a spec de escopo/contrato de
cada asset (ex.: [[SPEC-061-preparacao-da-regeneracao-do-piloto-de-zumbi]]
continua sendo a spec própria do Zumbi — esta aqui é só o índice).

## Convenção para novas entradas

1. Preparar o brief e os prompts no mesmo padrão já usado
   (`.atena/generated/<asset>-regeneration/v01/BRIEF-<ASSET>-REGEN-V01.md` +
   `PILOT-REQUEST-TEMPLATES-001.json`, com `generation_authorized`).
2. Abrir (ou já ter) uma spec própria do asset com o contrato visual e os
   critérios de aceite específicos.
3. Adicionar uma linha na tabela abaixo, com link para a spec e para a pasta
   do brief.
4. Quando o dono gerar externamente e devolver os PNGs brutos, esta sessão
   normaliza, valida em runtime real e conduz seleção/admissão pela spec
   própria do asset — e a linha sai da fila (ou marca "processado").

## Fila atual

| Asset | Spec | Pasta do brief | Frames | Status |
|---|---|---|---|---|
| Zumbi (inimigo) | [[SPEC-061-preparacao-da-regeneracao-do-piloto-de-zumbi]] | `.atena/generated/zumbi-regeneration/v01/` | 20 (idle 4, move 6, attack 4, death 6) | Geração autorizada, aguardando execução externa do dono |
| 7 quebráveis temáticos por bioma (imagem estática única cada) | [[SPEC-063-objetos-quebraveis-e-rebalanceamento-de-pocao]] | prompts em [[ART-PROMPTS-024-cenario-e-quebraveis-por-bioma]] (bloco "quebráveis") | 1 imagem cada (7 no total) | Prompts prontos; brief/template por asset ainda não montado — rodando com arte provisória reaproveitada |
| Props de cenário de Shedaklah | [[SPEC-065-props-de-shedaklah]] | prompts em [[ART-PROMPTS-024-cenario-e-quebraveis-por-bioma]] | 3 imagens | Preparada; sem urgência — priorizar os 7 quebráveis primeiro |
| Props de cenário de Molor | [[SPEC-066-props-de-molor]] | prompts em [[ART-PROMPTS-024-cenario-e-quebraveis-por-bioma]] | 3 imagens | Preparada; sem urgência |
| Props de cenário de Durao | [[SPEC-067-props-de-durao]] | prompts em [[ART-PROMPTS-024-cenario-e-quebraveis-por-bioma]] | 3 imagens | Preparada; sem urgência |
| Props de cenário de Feng-tu | [[SPEC-068-props-de-feng-tu]] | prompts em [[ART-PROMPTS-024-cenario-e-quebraveis-por-bioma]] | 3 imagens | Preparada; sem urgência |
| Props de cenário de Shendilavri | [[SPEC-069-props-de-shendilavri]] | prompts em [[ART-PROMPTS-024-cenario-e-quebraveis-por-bioma]] | 3 imagens | Preparada; sem urgência |
| Props de cenário de Goranthis | [[SPEC-070-props-de-goranthis]] | prompts em [[ART-PROMPTS-024-cenario-e-quebraveis-por-bioma]] | 3 imagens | Preparada; sem urgência |
| Props de cenário dos Pilares | [[SPEC-071-props-dos-pilares]] | prompts em [[ART-PROMPTS-024-cenario-e-quebraveis-por-bioma]] | 3 imagens | Preparada; sem urgência |

## Não objetivos

- Não gera, normaliza ou admite nenhum asset por conta própria.
- Não define método, fornecedor, licença ou custo de geração — isso continua
  em cada `PILOT-REQUEST-TEMPLATES-*.json` e no gate de autorização da spec
  própria de cada asset.
- Não substitui o registro de evidência (`EVID-*`) de cada execução quando
  ela finalmente acontecer.

## Limites

- Fila viva: não fecha "executada" enquanto houver itens pendentes. Cada
  processamento de item gera sua própria evidência na spec do asset
  correspondente.
