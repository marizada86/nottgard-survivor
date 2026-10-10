---
id: "ART-PROMPTS-061"
type: "prompts-de-arte"
title: "Mecânicas novas da 0.4.0: eventos aleatórios, Arcanista, ícones de armas e equipamentos, segredos e altar animado"
status: "prompts prontos para o ChatGPT; nenhuma imagem gerada; candidatos ficam fora do runtime até admissão do dono"
priority: "normal (depois dos heróis Erik e Arlindo, FILA-027)"
created: "2026-10-09"
relations: ["[[SPEC-164-eventos-aleatorios-novos-mec-005]]", "[[SPEC-149-npc-de-upgrade-de-magia-arcanista]]", "[[SPEC-150-tres-armas-e-magias-novas-do-nottcard]]", "[[SPEC-151-sete-equipamentos-unicos-do-vault]]", "[[SPEC-152-fatia-piloto-de-segredos-ecos-e-reliquias]]", "[[SPEC-153-altar-oco-sobre-a-estrada-bug-038]]", "[[ART-PROMPTS-042-isca-do-sylas-e-eventos-ampulheta-doacao-aposta]]", "[[ART-PROMPTS-009-icones-armas-itens]]", "[[ART-PROMPTS-059-icones-das-bencaos-novas]]"]
sources: ["backlog ART-041, ART-042, ART-043, ART-044, ART-046", "data/random_events.json", "data/weapons.json", "data/items.json", "data/secrets.json", "assets/interactions/*", "assets/icons/weapons/*", "assets/icons/items/*"]
---

# Mecânicas novas: eventos, Arcanista, ícones, segredos e altar

> Derivado. Não autoriza geração por si; o dono aprova o início do lote e a ordem. Tudo aqui hoje roda com **arte provisória** (losango colorido com rótulo, ícone emprestado por `icon_like`, brilho desenhado em código): **nenhuma peça bloqueia o jogo**.

## Prontidão visual (DRAFT, antes de gerar)

| Item | Estado |
|---|---|
| Direção de arte | **CANON de trabalho:** a mesma dos objetos interativos existentes (`assets/interactions/altar_active.png`, `loja.png`, `ferreiro.png`, `doacao.png`, `aposta.png`): pixel art sombria, vista três quartos, pedra cinza-arroxeada, metal escuro, acentos de uma cor por objeto. Âncora de estilo dos ícones: os existentes em `assets/icons/weapons/` e `assets/icons/items/`. |
| Identidade | **DRAFT.** Os eventos aleatórios são **genéricos de propósito** (aprovados em 2026-10-09 sem lore do Vault): a arte não pode inventar emblema, nome, símbolo de divindade, brasão nem texto. Arcanista: "figura de papel genérico, sem lore inventada" (SPEC-149). Itens únicos: só o que o `note` do cartão diz. |
| Contexto de cena | Objeto isolado em jogo 2D isométrico, fundo liso para recorte (magenta ou ciano) ou alfa real nos ícones. Sem cenário. |
| Lacunas | Nenhuma bloqueante. **Coração da Dominância:** referência do dono em `.atena/generated/item-refs/coracao-da-dominancia-referencia.webp` (anexar). O que o Vault não diz sobre cada equipamento não se desenha. |
| Autoridade | O dono admite ou rejeita cada candidato; nada entra em `assets/` antes disso. |

## Convenções do projeto (valem para todas as peças)

1. **Uma peça por mensagem.** Não gerar em lote numa imagem.
2. **Props e personagens de evento (EV, AR, AL, SE):** imagem **quadrada**, na maior resolução que o gerador der; fundo liso **magenta #FF00FF** (use **ciano #00FFFF** quando o objeto tiver magenta ou roxo, e diga na mensagem); recortar o fundo depois. Final **256 × 256 RGBA** em `assets/interactions/<id>.png` (exceto AL). Objeto inteiro centrado, ocupando cerca de 70% da altura, sombra suave no chão que **não** vira halo.
3. **Ícones (IC):** matriz **1024 × 1024**, final **128 × 128 RGBA**, fundo realmente transparente, 15% de margem, silhueta legível a **48 px**. Armas e feitiços em `assets/icons/weapons/<id>.png`; equipamentos e únicos em `assets/icons/items/<id>.png`.
4. **Sem** texto, letras, números, moldura, círculo de fundo, logotipo, marca d'água, mãos extras, cenário, halo preto/branco/vermelho ou aparência 3D.
5. Candidatas em `.atena/generated/art-candidates/<família>/<id>_v01.png`, até **3 por peça** (cada nova tentativa corrige um defeito objetivo). Marque `[x]` ao gerar e `[a]` ao aprovar.

