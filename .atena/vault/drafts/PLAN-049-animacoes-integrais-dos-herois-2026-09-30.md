---
id: "PLAN-049"
title: "Animações integrais e efeitos dos heróis"
status: "aprovado; SPEC-105 concluída; SPEC-106 aprovada e pausada por falta de fluxo local 2D adequado"
created: "2026-09-30"
relations:
  - "[[PLAN-001-nottgard-survivors]]"
  - "[[SPEC-021-prompts-de-animacao-dos-herois]]"
  - "[[SPEC-101-polimento-proporcoes-movimento-herois]]"
  - "[[SPEC-102-piloto-runtime-escala-direcional-durvall]]"
  - "[[SPEC-103-piloto-runtime-escala-direcional-brook]]"
  - "[[ANIMATION-PRODUCTION-MANIFEST-002]]"
  - "[[HERO-ANIMATION-PROMPT-MANIFEST-001]]"
  - "[[EVID-129-auditoria-piloto-movimento-herois-2026-09-30]]"
  - "[[EVID-132-piloto-runtime-escala-direcional-durvall-2026-09-30]]"
  - "[[SPEC-105-inventario-animacoes-e-efeitos-herois]]"
  - "[[EVID-133-inventario-visual-herois-2026-09-30]]"
  - "[[HERO-ANIMATION-INVENTORY-001]]"
  - "[[SPEC-106-pacote-integral-animacoes-durvall]]"
---

# PLAN-049 — Animações integrais e efeitos dos heróis

## Pedido e objetivo

Ampliar o trabalho de polimento para produzir e integrar um conjunto visual
completo, coerente e revisado para cada um dos dez heróis jogáveis atuais:
Durvall, Brook, Maelor, Sylas, Kayron, Korrak, Leoric, Nyrelia, Zynara e
Bromnor. O programa cobre movimento, ações, ataques e os efeitos visuais
associados às ações de cada personagem, além de identificar estados visuais que
ainda estejam faltando.

Durvall é o primeiro caso, pois a revisão recente confirmou que o movimento
lateral ainda parece grande demais e que a mudança para ataque também pode
produzir um salto visual. A tentativa de corrigir isso apenas com escala de
runtime foi revertida e não deve ser propagada ao elenco.

## Estado atual e aprendizado aplicado

- O runtime usa cinco fontes de movimento (`n`, `ne`, `e`, `se`, `s`) e espelha
  três delas para cobrir as oito direções lógicas. A arte não oferece oito
  animações independentes de movimento por herói.
- Atualmente o runtime carrega `idle`, movimento, `attack`, `active` e `death`.
  Ataque e habilidade usam uma folha por ação; a orientação e a relação dessas
  folhas com mira, arma e efeitos devem ser auditadas antes de definir variantes.
- A auditoria de EVID-129 encontra variação importante de escala aparente em
  algumas folhas. A caixa alfa inteira inclui corpo, arma e efeitos; não pode
  ser usada sozinha para normalizar personagens.
- A tentativa reprovada de Durvall em EVID-132 normalizou altura com escala
  uniforme, alargou a pose lateral e perdeu continuidade ao iniciar ataque.
  As capturas dessa tentativa são históricas; o perfil foi revertido.
- O manifesto atual registra dez heróis e nove fontes de sequência por herói
  sob o contrato antigo. Ele é referência de inventário, não uma promessa de
  que todas as folhas ou efeitos estejam corretos ou completos.

## Escopo visual proposto

Para cada herói, o inventário e as entregas cobrirão:

1. **Animações do corpo:** idle; movimento nas oito direções; ataque básico
   compatível com a arma inicial e com as armas equipáveis aplicáveis; habilidade
   ativa/classe; morte; e reações visuais a dano ou interrupção quando o jogo
   tiver esses eventos. Incluir qualquer outro estado animado já usado pelo
   runtime que a auditoria encontrar.
2. **Orientação das ações:** ataque e habilidade devem acompanhar a direção de
   mira/ação. A proposta é criar fontes direcionais próprias quando a pose muda
   materialmente; espelhamento só será aceito quando a simetria não inverter
   detalhes de identidade, arma, gesto ou efeito. O inventário define o número
   final de variantes por ação e herói.
3. **Efeitos próprios:** antecipação/ativação, trilha ou emissão da arma,
   projétil, impacto e área persistente quando existirem para aquele ataque ou
   habilidade. Cada efeito será ligado ao personagem/ação correspondente,
   alinhado ao quadro de impacto e revisado para não ocultar o herói ou o alvo.
   Efeitos visualmente compartilháveis serão identificados para reuso, não
   duplicados por padrão.
4. **Coerência do pacote:** manter identidade, equipamento, proporção, linha de
   chão, ancoragem e leitura do personagem entre animações, efeitos, sprite de
   gameplay e retrato/seleção existentes. O retrato só será substituído se uma
   SPEC própria aprovar essa alteração.

