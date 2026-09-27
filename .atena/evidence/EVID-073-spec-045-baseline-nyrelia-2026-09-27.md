# EVID-073 — Baseline técnico de Nyrelia para a SPEC-045

Data: 2026-09-27.

## Procedimento

Foi executada a auditoria local de leitura `tools/analyze_nyrelia_frames.gd`
contra os nove strips atuais de Nyrelia. A execução é somente leitura e não
alterou PNGs, importações, cenas, código, dados, lock ou registros canônicos.

## Resultado

- 50 frames foram percorridos: 4 de `idle`, 30 de movimentos, 4 de `attack`,
  6 de `active` e 6 de `death`.
- Todos os limites de alfa fraco chegam a `y=368`, a baseline que
  `ui/hero_view.gd` usa para Nyrelia.
- A menor margem horizontal observada é 8 px; nenhum limite alfa alcança ou
  cruza a borda de célula de 256 px.
- O runtime usa as folhas animadas quando elas existem e as nove estão
  disponíveis. Portanto, o asset estático de Nyrelia não é utilizado como
  fallback durante a execução normal com animação.

## Conclusão limitada

O baseline descarta, nos bytes atuais, uma falha geométrica simples de linha
de base ou de pixels atravessando células. Ele não prova boa leitura em escala
de jogo, cadência, VFX ou coerência de identidade; esses pontos permanecem
pendentes de captura QA interativa e decisão humana.

O Godot registrou os avisos ambientais já conhecidos sobre log e store de
certificados. Eles não impediram a leitura dos strips e não foram alterados.
