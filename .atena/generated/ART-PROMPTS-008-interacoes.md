---
id: "ART-PROMPTS-008"
type: "prompts-de-arte"
title: "Interações do mapa"
status: "draft-future-integration"
created: "2026-09-21"
relations: ["[[ART-PROMPTS-001-direcao-e-piloto]]"]
sources: ["PLAN-001", "PLAN-002"]
---

# Interações

Matriz 1024×1024; final 192×192 RGBA em `assets/interactions/<id>.png`; candidatas em `assets/_raw/interactions/`.

```text
Use case: stylized-concept
Asset type: interação isométrica de mapa
Style/medium: pixel art densa e sombria, contorno escuro, alto contraste, luz superior esquerda
Composition/framing: um objeto compacto em três quartos isométrico, base central inferior, 15% de margem, legível a 40–64 px
Constraints: fundo realmente transparente, sem chão ou sombra separada, texto, letras, números, moldura, logotipo ou marca-d'água
```

### `chest_closed`
```text
Baú fechado de madeira muito escura com cantoneiras de ferro oxidado e fecho simples, aparência comum e indistinguível de um possível mímico. Nada de olhos, dentes, brilho ou pistas.
```

### `chest_open`
Referência: `chest_closed`. `O mesmo baú, mesma câmera e materiais, tampa aberta mostrando poucas moedas sujas e brilho âmbar contido; nenhum traço de criatura.`

### `fountain_active`
```text
Fonte baixa de pedra rachada com bacia octogonal e água azul-clara luminosa, fluxo ativo e compacto preso ao objeto; aparência benéfica, mas antiga.
```

### `fountain_spent`
Referência: ativa. `A mesma fonte seca, mesma câmera e geometria, bacia vazia, pedra mais escura e apenas duas gotas sem brilho.`

### `altar_active`
```text
Altar baixo de pedra com tigela de oferenda, três velas âmbar e quatro encaixes neutros para bênçãos; sem símbolo de divindade reconhecível.
```

### `altar_spent`
Referência: ativo. `O mesmo altar após uso, velas apagadas, tigela vazia e pedra sem brilho; preservar geometria e câmera.`

### `ritual`
```text
Pequeno arranjo ritual abissal de velas, quatro pedras, correntes e um núcleo roxo flutuando baixo; marcas são geométricas sem letras, e todos os efeitos ficam presos à base.
```

### `portal`
```text
Portal de passagem entre camadas: arco irregular de pedra abissal com abertura vertical escura e borda lilás, pequenas cores das essências já conquistadas embutidas como fragmentos; compacto, sem revelar a próxima fase.
```

Aceite: pares ativo/gasto preservam identidade; baú fechado não denuncia mímico; estados distinguíveis sem depender só de cor.

