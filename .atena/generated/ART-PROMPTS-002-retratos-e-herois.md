---
id: "ART-PROMPTS-002"
type: "prompts-de-arte"
title: "Retratos faltantes e âncoras dos heróis"
status: "draft"
created: "2026-09-21"
relations: ["[[ART-PROMPTS-001-direcao-e-piloto]]", "[[SPEC-011-fase-1-prompts-de-arte]]"]
sources: ["data/heroes.json", "vault/02_Personagens", "vault/03_NPCs", "nottcard-ai/assets/concepts/candidates"]
---

# Retratos faltantes

Aplicar o bloco de retratos de ART-PROMPTS-001. Matriz 1536×1024; final 640×427 RGB em `assets/portraits/<id>.png`.

## 1. Korrak

ID `korrak`. Bruto `assets/_raw/portraits/korrak_vNN.png`. Referência: `nottcard-ai/assets/concepts/candidates/korrak_fullbody_candidate_v1.png`, somente identidade, cicatrizes, armadura e Machado de Xar'gath.

```text
Retrato 3:2 de Korrak Nammat, goliath extremamente robusto de pele cinza marcada por cicatrizes e padrões claros, cabelo raspado nas laterais, barba negra curta e expressão severa. Armadura pesada de couro e ferro gasto com pele marrom no ombro. O cabo e parte da lâmina negra do Machado de Xar'gath aparecem atrás do ombro, com fissuras vermelho-abissais discretas. Busto central, fundo escuro de basalto e ferrugem, luz fria superior esquerda. Preserve exatamente a identidade da imagem de referência; sem segunda arma, sem texto, sem moldura.
```

Aceite: reconhecível como a referência; machado não cobre o rosto; não criar chifres ou traços demoníacos permanentes.

## 2. Leoric

ID `leoric`. Bruto `assets/_raw/portraits/leoric_vNN.png`. Referência: `leoric_fullbody_candidate_v1.png`, identidade e traje.

```text
Retrato 3:2 de Leoric, gnomo adulto de baixa estatura sugerida pelas proporções, rosto expressivo, nariz forte, cabelo e barba grisalhos volumosos, chapéu escuro de aba larga e manto verde-musgo bordado com pequenas constelações douradas. Segura próximo ao peito um foco de madeira retorcida com cristal azul; pontos de luz azul-branca formam uma constelação curta junto à mão livre, sem dominar o quadro. Preserve rosto, barba, chapéu e paleta da referência. Fundo noturno desfocado, sem texto ou moldura.
```

Aceite: leitura de gnomo e astrônomo místico; constelação contida; sem aparência infantil.

## 3. Nyrelia

ID `nyrelia`. Bruto `assets/_raw/portraits/nyrelia_vNN.png`. Sem imagem de identidade aprovada; o vault exige máscara, espécie não estabelecida e aura amarela.

```text
Retrato 3:2 de Nyrelia, sacerdotisa de Mask e integrante dos Greenholders. Figura adulta de espécie deliberadamente impossível de determinar: rosto inteiro coberto por máscara escura lisa e elegante, capuz profundo e vestes de viagem verde-escuras e carvão, práticas e gastas, com pequenos fechos de bronze. Uma aura amarela muito discreta contorna máscara e ombros, sugerindo a presença de Mask. Postura protetora e maternal, não ameaçadora. Não mostrar pele, orelhas, olhos, cabelo ou anatomia que revele espécie. Sem símbolo inventado, texto ou moldura.
```

Aceite: espécie permanece indeterminada; máscara é o foco; aura amarela não vira halo sagrado.

## 4. Zynara

ID `zynara`. Bruto `assets/_raw/portraits/zynara_vNN.png`. Referência: `zynara_fullbody_candidate_v1.png`, somente identidade élfica, cabelo, traje preto e dourado; reduzir caráter régio excessivo.

```text
Retrato 3:2 de Zynara Vellen, alta conselheira élfica, pesquisadora e agente política. Elfa adulta de pele muito clara, orelhas longas, cabelo branco-prateado e olhos dourados atentos. Traje preto estruturado com filigranas douradas sóbrias, pequeno diadema de conselheira em vez de coroa, capa escura e uma pasta de papéis parcialmente visível. Expressão calma, analítica e levemente desconfiada. Fundo de arquivo e laboratório botânico em sombras, sem plantas extraplanares explícitas. Preserve a identidade da referência; sem decote exagerado, sem armadura de batalha, sem texto.
```

Aceite: conselheira e estudiosa, não rainha; rosto e cabelo coerentes com a referência.

## 5. Bromnor

ID `bromnor`. Bruto `assets/_raw/portraits/bromnor_vNN.png`. Referência: `bromnor_fullbody_candidate_v1.png`, identidade, armadura e barba; o martelo é o Martelo da Glória.

```text
Retrato 3:2 de Bromnor Martelo da Luz, anão idoso, largo e poderoso, cabelo e barba brancos muito longos, pele marcada, olhos azuis firmes e expressão de líder justo. Armadura pesada de bronze, couro e aço com tecido azul profundo e pequenos encaixes azul-luminosos. Segura verticalmente o Martelo da Glória junto ao ombro; um clarão dourado e prateado muito contido delineia o martelo e a barba, lembrando a Concórdia Eterna. Preserve a identidade da referência. Aparência viva e corpórea para seleção de herói, não fantasma; sem texto ou moldura.
```

Aceite: leitura inequívoca de anão; martelo, não cajado; dourado/prateado sem estourar o contraste.

## Registro

| ID | Referência | Candidata aprovada | Observação |
|---|---|---|---|
| `korrak` | fullbody v1 | — | piloto de retrato |
| `leoric` | fullbody v1 | — | — |
| `nyrelia` | somente vault | — | espécie deve permanecer oculta |
| `zynara` | fullbody v1 | — | reduzir coroa |
| `bromnor` | fullbody v1 | — | forma viva |

Os dez sprites de run serão prompts de identidade derivada após integração do caminho `assets/heroes/<id>.png`; não são gerados nesta fase.

