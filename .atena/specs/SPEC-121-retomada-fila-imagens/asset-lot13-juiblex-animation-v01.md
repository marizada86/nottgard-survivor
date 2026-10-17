# ASSET-LOT13/v01 — Manifestação de Juiblex, 26 quadros

DRAFT, origin planned, implementation_preceded_spec false. PLAN_CHANGE_REQUEST após “atena aprovado prossiga” e aceite LOT12. Escopo aprovado explicitamente em 2026-10-16: “atena, aprovado continue”, modo per-plan preservado. Implementação/preparação com Claude; produção de fonte não inclui integração. PLAN-103 e demais frentes preservados.

## Evidência e autoridade

[ART-032 estático MJ01/v03](../../vault/drafts/PLAN-ART032-JUIBLEX-v01.md), [aceite exato](../../generated/art032-juiblex-2026-10-12/visual-acceptance.json), [admissão estática](../../vault/drafts/PLAN-ART032-IMPLEMENT-v01.md), [PLAN-041 perfil B](../../vault/drafts/PLAN-041-animacao-padrao-zumbi-para-inimigos-e-interacoes-2026-09-29.md), [SPEC-118](../SPEC-118-acontecimentos-exclusivos-por-fase.md), `data/enemies.json` e `data/boss_phases.json`. Fonte MJ01/v03 e PNG estático ativo inspecionados, [hashes](../../generated/asset-lot13-2026-10-16/references.json). O trecho antigo que dizia que a manifestação copiava o receptáculo é diagnóstico histórico anterior à admissão, não estado atual.

Renderer `ui/enemy_view.gd` usa catálogo ANIMATED e diretórios de tiras; ID manifestacao_de_juiblex não foi encontrado no catálogo ou caminhos de animação consultados. Receptáculo/slime têm animações próprias, mas não substituem esta identidade. Reconfirmar antes de gerar, sem alegar inventário absoluto de fontes renomeadas. Manifestação já tem arte estática própria DRAFT; não redesenhar identidade, heróis ou lote de cenários.

Contexto existente: chefe substituto de Shedaklah após aliança com Zuggtmoy. Dados atuais têm puddle/summon/ring/aoe, e fases de invocação/hazards/enrage; não alterar números/gatilhos ou inventar poder. Escolha de consumer e ligação do special ficam com Claude em outro escopo. Sem nova consulta de lore: conteúdo necessário está nos registros locais, vault/Nottcard somente leitura.

## Bíblia e identidade — DRAFT v01

Identidade de entidade aplicável: manifestação ativa de Juiblex, não backup/receptáculo humanoide nem massa dormente de Thullgrime. Corpo assimétrico de gel verde-oliva/verde-negro, base larga coesa, lobo principal elevado fora do centro, três extensões filamentosas da mesma criatura, detalhes/recessos/reflexos da MJ01v03 preservados. Não interpretar recessos castanhos como autorização para acrescentar olhos/rosto. Sem esqueleto, boca, núcleo, braços/pernas humanos, criaturas menores incorporadas ou anatomia de franquias externas.

Fantasia sombria isométrica, clusters de pixel, câmera/facing para baixo-direita e luz superior esquerda da fonte. Brilho úmido localizado, grandes massas legíveis; gel-base opaco, transparência no vazio e apenas falloff legítimo. Corpo inteiro em cada PNG, sem chão, sombra projetada, cenário, texto, runas, aura/poça de habilidade destacada ou VFX separado. Contexto textual de combate basta; posição no mapa não é pré-requisito. Mesma base/escala/câmera em todos estados, exceto colapso de altura deliberado na morte e extensão contida no ataque/special.

## Escopo: 26 PNGs individuais, cinco entradas de revisão

| Estado / IDs | Quantidade | Proposta de fases | Reprodução |
|---|---:|---|---|
| idle JI00..JI03 |4|Repouso MJ01→pulso gel mínimo→relaxa→próximo do início, três extensões completas|Loop|
| move JM00..JM05 |6|Compressão/onda pela base e avanço visual do gel→recomposição, mesma posição no canvas; sem deslizar a imagem ou criar pernas|Loop|
| attack JA00..JA03 |4|Antecipa→extensão curta de um filamento existente para frente→contato visual contido→recolhe, sem projétil/novo membro|Uma vez, retorna ao repouso|
| death JD00..JD05 |6|Cede→lobo abaixa→extensões recolhem→massa achata→restos coesos→gel inerte assentado. Sem sangue/gore ou dispersão fora do canvas|Uma vez, segura último|
| special JS00..JS05 |6|Antecipa comprimindo base→lobo contrai→três extensões tensionam→pulso corporal máximo contido→relaxa→retorna. Somente animação corporal para futura habilidade existente|Uma vez, retorna ao repouso|

