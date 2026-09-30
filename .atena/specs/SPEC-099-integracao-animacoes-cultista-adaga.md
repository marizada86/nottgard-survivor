---
id: "SPEC-099"
title: "Integração das animações aprovadas do cultista de adaga"
status: "implementation verified; push in progress"
created: "2026-09-30"
relations:
  - "[[SPEC-097-geracao-das-imagens-de-arte-pendentes]]"
  - "[[PLAN-046-integracao-animacoes-cultista-adaga-2026-09-30]]"
  - "[[EVID-125-piloto-cultista-aprovacao-alfa-comparacao-2026-09-30]]"
---

# SPEC-099 — Integração das animações aprovadas do cultista de adaga

## Pedido e autorização

Em 2026-09-30, o dono autorizou implementar os assets aprovados até então e
fazer push. Esta spec limita a integração às animações do piloto
`cultista_adaga`; o plano aprovado anterior explicitamente não cobria os
demais inimigos.

## Escopo

- Compor os 20 quadros individuais aprovados E01–E20 em quatro tiras RGBA para
  runtime: `idle` (4), `move` (6), `attack` (4) e `death` (6), com células
  256×384, pixels vizinhos preservados e linha de base alinhada.
- Ligar as quatro tiras ao `EnemyView` de `cultista_adaga`, mantendo a arte
  estática como fallback se uma tira faltar.
- Espelhar horizontalmente somente durante movimento para a esquerda; ataques,
  idle e morte permanecem na orientação-base aprovada.
- Validar importação, dimensões, alfa, contagem dos quadros, fallback e
  orientação; registrar evidência e enviar commit de escopo limitado a uma
  branch `codex/`.

## Não objetivos

- Não integrar E21–E24 ao runtime: a extração automática dessas tiras cortou
  detalhes que atravessam os limites de célula, conforme EVID-125. Mantê-las
  como referências aprovadas no diretório local de candidatas.
- Não substituir `assets/enemies/cultista_adaga.png` nem modificar parâmetros,
  regras, lore, cenas ou animações de outros inimigos.
- Não incluir HQs nem alterações locais não relacionadas no commit/push.
- Não publicar release, abrir PR ou mesclar a branch.

## Critérios de aceite

1. Quatro PNGs RGBA em `assets/animations/enemies/cultista_adaga/`, cada qual
   com largura `quadros × 256` e altura 384; todos os quadros têm alfa e
   conteúdo dentro da célula.
2. `EnemyView` carrega exatamente 4/6/4/6 quadros e continua mostrando o PNG
   estático quando as tiras de animação não estão disponíveis.
3. Movimento para a esquerda espelha apenas o movimento; ações não ficam
   espelhadas.
4. Testes de assets e integração passam; uma verificação visual das quatro
   tiras não revela fundo ciano, corte ou salto de base.
5. Evidência reconciliada e commit/push contém somente arquivos do escopo em
   uma branch `codex/`; alterações não relacionadas permanecem intactas.

## Plano de voo aprovado

1. Gerar as tiras por composição determinística dos candidatos alfa E01–E20.
2. Registrar os quatro assets no teste de animação e adicionar a configuração
   mínima do cultista no `EnemyView`.
3. Importar, rodar testes e verificar imagens/dimensões/âncora; reparar antes
   de prosseguir se qualquer critério falhar.
4. Atualizar evidência e manifesto, conferir diff e criar commit isolado;
   fazer push da branch `codex/` sem incluir mudanças fora de escopo.

## Aprovação

Plano de voo aprovado pelo pedido explícito do dono em 2026-09-30: implementar
os assets existentes e fazer push. A recomendação documentada de usar quadros
individuais determina a fonte do runtime; nenhuma candidata é sobrescrita.
