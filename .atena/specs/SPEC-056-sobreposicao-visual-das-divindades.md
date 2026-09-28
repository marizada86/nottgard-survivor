---
id: "SPEC-056"
type: "especificação delimitada"
title: "Sobreposição visual das divindades"
status: "implementada e verificada"
created: "2026-09-27"
approved: "2026-09-27"
relations:
  - "[[PLAN-026-sobreposicao-visual-das-divindades-2026-09-27]]"
  - "[[RESEARCH-003-paleta-das-deidades-2026-09-27]]"
  - "[[SPEC-033-legibilidade-visual-e-retorno-divino]]"
---

# SPEC-056 — Sobreposição visual das divindades

## Escopo

Implementar uma sobreposição visual de afinidade divina, sem buffs. O herói
começa com sua identidade visual-base; após aceitar uma bênção de altar de uma
das sete divindades elegíveis, a última bênção passa a colorir coerentemente os
números de dano, aura, projéteis, trilhas e impactos. A aura permanece
inexistente até essa primeira escolha, como determina o canon.

As afinidades elegíveis são `Shar`, `Sendrinah`, `Mask`, `Lliira`,
`Ghaunadaur`, `Tou Um` e `Selûne`. Helion é um mago local e não habilita
afinidade, aura ou paleta divina.

## Contrato de dados visual

`core/divine_visuals.gd` evolui do mapa atual de cor/contorno para uma função
pura de resolução. O contrato retornado é um dicionário imutável na prática:

```text
ResolvedVisualTheme {
  primary: Color,       # números de dano e tonalidade principal
  aura_accent: Color,  # segunda camada de aura e traços de emissão
  impact_accent: Color,# clarão breve de impacto/trilha
  outline: Color,      # texto, linhas e contraste
  motif: String        # somente seleção de geometria/repetição já existente
}
```

A implementação fornece `is_divine_affinity(god)` e
`resolve(hero_id, visual_god, visual_boon_selected)`. A resolução não escreve
estado, não consome RNG e não modifica `Battle`, herói, buffs ou dados de
gameplay.

### Tema-base

Sem bênção ativa, `resolve` ignora a afinidade em `visual_god` e retorna a
identidade-base. Para manter exatamente a leitura já aprovada: Kayron retorna
vermelho abissal `#D13E54`, Maelor retorna dourado `#F4C542`, e os demais
heróis usam o campo `color` de `data/heroes.json`, com contorno escurecido.
Nenhum herói recebe aura persistente nessa condição.

### Sobreposições aprovadas

| Divindade | `primary` | `aura_accent` | `impact_accent` | `outline` | `motif` |
|---|---:|---:|---:|---:|---|
| Shar | `#B56BFF` | `#6B2A91` | `#D6A8FF` | `#160D24` | `eclipse` |
| Sendrinah | `#F4C542` | `#FFF0B3` | `#FFFFFF` | `#8C5B12` | `ascend` |
| Mask | `#AEB8C8` | `#536174` | `#DCE5F0` | `#171C27` | `shadow_ribbon` |
| Lliira | `#FFA12D` | `#FFE05C` | `#F04A3A` | `#9E2F37` | `three_stars` |
| Ghaunadaur | `#8AD14B` | `#A56BDA` | `#C58BFF` | `#44205E` | `elder_eye` |
| Tou Um | `#6FD4FF` | `#F1FBFF` | `#B9D0FF` | `#273C8F` | `north_star` |
| Selûne | `#8CCBFF` | `#EAF4FF` | `#FFFFFF` | `#355F94` | `seven_stars` |

O motivo não carrega regra nem cria um sistema de partículas. Ele só seleciona
uma variação leve de geometria, ritmo ou distribuição dentro dos efeitos que
já existem. Para Ghaunadaur, verde é sempre a leitura dominante; roxo aparece
somente em olho, névoa, tentáculo, trilha e impacto.

## Integrações delimitadas

| Consumidor | Ponto atual | Resultado exigido |
|---|---|---|
| Dano flutuante | `ui/run.gd`, evento `hit` | usa `primary`, crítico clareia somente o snapshot, e `outline` preserva contraste |
| Toast de afinidade | `ui/run.gd`, evento `divinity` | usa `primary`; nenhum texto novo |
| Aura | `_update_divine_aura` | continua oculta sem bênção; com bênção, usa anel principal e acento leve sem cobrir o herói |
| Golpe/trilha/impacto | funções visuais existentes de `ui/run.gd` | recebe a paleta do snapshot, sem mudar cone, raio, duração ou dano |
| Projéteis | caminho visual já acionado pelos eventos de combate | recebe `primary` e `impact_accent` no nascimento; não muda cor em voo |

