# SPEC-095 — Revisão de proporção e identidade das HQs

Status: **concluída — seis candidatas v02 aprovadas pelo dono** (2026-09-29).

## Escopo

Auditar as 40 candidatas `hq_n01_q1_v01.png` a `hq_n10_q4_v01.png` e criar
somente candidatas `v02` para cenas que não respeitem a identidade ou a
proporção dos personagens. Cenas sem personagens não são regeneradas.

## Fonte de verdade

- `data/heroes.json` para raça e papel.
- Retratos e sprites oficiais atuais para rosto, vestuário e silhueta.
- `CHARACTER-IDENTITY-003-brook-2026-09-29.md` para Brook.
- `ASSET-APPROVAL-REGISTER-018-leoric-skin-cartola-2026-09-29.md` e
  `ART-DIRECTION-019-leoric-retrato-selecao-2026-09-29.md` para Leoric.

## Matriz de escala e identidade

| Personagem | Regra de leitura no quadro |
|---|---|
| Korrak | Goliath: maior e mais largo do grupo; nunca reduzido à escala humana comum. |
| Kayron | Aasimar adulto: escala adulta regular; cabelo branco e armadura escura. |
| Sylas | Tiefling adulto: escala adulta regular; chifres e traje roxo-escuro preservados, sem tratar os chifres como ganho de altura corporal. |
| Maelor | Adulto de escala regular; roupa de estudioso azul e creme. |
| Brook | Halfling adulto: baixo e compacto, cabelo branco e barba branca curta; nunca anão ou humano alto. |
| Leoric | Gnomo adulto: baixo e compacto; barba grisalha, cartola preta com faixa marrom e sobretudo marrom; foco azul apenas discreto. |

## Não objetivos

- Não sobrescrever, promover ou redimensionar as candidatas `v01`.
- Não modificar `assets/`, runtime, lore, dados ou regras do jogo.
- Não alterar cenas sem personagem por preferência estética isolada.

## Critérios de aceite

1. Cada quadro com personagens é auditado quanto a escala relativa, raça,
   figurino e legibilidade em perspectiva.
2. Todo desvio recebe uma candidata irmã `v02`, preservando o enredo,
   enquadramento e as restrições originais da cena.
3. Leoric é corrigido nos seis quadros mapeados na fila: H08, H10, H12, H13,
   H16 e H22; candidatos adicionais são incluídos apenas se a auditoria achar
   Leoric em outra HQ já criada.
4. Cada candidata `v02` recebeu revisão explícita do dono antes da próxima.
5. A evidência registra a aprovação final e todas as saídas permanecem em
   `.atena/generated/art-candidates/hq/`, sem promoção para `assets/`.

## Plano de voo aprovado

1. Matriz registrada e `v01` preservadas como baseline recuperável.
2. Auditoria das 40 candidatas concluída.
3. Os seis quadros de Leoric foram corrigidos; nenhum outro desvio inequívoco
   exigiu regeneração neste passe.
4. As seis candidatas `v02` foram revisadas e aprovadas quadro a quadro; ver
   `EVID-123`.
