---
id: "EVID-125"
title: "Aprovação visual, versões alfa e comparação dos métodos — piloto do cultista"
date: "2026-09-30"
relations:
  - "[[SPEC-097-geracao-das-imagens-de-arte-pendentes]]"
  - "[[PLAN-045-piloto-animacao-cultista-adaga-2026-09-29]]"
  - "[[ART-PROMPTS-031-piloto-animacao-cultista-adaga]]"
  - "[[EVID-124-piloto-cultista-candidatas-geradas-2026-09-29]]"
  - "[[IMAGEGEN-LOG-001-piloto-cultista-2026-09-29]]"
---

# EVID-125 — Aprovação visual, versões alfa e comparação dos métodos

## Decisão e escopo

Em 2026-09-30, o dono aprovou as 24 candidatas geradas nos cinco lotes: idle,
move, attack, death e strips. A aprovação cobre as candidatas em
`.atena/generated/art-candidates/`; não autoriza admissão em `assets/`, troca
de sprites oficiais nem integração no jogo.

## Fundo e versões alfa

- Os 24 PNGs ciano originais foram preservados sem sobrescrita.
- Foram criadas 24 cópias `*_alpha_v01.png` no mesmo diretório, com canal alfa
  binário, usando a chave RGB ciano de
  `tools/remove_cyan_candidate_background.ps1`.
- A verificação confirmou 24/24 originais e 24/24 cópias alfa presentes; as
  cópias mantêm as dimensões das fontes. Pranchas em fundo xadrez confirmam a
  transparência e permitem inspecionar a silhueta:
  `review/review_alpha_idle.png`, `review/review_alpha_move.png`,
  `review/review_alpha_attack.png`, `review/review_alpha_death.png` e
  `review/review_alpha_strips.png`.

## Comparação

| Método | Resultado do piloto | Esforço e decisão |
|---|---|---|
| 1 — quadros individuais, E01–E20 | 20 quadros isolados, sem regenerações; cada imagem pode ser revisada e recortada sem atravessar a célula vizinha. | Menor risco de corte entre quadros. Recomendado para as próximas ondas. |
| 2 — tiras, E21–E24 | Quatro tiras geradas sem regenerações. A divisão automática por células iguais em 256×384 cortou detalhes que avançam sobre os limites da célula — incluindo partes da adaga e da silhueta em E22–E24. | Para salvar esses recortes seria necessário ajuste manual por quadro. Falha no critério de recorte automático; não recomendado para as próximas ondas. |

A prancha `review/review_alpha_strips_extracted_256x384.png` registra a falha
do recorte automático. As tiras originais e suas versões alfa continuam
aprovadas como candidatas, mas os quadros derivados dessa extração são apenas
uma prova de comparação e não devem ser admitidos no jogo.

## Reconciliação

- CANDIDATES-MANIFEST-002 registra aprovação do dono, caminhos das 24 versões
  alfa e resultado comparativo.
- A recomendação para ondas futuras é o método 1 (um quadro por geração),
  pois o método 2 exige reparos manuais após a segmentação.
- Na etapa de geração, os arquivos permaneceram como candidatos e nenhum asset
  oficial foi alterado. A integração posterior, explicitamente autorizada pelo
  dono, está reconciliada em [[EVID-126-integracao-animacoes-cultista-adaga-2026-09-30]].