## Bloco comum — props e personagens de evento

```text
Use case: stylized-concept
Asset type: objeto interativo de jogo 2D isométrico
Style/medium: pixel art sombria coerente com o jogo, pixels nítidos, pedra cinza-arroxeada, metal escuro, um acento de cor por objeto, luz principal no alto à esquerda
Composition/framing: vista três quartos, objeto inteiro centrado ocupando cerca de 70% da altura, sombra suave no chão
Constraints: fundo liso magenta #FF00FF (ciano #00FFFF se o objeto tiver roxo), sem texto, letras, números, moldura ou cenário, sem personagens (exceto onde o pedido disser), quadrado
```

Anexar sempre **duas âncoras de estilo**: `assets/interactions/loja.png` e `assets/interactions/doacao.png`.

---

## EV — Seis eventos aleatórios (ART-046, MEC-005)

Destino: `assets/interactions/<kind>.png` (o jogo já procura esse arquivo; sem ele, mostra o losango).

### EV01 `pacto_sangue` — Pacto de Sangue (acento vermelho)

```text
[Bloco comum] Primary request: laje de pedra escura rachada, plantada no chão, com um selo de cera vermelha pulsante no centro, gravado com um glifo angular simples (sem letras), três gotas escuras de sangue ressecado ao redor e uma pequena adaga cravada ao lado; um brilho vermelho fraco sobe do selo.
```

### EV02 `relicario` — Relicário Lacrado (acento dourado-escuro)

```text
[Bloco comum] Primary request: pequeno cofre de ferro escuro com tampa abaulada e fechadura feita de ossos entrelaçados, correntes grossas dando uma volta, reflexos dourado-escuros apagados no metal; sem luz saindo (está lacrado).
```

### EV03 `peregrino` — Peregrino Ferido (acento azul-claro) — figura de NPC

```text
[Bloco comum] Primary request: viajante humano caído sentado, encostado em um marco de pedra quebrado, capa azul-clara rota e capuz, uma mão pressionando o flanco, bolsa de viagem ao lado, expressão de dor; silhueta clara e sem rosto detalhado, em escala de evento (cerca de 80 px na tela).
Constraints extra: um único personagem, humano genérico, sem armadura de facção, sem emblema, sem arma desembainhada.
```

### EV04 `contador` — Contador de Histórias (acento verde) — figura de NPC

```text
[Bloco comum] Primary request: figura encapuzada sentada em um toco junto a uma fogueira baixa, manto verde-musgo, um rolo de pergaminho aberto sobre os joelhos, a luz da fogueira desenhando o contorno do capuz; rosto na sombra.
Constraints extra: um único personagem genérico, sem emblema nem símbolo, sem texto no pergaminho (só linhas borradas).
```

### EV05 `carroca` — Carroça Abandonada (acento laranja)

```text
[Bloco comum] Primary request: carroça de madeira escura tombada de lado com uma roda quebrada solta, caixotes abertos e sacos rasgados espalhados, uma lanterna acesa caída com luz laranja fraca; a cena sugere sorte ou isca, sem corpos nem inimigos.
```

### EV06 `eclipse_pedra` — Pedra do Eclipse (acento roxo) — usar fundo ciano

```text
[Bloco comum, com fundo ciano #00FFFF] Primary request: monólito baixo de pedra negra, liso e fosco, que não reflete luz; aro estreito de luz roxa fria ao redor da borda superior como o contorno de um eclipse, runas apagadas e sem sentido legível na base, rachaduras finas.
```

Aceite (EV01 a EV06): as seis se distinguem entre si e de loja, ferreiro, curandeiro, doação e aposta **pela silhueta e pela cor**; leem bem a 80 px; sem letras; fundo sólido uniforme; NPCs (EV03, EV04) genéricos.

---

## AR — Arcanista (ART-041, MEC-041)

### AR01 `arcanista` — NPC de upgrade de magia (acento roxo) — usar fundo ciano

