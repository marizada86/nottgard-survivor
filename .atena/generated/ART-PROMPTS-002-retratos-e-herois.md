---
id: "ART-PROMPTS-002"
type: "prompts-de-arte"
title: "Retratos harmonizados dos dez heróis"
status: "approved-for-generation"
created: "2026-09-21"
relations: ["[[ART-PROMPTS-001-direcao-e-piloto]]", "[[SPEC-011-fase-1-prompts-de-arte]]"]
sources: ["data/heroes.json", "vault/02_Personagens", "vault/03_NPCs", "RESEARCH-002", "reference-staging"]
---

# Retratos harmonizados

Aplicar o bloco de retratos de ART-PROMPTS-001. Matriz 1536×1024; final 640×427 RGB em `assets/portraits/<id>.png`.

As referências locais preservam identidade, não acabamento. Todos os dez retratos devem formar uma coleção única de ilustração digital sombria com textura de pixel art fina.

## 1. Durvall

ID `durvall`. Candidata `.atena/generated/art-candidates/portraits/durvall_vNN.png`. Referência `.atena/evidence/reference-staging/durvall.png`: identidade drow, cabelo, armadura e arma.

```text
Retrato 3:2 de Durvall Gellad, drow adulto de pele cinza-azulada escura, cabelo branco longo e liso, olhos frios, expressão contida e vigilante. Armadura negra segmentada e funcional, gola alta e detalhes discretos de metal azulado. Parte de uma lâmina escura envolta por energia azul-branca aparece ao lado, sem esconder o rosto. Fundo abissal frio e desfocado, luz superior esquerda. Preserve a identidade da referência sem copiar seu acabamento monocromático; sem asas, coroa, texto ou moldura.
```

## 2. Brook

ID `brook`. Candidata `.atena/generated/art-candidates/portraits/brook_vNN.png`. Referência `.atena/evidence/reference-staging/brook.png`: rosto, barba, armadura e maça.

```text
Retrato 3:2 de Brook França, jovem anão guerreiro adulto, baixo e muito robusto, pele marcada, cabelo castanho-escuro curto e barba castanha espessa dividida em mechas. Armadura pesada de aço escuro e couro, maça de guerra compacta junto ao ombro. Expressão determinada e justa, sem pose régia. Fundo de pedra e névoa azul-acinzentada, acento dourado muito discreto ligado a Lliira. Use a referência para feições, proporção e equipamento, mas respeite a juventude e o cabelo castanho definidos pelo jogo; sem aparência humana alta, sem texto ou moldura.
```

## 3. Maelor

ID `maelor`. Candidata `.atena/generated/art-candidates/portraits/maelor_vNN.png`. Referência `.atena/evidence/reference-staging/maelor.png`: rosto, traje e foco mágico.

```text
Retrato 3:2 de Maelor, aventureiro humano adulto de cabelo castanho e barba curta, vestes de conjurador viajante em marrom, cinza e azul, faixas e pequenos frascos utilitários. Uma mão sustenta energia azul-clara de cura e comunhão, compacta e legível. Expressão empática, concentrada e cansada. Fundo escuro de santuário em névoa, luz superior esquerda. Preserve identidade e traje da referência; sem cajado inventado, texto ou moldura.
```

## 4. Sylas

ID `sylas`. Candidata `.atena/generated/art-candidates/portraits/sylas_vNN.png`. Referência `.atena/evidence/reference-staging/sylas.png`: identidade tiefling, chifres, máscara/armadura e paleta.

```text
Retrato 3:2 de Sylas Malafaia, tiefling adulto de pele escura avermelhada quase oculta por armadura negra, chifres altos voltados para trás e olhos violetas. Armadura e manto de viajante em carvão com detalhes roxos de Mask, postura furtiva e controlada. Pequenas sombras aderem ao ombro sem formar asas permanentes. Expressão ou máscara transmite autocontrole e dívida. Preserve a identidade da referência, reinterpretada sem estética anime; sem asas grandes, texto ou moldura.
```

## 5. Kayron

ID `kayron`. Candidata `.atena/generated/art-candidates/portraits/kayron_vNN.png`. Referência `.atena/evidence/reference-staging/kayron.png`: cabelo, armadura e contraste; qualquer asa é efeito transitório, não anatomia permanente.

```text
Retrato 3:2 de Kayron Lioran, aasimar adulto de cabelo branco muito claro e sinais celestiais discretos, armadura negra leve com tecido escuro e pequenos acentos violeta ligados a Shar. Expressão introspectiva, perigosa e disciplinada. Atrás dos ombros há apenas rastros de sombra e penas de energia dissolvendo, nunca asas anatômicas permanentes. Fundo noturno frio com estrela distante. Preserve identidade e contraste da referência, removendo acabamento anime; sem texto ou moldura.
```

## 6. Korrak

ID `korrak`. Candidata `.atena/generated/art-candidates/portraits/korrak_vNN.png`. Referências `.atena/evidence/reference-staging/korrak.png` e `korrak_gigante.png`, somente identidade, cicatrizes, armadura, escala e Machado de Xar'gath.

