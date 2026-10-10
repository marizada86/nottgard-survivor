---
id: "CHATGPT-FILA-029"
title: "Fila de geração: botão de ação principal (JOGAR), moldura de nove fatias (ART-047)"
status: "criada 2026-10-10; nenhuma peça gerada; aguardando o dono enviar ao ChatGPT"
priority: "baixa: refinamento visual do Quartel; não bloqueia o jogo (o botão atual funciona)"
created: "2026-10-10"
relations: ["[[ART-PROMPTS-062-botao-de-acao-jogar]]", "[[ART-PROMPTS-057-ficha-c-molduras-e-icones]]", "[[SPEC-166-nova-ui-lote-2-quartel-selecao-e-titulo-mec-003]]"]
---

# CHATGPT-FILA-029: botão JOGAR (ART-047)

Compilação operacional de [[ART-PROMPTS-062-botao-de-acao-jogar]]; em caso de dúvida, o ART-PROMPTS prevalece (traz o contexto, o aceite e a normalização).

## Como enviar

1. **Uma peça, uma chamada.** Anexar as três referências abaixo e dizer o papel de cada uma (a mensagem já diz).
2. **Destino da candidata:** `.atena/generated/art-candidates/botao-acao/B01_v01.png` (até 3). Nada entra em `assets/` antes da aprovação visual do dono em escala real.
3. Marque `[x]` ao gerar e `[a]` ao aprovar.

## Fila

- [ ] gerada · [ ] aprovada — B01 `botao_acao_moldura` (final 320×64, fatias 28/28/20/20)

## B01 — mensagem completa (colar no ChatGPT)

Anexar, nesta ordem:

1. `assets/ui/ficha/ficha_aba_moldura.png`
2. `assets/ui/ficha/ficha_moldura_detalhe.png`
3. `assets/ui/evolucao_painel_moldura.png`
4. *(opcional)* captura do Quartel com o JOGAR atual

```text
Vou te enviar referências de uma interface de jogo gótica e sombria. Preciso de UMA imagem: a moldura de um botão de ação principal (o botão "JOGAR"), sem texto.

Papel de cada referência:
1) ficha_aba_moldura: é a família da peça. Aço claro dessaturado, cantos chanfrados, filete interno escuro, rebites. O botão novo é o "irmão mais encorpado" desta aba; NÃO copie a espessura nem a proporção.
2) ficha_moldura_detalhe: cantos em colchete pontiagudo e filete fino na borda interna; é o nível de ornamento aceito.
3) evolucao_painel_moldura: só material e cor (metal escuro, ouro velho, brilho âmbar nas bordas internas). NÃO copie a composição.
4) (se enviada) captura do jogo: é só o contexto de uso do botão; NÃO copie o visual.

Use case: stylized-concept
Asset type: moldura de botão de ação principal de interface de jogo, recortável em nove partes
Primary request: faixa retangular baixa e larga, mais encorpada que um botão de aba, de aço claro dessaturado com cantos chanfrados e filete interno escuro; dois pequenos rebites discretos perto de cada extremidade; em cada extremidade uma ponta gótica curta e simétrica (até 28 pixels em uma imagem de 320 de largura, sem passar da altura da faixa); trecho central da moldura completamente liso e uniforme; interior preenchido com pedra escura quase preta, lisa, com grão muito fino
Style/medium: pixel art sombria densa, mesma família do botão de aba de referência, porém mais robusta e de acabamento mais nobre; tom NEUTRO claro (cinza-aço, sem cor própria) para tingimento por código
Composition/framing: vista frontal plana, proporção 5 para 1, moldura ocupando a largura toda da imagem; imagem com cerca de 1536 pixels de largura
Constraints: fundo fora da moldura liso magenta #FF00FF; bordas duras sem anti-aliasing contra o magenta; topo, base e trecho central uniformes e esticáveis na horizontal; ornamento somente nas duas extremidades; interior com variação de luminosidade de no máximo 6%; sem texto, números, runas legíveis, ícones, personagens, sombra projetada ou brilho fora do contorno
Avoid: ornamento no meio da faixa, relevo pesado que reduza a área interna, 3D, aparência de plástico, dourado saturado, vermelho vivo, qualquer cor própria na moldura (precisa ser neutra para ser tingida)
```

**Se a primeira candidata vier com defeito**, corrija **um** problema por tentativa (até 3), por exemplo:

- Colorida demais: "mesma peça, mas o aço totalmente neutro, cinza-claro sem tom de cor".
- Ornamento no meio: "mesma peça, mas a faixa central totalmente lisa; ornamento só nas duas extremidades".
- Fina demais (parece aba): "mesma peça, mais encorpada: a faixa com cerca de 1,5 vez a espessura, mantendo a proporção 5 para 1".
- Halo ou brilho fora do contorno: "mesma peça, bordas duras contra o magenta, sem brilho nem sombra fora do contorno".

## Aceite (resumo; o completo está no ART-PROMPTS-062)

Estica de 280 a 420 px de largura e de 56 a 72 px de altura sem deformar; "JOGAR" a 28 px cabe com folga; tingida em ouro, em tom claro e apagada continua legível; lê como ação principal ao lado das abas; sem halo magenta.