Escolha de frames ilustra ações existentes sem definir hitbox, dano, duração, evento de invocação, raio ou uso de special. Não gerar slimes invocados, anéis/poças externos ou vítimas. Novos movimentos são hipóteses DRAFT, não CANON de lore.

## Etapas, gate e orçamento

Preferência do dono é revisão em lotes maiores. **Mudança explícita proposta para este ensaio:** usar MJ01/v03 já aceita como identidade e revisar os cinco estados juntos, dispensando somente neste lote o gate intermediário de novo idle00 descrito no PLAN-041. JI00 é âncora geométrica das demais fontes, não novo aceite humano presumido. Aprovação deste plano precisa abranger essa revisão conjunta; não altera gates de outras frentes. Não gerar antes dessa aprovação.

1. S-001 prontidão/proposta: concluída. Identidade/contexto/bíblia/refs/hashes e perfil de26quadros preparados. BLOCKING único: aprovação deste novo escopo, orçamento e revisão conjunta.
2. S-002 produção: built-in imagegen, um PNG individual por pose,26fontes; alvo1024×1024 com motivo até65% e margem solicitada≥12%, centrox512/basey820, medir dimensões reais. JI00 estabelece geometria; demais usam estático/primeiro quadro e âncoras de estado quando necessário. Máximo três tentativas por arquivo por defeito objetivo, total máximo78chamadas novas. Preservar bytes/revisões/prompts/origem e referências readonly em `.atena/generated/art-candidates/asset-lot13/`. Sem folhas que cruzem colunas ou pose fabricada por recorte.
3. S-003 QA:26poses efetivas nos cinco estados, identidade/filamentos completos, dimensões/alfa/banda externa4px/margens/base/escala/continuidade e movimento real. Morte deve reduzir altura e terminar inerte; não tratar colapso deliberado como deriva de base. Idle/move retornam; ataque/special recompõem identidade. Contatos e leituras80/128, sem alinhar ou redimensionar nativos escondidos. Bbox é proxy, não pivô semântico; diferenças de hash não comprovam animação. Defeito material persistente no limite retém arquivo/estado, sem ampliar orçamento silenciosamente. Testar lógica de loop/hold no player, sem alegar fluidez ou diversão por métricas.
4. S-004 galeria conjunta em `.atena/generated/asset-lot13-2026-10-16/`, cinco players pausa/replay/FPS/repetição/scrub, manifestos/hash/prompts/origens/referências/medidas/evidência e handoff local para Claude. Verificar caminhos/controles, distinguir DOM offline de render real. Parar no aceite visual conjunto, permitindo parcial por estado/versão. Nenhuma admissão/integração/playtest incluídos.

RESOLVABLE: consistência de gel/filamentos, enquadramento/registro, leitura das ações, alfa/margens e retorno. DEFERRED: CANON, normalização/pivô/packing/redução/temporização, consumer special/flip/trigger, runtime e playtest humano. Recuperação por fontes versionadas e retenção seletiva, sem substituir estáticos ou demais entregas. Sem arquitetura material/dependências/permissões novas, alteração de código/dados, números/mecânicas, commit/push/merge/exportação/publicação ou mensagem a Claude. As retenções históricas LOT11 permanecem. Aprovação per-plan autorizará apenas S-001..S-004; gate visual posterior independente.

## Resultado 2026-10-17

S-001..S-004 concluídas:26fontes selecionadas em27tentativas; JI00/v02 e demais/v01, nativos1254×1254. DRAFT aguardando revisão visual conjunta. Aprovação de produção incluiu revisão conjunta limitada a este lote e limite78chamadas, não aceite antecipado dos resultados.

[Galeria](../../generated/asset-lot13-2026-10-16/index.html), [evidência](../../evidence/asset-lot13-juiblex-animation-2026-10-17.md), [estado](../../state/asset-lot13-juiblex-animation.yaml). Integridade e controles offline PASS; render/fluidez/aceite humano não verificados. Contrato de produção entregue com falhas parciais de prontidão: alfa, registro/escala e margens JD04/JD05 abaixo do alvo12%, retidos para preparação. Não há PASS técnico global ou admissão. Próximo checkpoint OWNER_JOINT_VISUAL_REVIEW/PENDING.
Aceite visual posterior2026-10-17: “atena, aprovado, proximo”,26revisões/cinco estados DRAFT aceitos. [Recibo](../../generated/asset-lot13-2026-10-16/visual-acceptance.json). Supera PENDING visual anterior; retenções técnicas/históricas, preparação com Claude e ausência de admissão permanecem.
