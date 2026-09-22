---
id: "ART-PROMPTS-004"
type: "prompts-de-arte"
title: "Inimigos de Molor e Durao"
status: "draft"
created: "2026-09-21"
relations: ["[[ART-PROMPTS-001-direcao-e-piloto]]", "[[RESEARCH-001-abismo-bestiario-visual-2026-09-21]]"]
sources: ["data/enemies.json", "data/stages.json", "vault canônico"]
---

# Inimigos — Molor e Durao

Aplicar o bloco de figuras de ART-PROMPTS-001. Matriz 1024×1536 transparente; final `assets/enemies/<id>.png`, RGBA 320×480; candidatas em `assets/_raw/enemies/`.

## Molor

### 1. `bolha_de_slime` — comum/divisor; altura 58%
```text
Bolha de slime de Molor, esfera gelatinosa verde-negra quase translúcida porém com borda sólida, deformada contra a base, bolhas menores presas em seu interior, detritos e um filamento que sugere divisão. Sem rosto. Pixel art isométrica, contraste forte, fundo realmente transparente, sem caverna ou chão.
```
Aceite: esfera legível; diferente do limo alongado de Juiblex.

### 2. `cultista_thullgrime` — atirador; altura 82%
```text
Cultista de Ghaunadaur de Thullgrime, humanoide adulto em andrajos impermeáveis, máscara improvisada, documentos apodrecidos presos ao cinto e cajado curto que lança um glóbulo roxo-negro. Parasitas e limo aderem às botas; postura fanática, doente e ainda consciente. Pixel art isométrica sombria, fundo transparente, sem barraco ou cenário.
```
Aceite: cultura miserável de Thullgrime; não copiar os cultistas de Dagruve.

### 3. `receptaculo_de_juiblex` — elite; altura 90%
Referência obrigatória: `slime_de_juiblex` aprovado.
```text
Receptáculo de Juiblex, enorme massa humanoide de ooze verde-oliva construída da mesma substância e olhos dispersos do Limo de Juiblex de referência. Tórax cavado abriga um núcleo verde opaco, braços assimétricos terminam em pseudópodes e a base se divide em vários fluxos presos ao corpo. Deve parecer backup vazio, sem a presença soberana do original. Pixel art isométrica, fundo transparente, sem altar.
```
Aceite: identidade visual de Juiblex; elite, não chefe final; núcleo visível.

### 4. `blogbog` — chefe; altura 96%
```text
Blogbog, chefe fúngico de Molor, corpo inteiro colossal: entidade de cogumelo apodrecido com chapéu rasgado, quatro braços-raiz, crostas de slime e um núcleo verde de Juiblex brilhando por rachaduras no tórax. Mistura fungo e ooze sem perder silhueta fúngica; postura agressiva e pesada. Pixel art isométrica sombria, fundo transparente, sem cenário ou lacaios.
```
Aceite: núcleo verde é integrado; maior que o receptáculo; não se parece com Zuggtmoy.

## Durao

### 5. `alma_penada` — enxame; altura 66%
```text
Alma penada arrancada do rio de Durao, forma humanoide alongada azul-ciano, rosto quase apagado, braços puxados para trás pela corrente e cauda espectral compacta em vez de pernas. Bordas opacas com dithering, transparência apenas por modulação no jogo. Pixel art isométrica, fundo alfa, sem rio ou partículas separadas.
```
Aceite: leitura espectral a 48 px; corpo opaco suficiente para recorte.

### 6. `demonio_de_gehenna` — mercenário yugoloth; altura 84%
```text
Mercenário yugoloth vindo de Gehenna, mantendo o ID interno demonio_de_gehenna: humanoide insetoide de carapaça vermelho-ferrugem e negra, quatro braços compactos, duas lanças curtas de ferro e placas de contrato presas ao peitoral. Aparência disciplinada de soldado pago, não demônio caótico nem diabo. Pixel art isométrica, luz superior esquerda, fundo transparente, sem estandarte ou texto.
```
Aceite: yugoloth/mercenário; sem símbolos infernais; ID não aparece na imagem.

### 7. `carcereiro_de_pedra` — pesado; altura 88%
```text
Carcereiro de Pedra da jaula gigante de Durao: construto largo de basalto e ferro oxidado, cabeça sem rosto sob arco de pedra, braços terminando em grilhões maciços e uma fenda azul de almas no peito. Silhueta quadrada, passos pesados. Pixel art isométrica, fundo transparente, sem cela ou cenário.
```
Aceite: pedra e ferro; grilhões legíveis; diferente dos guardiões alados.

### 8. `molydeus_menor` — elite; altura 92%
```text
Molydeus carcereiro de Durao, demônio enorme e musculoso com duas cabeças: uma cabeça lupina dominante e uma cabeça serpentina menor surgindo do ombro. Pele vermelho-escura, armadura de ferro oxidado, machado demoníaco de duas lâminas e correntes de prisão. Feridas antigas irradiam azul de almas muito discreto. Pixel art isométrica, fundo transparente, sem outras criaturas.
```
Aceite: duas cabeças e machado inequívocos; elite alto; sem luz radiante própria.

### 9. `molydeus_chefe` — chefe; altura 98%
Referência obrigatória: `molydeus_menor` aprovado.
```text
O mesmo tipo de Molydeus da referência, agora Carcereiro-Chefe: maior, armadura cerimonial de ferro negro e ferrugem, cabeça lupina marcada por cicatriz, serpente com olhos azul-fantasma, machado mais largo e feixe de chaves/grilhões preso à cintura. Manter anatomia, espécie e câmera da referência; ampliar autoridade por silhueta e detalhes, não apenas cor. Fundo transparente, sem jaula.
```
Aceite: mesma espécie; chefe por porte; arma inteira dentro do quadro.

### 10. `aberracao_shu` — comum veloz; altura 72%
```text
Shu, aberração semelhante a um gafanhoto sob controle de Ghaunadaur: corpo insetoide vertical magro, carapaça verde-negra, pernas traseiras dobradas, braços em foice, olhos múltiplos roxos e um pequeno selo viscoso aderido ao tórax. Estranho e ágil, sem roupas ou arma. Pixel art isométrica, fundo transparente.
```
Aceite: gafanhoto aberrante; controle sugerido sem redesenhar como slime.

### 11. `ezro` — pesado; altura 80%
```text
Ezro, demônio-sapo sob submissão anômala a Ghaunadaur: sapo humanoide largo, pele cinza-esverdeada verrugosa, boca enorme, olhos âmbar, braços fortes e postura agachada. Um olho-selo roxo viscoso está preso ao dorso como marca de controle, não como parte natural. Pixel art isométrica sombria, fundo transparente, sem pântano.
```
Aceite: demônio-sapo; marca de controle secundária; não parecer hezrou genérico.

## Dependências

`slime_de_juiblex` → `receptaculo_de_juiblex`; `molydeus_menor` → `molydeus_chefe`. Candidata aprovada: —.