Destino: `assets/interactions/arcanista.png` (256 × 256). Hoje: losango roxo com rótulo.

```text
[Bloco comum, com fundo ciano #00FFFF] Primary request: figura de papel genérico, um mago-escriba de meia-idade, de pé, túnica longa roxo-escura com detalhes em violeta, capuz baixo, uma mão segurando um livro grosso fechado com fecho de metal e a outra erguida com um pequeno fogo-fátuo violeta flutuando sobre a palma; paleta abissal, tom arcano.
Constraints extra: um único personagem, sem emblema, sem texto, sem cajado enorme, rosto discreto; em escala de evento (cerca de 80 px na tela) e distinto do Curandeiro (`assets/interactions/curandeiro.png`).
```

Aceite: lê como "alguém que estuda magia", não como herói nem inimigo; combina com o Ferreiro e o Curandeiro; roxo reconhecível sem confundir com o Eclipse (EV06).

---

## IC — Ícones das armas e equipamentos novos da 0.4.0 (ART-042, MEC-042)

Bloco comum dos ícones (o mesmo do ART-PROMPTS-009):

```text
Use case: stylized-concept
Asset type: ícone de item/habilidade para jogo
Style/medium: ícone pintado em pixel art sombria, contorno escuro grosso, materiais legíveis, alto contraste, luz superior esquerda
Composition/framing: um único objeto ou gesto mágico central, vista três quartos, 15% de margem, silhueta legível a 48 px
Constraints: fundo realmente transparente; sem texto, letras, números, mãos extras, moldura, cenário, logotipo ou marca-d'água; nenhuma cor encosta nas bordas
```

Âncoras de família a anexar: para armas, `assets/icons/weapons/descarga_estelar.png` e `golpe_esmagador.png`; para equipamentos, `assets/icons/items/machado_de_xargath.png` e `colar_dos_tentaculos.png`.

### Armas e feitiços — `assets/icons/weapons/<id>.png`

| Código | `id` | Pedido específico |
|---|---|---|
| IC01 | `bola_de_fogo` | Esfera de fogo laranja-vermelha com cauda curta e centro amarelo-branco, desenhada como um projétil prestes a explodir; chamas angulares, sem rosto. |
| IC02 | `tormenta_de_fogo` | Evolução da bola de fogo (mesma forma-base): um grupo compacto de quatro esferas de fogo caindo em arcos paralelos sobre uma faixa de chamas baixas. |
| IC03 | `lamina_de_sombra` | Lâmina curva de sombra roxo-escura, quase translúcida, com uma fenda branco-azulada no fio que corta um véu arcano; diagonal ascendente. |
| IC04 | `romper_armadura` | Maça de guerra de ferro no instante do impacto contra uma peitoral de placas que racha em duas, estilhaços presos ao conjunto. |
| IC05 | `esmagar_defesas` | Evolução do romper armadura: o mesmo martelo ampliado, com a placa quebrada em três pedaços e uma rachadura que sobe pelo cabo. |
| IC06 | `dominio_da_vontade` | Olho aberto, sem pupila definida, cercado por três fios de névoa rosa-violeta que se prendem a uma silhueta humana mínima (marionete); sem mãos. Mesma família de `dominar_pessoa`. |

### Equipamentos únicos — `assets/icons/items/<id>.png`

| Código | `id` | Pedido específico (só o que o cartão diz) |
|---|---|---|
| IC07 | `cajado_familia_infernum` | Cajado de madeira clara de Yggdrasil, nós e veios visíveis, cravejado com pedras azul-brancas da estrela de Eléstria na ponta; relíquia de família, bem cuidada. |
| IC08 | `wave_of_terror` | Espada longa de lâmina negra com acabamento ácido esverdeado escorrendo pelo fio, sombras presas à guarda; sensação de maldição, sem caveiras nem texto. |
| IC09 | `colar_visao_verdadeira` | Colar de corrente de prata escura com um pingente em forma de olho aberto de três pontas (o olho de Ghaunadaur): íris roxa fria, esclera cinza, legível a 48 px. |
| IC10 | `detector_arcano` | Anel de latão com uma lente pequena e uma agulha fina que oscila, runas apagadas na argola; sensação de instrumento, não de joia. |
| IC11 | `dispositivo_antimagia_gilly` | Peitoral-engenhoca de chapa e engrenagens aparentes, com uma lente circular azul no centro que projeta um escudo hexagonal; aparência de invenção gnômica, não de armadura de cavaleiro. |
| IC12 | `dispositivo_das_docas` | Mecanismo de bronze e cordas, do tamanho de um amuleto, com uma pequena hélice e uma âncora estilizada; sensação de porto e maresia, sem texto. |
| IC13 | `coracao_da_dominancia` | **Anexar a referência do dono.** Cajado de osso branco perolado terminando em um coração cristalino rosa com luz interna, envolto em filamentos roxos e carmesim; troféu da vontade, elegante e perigoso. A referência prevalece sobre o texto. |

