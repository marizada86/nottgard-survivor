---
id: "ART-PROMPTS-011"
type: "prompts-de-arte"
title: "Sprites de herói e remaster dos inimigos legados"
status: "approved-for-generation"
created: "2026-09-22"
relations: ["[[ART-PROMPTS-001-direcao-e-piloto]]", "[[ART-PROMPTS-002-retratos-e-herois]]", "[[SPEC-015-producao-total-de-assets-visuais]]"]
sources: ["data/heroes.json", "data/enemies.json", "vault Nottgard", "RESEARCH-002", "assets legados"]
---

# Sprites de run e remasters

Aplicar o bloco comum de figuras de `ART-PROMPTS-001`. Uma chamada por linha. Fundo com alfa real, nenhum cenário, texto ou sombra separada.

## Heróis — `assets/heroes/<id>.png`

Matriz 1024×1536; final 256×384 RGBA. Anexar o retrato aprovado e a referência local indicada. O sprite simplifica detalhes, mas preserva espécie, rosto, cabelo, traje, arma e cores.

| ID | Referência local | Pedido específico autocontido |
|---|---|---|
| `durvall` | `reference-staging/durvall.png` | Drow adulto esguio de pele cinza-azulada, cabelo branco longo, armadura negra segmentada; segura espada sombria com veios azul-brancos, postura de duelista controlada. |
| `brook` | `reference-staging/brook.png` | Jovem anão baixo e robusto, cabelo e barba castanho-escuros, armadura pesada de aço/couro; maça ou foco de Lliira, acento dourado festivo contido. |
| `maelor` | `reference-staging/maelor.png` | Humano adulto de cabelo castanho-claro, vestes de conjurador viajante marrom/azul, mão com luz curativa azul-clara, postura protetora. |
| `sylas` | `reference-staging/sylas.png` | Tiefling adulto com chifres voltados para trás, armadura e manto carvão/roxo de Mask, postura furtiva; sombras aderidas, sem asas. |
| `kayron` | `reference-staging/kayron.png` | Aasimar adulto de cabelo branco, armadura negra leve e acentos violeta de Shar, energia estelar discreta; penas de sombra transitórias, sem asas anatômicas. |
| `korrak` | `reference-staging/korrak.png`, `korrak_gigante.png` | Goliath enorme de pele cinza e cicatrizes, couro/ferro e pele marrom, Machado de Xar'gath negro com fissuras vermelhas; silhueta pesada. |
| `leoric` | `reference-staging/leoric.png` | Gnomo adulto, chapéu escuro largo, barba grisalha, manto verde-musgo com constelações douradas e foco azul; proporção adulta, não chibi. |
| `nyrelia` | somente retrato aprovado/vault | Sacerdotisa mascarada de espécie indeterminável, capuz e vestes verde-escuras/carvão, fechos de bronze e aura amarela mínima; nenhuma pele visível. |
| `zynara` | `reference-staging/zynara.png` | Elfa adulta alta, cabelo branco-prateado, traje negro com filigrana dourada sóbria, pequena ampulheta prateada e postura analítica; não rainha. |
| `bromnor` | `reference-staging/bromnor.png` | Anão idoso largo, barba branca longa, armadura bronze/aço e tecido azul; Martelo da Glória com luz dourada/prateada contida. |

Aceite: leitura a 48–80 px; base dos pés uniforme; arma principal reconhecível; retrato e sprite inequívocos como o mesmo personagem.

## Inimigos legados — `assets/enemies/<id>.png`

Matriz 1024×1536; final 320×480 RGBA. Anexar o PNG legado correspondente como referência de identidade. Reinterpretar para três quartos isométrico e acabamento comum, sem alterar o conceito.

| ID | Pedido específico autocontido |
|---|---|
| `zumbi` | Cadáver humano movido pela névoa, roupas portuárias rasgadas, pele cinza e postura inclinada; morto comum, sem gore excessivo. |
| `slime_corrosivo` | Massa baixa de slime verde-ácido translúcido com núcleo escuro e gotas presas à forma; base larga, sem rosto cômico. |
| `cultista_adaga` | Cultista de Dagruve encapuzado, tecido carvão gasto, máscara parcial e adaga curta; silhueta ágil, acento roxo doentio. |
| `cultista_arqueiro` | Cultista encapuzado da mesma facção com arco curto e aljava, postura de manter distância; não confundir com o de adaga. |
| `cultista_cajado` | Cultista da mesma facção com cajado-lampião coberto de cera fervente, silhueta vertical e luz âmbar contaminada. |
| `criatura_corrompida` | Humanoide portuário deformado pela névoa, um braço ampliado e carne/roupa fundidas, roxo escuro; sem tentáculos gratuitos. |
| `guardiao_copia` | Guardião alado ilusório em armadura clara rachada, asas compactas e lança curta; aparência incompleta e menos sólida. |
| `guardiao_verdadeiro` | Guardião alado corpóreo, armadura clara pesada, asas amplas e lança, presença superior à cópia e núcleo abissal discreto. |
| `mimico` | Baú escuro transformado, tampa como mandíbula, dentes irregulares, língua curta e ferragens como membros; reconhecível como o `chest_closed`. |
| `sacerdote_mente_derretida` | Sacerdote alto em vestes cerimoniais carbonizadas, cabeça/rosto derretidos em cera e turíbulo pesado; chefe de Dagruve, silhueta dominante. |

Aceite: identidade do legado preservada; câmera e luz alinhadas ao conjunto; cópia/verdadeiro distinguíveis por forma; mímico deriva do baú aprovado.

