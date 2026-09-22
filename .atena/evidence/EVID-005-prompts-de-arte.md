# EVID-005 — Prompts de arte

Data: 2026-09-21
Spec: `SPEC-011-fase-1-prompts-de-arte.md`
Resultado: **aprovada, executada e verificada**

## Entregas

- 10 documentos `ART-PROMPTS-001..010` em `.atena/generated/`.
- 39 prompts de inimigos ausentes, todos únicos e correspondentes a `data/enemies.json`.
- 5 prompts de retratos ausentes: Korrak, Leoric, Nyrelia, Zynara e Bromnor.
- Catálogo futuro: 8 pisos, 24 props, 8 thumbnails e 8 interações.
- Catálogo de ícones: 30 armas/habilidades, 13 itens-base, 18 itens únicos, 14 passivas, 12 bênçãos e 8 ícones de HUD.
- Conquistas mantidas por reuso no primeiro passe, sem criar 18 imagens redundantes.

## Verificações executadas

| Checagem | Resultado |
|---|---|
| Documentos esperados | 10/10 |
| Inimigos ausentes cobertos | 39/39; 39 IDs únicos; sem extras |
| Retratos ausentes cobertos | 5/5; 5 IDs únicos |
| Pisos | 8/8 |
| Props | 24/24 |
| Thumbnails | 8/8 |
| Interações | 8/8 |
| Armas/habilidades | 30/30 |
| Itens-base | 13/13 |
| Itens únicos | 18/18 |
| Passivas | 14/14 |
| Bênçãos | 12/12 |
| HUD | 8/8 |
| Alterações de imagens | nenhuma |
| Alterações intencionais de código/dados | nenhuma nesta spec |

## Revisão de drift

- O vault permanece a autoridade sobre identidades e acontecimentos.
- As criaturas adicionais encontradas na pesquisa de D&D ficaram no backlog, sem novos IDs.
- Death Tyrant, Master of Cruelties, Shu e Ezro foram mantidos como entidades canônicas de Nottgard.
- O ID `demonio_de_gehenna` foi preservado; o prompt o apresenta como mercenário yugoloth, conforme a decisão aprovada.
- Zuggtmoy, Malcanthet e Socothbenoth não são representados mortos ou como troféus.
- Assets ainda não consumidos pelo jogo estão marcados como `draft-future-integration`.

## Estado do workspace

Durante a verificação apareceram alterações fora da SPEC-011 em arquivos canônicos, novas specs e novos JSONs. Elas não foram produzidas, editadas, revertidas nem incluídas nesta evidência. A entrega desta spec limita-se aos arquivos relacionados acima.

## Próximo gate

Nenhuma imagem deve ser gerada até aprovação explícita da fase 2. O lote recomendado é o piloto: `notivago`, retrato de `korrak`, piso `dagruve_ground` e prop `pilar_01`, seguido de inspeção no jogo.

