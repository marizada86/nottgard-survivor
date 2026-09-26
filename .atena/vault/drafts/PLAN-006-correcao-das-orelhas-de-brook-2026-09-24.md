# PLAN-006 - Correcao das orelhas de Brook

Status: executado em 2026-09-24; correcao de identidade aprovada, alfa ainda bloqueado.

## Objetivo

Garantir que Brook seja representado como anao em toda arte nova: orelhas
curtas e arredondadas, parcialmente cobertas pelo cabelo, sem ponta longa ou
silhueta elfíca. A correcao deve preservar barba, cabelo, armadura, maca,
acento de Lliira, direcao da caminhada, quadros e escala.

## Escopo

- Candidatas de `HERO-brook-move_e` em
  `.atena/generated/animation-candidates/heroes/brook/`.
- Registros de execucao e evidencia associados.
- A regra de identidade ja registrada nos dados, spec e catalogo de prompts.

## Fora de escopo

- Nao alterar `assets/animations/heroes/brook/idle.png`, que ja foi aceita,
  salvo se uma nova revisao visual encontrar uma orelha elfíca nela.
- Nao integrar `move_e` sem aprovacao separada.
- Nao gerar ou editar outros estados de Brook neste plano.

## Criterios de aceite

1. Em todos os seis quadros, a orelha visivel e curta, arredondada e sem ponta
   projetada para fora do perfil.
2. Nenhuma alteracao em especie, barba, cabelo, armadura, maca, simbolo de
   Lliira, pose, direcao para a direita ou sequencia de caminhada.
3. Fundo e alfa passam por revisao independente; a correcao de orelha nao
   resolve nem mascara qualquer falha de transparencia.
4. A candidata corrigida e vista isoladamente e normalizada antes de qualquer
   integracao.

## Plano de voo

1. Escolher a candidata de melhor leitura corporal como alvo de edicao, sem
   apagar as tres originais. A preferencia inicial e `move_e_v02.png`, pois
   ela corrigiu a direcao e aproximou a identidade.
2. Usar edicao localizada de preservacao de identidade, com o alvo visivel e
   com uma unica mudanca: substituir apenas cada orelha pontuda por uma orelha
   ana curta e arredondada, parcialmente coberta pelo cabelo.
3. Anexar somente referencias previamente autorizadas para Brook. Caso a
   candidata `idle_v02_alpha_t06.png` seja usada como nova referencia de
   orelha, solicitar autorizacao explicita de transferencia antes da chamada.
4. Salvar a saida como derivada nao destrutiva, por exemplo
   `move_e_v02_earfix_v01.png`; nao substituir candidatas existentes.
5. Validar quadros, direcao, linha dos pes, especie e ausencia de anatomia
   extra. Avaliar alfa como gate separado.
6. Se a edicao mantiver fundo opaco, aplicar somente um recorte que preserve
   detalhes escuros; interromper se o recorte causar perdas.
7. Pedir aprovacao separada antes de normalizar ou integrar qualquer PNG.

## Gates

- O limite original de tres candidatas de geracao foi atingido. Esta edicao
  exige autorizacao explicita como excecao corretiva de identidade; ela nao
  reescreve o historico nem descarta as tres candidatas.
- A chamada deve registrar nova leitura das instrucoes gerais, do prompt
  especifico, do manifesto e dos dados de Brook.
- Sem aprovacao, o estado de `HERO-brook-move_e` permanece `qa_failed`.

## Evidencia planejada

- PNG alvo e PNG derivado, ambos fora de `assets/`.
- Registro atualizado em `prompt-execution/HERO-brook-move_e.json`.
- Resultado visual e decisao em uma evidencia nova ou em `EVID-015`.

## Resultado da execucao

A edicao derivada `move_e_v02_earfix_v01.png` corrigiu as seis orelhas para o
formato curto e arredondado de anao, preservando caminhada, maca, armadura e
grade. O recorte com limiar 6 preserva a arte, mas deixa halo colorido; o
limiar 7 danifica armadura e foi rejeitado. Nenhum arquivo foi integrado.
