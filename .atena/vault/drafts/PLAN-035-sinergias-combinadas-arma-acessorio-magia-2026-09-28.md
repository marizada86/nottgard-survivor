# PLAN-035 — Sinergias combinadas: arma + acessório + magia no nível máximo

Status: **[[SPEC-075-sinergias-combinadas-arma-acessorio-magia]] aprovada e
executada em 2026-09-28 — suíte e smoke verdes; checagem manual interativa
do dono pendente. Evidência em
[[EVID-099-spec-075-sinergias-combinadas-2026-09-28]].**

## Decisões da entrevista de alinhamento (2026-09-28)

1. **Terceira perna**: "magia" = passiva de `passives.json` (não a habilidade
   ativa fixa do herói).
2. **Curadoria**: estender as 8 combinações arma+passiva já existentes,
   acrescentando um acessório específico a dedo por combo — não um sistema
   genérico.
3. **Formato**: evento único, escolhido na tela de level-up (mesmo padrão da
   evolução de arma hoje) — não um bônus automático silencioso.
4. **Escala**: o bônus da sinergia escala com `descent_depth`, sem teto —
   bate com "escalar poder em runs mais longas/descidas mais profundas" do
   pedido original.

## Origem

Item 7 do backlog original do playtester Hiago
([[PLAN-030-backlog-hiago-itens-equipamento-e-economia-2026-09-27]]): "Combinar
armas, acessórios e magias com sinergia, no nível máximo, para escalar poder em
runs mais longas/descidas mais profundas." O próprio PLAN-030 já registrou que
isso depende do item 6 (nível máximo de equipamento) estar implementado e
balanceado primeiro — [[SPEC-073-nivel-de-equipamento-e-super-upgrade]] foi
executada em 2026-09-28, então a dependência está resolvida.

O PLAN-034 já havia decidido, na entrevista de 2026-09-28, que nível
máximo/sinergia "vale para qualquer run, não só o modo infinito" — sem regra
especial por profundidade. Essa decisão já resolve o risco 3 do PLAN-030
("escopo de profundidade infinita").

## Discovery

- **O padrão de sinergia de duas pernas já existe e está em produção**: cada
  arma com `evolve` em `data/weapons.json` define `{"passive": <id>, "into":
  <arma_evoluída>}`. `Weapon.can_evolve()` exige `level >= MAX_LEVEL` (5,
  `core/weapon.gd:5`) e `def.has("evolve")`; `Battle` (`core/battle.gd:1478`)
  só oferece a evolução na tela de level-up quando o herói também tem
  `hero.passives.get(passive_id, 0) > 0` — ou seja, "arma no nível máximo +
  pelo menos 1 ponto numa passiva específica" já é escolhido pelo jogador como
  opção de oferta (`role: "synergy"`, peso alto). Há 8 armas com evolução
  definida hoje.
- **Acessórios agora têm nível máximo e super-upgrade (SPEC-073)**: item de
  armadura/amuleto/anel chega a `level == Items.MAX_LEVEL` (3) e ganha o bônus
  fixo `bases.<slot>[i].super` automaticamente ao ser agregado em
  `Hero.recalc()` — sem escolha do jogador, é automático assim que o nível 3 é
  alcançado (via ferreiro). Isso é diferente do padrão de arma (que exige uma
  escolha explícita na oferta de level-up).
- **"Magias" não é um dado à parte** — o candidato mais próximo são as
  passivas de `data/passives.json` (14 hoje: atributos, equipamento, cartas
  como "Alcance"/"Sabedoria"/"Ganância"). Elas já são a "perna 3" do padrão de
  evolução de arma. A alternativa seria a habilidade ativa por herói
  (`data/abilities.json`, uma única e fixa por herói, sem nível/escolha) — não
  parece encaixar em "magias" no plural nem em algo que "atinge o nível
  máximo", porque não tem nível.
