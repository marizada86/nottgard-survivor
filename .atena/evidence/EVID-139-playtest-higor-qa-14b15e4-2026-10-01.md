# EVID-139 — Playtest do dono (Higor), build qa 14b15e4

Data: 2026-10-01 (00:33 a 01:07)
Fonte: `evidencias/relato.txt`, `evidencias/logs/jogo.log`, `evidencias/imagens/print-2026-10-01-010722.png`

## Sessão

4 runs: Durvall em Dagruve (2×, derrota), Sylas em Dagruve (derrota, 145 abates), Sylas em Docas (derrota, 15 abates).
O log não registra crash nem exceção; serve só de contexto dos relatos.

## Relatos (resumo fiel) e destino

| IN | Relato | Destino |
|---|---|---|
| IN-041 | F5 com HQ aberta: barra de espaço passa a HQ em vez de escrever; o bloco deve vir em primeiro plano | BUG-020 |
| IN-042 | Peregrinação da Estrela, quadro 2: braço de Korrak fundido ao machado | BUG-022 |
| IN-043 | Q/RMB do Sylas muito ruim; sugere cópia de si que atrai inimigos | MEC-029 |
| IN-044 | Heróis (Brook, Kayron, Korrak e outros) deformam ao andar; Sylas não; investigar a causa | BUG-021 |
| IN-045 | Fazer imagem das Docas; mapas 1 e 2 com 5 min | ART-024, BAL-011 |
| IN-046 | Movimento dos inimigos "surpreendentemente bom"; seguir com novos inimigos | registro |
| IN-047 | Cenário sem sentido na disposição; estradas, carroças, destrutíveis, armadilhas temáticas | MEC-030, ART-025/026 |
| IN-048 | Jogo jogável mas "cru, sem alma"; dopamina temática, história, fundos melhores | MEC-031/032, ART-025 |

## Medição (BUG-021)

`tools/audit_hero_motion.gd` (altura mediana do conteúdo, px, célula 256×384):
Brook idle 259, move_s 360, move_ne 245 · Durvall idle 293, move_n 368, move_e 226 ·
Leoric idle 313, move_e 216 · Sylas 316–373 (consistente).
Larguras ficam em 232–256. Kayron, Korrak e Sylas têm quadros que tocam a borda da célula.
Causa: cada tira é encaixada na célula com escala própria (`normalize_animation_grid_fit.gd`, `MAX_CONTENT` 232×360).
O runtime (`ui/hero_view.gd`) usa escala fixa, então a variação vem do conteúdo.

## Print

Menu "Jogar": a linha "2. Docas" sem miniatura (falta `assets/stages/docas_thumb.png`).
Menu mostra Sylas com PV 26; na run aparece 42/42 (verificar se é bônus de meta/nível ou divergência).
