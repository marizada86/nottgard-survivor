---
id: "SPEC-102"
title: "Piloto runtime de escala direcional de Durvall"
status: "piloto executado e revertido após reprovação visual em 2026-09-30"
created: "2026-09-30"
relations:
  - "[[SPEC-101-polimento-proporcoes-movimento-herois]]"
  - "[[EVID-129-auditoria-piloto-movimento-herois-2026-09-30]]"
  - "[[EVID-132-piloto-runtime-escala-direcional-durvall-2026-09-30]]"
  - "[[SPEC-021-prompts-de-animacao-dos-herois]]"
---

# SPEC-102 — Piloto runtime de escala direcional de Durvall

## Intenção

Aplicar em runtime, somente a Durvall, os fatores de escala por movimento-fonte
calculados no piloto visual da SPEC-101. Avaliar o resultado com as seis poses
de cada folha e confirmar que direções espelhadas, ações e âncora do personagem
continuam corretas.

## Descoberta

- O renderer define altura-base de 72 px e usa a mesma escala para todas as
  animações em `ui/hero_view.gd`.
- As alturas medianas medidas em Durvall são: idle 293 px; norte 368; nordeste
  319; leste 226; sudeste 251; sul 308.
- O piloto estático sugere os fatores norte 0,796; nordeste 0,918; leste 1,296;
  sudeste 1,167; sul 0,951. O fator decorre de `293 / mediana da direção`.
- A linha inferior mediana de `idle` e das cinco direções de Durvall é y=376
  em células de 384 px. Não há discrepância mediana de base entre elas; esta
  SPEC preserva a âncora existente e não propõe deslocamentos por direção.
- Oeste, noroeste e sudoeste usam as folhas leste, nordeste e sudeste espelhadas
  no runtime, portanto devem herdar o fator da folha-fonte correspondente.
- As medidas incluem cabelo, espada e efeitos. A aparência final precisa ser
  revisada nos quadros completos, pois a escala afeta a arte inteira.

## Escopo

- Acrescentar perfil de escala opcional para movimentos-fonte, inicialmente
  apenas para `durvall`, em `ui/hero_view.gd`.
- Aplicar o fator quando `sync_visual` seleciona uma caminhada; restaurar a
  escala-base ao selecionar `idle`, `attack`, `active` ou `death`.
- Preservar a escala correta ao aplicar ou trocar herói, ao espelhar movimento
  e ao sair de uma ação travada.
- Estender `tests/test_animation_assets.gd` para cobrir as cinco escalas-fonte,
  as três direções espelhadas e a restauração da escala-base.
- Criar QA local que compare runtime atual e piloto ajustado em 72 px e ampliado,
  exibindo as seis poses de cada uma das cinco folhas-fonte.
- Registrar captura, fatores efetivamente usados, revisão visual e resultados
  em `.atena/evidence/`.

## Não objetivos

- Ajustar outro herói ou propagar estes fatores ao elenco.
- Editar ou regenerar PNGs oficiais, retratos, sprites estáticos ou prompts.
- Mudar célula, taxa de quadros, entrada, velocidade, colisão, posição lógica,
  identidade, lore, arma, efeitos ou regras de combate.
- Adicionar dependências, transferir referências remotamente, fazer commit,
  publicar ou abrir PR.

## Critérios de aceite

1. Durvall mantém os fatores do perfil nas cinco animações-fonte e os três
   movimentos espelhados usam o fator da fonte apropriada.
2. `idle`, `attack`, `active` e `death` usam a escala-base. A troca de herói e
   o retorno de uma ação não deixam um fator antigo aplicado.
3. A altura mediana de cada fonte de movimento, depois da escala, fica a no
   máximo 1 px da mediana de `idle` na métrica de caixa alfa; o resultado em
   jogo é revisado separadamente porque as caixas incluem arma e efeitos.
4. As seis poses de cada fonte continuam legíveis em escala de jogo; não há
   perda de espada, cabelo, efeito essencial, recorte, tremulação de base ou
   crescimento visual que faça Durvall dominar a cena.
