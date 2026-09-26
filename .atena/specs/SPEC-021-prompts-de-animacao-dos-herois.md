# SPEC-021 — Prompts de animação dos heróis jogáveis

Status: **concluída e reconciliada em 2026-09-23; somente redação de prompts, sem geração de imagens.**

## Objetivo

Completar o catálogo de prompts de asset para os dez heróis jogáveis, mantendo a
identidade já aprovada entre retrato, sprite de run e animações. A entrega é um
pacote de prompts e seu manifesto; não produz, processa nem integra PNGs.

## Escopo

O catálogo cobre os IDs declarados em `data/heroes.json`:

| Herói | Âncora de identidade | Arma / habilidade que a animação deve preservar |
|---|---|---|
| `durvall` | drow de cabelo branco, armadura negra e espada azul | Espada Sombria / Ruptura Sombria |
| `brook` | jovem anão, orelhas curtas e arredondadas (nunca élficas), aço e couro, barba castanha | Sentença de Lliira / Guarda de Lliira |
| `maelor` | devoto viajante de Sendrinah | Raio de Luz / Comunhão |
| `sylas` | tiefling furtivo de Mask, sem asas | Raio Enfraquecedor / Passo pelas Sombras |
| `kayron` | aasimar de cabelo branco, sem asas anatômicas | Descarga Estelar / Sobrecarga Mística |
| `korrak` | goliath pesado com Machado de Xar'gath | Machado de Xar'gath / Impacto de Xar'gath |
| `leoric` | gnomo adulto e astrônomo | Sopro de Estrela / Constelação |
| `nyrelia` | sacerdotisa mascarada, espécie indeterminada | Dominar Pessoa / Dominação |
| `zynara` | elfa estudiosa com ampulheta | Ampulheta / Suspensão Temporal |
| `bromnor` | anão idoso, Martelo da Glória | Martelo da Glória / Concórdia |

Para cada herói, o manifesto deve apontar para os prompts já existentes de
retrato e sprite estático (`ART-PROMPTS-002` e `ART-PROMPTS-011`) e cobrir estas
doze sequências de animação:

1. `idle` — 4 quadros;
2. `move_n`, `move_ne`, `move_e`, `move_se`, `move_s`, `move_sw`, `move_w` e
   `move_nw` — 6 quadros cada;
3. `attack` — 4 quadros;
4. `active` — 6 quadros;
5. `death` — 6 quadros.

As direções são sempre visuais, na tela: `move_sw` é baixo e esquerda. Cada
quadro usa célula `256×384`, corpo inteiro, linha de base comum, câmera
três-quartos isométrica, iluminação superior esquerda e alfa real. A fonte de
uma sequência de seis quadros é uma grade 3×2 limpa; a normalização posterior
para tira horizontal `1536×384` não faz parte desta spec.

`ART-PROMPTS-014` e `ART-PROMPTS-015` continuam sendo as fontes de Durvall,
sujeitas a auditoria de cobertura. O novo pacote deve redigir somente as 108
sequências ainda ausentes: doze para cada um dos outros nove heróis. Caso a
auditoria revele lacuna real nas sequências de Durvall, ela será registrada em
vez de ser preenchida por inferência.

## Entregáveis

- `ART-PROMPTS-016-animacoes-dos-herois.md`, com um bloco comum e 108 chamadas
  autocontidas, nomeadas `HERO-<id>-<sequencia>`.
- `HERO-ANIMATION-PROMPT-MANIFEST-001.json`, que relaciona para cada sequência:
  id do herói, sequência, quantidade de quadros, caminho candidato, caminho
  final pretendido, prompt, fontes e estado de revisão.
- Uma evidência de auditoria com a contagem 10 heróis × 12 sequências, links de
  origem, conflitos encontrados e a conclusão de que nenhuma imagem foi
  gerada nesta etapa.

## Não objetivos

- Chamar ImageGen, enviar referências locais, gerar ou substituir imagens.
- Alterar lore, espécie, arma, habilidade, ID, controles, balanceamento ou
  cenas do jogo.
