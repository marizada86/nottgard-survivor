---
id: "ART-PROMPTS-005"
type: "prompts-de-arte"
title: "Inimigos de Feng-tu e Shendilavri"
status: "draft"
created: "2026-09-21"
relations: ["[[ART-PROMPTS-001-direcao-e-piloto]]", "[[RESEARCH-001-abismo-bestiario-visual-2026-09-21]]"]
sources: ["data/enemies.json", "data/stages.json", "vault canônico"]
---

# Inimigos — Feng-tu e Shendilavri

Aplicar ART-PROMPTS-001: matriz 1024×1536, transparência real, final RGBA 320×480 em `assets/enemies/<id>.png`, candidatas em `assets/_raw/enemies/`.

## Feng-tu

### 1. `larva_de_lu_yueh` — enxame; altura 42%
```text
Pequena larva demoníaca de Lu Yueh, corpo segmentado verde-pestilento com seis pernas curtas e um rosto humano adulto perturbador incrustado na cabeça, olhos febris e boca fechada. Pústulas discretas liberam um vapor opaco aderido ao corpo. Pixel art isométrica, fundo transparente, sem sangue, cenário ou caricatura.
```
Aceite: pequena, repulsiva e legível; rosto humano sem comicidade.

### 2. `cultista_de_feng_tu` — comum; altura 80%
```text
Acólito Pestilento de Feng-tu em vestes de templo cinza-ardósia e vermelho desbotado, máscara de pano, sinos de quarentena e bastão curto com frascos verdes selados. Pele visível marcada por doença, postura ritual disciplinada. Motivos locais vêm de estrela do norte, epidemia e arquitetura de templo, sem fantasia oriental genérica. Pixel art isométrica, fundo transparente.
```
Aceite: culto de epidemia; frascos fechados; sem texto ou ideogramas inventados.

### 3. `estatua_do_templo` — pesado; altura 88%
```text
Estátua guardiã do templo de Tou Um, pedra azul-ardósia antiga, humanoide de armadura lamelar estilizada, quatro braços simétricos em pose de proteção e uma estrela de oito pontas sem texto gravada no peito. Rachaduras deixam sair luz azul-branca. Pixel art isométrica, fundo transparente, sem pedestal ou templo.
```
Aceite: protetora, não demoníaca; estrela legível; quatro braços dentro das margens.

### 4. `discipulo_pestilento` — elite; altura 90%
Referência: `cultista_de_feng_tu` aprovado.
```text
O Discípulo Pestilento, evolução do acólito de referência: mesma tradição de vestes, agora alto e deformado pela peste, máscara rígida rachada, três braços doentes, cajado com recipientes lacrados e manto que lembra asas de inseto sem se tornar inseto completo. Aura verde opaca aderida à roupa. Pixel art isométrica, fundo transparente, sem círculo mágico.
```
Aceite: mesma facção; elite por anatomia; não copiar Shu.

### 5. `lu_yueh` — chefe; altura 97%
```text
Lu Yueh, deus das epidemias e conquistador de Feng-tu, figura divina demoníaca alta em vestes cerimoniais verde-negras e vermelho escuro, seis braços segurando recipientes selados, sino, lâmina curta e pergaminho fechado sem escrita visível. Rosto severo coberto por máscara de doença, coroa assimétrica de chifres e halo quebrado verde-pálido preso à silhueta. Ameaça agressiva, não negociadora. Pixel art isométrica, fundo transparente, sem templo ou lacaios.
```
Aceite: chefe por forma; peste sem gore excessivo; nada de texto pseudoasiático.

### 6. `cultista_ghaunadaur` — comum reutilizável; altura 80%
```text
Fanático de Ghaunadaur, humanoide de espécie incerta em manto roxo-negro, capuz profundo e máscara com um único olho oval. Carrega cetro orgânico curto e tem tentáculos viscosos discretos envolvendo um antebraço; pequenos olhos aparecem nas dobras do tecido. Silhueta de cultista abissal reutilizável entre camadas. Pixel art isométrica, fundo transparente, sem cenário.
```
Aceite: identidade de Ghaunadaur; diferente dos cultistas de Dagruve e Thullgrime.

