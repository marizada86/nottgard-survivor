---
id: "ART-PROMPTS-047"
type: "prompts-de-arte"
title: "Animações dos inimigos de Feng Tu — identidade e ciclos"
status: "Feng Tu integrado:126quadros/25tiras — build159validada"
created: "2026-10-01"
relations: ["[[PLAN-041-animacao-padrao-zumbi-para-inimigos-e-interacoes-2026-09-29]]", "[[PLAN-048-geracao-animacoes-mobs-onda-1-2026-09-30]]", "[[ART-PROMPTS-033-mobs-onda-1-lote-a]]"]
---

# ART-PROMPTS-047 — Feng Tu (Andar 300 · templo de Tou Um)

Segue a receita da Onda 1 (ART-PROMPTS-032 e 033), que o dono aprovou: **primeiro a identidade** (`idle_00`) de cada alvo, depois os demais quadros, cada um como imagem independente. Perfil A = 20 quadros (idle 4, move 6, attack 4, death 6). Perfil B (chefe) = 26 (mais `special` 6). Nenhuma imagem é asset oficial; tudo fica em `.atena/generated/art-candidates/enemies-feng-tu/<id>/`.

## Alvos deste lote

| Alvo | Nome | Perfil | Quadros | Referência estática |
|---|---|---|---:|---|
| `larva_de_lu_yueh` | Larva de Lu Yueh | A | 20 | `assets/enemies/larva_de_lu_yueh.png` |
| `cultista_de_feng_tu` | Acólito Pestilento | A | 20 | `assets/enemies/cultista_de_feng_tu.png` |
| `estatua_do_templo` | Estátua do Templo | A | 20 | `assets/enemies/estatua_do_templo.png` |
| `cultista_ghaunadaur` | Fanático de Ghaunadaur | A | 20 | `assets/enemies/cultista_ghaunadaur.png` |
| `discipulo_pestilento` | O Discípulo Pestilento | A | 20 | `assets/enemies/discipulo_pestilento.png` |
| `lu_yueh` | Lu Yueh, Deus das Epidemias | B | 26 | `assets/enemies/lu_yueh.png` |
| **Total** | | | **126** | |

## Contrato do gate de identidade

```text
Use the attached static sprite as the exact identity reference: preserve its unique silhouette, clothing or anatomy, palette, props, and visual hierarchy. Create one full-body game sprite in a neutral idle pose, viewed at a three-quarter front angle and facing to the RIGHT. Dark-fantasy isometric pixel art, crisp controlled dithering, opaque solid silhouette, no blur, no antialiasing, no motion lines. Centered; the visual base is anchored at the bottom; at least 8% side margin. Transparent background. No ground, cast shadow, scenery, gradient, text, logo, watermark, frame, UI, or extra character. Keep the subject isolated, readable, and at the same apparent scale as the reference.
```

Cada identidade gera só o `idle_00`, anexando a arte estática do alvo. Salvar como `<id>_idle_00_v01.png`.

## I01 — `larva_de_lu_yueh_idle_00`

Referência: `assets/enemies/larva_de_lu_yueh.png`. Larva grande e segmentada verde-oliva, com um rosto humano pálido de olhos vermelhos na frente, fios de fumaça amarela saindo de bulbos nas costas e pernas curtas com garras. Pose: parada, corpo respirando, fumaça amarela presa aos bulbos oscilando.

## I02 — `cultista_de_feng_tu_idle_00`

Referência: `assets/enemies/cultista_de_feng_tu.png`. Cultista de pele doente, chapéu alto preto e vermelho coroado de sinos, véu, robe cinza rasgado com faixas vermelhas, lanternas verdes e sinos pendurados no cinto, cajado ornamentado na mão direita. Pose: parado, cajado apoiado, sinos balançando levemente presos.

## I03 — `estatua_do_templo_idle_00`

Referência: `assets/enemies/estatua_do_templo.png`. Estátua viva de pedra azul com quatro braços (espada, escudo, lança e maça), armadura estrelada com rachaduras azuis luminosas, coroa e pedestal de botas. Pose: parada e rígida, rachaduras azuis pulsando, braços em guarda.

## I04 — `cultista_ghaunadaur_idle_00`

Referência: `assets/enemies/cultista_ghaunadaur.png`. Cultista de manto roxo e capuz, máscara pálida com gema, cajado com um olho roxo na ponta na mão esquerda, braço direito terminado em tentáculo. Pose: parado, cajado apoiado, tentáculo do braço balançando de leve.

## I05 — `discipulo_pestilento_idle_00`

