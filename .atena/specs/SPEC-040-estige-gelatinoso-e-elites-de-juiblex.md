# SPEC-040 — Estige gelatinoso e elites de Juiblex em Durao

Status: **supersedida** pelo PLAN-027/SPEC-055 (2026-09-27); histórico
preservado. Gelatina de Juiblex e imbuimento de raros não são intenção vigente.

## Intenção

Corrigir a leitura e a regra ambiental de Durao para refletir o fato canônico
novo: depois da passagem de Juiblex, o Rio Estige ficou gelatinoso e está
parado. O rio continua atravessável e mentalmente perigoso, mas não arrasta
herói, inimigos, itens ou projéteis. Inimigos raros que ficam sobre a água
recebem uma bênção temporária de Juiblex.

## Fonte e precedência

1. `vault/canon/PLAN-001-nottgard-survivors.md`, seções 6 e 7;
2. `SPEC-039-macroterreno-abissal-montanhas-e-rio-estige.md`;
3. declaração aprovada do dono em 2026-09-27: “Por onde Juiblex passa os rios
   ficam gelatinosos e param seu fluxo.”

O cânone aprovado prevalece sobre a regra de corrente implementada pela
SPEC-039.

## Escopo

- Criar o estado ambiental explícito `estige_gelatinoso` para Durao.
- Remover toda força de fluxo aplicada ao herói, inimigos, itens e projéteis
  enquanto esse estado estiver ativo.
- Substituir traços animados de corrente por água densa e imóvel, com almas e
  bolhas presas na gelatina.
- Preservar Teste de Lucidez, perda de lucidez efetiva, Esquecimento, aviso,
  Chamado e derrota como perigos sobrenaturais independentes de corrente.
- Conceder a inimigos raros/elite não-chefes, enquanto estiverem sobre a água,
  o buff temporário **Imbuído por Juiblex**: +20% de dano e 15% de redução de
  dano, com aura verde-amarela e bolha gelatinosa aos pés.
- Remover o buff imediatamente ao sair da água ou morrer; chefes não recebem
  esse bônus nesta entrega.
- Atualizar cenários QA e testes para rio imóvel, risco mental e buff raro.

## Não objetivos

- Retirar o perigo mental do Estige ou torná-lo uma parede intransponível.
- Mudar atributos persistentes, recompensas, chefes, ondas ou duração de
  Durao.
- Aplicar a bênção a inimigos comuns, chefes ou outras fases.
- Decidir agora quando o Estige voltará a fluir; o estado deve apenas permitir
  essa evolução futura guiada por lore.

## Critérios de aceite

1. Em Durao, herói, inimigos, itens e projéteis não sofrem deslocamento pelo
   Estige, inclusive após vários segundos na água.
2. A água parece densa e parada; não há traços ou animação que sugiram fluxo.
3. Os limiares mentais aprovados na SPEC-039 continuam funcionais e legíveis.
4. Um raro sobre a água mostra **Imbuído por Juiblex**, recebe exatamente os
   bônus definidos e os perde ao sair; chefe permanece inalterado.
5. QA oferece rio imóvel, raro imbuído, Esquecimento, Chamado e derrota; os
   testes cobrem cada transição sem consumir RNG de combate indevidamente.
6. Suíte, smoke e captura 1280×720 passam antes da reconciliação.

## Plano de voo proposto

1. Parametrizar a regra de Durao por estado ambiental, removendo o fluxo sem
   apagar a geometria, a água ou o risco mental do Estige.
2. Separar a apresentação visual estática da regra de deslocamento e atualizar
   a leitura da água gelatinosa.
3. Adicionar o estado efêmero de inimigo imbuído, calcular bônus somente
   durante sua presença na água e apresentar a aura sem ocultar telégrafos.
4. Revisar QA e testes determinísticos para herói, raro, elite e chefe.
5. Capturar Durao, executar suíte/smoke e reconciliar uma evidência ADD.

## Impactos previstos

- `data/stage_rules.json`, `core/battle.gd`, `core/enemy.gd`,
  `ui/ground.gd`, `ui/enemy_view.gd`, Navegador QA e testes de batalha/terreno.
- Atualização de reconciliação em SPEC-039 e nova evidência para esta correção.

## Reconciliação da execução

- Durao declara `styx_gelatinous` nos dados de fase e regra ambiental. A
  simulação não desloca herói, inimigos, itens ou projéteis por água do Estige.
- Teste de Lucidez, Esquecimento, aviso, Chamado e derrota continuam ativos;
  o Chamado não acrescenta força de movimento enquanto a água está gelada.
- `Enemy.styx_imbued` é temporário e somente ativa em inimigos com afixo,
  não-chefes, que estejam sobre a água. Ele multiplica dano por 1,20 e dano
  recebido por 0,85, inclusive em projéteis e áreas já lançadas.
- A água de `ui/ground.gd` passou a usar almas e bolhas estáticas. A UI chama
  Durao de Estige gelatinoso e não apresenta o ícone de corrente.
- QA ganhou “Estige: raro imbuído”; a suíte cobre ausência de empurrão,
  ativação/remoção do buff e exclusão de chefes.
- Evidência: `EVID-049-spec-040-estige-gelatinoso-2026-09-27.md` e
  `SPEC-040-durao-estige-gelatinoso-2026-09-27.png`.
