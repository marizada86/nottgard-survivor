---
id: "CHATGPT-FILA-027"
title: "Fila de geração — Erik Blackthorn e Arlindo Orlando (PRIORIDADE ALTA)"
status: "20 peças nativas geradas; revisão visual e normalização pendentes"
priority: "alta"
created: "2026-10-09"
relations: ["[[ART-PROMPTS-060-erik-e-arlindo-jogaveis]]", "[[SPEC-160-arlindo-orlando-e-erik-blackthorn-jogaveis]]"]
---

# CHATGPT-FILA-027 — Erik e Arlindo (prioridade alta)

Compilação operacional de [[ART-PROMPTS-060-erik-e-arlindo-jogaveis]]; em caso de dúvida, o ART-PROMPTS prevalece. **Passa na frente das demais filas de imagem** (pedido do dono em 2026-10-09).

## Como enviar

1. **Uma conversa por herói.** Anexar o retrato do Nottcard: `F:\dev\nottcard\assets\portraits\erik.png` ou `arlindo.png`.
2. Uma peça por chamada, **na ordem abaixo**. Colar o "Bloco comum obrigatório" e o "Identidade" do herói do ART-PROMPTS-060 no início da conversa e, em cada chamada, só a linha da peça. Pedir a tira **já na grade 256 × 384 por quadro**, com alfa real e folga de 10 px.
3. Do segundo pedido em diante, anexar também o `idle` **aprovado** do herói.
4. Destino dos candidatos: `.atena/generated/art-candidates/heroes-novos/<erik|arlindo>/<codigo>.png`. Nada entra no runtime sem a auditoria do ART-PROMPTS-060 e a sua admissão.

Marque `[x]` ao gerar e `[a]` ao aprovar. **Dica de cota:** se o limite diário apertar, gere só **ER01, ER02, AO01 e AO02** (retratos e `idle`) e deixe o resto para depois; com esses quatro o jogo já mostra os dois na seleção e o `idle` verdadeiro.

## Erik Blackthorn

- [x] gerada · [x] aprovada — ER01 retrato (1536 × 1024)
- [x] gerada · [x] aprovada — ER02 `idle`
- [x] gerada · [ ] aprovada — ER03 `move_e`
- [x] gerada · [ ] aprovada — ER04 `move_se`
- [x] gerada · [ ] aprovada — ER05 `move_s`
- [x] gerada · [ ] aprovada — ER06 `move_ne`
- [x] gerada · [ ] aprovada — ER07 `move_n`
- [x] gerada · [ ] aprovada — ER08 `attack`
- [x] gerada · [ ] aprovada — ER09 `active`
- [x] gerada · [ ] aprovada — ER10 `death`

## Arlindo Orlando

- [x] gerada · [x] aprovada — AO01 retrato (1536 × 1024)
- [x] gerada · [ ] aprovada — AO02 `idle`
- [x] gerada · [ ] aprovada — AO03 `move_e`
- [x] gerada · [ ] aprovada — AO04 `move_se`
- [x] gerada · [ ] aprovada — AO05 `move_s`
- [x] gerada · [ ] aprovada — AO06 `move_ne`
- [x] gerada · [ ] aprovada — AO07 `move_n`
- [x] gerada · [ ] aprovada — AO08 `attack`
- [x] gerada · [ ] aprovada — AO09 `active`
- [x] gerada · [ ] aprovada — AO10 `death`


## Continuação local DEV-024 v03

Snapshot de origem preservado em `art045-priority-review/v01`; esta cópia registra os fatos atuais. Aprovação visual anterior: ER01, ER02 e AO01. AO02 foi usado como referência DRAFT experimental. Nenhuma nova peça foi admitida no runtime.

[Galeria de revisão](erik-arlindo-complete-2026-10-09/index.html).