5. As oito direções continuam selecionáveis e o ponto lógico, velocidade,
   facing e ciclo de quadros permanecem inalterados.
6. Os testes de animação e a suíte do projeto passam; a cena de QA registra
   evidência visual comparável entre escala atual e escala ajustada.
7. Nenhum arquivo em `assets/animations/heroes/` foi alterado.

## Riscos e resposta

- O fator leste aumenta a arte em 29,6%; espada e efeitos também crescem.
  Revisar a largura aparente e a proximidade de inimigos/props na escala real.
- A silhueta muda de orientação entre fontes; tamanho uniforme não garante
  volume corporal igual. Se a forma ficar artificial, parar e manter os PNGs e
  renderer no estado anterior até revisar outra abordagem.
- O alfa inclui elementos não corporais. Não alterar os fatores só para
  perseguir um número se a leitura visual se deteriorar.

## Impactos

Arquivos previstos: `ui/hero_view.gd`, `tests/test_animation_assets.gd`, duas
cenas/scripts QA locais e capturas/evidência Markdown. Os PNGs oficiais e dados
de gameplay ficam fora do escopo.

## Plano de voo

1. Registrar o baseline de runtime atual de Durvall nas cinco fontes e nas três
   direções espelhadas, incluindo os seis quadros de cada strip.
2. Adicionar o perfil por animação de Durvall, mantendo o valor-base dos demais
   heróis e de todas as ações.
3. Acrescentar verificações de escala e cobertura direcional ao teste de
   animações; exercitar troca de herói e retorno de ação.
4. Capturar a comparação no tamanho real de jogo e em ampliação. Inspecionar
   espada, cabelo, efeitos, pés e silhueta quadro a quadro.
5. Rodar `tests/run_all.gd` e o smoke test do jogo; registrar resultados e
   comparar com todos os critérios de aceite.
6. Reverter apenas as alterações desta SPEC se qualquer critério visual ou
   técnico falhar; registrar a causa e sugerir nova abordagem.
7. Reconciliar SPEC-102 e EVID-132. Não aplicar o perfil a outro herói; qualquer
   expansão recebe uma SPEC de elenco separada.

## Gate de execução

Esta SPEC limita a próxima execução a Durvall e ao renderer/testes/QA descritos
acima. Os arquivos oficiais de arte e os demais heróis permanecem fora do lote.
O perfil `.atena/add.yaml` exige aprovação do plano de voo de cada SPEC antes
da execução.

## Recuperação

Registrar os arquivos alterados antes da execução e preservar alterações
existentes. Como os PNGs oficiais não fazem parte da execução, reverter o
perfil e os testes da SPEC restaura o visual anterior sem restauração de assets.

## Evidência planejada

`../evidence/EVID-132-piloto-runtime-escala-direcional-durvall-2026-09-30.md`,
com fatores, cobertura das oito direções, capturas e resultados dos testes.

## Reconciliação — 2026-09-30

Execução inicialmente aprovada pelo usuário. A revisão posterior identificou
que a normalização considerava só altura e aplicava o fator uniformemente nos
dois eixos. Isso fez a caixa mediana de `move_e` passar de 240×226 para cerca de
311×293 px, enquanto idle é 240×293 px; portanto a pose lateral cresceu quase
30% em largura e falhou no critério visual 4. Ao iniciar ataque durante esse
movimento, a escala também caía de 1,296× para 1×.

Por orientação de recuperação já aprovada no plano, o perfil runtime e os
testes específicos dessa tentativa foram removidos. A escala uniforme anterior
foi restaurada; PNGs oficiais e alterações preexistentes foram preservados.
As imagens de EVID-132 são históricas e mostram a tentativa reprovada, não o
runtime atual. Suíte e smoke passaram novamente após a reversão. Qualquer nova
abordagem deve avaliar largura e silhueta junto com altura e tratar a transição
para ataque sem salto visual. A forma da sequência de ataque ainda precisa de
revisão visual contextual se permanecer como sintoma após corrigir o salto.
Brook permanece fora desta execução.
