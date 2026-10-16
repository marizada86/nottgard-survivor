# EVID-266 — Integração da FILA-028 (PLAN-107 / SPEC-182)

Data: 2026-10-16 · Estado do conteúdo: `CANON_PREPARATION_VISUAL_ONLY` (preparações aceitas; admissão no runtime por este escopo, aprovado por plano) · Desvio: DEV-043 (PLAN-103 suspenso e retomado).

## O que entrou

Origem: pacote `claude-handoff-v01` (branch `codex/claude-art-handoff-2026-10-16`, `f88a8c9b`). Cada fonte teve o SHA-256 conferido contra o manifesto antes da cópia; destino novo em todos os casos, exceto o altar (backup do sheet anterior, hash antes `e3f2da83…94b3d95`, em `.atena/generated/fila028-integration-2026-10-16/backup/`). Nenhum raster foi alterado.

| Lote | Peças | Ligação |
|---|---|---|
| B-001 | IC01–IC06 (armas), IC07–IC13 (itens), I01–I02 (bênçãos) | só o PNG próprio; `Items.weapon_icon`, `Items.item_icon` e `BoonKinds.icon_path` já o preferiam ao `icon_like` |
| B-002 | AR01 Arcanista; EV01–EV06 (pacto_sangue, relicario, peregrino, contador, carroca, eclipse_pedra) | o overlay já procurava `arcanista.png` e `<kind>.png` dos eventos; só os PNGs |
| B-003 | SE01 Eco; SE02/SE03 câmara selada/aberta; SE04–SE11 ruínas | `ui/overlay.gd`: Eco desenhado com o cristal (mantém o brilho); câmara troca para `camara_aberta` com `chamber_unlocked`; ruína desenhada atrás do baú do ponto (`ruin_art = "ruina_<fase>"` em `core/battle.gd`, só visual) |
| B-004 | AL01 `AL01_loop_v03.png` (AL01-CORR/v01) | `assets/animations/interactions/altar_active.png`; o overlay deixou de forçar o sprite estático do altar e usa 150 ms por quadro (6 quadros, 900 ms) |

Código: `ui/overlay.gd` (constantes `ALTAR_FRAME_MS`, `RUIN_HEIGHT`, `RUIN_DROP`, `ECO_ART_HEIGHT`), `core/battle.gd` (1 linha), `tools/capture_fila028.gd/.tscn` (capturas). Localização, colisão, regras e dados dos segredos, eventos e altar ficaram intactos.

## Verificação

- Importação headless do Godot: 34 recursos reimportados sem erro.
- `tests/run_all.gd`: **0 falhas**.
- `tools/smoke.tscn`: 9 fases, `ok`.
- Capturas (`.atena/generated/fila028-integration-2026-10-16/capturas/`): ruína + baú nas 8 fases com ruína, Eco perto, câmara selada e aberta, Arcanista, altar em 3 instantes (hashes diferentes: anima), 6 eventos e folha de 15 ícones a 64 e 48 px (legíveis).

## Não verificado / pendente do dono

- Legibilidade, escala e sensação em jogo: **o dono avalia**. Pontos a olhar: ruína a 150 px atrás do baú (o rótulo "baú" cobre parte dela), cristal do Eco a 44 px, escala do Arcanista e dos 6 eventos, ritmo do altar.
- Nenhum playtest humano foi feito. Sem commit, push, build nem exportação.
- Fora do escopo: Durvall v03 (PLAN-103/M1, faltam 5 retornos), ART-047, ART-048, ART-049, PLAN-104.