- ER03: [er03-move_e-v01.png](art-candidates/heroes-novos/erik/er03-move_e-v01.png) — DIMENSION_MISMATCH, EDGE_CONTENT, WALK_LOOP_CONTACT_REVIEW_PENDING, EAST_PROFILE_CAMERA_REVIEW_PENDING
- ER04: [er04-move_se-v01.png](art-candidates/heroes-novos/erik/er04-move_se-v01.png) — DIMENSION_MISMATCH, EDGE_CONTENT, WALK_LOOP_CONTACT_REVIEW_PENDING
- ER05: [er05-move_s-v01.png](art-candidates/heroes-novos/erik/er05-move_s-v01.png) — DIMENSION_MISMATCH, EDGE_CONTENT, WALK_LOOP_CONTACT_REVIEW_PENDING
- ER06: [er06-move_ne-v01.png](art-candidates/heroes-novos/erik/er06-move_ne-v01.png) — DIMENSION_MISMATCH, EDGE_CONTENT, WALK_LOOP_CONTACT_REVIEW_PENDING
- ER07: [er07-move_n-v01.png](art-candidates/heroes-novos/erik/er07-move_n-v01.png) — DIMENSION_MISMATCH, WALK_LOOP_CONTACT_REVIEW_PENDING
- ER08: [er08-attack-v01.png](art-candidates/heroes-novos/erik/er08-attack-v01.png) — DIMENSION_MISMATCH, EDGE_CONTENT
- ER09: [er09-active-v01.png](art-candidates/heroes-novos/erik/er09-active-v01.png) — DIMENSION_MISMATCH, EDGE_CONTENT
- ER10: [er10-death-v01.png](art-candidates/heroes-novos/erik/er10-death-v01.png) — DIMENSION_MISMATCH, EDGE_CONTENT
- AO03: [ao03-move_e-v01.png](art-candidates/heroes-novos/arlindo/ao03-move_e-v01.png) — DIMENSION_MISMATCH, EDGE_CONTENT, WALK_LOOP_CONTACT_REVIEW_PENDING
- AO04: [ao04-move_se-v01.png](art-candidates/heroes-novos/arlindo/ao04-move_se-v01.png) — DIMENSION_MISMATCH, WALK_LOOP_CONTACT_REVIEW_PENDING
- AO05: [ao05-move_s-v01.png](art-candidates/heroes-novos/arlindo/ao05-move_s-v01.png) — DIMENSION_MISMATCH, WALK_LOOP_CONTACT_REVIEW_PENDING
- AO06: [ao06-move_ne-v01.png](art-candidates/heroes-novos/arlindo/ao06-move_ne-v01.png) — DIMENSION_MISMATCH, EDGE_CONTENT, WALK_LOOP_CONTACT_REVIEW_PENDING
- AO07: [ao07-move_n-v01.png](art-candidates/heroes-novos/arlindo/ao07-move_n-v01.png) — DIMENSION_MISMATCH, EDGE_CONTENT, WALK_LOOP_CONTACT_REVIEW_PENDING
- AO08: [ao08-attack-v01.png](art-candidates/heroes-novos/arlindo/ao08-attack-v01.png) — DIMENSION_MISMATCH
- AO09: [ao09-active-v01.png](art-candidates/heroes-novos/arlindo/ao09-active-v01.png) — DIMENSION_MISMATCH, EDGE_CONTENT
- AO10: [ao10-death-v01.png](art-candidates/heroes-novos/arlindo/ao10-death-v01.png) — DIMENSION_MISMATCH, EDGE_CONTENT

## Piloto controlado ER03

[Ciclo por camadas](erik-gait-pilot/layered-v01/index.html), grade1536x384 e alternância geométrica verificadas. Candidato alternativo DRAFT, emendas e continuidade pendentes; não substitui automaticamente a seleção anterior.

## Correção controlada das caminhadas — 2026-10-10

[Galeria de dez direções, contatos e reprodução](erik-gait-reference-production/index.html). Nove candidatas novas: oito aguardam revisão artística e AO03 requer refinamento da calça. Seis quadros distintos, alpha, grade, margens e base368 conferidos. Originais preservados; runtime não alterado.

## Seleção restaurada pelo dono — 2026-10-10

Pedido: “desisto volte para as primeiras tiragens geradas”. As16 tiras ER03–ER10 e AO03–AO10 voltaram para v01. Retratos e idle previamente selecionados preservados (ER02 permanece v02 aprovado). Pilotos, guias e correções por camadas deixam de ser a seleção ativa; arquivos mantidos como histórico. Correção da caminhada cancelada. [Galeria das tiragens originais](erik-arlindo-complete-2026-10-09/index.html). Runtime não alterado.
