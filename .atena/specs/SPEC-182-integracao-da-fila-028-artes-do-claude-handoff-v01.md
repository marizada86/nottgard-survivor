---
id: "SPEC-182"
title: "Integração da FILA-028 (34 artes do pacote claude-handoff-v01)"
status: "IMPLEMENTADA localmente em 2026-10-16; aguarda playtest do dono (EVID-266)"
origin: planned
implementation_preceded_spec: false
request_classification: PLAN_DEVIATION   # PLAN-103 estava em B-002/S-008; dono escolheu "fazer agora e voltar" em 2026-10-16
created: "2026-10-16"
revision: "r1 (2026-10-16)"
relations: ["[[PLAN-103]]", "[[ART-042]]", "[[ART-043]]", "[[ART-041]]", "[[ART-038]]"]
content_state: CANON_PREPARATION_VISUAL_ONLY   # preparações aceitas; a admissão no runtime é este escopo, aprovado por plano
---

# SPEC-182 — Integração da FILA-028

## Origem

Pacote `claude-handoff-v01` (branch `codex/claude-art-handoff-2026-10-16`, commit `f88a8c9b`; cópia local
`C:\Users\Higor Rossini\.codex\worktrees\46e1\nottgard-survivor\.atena\generated\art-candidates\claude-handoff-v01`).
38 artes principais: **34 da FILA-028** (este escopo) e **4 tiras do Durvall v03** (fora: pertencem ao
PLAN-103/M1, faltam os 5 retornos N, NE, W, SW e NW). Dono, 2026-10-16: rota "fazer agora e voltar",
aprovação **por plano**.

## Regras

- Não alterar raster, silhueta, paleta ou identidade. Só copiar (com conferência de SHA-256 contra o manifesto),
  ligar ao código/dados e medir.
- Backup de qualquer arquivo substituído; conferir `runtime_before_sha256` antes.
- Preservar localização, colisão e regras dos segredos, dos eventos e do altar.
- AL01: somente `AL01_loop_v03.png` (revisão `AL01-CORR/v01`, 6 quadros de 192, ciclo de 900 ms). Nunca o `AL01_v02.png`.
- Nada de commit, push, build, exportação ou aviso sem autorização própria. Outras sessões: preservar intocado.

## Lotes (aprovação por plano; execução em ordem)

| Lote | Peças | Destino e ligação |
|---|---|---|
| B-001 | IC01–IC06 (armas), IC07–IC13 (itens), I01–I02 (bênçãos) | `assets/icons/{weapons,items,boons}/<id>.png`; `Items.weapon_icon`, `Items.item_icon` e `BoonKinds.icon_path` já preferem o PNG próprio; o `icon_like` e o ícone da mesma divindade deixam de valer só para estes ids |
| B-002 | AR01 Arcanista, EV01–EV06 eventos | `assets/interactions/<id>.png` (o overlay usa o `kind`, que é o id do evento) |
| B-003 | SE01 Eco, SE02/SE03 câmara selada/aberta, SE04–SE11 ruínas | `eco.png` desenhado no lugar do círculo; câmara troca por `camara_aberta` quando `chamber_unlocked`; ruína desenhada atrás do baú do POI, só visual |
| B-004 | AL01 altar | `assets/animations/interactions/altar_active.png` (backup do atual); animação do altar volta a valer com 900 ms de ciclo |

## Verificação

Importação do Godot, suíte (`tests/run_all.gd`), smoke das nove fases, capturas dos estados afetados (ofertas, ficha,
baú, evento, eco, câmara, ruína, altar). O dono avalia legibilidade e sensação; nenhum teste automático encerra esse aceite.

## Pendências fora do escopo

Durvall (PLAN-103/M1), ART-047, ART-048, ART-049 e PLAN-104 (sem imagem disponível).
