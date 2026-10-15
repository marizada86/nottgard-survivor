---
id: "SPEC-178"
title: "Retratos próprios da Ficha do herói (C) e do HUD dos 12 heróis"
status: "DRAFT r1 em 2026-10-14; plano aprovado por plano (per-plan) e rota fazer-agora-e-voltar; B-001 feito (EVID-256); aguarda G-R0"
origin: planned
implementation_preceded_spec: false
request_classification: PLAN_DEVIATION   # PLAN-103 ativo; o pedido não é B-002 (movimento) nem B-003 (game feel); encaixa em M3 (UI) e M5 (arte por visibilidade)
created: "2026-10-14"
revision: "r1 (2026-10-14)"
relations: ["[[PLAN-104-retratos-da-ficha-e-do-hud-2026-10-14]]", "[[PROMPTS-retratos-ficha-e-hud-herois-2026-10-14]]", "[[FICHAS-DE-IDENTIDADE-herois-m1-2026-10-14]]", "[[ART-DIRECTION-019-leoric-retrato-selecao-2026-09-29]]"]
content_state: DRAFT
---

# SPEC-178 — Retratos da Ficha (C) e do HUD

## Problema

As três telas usam o mesmo arquivo, `assets/portraits/<id>.png` (640×427 ou 1536×1024, 3:2):

| Tela | Código | Caixa | Efeito |
|---|---|---|---|
| Menu de seleção | `ui/menu.gd:237,281` | 360×180 | adequado (**não muda**) |
| Ficha (C) | `ui/character_sheet.gd:114,323` | 250×90 (250×70 no toque), `KEEP_ASPECT_CENTERED` | retrato 3:2 encolhido para ~135×90, sobra moldura vazia e o rosto fica pequeno |
| HUD | `ui/hero_panel.gd:109,267` | 76×76, `KEEP_ASPECT_COVERED` | corte central de um 3:2; rosto cortado ou pequeno |

## Decisão

Dois conjuntos novos de imagem, um por tela, com **fallback** para o retrato do menu quando o arquivo novo não existe:

| Conjunto | Caminho | Tamanho final | Origem |
|---|---|---|---|
| Ficha | `assets/portraits/ficha/<id>.png` | 768×256 (3:1) | faixa central 1536×512 do 1536×1024 gerado |
| HUD | `assets/portraits/hud/<id>.png` | 256×256 (1:1) | 1024×1024 reduzido (3,4× a caixa de 76 px) |

Prompts: `PROMPTS-retratos-ficha-e-hud-herois-2026-10-14.md` (DRAFT; aprovados pelo dono nesta conversa).

## Escopo

- **Dentro:** 12 heróis jogáveis (durvall, brook, maelor, sylas, kayron, korrak, leoric, nyrelia, zynara, bromnor, arlindo, erik); resolvedor com fallback; ajuste de `stretch_mode` da Ficha; testes; normalização, admissão e trava de assets.
- **Fora:** retrato do menu; sprites e animações; `sylas_copia_isca` (não jogável); novo layout das telas; lore ou textos; cânone do mestre.

## Mudanças de código previstas (B-001)

1. Função estática única de resolução (`HeroPortraits.texture(id, kind)` com `kind` ∈ `menu|ficha|hud`; ordem: arquivo do tipo, depois `assets/portraits/<id>.png`, depois `null`).
2. `ui/character_sheet.gd:323` e `ui/hero_panel.gd:267` passam a usar o resolvedor; `ui/menu.gd` fica como está.
3. Ficha: `stretch_mode` de `KEEP_ASPECT_CENTERED` para `KEEP_ASPECT_COVERED`, para a faixa 3:1 preencher a caixa (2,78:1 no desktop; 3,57:1 no toque corta ~16% do topo e da base, e o prompt já mantém o rosto na faixa central).
4. Nenhuma outra tela, sinal ou dado muda. Sem dependências novas.

## Critérios de aceite

| # | Critério | Como verificar |
|---|---|---|
| A1 | Menu inalterado: mesmo arquivo, mesmo tamanho | teste + captura do menu |
| A2 | Sem imagem nova, Ficha e HUD mostram o retrato do menu como hoje (fallback) | teste com a pasta nova vazia |
| A3 | Com imagem nova, Ficha e HUD usam o arquivo do conjunto correspondente para cada herói | `tests/test_character_sheet.gd` e `tests/test_hero_panel.gd` estendidos |
| A4 | 12 heróis × 2 conjuntos presentes, nas dimensões 768×256 e 256×256, importados pelo Godot | `tests/test_new_heroes.gd` estendido; `--import` |
| A5 | Cada imagem respeita a ficha de identidade ("traços fixos" e "não pode") e as decisões P1, P4, P6 | conferência da Atena, folha de contato, gate do dono |
| A6 | HUD legível a 76 px: rosto reconhecível, contraste suficiente sobre o fundo do jogo | captura do HUD em jogo, gate do dono |
| A7 | Suíte de testes e smoke das nove fases sem novas falhas | `tools/` existentes |
| A8 | Hash de cada PNG registrado na trava de assets e no manifesto | `ASSET-OFFICIAL-LOCK-015`, `tools/build_asset_manifest.ps1` |

## Lacunas

| Lacuna | Tipo | Tratamento |
|---|---|---|
| Referência canônica de Brook ausente (P2 das fichas) | RESOLVABLE | Brook entra com sprite e retrato atuais; o dono revisa no gate visual |
| Rosto de Nyrelia | DECIDIDO (P4) | Rosto oculto, sem exceção |
| Kayron com asas | DECIDIDO (P1) | Sem asas |
| Aprovação por herói ou em bloco | RESOLVABLE | Recomendado: gate visual por lote de 3 a 4 heróis (como o M1) |
| Tamanho do HUD (76 px) | DEFERRED | Manter; revisão de escala entra com BUG-025 |

Nenhuma lacuna BLOCKING.

## Gates

- Dono: geração das 24 imagens no ChatGPT e entrega em `.atena/generated/retratos-ficha-hud/entrega/` (`<id>_ficha.png`, `<id>_hud.png`).
- Dono: aceite visual por lote (G-R1) e em jogo (G-R2).
- Commit, push, exportação do `.exe` e aviso: aprovações separadas (`add.yaml`).
- Mudanças não commitadas de outras sessões em `ui/hud.gd`, `ui/overlay.gd`, `ui/run.gd` etc.: preservadas; esta spec não toca nesses arquivos.