- Criar animações direcionais para ataque, habilidade ou morte além das
  sequências únicas que o runtime atual consome.
- Reescrever os retratos, sprites estáticos ou prompts de Durvall já aprovados
  sem uma divergência concreta e registrada.

## Fontes e precedência

1. `data/heroes.json`, `data/weapons.json` e `data/abilities.json` para IDs,
   função de jogo, arma e habilidade;
2. `ART-PROMPTS-002`, `011`, `014` e `015` para identidade já decidida;
3. `PLAN-001` e o vault canônico para fatos de lore;
4. referências locais já catalogadas apenas como âncora de identidade, nunca
   como licença para inventar detalhes.

Conflitos que mudem espécie, máscara de Nyrelia, asas de Kayron/Sylas, arma,
símbolo ou função de jogo bloqueiam apenas o prompt afetado e pedem decisão do
dono.

## Critérios de aceite

1. Os dez IDs de `data/heroes.json` aparecem uma vez no manifesto.
2. Cada ID possui os doze estados nomeados, a contagem correta de quadros e os
   caminhos `assets/animations/heroes/<id>/<sequencia>.png`.
3. Há exatamente 108 novas chamadas de prompt e as doze de Durvall apontam para
   seus prompts existentes ou para uma lacuna explicitamente registrada.
4. Todo prompt é autocontido: descreve identidade, estado, câmera, base,
   iluminação, transparência, ação legível e restrições contra texto, cenário,
   watermark, membros/armas duplicados e redesign.
5. `move_sw` e as demais direções nomeiam explicitamente a direção visual na
   tela, jamais a coordenada de chão isométrica.
6. Nenhum prompt altera fatos canônicos ou solicita envio remoto de referência.
7. A auditoria confere IDs, contagens, links, caminhos e divergências antes de
   considerar o pacote pronto para uma eventual geração.

## Plano de voo

1. Congelar a lista de heróis e extrair, para cada um, os traços imutáveis,
   arma e habilidade dos dados atuais.
2. Auditar os prompts existentes e registrar a matriz de reuso de retrato,
   sprite estático e animações de Durvall.
3. Redigir o bloco visual comum e as doze sequências de cada herói sem lacuna,
   começando por identidade e depois por movimento, ataque, habilidade e morte.
4. Construir o manifesto e validar programaticamente as 120 sequências totais,
   108 novas chamadas e os caminhos finais pretendidos.
5. Fazer revisão independente de lore, direções e anti-requisitos; registrar
   a evidência e reconciliar este documento.

## Gate de geração de imagens

A geração de imagens, transmissão de referências locais, processamento de
PNGs, integração no jogo e publicação continuam exigindo aprovação explícita
por lote.

## Reconciliação

- `ART-PROMPTS-016` contém as 108 chamadas novas: doze sequências para cada um
  dos nove heróis sem animação anterior.
- `HERO-ANIMATION-PROMPT-MANIFEST-001.json` registra os dez IDs, as 120
  sequências e o reuso das doze sequências de Durvall.
- `tests/test_hero_animation_prompt_manifest.gd` audita contagem, cobertura e
  IDs antes de qualquer geração.
- Evidência: `../evidence/EVID-012-prompts-de-animacao-e-movimento.md`.

## Emenda global aprovada — 2026-09-24

Esta emenda substitui, para toda geração futura, a exigência de oito folhas de movimento. O estado lógico continua com oito direções, mas a fonte de arte passa a ter somente `move_n`, `move_ne`, `move_e`, `move_se` e `move_s`.
O runtime espelha horizontalmente `move_ne` para `move_nw`, `move_e` para `move_w` e `move_se` para `move_sw`.

Logo, o contrato de geração por herói é de nove sequências-fonte: cinco de movimento, `idle`, `attack`, `active` e `death`.
As folhas inversas já geradas permanecem como legado e não devem ser removidas, mas nenhum lote novo deve solicitá-las.
O manifesto é a fonte operacional desta regra.
