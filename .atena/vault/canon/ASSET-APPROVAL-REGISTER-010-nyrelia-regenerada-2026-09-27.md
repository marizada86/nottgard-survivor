# ASSET-APPROVAL-REGISTER-010 — Animações regeneradas de Nyrelia

Status: **canônico — substituição aprovada pelo dono** (2026-09-27).

## Decisão

O dono determinou: **“vamos gerar novamente os assets de Nyrelia e
substituí-los”**. Esta decisão admite exclusivamente o lote v02 das nove
animações de Nyrelia, gerado localmente pela ferramenta integrada de imagens,
normalizado e validado antes da cópia para os caminhos oficiais.

## Escopo admitido

- `nyrelia.idle`
- `nyrelia.move_n`, `nyrelia.move_ne`, `nyrelia.move_e`, `nyrelia.move_se`,
  `nyrelia.move_s`
- `nyrelia.attack`, `nyrelia.active`, `nyrelia.death`

Os nove arquivos continuam nos mesmos caminhos sob
`assets/animations/heroes/nyrelia/`. Direções `w`, `nw` e `sw` continuam
espelhadas pelas regras de runtime existentes.

## Preservação e limites

- Os bytes substituídos foram preservados em
  `.atena/generated/nyrelia-regeneration/v02/previous-official/`.
- As fontes, prompts e strips candidatos permanecem em
  `.atena/generated/nyrelia-regeneration/v02/`.
- Esta decisão não altera lore, atributos, habilidade, cenas, placements,
  props ou os demais assets oficiais.

## Integridade e evidência

- Lock vigente: `.atena/generated/asset-audit/ASSET-OFFICIAL-LOCK-010.json`.
- Evidência: `EVID-078-regeneracao-e-admissao-de-nyrelia-2026-09-27.md`.
- A validação confirmou RGBA, dimensões de strip, margem lateral mínima de
  16 px, base visível em y=367 e leitura em escala real de jogo.
