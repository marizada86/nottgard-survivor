# SPEC-076 — Redefinição visual de Brook

Status: **concluída e reconciliada** (2026-09-29).

## Escopo

Redefinir Brook França como halfling paladino de Lliira, ancorado na imagem de
referência canônica, e reconstruir sua família de arte: folha de identidade,
retrato, ícone de herói e nove sequências de animação.

## Não objetivos

- Alterar atributos, habilidades, balanceamento, cenas, placements ou outros
  heróis.
- Apagar os assets legados ou publicar/enviar mudanças remotamente.
- Promover uma candidata visual sem revisão humana explícita.

## Critérios de aceitação

1. A identidade canônica e os dados do herói dizem “halfling”, sem vestígios
   ativos de “anão” para Brook.
2. A folha de identidade mostra uma silhueta inequivocamente baixa e compacta,
   cabelo e barba brancos, maça de espinhos e armadura/capa coerentes com a
   referência canônica.
3. O dono aprova essa folha antes da geração dos assets de runtime.
4. Cada asset regenerado preserva a identidade, o contrato de frames, alfa e
   legibilidade em jogo; uma prancha final e hashes registram a evidência.
5. A aprovação final substitui os locks de Brook, preservando o histórico e a
   aprovação de Durvall.

## Impactos

- Cânone: `PLAN-001` e `CHARACTER-IDENTITY-003`.
- Dados: `data/heroes.json`.
- Produção futura: retrato, ícone e animações de Brook.
- Histórico: o registro de aprovação de 2026-09-27 continua como evidência,
  mas não é mais a fonte de verdade para Brook.

## Plano de voo aprovado

1. Persistir a imagem fornecida como referência canônica e registrar a decisão.
2. Gerar uma folha de identidade estática sem fundo usando apenas essa
   referência; inspecionar e submetê-la à revisão humana.
3. Após aprovação visual da folha, gerar retrato, ícone e as nove sequências,
   normalizar, validar e integrar as candidatas.
4. Auditar dimensões, alfa, hashes e consistência; atualizar locks e produzir
   prancha final de revisão.
5. Reconciliar os registros canônicos e a evidência, reportando exceções.

## Estado de execução

- A identidade v01 foi aprovada pelo dono.
- Retrato, ícone e as nove tiras foram regenerados, normalizados e integrados
  localmente.
- A bateria `tests/run_all.gd` passou com zero falhas.
- O dono aprovou a prancha final. `ASSET-OFFICIAL-LOCK-012.json` fixa os nove
  strips oficiais regenerados; `ASSET-APPROVAL-REGISTER-017` registra a
  decisão canônica e `EVID-060` comprova a reconciliação.

## Evidência prevista

- Referência preservada em `.atena/evidence/reference-staging/`.
- Folha e candidatas em `.atena/generated/`.
- Registro de prompt, auditoria e prancha final em `.atena/evidence/`.

## Reconciliação

Ao encerrar, registrar os hashes oficiais da nova família de Brook, apontar os
assets legados como supersedidos e confirmar que nenhum dado de combate ou
asset de outro herói foi modificado.
