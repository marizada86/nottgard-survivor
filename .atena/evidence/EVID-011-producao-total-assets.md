# EVID-011 — Produção total dos assets visuais

Data: 2026-09-22  
Spec: `../specs/SPEC-015-producao-total-de-assets-visuais.md`  
Plano: `../vault/drafts/PLAN-003-geracao-total-assets-2026-09-21.md`  
Manifesto: `../generated/ASSET-PRODUCTION-MANIFEST-001.json`

## Resultado

- **236/236 PNGs finais** presentes e verificados.
- **228 imagens distintas** produzidas a partir dos pacotes `ART-PROMPTS-001..013`.
- **8 aliases determinísticos** entre arma e item: `machado_de_xargath`, `martelo_da_gloria`, `lamina_da_digestao`, `chicote_avarento`, `cajado_dos_desejos`, `colar_dos_tentaculos`, `sopro_de_estrela` e `ampulheta`.
- **1 SVG do aplicativo** redesenhado e validado.
- Assets integrados em herói, chão, props, interações, pickups, menu, HUD, ofertas de level-up, thumbnails e telas de resultado.
- VFX, telegráfos, partículas, barras, molduras e comportamento visual continuam procedurais, conforme o pipeline híbrido aprovado.

## Cobertura entregue

| Família | Quantidade |
|---|---:|
| Retratos de herói | 10 |
| Sprites de herói | 10 |
| Inimigos | 49 |
| Pisos | 8 |
| Props | 24 |
| Interações | 8 |
| Thumbnails de camada | 8 |
| Fundos de UI | 3 |
| Pickups | 3 |
| Ícones de regra de camada | 8 |
| Ícones de HUD | 8 |
| Passivas | 14 |
| Bênçãos | 12 |
| Habilidades | 10 |
| Armas | 30 |
| Itens | 31, incluindo 8 aliases |

## Validação automática

Execução de `tools/validate_generated_assets.ps1`:

```text
manifest_total: 236
files_checked: 236
alpha_assets_checked: 207
aliases_checked: 8
svg_checked: true
warnings: []
errors: []
passed: true
```

Execução da suíte Godot:

```text
testes: 0 falha(s)
exit code: 0
```

Smoke test das oito camadas:

```text
dagruve: inimigos=6 estado=running
shedaklah: inimigos=6 estado=running
molor: inimigos=6 estado=running
durao: inimigos=6 estado=running
feng_tu: inimigos=6 estado=running
shendilavri: inimigos=6 estado=running
goranthis: inimigos=6 estado=running
pilares: inimigos=6 estado=running
smoke: ok
exit code: 0
```

O importador do Godot reconheceu os 236 PNGs e o SVG. Os avisos observados ao encerrar testes referem-se à indisponibilidade do diretório `user://`, ao certificado-raiz do Windows e a objetos mantidos até o encerramento abrupto das cenas de teste; não houve erro de asset ou de importação.

## Evidência visual

- `EVID-009-assets-contact-sheet.png`: galeria dos 236 PNGs.
- `EVID-010-stage-screenshots-contact-sheet.png`: comparação das oito camadas em jogo.
- `asset-screenshots/menu.png`: Quartel com fundo, retrato e thumbnails finais.
- `asset-screenshots/levelup.png`: ofertas com ícones finais em 1280×720.
- `asset-screenshots/dagruve.png`, `shedaklah.png`, `molor.png`, `durao.png`, `feng_tu.png`, `shendilavri.png`, `goranthis.png` e `pilares.png`: leitura das camadas, pisos, herói, inimigos, props e HUD.
- `legacy-backup/`: cópias recuperáveis da arte substituída.

## Critérios de pronto

1. Cobertura do manifesto: **atendido**.
2. Consumers resolvidos por arquivo, alias ou implementação procedural: **atendido**.
3. Placeholders geométricos dos consumers cobertos pela spec removidos ou mantidos apenas como fallback defensivo: **atendido**.
4. Auditoria técnica e inspeção visual: **atendido**.
5. Oito camadas carregadas e operacionais com assets finais: **atendido pelo smoke test e pelas capturas por camada**.
6. Identidade entre retratos, sprites, habilidades e itens: **atendido na galeria e nas cenas reais**.
7. Legibilidade em 1280×720: **atendido nas capturas de menu, run e level-up**.
8. Watermark, texto acidental, fundo verde e alfa falso: **nenhuma ocorrência detectada nos finais**.
9. Evidências registradas: **atendido**.
10. Manifesto, prompts e fatos operacionais reconciliados: **atendido**.

## Decisão de pipeline

O pipeline híbrido permanece recomendado para continuidade: ImageGen define identidade e conteúdo; Godot controla comportamento, animação, estados, VFX e UI estrutural. Isso preserva consistência, editabilidade e custo sem multiplicar PNGs para cada estado transitório.
