---
id: "PLAN-025"
type: "plano-de-voo"
title: "Tema de combate por personagem, divindade e buff"
status: "substituído por PLAN-026 — buffs adiados por decisão do dono"
created: "2026-09-27"
relations:
  - "[[PLAN-001-nottgard-survivors]]"
  - "[[SPEC-033-legibilidade-visual-e-retorno-divino]]"
  - "[[SPEC-040-estige-gelatinoso-e-elites-de-juiblex]]"
---

# PLAN-025 — Tema de combate por personagem, divindade e buff

> Substituído em 2026-09-27 por `PLAN-026-sobreposicao-visual-das-divindades-2026-09-27`.
> A primeira entrega cobre somente sobreposições de divindades; buffs e tiers
> ficam deliberadamente fora do escopo até uma nova decisão do dono.

## Intenção

Dar a cada herói uma assinatura visual de combate consistente e legível. Os
números de dano, auras, projéteis, trilhas e impactos devem partir da
identidade/divindade do herói e responder, de forma temporária, ao buff ativo.
Os tiers de buff devem aumentar a riqueza e a cadência da apresentação visual,
sem mudar por si só as regras mecânicas do buff.

## Decisão recomendada

Adotar um **tema de combate resolvido** como fonte única de verdade visual.
Nenhuma arma, projétil, aura ou número de dano escolhe sua cor diretamente:
todos consultam o mesmo resultado antes de nascer.

```text
identidade do herói + afinidade divina -> tema-base
tema-base + buff dominante + acentos secundários -> tema resolvido
tema resolvido -> dano, aura, projétil, trilha, impacto e partículas
```

O tema-base é definido pelo herói e sua afinidade divina. Um buff ativo ocupa
o papel visual dominante; buffs adicionais só acrescentam acentos pequenos e
nunca produzem uma mistura indiscriminada de cores. Ao expirar, o buff devolve
o herói ao tema-base com transição curta, e não com troca abrupta.

## Ponto canônico que exige aprovação

O cânone atual em `PLAN-001`, seção 19, e a `SPEC-033` dizem que a aura só
existe após a primeira bênção de altar. O pedido de um tema de aura vindo de
buff pode alcançar personagens que ainda não receberam essa bênção.

A recomendação é preservar a aura divina persistente somente após a primeira
bênção, mas permitir que um buff ativo emita uma **aura temporária de buff**
enquanto durar. Antes da bênção, o personagem mantém apenas sua cor de dano
base; o buff pode sobrepô-la durante sua duração. Essa exceção é uma mudança
canônica delimitada e requer aprovação explícita antes da SPEC ou de código.

## Modelo visual proposto

| Camada | Responsabilidade | Regra de composição |
|---|---|---|
| Tema-base | cor inicial de dano, paleta e assinatura de deidade/herói | sempre existe |
| Afinidade divina | atualiza o tema-base após escolha de altar | a última escolha substitui a anterior, como no cânone atual |
| Buff dominante | paleta, forma, ritmo e VFX principais enquanto ativo | vence o tema-base visualmente |
| Buff secundário | acento pontual em impacto, trilha ou partícula | não substitui paleta, silhueta ou telegráfo principal |
| Snapshot de emissão | cópia do tema no nascimento de projétil/impacto | efeitos já disparados não trocam de cor no ar |

O primeiro buff de maior tier é dominante. Em empate, a maior prioridade de
design do buff vence; se ainda houver empate, vence o mais recentemente
adquirido. A regra será centralizada e determinística, sem consumir RNG de
combate.

## Linguagem visual por tier

| Tier | Leitura desejada | Componentes permitidos |
|---|---|---|
| 1 | estado temporário reconhecível, discreto | recoloração, pulso curto, um emissor simples e impacto breve |
| 2 | poder relevante para a build | aura em duas camadas, trilha orientada e impacto próprio com partículas controladas |
| 3 | estado heroico e imediatamente prioritário | aura persistente rica, animação multifásica de ataque, material/shader leve e acento ambiental breve |

Tier aumenta presença visual; não cria dano, alcance, cadência, hitbox, RNG ou
efeito mecânico que não pertença à própria definição de gameplay do buff.

## Arquitetura local proposta

1. Criar um recurso de dados `CombatTheme` com identificador, paleta primária/
   secundária, cor de dano, perfis de aura, trilha, projétil e impacto.
2. Fazer cada herói referenciar seu tema-base; ofertas de divindade atualizam a
   afinidade, preservando a regra de última escolha.
