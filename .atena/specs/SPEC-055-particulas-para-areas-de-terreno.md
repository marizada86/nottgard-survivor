---
id: "SPEC-055"
type: "especificação delimitada"
title: "Partículas paramétricas para áreas de terreno"
status: "implementada — validação gráfica pendente"
created: "2026-09-27"
approved: "2026-09-27"
relations:
  - "[[PLAN-024-particulas-para-efeitos-de-area-2026-09-27]]"
  - "[[SPEC-054-vfx-procedural-para-areas-de-terreno]]"
  - "[[ART-SPEC-001-vfx-e-ui-procedural]]"
---

# SPEC-055 — Partículas paramétricas para áreas de terreno

## Escopo

Adicionar acabamento de partículas reutilizável às áreas de terreno já
desenhadas proceduralmente. A implementação cria uma camada pooled sob os
atores, parametrizada por perfil, cor, emissão, vida, velocidade, direção,
prioridade e visibilidade em tela.

O lote inclui apenas quatro perfis: `mote`, `bolha`, `faísca` e `fluxo`.
Eles usam gradiente, curva, material/shader simples ou geometria procedural;
nenhum PNG, sprite exclusivo, dependência ou serviço externo será criado.

## Mapeamento de perfis

| Perfil | Consumidores | Limite |
|---|---|---|
| Mote | ritual, santuário, Estige, ilusão | 4–8 vivos por zona |
| Bolha | poça, Molor, raro imbuído | 1–4 vivos por zona |
| Faísca | impacto de telegráfo, explosão de bolha, Cera Fervente | até 12 por evento, vida de 0,15–0,35 s |
| Fluxo | corrente ativa dos Pilares | baixo alfa, orientado à força, pausado fora de tela |

Tentáculos permanecem desenhados por geometria procedural; recebem no máximo
duas gotículas no surgimento. Telégrafos não emitem partículas antes do dano.
Santuários falsos só recebem o acento violeta quando sua natureza é revelada.

## Regras de orçamento e camada

- Até três emissores ricos por quadrante. Quando o limite for alcançado, a
  zona-base e seu contorno permanecem; apenas o acabamento é suprimido.
- Até oito partículas vivas por zona persistente e doze no impacto.
- Os emissores são pausados fora de tela e nunca consomem a RNG de combate.
- Partículas de chão ficam abaixo de herói, inimigos, itens, interações e HUD.
- Partículas de impacto têm vida breve e não ocultam silhuetas críticas.

## Não objetivos

- Mudar regras em `core/battle.gd`, dados, dano, raio, duração, cadência,
  empurrão, cura, IA, áudio, loot, chefes ou progressão.
- Criar assets raster, spritesheets, shaders complexos, dependências novas ou
  atualizar materiais de terreno.
- Alterar lore, Estige, RNG ou comportamento em fases não listadas.
- Publicar, fazer commit, push, deploy ou compartilhar arte fora do workspace.

## Critérios de aceite

1. Os quatro perfis são reutilizáveis e cobrem os consumidores mapeados sem
   multiplicar cenas ou texturas por efeito.
2. A remoção visual de partículas não elimina a leitura de área, perigo,
   telegráfo, cura, alcance ou tempo.
3. Os limites por zona, evento e quadrante são respeitados no estresse com
   30–60 inimigos.
4. Partículas não ocultam herói, chefe, item, interação ou HUD em 1280×720.
5. Nenhuma regra mecânica, dado ou consumo de RNG é alterado.
6. Smoke, suíte, captura gráfica e evidência ADD passam antes da reconciliação.

## Plano de voo de execução

1. Criar o pool e a interface de perfil, com limite global por quadrante e
   pausa fora de tela.
2. Implementar `bolha`, `faísca` e `mote`; conectar aos consumidores de maior
   leitura sem mudar as zonas-base.
3. Implementar `fluxo` para a corrente dos Pilares e as respostas breves de
   impacto.
4. Validar em combate e no cenário determinístico de captura, incluindo o
   estresse de 30–60 inimigos.
5. Executar smoke e suíte; revisar a ordem de camadas, contagens e ausência de
   deriva mecânica; registrar evidência ADD.
6. Interromper e pedir nova direção se for necessário criar raster, dependência,
   alterar regra, ultrapassar orçamento ou mudar a decisão canônica.

## Aprovação requerida

A aprovação desta SPEC autoriza apenas a execução local e delimitada acima em
modo guarded-autopilot. Qualquer alteração além do escopo requer nova aprovação
explícita.
