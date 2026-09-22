---
id: "ART-PROMPTS-009"
type: "prompts-de-arte"
title: "Ícones de armas e itens"
status: "approved-for-generation"
created: "2026-09-21"
relations: ["[[ART-PROMPTS-001-direcao-e-piloto]]"]
sources: ["data/weapons.json", "data/items.json", "vault/06_Itens"]
---

# Ícones — armas e itens

> Cada linha é um pedido individual anexado ao bloco comum. Não gerar em lote numa única imagem.

## Bloco comum

```text
Use case: stylized-concept
Asset type: ícone de item/habilidade para jogo
Style/medium: ícone pintado em pixel art sombria, contorno escuro grosso, materiais legíveis, alto contraste, luz superior esquerda
Composition/framing: um único objeto ou gesto mágico central, vista três quartos, 15% de margem, silhueta legível a 48 px
Constraints: fundo realmente transparente; sem texto, letras, números, mãos extras, moldura, cenário, logotipo ou marca-d'água; nenhuma cor encosta nas bordas
```

Matriz 1024×1024; final 128×128 RGBA. Armas: `assets/icons/weapons/<id>.png`; bases e únicos: `assets/icons/items/<id>.png`; candidatos espelham a família sob `.atena/generated/art-candidates/`.

## Armas e habilidades — 30

| ID | Pedido específico |
|---|---|
| `espada_sombria` | Espada larga negra com veios psiônicos azul-brancos discretos, diagonal ascendente. |
| `espada_do_receptaculo` | Evolução da espada sombria, mesma forma-base ampliada, arco de energia e fissura que rasga uma placa de armadura. |
| `golpe_esmagador` | Maça de guerra de ferro no instante do impacto contra pedra, estilhaços presos ao conjunto. |
| `adaga_rapida` | Adaga curta escura repetida como três pós-imagens compactas, sugerindo velocidade. |
| `rajada_infinita` | Mesma adaga envolta por círculo compacto de múltiplos rastros cortantes. |
| `golpe_atordoante` | Maça robusta com anel de impacto azul e pequenas estrelas angulares, sem texto. |
| `golpe_do_juizo` | Maça/arma de julgamento emitindo impacto radiante dourado-branco em leque. |
| `sentenca_de_lliira` | Pulso circular dourado e colorido partindo de pequeno cetro festivo, alegria solene, não infantil. |
| `julgamento_da_gloria` | Evolução da sentença: martelo/cetro radiante cercado por onda dourada que fere fora e cura no centro. |
| `raio_de_luz` | Feixe branco-dourado concentrado saindo de cristal simples, diagonal. |
| `luz_mais_pura` | Mesmo cristal transformado em estrela luminosa de núcleo branco e raios dourados compactos. |
| `raio_enfraquecedor` | Raio roxo escuro atingindo placa de armadura que perde brilho e racha. |
| `descarga_estelar` | Pequena estrela azul-branca disparando cauda curta, forma limpa e precisa. |
| `chuva_de_estrelas` | Grupo compacto de cinco estrelas azul-brancas caindo em arcos paralelos. |
| `estocada_mistica` | Ponta de lança/espada atravessando véu arcano azul-violeta, gesto linear. |
| `cera_fervente` | Gota grossa de cera âmbar fervendo sobre chama escura, aparência perigosa. |
| `inferno_de_cera` | Turíbulo coberto de cera lançando labaredas âmbar e roxas compactas. |
| `vela_sagrada` | Vela branca curta com chama dourada protegida por pequeno halo geométrico. |
| `lamina_trovejante` | Lâmina escura envolta por raio azul angular aderido ao metal. |
| `tempestade` | Núcleo de nuvem azul-negra com três relâmpagos radiais, sem paisagem. |
| `dominar_pessoa` | Máscara escura sob mão enluvada e fios amarelos de controle, sem rosto real. |
| `marca_da_retidao` | Selo dourado geométrico sobre silhueta de alvo, sem letras religiosas. |
| `chicote_avarento` | Chicote negro e dourado enrolado em torno de gema/olho que reflete desejo. |
| `martelo_da_gloria` | Martelo anão de bronze e aço com runas não textuais, luz dourada e prateada. |
| `machado_de_xargath` | Machado pesado negro de duas lâminas com fissuras vermelho-abissais e alma presa no núcleo. |
| `colar_dos_tentaculos` | Colar com olho de Ghaunadaur e pequenos tentáculos roxos formando o aro. |
| `sopro_de_estrela` | Concha celestial azul-prateada soprando poeira de estrelas em arco curto. |
| `lamina_da_digestao` | Lâmina curva verde-negra pingando ácido que corrói um elo de armadura. |
| `cajado_dos_desejos` | Cajado elegante escuro com gema em forma de boca sussurrante e fios violeta. |
| `ampulheta` | Ampulheta negra e prateada com areia suspensa no meio, aura de silêncio contida. |

