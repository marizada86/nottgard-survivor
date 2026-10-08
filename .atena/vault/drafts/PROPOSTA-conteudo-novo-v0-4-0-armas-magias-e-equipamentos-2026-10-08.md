---
id: PROPOSTA-conteudo-v0-4-0
title: Conteúdo novo da v0.4.0 — 3 armas/magias e 6 equipamentos (portão de conteúdo, PLAN-081 B-005 S-013)
status: proposta aguardando aprovação do dono; nada codificado
created: 2026-10-08
relations: ["[[SPEC-148-lancamento-da-v0-4-0]]", "[[SPEC-149-npc-de-upgrade-de-magia-arcanista]]", "[[EVID-147-auditoria-vault-x-jogo-2026-10-03]]"]
---

# Proposta de conteúdo novo (MEC-042)

Regra: lore vem do Nottgard Vault (principal) e do Nottcard; nada de "cânone do mestre"; um commit, uma spec e um teste por item; números de partida são **rascunho** e passam pelo bot (`tools/bal_armas.gd`, `tools/bal_itens.gd`) antes de valer. Lido em 2026-10-08: o jogo já usa 18 itens únicos do Vault (a lista "não usados" do EVID-147 §4 está parcialmente desatualizada: Broche Celestial, Amuleto da Luz, Luneta de Korrak, Olho de Ghaunadaur, Lasca de Ailalore, Colar Rúnico de Thalion e Anel da Passagem Sombria já existem).

## A. Três armas/magias (cartas do Nottcard que o jogo ainda não tem)

Fonte: `F:\dev\nottcard\data\core\cards.json`. O jogo já tem 13 das 73 cartas. Estas três não têm e cobrem os três ofícios (Arcanista × 2, ferreiro × 1). O tipo de dano usa os que o jogo tem (`fisico`, `radiante`, `magico`, `fogo`).

| # | Nome (Nottcard) | Quem melhora | Tipo | Rascunho de números | Por quê |
|---|---|---|---|---|---|
| W1 | **Bola de Fogo** (carta amarela, 3d6, fogo, atinge todos) | Arcanista | `nova`, `fogo`, INT | 3d6, recarga 6,0 s, raio 3,4; níveis: 3d8; raio +0,5; recarga −0,8; 4d8 e +2 de dano. Evolução proposta ligada à passiva **Foco Arcano** | A magia de área clássica que faltava; contrasta com a Descarga Estelar (radiante, CAR) |
| W2 | **Lâmina de Sombra** (carta amarela, 1d8, necrótico/sombra, ignora 1 CAM) | Arcanista | `bolt`, `magico`, INT, perfura 1 | 1d8, recarga 1,8 s, alcance 9; ignora 1 CAM do alvo (campo novo `ignore_cam`, mesma ideia do `weaken`); níveis: 1d10; perfura +1; recarga −0,2; dois projéteis | Disparo mágico preciso contra alvo blindado; ecoa Mask e as sombras (Sylas) |
| W3 | **Romper Armadura** (carta vermelha, 1d6, CA do alvo −2) | Ferreiro | `melee`, `fisico`, FOR | 1d6, recarga 1,5 s, alcance 1,8, cone 55; reduz CA do alvo (reutiliza `weaken`); níveis: 1d8; `weaken` +1; recarga −0,2; 2d6 e +2 de dano. Evolução proposta ligada à passiva **Cota de Malha** | Arma de combate que quebra defesa; o único dos três que o ferreiro melhora |

Fora desta rodada (guardadas para depois): Raio Sombrio, Lança Mística, Pulso Psíquico, Toque Vampírico (a regra do dono é nunca melhorar curas, BAL-022), Névoa Fria.

**A aprovar:** se as evoluções de W1 e W3 entram (nomes seguiriam o padrão "Evolução" do jogo, ex.: *Bola de Fogo* → um nome do Nottcard/Vault; não vou inventar um sem a sua palavra) ou se as três saem só com níveis na 0.4.0.

## B. Seis equipamentos únicos (do Vault, ainda fora do jogo)

Cada um com fonte, slot, tier (profundidade em que passa a cair), bônus e uma maldição só quando o Vault registra. Ícones: reaproveitar o ícone da base de cada slot (provisório, ART-038/ART-041 estilo), sem gerar imagem.

| # | Item (Vault) | Slot / tier | Efeito em jogo (rascunho) | Base no Vault | Observação |
|---|---|---|---|---|---|
| E1 | **Cajado da Família Infernum** | arma, tier 3 | INT +2, CAM +1, área +10% | "Relíquia da família Infernum, feita de Yggdrasil e cravejada com pedras da estrela de Eléstria" (S21) | Sem arma concedida; só bônus |
| E2 | **Wave of Terror** | arma, tier 5 | FOR +1, dano +15%; **Maldição da Ambição Sombria:** −8 PV máximos | "Espada mágica com dano de ácido, ocultação em sombras e Maldição da Ambição Sombria" (S19/20) | A maldição aqui é só numérica (o texto do Vault não detalha) |
| E3 | **Colar de visão verdadeira do Santuário** | amuleto, tier 2 | precisão +2, crítico +3% | "Concede visão verdadeira"; ligado a Ghaunadaur; usado por Sylas; "maldição cujo funcionamento não foi esclarecido" | Sem maldição inventada; o texto fica "visão verdadeira" e o Vault manda |
| E4 | **Detector Arcano** | anel, tier 1 | coleta +1,5, sorte +2 | "Aparelho que detecta assinaturas mágicas" (S21) | Ajuda a achar loot e Ecos (casa com o MEC-039) |
| E5 | **Dispositivo Antimagia de Gilly** | armadura, tier 4 | CAM +3, INT −1 | "Projeta um escudo para cerca de cinco pessoas; cerca de 30 usos" (entregue por Gilly à escolta de Bella) | O custo em INT lembra que antimagia também afeta quem usa |
| E6 | **Dispositivo das Docas** | amuleto, tier 1 | redução de dano +1, CA +1 | "Mecanismo do porto que afasta criaturas do mar" (S21) | Item de Docas que dá peso à fase 2 |

Ficam de fora e por quê: Baralho de Muitas Coisas (efeito aleatório e peso narrativo de S24, Sylas), Jarra do Navio das Docas (efeito de arremesso difícil de traduzir), Colar de Ghaunadaur (toca o segredo do mestre, EVID-147 §3), Espelho das Almas Desejantes (reservado à relíquia de Goranthis, MEC-039 futuro), Livrinho, Plantas do Túmulo, Papiros e diários (viram Ecos).

## O que preciso de você (portão de conteúdo)

1. Aprova W1, W2 e W3 como estão, ou troca algum.
2. Evoluções: **sim para W1 e W3, sem evolução para W2** (recomendado) / todas / nenhuma.
3. Aprova E1 a E6 como estão, ou troca algum. Em especial, a maldição do E2 e o custo do E5.
4. Os números são ponto de partida: eu os meço com o bot e te devolvo o antes → depois.

## Passos seguintes (se aprovado)

SPEC-150 (W1 a W3) e SPEC-151 (E1 a E6) → um commit por item com teste, ícone provisório por slot, `bal_armas`/`bal_itens` antes e depois → EVID-206.
