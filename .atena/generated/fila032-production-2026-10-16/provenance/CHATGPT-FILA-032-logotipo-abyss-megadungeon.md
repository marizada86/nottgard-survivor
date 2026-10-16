---
id: "CHATGPT-FILA-032"
title: "Fila de geração: logotipo do título com o nome novo, Nottgard - Abyss Megadungeon (ART-049)"
status: "criada 2026-10-15; nenhuma peça gerada; G-1 resolvida; aguardando o dono enviar ao ChatGPT"
priority: "ALTA: pedido do dono em 2026-10-15; o título ainda mostra SURVIVORS até a peça entrar"
created: "2026-10-15"
relations: ["[[ART-PROMPTS-065-logotipo-abyss-megadungeon]]", "[[ART-PROMPTS-058-lettering-placas-e-cursor]]", "[[SPEC-181-renomeacao-nottgard-abyss-megadungeon]]"]
---

# CHATGPT-FILA-032: logotipo novo (ART-049)

Compilação operacional de [[ART-PROMPTS-065-logotipo-abyss-megadungeon]]; em caso de dúvida, o ART-PROMPTS prevalece (traz o inventário, o aceite e a integração).

## Antes de enviar

**G-1 resolvida (dono, 2026-10-16):** lockup `NOTTGARD` / `ABYSS MEGADUNGEON`, sem hífen escrito. O prompt abaixo já está nessa forma.

## Como enviar

1. **Uma peça, uma chamada.** Anexar as três referências abaixo e dizer o papel de cada uma (a mensagem já diz). Avisar que a chave é **ciano #00FFFF**.
2. **Destino da candidata:** `.atena/generated/art-candidates/lettering/LN01_v01.png` (até 3). Nada entra em `assets/` antes da aprovação visual do dono em escala real.
3. Marque `[x]` ao gerar e `[a]` ao aprovar.

## Fila

- [ ] gerada · [ ] aprovada — LN01 `logo` v2 (final até 1100×176)

## LN01 — mensagem completa (colar no ChatGPT)

Anexar, nesta ordem:

1. `assets/ui/title/logo.png`
2. `assets/ui/title/title_background.png`
3. `assets/ui/evolucao_painel_moldura.png`

```text
Vou te enviar referências de um jogo gótico e sombrio. Preciso de UMA imagem: o logotipo do título com o nome novo do jogo. Use fundo ciano #00FFFF liso (a peça tem roxo, por isso não magenta).

Papel de cada referência:
1) logo (o logotipo atual): MANTENHA a palavra NOTTGARD, o material, o bisel, as pontas góticas e a rachadura roxa; só a linha de baixo muda (de SURVIVORS para ABYSS MEGADUNGEON).
2) title_background: só o clima e a paleta; o logo vai por cima dele. NÃO inclua o fundo na imagem.
3) evolucao_painel_moldura: só material e cor (metal escuro, ouro velho). NÃO copie a composição.

Use case: stylized-concept
Asset type: logotipo do jogo "Nottgard - Abyss Megadungeon" para tela de título
Primary request: lockup em duas linhas centralizado, na mesma família do logotipo de referência: linha de cima "NOTTGARD" em capitais grandes idênticas em estilo e material às da referência; linha de baixo "ABYSS MEGADUNGEON" em capitais menores (cerca de 40% da altura da linha de cima), com espaço entre letras generoso para ler as dezessete letras; ouro velho forjado com bisel, contorno quase preto, rachadura fina de luz roxa abissal passando por trás das letras (dentro do contorno), pequenos espinhos e arcos góticos só nas duas pontas laterais, em simetria; proporção do conjunto entre 6:1 e 4:1
Style/medium: pixel art sombria densa, mesma família do logotipo de referência e do clima do fundo do título
Constraints: fundo e vazios lisos ciano #00FFFF; bordas duras sem anti-aliasing contra a chave; texto EXATAMENTE "NOTTGARD" e "ABYSS MEGADUNGEON", sem hífen, sem outras letras, números ou símbolos; a segunda linha com largura de cerca de 85% da primeira; sem sombra projetada nem brilho fora do contorno
Avoid: letras fundidas, "SURVIVORS" em qualquer lugar, ornamento cobrindo as letras, cursivo, 3D plástico, roxo saturado em excesso, runas, brasões
```

**Se a primeira candidata vier com defeito**, corrija **um** problema por tentativa (até 3), por exemplo:

- Letra errada ou extra: "mesma peça, mas o texto EXATAMENTE `NOTTGARD` e `ABYSS MEGADUNGEON`; leia letra a letra e corrija".
- Linha de baixo pequena demais: "mesma peça, mas ABYSS MEGADUNGEON com cerca de 45% da altura da linha de cima".
- Ornamento invadindo o texto: "mesma peça, ornamento só nas duas pontas laterais, sem tocar nas letras".
- Halo ou brilho fora do contorno: "mesma peça, bordas duras contra o ciano, sem brilho nem sombra fora do contorno".

## Aceite (resumo; o completo está no ART-PROMPTS-065)

Texto exato sem `SURVIVORS`; segunda linha legível a 1280×720 (≥ 14 px de altura de letra); ornamento fora do texto; ouro legível sobre o fundo roxo; sem halo ciano.