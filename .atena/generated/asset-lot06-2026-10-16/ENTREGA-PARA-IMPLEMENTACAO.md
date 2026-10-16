# ASSET-LOT06/v02 — oito fontes / 29 desenhos

DRAFT. Escopo ampliado autorizado: "Aprovo as 8 fontes por plano",16/10/2026. Direção visual das oito revisões aceita com "aprovado, continue" em16/10/2026. [Recibo](visual-acceptance.json). Retenção FC02_ORIGIN e pendências técnicas preservadas. Implementação com Claude; entrega local, sem mensagem a outro chat. Não há admissão em jogo ou promoção canônica. MEC-004 continua pendente, lança-chamas é antecipação visual autorizada.

| Código | Fonte selecionada | Desenhos | Base do contorno alfa≥128 | Margem mínima alfa≥16 |
|---|---|---:|---:|---:|
| FC01 ícone | [v01](../animation-candidates/asset-lot06/FC01_v01.png) | 1 | N/A | 46px |
| FC02 jato | [v03](../animation-candidates/asset-lot06/FC02_v03.png) | 4 | N/A efeito; contorno57px | 5px |
| IE01 doação | [v02](../animation-candidates/asset-lot06/IE01_v02.png) | 4 | 50px | 13px |
| IE02 aposta | [v01](../animation-candidates/asset-lot06/IE02_v01.png) | 4 | 24px | 56px |
| IE03 ampulheta | [v01](../animation-candidates/asset-lot06/IE03_v01.png) | 4 | 0px | 56px |
| IE04 arcanista | [v02](../animation-candidates/asset-lot06/IE04_v02.png) | 4 | 51px | 29px |
| IE05 peregrino | [v01](../animation-candidates/asset-lot06/IE05_v01.png) | 4 | 28px | 46px |
| IE06 contador | [v01](../animation-candidates/asset-lot06/IE06_v01.png) | 4 | 27px | 66px |

Todas fontes1254×1254. FC01 é imagem única; outras são2×2, células627×627 em ordem de leitura. Não recortar512. `frames/` contém29 recortes brutos para QA, sem reposicionar ou normalizar. Ícone32/48/64 são apenas prévias reduzidas. [Galeria](index.html), [manifesto](manifest.json), [medidas/hashes](inspection.json), [prompts](prompts.md), [checagem dos controles](player-check.json), [snapshot das referências](references.json).

## Retenção e preparação

**FC02 retido tecnicamente:** após três tentativas, v03 separa as fases e tem ponta máxima alfa≥16 em x469/470/470/463, mas a raiz fica afastada5–10px da esquerda e abaixo da meia altura em parte da sequência. A banda esquerda4px não contém núcleo: não cumpre origem contratada. Registrar emissão por quadro e preservar alcance aparente; não centralizar pelo contorno todo. Não usar v01/v02, que têm maior variação e vazamento entre células. Sem quarta tentativa neste escopo.

**Idles pendentes de registro e continuidade:** doação e arcanista continuam com deslocamentos50/51px mesmo após tentativa de correção. Demais desvios estão na tabela. A origem métrica é o fundo do contorno, não anotação semântica de pés/apoio, e inclui roupa/fogueira. Não declarar estrutura pixel-invariante: detalhes, perspectiva e posições precisam de comparação com a referência e alinhamento antes de uso. A ampulheta ter base0px não prova corpo invariável. Sem correção oculta na prévia.

IE01 v01 acrescentou lâmina longa, removida em v02; somente v02 selecionada. Conferir oferendas/ornamentos com o estático. IE02 conferir permanência de cartas/dados/moedas. IE04 conferir mãos, livro fechado e rosto sob capuz; v02 não resolveu o salto de base. IE05 conferir a área do abdômen, cabeça, pedra/bolsa e continuidade dos props; não adicionar ferida/sangue na implementação. IE06 conferir mão, pergaminho e fogo. Transição4→1 e reconhecimento reduzido dependem do dono.

Alfa modal do primeiro quadro253 em todas, com resíduos baixos: sólidos ainda não são estritamente255; limpar/preparar de forma autorizada preservando fogo, vidro e bordas. Para FC02, alfa variável faz parte do efeito, não aplicar teste de solidez do corpo ao brilho. Nenhum pixel alfa≥16 nas faixas externas4px das selecionadas, mas isso não garante margem-alvo nem origem correta. FC01 não atingiu folga solicitada12%; avaliar reconhecimento a32px (poucos detalhes),48/64px.

Destinos e consumers a confirmar na frente de implementação: ícone/pickup de MEC-004 e VFX, idles de interações/eventos; não pressupor que o consumer atual aceite essas folhas. Não modificar duração/dano/alcance/loot/quest ou substituir estáticos automaticamente. Referências FILA028 são fontes visualmente aceitas; novas animações permanecem DRAFT.

Sete players repetem por padrão;8FPS inicial e2/4/8/10/12 são de inspeção. DOM mínimo executou lógica real dos controles, sete instâncias/28PNG animados, pausa/scrub/reinício/FPS/repetição/hold e caminhos; ícone e prévias também conferidos. Não verifica render real de navegador. Nenhum playtest em jogo; explicar escopo/procedimento/critérios antes de teste futuro. Sem commit/push/exportação neste lote.