Aceite (IC01 a IC13): cada ícone se reconhece a **48 px**; armas da mesma evolução (IC01/IC02, IC04/IC05) compartilham forma-base; nenhuma lembra o ícone emprestado a ponto de ser confundida com ele (`descarga_estelar`, `golpe_esmagador`, `cajado`, `espada_longa`, `amuleto_simples`, `anel_simples`, `cota`, `cetro`); sem letras.

---

## AL — Altar animado com corpo opaco (ART-044, BUG-038)

### AL01 `altar_active` (sheet animado de 6 quadros)

Anexar `assets/interactions/altar_active.png` (o estático **correto**: altar de pedra escura, pano vermelho, bacia e quatro velas). Destino: `assets/animations/interactions/altar_active.png` (**6 quadros de 192 × 192 em uma linha = 1152 × 192**, alfa real).

```text
Use case: stylized-concept
Asset type: sprite sheet de animação de objeto interativo, 6 quadros
Primary request: a mesma imagem de referência do altar, com o corpo de pedra, o pano vermelho e a bacia IDÊNTICOS e totalmente OPACOS em todos os quadros (nenhum quadro pode ter o corpo transparente), variando só as chamas das quatro velas e as brasas da bacia ao longo de um ciclo de 6 quadros que fecha o loop sem salto
Style/medium: pixel art sombria igual à referência, mesma paleta e mesma resolução
Composition/framing: grade de 3 colunas por 2 linhas (ordem: esquerda para a direita, de cima para baixo), cada quadro com o altar inteiro centrado na mesma posição exata, mesma escala em todos
Constraints: fundo liso magenta #FF00FF; sem texto, sem personagens, sem sombra projetada, sem bordas entre os quadros, a pedra nunca pode mostrar o fundo através do corpo
```

Montagem: cortar a grade 3 × 2, recortar o fundo e montar a linha `1152 × 192`. Ao admitir, voltar a animação em `ui/overlay.gd` (exceção `kind == "altar"`).

Aceite: o corpo de pedra tem alfa **1,0** em todos os quadros (auditar com `tools/audit_alpha_solidity.gd`); só chamas e brasas mudam; o primeiro e o último quadro fecham o loop.

---

## SE — Segredos da fatia piloto (ART-043, MEC-039)

> **Ligação no jogo (passo à parte, depois da aprovação visual):** hoje o Eco é um brilho desenhado em código, a câmara usa `camara_selada` (só falta o PNG) e a ruína é o baú comum. Os nomes `eco.png`, `camara_aberta.png` e `ruina_<fase>.png` são **destinos propostos**; cada um pede uma mudança pequena em `ui/overlay.gd` e um teste quando for admitido. As peças de evento (EV), `arcanista`, `camara_selada` e os ícones (IC) já são procurados pelo jogo pelo nome do arquivo.

Prioridade interna: **SE01 a SE03** primeiro (valem em todas as oito fases); **SE04 a SE11** (uma ruína por fase) depois, se a cota permitir. Sem lore nova: só o que a pasta do Vault e `data/secrets.json` dizem.

### SE01 `eco` — Eco de Nottgard (miniatura, acento azul-pálido) — usar fundo ciano

Destino: `assets/interactions/eco.png` (**128 × 128**; é pequeno). Hoje: brilho desenhado em código.

```text
[Bloco comum, com fundo ciano #00FFFF] Primary request: uma lembrança em miniatura: pequeno fragmento de cristal azul-pálido do tamanho de uma mão, translúcido, com um fio de luz branco-azulada subindo e uma fina poeira de partículas; sensação de memória aprisionada, sem rosto nem símbolo.
Composition extra: ocupa cerca de 50% da altura; deve ler como "brilho colecionável", nunca como moeda nem poção.
```