3. Fazer cada definição de buff referenciar opcionalmente um tema visual, seu
   tier e sua prioridade visual; gameplay e VFX permanecem campos separados.
4. Introduzir um `ThemeResolver` puro, determinístico e sem RNG que componha o
   `ResolvedCombatTheme` a partir de herói, afinidade e buffs ativos.
5. Fazer emissores de dano, aura, projéteis, trilhas e impactos consumir o
   resultado resolvido e receber seu snapshot no momento de emissão.
6. Reutilizar perfis de partículas existentes/poolados quando possível, com
   limites de contagem e pausa fora de tela.

## Escopo proposto

1. Mapear heróis, divindades e buffs já existentes para uma primeira matriz de
   temas, sem inventar novas divindades, buffs ou lore.
2. Implementar o modelo de dados e o resolvedor, primeiro em cenário de QA
   determinístico.
3. Aplicar o tema resolvido aos números de dano e a um caminho de ataque/
   projétil representativo por herói.
4. Aplicar aura e VFX de buff conforme a decisão canônica aprovada, usando os
   três tiers para um piloto de um buff por tier.
5. Expandir somente após validar clareza, orçamento, restauração de tema e
   compatibilidade com as bênçãos e o buff Imbuído por Juiblex.

## Não objetivos

- Mudar os valores, duração, fontes ou regras de gameplay dos buffs.
- Criar novos buffs, novas divindades, novo lore, dependências, serviços ou
  assets raster obrigatórios.
- Alterar hitbox, dano, alcance, cadência, IA, loot, save, progressão ou RNG.
- Exibir muitas paletas simultâneas, ocultar telegráfos ou permitir que VFX
  ricos encubram herói, inimigos, itens, interações ou HUD.
- Publicar, fazer commit, push, deploy ou compartilhar conteúdo fora do
  workspace.

## Critérios de aceite propostos

1. Sem buff, o dano inicia na cor do tema-base do herói e a afinidade divina
   segue a regra aprovada para a última bênção.
2. Com um buff dominante ativo, dano, aura/VFX, projétil, trilha e impacto usam
   a paleta e a linguagem do mesmo tema resolvido.
3. Buffs secundários são visíveis apenas como acentos e não tornam a origem ou
   o telegráfo do dano ambíguos.
4. Tiers 1, 2 e 3 são distinguíveis pela linguagem visual descrita, sem criar
   mecânica nova nem violar o orçamento de efeitos.
5. Projéteis e impactos já emitidos preservam o snapshot correto até o fim.
6. Ao expirar um buff, o retorno ao tema anterior é suave, determinístico e não
   deixa emissores, materiais ou cores órfãos.
7. A cenografia de 1280×720 e o estresse com 30–60 inimigos mantêm leitura de
   herói, inimigos, chefe, telegráfos, itens, interações e HUD.
8. Testes automatizados, smoke, captura visual e evidência ADD passam antes da
   reconciliação.

## Plano de voo

1. Obter aprovação explícita da exceção canônica para aura temporária de buff
   antes da primeira bênção — ou receber a regra alternativa do dono.
2. Elaborar uma SPEC limitada com a matriz inicial, formato de recursos,
   desempate de prioridade, transições, orçamento de VFX e cenários de QA.
3. Após aprovação da SPEC, implementar o resolvedor e os dados sem alterar
   regras mecânicas.
4. Integrar um piloto que cubra dano, aura/VFX, projétil, trilha e impacto em
   cada tier; validar em isolamento e em combate real.
5. Exercitar aquisição, sobreposição, expiração, morte, troca de cena e buffs
   simultâneos; verificar que nenhum estado visual vaza para a próxima run.
6. Rodar suíte, smoke, cenários de estresse e capturas em resolução-alvo.
7. Revisar independentemente os critérios de aceite, registrar evidência e
   reconciliar apenas os fatos operacionais aprovados.

## Aprovações necessárias

- Aprovação canônica da regra de aura de buff antes da primeira bênção, ou
  confirmação de que buffs só podem afetar uma aura já desbloqueada.
- Aprovação deste plano para produzir a SPEC delimitada.
- Aprovação explícita da SPEC antes de modificar código, recursos, dados ou
  testes de integração.
- Nova aprovação se a execução exigir dependência, shader complexo, asset
  raster, mudança de regra, nova decisão de lore ou publicação.

## Registro de aprovação

Este rascunho não autoriza mudanças locais de código, recursos, dados ou
cânone. A aprovação do plano autoriza somente a elaboração da SPEC delimitada.