O conjunto prioriza os estados que o jogo já executa. A auditoria também
registrará lacunas que exigiriam novos estados ou eventos de gameplay; criá-los
depende de SPEC e aprovação próprios, sem alterar silenciosamente combate,
habilidades ou regras.

## Elenco e ordem de trabalho

| Ordem proposta | Herói | Razão inicial |
|---:|---|---|
| 1 | Durvall | Sintoma visual ainda reportado; valida proporção e transição movimento–ataque. |
| 2 | Brook | Segundo maior caso de variação aparente na auditoria. |
| 3 | Maelor | Próximo caso de maior variação medida. |
| 4 | Nyrelia | Revisar escala e ancoragem em conjunto com a identidade já integrada. |
| 5 | Bromnor | Variação de base e porte merece conferência quadro a quadro. |
| 6 | Leoric | Validar continuidade de escala e silhueta nas ações. |
| 7 | Kayron | Conferir escala, base e consistência de arma/efeitos. |
| 8 | Sylas | Conferir escala e leitura da habilidade/efeitos. |
| 9 | Korrak | Conferir base e compatibilidade com arma. |
| 10 | Zynara | Usar como controle comparativo após validar o método nos casos discrepantes. |

A ordem é uma proposta baseada na auditoria de movimento; a fase de inventário
pode ajustá-la se revelar dependências ou prioridades diferentes. Cada pacote é
revisado por herói e não avança automaticamente por ter passado o anterior.

## Plano de voo

1. **Inventário sem alterações.** Conferir os dez heróis, folhas e estados do
   runtime, armas realmente equipáveis, habilidades, mira/facing e todos os
   efeitos disparados por seus ataques. Produzir uma matriz por herói com
   estado, direção, frames, fonte, dono do efeito, dependências compartilhadas,
   lacunas e asset instalado. Comparar o corpo separadamente de arma/VFX sempre
   que a fonte permitir; registrar largura, altura, pés/linha de chão e recortes
   por quadro.
2. **Contrato visual e proposta direcional.** Especificar grade, cadência,
   margens, escala aparente, ancoragem, tolerâncias, identidade e critérios de
   aprovação em escala real. Apresentar explicitamente o impacto da proposta de
   substituir cinco fontes mais espelhamento por oito fontes independentes de
   movimento e variantes direcionais para ações orientadas. Essa mudança de
   regra canônica só entra em vigor após aprovação expressa do dono; até lá, o
   contrato aprovado da SPEC-021 continua valendo.
3. **Pacote-piloto completo de Durvall.** Preparar uma SPEC limitada para todas
   as animações e VFX de Durvall identificados no inventário. Gerar candidatos
   isolados, aprovar identidade/folhas e efeitos por etapas, integrar apenas
   candidatos explicitamente aprovados e validar a continuidade entre caminhar,
   atacar, usar habilidade e retornar a idle. Não aplicar perfil de escala
   altura-apenas nem sobrescrever os PNGs atuais durante a preparação.
4. **Revisão do método.** Comparar Durvall em oito direções, todos os quadros,
   ataques/efeitos, escala de jogo e contexto com inimigos/props. Se corpo,
   arma ou VFX não puderem ser separados por escala, corrigir a arte/quadros ou
   sua ancoragem; registrar exceções por herói em vez de forçar uma fórmula
   global. A revisão humana aprova ou solicita regeneração antes do lote
   seguinte.
5. **Produção do restante do elenco.** Preparar uma SPEC por herói, ou por
   lote pequeno quando os assets forem independentes, seguindo a ordem acima.
   Cada SPEC declara estados, variantes por direção, efeitos, quadros, caminhos,
   lotes candidatos, aprovação visual e recuperação. Aprovação de um herói não
   autoriza gerar, admitir ou sobrescrever assets de outro.
6. **Integração controlada.** Para cada pacote aprovado, integrar os sprites e
   efeitos nos caminhos previstos, configurar direção/facing, âncoras e
   sincronização dos efeitos com as ações. Preservar gameplay, dados de
   habilidades, hitboxes, cooldowns, velocidade de movimento e balanceamento.
   Mudança necessária fora desses limites vira outra SPEC.
7. **QA por herói e regressão do elenco.** Revisar todos os quadros e transições
   em tamanho de jogo e ampliado, em oito direções e em cena comparativa. Cobrir
   idle→movimento, movimento→ataque, ataque→idle, active→idle, dano e morte
   quando aplicável. Conferir cortes, alternância de tamanho, contato com o
   chão, arma, efeito, momento de impacto, legibilidade e ausência de salto de
   escala. Rodar testes de assets, suíte do projeto e smoke após cada
   integração.
8. **Reconciliação.** Registrar decisão, candidatos aceitos/rejeitados,
   versões integradas, testes, capturas e desvios em evidência `.atena/`;
   reconciliar o manifesto sem confundir candidato com oficial. Não publicar,
   enviar ou mesclar alterações.

## Critérios de aceite do programa

1. A matriz confirma cobertura e estado de cada animação e efeito para os dez
   heróis; todo item ausente tem solução aprovada, reuso identificado ou exceção
   justificada pelo dono.
