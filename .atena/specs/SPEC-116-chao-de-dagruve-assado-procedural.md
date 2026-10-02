---
id: "SPEC-116"
title: "Chão dos nove biomas: textura contínua assada por código (PLAN-054, F0–F3)"
status: "Dagruve e Docas aprovadas pelo dono 2026-10-02; sete biomas restantes implementados 2026-10-02, aguardam aprovação visual"
created: "2026-10-02"
relations: ["[[PLAN-054-direcao-de-chao-e-level-design-coeso-2026-10-02]]", "[[SPEC-115-riqueza-de-cenario-piloto-dagruve-docas]]"]
---

# SPEC-116 — Chão de Dagruve

Risco: **baixo** (só visual; nada de colisão, RNG ou dados de batalha).

## Ficha de direção (F0) — Dagruve
Distrito esquecido de Nottgard, névoa e culto. Valores: terra escura (base), laje cinza-violeta (claro), junta e borda de névoa (escuro).
Materiais: **terra batida**, **musgo azedo**, **laje antiga** (praça do selo, poço, ruínas ao norte e remendos de rua), **ombro de estrada** (terra pisada ao longo das ruas declaradas em `data/scenery.json`).
Leitura: a praça do selo é o centro ritual (estampa violeta sob a armadilha); as ruas são o eixo; a borda do mapa afunda na névoa.
Regra de contraste: o chão fica abaixo de herói, inimigos e projéteis (valores 0,15–0,34; os props e o decal de estrada seguem mais claros).

## Técnica
- `tools/bake_ground.gd` calcula o chão em **coordenadas de mundo** (tiles) e grava um PNG isométrico único 3840×1920 (`assets/tiles/dagruve_ground_baked_v1.png`).
  Sem malha de losangos, logo sem costura nem repetição; lajes são células de Voronoi com domínio deformado.
- `ui/ground.gd` ganhou `baked_texture_path`: se definido, desenha a imagem e ignora a malha de losangos. `ui/stages/dagruve.tscn` usa o novo caminho; o atlas antigo continua no repositório como fallback.
- Regerar: `godot --headless --path . -s tools/bake_ground.gd -- dagruve assets/tiles/dagruve_ground_baked_v1.png`, depois `godot --headless --path . --import`.
- As posições das ruas, da praça (42,38), do poço (36,41) e das ruínas (30,8) estão no script e espelham `data/scenery.json`; mudar um exige regerar.

## Ficha de direção (F0) — Docas
Cais, fenda e porão ritual. Valores: cascalho e lama de maré (azul-petróleo), calçada molhada, tábuas, água escura.
Materiais: **cascalho molhado** com poças, **calçada molhada** (faixa junto ao cais, pátio sul e remendos), **tábuas** (cais oeste, pátio do armazém, píer leste, com emendas escalonadas e tábuas podres), **água com espuma** além do cais, **laje do porão ritual** com mancha vinho em (40,28).
Técnica igual à de Dagruve: `godot --headless --path . -s tools/bake_ground.gd -- docas assets/tiles/docas_ground_baked_v1.png`. Constantes espelham `data/scenery.json` (cais x≈3,2; armazém (26,14); píer y=18; sul (21,43)).

## Biomas com macroterreno (F3)
Shedaklah, Molor, Durao, Feng-tu, Shendilavri, Goranthis e Pilares reaproveitam o layout existente (`TerrainLayout.material_at`): a ferramenta consulta uma tabela de materiais (5 células por tile) e pinta cada material com um estilo procedural (terra, cinza, laje, laje rachada, laje com veios, água, queda d'água, lodo com bolhas, rocha, margem, musgo, teia de micélio). A consulta é deslocada por ruído para bordas orgânicas; perto de água e margem o deslocamento cai a 0,3 tile para a jogabilidade (Estige, corrente) continuar coincidindo com o que se vê. Materiais vizinhos se misturam levemente nas bordas e cada bioma tem sua cor de névoa na borda.
Paletas por material estão em `_setup_layout` (`tools/bake_ground.gd`). Regerar: `godot --headless --path . -s tools/bake_ground.gd -- <bioma> assets/tiles/<bioma>_ground_baked_v1.png` e depois `--import`. Capturas `*_v2_*.png` em `.atena/generated/ground-review/`.

## Level design (F1) — Shedaklah
Ver PLAN-054, seção Progresso. Zonas de chão em `data/level_design.json` → `chao`; props por zonas no mesmo arquivo → `props` (substituem os 40 props soltos da cena em tempo de execução, sem tocar na RNG da batalha). Mudança de comportamento: os props de Shedaklah agora ficam em aglomerados (avenida, praça da estrutura, bosque, poço de lodo, esporos, margens) e nenhum nasce em água ou margem.

## Evidência
Capturas em `.atena/generated/ground-review/` (Dagruve: `dagruve_before.png`, `dagruve_v3.png`; Docas: `docas_before.png`, `docas_v2_*.png`, geradas por `tools/capture_ground_spots.tscn`). Suíte: 0 falhas.

## Pendências (próximas fases)
- Aprovação visual do dono; ajuste fino de valor, junta e tamanho de laje.
- Ler posições do `scenery.json` em vez de constantes; mover materiais para dados (F1).
- Nos sete biomas ainda não há zonas de level design próprias (eixo de caminho, landmarks, clareira de início): o chão segue as manchas do layout. É a F1 do PLAN-054.
- Peças de assinatura por imagegen (laje ritual, estrada) se o dono quiser mais estilo.
