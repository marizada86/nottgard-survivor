# PLAN-004 — Regressão de movimento sudoeste

Status: **execução parcial em 2026-09-23; rota lógica coberta, validação visual manual pendente.**

## Contexto observado

Foi relatado que `A + S` (baixo e esquerda na tela) não apresenta a animação
esperada. A leitura estática atual é coerente: `ui/run.gd` monta `(-1, 1)` para
essas teclas e `HeroView.directional_walk_animation()` resolve esse vetor para
`move_sw`. A faixa `move_sw.png` existe e tem a dimensão esperada. O teste atual
prova somente seleção nominal e presença do arquivo; não prova o comportamento
visível em uma run.

## Hipóteses, em ordem de verificação

1. A seleção em execução diverge da seleção unitária por estado travado
   (`attack`, `active` ou `death`) ou por ausência de sincronização do nó.
2. O deslocamento ocorre, mas a sequência `move_sw` tem leitura visual
   ambígua/sem movimento suficiente para baixo e esquerda.
3. O cenário, foco de janela ou entrada física impede a combinação de teclas;
   não há evidência de que seja esse o caso.

## Plano de voo

1. Reproduzir em uma run sem combate, registrar entrada, deslocamento em tela e
   nome da animação selecionada para `A`, `S`, `A+S` e setas equivalentes.
2. Adicionar um teste de regressão que instancie `HeroView`, aplique dois
   deslocamentos em tela e confirme `move_sw` para `Vector2(-1, 1)` sem ação
   travada.
3. Se o seletor falhar, corrigir apenas a passagem do vetor de deslocamento real
   para `HeroView` e cobrir os oito setores no teste.
4. Se o seletor estiver correto mas a leitura falhar, substituir somente a
   candidata de `move_sw` após um prompt de correção que declare
   explicitamente “movimento visual para baixo e esquerda”, preservando
   identidade, base, alfa e os seis quadros.
5. Rodar a suíte, verificar `A+S` e as setas em runtime e registrar screenshot
   ou evidência de execução antes de reconciliar.

## Critérios de aceite

1. `A+S` e baixo+esquerda nas setas deslocam Durvall para baixo e esquerda na
   tela e selecionam `move_sw` durante a caminhada.
2. As outras sete direções continuam selecionando suas sequências corretas.
3. Ataque, habilidade, morte, pausa e colisão não regredem.
4. A suíte automatizada e o smoke test permanecem verdes.

## Limites

Não alterar controles, projeção isométrica, lore ou arquivos de outros heróis
sem nova decisão. Se for necessário gerar ou substituir a imagem `move_sw`,
solicitar aprovação específica para essa geração antes de enviar referências ou
alterar o asset final.

## Evidência da execução parcial

- `Hero.movement_input()` passou a ser a única tradução das quatro entradas de
  movimento usada por `ui/run.gd`.
- O teste de assets agora prova `A+S → Vector2(-1, 1)`, aplica esse vetor ao
  deslocamento real de `Hero` e confirma que o delta visual escolhe `move_sw`.
- A suíte e o smoke test passaram. O ambiente de automação não expôs uma janela
  nativa do jogo, portanto não há afirmação de inspeção visual em runtime.
