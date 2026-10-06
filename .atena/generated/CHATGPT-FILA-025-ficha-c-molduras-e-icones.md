---
id: "CHATGPT-FILA-025"
title: "Fila de geração: ficha C, molduras, slots, abas e textura (ART-035)"
status: "na fila desde 2026-10-06; A01 pronta para enviar; demais aguardam a aprovação da A01"
priority: "alta (2ª da fila, logo depois do PLAN-053 em andamento; antes das filas 022 e 023)"
created: "2026-10-06"
relations: ["[[ART-PROMPTS-057-ficha-c-molduras-e-icones]]", "[[SPEC-130-ficha-c-em-abas-grade-e-detalhe]]"]
---

# CHATGPT-FILA-025: ficha C (ART-035)

Compilação operacional de [[ART-PROMPTS-057-ficha-c-molduras-e-icones]]; em caso de dúvida, o ART-PROMPTS prevalece (inclui o bloco comum, os tamanhos finais e os critérios de aceite).

## Ordem de envio

1. Uma peça por chamada. Anexar as referências do ART-PROMPTS-057 e dizer o papel de cada uma.
2. Destino dos candidatos: `.atena/generated/art-candidates/ficha-c/<id>_v01.png` (até 3 por peça). Nada entra em `assets/` sem passar na verificação em escala real no jogo.
3. Marque `[x]` ao gerar e `[a]` ao aprovar.


## Prioridade (decidida por Atena em 2026-10-06, a pedido do dono)

**Alta, 2ª da fila de imagens.** Ordem das filas abertas:

1. **PLAN-053** (heróis, Shu: `attack_02`, `death_03`, `death_04`), já em andamento e ligado ao BUG-025.
2. **Esta fila (ficha C, 10 peças).** Motivos: o layout já foi validado e aceito pelo dono; são poucas imagens, sem animação nem auditoria de quadros; e a SPEC-131 (HUD da run no padrão da ficha C) segue o mesmo visual e pode reaproveitar estas molduras, então a arte pode destravar duas telas.
3. FILA-021 (E e F, golpes de exceção).
4. FILA-022 e FILA-023 (projéteis e habilidades), que só começam depois da aprovação do piloto da FILA-020.

Dentro desta fila, a ordem é a da lista da seção "Fila" abaixo: A01 define o tom e vai primeiro.

## Fila

- [ ] gerada · [ ] aprovada — A01 `ficha_moldura_painel` (enviar primeiro; define o tom das outras)
- [ ] gerada · [ ] aprovada — A03 `ficha_slot_moldura`
- [ ] gerada · [ ] aprovada — A04 `ficha_slot_vazio`
- [ ] gerada · [ ] aprovada — A02 `ficha_moldura_detalhe`
- [ ] gerada · [ ] aprovada — A05 `ficha_aba_moldura`
- [ ] gerada · [ ] aprovada — A06 `ficha_aba_armas`
- [ ] gerada · [ ] aprovada — A07 `ficha_aba_equipamento`
- [ ] gerada · [ ] aprovada — A08 `ficha_aba_passivas`
- [ ] gerada · [ ] aprovada — A09 `ficha_aba_sinergias`
- [ ] gerada · [ ] aprovada — A10 `ficha_fundo_textura`

## A01 — `ficha_moldura_painel` (mensagem completa)

Anexar: `assets/ui/evolucao_painel_moldura.png`, com o papel "material, cor e família de ornamento; **não** copiar a composição nem a espessura, a nova moldura é muito mais fina". Pedir imagem 16:9 (1536×864 ou o 16:9 mais próximo).

```text
Use case: stylized-concept
Asset type: moldura externa de painel de ficha de personagem para jogo
Primary request: moldura retangular fina de ferro escuro e ouro velho; faixa lateral e inferior com cerca de 36 pixels de espessura na imagem de 1280×720, lisa, com pequenos rebites discretos e um filete âmbar apagado na borda interna; ornamentos góticos pontiagudos apenas nos quatro cantos (até 96 pixels), e um pequeno ornamento central no meio da borda superior (até 56 pixels de altura); centro vazio
Style/medium: pixel art sombria coerente com a moldura de evolução de referência, porém muito mais fina e discreta
Composition/framing: vista frontal plana, proporção exata 16 para 9, moldura ocupando a imagem toda; ocupar menos de 7% da largura em cada lado, salvo os cantos
Constraints: fundo fora da moldura e centro lisos magenta #FF00FF; bordas duras sem anti-aliasing contra o magenta; ornamento somente nos cantos e no meio da borda superior; faixa lateral lisa e repetível; sem texto, números, runas legíveis, personagens, sombra projetada ou brilho fora do contorno
Avoid: ornamento no meio das laterais, relevo pesado que reduza a área útil, 3D, aparência de plástico, dourado saturado, vermelho vivo
```

Aceite: lateral e base ≤ 36 px; ornamentos de canto não invadem a coluna do herói nem o botão de fechar; o ornamento do topo não cobre o título à esquerda nem as abas à direita.