Referência: `assets/enemies/discipulo_pestilento.png`. Versão elite do acólito com três braços conforme identidade v02 aprovada: um braço mutado superior, um braço das lanternas e um braço do cajado; chapéu alto de sinos, robe mais rasgado e corroído, pele doente e lanternas verdes brilhantes. Pose: parado e curvado, cajado apoiado, brilho verde das lanternas pulsando.

## I06 — `lu_yueh_idle_00`

Referência: `assets/enemies/lu_yueh.png`. Deus alto de seis braços conforme identidade v02 aprovada e máscara de bico de peste, coroa de espinhos, manto longo verde-escuro e vermelho com sinos pendurados; segura lanterna, sino, pergaminho e lâmina curva. Pose: ereto e imponente, braços em pose, sinos e manto balançando.

## Base fixa para cada quadro (depois da identidade aprovada)

```text
Use the two attached images as references: preserve the exact character identity from the static sprite, and match the approved idle frame for proportions, palette, scale, camera and facing. Create exactly one full-body animation frame. Dark-fantasy isometric pixel art, three-quarter front view, facing RIGHT, crisp controlled dithering, clean pixel edges. Centered in a tall 2:3 frame with the visual base at the bottom and at least 8% side margin. Truly transparent background. The complete silhouette is solid and opaque; keep slime, mist, fungus, cloth, chains, flames and other effects attached to the character. No ground, cast shadow, scenery, gradient, text, logo, watermark, frame, UI, second character, blur, motion streaks, or loose particles. Keep the same apparent scale as the approved identity frame.
```

Anexar a arte estática `assets/enemies/<id>.png` e o `idle_00` aprovado. Salvar como `<id>_<estado>_<quadro>_v01.png`.

## Poses comuns (todos os alvos)

- `idle_01`: respiração ou pulsação leve, base fixa. `idle_02`: pequena troca de peso ou pulso contido. `idle_03`: assenta na pose de `idle_00` para o loop fechar.
- `move_00`: primeiro contato, passo (ou frente do corpo) à frente. `move_01`: transferência de peso, leve queda do corpo. `move_02`: passagem. `move_03`: contato oposto. `move_04`: transferência oposta. `move_05`: fechamento, pronto para voltar a `move_00` sem salto.
- `attack_00`: antecipação clara. `attack_01`: início da ação. `attack_02`: ponto de impacto legível, sem projétil, círculo, respingo ou efeito solto. `attack_03`: recuperação contida.
- `death_00`: recebe o impacto. `death_01`: estrutura começa a ceder. `death_02`: cai mais, perde o equilíbrio. `death_03`: semi-caído, silhueta inteira no quadro. `death_04`: colapso. `death_05`: pose final imóvel.
- Não espelhar imagens: a integração cuida do lado. Nada de pernas, armas ou objetos duplicados, nem trocar o lado da arma entre quadros.

## Poses específicas por alvo

### `larva_de_lu_yueh` — Larva de Lu Yueh
- Identidade fixa: Larva grande e segmentada verde-oliva, com um rosto humano pálido de olhos vermelhos na frente, fios de fumaça amarela saindo de bulbos nas costas e pernas curtas com garras.
- `idle`: parada, corpo respirando, fumaça amarela presa aos bulbos oscilando.
- `move`: ondulação do corpo segmentado para a direita, as pernas curtas alternando.
- `attack`: avança a cabeça para a direita em mordida.
- `death`: o corpo se contrai, os segmentos se espalham e a larva tomba de lado, murcha.

### `cultista_de_feng_tu` — Acólito Pestilento
- Identidade fixa: Cultista de pele doente, chapéu alto preto e vermelho coroado de sinos, véu, robe cinza rasgado com faixas vermelhas, lanternas verdes e sinos pendurados no cinto, cajado ornamentado na mão direita.
- `idle`: parado, cajado apoiado, sinos balançando levemente presos.
- `move`: passos arrastados, cajado sempre na mão direita, sinos e lanternas balançando presos.
- `attack`: ergue o cajado e aponta à direita, sem círculo mágico nem projétil.
- `death`: joelhos cedem, cajado ao lado, tomba de lado e fica imóvel.

### `estatua_do_templo` — Estátua do Templo
- Identidade fixa: Estátua viva de pedra azul com quatro braços (espada, escudo, lança e maça), armadura estrelada com rachaduras azuis luminosas, coroa e pedestal de botas.
- `idle`: parada e rígida, rachaduras azuis pulsando, braços em guarda.
- `move`: passos rígidos e pesados, quatro braços balançando pouco, armas presas.
- `attack`: golpe de espada e maça para a direita, com os outros dois braços acompanhando.
- `death`: as rachaduras apagam, as juntas cedem e a estátua desaba em bloco, inteira.

