---
id: "ART-PROMPTS-006"
type: "prompts-de-arte"
title: "Inimigos de Goranthis e dos Pilares"
status: "approved-for-generation"
created: "2026-09-21"
relations: ["[[ART-PROMPTS-001-direcao-e-piloto]]", "[[RESEARCH-001-abismo-bestiario-visual-2026-09-21]]"]
sources: ["data/enemies.json", "data/stages.json", "vault canônico"]
---

# Inimigos — Goranthis e Pilares

Aplicar ART-PROMPTS-001: matriz 1024×1536, transparência real, final RGBA 320×480 em `assets/enemies/<id>.png`.

### 1. `ilusao_de_socothbenoth` — enxame ilusório; altura 78%
```text
Ilusão criada por Socothbenoth: cortesão humanoide adulto de beleza artificial, roupas marfim e dourado gasto, rosto liso demais como máscara de porcelana e sorriso imóvel. Metade inferior revela placas geométricas e carne rosada apenas nas fissuras, tudo preso à silhueta. Pixel art isométrica, fundo transparente; transparência adicional será aplicada no jogo.
```
Aceite: falso paraíso em primeiro olhar; horror só na segunda leitura.

### 2. `guardiao_de_goranthis` — pesado; altura 90%
```text
Guardião do Paraíso de Goranthis: estátua viva de mármore marfim e ouro gasto, corpo atlético idealizado, quatro asas pétreas fechadas e lança ornamental. Rachaduras discretas mostram carne viva e slime verde por baixo, revelando que o paraíso é falso. Pixel art isométrica, fundo transparente, sem pedestal ou jardim.
```
Aceite: beleza corrompida; diferente da estátua de Feng-tu e das gárgulas.

### 3. `cultista_de_socothbenoth` — conjurador; altura 82%
```text
Sacerdote de ilusões de Socothbenoth, adulto em túnica marfim, rosa escuro e ouro, máscara dupla com uma face serena e outra sussurrante, cajado espelhado e fitas que parecem belas de um lado e carne do outro. Postura persuasiva, não combatente bruto. Pixel art isométrica, fundo transparente, sem símbolos textuais.
```
Aceite: conjurador/ilusionista; dualidade visual legível.

### 4. `socothbenoth` — chefe/âncora; altura 98%
```text
Socothbenoth, Lorde Abissal e âncora de Juiblex, corpo inteiro régio e andrógino em três quartos isométrico. Forma alta e elegante, pele marfim, quatro chifres finos, vestes douradas e vinho que se fundem a placas de carne viva; sombras sussurrantes aderidas aos ombros. No abdômen, fissuras discretas deixam ver slime verde de Juiblex envolvendo um núcleo, preparando uma futura corrupção sem consumi-lo ainda. Pixel art sombria, fundo transparente, sem palácio, nudez ou servos.
```
Aceite: soberano do falso paraíso; slime secundário; não representar já morto.

### 5. `death_tyrant` — elite canônico realocado; altura 90%
```text
Death Tyrant canônico de Nottgard: cadáver de Kein fundido a um Beholder. Grande esfera ocular morta de pele cinza-violeta, olho central azul fantasmagórico, dez hastes oculares ósseas; o torso e o rosto parcialmente reconhecíveis de um humano morto emergem fundidos na parte inferior, sem gore explícito. Correntes e resíduos rituais presos ao corpo. Pixel art isométrica, fundo transparente, sem covil.
```
Aceite: fusão, não beholder genérico; elite flutuante; nenhum segundo corpo separado.

### 6. `sintese_abissal` — chefe final; altura 100%, gerar por último
Referências obrigatórias: Zuggtmoy/fungo, Receptáculo/ooze, Molydeus, Lu Yueh, Malcanthet e Socothbenoth aprovados.
```text
A Síntese Abissal, chefe final composto pelas linguagens visuais já aprovadas: corpo central alto de pedra abissal violeta quase preta, torso envolto por slime verde de Juiblex, coroa fúngica assimétrica, um braço-carcerário inspirado no Molydeus, outro braço pestilento de Lu Yueh, uma asa negra de Shendilavri e placas de mármore/carne de Goranthis. Tudo deve formar uma única anatomia coerente, não colagem de monstros. Um núcleo lilás elétrico no peito é protegido por camadas resistentes; pequenas fissuras branco-douradas sugerem vulnerabilidade radiante. Pixel art isométrica, fundo transparente, sem cenário, texto ou lacaios.
```
Aceite: motivos reconhecíveis sem copiar cabeças inteiras; silhueta única; vulnerabilidade radiante discreta; nenhuma nova linguagem visual.

## Dependências

Gerar Socothbenoth antes de eventual fase consumida. Gerar Síntese somente depois de todas as referências. Candidata aprovada: —.
