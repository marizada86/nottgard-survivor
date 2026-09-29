# PLAN-030 — Backlog do playtester Hiago: itens, equipamento e economia de run

Status: **alinhado com o dono em 2026-09-27 — Fase A liberada para spec.**

## Decisões da entrevista de alinhamento (2026-09-27)

1. **Sequência:** Fase A primeiro (itens 1 e 3), como recomendado.
2. **Modelo de loot (#2):** escassez com escolha, estilo roguelike — o loot
   vira uma oferta que se aceita, recusa ou vende no momento da coleta; não é
   um inventário livre para revisar depois. Isso muda o desenho de #2 na
   Fase B: não é só "abrir um painel e trocar", é uma decisão no momento do
   drop.
3. **Escopo de nível máximo/sinergia (#6/#7):** vale para qualquer run, não só
   para o modo infinito/profundidade de SPEC-009. Sem regra especial por modo
   — simplifica a Fase C: um único sistema de progressão de equipamento, sem
   caso especial para descidas profundas.
4. **Balanceamento econômico de #8:** resolvido dentro do escopo da própria
   spec de loja/ferreiro/curandeiro, sem spec de economia separada.

## Contexto observado

O dono trouxe 8 evidências de playtest do jogador **Hiago**, fora do fluxo do
kit de evidências (SPEC-020) — texto direto, sem manifesto/captura. Registro
literal:

1. Aparecer descrição dos itens.
2. Poder escolher qual item equipa e qual vende.
3. Deixar evidente quantos slots estão disponíveis para acessórios,
   equipamentos, magias, etc.
4. Itens "quebráveis" podendo conter poções, ouro, ímã, etc.
5. Itens temporários que causam dano (ex.: magia de fogo tipo lança-chamas por
   15 segundos).
6. Limitar o nível dos equipamentos/magias e, no nível final, super-upgrade
   (ex.: Cota de Malha nível máximo → +1 CA e +2 Força).
7. Combinar armas, acessórios e magias com sinergia, no nível máximo, para
   escalar poder em runs mais longas/descidas mais profundas.
8. Eventos aleatórios para gastar dinheiro: loja, ferreiro (upgrade de
   equipamento/arma), curandeiro, etc.

Este documento cobre só análise e proposta de sequenciamento. Nenhuma spec foi
aberta, nenhum arquivo de jogo foi alterado.

## Descoberta: o que já existe hoje

Antes de propor construção nova, o que já está implementado e pode ser
reaproveitado:

- **Descrições já existem como dado, mas não para itens de loot.** `desc` já é
  exibido para armas/habilidades na tela de level-up (`ui/hud.gd:152`), para
  melhorias meta (`ui/menu.gd:182`) e no Códex (`ui/menu.gd:249`). Itens de
  `data/items.json` (bases, afixos, únicos) têm `name`/`mods` e às vezes `note`
  (lore), mas isso **não aparece em tela** durante a run — é exatamente a
  lacuna da nota 1.
- **Nível e evolução de armas já existem — só não para equipamento.**
  `data/weapons.json` já tem `levels: [...]` (progressão por nível) e
  `evolve: {"passive": ..., "into": ...}` (evolução ao combinar arma + passiva
  no nível máximo), implementado em `core/battle.gd` e `core/weapon.gd`. Isso é
  quase literalmente o pedido 6/7, só que hoje vale para armas/magias, não para
  armadura/amuleto/anel.
- **Slots parciais já existem, mas invisíveis.** `data/upgrades.json` tem
  `bolso_fundo` (+1 slot de arma) e `mao_cheia` (+1 opção de level-up), ou seja,
  já existe noção de limite de slots — só não há indicador de HUD mostrando
  quantos slots existem/estão ocupados (pedido 3).
- **Não existe hoje:** objetos quebráveis com drop-table (pedido 4); dano por
  zona temporária já existe como *padrão de arma* (`cera_fervente`/
  `inferno_de_cera` já são zonas com `duration`/`tick`), então o pedido 5 é
  mais próximo de um novo item consumível usando um padrão que já existe no
  motor de armas do que de um sistema novo; inventário com decisão de
  equipar/vender (pedido 2); e qualquer evento de loja/ferreiro/curandeiro
  (pedido 8) — `data/stage_events.json` só tem `wave`, `hazard`, `elite`.

## Recomendação de agrupamento e sequência

Proponho 3 fases, ordenadas por dependência e risco — cada uma dá origem a
spec(s) própria(s), aprovadas uma de cada vez:

### Fase A — vitrine do que já existe (baixo risco, alto valor imediato)
- **#1 Descrição de itens**: expor `name`/`mods`/`note` já existentes em
  tooltip/painel de item durante a run, no mesmo padrão visual já usado para
  armas na tela de level-up.
- **#3 Slots visíveis**: HUD mostra contagem `ocupados/total` por categoria
  (arma, armadura, amuleto, anel), lendo os limites que já existem
  (`bolso_fundo` etc.) em vez de criar um sistema de limite novo.

Sem mudança de economia, sem novo dado de jogo — praticamente exposição de UI
sobre dado que já existe. Menor risco de todo o backlog.

### Fase B — decisões e conteúdo novo de escopo contido
- **#2 Equipar/vender**: precisa definir um modelo de inventário (hoje o loot
  parece se auto-aplicar). Esta é a decisão de design mais importante do
  backlog inteiro — ver pergunta 2 abaixo.
- **#4 Quebráveis**: nova entidade de cenário com drop-table (poção, ouro,
  ímã), reaproveitando padrões de prop já existentes (SPEC-022 a
  SPEC-031 criaram props de Dagruve) e de pickup já existentes.
