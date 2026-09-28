---
id: "PLAN-024"
type: "plano-de-voo"
title: "Partículas reutilizáveis para efeitos de área"
status: "executado — validação gráfica pendente"
created: "2026-09-27"
approved: "2026-09-27"
relations:
  - "[[PLAN-023-efeitos-de-area-e-assets-procedurais-2026-09-27]]"
  - "[[SPEC-054-vfx-procedural-para-areas-de-terreno]]"
  - "[[ART-SPEC-001-vfx-e-ui-procedural]]"
---

# PLAN-024 — Partículas reutilizáveis para efeitos de área

## Intenção

Adicionar acabamento de partículas aos VFX procedurais das áreas de terreno,
sem substituir a linguagem já legível de forma, contorno, ritmo e telegráfo.
Partículas reforçam estados importantes e impactos; elas não serão a única
forma de comunicar perigo, cura, alcance ou tempo.

## Direção recomendada

Construir quatro perfis paramétricos e reutilizáveis em Godot, sem PNG ou
sprites exclusivos por efeito:

| Perfil | Uso | Regra de movimento |
|---|---|---|
| Mote suave | ritual, santuário, Estige e ilusão | sobe ou deriva lentamente, alfa baixo |
| Bolha orgânica | poça, Molor e raro imbuído | cresce, perde alfa e some; não cobre atores |
| Faísca curta | impactos, telegráfos resolvidos e Cera Fervente | explosão breve, 0,15–0,35 s |
| Fluxo linear | corrente dos Pilares | risco espectral orientado pela força atual |

Os perfis usam gradiente, curva e material/shader simples ou geometria já
procedural; nenhuma textura raster nova é necessária. A prioridade é uma
implementação pooled/reutilizável e de vida curta, adequada a 30–60 inimigos.

## Aplicação por efeito

- **Poça:** 1–3 bolhas lentas; nenhum respingo contínuo.
- **Ritual:** 6–8 motes que sobem ou convergem para o selo.
- **Telégrafo:** nenhuma partícula antes do dano; no impacto, 6–10 faíscas e
  anel curto.
- **Bolha de Molor:** bolhas na inflação; no estouro, até 8 gotículas e onda
  de pressão.
- **Santuário:** 4–6 motes dourados ascendentes; o falso revela 1–2 motes
  violeta somente ao ativar.
- **Cera Fervente:** brasas pequenas e três chamas contidas; sem fumaça grande.
- **Tentáculos:** nenhuma emissão contínua; duas gotículas arcanas no
  surgimento são suficientes.
- **Estige e imbuído:** almas/motes quase imóveis; raro imbuído recebe 3–4
  bolhas verde-amarelas nos pés.
- **Corrente:** riscos espaçados, leves e sempre orientados pela direção da
  força.

## Orçamento visual proposto

- Até 12 partículas de impacto por evento.
- Até 8 partículas vivas por zona persistente.
- Até três emissores ricos por quadrante; efeitos restantes preservam o
  contorno e usam apenas acentos mínimos.
- Emissores pausam fora de tela e não dependem da RNG de combate.
- Atores, chefe, itens, interações e HUD nunca ficam completamente cobertos.

## Escopo proposto

1. Definir uma interface de perfil com cor, emissão, vida, velocidade,
   gravidade, direção e prioridade visual.
2. Implementar primeiro `bolha`, `faísca` e `mote`, aplicando-os em poça,
   ritual, telegráfo, Molor e Cera.
3. Implementar `fluxo linear` para a corrente dos Pilares.
4. Conectar perfis às zonas existentes sem alterar `core/battle.gd`, dados,
   dano, raio, duração, cadência, áudio ou regras ambientais.
5. Validar ordem de camadas, orçamento, leitura em 1280×720 e estresse com
   30–60 inimigos; registrar evidência ADD.

## Não objetivos

- Criar PNGs, spritesheets, dependências ou serviços externos.
- Mudar regras de combate, lore, RNG, chefes, progressão ou o comportamento do
  Estige.
- Converter todos os VFX do jogo de uma vez; o lote cobre somente áreas de
  terreno e suas respostas de impacto.
- Publicar, fazer commit, push, deploy ou compartilhar fora do workspace.

## Critérios de aceite propostos

1. Cada perfil é reutilizado por pelo menos dois usos compatíveis ou é
   justificado como exceção de alta leitura.
2. Um efeito continua compreensível quando suas partículas são desativadas.
3. Nenhuma área persistente ultrapassa oito partículas vivas e nenhum impacto
   ultrapassa doze partículas.
4. O cenário de 30–60 inimigos respeita três emissores ricos por quadrante sem
   ocultar silhuetas importantes.
5. Não há alteração mecânica, de dados, de RNG ou dependência nova.
6. Suíte, smoke e captura gráfica 1280×720 passam antes da reconciliação.

## Plano de voo

1. Criar uma SPEC delimitando a arquitetura de pool, a camada e os quatro
   perfis, depois de aprovação deste plano.
2. Implementar os três perfis prioritários e o limite global de emissão.
3. Integrar as respostas de impacto e o fluxo dos Pilares.
4. Executar testes, smoke e cenário de estresse; capturar a composição gráfica.
5. Revisar independentemente os limites, a legibilidade e a ausência de deriva
   mecânica; registrar evidência e reconciliar fatos operacionais.

## Aprovações necessárias

- Aprovação deste plano para elaborar a SPEC.
- Aprovação explícita da SPEC antes de executar código, recursos locais ou
  testes de estresse.
- Nova aprovação se a investigação exigir dependência, raster, alteração de
  regra, decisão canônica, publicação ou serviço externo.

## Registro de aprovação

O dono aprovou este plano em 2026-09-27. A aprovação permite elaborar a SPEC
delimitada, mas não autoriza ainda mudanças de código, recursos locais, dados,
dependências, publicação ou serviços externos.
