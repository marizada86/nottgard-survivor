# EVID-046 — Terreno modular integrado: Dagruve e Docas

Data: 2026-09-27  
SPEC: `SPEC-037-terreno-modular-isometrico-dagruve-docas.md`

## Resultado integrado

- Atlas ativo: `assets/tiles/dagruve_ground_atlas_v3.png` — 128×64, quatro
  variantes de pedra fria com acento violeta discreto.
- Atlas ativo: `assets/tiles/docas_ground_atlas_v3.png` — 128×64, quatro
  variantes de pedra úmida azul-esverdeada.
- `ui/ground.gd` seleciona variantes sem usar o RNG de combate; a escolha é
  determinística para a mesma fase, célula e seed, e respeita a dimensão real
  do atlas.
- As cenas de Dagruve e Docas apontam para seus atlas v3; a textura legada
  `assets/tiles/dagruve_ground.png` não foi substituída.

## Origem e decisões de arte

| Bioma | Fonte | Decisão |
| --- | --- | --- |
| Dagruve | `.atena/generated/art-candidates/terrain/dagruve-atlas-source-v2.png` | A geração com fundo transparente confirmou paleta e material; a forma de losango renderizada foi rejeitada para UV de piso. O atlas final deriva da textura plana existente com esse direcionamento. |
| Docas | `.atena/generated/art-candidates/terrain/docas-atlas-source-v2.png` | A geração confirmou pedra úmida, sal e tons teal; o atlas final deriva da textura plana existente com essa paleta para preservar leitura. |

As fontes foram criadas pelo fluxo interno de geração de imagens. Os artefatos
intermediários `*_atlas_v1.png` e `*_atlas_v2.png` foram preservados para
rastreabilidade, mas não são consumidos por cena alguma.

## Comandos e resultado

- Suíte: `Godot_v4.7.2-stable_win64.exe --headless --path . -s tests/run_all.gd`
  — `testes: 0 falha(s)`.
- Fumaça: `Godot_v4.7.2-stable_win64.exe --headless --path . res://tools/smoke.tscn`
  — abriu Dagruve, Docas e as demais fases; `smoke: ok`.
- Checagem de espaços: `git diff --check` para os arquivos do piloto — passou.
- Capturas de viewport 1280×720: `terrain-pilot-atlas-v3-2026-09-27.png`,
  `dagruve-atlas-run-v4-2026-09-27.png` e
  `docas-atlas-run-v2-2026-09-27.png` nesta pasta de evidências.

## Critérios de aceite

- Piloto 8×8 sem lacunas, molduras ou padrão de grade evidente: aprovado na
  captura de viewport.
- Dagruve e Docas distinguíveis por piso e props: aprovado.
- Herói, inimigos, props e UI legíveis em 1280×720: aprovado nas capturas de
  cada fase.
- Sem efeito em RNG, colisão ou simulação: aprovado por teste determinístico e
  smoke.