### SE02 `camara_selada` — Câmara selada (acento roxo claro) — usar fundo ciano

Destino: `assets/interactions/camara_selada.png` (256 × 256). Hoje: losango roxo com rótulo.

```text
[Bloco comum, com fundo ciano #00FFFF] Primary request: porta de pedra baixa e pesada embutida em uma parede de cripta curta, lacrada por três grandes selos de cera e ferro cruzados, uma fenda de luz violeta muito fraca no vão inferior, runas apagadas e sem sentido legível na verga; sensação de câmara trancada que vai abrir.
```

### SE03 `camara_aberta` — Câmara aberta

Destino: `assets/interactions/camara_aberta.png` (256 × 256). Mesma peça de SE02 (anexar a SE02 aprovada) com os selos quebrados e a porta entreaberta.

```text
[Bloco comum, com fundo ciano #00FFFF] Primary request: a mesma câmara de pedra da imagem de referência, agora com os três selos quebrados no chão, a porta entreaberta e uma luz violeta quente saindo do vão, poeira no ar; mesma posição, escala e paleta da referência.
```

### Ruína por fase (SE04 a SE11) — `assets/interactions/ruina_<fase>.png` (256 × 256)

Um prop de ruína por mapa, no tom do bioma; a ruína é onde ficam os Ecos e um baú. Bloco comum de props, fundo magenta (ciano se tiver roxo). **Nenhum personagem.**

| Código | `id` | Fase | Pedido específico |
|---|---|---|---|
| SE04 | `ruina_dagruve` | Dagruve | **Capela abandonada**: pequena capela de pedra escura com o telhado parcialmente desabado, vitral quebrado, névoa baixa no chão e lápides ao lado. |
| SE05 | `ruina_docas` | Docas | **Galpão abandonado**: galpão de madeira e ferro corroído com a porta entreaberta, caixas de carga empilhadas e uma corda caída; sensação de porto morto. |
| SE06 | `ruina_shedaklah` | Shedaklah | **Ruína do bosque fúngico**: muro de pedra tomado por cogumelos grandes e limo verde-escuro, um arco quebrado e esporos no ar. |
| SE07 | `ruina_molor` | Molor | **Ruína na gruta de estalactites**: pilares de pedra com estalactites que descem do teto, poças de slime esverdeado e um altar partido. |
| SE08 | `ruina_durao` | Durao | **Acampamento abandonado**: tendas cinzentas rasgadas, uma fogueira apagada, armas largadas e uma bandeira sem emblema caída. |
| SE09 | `ruina_feng_tu` | Feng-tu | **Templo arruinado de Tou Um**: templo de pedra clara partido ao meio, uma estrela de pedra caída no chão, vermelho estreito de um tapete rasgado; sem texto. |
| SE10 | `ruina_shendilavri` | Shendilavri | **Ruína na colina de Rivenheart**: arcos de pedra rosada sobre uma colina, cortinas rasgadas ao vento e pétalas secas; elegância decaída. |
| SE11 | `ruina_goranthis` | Goranthis | **Salão de festa abandonado**: salão aberto com mesas viradas, taças quebradas e fitas prateadas penduradas; festa que acabou. |

Aceite (SE01 a SE11): SE01 lê a 48 px como "brilho a coletar"; SE02/SE03 são claramente a mesma câmara fechada e aberta; as oito ruínas se distinguem entre si pelo bioma e **não** se confundem com baú, altar ou portal; sem letras nem emblemas.

---

## BN — Ícones das bênçãos novas (ART-038)

Os prompts **já estão prontos** em [[ART-PROMPTS-059-icones-das-bencaos-novas]] (**I01** `lliira_juramento` e **I02** `tou_um_caminho`; ícones **128 × 128**). Esta fila só os abre; não repito os textos aqui.

---

## Admissão (todas)

1. Candidata em `.atena/generated/art-candidates/<família>/` (`eventos`, `arcanista`, `icones`, `altar`, `segredos`).
2. O dono aprova o visual; a Atena recorta o fundo, normaliza o tamanho e confere o aceite da peça.
3. Só então entra em `assets/` (com o `.import`) e o provisório correspondente sai (ícone `icon_like`, losango, brilho).
4. Cada admissão tem teste e registro (`tools/audit_projeto.gd` deve manter `erros=0`).
