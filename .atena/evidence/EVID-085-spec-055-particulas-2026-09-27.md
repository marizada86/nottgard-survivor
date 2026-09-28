---
id: "EVID-085"
type: "evidência de execução"
status: "parcial — validação gráfica pendente"
date: "2026-09-27"
relations:
  - "[[SPEC-055-particulas-para-areas-de-terreno]]"
  - "[[PLAN-024-particulas-para-efeitos-de-area-2026-09-27]]"
---

# EVID-085 — SPEC-055: partículas para áreas de terreno

## Entrega implementada

`ui/overlay.gd` passou a manter um pool visual local de até 96 partículas. O
pool não consulta ou consome a RNG de combate e aplica os quatro perfis da SPEC:

- `mote` para rituais e santuários;
- `bubble` para poças, Bolhas de Molor e raros imbuídos;
- `spark` para Cera Fervente e impactos de `boom`;
- `flow` para a corrente ativa dos Pilares.

Os emissores ricos são limitados a três por quadrante, pausam fora de tela e
respeitam oito partículas por zona persistente e doze por impacto. As zonas
procedurais preexistentes continuam sendo a leitura primária.

`ui/run.gd` apenas solicita as oito faíscas visuais quando um evento `boom` já
ocorre; não altera dano, raio, cadência, regra ou dados. O teste
`tests/test_vfx_particles.gd` cobre seleção de perfil, teto de zona, teto de
impacto e expiração do pool.

## Verificação realizada

| Verificação | Resultado |
|---|---|
| Smoke das nove fases | Passou: todas as fases ficaram em `running`; `smoke: ok`. |
| Compilação de overlay e run | Passou no smoke com o pool, os perfis, o limite fora de tela e a ligação de impacto ativos. |
| Alteração mecânica | Não realizada: não houve modificação em `core/battle.gd` ou em dados de regra. |
| Teste específico | Adicionado ao runner; o resumo integral de `tests/run_all.gd` não pôde ser coletado neste ambiente. |

Comando executado: `D:\Godot\godot.exe --headless --path . res://tools/smoke.tscn`.

## Exceção de validação

O renderer headless desta sessão não oferece textura de viewport para captura
gráfica. Logo, a inspeção 1280×720 do limite de três emissores por quadrante e
a execução visual de todos os quatro perfis continuam pendentes. O runner
integral também excede o limite de coleta deste ambiente antes de devolver seu
resumo final.

## Próxima verificação necessária

Em sessão com renderer gráfico, executar a captura determinística com a flag
`vfx` de `tools/shot.gd`, inspecionar a imagem em 1280×720 e rodar
`tests/run_all.gd` até o resumo final. Só então a SPEC pode ser reconciliada
como verificada.
