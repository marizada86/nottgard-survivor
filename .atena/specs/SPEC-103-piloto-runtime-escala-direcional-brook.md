---
id: "SPEC-103"
title: "Piloto runtime de escala direcional de Brook"
status: "rascunho suspenso — programa PLAN-049 aprovado; manter apenas como diagnóstico histórico"
created: "2026-09-30"
relations:
  - "[[SPEC-101-polimento-proporcoes-movimento-herois]]"
  - "[[SPEC-102-piloto-runtime-escala-direcional-durvall]]"
  - "[[EVID-129-auditoria-piloto-movimento-herois-2026-09-30]]"
  - "[[PLAN-049-animacoes-integrais-dos-herois-2026-09-30]]"
---

# SPEC-103 — Piloto runtime de escala direcional de Brook

## Intenção

Avaliar uma correção reversível de escala por movimento-fonte para Brook,
segundo maior caso de variação aparente identificado pela auditoria. Só integrar
os fatores se a revisão de todos os quadros em escala de jogo confirmar que a
silhueta, arma, base e leitura visual continuam naturais.

## Descoberta

- As medianas da caixa alfa são: `idle` 259 px; norte 305; nordeste 245; leste
  255; sudeste 271; sul 360.
- Os fatores de partida `259 / mediana da direção` são norte 0,849; nordeste
  1,057; leste 1,016; sudeste 0,956; sul 0,719. São hipóteses, não aprovação
  automática do ajuste visual.
- A linha inferior mediana de `idle` e das cinco folhas de Brook é y=368 em
  células de 384 px; a auditoria não indica deslocamento mediano por direção.
- O runtime oferece oito direções lógicas usando cinco fontes e espelha oeste,
  noroeste e sudoeste. A arte não tem oito fontes independentes sob o contrato
  atual. Produzir animações independentes para os lados espelhados é outro
  trabalho e não faz parte deste piloto.
- A medição inclui arma, cabelo e efeitos; a escala pode afetar toda a silhueta.

## Escopo

- Adicionar perfil de escala runtime opcional somente para Brook, em
  `ui/hero_view.gd`, partindo dos fatores acima e sujeito à inspeção visual.
- Garantir que movimentos espelhados herdem a escala da fonte correta e que
  idle, ações, morte e troca de herói usem a escala-base.
- Testar as seis poses das cinco folhas, as oito direções lógicas, o retorno de
  ações e a restauração da escala ao mudar de herói.
- Capturar escala real, ampliação e uma comparação contextual local com o
  cenário, inimigos e props do runtime.
- Registrar a decisão e os resultados em uma nova evidência `.atena/`.

## Não objetivos

- Alterar qualquer outro herói, inclusive os fatores já integrados para
  Durvall.
- Gerar, substituir ou modificar PNGs oficiais, prompts, retratos ou identidade.
- Criar arte independente para oeste, noroeste ou sudoeste; o espelhamento
  aprovado continua vigente.
- Mudar células, taxa de quadros, velocidade, input, posição lógica, colisão,
  facing, efeitos ou regras de combate.
- Adicionar dependências, transferir referências remotamente, publicar ou
  alterar dados persistentes de gameplay.

## Critérios de aceite

1. O perfil é aplicado somente às cinco fontes de Brook; movimentos espelhados
   usam a fonte correta e qualquer outra animação/herói preserva escala-base.
2. A troca de herói e o fim/retorno de ações não deixam escala residual.
3. A mediana de altura alfa de cada fonte fica até 1 px da mediana de idle, e
   os seis quadros continuam enquadrados; a métrica não substitui revisão de
   corpo, arma e efeitos.
4. A comparação em tamanho de jogo e ampliada mostra pés estáveis, arma inteira,
   silhueta natural e crescimento que não domine inimigos/props próximos.
5. O teste cobre as oito direções, espelhamentos e invariantes de movimento;
   suíte do projeto e smoke passam.
6. Nenhum PNG em `assets/animations/heroes/` é alterado.

## Riscos e resposta

- A hipótese reduz `move_s` a cerca de 72% do tamanho uniforme. Se isso diminuir
  demais Brook ou sua arma, interromper e conservar apenas a evidência sem
  integrar o perfil.
- A métrica alfa contabiliza toda a arte. Não perseguir a equivalência
  numérica se uma pose parecer artificial.
- A troca visual entre direções pode vir da silhueta, não apenas da escala.
  Nesse caso, registrar a causa e propor abordagem específica, sem editar PNGs.

## Impactos previstos

`ui/hero_view.gd`, `tests/test_animation_assets.gd`, QA local e evidência
`.atena/`. Sem novos pacotes ou mudanças nos assets de animação.

## Plano de voo

1. Revalidar medidas e perfil de Brook diretamente nas folhas instaladas e
   comparar cada pose, arma, alfa e base com `idle`.
2. Registrar a captura baseline antes de integrar qualquer fator.
3. Implementar perfil isolado de Brook somente se a revisão confirmar que os
   fatores preservam leitura natural; caso contrário, interromper a execução e
   reconciliar a evidência com a recomendação de outra abordagem.
4. Estender os testes de escala e cobertura direcional sem alterar o contrato
   de cinco fontes mais três espelhamentos.
5. Capturar todos os quadros em escala real e ampliada, além do contexto de
   runtime com inimigos e props; revisar arma, cabelo/efeitos, base e silhueta.
6. Rodar `tests/run_all.gd` e `tools/smoke.tscn`, comparar cada critério e
   registrar avisos do ambiente, se houver.
7. Se qualquer critério visual ou técnico falhar, remover somente a tentativa
   desta SPEC, preservando alterações preexistentes, e registrar a falha.
8. Reconciliar SPEC-103 e sua evidência; não propagar o perfil ao elenco.

## Gate de execução

Este documento é um rascunho suspenso, não autorização para alterar o renderer
ou executar o piloto. A falha visual do método altura-apenas em SPEC-102 deve
ser resolvida antes de retomar ou aprovar a execução em Brook. O perfil
`.atena/add.yaml` exige aprovação do plano de voo de cada SPEC antes da
execução.

## Recuperação

Registrar o estado inicial e preservar mudanças existentes. A tentativa não
edita PNGs; remover somente entradas do perfil, testes e ferramentas/evidências
criadas por esta SPEC restaura o comportamento runtime anterior.

## Evidência planejada

Criar `../evidence/EVID-<próximo-id-livre>-piloto-runtime-escala-direcional-brook-2026-09-30.md`
depois da execução, sem reservar ID em conflito com trabalho paralelo.