`core/battle.gd` só deverá atualizar `visual_god` e habilitar
`visual_boon_selected` quando a escolha for uma bênção de altar de uma das sete
afinidades elegíveis. Bênções ou itens associados a Helion mantêm seus efeitos
mecânicos atuais, mas não criam uma aura ou uma afinidade divina.

## Regras de composição e ciclo de vida

1. Apenas uma sobreposição divina pode existir: a última bênção de altar
   elegível substitui a anterior.
2. Não há mistura de paletas, acúmulo de auras ou prioridade de buffs.
3. Cada projétil, trilha e impacto captura o `ResolvedVisualTheme` ao nascer.
4. Morte, reinício de run e troca de cena recriam o tema a partir do estado da
   run nova; nenhum `Line2D`, material ou modulação antiga pode persistir.
5. A transição de uma bênção para outra pode usar fade curto de no máximo
   0,20 s, sem efeito de tela, tremor de câmera ou áudio novo.

## Não objetivos

- Buffs, tiers, temas de item, elementos, combinação de cores ou auras antes
  de uma bênção divina.
- Alterar dano, duração, alcance, área, hitbox, recarga, IA, loot, progressão,
  save, oferta de altar ou RNG.
- Criar spritesheets, raster, dependências, shaders complexos, serviços externos
  ou alterações de lore além da decisão canônica já registrada.
- Incluir Helion na enumeração de divindades ou remover seu conteúdo de gameplay.
- Publicar, fazer commit, push, deploy ou compartilhar material fora do
  workspace.

## Critérios de aceite

1. Cada uma das sete afinidades resolve para a paleta exata da tabela; Helion
   não resolve como afinidade divina.
2. Kayron inicia vermelho abissal e Maelor dourado; os demais heróis iniciam
   pela cor registrada no seu dado, sem aura persistente.
3. Depois de uma bênção de altar elegível, os cinco consumidores mapeados usam
   a mesma paleta resolvida; uma escolha posterior substitui a anterior.
4. Ghaunadaur é verde em dano/forma dominante e roxo em acentos de VFX.
5. Efeitos emitidos preservam sua paleta até o fim, mesmo se uma nova bênção
   for escolhida depois.
6. Em 1280×720, aura, números, ataques e telegráfos permanecem distinguíveis;
   não há ocultação de herói, inimigos, chefe, itens, interações ou HUD.
7. A suíte, smoke de uma run, captura das sete bênçãos e reinício de run passam
   sem mudar resultados mecânicos ou consumo de RNG.

## Plano de voo de execução

1. Implementar o resolvedor puro e testes unitários para tema-base, cada uma
   das sete afinidades e exclusão de Helion.
2. Ajustar a transição de altar para aceitar apenas afinidades elegíveis, sem
   tocar nos modificadores de boon.
3. Conectar dano, toast e aura ao tema resolvido; validar a ausência de aura
   antes da primeira bênção.
4. Conectar golpe, trilha, impacto e projétil a snapshots; validar troca,
   expiração visual e reinício de run.
5. Rodar `tests/run_all.gd`, smoke determinístico e capturas das sete paletas
   em 1280×720; comparar com os critérios de aceite.
6. Revisar independentemente a matriz, a exclusão de Helion, o contraste e a
   ausência de deriva mecânica; registrar evidência ADD e reconciliar fatos
   operacionais aprovados.

## Evidências previstas

- Saída da suíte e dos testes novos de resolução de tema.
- Captura antes de qualquer bênção para Kayron, Maelor e um herói sem patrono.
- Uma captura por afinidade divina, incluindo Ghaunadaur, e uma tentativa de
  bênção de Helion sem aura divina.
- Registro de smoke de troca entre duas bênçãos e de reinício de run.
- Revisão do diff confirmando ausência de mudança em dados e regras mecânicas.

## Aprovação requerida

A aprovação desta SPEC autoriza a execução local e limitada descrita acima em
modo guarded-autopilot. Qualquer necessidade de incluir buffs, tier, Helion
como divindade, assets, dependências, mudança mecânica, publicação ou expansão
de lore exige nova aprovação explícita.

## Evidência e reconciliação

Execução concluída em 2026-09-27. `EVID-086` registra a suíte com zero falhas,
smoke completo e as sete capturas das afinidades. O tema foi mantido estritamente
visual: não houve alteração de dados de combate, RNG, regras, buffs ou Helion.
