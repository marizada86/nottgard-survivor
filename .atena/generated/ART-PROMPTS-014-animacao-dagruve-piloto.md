---
id: "ART-PROMPTS-014"
type: "prompts-de-arte"
title: "Piloto de animação de Dagruve"
status: "generated-and-integrated"
created: "2026-09-22"
relations: ["[[ART-PROMPTS-001-direcao-e-piloto]]", "[[ART-PROMPTS-011-herois-run-e-inimigos-legado]]", "[[SPEC-017-piloto-animacao-dagruve]]"]
sources: ["assets/heroes/durvall.png", "assets/enemies/zumbi.png", "assets/enemies/sacerdote_mente_derretida.png", "assets/interactions/*.png", "data/stages.json", "data/boss_phases.json"]
---

# Piloto de animação de Dagruve

## Bloco comum obrigatório

Use case: `stylized-concept`. Asset type: folha-fonte de animação para jogo 2D isométrico. A imagem anexada é referência obrigatória de identidade, proporção, roupa/objeto, material, paleta e acabamento. Preservar câmera três-quartos isométrica, luz superior esquerda, escala e recorte. Fundo com alfa real; corpo/objeto inteiro; mesma linha de base em todos os quadros; nenhum quadro pode invadir outro. Sem cenário, piso, sombra projetada, texto, rótulo, grade, borda, watermark, motion blur, membro extra, objeto duplicado ou redesign.

Cada linha abaixo é uma chamada independente. O resultado é processado deterministicamente para tira horizontal de células fixas.

## Durvall — referência `assets/heroes/durvall.png`

| Sequência | Quadros | Grade-fonte | Movimento |
|---|---:|---:|---|
| `idle` | 4 | 2×2 | respiração mínima; cabelo e faixa oscilam; pés plantados |
| `move` | 6 | 3×2 | corrida isométrica controlada; passada legível; espada segura |
| `attack` | 4 | 2×2 | preparação, arco curto da espada, contato e recuperação |
| `active` | 6 | 3×2 | Ruptura Sombria: concentra a espada, corte frontal pesado e recuperação |
| `death` | 6 | 3×2 | perde força, ajoelha e cai; sem gore; quadro final estável |

## Zumbi — referência `assets/enemies/zumbi.png`

| Sequência | Quadros | Grade-fonte | Movimento |
|---|---:|---:|---|
| `idle` | 4 | 2×2 | balanço morto e respiração inexistente; braços pendem |
| `move` | 6 | 3×2 | marcha arrastada irregular, mantendo leitura dos pés |
| `attack` | 4 | 2×2 | recuo curto, golpe com braços, contato e retorno |
| `death` | 6 | 3×2 | pernas cedem e corpo desaba; sem gore; final estável |

## Sacerdote da Mente Derretida — referência `assets/enemies/sacerdote_mente_derretida.png`

| Sequência | Quadros | Grade-fonte | Movimento |
|---|---:|---:|---|
| `idle` | 6 | 3×2 | flutuação/respiração ritual, cera e turíbulo com movimento contido |
| `move` | 8 | 4×2 | deslize cerimonial lento; vestes e turíbulo atrasam o corpo |
| `attack` | 6 | 3×2 | ergue a mão, golpe mágico curto e recuperação |
| `special_a` | 8 | 4×2 | invocação: turíbulo descreve arco e libera névoa controlada |
| `special_b` | 8 | 4×2 | anel: abre os braços e descarrega energia radial |
| `phase` | 8 | 4×2 | turíbulo se rompe e cera/mente se agitam; transformação sem mudar identidade |
| `death` | 10 | 5×2 | cera perde sustentação e vestes colapsam; sem gore; final estável |

## Interações — referência do PNG homônimo em `assets/interactions/`

| Sequência | Quadros | Grade-fonte | Movimento |
|---|---:|---:|---|
| `chest_open` | 6 | 3×2 | fechado → trava cede → tampa abre; último quadro corresponde ao aberto |
| `fountain_active` | 6 | 3×2 | água circula e pulsa; pedra imóvel; loop contínuo |
| `altar_active` | 6 | 3×2 | chama e recipiente pulsam; base imóvel; loop contínuo |
| `ritual` | 8 | 4×2 | runas e chama circulam; estrutura imóvel; loop contínuo |
| `portal` | 8 | 4×2 | vórtice gira/pulsa dentro do arco; pedras imóveis; loop contínuo |

## Aceite visual

- Identidade e silhueta inequívocas quando comparadas ao PNG estático.
- Nenhum salto de tamanho, câmera, pés/base ou objeto entre quadros.
- Alfa verdadeiro sem halo preto/branco.
- Movimento legível a 8–12 FPS e na altura real de 54–100 px em 1280×720.
- O primeiro/último quadro das transições se conecta ao estado estático correspondente.