## Shendilavri

### 7. `escravo_de_rivenheart` — comum; altura 78%
```text
Pessoa escravizada de Rivenheart, adulta, magra e exausta, usando roupas outrora luxuosas agora rasgadas, coleira de prata escurecida e correntes quebradas nas mãos. Olhar vazio por encantamento, postura compelida a avançar; sem erotização e sem ferimentos gráficos. Pixel art isométrica, fundo transparente.
```
Aceite: vítima sob controle, não monstro voluntário; leitura respeitosa.

### 8. `sucubo` — comum; altura 84%
```text
Súcubo de Rivenheart em forma demoníaca: figura adulta elegante e ameaçadora, pele vinho escuro, asas de morcego compactas, chifres curvos, cauda e vestes negras/prateadas de corte luxuoso apropriadas para combate. Postura manipuladora com uma mão convidativa e outra pronta para atacar. Pixel art isométrica, fundo transparente; sem nudez, erotização explícita ou cenário.
```
Aceite: sedução por postura e luxo, não exposição corporal; asas nas margens.

### 9. `ilusao_de_sucubo` — variante ilusória; altura 84%
Referência obrigatória: `sucubo` aprovado.
```text
A mesma súcubo da referência, mesma pose, rosto, traje e proporções, mas como ilusão incompleta: bordas duplicadas em magenta e prata, partes das asas e pernas se desfazem em placas geométricas opacas aderidas ao corpo, olhos sem pupila. Não redesenhar a personagem. Fundo transparente; o jogo aplicará transparência adicional.
```
Aceite: identidade idêntica à base; efeitos presos ao corpo; não gerar personagem nova.

### 10. `guarda_do_castelo` — pesado; altura 88%
```text
Guarda do Castelo Argento de Graz'zt: guerreiro demoníaco alto em armadura negra polida com filetes prateados, elmo alongado sem rosto, capa vinho curta e lança de lâmina ondulada. Três pequenos chifres no elmo remetem discretamente a Graz'zt. Postura marcial e sofisticada. Pixel art isométrica, fundo transparente, sem castelo ou brasão textual.
```
Aceite: facção do Castelo Argento; diferente do carcereiro de Durao.

### 11. `master_of_cruelties` — elite reutilizado; altura 92%
```text
Master of Cruelties canônico de Nottgard: grande demônio alado de presença cativante, corpo coberto por armadura orgânica preta e vermelho seco, rosto belo e cruel parcialmente oculto por máscara rachada, asas longas dobradas e mãos com garras. Um brilho dourado corrompido preso ao peito sugere encantamento; nenhuma chama, pois é imune ao fogo. Pixel art isométrica, fundo transparente, sem cenário.
```
Aceite: voador, encantador e resistente; não confundir com súcubo nem Malcanthet.

### 12. `malcanthet` — chefe; altura 97%
Referência visual futura: `sucubo`; fontes: Malcanthet e Irmãs Radiantes no vault.
```text
Malcanthet, Rainha das Súcubos, corpo inteiro régio em três quartos isométrico. Figura demoníaca adulta de pele vinho profundo, grandes asas negras com membranas magenta, chifres de marfim, coroa prateada, cauda e vestido-armadura negro e prata de luxo corrompido. Expressão soberana e calculista, uma mão comandando e outra segurando espelho pequeno escuro. Imponente sem nudez; confronto sem morte implícita. Pixel art densa, fundo transparente, sem trono ou servos.
```
Aceite: mesma família visual da súcubo, autoridade inequívoca; sem ferimento/chifre perdido nesta forma-base.

## Dependências

`cultista_de_feng_tu` → `discipulo_pestilento`; `sucubo` → `ilusao_de_sucubo` → `malcanthet`. Candidata aprovada: —.