### `cultista_ghaunadaur` — Fanático de Ghaunadaur
- Identidade fixa: Cultista de manto roxo e capuz, máscara pálida com gema, cajado com um olho roxo na ponta na mão esquerda, braço direito terminado em tentáculo.
- `idle`: parado, cajado apoiado, tentáculo do braço balançando de leve.
- `move`: passos arrastados, manto ondulando, cajado sempre na mesma mão.
- `attack`: aponta o cajado e o tentáculo para a direita, sem círculo nem projétil.
- `death`: joelhos cedem, manto abre sobre o corpo, tomba de lado.

### `discipulo_pestilento` — O Discípulo Pestilento
- Identidade fixa: Versão elite do acólito com três braços conforme identidade v02 aprovada: um braço mutado superior, um braço das lanternas e um braço do cajado; chapéu alto de sinos, robe mais rasgado e corroído, pele doente e lanternas verdes brilhantes.
- `idle`: parado e curvado, cajado apoiado, brilho verde das lanternas pulsando.
- `move`: passos lentos, cajado sempre na mão direita, sinos e lanternas balançando.
- `attack`: ergue o cajado e as lanternas e as impulsiona para a direita, sem efeito solto.
- `death`: joelhos cedem, as lanternas apagam, tomba de lado.

### `lu_yueh` — Lu Yueh, Deus das Epidemias
- Identidade fixa: Deus alto de seis braços e máscara de bico de peste, coroa de espinhos, manto longo verde-escuro e vermelho com sinos pendurados; segura lanterna, sino, pergaminho e lâmina curva.
- `idle`: ereto e imponente, braços em pose, sinos e manto balançando.
- `move`: desliza em passos lentos, sinos e manto ondulando.
- `attack`: golpe de lâmina e arremesso dos sinos à direita, sem efeitos soltos.
- `death`: os braços caem, as lanternas se apagam, ele desaba de joelhos e tomba de lado.
- `special_00`–`special_05` (6 quadros): gesto ritual dos seis braços, usando somente os objetos da identidade aprovada, para a habilidade `aoe` já existente. Objetos permanecem seguros nas mesmas mãos; sem efeito solto nem nova mecânica. Sequência: recolhe braços (antecipação), inicia abertura, eleva urnas/sino, pico de braços abertos, breve sustentação, recupera a guarda.

## Critérios de rejeição imediata

- Orientação para a esquerda, corte de asa, arma, braço ou cauda, escala diferente do `idle_00`, fundo não transparente.
- Gosma, névoa, chama, fungo ou corrente translúcidos, desfocados ou soltos; partículas, círculos mágicos, projéteis ou respingos separados.
- Troca de mão da arma, membros duplicados, texto, UI, cenário, sombra no chão ou segundo personagem.
- Solidez abaixo de 0,90 (0,79 apenas para o que é translúcido por desenho: `alma_penada`, `bolha_de_slime`).

2026-10-04: pilotos I01–I06 v02 gerados e inspecionados na prancha priority-review/feng-tu_identities_v02.png. Fontes1254x1254, alfa nativo, sem cortes; solidez0,956–0,979. V01 rejeitados por halos externos (e mão duplicada no discípulo); v02 removeu halos via imagegen integrado, sem scripts de limpeza. Discípulo preserva três braços e Lu Yueh seis, conforme as referências estáticas; divergência de Lu Yueh com descrição anterior de quatro braços será submetida explicitamente ao dono. Esta nota registra candidatos, não altera intenção canônica nem registra aprovação. Ordem na prancha: linha superior Larva, Acólito, Estátua, Fanático; inferior Discípulo, Lu Yueh. Gate FILA-016 PENDING; zero ciclos e zero assets Feng Tu no runtime. Prompts/resultados feng-tu-identity-{prompts,results}-2026-10-04.json e feng-tu-identity-correction-{prompts,results}-2026-10-04.json; logs feng-tu-identity-{review-v02,alpha-v02,solidity}-2026-10-04.log.

2026-10-04: dono respondeu ‘atena continue’ após gate explícito das seis identidades v02. Aprovação registrada incluindo Lu Yueh6 braços e Discípulo3 da referência. Pedido IN_PLAN; continuar por ator a partir de Larva. Gate liberado, fontes aprovadas versão02.

