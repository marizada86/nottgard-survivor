---
id: "ART-PROMPTS-059"
type: "prompts-de-arte"
title: "Ícones das bênçãos novas (SPEC-129)"
status: "ready-for-generation (geração só com aprovação do dono; cota de imagens)"
created: "2026-10-06"
relations: ["[[ART-PROMPTS-010-icones-passivas-bencaos-ui]]", "[[SPEC-129-dinamismo-bencaos-divinas-e-eventos]]", "[[EVID-169-b002-juramento-e-caminho-da-estrela-2026-10-06]]"]
sources: ["backlog ART-038, MEC-050", "data/boons.json", "assets/icons/boons/"]
---

# Ícones das bênçãos novas — `assets/icons/boons/<id>.png`

> Derivado. Não autoriza geração por si; o dono aprova o início do lote. Mesma família dos 14 ícones existentes (ART-PROMPTS-010): 1024×1024 na geração, **128×128 RGBA** no jogo; cada divindade mantém forma e cor comuns entre as suas bênçãos. Conferir a legibilidade a **48 px** na tela de escolha.

## Bloco comum

```text
Use case: stylized-concept
Asset type: ícone de HUD para jogo
Style/medium: pixel art sombria de alto contraste, contorno escuro grosso, poucos blocos de cor, silhueta clara a 32–48 px
Composition/framing: um símbolo central simples, 18% de margem, sem elementos soltos
Constraints: fundo realmente transparente; sem texto, letras, números, moldura, círculo de fundo, logotipo, marca-d'água ou aparência 3D
```

## Referências a anexar

| Arquivo | Papel |
|---|---|
| `assets/icons/boons/lliira_alegria.png`, `lliira_sorte.png` | Forma e paleta de Lliira (fitas dourada, azul e vermelho-seco). |
| `assets/icons/boons/tou_um_estrela.png` | Forma e paleta de Tou Um (estrela do Norte azul-branca, caminho vermelho estreito). |

## Peças prontas (B-002, já no jogo)

- [ ] **I01** `lliira_juramento` — Juramento de Lliira (`oath`). Pedido: três fitas de Lliira (dourada, azul e vermelho-seco) amarradas em torno de uma mão aberta e erguida, com a fita vermelho-seco ainda solta no fim.
- [ ] **I02** `tou_um_caminho` — Caminho da Estrela (`path`). Pedido: Estrela do Norte azul-branca no alto de um caminho vermelho estreito que sobe e se perde; uma pegada pequena na base.

## Peças da B-003

As bênçãos novas da SPEC-129 B-003 (só dados) entram aqui como **I03 em diante** quando a B-003 for aprovada e os `id` estiverem fixados em `data/boons.json`. Uma linha por bênção, no mesmo formato acima.

## Admissão

Salvar candidata em `.atena/generated/art-candidates/boons/<id>_v01.png` (até 3 por peça; cada nova tentativa corrige um defeito objetivo); aprovada vai para `assets/icons/boons/<id>.png`. Marque `[x]` ao gerar e `[a]` ao aprovar.
