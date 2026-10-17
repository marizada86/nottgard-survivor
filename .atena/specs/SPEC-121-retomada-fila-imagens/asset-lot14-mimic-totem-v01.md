# ASSET-LOT14/v01 — Mímico e Turíbulo de Sangue

DRAFT, origin planned, implementation_preceded_spec false. Pedido2026-10-17: “atena, aprovado, proximo”. Aceite anterior refere-se às26revisões LOT13; este novo escopo é PLAN_CHANGE_REQUEST, proposto para aprovação antes de produzir. Preferência per-plan e revisão em lote grande preservadas. Não executar enquanto approval_status PENDING_SCOPE_APPROVAL.

## Autoridade, evidência e necessidade

[PLAN-041](../../vault/drafts/PLAN-041-animacao-padrao-zumbi-para-inimigos-e-interacoes-2026-09-29.md), [SPEC-134](../SPEC-134-bau-mimico-unico-e-pausa-ao-pegar-item.md), dados atuais `data/enemies.json`, renderer `ui/enemy_view.gd`, `core/battle.gd` e `core/boss_mechanics.gd` consultados. Baselines visuais locais inspecionadas: `assets/enemies/mimico.png` e `assets/enemies/totem_de_chefe.png`; [revisões por hash](../../generated/asset-lot14-2026-10-17/references.json). São referências implementadas, sem atribuir novo aceite ou promover CANON.

Mímico tem speed1,6 e mordida na nota existente; nasce de baú e deixa baú seguro (SPEC-134/BUG-030). Turíbulo tem speed0 e flags inerte/totem; mecânica existente pode proteger ou curar chefe conforme configuração. Não desenhar escudo/raios de cura nem alterar parâmetros. Mímico/totem não encontrados no bloco ANIMATED, nos diretórios nominais de animação consultados ou nos manifestos LOT02..13. Consulta delimitada, não prova de ausência de arquivos renomeados. LOT13 cobriu Manifestação de Juiblex e permanece separada.

## Bíblia visual e identidade DRAFT v01

Mímico: baú de madeira quase preta, ferragens bronze envelhecido, fechadura frontal, fendas roxas, tampa como mandíbula com dentes irregulares amarelados, língua roxa espessa, olhos âmbar existentes e quatro patas curtas com garras. Vista elevada3/4 para direita, luz superior esquerda, pixel art detalhada de fantasia sombria. Preservar desenho/construção, número de patas, mandíbula, língua e ferragens; não adicionar membros, pupilas extras, armas, sangue, vítima ou baú separado. Caminhada alterna pares de patas já existentes com corpo na mesma posição do canvas; ataque abre e fecha mandíbula, extensão curta da língua, sem alvo/projétil. Morte colapsa o corpo de baú e recolhe língua, termina inerte, sem transformar em recompensa (o jogo gera isso separadamente).

Turíbulo: suporte quadrado de madeira escura com ferragens e bandeja metálica baixa circular, três velas de alturas distintas, cera marfim e chamas âmbar com extremidades roxas. Não é estátua sanguínea; nome não autoriza acrescentar sangue ou lore. Repouso anima só chama e pequena cera/luz, estrutura rígida. Ruptura cede velas/suporte com fragmentos contidos, chamas extinguem, termina restos inertes no mesmo apoio. Sem explosão, aura, chão, cenário ou magia destacada. Identidade pessoal N/A por ser objeto; identidade construtiva/material é aplicável e está descrita.

Contexto textual de combate em mapa isométrico existente basta. Não é preciso definir posição no mapa. As duas referências fixam câmera, materiais e identidade; âncora inicial por entidade fixa escala/base para os demais quadros. Motivos opacos, transparência no vazio, margem solicitada≥12%, canvas solicitado1024quadrado, medir nativo real. Não reinterpretar baixa opacidade incidental como material fantasma.

## Escopo e revisão conjunta

| Sequência | IDs | Poses | Fases | Preview |
|---|---|---:|---|---|
| Mímico idle | MI00..03 |4|repouso→respira/mandíbula mínima→relaxa→retorno|loop|
| Mímico move | MM00..05 |6|contato patas→peso→passada→contato oposto→peso→retorno|loop|
| Mímico attack | MA00..03 |4|antecipa→abre/avança mandíbula→mordida→recolhe|uma vez, recuperação|
| Mímico death | MD00..05 |6|cede→abaixa→patas dobram→corpo colapsa→assenta→inerte|uma vez, último|
| Turíbulo idle | TI00..03 |4|chamas oscilam, estrutura fixa→retorno|loop|
| Turíbulo death | TD00..04 |5|cede→rompe→cai contido→apaga→restos inertes|uma vez, último|

29PNGs individuais,29desenhos, seis entradas de revisão. PerfilA20 para Mímico; Turíbulo estático recebe idle4 + ruptura5 (adaptação objeto perfilD, sem move/attack/special). Proposta de exceção limitada ao gate intermediário idle00 do PLAN-041: examinar os seis estados juntos a partir das identidades estáticas implementadas. MI00/TI00 serão âncoras geométricas DRAFT, não aceite humano presumido. Aprovação deste escopo deve abranger esta revisão conjunta; não muda gates das demais frentes.

## Etapas e recuperação

1. S-001 prontidão: referências/contexto/bíblia/escopo/hashes preparados. BLOCKING único: aprovação do novo lote, incluindo orçamento e revisão conjunta. Produção especialista imagegen só após resolver.
2. S-002 produção: built-in imagegen, um PNG por pose, máximo3tentativas por arquivo e87chamadas no total. Preservar tentativas/prompts/origens/revisões, cópias nativas byte a byte em `.atena/generated/art-candidates/asset-lot14/`; fontes não fabricadas por recorte, translação ou cópia de poses.
3. S-003 QA: dimensões/alfa/opacidade/banda externa4px/margens e geometria; identidade, quatro patas/mandíbula/língua do Mímico, três velas/estrutura do Turíbulo; leitura48/80/128, contatos integrais, continuidade de estados e retornos. Medir apoio sem confundir patas/fragmentos com pivô semântico. Queda deliberada não autoriza deriva. Defeito material após limite retém quadro/estado. Não regravar nativos ou mascarar correções. Rigidez TI deve ser conferida além de bbox.
4. S-004 entrega: galeria conjunta em `.atena/generated/asset-lot14-2026-10-17/`, seis players com pausa/replay/FPS/repeat/scrub, manifestos/hash/refs/origens/prompts/evidência/handoff local para Claude. Checar caminhos, loops4/6 e holds4/5/6 por controles offline; distinguir simulação DOM de render real. Parar no aceite visual humano, inclusive parcial por estado/revisão.

RESOLVABLE na produção: escala/base, anatomia/construção estável, opacidade, margens e legibilidade. DEFERRED: limpeza final/pivô/packing/temporização/redução/consumer, runtime, CANON e playtest humano. Aprovação visual não comprova admissão técnica; usuário avaliará ações/continuidade na galeria, preparação e implementação com Claude em outro escopo. Retenções anteriores permanecem.

## Impacto e limites

Novo lote não altera LOT13 aceito, PLAN-103 ou outros planos. Retorno a PLAN-103 registrado; não substitui milestones. Sem alterações em código/dados/assets oficiais, lore, mecânicas, arquitetura ou dependências. Sem commit, push, merge, exportação, publicação ou mensagem a outro chat. Recuperação por fontes versionadas, hashes de referência e seleção explícita. Não há pendência técnica textual BLOCKING adicional conhecida; aprovação do escopo continua BLOCKING. Modo per-plan já escolhido, sem repetir escolha de nível; aguardar somente autorização deste plano.