## Itens-base — 13

| ID | Pedido específico |
|---|---|
| `adaga` | Adaga comum de ferro e couro, gasta, sem magia. |
| `espada_longa` | Espada longa comum de aço escuro, guarda simples. |
| `maca_de_guerra` | Maça de guerra comum de ferro facetado. |
| `cajado` | Cajado de madeira escura com cristal pequeno apagado. |
| `cetro` | Cetro curto de bronze com gema simples. |
| `couro` | Peitoral de couro marrom reforçado, sozinho. |
| `cota` | Camisa dobrada de cota de malha e gola de couro. |
| `placa` | Peitoral de placa completo pesado com ombreiras. |
| `robe` | Robe arcano dobrado azul-escuro com filetes roxos sem símbolo. |
| `amuleto_simples` | Pingente oval de ferro em cordão de couro. |
| `talisma` | Talismã de madeira, osso e fio vermelho, sem escrita. |
| `anel_simples` | Anel de ferro escuro liso. |
| `anel_de_prata` | Anel de prata gasto com pequeno encaixe vazio. |

## Itens únicos — 18

Quando houver arma homônima, usar o ícone aprovado correspondente como alias exato no manifesto; não gerar uma segunda interpretação. Os dez únicos sem arma homônima usam os pedidos abaixo.

| ID | Pedido específico |
|---|---|
| `machado_de_xargath` | Retrato de item do mesmo machado aprovado, isolado, fissuras vermelhas e núcleo de alma. |
| `martelo_da_gloria` | Mesmo martelo aprovado, isolado, brilho dourado/prateado contido. |
| `lamina_da_digestao` | Mesma lâmina aprovada, isolada, ácido corroendo a própria bainha. |
| `chicote_avarento` | Mesmo chicote aprovado enrolado em moeda escura e gema de desejo. |
| `cajado_dos_desejos` | Mesmo cajado aprovado, gema sussurrante e aura amaldiçoada. |
| `colar_dos_tentaculos` | Mesmo colar aprovado como joia, olho central aberto. |
| `sopro_de_estrela` | Mesma concha aprovada, vista como amuleto com cordão prateado. |
| `ampulheta` | Mesma ampulheta aprovada como amuleto, corrente fina e areia imóvel. |
| `anel_resistencia_abissal` | Anel negro robusto com faixa interna lilás e marcas de garras repelidas. |
| `anel_passagem_sombria` | Anel de prata negra cuja metade se dissolve em sombra sólida. |
| `aneis_de_grazzt` | Par de anéis de prata negra entrelaçados, três gemas ametistas em cada conjunto, elegância perigosa. |
| `manto_do_pantano` | Manto verde-musgo dobrado, impermeável, bordas cobertas por limo inofensivo. |
| `broche_celestial` | Broche prateado de guardião com pequena estrela azul, sem texto. |
| `amuleto_da_luz` | Amuleto dourado simples com núcleo branco quente que afasta névoa escura. |
| `luneta_de_korrak` | Luneta curta de bronze e couro, lente azul, robusta para mãos grandes. |
| `olho_de_ghaunadaur` | Olho roxo orgânico montado em amuleto negro, tentáculos mínimos e preço ameaçador. |
| `lasca_de_ailalore` | Fragmento de estrela branco-azul em suporte de prata, luz fria e pura. |
| `colar_runico_de_thalion` | Colar élfico prateado com placa rúnica geométrica azul, sem letras legíveis. |

## Aceite

- Um ícone por arquivo e nenhuma folha de ícones.
- Formas-base permanecem modestas; únicos/evoluções se distinguem por material e silhueta.
- Duplicatas semânticas usam a imagem-âncora, mas possuem arquivo próprio.
- Testar a 48 px sobre fundos dos oito biomas.
