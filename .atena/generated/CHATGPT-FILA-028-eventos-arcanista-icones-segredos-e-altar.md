---
id: "CHATGPT-FILA-028"
title: "Fila de geração: eventos aleatórios, Arcanista, ícones das armas e equipamentos novos, segredos e altar animado"
status: "2026-10-10: AL01 e EV01–EV06 aceitas visualmente; preparacao runtime pendente; demais blocos nao iniciados"
priority: "normal: depois da FILA-027 (Erik e Arlindo)"
created: "2026-10-09"
relations: ["[[ART-PROMPTS-061-eventos-arcanista-icones-segredos-e-altar]]", "[[ART-PROMPTS-059-icones-das-bencaos-novas]]", "[[SPEC-164-eventos-aleatorios-novos-mec-005]]"]
---

# CHATGPT-FILA-028: mecânicas novas da 0.4.0

Compilação operacional de [[ART-PROMPTS-061-eventos-arcanista-icones-segredos-e-altar]]; em caso de dúvida, o ART-PROMPTS prevalece (traz os prompts completos, tamanhos finais e critérios de aceite). **A FILA-027 (Erik e Arlindo) passa na frente** (pedido do dono em 2026-10-09). Nenhuma peça abaixo bloqueia o jogo: tudo roda com provisório.

## Como enviar

1. **Uma peça por chamada.** Colar o bloco comum certo do ART-PROMPTS-061 (props/personagens de evento **ou** ícones) e, em cada chamada, só o pedido da peça.
2. **Referências a anexar:** props e NPCs: `assets/interactions/loja.png` e `assets/interactions/doacao.png` (âncoras de estilo). Ícones de armas: `assets/icons/weapons/descarga_estelar.png` e `golpe_esmagador.png`. Ícones de equipamentos: `assets/icons/items/machado_de_xargath.png` e `colar_dos_tentaculos.png`. **IC13:** também `.atena/generated/item-refs/coracao-da-dominancia-referencia.webp`. **AL01:** o altar estático `assets/interactions/altar_active.png`.
3. **Fundo:** props e NPCs em magenta `#FF00FF` (ciano `#00FFFF` onde a peça disser, porque tem roxo); ícones com alfa real. Recortar o fundo depois.
4. **Destino das candidatas:** `.atena/generated/art-candidates/<eventos|arcanista|icones|altar|segredos>/<codigo>_v01.png`, até 3 por peça. Nada entra em `assets/` antes da aprovação visual do dono.
5. Marque `[x]` ao gerar e `[a]` ao aprovar.

## Ordem sugerida (o dono reordena)

| # | Bloco | Peças | Por quê primeiro |
|--:|---|--:|---|
| 1 | **AL** altar animado | 1 | Corrige o altar que aparece oco (BUG-038); só 1 imagem |
| 2 | **EV** eventos aleatórios | 6 | Aparecem em toda run, em todas as fases, junto de loja e altar |
| 3 | **IC** ícones das armas e equipamentos | 13 | Aparecem nas ofertas de level-up e no baú, hoje com ícone emprestado |
| 4 | **AR** Arcanista | 1 | NPC que melhora magias; hoje losango roxo |
| 5 | **SE** segredos (SE01 a SE03) | 3 | Eco e câmara selada valem em todas as fases com segredos |
| 6 | **SE** ruínas por fase (SE04 a SE11) | 8 | Só se a cota permitir |
| 7 | **BN** ícones das bênçãos (I01 e I02, do ART-PROMPTS-059) | 2 | Hoje aparecem sem ícone na escolha 1 de 3 |

**Dica de cota:** o menor conjunto que já muda o jogo é **AL01 + EV01 a EV06 + IC01 a IC06** (13 peças).

## 1. AL: altar animado (ART-044)

- [x] gerada · [x] aprovada: AL01 `altar_active` (v02, fonte nativa grade 3×2; sheet 1152 × 192 ainda não montado)