2. Cada pacote aceito preserva identidade e consistência de escala, ancoragem,
   silhueta, arma e efeitos em todos os quadros e orientações planejadas.
3. As transições de movimento para ataque/habilidade e de volta não apresentam
   salto de escala, facing incorreto, quadro cortado, base flutuante nem efeito
   fora de sincronia.
4. A leitura em tamanho real mostra o personagem e o impacto sem poluir ou
   ocultar o combate; ampliações servem apenas à inspeção de detalhe.
5. Testes, smoke e evidência passam para cada integração; exceções e avisos do
   ambiente ficam registrados.
6. Nenhum asset oficial muda antes da aprovação explícita de sua SPEC/pacote; a
   qualidade visual não é decidida apenas por uma métrica de caixa alfa.
7. Os dez heróis e todos os efeitos próprios previstos estão reconciliados no
   manifesto e a regra direcional só é alterada depois de aprovação canônica.

## Não objetivos e gates

- Não fazer novas mudanças canônicas além do contrato de animação aprovado na
  seção 26 de PLAN-001.
- Não alterar mecânicas, hitboxes, dano, mira, cooldown, velocidade, equilíbrio,
  equipamentos disponíveis ou regras de habilidade.
- Não animar inimigos/NPCs não jogáveis, cenários, props, interface genérica ou
  VFX globais não pertencentes a um ataque/efeito de herói.
- Não produzir áudio/voz, retratos novos, cutscenes, skins ou novas habilidades
  como parte automática do programa; lacunas podem ser propostas à parte.
- Não sobrescrever PNG oficial, transferir referência a serviço remoto, usar
  nova dependência, publicar, fazer push ou mesclar sem aprovação aplicável.

O inventário e qualquer geração, processamento ou integração ficam atrás de
SPECs aprovadas individualmente, conforme `.atena/add.yaml` (`execution_approval:
per-spec`). A aprovação deste plano aprova D-M1 a D-M4 e a mudança canônica
registrada na seção 26 de PLAN-001, mas não aprova a execução de uma SPEC nem a
admissão de candidatos em `assets/`.

## Decisões do dono

| ID | Decisão | Estado |
|---|---|---|
| D-M1 | Programa para os dez heróis, começando por Durvall e com gate de revisão por personagem | Aprovado em 2026-09-30 |
| D-M2 | Oito fontes independentes de movimento por herói, em lugar de cinco fontes mais três espelhamentos | Aprovado em 2026-09-30; registrado em PLAN-001 §26 |
| D-M3 | Ataque/habilidade acompanham facing; variantes próprias quando pose/arma/efeito não funcionarem espelhados | Aprovado em 2026-09-30; inventário fixa o número antes de gerar |
| D-M4 | Cada herói/pacote de VFX tem SPEC e revisão antes de admitir assets oficiais | Aprovado em 2026-09-30 |

## Aprovação ADD

O dono aprovou este plano e D-M1 a D-M4 em 2026-09-30. D-M2 foi reconciliada
como cânone na seção 26 de PLAN-001. A aprovação não inicia produção em massa:
o voo de cada SPEC continua exigindo aprovação explícita, começando pelo
inventário da SPEC-105. Candidatos permanecem isolados; integração em `assets/`
exige a aprovação rastreável prevista na SPEC-044.

## Recuperação e preservação

Antes de cada SPEC, registrar exatamente os caminhos existentes e alterações
locais. Candidatos ficam em `.atena/generated/` e nunca substituem oficiais. Se
QA reprovar, retirar somente as mudanças da SPEC em execução e restaurar seu
comportamento anterior; preservar alterações preexistentes e arte já aprovada.

## Evidência futura

Cada fase registra matriz, decisões e QA em `.atena/evidence/`, usando o próximo
ID livre no momento da criação. Não reservar IDs nem declarar produção concluída
com base apenas na aprovação deste plano.

## Aprovação reconciliada — 2026-09-30

O dono aprovou D-M1, D-M2, D-M3 e D-M4. O contrato direcional de oito fontes e
as regras de facing/efeitos foram registrados como cânone em PLAN-001, seção
26. O voo de inventário da [[SPEC-105-inventario-animacoes-e-efeitos-herois]]
foi aprovado e concluído sem alterações em assets, código, dados ou manifests;
seus resultados estão em [[EVID-133-inventario-visual-herois-2026-09-30]] e
[[HERO-ANIMATION-INVENTORY-001]]. A SPEC própria do pacote completo de Durvall
está registrada em [[SPEC-106-pacote-integral-animacoes-durvall]] e foi
aprovada pelo dono em 2026-09-30. O CLI oficial `game-dev` v1.0.2 foi compilado
e verificado em pasta temporária após o pacote npm retornar E404; suas operações
disponíveis cobrem assets 3D/GLB, não sprites 2D ou efeitos de ataque. Nenhuma
referência local foi enviada a serviço remoto. Retomar somente após definir e
aprovar um fluxo adequado de produção 2D, respeitando a autorização explícita
necessária para transferir referências.
