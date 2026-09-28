---
id: "SPEC-053"
type: "especificação delimitada"
title: "VFX procedural para áreas de terreno"
status: "rascunho — aguardando aprovação"
created: "2026-09-27"
relations:
  - "[[PLAN-022-efeitos-de-area-e-assets-procedurais-2026-09-27]]"
  - "[[ART-SPEC-001-vfx-e-ui-procedural]]"
  - "[[SPEC-040-estige-gelatinoso-e-elites-de-juiblex]]"
---

# SPEC-053 — VFX procedural para áreas de terreno

## Escopo

Substituir a apresentação plana das zonas de chão por uma biblioteca de VFX
procedurais reutilizável, sem alterar regras de combate. O lote cobre as
zonas existentes: poça, selo ritual, telégrafo, bolha, santuário, Estige
gelatinoso/imbuído, corrente e zonas de jogador de cera e tentáculos.

O trabalho mantém as zonas abaixo de atores, itens, interações e HUD. Impactos
breves podem sobrepor o chão, mas não ocultam herói, chefe ou interação.

## Decisão de comportamento preservada

Para não introduzir alteração mecânica, `data/stage_rules.json` e
`core/battle.gd` são a referência de runtime desta SPEC. A lista `ambient` em
`data/stages.json` permanece somente como catálogo enquanto não houver decisão
específica para reconciliá-la.

Portanto, este lote não torna ilusões e poças simultâneas em Goranthis, não
troca as bolhas de Molor por poças e não transforma a rotação dos Pilares em
efeitos simultâneos. A divergência será documentada como evidência, não
modificada nesta execução.

## Não objetivos

- Alterar dano, raio, duração, cadência, empurrão, cura, IA, chefes, loot ou
  progressão.
- Criar regras novas para água/Estige em qualquer fase.
- Gerar sprites PNG de VFX, promover raster de terreno, adicionar dependência
  ou alterar áudio.
- Alterar cânone, dados narrativos, publicação, commit, push ou deployment.

## Critérios de aceite

1. Poça, ritual, telégrafo, bolha, santuário, Estige/imbuído, corrente, cera e
   tentáculos possuem forma e ritmo distintos; cor nunca é o único sinal.
2. Todo telegráfo aparece antes do dano e é visualmente distinguível do
   impacto.
3. As identidades de fase são reconhecíveis: corrosão/esporo, rito, Molor,
   falso paraíso, Estige imóvel e Pilares não parecem variações da mesma elipse.
4. O número de efeitos grandes não excede três por quadrante de tela no cenário
   de estresse; silhuetas essenciais permanecem legíveis a 1280×720 com 30–60
   inimigos.
5. Testes existentes continuam verdes; testes novos cobrem somente a seleção de
   VFX e a ordem de camadas que puder ser verificada deterministicamente.
6. Nenhum valor mecânico ou configuração de regra é alterado.

## Impactos previstos

- `ui/overlay.gd`: componentes e desenho de zonas.
- `ui/run.gd`: somente se necessário para respostas transitórias de impacto.
- Recursos locais de shader/material/partícula procedural, sem dependências nem
  texturas raster novas.
- Testes e captura reprodutível; `.atena/evidence/` para a reconciliação.

## Plano de voo de execução

1. Criar um vocabulário de parâmetros compartilhados: equipe, perigo, raio,
   atraso, progresso, duração, estado falso e intensidade.
2. Implementar poça, telégrafo e ritual, validando primeiro a leitura abaixo
   dos atores.
3. Implementar bolha, santuário, corrente e as zonas de jogador com a mesma
   base.
4. Aplicar acabamento específico ao Estige imóvel e ao raro imbuído sem sugerir
   corrente em Durao.
5. Executar a suíte, smoke, captura 1280×720 e cenário de estresse.
6. Fazer revisão independente contra os critérios de aceite, registrar a
   divergência `ambient`/`stage_rules` e criar evidência ADD.
7. Reconciliar os fatos operacionais; interromper e pedir orientação se a
   implementação exigir mudar regra, dados, cânone, dependência ou orçamento.

## Evidência planejada

- Capturas antes/depois por grupo de efeito em 1280×720.
- Resultado de testes e smoke.
- Registro de contagem visual no cenário de estresse.
- Comparação de configurações para demonstrar que valores mecânicos não
  mudaram.

## Aprovação requerida

A aprovação desta SPEC autoriza apenas a execução local delimitada acima, em
modo guarded-autopilot. Qualquer ampliação de regra, asset raster, dependência,
canon, publicação ou alteração externa exige nova aprovação.
