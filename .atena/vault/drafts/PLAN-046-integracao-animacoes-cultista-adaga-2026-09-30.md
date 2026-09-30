---
id: "PLAN-046"
title: "Integração das animações do cultista de adaga"
status: "implementation verified; push in progress"
created: "2026-09-30"
relations:
  - "[[SPEC-099-integracao-animacoes-cultista-adaga]]"
  - "[[EVID-125-piloto-cultista-aprovacao-alfa-comparacao-2026-09-30]]"
---

# PLAN-046 — Integração das animações do cultista de adaga

## Pedido do dono

Implementar todos os assets aprovados até o momento e fazer push.

## Decisão de implementação

O piloto contém duas representações do mesmo conjunto: 20 quadros individuais
E01–E20 e quatro tiras E21–E24. A aprovação visual incluiu ambos, mas a
comparação documentada mostra que a divisão automática das tiras corta detalhes
em E22–E24. Portanto, o runtime será composto dos 20 quadros individuais. As
tiras de comparação permanecem preservadas localmente e fora do runtime.

## Plano de voo

1. Manter todos os PNGs candidatos sem sobrescrita; compor tiras de 256×384
   usando E01–E20 e alfa real.
2. Adicionar `idle`, `move`, `attack` e `death` ao `EnemyView` do cultista,
   preservando fallback estático e flip horizontal somente ao mover para a
   esquerda.
3. Registrar as dimensões esperadas e testar contagem, importação, alfa,
   fallback, eventos de ação e direção.
4. Inspecionar as tiras resultantes sobre fundo xadrez e reconciliar SPEC-099,
   EVID-125 e CANDIDATES-MANIFEST-002.
5. Stage/commit apenas arquivos relacionados ao piloto e à integração; deixar
   HQs e todo o restante do worktree sem stage. Enviar a branch `codex/` para
   `origin`; não abrir PR nem mesclar.

## Fora do escopo

Substituir a arte estática, animar outros atores/interações, modificar balance,
lore ou regras, incluir HQs, publicar release ou mesclar a branch.

## Aprovação

A autorização explícita de implementar e fazer push em 2026-09-30 aprova este
plano limitado, seguindo a recomendação já aprovada do método de quadros
individuais.
