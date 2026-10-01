---
id: "SPEC-101"
title: "Auditoria e piloto de proporções no movimento dos heróis"
status: "SPEC-106 de Durvall aprovada; produção pausada por falta de fluxo local 2D adequado"
created: "2026-09-30"
relations:
  - "[[SPEC-021-prompts-de-animacao-dos-herois]]"
  - "[[SPEC-048-admissao-das-animacoes-regeneradas-de-nyrelia]]"
  - "[[ANIMATION-PRODUCTION-MANIFEST-002]]"
  - "[[EVID-129-auditoria-piloto-movimento-herois-2026-09-30]]"
  - "[[PLAN-049-animacoes-integrais-dos-herois-2026-09-30]]"
  - "[[SPEC-105-inventario-animacoes-e-efeitos-herois]]"
  - "[[EVID-133-inventario-visual-herois-2026-09-30]]"
  - "[[HERO-ANIMATION-INVENTORY-001]]"
---

# SPEC-101 — Auditoria e piloto de proporções no movimento dos heróis

## Intenção

Medir diferenças aparentes de tamanho e contato com o chão nas animações dos
heróis. Fazer um piloto reversível em um personagem antes de propor qualquer
alteração nos PNGs oficiais ou no renderizador.

## Descoberta

- `ui/hero_view.gd` carrega cinco folhas-fonte de caminhada — norte, nordeste,
  leste, sudeste e sul — e aplica a mesma escala de exibição aos quadros.
- Noroeste, oeste e sudoeste são derivados por espelhamento horizontal,
  conforme o contrato aprovado na SPEC-021. O runtime cobre as oito direções;
  três delas não usam folhas de arte independentes, mesmo quando existem
  arquivos legados para alguns heróis.
- Os dez heróis têm `idle` e as cinco folhas-fonte. Cada folha de movimento
  usa seis células de 256×384, mas a caixa visível de alfa dentro da célula
  varia bastante por personagem, direção e pose.
- A auditoria usa o contorno total visível, incluindo arma e efeitos. É uma
  medida reprodutível de escala aparente, não uma segmentação perfeita do
  corpo.
- Durvall foi selecionado como piloto por apresentar a maior diferença entre
  medianas direcionais no elenco: 368 px em `move_n` contra 226 px em
  `move_e` (razão 1,63). Sua altura mediana em `idle` é 293 px.

## Escopo desta SPEC

- Medir `idle` e as cinco direções-fonte dos dez heróis, quadro a quadro,
  registrando largura, altura, linha inferior e contato com as bordas da célula.
- Gerar uma comparação visual local de Durvall com o runtime atual e uma
  hipótese de escala por direção calculada pela altura mediana de `idle`.
- Manter a comparação e as ferramentas em `.atena/`; não substituir arte oficial.

## Não objetivos

- Alterar PNGs oficiais, `ui/hero_view.gd`, cenas de jogo ou regras de
  movimento nesta etapa.
- Gerar arte nova ou transferir referências a um serviço remoto.
- Redesenhar as oito direções para todos os heróis. O contrato de cinco fontes
  e três espelhamentos da SPEC-021 continua vigente.
- Mudar cânone, identidade, gameplay, dependências, permissões ou publicar
  alterações.

## Critérios de aceite desta etapa

1. O relatório cobre dez heróis, um `idle` e cinco movimentos-fonte por herói;
   as folhas encontradas têm seis quadros de 256×384.
2. A auditoria registra mediana e faixa de altura visível, mediana da largura,
   base visível e quadros próximos às bordas da célula.
3. O piloto mostra as seis poses selecionadas de Durvall no tamanho atual e
   com escala hipotética por direção, alinhadas a uma linha de chão comum.
4. A evidência declara as limitações da caixa de alfa e não apresenta a prancha
   ampliada como captura de gameplay ou como correção integrada.
5. Nenhum PNG oficial ou estado de gameplay é modificado.

## Critérios propostos para uma futura SPEC de elenco

Usar como ponto de partida, sujeito a revisão visual em escala real: manter a
altura mediana aparente das cinco direções-fonte dentro de ±8% da referência do
herói e o contato mediano dos pés dentro de 2 px na escala de jogo. Confirmar
identidade, silhueta, arma/efeitos, legibilidade, enquadramento e sobreposição
com o cenário antes de aceitar cada personagem. A caixa alfa pode selecionar
casos para revisão, mas não substitui a inspeção do corpo.

## Plano de voo executado

1. Conferir o contrato do runtime e o manifesto de produção de animações.
2. Medir as folhas de todos os heróis com `tools/audit_hero_motion.gd`.
3. Escolher Durvall por ter a maior variação mediana entre direções.
4. Calcular fatores hipotéticos de escala por direção contra `idle` e montar a
   prancha de comparação com `tools/hero_motion_pilot.gd`.
5. Inspecionar a prancha, registrar resultados e limites em EVID-129.

## Impactos

Esta etapa acrescenta duas ferramentas de inspeção e uma imagem de evidência.
Não modifica assets oficiais, dados do jogo ou código do renderer. Uma futura
execução por elenco poderá envolver escalas e âncoras em `ui/hero_view.gd` ou
revisão de assets por personagem; esses caminhos permanecem fora desta SPEC.

## Próxima etapa — substituída

A proposta estreita de selecionar outro piloto de escala de runtime foi
substituída pelo programa aprovado de animações integrais e efeitos para os dez
heróis em [[PLAN-049-animacoes-integrais-dos-herois-2026-09-30]]. EVID-129
permanece como diagnóstico de base; seus fatores hipotéticos não são parâmetros
de produção nem devem ser propagados automaticamente. O inventário executável
está especificado em [[SPEC-105-inventario-animacoes-e-efeitos-herois]] e
foi aprovado e concluído. A SPEC do pacote de Durvall está em
[[SPEC-106-pacote-integral-animacoes-durvall]], aprovada, mas pausada porque o
CLI local verificado cobre assets 3D/GLB, não animações de sprites 2D; nenhuma
referência local foi transmitida remotamente. O piloto de escala reprovado permanece
documentado em SPEC-102/EVID-132 como histórico.

## Reconciliação

- Auditoria de `idle` e das cinco fontes concluída para os dez heróis.
- Piloto de escala direcional de Durvall gerado e inspecionado.
- Arte oficial, renderer e estado de gameplay preservados.
- Evidência: `../evidence/EVID-129-auditoria-piloto-movimento-herois-2026-09-30.md`.

## Atualização após SPEC-105 — 2026-09-30

O inventário estático acrescentou a cobertura dos dez heróis, 106 folhas e
efeitos/ações observados em runtime. Foram encontradas 15 fontes opostas já
existentes mas não carregadas e 15 fontes ausentes para o contrato de oito
movimentos independentes. Ataque/habilidade não recebem o vetor de facing no
sprite; efeitos de combate são procedurais e não há sequência de gameplay VFX
específica por herói. Detalhes e limites da medição estão em
[[EVID-133-inventario-visual-herois-2026-09-30]].