## 2. EV: eventos aleatórios (ART-046)

- [x] gerada · [x] aprovada: EV01 `pacto_sangue` (v02)
- [x] gerada · [x] aprovada: EV02 `relicario` (v01)
- [x] gerada · [x] aprovada: EV03 `peregrino` (NPC, v01)
- [x] gerada · [x] aprovada: EV04 `contador` (NPC, v02)
- [x] gerada · [x] aprovada: EV05 `carroca` (v02)
- [x] gerada · [x] aprovada: EV06 `eclipse_pedra` (fundo ciano, v02)

## 3. IC: ícones das armas e equipamentos novos (ART-042)

Armas e feitiços (`assets/icons/weapons/`):

- [ ] gerada · [ ] aprovada: IC01 `bola_de_fogo`
- [ ] gerada · [ ] aprovada: IC02 `tormenta_de_fogo`
- [ ] gerada · [ ] aprovada: IC03 `lamina_de_sombra`
- [ ] gerada · [ ] aprovada: IC04 `romper_armadura`
- [ ] gerada · [ ] aprovada: IC05 `esmagar_defesas`
- [ ] gerada · [ ] aprovada: IC06 `dominio_da_vontade`

Equipamentos únicos (`assets/icons/items/`):

- [ ] gerada · [ ] aprovada: IC07 `cajado_familia_infernum`
- [ ] gerada · [ ] aprovada: IC08 `wave_of_terror`
- [ ] gerada · [ ] aprovada: IC09 `colar_visao_verdadeira`
- [ ] gerada · [ ] aprovada: IC10 `detector_arcano`
- [ ] gerada · [ ] aprovada: IC11 `dispositivo_antimagia_gilly`
- [ ] gerada · [ ] aprovada: IC12 `dispositivo_das_docas`
- [ ] gerada · [ ] aprovada: IC13 `coracao_da_dominancia` (com a referência do dono)

## 4. AR: Arcanista (ART-041)

- [ ] gerada · [ ] aprovada: AR01 `arcanista` (NPC, fundo ciano)

## 5. SE: segredos da fatia piloto (ART-043)

- [ ] gerada · [ ] aprovada: SE01 `eco` (miniatura 128 × 128, fundo ciano)
- [ ] gerada · [ ] aprovada: SE02 `camara_selada` (fundo ciano)
- [ ] gerada · [ ] aprovada: SE03 `camara_aberta` (com a SE02 aprovada anexada)

## 6. SE: ruína de cada fase (ART-043)

- [ ] gerada · [ ] aprovada: SE04 `ruina_dagruve`
- [ ] gerada · [ ] aprovada: SE05 `ruina_docas`
- [ ] gerada · [ ] aprovada: SE06 `ruina_shedaklah`
- [ ] gerada · [ ] aprovada: SE07 `ruina_molor`
- [ ] gerada · [ ] aprovada: SE08 `ruina_durao`
- [ ] gerada · [ ] aprovada: SE09 `ruina_feng_tu`
- [ ] gerada · [ ] aprovada: SE10 `ruina_shendilavri`
- [ ] gerada · [ ] aprovada: SE11 `ruina_goranthis`

## 7. BN: ícones das bênçãos novas (ART-038)

Prompts em [[ART-PROMPTS-059-icones-das-bencaos-novas]]; ícones 128 × 128, destino `assets/icons/boons/<id>.png`.

- [ ] gerada · [ ] aprovada: I01 `lliira_juramento`
- [ ] gerada · [ ] aprovada: I02 `tou_um_caminho`

## Mensagens

Os textos completos de cada mensagem estão em [[ART-PROMPTS-061-eventos-arcanista-icones-segredos-e-altar]] (seções EV, AR, IC, AL, SE) e em [[ART-PROMPTS-059-icones-das-bencaos-novas]] (BN).

## Total

34 peças: 1 + 6 + 13 + 1 + 3 + 8 + 2.
