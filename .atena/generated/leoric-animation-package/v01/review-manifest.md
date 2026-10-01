# Revisão de candidatos — Leoric v01

**Estado:** candidatos para revisão visual; não aprovados para integração.
**Data:** 2026-09-30
**Método:** ImageGen integrado, após aprovação da SPEC-110 e autorização
explícita do dono para transferir as referências abaixo.

## Referências transferidas

Somente estes cinco PNGs oficiais em `assets/animations/heroes/leoric/`:

- `idle.png`
- `move_e.png`
- `move_s.png`
- `attack.png`
- `active.png`

Nenhum retrato, skin, dado, áudio, código ou outra referência local foi enviado.

## Candidatos selecionados para revisão

| Arquivo | Conteúdo | Prancha | SHA-256 | Verificação técnica |
|---|---|---|---|---|
| `candidates/move_e-contact-sheet-v02.png` | Marcha para leste, seis poses | 3×2 | `45457f9c38fc9f09066edcb964a79076bec562307c3829ea9b96b31efdf2fe37` | 1536×1024; alfa 0 no canto e no espaço central |
| `candidates/move_w-contact-sheet-v01.png` | Marcha para oeste, seis poses | 3×2 | `2bb6bbbd449c2d19631b2498c790a4bcee7ff046aa477568fb6e5a6a5666f787` | 1536×1024; alfa 0 no canto e no espaço central |
| `candidates/attack_bolt_e-contact-sheet-v01.png` | Conjuração para leste, quatro fases | 2×2 | `4f86221aa849a5703b41b6f6d4ce2cd698ab7a8e39e4ea4a9043039d7d21da31` | 1536×1024; alfa 0 no canto e no espaço central |
| `candidates/constellation_star_burst-contact-sheet-v02.png` | Constelação, quatro fases | 2×2 | `40c25739ec084471c127cf0751dae2ca5b6a9ea608f6f1c5e6dac8809eba628d` | 1536×1024; alfa 0 no canto e no espaço central |

Os arquivos `move_e-contact-sheet-v01.png` e
`constellation_star_burst-contact-sheet-v01.png` permanecem preservados como
tentativas não selecionadas: a saída não respeitou a dimensão 1536×1024.

## Conjunto de prompts final

- **Movimento leste:** prancha RGBA 1536×1024, grade 3×2, seis poses distintas
  de Leoric andando para leste visual. Preservar gnomo adulto, cartola preta
  com faixa marrom, barba grisalha, sobretudo marrom, cajado entalhado e foco
  azul; pixel art 2D isométrica 3/4, sem cenário ou sombra.
- **Movimento oeste:** a mesma prancha 3×2, mas marcha independente para oeste;
  proibido espelhar a fonte leste e exigida variação natural de mão, cajado,
  casaco e passada.
- **Conjuração leste:** prancha RGBA 1536×1024, grade 2×2, quatro fases:
  preparar, apontar cajado, emissão azul breve, recuperação. O gesto aponta
  para leste visual e o efeito não oculta Leoric.
- **Constelação:** prancha RGBA 1536×1024, grade 2×2, VFX separado do herói:
  oito estrelas azul-douradas se formam, orbitam, expandem radialmente e se
  desfazem. Sem personagem, cajado, texto, cenário ou fundo opaco.

Todos os prompts pediram fundo realmente transparente, arte sem texto, moldura,
marca-d'água ou interface e saídas de prancha de revisão, não tiras finais.

## Revisão visual e limites

- As quatro pranchas preservam a cartola, barba, sobretudo, cajado e foco azul
  reconhecíveis de Leoric.
- `move_e` e `move_w` mostram seis leituras de passada; a direção oeste é uma
  composição própria, não um arquivo espelhado.
- `attack_bolt_e` apresenta preparar, apontar, emissão e recuperação; o cajado
  segue para leste visual.
- Constelação é separada do corpo e apresenta uma fase radial de oito estrelas.
- Pranchas de contato não são tiras de células `256×384`, não foram recortadas,
  normalizadas, importadas pelo Godot ou avaliadas em cena. A aprovação desta
  revisão não substitui o gate de normalização/admissão.

## Preservação

Todos os candidatos permanecem em `.atena/generated/`. Nenhum PNG oficial,
asset de runtime, dado, cena ou comportamento de combate foi modificado.
