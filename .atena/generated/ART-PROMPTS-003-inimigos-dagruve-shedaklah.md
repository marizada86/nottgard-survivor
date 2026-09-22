---
id: "ART-PROMPTS-003"
type: "prompts-de-arte"
title: "Inimigos de Dagruve e Shedaklah"
status: "approved-for-generation"
created: "2026-09-21"
relations: ["[[ART-PROMPTS-001-direcao-e-piloto]]", "[[RESEARCH-001-abismo-bestiario-visual-2026-09-21]]"]
sources: ["data/enemies.json", "data/stages.json", "vault canônico"]
---

# Inimigos — Dagruve e Shedaklah

Aplicar o bloco de figuras de ART-PROMPTS-001. Cada matriz é 1024×1536 transparente; final RGBA 320×480. Candidata `.atena/generated/art-candidates/enemies/<id>_vNN.png`; final `assets/enemies/<id>.png`.

## Dagruve

### 1. `notivago` — comum, piloto; altura útil 78%

```text
Uma pessoa profundamente afetada pela névoa de Dagruve, corpo inteiro isométrico. Humanoide magro e encurvado, roupas comuns rasgadas e úmidas, pele pálida acinzentada, olhos opacos, dedos tensos e marcha errática; fios sólidos de névoa cinza-azulada aderidos às pernas e costas. Deve parecer vítima perigosa, não zumbi decomposto. Pixel art sombria, luz superior esquerda, fundo realmente transparente, sem cenário, texto ou partículas soltas.
```

Aceite: distinto do `zumbi`; fraco e veloz; névoa presa ao corpo.

### 2. `arch_hag` — elite; altura 88%

```text
Arch-hag das Docas, conjuradora monstruosa de corpo inteiro em três quartos isométrico. Figura feminina idosa, alta e ossuda, pele verde-acinzentada marcada por sal e ritual, cabelo branco encharcado, manto feito de redes, couro e algas escuras; cajado torto com talismãs de cais e uma mão erguida invocando magia verde-fria compacta. Silhueta de elite e invocadora, sem sensualização. Pixel art sombria, fundo transparente, sem cenário, texto ou símbolos inventados.
```

Aceite: leitura de lançadora à distância; nenhum oceano ou círculo de ritual no fundo.

### 3. `tentaculo_kraken` — elite imóvel; altura 72%, base larga

```text
Um único tentáculo colossal do Kraken das Docas emergindo verticalmente de uma base compacta de água escura e madeira quebrada aderida ao corpo. Pele azul-negra com ventosas pálidas, cicatrizes e placas úmidas; ponta curvada pronta para golpear à distância. A base deve permitir leitura de inimigo imóvel e ponto de contato claro. Pixel art isométrica, luz superior esquerda, fundo transparente; sem mostrar o kraken inteiro, barco completo ou cenário.
```

Aceite: uma criatura/segmento; base central; silhueta não parece slime.

## Shedaklah

### 4. `gargula` — comum resistente; altura 82%

```text
Gárgula da Biblioteca Corrompida reaproveitada em Shedaklah: corpo inteiro baixo e pesado, pedra antiga parcialmente derretida e remodelada como argila, asas curtas fechadas, garras grossas, rosto bestial rachado. Pequenos resíduos de limo e fungo apenas mostram a travessia da camada; a criatura continua sendo pedra. Pixel art isométrica sombria, fundo transparente, sem pedestal ou cenário.
```

Aceite: pedra/argila domina; asas dentro das margens; não confundir com Guardião Alado.

### 5. `cogumelo_fungico` — comum de área; altura 60%

```text
Criatura fúngica ambulante de Shedaklah: grande chapéu irregular marrom-violeta sobre talo carnoso dividido em três pernas-raiz, bolsas de esporos rosa-doentio e micélio pendente. Sem rosto humano; postura baixa, deixando uma pequena mancha de esporos opacos presa à base. Pixel art isométrica, fundo realmente transparente, sem floresta ou chão.
```

Aceite: pequeno, área persistente, forma fungo e não slime.

### 6. `servo_de_zuggtmoy` — comum; altura 82%

```text
Servo voluntário de Zuggtmoy, humano ou meio-orc adulto de corpo inteiro, vestes práticas de pântano cobertas por micélio, máscara respiratória de fibras fúngicas e lança curta de madeira-micélio. Cogumelos crescem simetricamente nos ombros como insígnia, sem controle parasitário grotesco; postura disciplinada e consciente. Pixel art isométrica sombria, fundo transparente, sem texto ou cenário.
```

Aceite: devoção voluntária; não parecer morto-vivo ou infectado sem vontade.

### 7. `esporo_voador` — atirador; altura 46%

```text
Esporo voador de Shedaklah: bolsa fúngica arredondada rosa-pálida e violeta, membranas curtas como asas, filamentos pendentes e um poro frontal lançador. Flutua com corpo compacto; poucos grãos de esporo opacos permanecem colados ao contorno. Pixel art isométrica, fundo transparente, sem nuvem solta ou cenário.
```

Aceite: menor da camada; leitura aérea; projétil sugerido sem ser desenhado separado.

### 8. `pudim_negro` — pesado; altura 62%, base 80% da largura

```text
Pudim negro abissal, massa ampla de ooze preto-violeta erguida em arco baixo, superfície brilhante irregular com bolhas, ossos e metal parcialmente dissolvidos dentro do corpo. Nenhum rosto; pseudópodes curtos e poça opaca integrada à base. Pixel art isométrica de alto contraste, fundo transparente, sem reflexo de cenário.
```

Aceite: amorfo e pesado; não usar preto sem detalhes; objetos internos não viram membros.

### 9. `slime_de_juiblex` — divisor; altura 66%

```text
Limo de Juiblex verde ácido e oliva, massa assimétrica elevada com vários pseudópodes finos e olhos incompletos dispersos sob a superfície, sugerindo fragmento de uma mente-colmeia. Duas pequenas gotas-filhas ainda ligadas ao corpo indicam que se divide ao morrer. Pixel art sombria, luz superior esquerda, fundo transparente, sem rosto central ou cenário.
```

Aceite: distinto de `slime_corrosivo`; divisão legível; olhos não formam rosto simpático.

### 10. `zuggtmoy` — chefe; altura 96%

```text
Zuggtmoy, Dama dos Fungos, corpo inteiro monumental em três quartos isométrico. Forma régia feminina não humana composta por talos, micélio, placas de cogumelos e quatro grandes franjas fúngicas que funcionam como manto; coroa orgânica de chapéus, rosto belo porém alienígena, mãos longas e bolsas de esporos rosa-violeta. Postura de negociação ameaçadora e poder soberano, não cadáver nem troféu. Pixel art densa, fundo transparente, sem trono, súditos ou cenário.
```

Aceite: chefe por silhueta/escala; fungo, não planta floral; nada implica morte.

## Dependências e registro

Gerar `cogumelo_fungico` antes de `servo_de_zuggtmoy` e Zuggtmoy; gerar `slime_de_juiblex` antes de futuros receptáculos. Candidata aprovada: — para todos.
