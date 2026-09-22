---
id: "ART-PROMPTS-010"
type: "prompts-de-arte"
title: "Ícones de passivas, bênçãos e HUD"
status: "approved-for-generation"
created: "2026-09-21"
relations: ["[[ART-PROMPTS-001-direcao-e-piloto]]"]
sources: ["data/passives.json", "data/boons.json", "data/achievements.json", "PLAN-002"]
---

# Ícones — passivas, bênçãos e HUD

Cada linha é uma geração individual. Matriz 1024×1024; final 128×128 RGBA.

```text
Use case: stylized-concept
Asset type: ícone de HUD para jogo
Style/medium: pixel art sombria de alto contraste, contorno escuro grosso, poucos blocos de cor, silhueta clara a 32–48 px
Composition/framing: um símbolo central simples, 18% de margem, sem elementos soltos
Constraints: fundo realmente transparente; sem texto, letras, números, moldura, círculo de fundo, logotipo, marca-d'água ou aparência 3D
```

## Passivas — `assets/icons/passives/<id>.png`

| ID | Pedido específico |
|---|---|
| `forca` | Punho de manopla vermelho-seco apertando uma barra quebrada. |
| `inteligencia` | Prisma amarelo-dourado sobre livro fechado sem escrita. |
| `constituicao` | Coração azul protegido por duas placas de aço. |
| `carisma` | Máscara roxa elegante com pequeno brilho frontal. |
| `cota_de_malha` | Três elos grandes de aço entrelaçados. |
| `robe_arcano` | Gola e ombros de robe azul-violeta com gema central. |
| `botas_leves` | Par de botas de couro inclinado para frente com dois rastros curtos. |
| `regeneracao` | Gota de vida azul envolvendo pequeno broto dourado. |
| `foco_arcano` | Cristal violeta preso por aro metálico, energia concentrada para dentro. |
| `alcance` | Ponta de lança sobre três arcos concêntricos sem alvo textual. |
| `sabedoria` | Olho sereno azul dentro de losango dourado aberto. |
| `sorte_de_sendrinah` | Moeda estrelada equilibrada na ponta de um crescente. |
| `ganancia` | Mão enluvada fechando-se sobre três moedas antigas. |
| `pele_de_pedra` | Antebraço de pedra rachada formando punho defensivo. |

## Bênçãos — `assets/icons/boons/<id>.png`

Cada divindade mantém forma e cor comuns entre seu par.

| ID | Pedido específico |
|---|---|
| `sendrinah_cura` | Estrela suave azul-prateada envolvendo uma gota de vida. |
| `sendrinah_vida` | Mesma estrela protegendo um coração azul. |
| `mask_sombras` | Máscara negra parcialmente coberta por sombra roxa. |
| `mask_ladrao` | Mesma máscara sobre chave dourada capturada por dedos sombrios. |
| `lliira_alegria` | Três fitas dourada, azul e vermelho-seco girando em torno de chama alegre. |
| `lliira_sorte` | Mesmas fitas envolvendo moeda que cai em pé. |
| `shar_noite` | Disco negro eclipsando estrela violeta. |
| `shar_perda` | Mesmo eclipse com fragmento de memória se desfazendo para dentro. |
| `ghaunadaur_fome` | Olho roxo cercado por boca circular de slime, sem gore. |
| `ghaunadaur_olho` | Mesmo olho aberto com três pequenos tentáculos formando triângulo. |
| `tou_um_estrela` | Estrela do Norte azul-branca acima de caminho vermelho estreito. |
| `helion_saber` | Sol âmbar atrás de livro escuro fechado, sem escrita. |

## HUD — `assets/icons/ui/<id>.png`

| ID | Pedido específico |
|---|---|
| `coin` | Moeda antiga dourada com entalhe geométrico simples. |
| `kill` | Crânio demoníaco minimalista atravessado por risco vermelho-seco. |
| `ca` | Escudo de aço com marca curta de impacto físico. |
| `cam` | Escudo violeta com onda arcana absorvida. |
| `health` | Coração vermelho-seco com brilho âmbar discreto. |
| `xp` | Fragmento cristalino azul-ciano apontando para cima. |
| `target` | Ponta de lança branca no centro de quatro marcas angulares. |
| `essence` | Frasco pequeno contendo três camadas de energia — verde, azul e violeta — sem mistura turva. |

## Conquistas

Os 18 IDs de `achievements.json` reutilizam, no primeiro passe, o ícone do conteúdo que desbloqueiam ou um dos ícones acima. Não há prompt nem imagem nova até que a UI demonstre necessidade de medalhas exclusivas.

## Aceite

- Cada ícone continua reconhecível em 32 px e em escala de cinza.
- Pares de bênçãos compartilham divindade sem serem idênticos.
- CA e CAM são distinguíveis por forma além da cor.
- Nenhum símbolo introduz escrita, número ou iconografia religiosa não aprovada.
