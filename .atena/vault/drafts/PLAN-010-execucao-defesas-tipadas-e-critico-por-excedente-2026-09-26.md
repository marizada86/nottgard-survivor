# PLAN-010 — Execução: defesas tipadas e crítico por excedente

Status: implementado e testado em 2026-09-27. Smoke visual pendente de uma falha preexistente fora do escopo (`DivineVisuals` ausente em `ui/run.gd`).

## Resultado pretendido

CA/CAM deixam de ser uma segunda camada de acerto e passam a representar evasão física/mística; o crítico passa a depender de excedente do total de ataque acima de 20, com 20 natural garantido e teto de 40%.

## Escopo técnico

- Resolver acerto, evasão e crítico em `core/battle.gd`;
- expor funções derivadas de esquiva em `core/hero.gd`;
- migrar chaves e descrições de dados que usam `crit_range` e `crit_step`;
- classificar a futura Maré de Névoa como perigo ambiental não esquivável;
- atualizar HUD, telas de conteúdo e testes de combate.

## Plano de voo

1. Registrar um baseline dos testes e da taxa atual de acerto/crítico por herói e fase.
2. Isolar a resolução de defesa tipada: CA/CAM acima de 10, teto tipado de 30%, combinação multiplicativa com esquiva geral e teto composto de 45%.
3. Preservar 1 natural como erro e substituir a defesa d20 do alvo pela evasão tipada/precisão.
4. Resolver primeiro o acerto normal; depois aplicar o crítico garantido de 20 natural ou a chance `3% × excedente`, limitada a 40%.
5. Migrar `crit_range` e `crit_step` para os novos bônus percentuais, atualizando toda descrição afetada.
6. Adicionar os testes de limiar: CA/CAM 20, esquiva composta, precisão de chefe, 1 natural, 20 natural, 19 + 3 = 22, teto de 40% e ataque que acerta sem critar.
7. Simular runs com builds iniciais, defensivas e de precisão; ajustar apenas constantes documentadas na SPEC-035.
8. Implementar a Maré de Névoa somente em uma etapa posterior aprovada, reutilizando a classificação de perigo ambiental já testada.

## Segurança e reconciliação

- Preservar mudanças locais preexistentes em arquivos de combate, dados e testes.
- Não alterar cânone de lore, roster de chefe ou arte nesta execução.
- Manter o comportamento anterior recuperável em cópia local/diff até testes e playtest concluírem.
- Registrar métricas, testes e exceções em evidência ADD antes de reconciliar os fatos operacionais.

## Portão de execução

1. Baseline de testes disponível e sem falhas não relacionadas que impeçam comparação.
2. Resolução de conflitos com eventuais mudanças locais que toquem as mesmas funções.