```text
Retrato 3:2 de Korrak Nammat, goliath extremamente robusto de pele cinza marcada por cicatrizes e padrões claros, cabelo raspado nas laterais, barba negra curta e expressão severa. Armadura pesada de couro e ferro gasto com pele marrom no ombro. O cabo e parte da lâmina negra do Machado de Xar'gath aparecem atrás do ombro, com fissuras vermelho-abissais discretas. Busto central, fundo escuro de basalto e ferrugem, luz fria superior esquerda. Preserve exatamente a identidade da imagem de referência; sem segunda arma, sem texto, sem moldura.
```

Aceite: reconhecível como a referência; machado não cobre o rosto; não criar chifres ou traços demoníacos permanentes.

## 7. Leoric

ID `leoric`. Candidata `.atena/generated/art-candidates/portraits/leoric_vNN.png`. Referência `.atena/evidence/reference-staging/leoric.png`, identidade e traje; remover aparência chibi/3D.

```text
Retrato 3:2 de Leoric, gnomo adulto de baixa estatura sugerida pelas proporções, rosto expressivo, nariz forte, cabelo e barba grisalhos volumosos, chapéu escuro de aba larga e manto verde-musgo bordado com pequenas constelações douradas. Segura próximo ao peito um foco de madeira retorcida com cristal azul; pontos de luz azul-branca formam uma constelação curta junto à mão livre, sem dominar o quadro. Preserve rosto, barba, chapéu e paleta da referência. Fundo noturno desfocado, sem texto ou moldura.
```

Aceite: leitura de gnomo e astrônomo místico; constelação contida; sem aparência infantil.

## 8. Nyrelia

ID `nyrelia`. Candidata `.atena/generated/art-candidates/portraits/nyrelia_vNN.png`. Sem imagem local; o vault exige máscara, espécie não estabelecida e aura amarela.

```text
Retrato 3:2 de Nyrelia, sacerdotisa de Mask e integrante dos Greenholders. Figura adulta de espécie deliberadamente impossível de determinar: rosto inteiro coberto por máscara escura lisa e elegante, capuz profundo e vestes de viagem verde-escuras e carvão, práticas e gastas, com pequenos fechos de bronze. Uma aura amarela muito discreta contorna máscara e ombros, sugerindo a presença de Mask. Postura protetora e maternal, não ameaçadora. Não mostrar pele, orelhas, olhos, cabelo ou anatomia que revele espécie. Sem símbolo inventado, texto ou moldura.
```

Aceite: espécie permanece indeterminada; máscara é o foco; aura amarela não vira halo sagrado.

## 9. Zynara

ID `zynara`. Candidata `.atena/generated/art-candidates/portraits/zynara_vNN.png`. Referência `.atena/evidence/reference-staging/zynara.png`, somente identidade élfica, cabelo, traje preto e dourado; reduzir caráter régio excessivo.

```text
Retrato 3:2 de Zynara Vellen, alta conselheira élfica, pesquisadora e agente política. Elfa adulta de pele muito clara, orelhas longas, cabelo branco-prateado e olhos dourados atentos. Traje preto estruturado com filigranas douradas sóbrias, pequeno diadema de conselheira em vez de coroa, capa escura e uma pasta de papéis parcialmente visível. Expressão calma, analítica e levemente desconfiada. Fundo de arquivo e laboratório botânico em sombras, sem plantas extraplanares explícitas. Preserve a identidade da referência; sem decote exagerado, sem armadura de batalha, sem texto.
```

Aceite: conselheira e estudiosa, não rainha; rosto e cabelo coerentes com a referência.

## 10. Bromnor

ID `bromnor`. Candidata `.atena/generated/art-candidates/portraits/bromnor_vNN.png`. Referência `.atena/evidence/reference-staging/bromnor.png`, identidade, armadura e barba; o martelo é o Martelo da Glória.

```text
Retrato 3:2 de Bromnor Martelo da Luz, anão idoso, largo e poderoso, cabelo e barba brancos muito longos, pele marcada, olhos azuis firmes e expressão de líder justo. Armadura pesada de bronze, couro e aço com tecido azul profundo e pequenos encaixes azul-luminosos. Segura verticalmente o Martelo da Glória junto ao ombro; um clarão dourado e prateado muito contido delineia o martelo e a barba, lembrando a Concórdia Eterna. Preserve a identidade da referência. Aparência viva e corpórea para seleção de herói, não fantasma; sem texto ou moldura.
```

Aceite: leitura inequívoca de anão; martelo, não cajado; dourado/prateado sem estourar o contraste.

## Registro

| ID | Referência | Candidata aprovada | Observação |
|---|---|---|---|
| `durvall` | staging/durvall | — | piloto de retrato |
| `brook` | staging/brook | — | harmonizar legado |
| `maelor` | staging/maelor | — | harmonizar legado |
| `sylas` | staging/sylas | — | harmonizar legado |
| `kayron` | staging/kayron | — | asas apenas como efeito |
| `korrak` | staging/korrak + gigante | — | — |
| `leoric` | staging/leoric | — | remover chibi/3D |
| `nyrelia` | somente vault | — | espécie deve permanecer oculta |
| `zynara` | staging/zynara | — | reduzir coroa |
| `bromnor` | staging/bromnor | — | forma viva |

Os dez sprites de run usam `ART-PROMPTS-011` e o retrato aprovado de cada personagem como âncora adicional.