2026-10-04 — Feng Tu: gate de seis identidades v02 aprovado pelo dono com “atena continue”. Larva integrada20 quadros/4 tiras: identidadeidle00v02; fontes19v01; death02/03/04/05 selecionadosv02. Recuperaçãoattack03v01 conferida pelo caminho exato, boca fechada. Alturas da morte selecionada1093/1041/877/848/713/709, sem cortes; solidez das tiras0,975–0,981. Corpo150/base356; runtime na escala real0,7 passou em ancoragem/ações/limpeza. Captura priority-review/larva_de_lu_yueh_runtime.png inspecionada em Feng Tu (IDruntimefeng_tu, candidatosfeng-tu). Alpha/RGB preservados por nearest packing; nenhuma limpeza por scripts. PNGs4 em assets/animations/enemies/larva_de_lu_yueh, manifesto138 hashes conferidos. Installer aceita IDsFeng Tu; contratoLu Yueh26quadros inclui special. Prompts/resultados e correções em feng-tu-larva-*.json; QA feng-tu-larva-qa-notes-2026-10-04.json. Acólito é próximo ator,19quadros; nenhuma alteração de combate/dependências, nenhum commit/push. BugsP1 abertos2 (025,027), playtest humano pendente. Aprovações visuais duráveis no registro canônico020, sem afirmar admissão de outros atores. Estado central PLAN-056 preservado.

2026-10-04 — Acólito integrado20quadros/4tiras; identidadeidle00v02,19fontesv01,death04/05v02 corrigem retorno indevido à postura de pé. Fontes sem cortes, alfa nativo preservado, tiras solidez0,956–0,965, corpo119/base356. Runtime real e fila passaram (0falhas); captura Feng Tu cultista_de_feng_tu_runtime.png revisada. Manifesto142assets. Estátua19quadros em geração, respeitando quatro braços e armas fixas por mão. Build142 em validação; sem commit/push. Estado central PLAN-056 preservado.



2026-10-04 — Estátua admitida20quadros/4tiras. Identidadeidle00v02;19fontesv01,death04v03/death05v02 selecionados. Death04v01 repete intermediária,death05v01 reacende rachaduras;death04v02 rejeita fusão lança/maça e mão do escudo oculta. Correçãov03 mantém quatro mãos visíveis e armas separadas, luzes apagadas/olhos fechados na pose deitada. Fonte sem cortes;tirassolidez0,955–0,972;corpo152/base356. Runtime real/queue0, captura Feng Tu estatua_do_templo_runtime.png revisada. Manifesto146assets, Feng Tu60quadros/12tiras. Fanático em geração; sem commit/push. Estado central PLAN-056 preservado.



2026-10-04 — Fanático admitido20quadros/4tiras:idle00v02 e19fontesv01,death05v02 selecionado (v01 levantava cajado/rotacionava corpo após death04). Queda termina com staff horizontal e olhos/adornos darkpurple;altura1104/1095/1032/864/505/497. Todas fontes sem cortes,alfa nativo;solidez0,961–0,972,corpo153/base356. Runtime real/queue0;captura cultista_ghaunadaur_runtime.png revisada. Manifesto150assets,Feng Tu80quadros/16tiras. Discípulo18quadros em geração e death05 após revisão death04. Sem commit/push;centralPLAN056 preservado.



2026-10-04 — Detalhamento operacional do special de Lu Yueh antes da geração: lacuna textual preenchida com gesto ritual dos seis braços e props da identidade já aprovada, vinculado somente ao aoe existente (data/enemies.json), sem nova mecânica/lore/efeito solto. Cabeçalho I06 reconciliado para seis braços conforme aprovação canônica020; descrição histórica de quatro permanece nas notas datadas.


2026-10-04 — Discípulo admitido20quadros/4tiras: identidadeidle00v02 e19fontesv01, death05 derivado de death04 após revisão. Três braços preservados; morte alturas1197/1161/1079/977/585/582, todos20semcortes, solidez0,962–0,966; corpo171/base356. Runtime real/queue0; captura discipulo_pestilento_runtime.png revisada. Manifesto154assets, Feng Tu100quadros/20tiras. Lu Yueh24quadros em geração, death05 após inspeção; seis braços eprops mesmos braços aprovados. Sem commit/push; centralPLAN056 preservado.

2026-10-04 — Feng Tu concluído localmente:6atores/126quadros/25tiras;manifesto159assets. Lu Yueh26quadros/5tiras:identityidle00v02,25fontesv01;special02/03/04v02 reforçam ritual,death04v03 mostra seis mãos resting e death05v04 selecionado (v01corte coroa,v02/v03halos rejeitados). Alfa nativo preservado,26semcortes,solidez0,953–0,965;corpo145/base356. Death1141/1060/1079/1051/487/478: aumento19 em02 vem coroa/urnas,corpo passa crouch→kneeling;03fall→04lying com seisbraços baixos. Runtime real1,8 escala/ações/limpeza0;queue0;captura lu_yueh_runtime.png revisada. Habilidadeaoe existente toca special(ui/run.gd). Buildcompleta em validação,próximo gatecincoidentidades Shendilavri. Sem commit/push;centralPLAN056 preservado.
