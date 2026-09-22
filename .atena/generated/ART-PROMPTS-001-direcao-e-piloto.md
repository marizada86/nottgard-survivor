---
id: "ART-PROMPTS-001"
type: "prompts-de-arte"
title: "Direção de arte e lote piloto"
status: "draft"
created: "2026-09-21"
relations: ["[[SPEC-011-fase-1-prompts-de-arte]]", "[[ASSET-MATRIX-001-imagens-e-prompts-2026-09-21]]"]
sources: ["PLAN-001", "PLAN-002", "assets existentes", "nottcard-ai ART-PROMPTS-021"]
---

# Direção de arte e piloto

> Derivado. Não é fonte de lore. Este documento não autoriza geração.

## Como usar

1. Uma chamada de ImageGen por asset ou variante.
2. Anexar somente as referências listadas e declarar o papel de cada uma.
3. Pedir transparência real para figuras/props/ícones; nunca xadrez pintado.
4. Salvar candidatas como `<id>_v01.png` em `assets/_raw/`; aprovado sem sufixo no caminho final.
5. Máximo de três candidatas; cada nova tentativa corrige um problema objetivo.
6. Aprovar em escala real no jogo, nunca apenas no PNG isolado.

## Bloco comum — figuras

```text
Use case: stylized-concept
Asset type: sprite isométrico de personagem para jogo
Style/medium: pixel art densa e sombria, pixels nítidos, dithering controlado, contorno escuro, blocos de cor definidos; acabamento coerente com os sprites existentes de Nottgard Survivors
Composition/framing: uma única figura de corpo inteiro em três quartos isométrico, câmera cerca de 30 graus acima, voltada para baixo e à direita; pés/base na mesma linha, margens laterais de 10%, nada cortado
Lighting/mood: luz principal no alto à esquerda, atmosfera sombria, contraste forte e legível
Constraints: fundo realmente transparente com canal alfa; sem sombra projetada fora da base; sem cenário; sem texto, letras, números, moldura, logotipo ou marca-d'água; sem aparência 3D, anime ou cartoon; silhueta legível a 48–110 px
Avoid: fundo xadrez pintado, halo claro, blur, partículas soltas, membros escondidos, vista frontal plana
```

Matriz de geração: 1024×1536. Final inimigo: 320×480 RGBA. Final herói de run: 256×384 RGBA. O ponto de contato fica centralizado na borda inferior útil.

## Bloco comum — retratos

```text
Use case: stylized-concept
Asset type: retrato de seleção de herói
Style/medium: ilustração digital sombria com textura de pixel art fina, mesmo acabamento, contraste e densidade dos cinco retratos existentes
Composition/framing: busto em formato 3:2, personagem central, cabeça e ombros inteiros, 8% de margem, fundo atmosférico opaco simples
Lighting/mood: luz fria superior esquerda e pequeno acento quente; expressão séria e contida
Constraints: sem texto, moldura, logotipo ou marca-d'água; não inventar espécie, símbolos ou fatos não presentes nas referências
```

Matriz: 1536×1024. Final: 640×427 RGB.

## Piloto de validação

Usar nesta ordem, sem duplicar prompts: `notivago` de ART-PROMPTS-003, `korrak` de ART-PROMPTS-002 e, após integração aprovada, piso `dagruve` e prop `pilar_01` de ART-PROMPTS-007. O piloto valida identidade, alfa, câmera, linha dos pés, escala e contraste.

## Gate visual

- Alfa real e bordas sem halo.
- Luz superior esquerda e câmera coerentes.
- Silhueta reconhecível no tamanho renderizado.
- Chefe/elite distinguível por forma, não apenas por cor.
- Nada contradiz o vault ou revela spoiler além do conteúdo conhecido.

