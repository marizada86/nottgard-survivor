---
id: "ART-PROMPTS-013"
type: "prompts-de-arte"
title: "Fundos de tela e identidade do aplicativo"
status: "approved-for-generation"
created: "2026-09-22"
relations: ["[[ART-PROMPTS-001-direcao-e-piloto]]", "[[RESEARCH-002-biblioteca-visual-desktop-2026-09-21]]", "[[SPEC-015-producao-total-de-assets-visuais]]"]
sources: ["reference-staging/menu.png", "reference-staging/vitoria.png", "reference-staging/game_over.png", "PLAN-001"]
---

# Fundos de tela

Use as três referências somente para composição, atmosfera e densidade de pixel art. Remova totalmente selo, texto, logo, HUD e personagens identificáveis. Matriz 1536×1024; final 1920×1080 RGB, com crop seguro 16:9 e zona de leitura para UI.

## `quartel_background`

Referência: `.atena/evidence/reference-staging/menu.png`.

```text
Use case: stylized-concept
Asset type: fundo do menu principal de jogo
Primary request: vista ampla das docas e do Quartel de Nottgard durante a noite sem fim, aventureiro anônimo de costas em primeiro plano baixo, cidade de pedra e mar ao longe
Style/medium: pixel art cinematográfica sombria, pixels nítidos e paleta azul-negra com acentos âmbar
Composition/framing: 16:9, centro e lado esquerdo com baixo detalhe para painéis; horizonte alto, profundidade isométrica sutil
Lighting/mood: névoa fria, poucas janelas quentes, sensação de preparação antes da descida
Constraints: sem texto, logotipo, watermark, botões, HUD ou rosto reconhecível
```

## `victory_background`

Referência: `.atena/evidence/reference-staging/vitoria.png`.

```text
Use case: stylized-concept
Asset type: fundo de resultado de vitória
Primary request: campo abissal após a batalha, figura anônima de costas diante de uma fissura sendo selada, luz azul e âmbar atravessando névoa roxa
Style/medium: pixel art cinematográfica sombria coerente com o menu
Composition/framing: 16:9, foco ambiental no terço direito; grande área escura limpa no lado esquerdo para estatísticas
Lighting/mood: alívio contido, custo e exaustão, sem celebração colorida
Constraints: sem texto, logotipo, watermark, HUD ou personagem identificável
```

## `defeat_background`

Referência: `.atena/evidence/reference-staging/game_over.png`.

```text
Use case: stylized-concept
Asset type: fundo de resultado de derrota
Primary request: campo abissal silencioso, figura anônima ajoelhada entre névoa violeta e pedras, cidade distante quase apagada
Style/medium: pixel art cinematográfica sombria coerente com o menu
Composition/framing: 16:9, foco baixo no terço direito; grande área escura limpa no lado esquerdo para estatísticas
Lighting/mood: derrota melancólica, sem gore, pequena brasa distante sugerindo continuidade
Constraints: sem texto, logotipo, watermark, HUD ou personagem identificável
```

## Ícone do aplicativo — diretiva vetorial

Não usar ImageGen para letras. Redesenhar `icon.svg` por código com: losango isométrico abissal, monólito central em negativo, violeta quase preto, lilás elétrico e ouro gasto; manter legibilidade em 16, 32, 64 e 128 px. O nome permanece texto renderizado pela fonte do jogo, não dentro do ícone.

