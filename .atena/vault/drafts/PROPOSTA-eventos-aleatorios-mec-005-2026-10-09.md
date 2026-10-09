---
id: PROPOSTA-eventos-aleatorios-mec-005
status: APROVADA como está pelo dono em 2026-10-09 (revisão 1); CANON de trabalho
revision: 1
created: 2026-10-09
spec: SPEC-164
---

# Proposta de conteúdo: 6 eventos aleatórios novos (MEC-005)

**Estado: DRAFT.** Nada daqui é canon nem código até a sua aprovação. Entrevista de 2026-10-09: 6 eventos **genéricos** (todas as fases), cobrindo os quatro tipos que você marcou: risco e recompensa, encontros com NPC e lore, emboscadas e perigos, eventos que mudam a run.

Convenções: todos entram no mesmo sorteio da loja, do altar e da aposta (`data/stages.json` → `interactions`), a cada 80 a 115 s, no máximo 3 vivos (`data/difficulty.json`). Todo evento tem **"Sair" sem custo** e diz com clareza o que dá e o que custa. Arte **provisória**: losango colorido com rótulo, como o Arcanista (sem PNG; ART registrada para depois). Texto sem lore do Vault que seja segredo do mestre; só frases genéricas de ambiente.

| # | Evento | Tipo | Peso | Cor do losango |
|---|---|---|---|---|
| 1 | Pacto de Sangue | risco e recompensa | 0,7 | vermelho |
| 2 | Relicário Lacrado | risco e recompensa | 0,7 | dourado-escuro |
| 3 | Peregrino Ferido | NPC | 0,8 | azul-claro |
| 4 | Contador de Histórias | lore | 0,7 | verde |
| 5 | Carroça Abandonada | emboscada | 0,8 | laranja |
| 6 | Pedra do Eclipse | muda a run | 0,6 | roxo |

## 1. Pacto de Sangue (risco e recompensa)

*"Um selo de cera vermelha pulsa no chão. Algo promete força em troca do que corre nas suas veias."*

| Opção | Custo | Ganho |
|---|---|---|
| Selo menor | −15% da vida máxima até o fim da run | +12% de dano até o fim da run |
| Selo maior | −30% da vida máxima até o fim da run | +25% de dano até o fim da run |
| Sair | nada | nada |

Regras: a vida atual cai na mesma proporção (nunca mata); a vida máxima nunca fica abaixo de 20; a soma dos pactos da run perde no máximo 45% da vida máxima (depois disso, "O selo recusa quem já deu demais"). Cada selo é consumido ao usar.

## 2. Relicário Lacrado (risco e recompensa)

*"Um cofre de ferro com fechadura de ossos. Só abre com sangue ou com ouro."*

| Opção | Custo | Ganho |
|---|---|---|
| Abrir com sangue | 25% da vida atual (indisponível com menos de 40% de vida) | 1 equipamento **raro ou melhor** |
| Arrombar com ouro | 200 moedas × multiplicador de moeda da fase | 1 equipamento **mágico ou melhor** |
| Sair | nada | nada |

## 3. Peregrino Ferido (NPC)

*"Um viajante caído ao lado da estrada, a mão no flanco. 'Por favor...'"*

| Opção | Custo | Ganho / consequência |
|---|---|---|
| Ajudar | 30% das moedas atuais | **Gratidão do Peregrino**: +8% de XP e +0,6 de coleta por 120 s, e XP igual a 25% do nível atual |
| Conversar | nada | Uma lição do lugar: XP igual a 15% do nível atual |
| Roubar | nada | +15 moedas × multiplicador da fase, mas 6 inimigos da fase o cercam (vingança) |
| Sair | nada | nada |

## 4. Contador de Histórias (lore)

*"Uma figura de capuz junto a uma fogueira baixa: 'Escolha que história quer levar daqui.'"*

Mostra **3 histórias** sorteadas entre 6; cada uma é uma frase de ambiente do lugar e dá um bônus pela run inteira. Escolher uma encerra o evento.

| História (bônus) | Valor |
|---|---|
| Dos que Caminham (velocidade) | +6% |
| Dos que Colhem (coleta) | +0,5 |
| Dos que Lutam (dano) | +5% |
| Dos que Resistem (CA) | +1 |
| Dos que Lembram (XP) | +6% |
| Dos que Esperam (recarga da habilidade) | −6% |

As frases usam o texto de ambiente que já existe em `data/stage_story.json` (epígrafes aprovadas). Frases novas por fase, a partir do Vault, ficam para uma segunda rodada, com a sua aprovação.

## 5. Carroça Abandonada (emboscada)

*"Uma carroça tombada, a carga espalhada. Pode ser só sorte. Pode ser isca."*

| Opção | Resultado |
|---|---|
| Vasculhar | **60%**: um equipamento raro ou 40 moedas × multiplicador da fase. **40%: emboscada**: 8 inimigos comuns da fase aparecem em círculo e 1 elite; a elite solta um baú |
| Sair | nada |

O texto do evento avisa "pode ser uma emboscada" (não é pegadinha).

## 6. Pedra do Eclipse (muda a run)

*"Uma pedra negra que não reflete luz. Quando você a toca, o céu se fecha."*

| Opção | Efeito por **90 s** |
|---|---|
| Eclipse Rubro | inimigos +25% de velocidade e de dano; **XP e ouro ×1,5** |
| Eclipse Prateado | inimigos −20% de velocidade e de dano; XP e ouro ×0,8 |
| Sair | nada |

Só um eclipse por vez (com um ativo, a pedra não aparece). Um chip na HUD mostra o eclipse e o tempo restante; o chefe **não** é afetado.

## O que você aprova

1. A lista dos 6 e os números acima (ou os ajustes que quiser).
2. Pesos: total novo de 4,3 contra 5,8 dos atuais de evento: o sorteio fica mais variado. Se pesar demais, reduzo no JSON.
3. Arte provisória: losango colorido com rótulo. Os ícones finais viram um cartão ART.
