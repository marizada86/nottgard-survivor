---
id: "EVID-211"
title: "PLAN-082 B-001: piloto da pré-redução das tiras no Kayron (BUG-029)"
created: "2026-10-09"
plan: "PLAN-082"
spec: "SPEC-154"
cards: ["BUG-029", "BUG-025"]
status: "S-001 a S-003 feitos; S-004 (escolha visual do dono) pendente; sem commit"
---

# EVID-211 — Piloto no Kayron (B-001)

## O que existe agora

- `tools/reduce_hero_strips.gd`: reduz cada quadro das 12 tiras do herói (célula 256×384), com alfa pré-multiplicado, sem ler o quadro vizinho. Modos `a` (média por área, 1:1 em tela), `b` (Lanczos 3, 1:1) e `c` (média por área, 2× a altura em tela). **Determinística** (três execuções, o mesmo hash MD5 em `idle.png`) e rápida (~6 s por herói e variante).
- `ui/hero_view.gd`: suporte a `HERO_STRIP_SET` (tabela por herói, hoje vazia) e a `strip_override` (só capturas e testes). Com a tabela vazia o jogo é idêntico ao de antes; a suíte completa dá `testes: 0 falha(s)`.
- `tools/capture_hero_variants.gd`: o herói com o conjunto original e as variantes A, B e C lado a lado em jogo, recorte de 80×100 px ampliado 5× sem suavizar.
- Variantes geradas (ainda não adotadas): `assets/animations/heroes_screen_preview/{a,b,c}/kayron/` (não commitar antes da escolha).

## Medidas do idle do Kayron (quadro 1)

| | Altura (alfa > 8) | Pés | Corte na borda | Solidez do miolo |
|---|---|---|---|---|
| Original (célula 256×384) | 316 | 376 | 0 | 0,980 |
| A (célula 54×81, fator 0,2089) | 67 (esperado 66) | 79 (78,5) | 0 | 0,961 |
| B (54×81) | 69 | 81 | **1 px (halo de Lanczos toca a borda de baixo)** | 0,963 |
| C (107×161, fator 0,4177) | 133 (esperado 132) | 158 (157,1) | 0 | 0,971 |

A altura passa 1 px do esperado porque o limiar de alfa conta a borda suavizada. A variante B gera um halo (anel de Lanczos) que toca a borda inferior da célula.

## O que as capturas mostram

[Capturas](../generated/bug-029-reducao/capturas/): `kayron_z1.0.png`, `kayron_z1.5.png`, `kayron_z2.0.png` (colunas: original, A, B, C; linha de cima idle, de baixo andando para leste).

- **Zoom 1,0:** o original mostra os **pontos brancos soltos** na armadura (o bug). A, B e C **eliminam** os pontos; os pés ficam sobre a sombra, na mesma posição. A e B ficam **mais suaves e escuros** (menos detalhe); **C mantém o detalhe** e o contraste.
- **Zoom 2,0:** A e B viram **blocos grandes** (a arte de 1:1 ampliada 2×); o original e a C continuam **nítidos**, porque têm resolução de sobra.

## Recomendação da Atena (a escolha é do dono)

**Variante C** (supersample 2:1): limpa os pontos soltos, mantém o detalhe a zoom 1,0 e não vira bloco quando a câmera aproxima. Custo: arquivos 4× maiores que a A (ainda pequenos: o conjunto do Kayron reduzido fica em poucas centenas de KB) e vizinho mais próximo a 2:1 (granulado fino). A e B só valem se o jogo nunca usar zoom acima de 1,0.

## Pendências

S-004: o dono escolher a variante (ou rejeitar). Sem a escolha, nenhum herói é alterado e os arquivos de `heroes_screen_preview/` ficam fora do Git.

## Adendo (2026-10-09): variante C escolhida, margem anticorte e integração do Kayron (B-002)

**Decisão do dono:** variante **C**, "tomando cuidado para não cortar a imagem: as pontas dos assets estão sumindo na linha limite do asset do personagem".

**Verificação do risco de corte** (`tools/audit_strip_edges.gd`, quadro a quadro, pixel visível = alfa > 8):

| O que | Resultado |
|---|---|
| Originais usados pelo jogo (idle, move_e/se/s/n/ne, attack, active, death) dos **dez heróis** | nenhum encostado na borda; menor margem 3 px (Sylas attack, Brook move_e, Kayron death); Korrak e os demais ≥ 4 px |
| Originais não usados (`move_nw`, `move_sw`, `move_w` do Kayron) | **cortados na borda em todos os quadros**, mas o jogo não os carrega (nw, sw e w são espelhos de ne, se e e); ficam como estão |
| Variante C sem margem | menor margem 1 px (death) e 0 px encostados: apertado demais |
| **Variante C com margem de 2 px** (célula 111×165) | menor margem **3 px** (death), 4 a 6 px nas demais; **0 quadros encostados e 0 a 1 px da borda** nos 68 quadros |

**Correção:** `tools/reduce_hero_strips.gd` agora coloca cada quadro reduzido numa célula com **2 px de margem transparente** (`PAD`), de modo que nem a suavização da redução nem um halo possam ser cortados. O `HERO_STRIP_SET` leva `pad`; `cell_of` soma 2×pad à célula e a linha dos pés soma `pad`. A altura em tela não muda.

**Integração (S-005 a S-007):** `HERO_STRIP_SET[kayron] = {dir: heroes_screen/kayron, factor: 0.4177215 (2 × 66/316), pad: 2}`; tiras em `assets/animations/heroes_screen/kayron/` (12 arquivos, 1,5 MB); originais intactos. Teste novo `tests/test_hero_strips.gd` (fator 1× ou 2×, margem ≥ 2, célula, altura em tela igual, e, para cada quadro das nove tiras usadas: nenhum pixel visível a menos de 2 px da borda, altura e pés dentro de 2,5 e 2 px do esperado, solidez do miolo ±0,03, mesmos quadros por tira, originais presentes) e ajuste de `test_animation_assets` (a escala conta o fator). Suíte `0 falha(s)`, `smoke: ok`, `kit: OK`, `audit_projeto` sem erros.

**Capturas finais** (original à esquerda, o jogo com a tabela à direita): `capturas/kayron_original-x-tabela_z1.0.png` e `..._z2.0.png`: mesma altura, mesma posição, pés sobre a sombra, pontas da capa e botas inteiras, sem os pontos brancos soltos.

**Observações:** (1) no zoom 2,0 a C fica um pouco mais suave que o original; é o custo da redução (o original, sem filtro, amplia a arte grande). (2) 10 heróis na variante C ocupam cerca de 15 MB; confere no fechamento (critério 5 da SPEC-154).