- **#5 Item de dano temporário**: novo item/consumível reaproveitando o padrão
  `kind: "zone"` + `duration`/`tick` que `cera_fervente` já usa — menor
  novidade de engine do que parece à primeira vista.

### Fase C — sistemas grandes, maior superfície de design e balanceamento
- **#6 Nível máximo + super-upgrade de equipamento**: estender o padrão
  `levels`/evolução das armas para armadura/amuleto/anel. Depende da Fase B
  (#2) estar pronta, porque só faz sentido "escolher o que evolui" se já existe
  gestão de inventário.
- **#7 Sinergias combinatórias no nível máximo, para descidas mais
  profundas**: extensão do mecanismo de evolução (#6) para combinações
  arma+acessório+magia, alimentando o sistema de profundidade infinita já
  citado em SPEC-009/no campo `profundidade` do contexto de run. Depende de
  #6 estar implementado e balanceado primeiro.
- **#8 Eventos aleatórios de loja/ferreiro/curandeiro**: novo tipo de evento em
  `stage_events.json` e nova tela de interação (no padrão de `altar`/`ritual`
  já existente em SPEC-020). É o maior novo sistema econômico do lote — abre
  um sumidouro de moedas novo, o que interage com todo o balanceamento de
  `upgrades.json` (`ganancia`, afixos `da_fortuna`, `chicote_avarento`).
  Recomendo especificar depois de #6/#7 existirem, porque "ferreiro faz upgrade
  de equipamento" só tem conteúdo se o upgrade de equipamento (#6) já existir.

## Riscos e dependências a decidir antes de abrir a primeira spec

1. **Economia de moedas.** #2 (vender), #6 (super-upgrade) e #8 (loja/ferreiro)
   todos mexem no mesmo saldo de moedas que hoje só alimenta `upgrades.json`
   no Quartel. Sem um dono único de balanceamento, o risco é inflacionar ou
   esvaziar a economia entre runs.
2. **Save.** SPEC-057 (save resiliente) foi concluída recentemente; qualquer
   novo estado persistente (inventário, nível de equipamento, sinergias
   ativas) deveria estender esse trabalho em vez de criar um caminho de save
   paralelo.
3. **Escopo de "profundidade infinita".** O pedido 7 menciona explicitamente
   "descidas mais profundas" — isso é o modo de camadas 4–6/infinito de
   SPEC-009. Vale confirmar se o backlog do Hiago é para o modo normal, o modo
   infinito, ou ambos, porque isso muda o que "sinergia de nível máximo"
   precisa suportar (escalonamento sem teto vs. teto fixo).

## Plano de voo

1. ~~Alinhar com o dono as decisões abertas (perguntas abaixo).~~ Feito
   (ver decisões acima).
2. ~~Abrir SPEC da Fase A (itens 1 e 3) primeiro~~ —
   [[SPEC-059-descricao-de-itens-e-slots-visiveis]] aberta, **aprovada e
   executada em 2026-09-27** (suíte e smoke verdes; checagem manual
   interativa do dono pendente — ver
   [[EVID-089-spec-059-descricao-itens-e-slots-2026-09-27]]).
3. Abrir SPEC(s) da Fase B (itens 2, 4, 5) — item 2 primeiro, pois 6/7
   dependem dele.
   [[SPEC-060-escolha-de-equipar-ou-vender-loot]] (item 2) **aberta,
   aprovada e executada em 2026-09-28** (suíte e smoke verdes; checagem
   manual interativa do dono pendente — ver
   [[EVID-090-spec-060-escolha-equipar-vender-2026-09-28]]). Faltam os itens
   4 (quebráveis) e 5 (item de dano temporário) para fechar a Fase B.
4. Abrir SPEC(s) da Fase C (itens 6, 7, 8) só depois de B estar reconciliada,
   com uma spec de balanceamento econômico dedicada antes ou junto de #8.
5. Registrar EVID de cada execução no padrão já usado no projeto.

## Critérios de aceite (desta triagem)

1. As 8 evidências de Hiago estão categorizadas em fase, com dependências
   explícitas entre elas.
2. Nenhuma fase começa sem spec aprovada
   (`autonomy.execution_approval: per-spec` em `.atena/add.yaml`).
3. Os riscos de economia/save/escopo de profundidade estão registrados antes
   da primeira spec ser aberta.

## Limites

- Este plano não abre, aprova nem executa nenhuma spec por conta própria.
- Nenhum commit git foi feito.