- **`descent_depth` (`core/battle.gd:98`) já mede profundidade dentro da run**
  (incrementado a cada portal, `core/battle.gd:1447`) e já modula recompensa e
  pressão de elites. É o gancho natural para "escalar poder... em descidas
  mais profundas", caso a sinergia deva crescer com a profundidade em vez de
  ser um bônus fixo.
- **Precedente de curadoria manual**: na decisão da SPEC-073, o dono preferiu
  bônus definidos à mão por base de item (`super`) a uma fórmula genérica.
  Isso é um sinal de que a mesma preferência provavelmente vale aqui — mas é
  uma decisão explícita a confirmar, porque o espaço combinatório é bem maior
  aqui (8 armas × 13 bases de acessório × 14 passivas, se fosse combinação
  livre) do que os 13 bônus `super` de SPEC-073.

## Decisões necessárias antes de abrir a spec

1. **Terceira perna da sinergia**: confirmar que "magia" = passiva de
   `data/passives.json` (não a habilidade ativa fixa do herói). Recomendo
   isso, por já ser a perna 3 do padrão de evolução de arma existente e por
   ter nível/escolha (habilidade ativa não tem nenhum dos dois).
2. **Curadoria vs. fórmula genérica**: cada uma das 8 armas com evolução já
   tem uma passiva-parceira definida a dedo. Duas abordagens:
   - **Estender a tripla já existente** (recomendo): a mesma arma evoluída +
     a mesma passiva-parceira (já exigida pra evoluir) + um acessório
     específico no nível máximo (escolhido a dedo por combo, ex. a base de
     armadura mais temática daquela arma) desbloqueia uma "segunda evolução"
     ou um bônus adicional — reaproveita as 8 combinações já balanceadas em
     vez de abrir um espaço combinatório novo do zero.
   - **Sistema genérico**: qualquer arma no nível máximo + qualquer acessório
     no nível 3 + qualquer passiva com nível ≥ N aplica um bônus genérico
     (ex. "+X% de todos os mods enquanto as três condições estiverem
     ativas"). Menor trabalho de conteúdo, mas contraria a preferência já
     expressa na SPEC-073 por bônus nomeados/temáticos em vez de fórmula.
3. **Formato do bônus**: 
   - **Evento único, escolhido** (como a evolução de arma hoje): aparece como
     opção na tela de level-up quando as três condições são satisfeitas,
     jogador escolhe confirmar.
   - **Bônus automático e contínuo**, reavaliado em `Hero.recalc()` sempre que
     as três condições estiverem simultaneamente ativas (equivale ao padrão
     do `super` de acessório — automático, sem escolha) — e, se a resposta da
     decisão 4 for sim, **escalando com `descent_depth`** em vez de ser fixo.
4. **Escala por profundidade**: a frase original é "para escalar poder em
   runs mais longas/descidas mais profundas". Isso deveria significar que o
   bônus da sinergia cresce com `descent_depth` (ex. `+N% por camada
   descida`, sem teto, já que a decisão de PLAN-034 tirou o caso especial do
   modo infinito), ou é um bônus fixo que só fica disponível mais tarde na
   run (porque leva tempo pra maximizar 3 coisas), sem crescer sozinho depois
   disso?

## Fora de escopo (proposto)

- Não reabre a fórmula de nível/escala de acessório da SPEC-073 nem a
  evolução de arma existente — a sinergia se soma ao que já existe, não
  substitui.
- Não cria itens, armas, passivas ou heróis novos só para preencher combos —
  usa o que já existe em `data/*.json`.
- Sem caso especial por modo de jogo (infinito vs. normal) — decisão já
  fechada no PLAN-034.

## Plano de voo

1. ~~Alinhar as 4 decisões acima com o dono.~~ Feito.
2. [[SPEC-075-sinergias-combinadas-arma-acessorio-magia]] redigida com os 8
   combos, aguardando aprovação do dono.
3. Seguir o fluxo padrão do projeto: aprovação explícita → implementação →
   suíte/smoke → evidência → reconciliação.

## Limites

- Este plano não abre, aprova nem executa nenhuma spec por conta própria.
- Nenhum arquivo de jogo foi alterado nesta análise.
