---
id: "SPEC-100"
title: "Integração das HQN-01 a HQN-10 no jogo"
status: "concluída — execução e verificação locais"
created: "2026-09-30"
relations:
  - "[[PLAN-040-hqs-novas-highlights-do-vault-2026-09-29]]"
  - "[[ART-PROMPTS-027-hqs-novas-guia-de-estilo-e-piloto]]"
  - "[[ART-PROMPTS-028-hqs-onda-1]]"
  - "[[ART-PROMPTS-029-hqs-onda-2]]"
  - "[[SPEC-099-integracao-hqs-hqn-11-a-14]]"
  - "[[EVID-128-integracao-hqs-hqn-11-a-14-2026-09-30]]"
  - "[[EVID-111-hqn-02-candidatas-2026-09-29]]"
  - "[[EVID-112-hqn-03-candidatas-2026-09-29]]"
  - "[[EVID-113-hqn-04-candidatas-2026-09-29]]"
  - "[[EVID-114-hqn-05-candidatas-2026-09-29]]"
  - "[[EVID-115-hqn-06-e-onda-1-candidatas-2026-09-29]]"
  - "[[EVID-116-hqn-07-candidatas-2026-09-29]]"
  - "[[EVID-117-hqn-08-candidatas-2026-09-29]]"
  - "[[EVID-118-hqn-09-candidatas-2026-09-29]]"
  - "[[EVID-119-hqn-10-candidatas-2026-09-29]]"
  - "[[EVID-123-auditoria-de-proporcao-e-identidade-das-hqs-2026-09-29]]"
  - "[[EVID-130-admissao-arte-hqn-01-a-10-2026-09-30]]"
  - "[[EVID-131-implementacao-hqn-01-a-10-2026-09-30]]"
  - "[[SPEC-080-hqs-de-transicao-do-nottcard]]"
---

# SPEC-100 — Integração das HQN-01 a HQN-10

## Descoberta

- A branch `codex/hq-story-integration` já contém o leitor, a aba Diário e as
  HQN-11 a HQN-14 (16 imagens), integradas aos gatilhos de conquista existentes.
- Há 40 candidatas para HQN-01 a HQN-10, quatro por história, em
  `.atena/generated/art-candidates/hq/`. O conjunto contém versões revisadas;
  a execução deve selecionar somente a variante aprovada em cada evidência e
  preservar todas as candidatas originais. Não gerar imagens novas.
- A auditoria EVID-123 aprovou seis variantes v02 para corrigir proporção e o
  visual canônico de Leoric; essas versões substituem as v01 correspondentes
  apenas nos destinos do jogo.
- `PLAN-040` já registra o mapa narrativo e os gatilhos, mas seu cabeçalho ainda
  diz que nada foi gerado ou implementado. `ART-PROMPTS-028` também tem status
  operacional desatualizado. Reconciliar esses estados após a execução sem
  reescrever o conteúdo aprovado.
- O vault externo de Nottgard referido pelos prompts não está montado neste
  ambiente. Para este lote, tratar os prompts, as legendas e as aprovações locais
  como fonte congelada; não acrescentar nem alterar lore.
- As HQs antigas `hq_001` a `hq_003` permanecem fora deste lote enquanto D1–D5
  da SPEC-080 aguardam decisão. HQN-15 a HQN-18 também ficam fora: são opcionais,
  ainda sem candidatas geradas e dependem de decisão econômica separada.

## Interpretação e escopo

Completar a integração do arco principal HQN-01 a HQN-14, acrescentando HQN-01
a HQN-10 às quatro histórias já jogáveis. Usar 40 imagens aprovadas, sem
redimensionar ou editar os PNGs. Reutilizar o leitor e o Diário existentes.

Gatilhos propostos, conforme PLAN-040:

| HQ | Gatilho |
|---|---|
| HQN-01 | Primeira run de um perfil (abertura) |
| HQN-02 | Primeira vitória em Docas |
| HQN-03 | Primeira entrada em Shedaklah |
| HQN-04 | Primeira vitória em Shedaklah |
| HQN-05 | Primeira vitória em Molor |
| HQN-06 | Primeira vitória em Durão (`durao`) |
| HQN-07 | Primeira vitória em Feng-tu (`feng_tu`) |
| HQN-08 | Primeira vitória em Shendilavri (`shendilavri`) |
| HQN-09 | Primeira vitória em Goranthis (`goranthis`) |
| HQN-10 | Primeira vitória final nos Pilares (`pilares`) |

Exibição e estado:

- Mostrar HQN-01 como abertura da primeira run. As HQs ligadas a uma fase
  aparecem quando o marco é alcançado, antes de continuar a run; HQN-10 aparece
  após a vitória final. Cada abertura pausa o jogo, pode ser pulada com Esc e
  usa a fila em ordem de campanha se vários marcos ocorrerem juntos.
- Registrar HQs concluídas em `profile.data.hqs_seen`. Completar o último quadro
  conta como vista; pular com Esc não conta para conquistas por leitura. Fazer
  a chave surgir em perfis novos e migrar com valor vazio em saves antigos.
- Registrar `stats.reached` e `cleared` no instante em que o marco acontece,
  antes de abrir a HQ. São campos já existentes; assim a entrada no Diário e a
  progressão da fase não dependem do fim da run.
- O Diário lista HQs liberadas pelo progresso existente e permite reassisti-las.
  Para saves antigos, marcos já cumpridos liberam acesso no Diário, mas não
  disparam reprodução retroativa automática. HQs ainda não liberadas ficam
  ocultas, mantendo o comportamento aprovado na SPEC-099.
- Preservar HQN-11 a HQN-14 e seus gatilhos atuais. `hqs_seen` também permite
  contar leituras de todo o arco para as conquistas narrativas aprovadas em
  PLAN-040. Incluir neste lote **Cronista de Nottgard** (5 HQs concluídas, 300
  moedas). Adiar **Guardião com Broche** e **Arquivo Completo** até a decisão e
  integração das HQs Nottcard necessárias; não criar conquistas impossíveis de
  obter.

## Não objetivos

- Não gerar, redesenhar, redimensionar ou sobrescrever arte aprovada.
- Não alterar textos, falas, sequência narrativa, cânone ou restrições dos
  prompts aprovados.
- Não integrar HQN-15 a HQN-18 nem `hq_001` a `hq_003` nesta SPEC.
- Não mudar as quatro HQs HQN-11 a HQN-14 já integradas, exceto a leitura
  compartilhada do estado de HQ concluída necessária para a conquista Cronista.
- Não publicar, criar PR ou fazer merge como parte do plano.

## Critérios de aceite

1. HQN-01 a HQN-10 aparecem em `data/hqs.json`, cada uma com quatro imagens
   válidas e legendas aprovadas; os 40 destinos correspondem às candidatas
   selecionadas por SHA-256.
2. Cada gatilho da tabela funciona uma única vez em perfis novos, no momento
   definido; HQN-11 a HQN-14 mantêm o comportamento existente.
3. `hqs_seen` registra leituras completas, aciona Cronista de Nottgard uma vez e
   não contabiliza HQ pulada.
4. Perfil antigo sem `hqs_seen` carrega sem perda ou erro; progresso já obtido
   revela HQs no Diário, sem reprodução retroativa automática.
5. Clique/Enter/Espaço avançam, Esc pula, as imagens não são distorcidas nem
   cortadas em 1280×720 e 1920×1080, e o Diário não mostra HQs bloqueadas.
6. Testes cobrem gatilhos de fase/primeira run, conquistas por leitura, saves
   antigos, fila, skip, replay e regressão das HQN-11 a HQN-14; suíte e smoke
   testam sem alterar saves reais.
7. Evidência registra variantes, hashes, testes e commits. Arte e mecânica ficam
   separados; sem push/PR/merge sem autorização específica.

## Impactos

- Admitir 40 PNGs e seus metadados de importação em `assets/hq/`.
- Estender `data/hqs.json` e `core/hq_catalog.gd` para `first_run`,
  `stage_reached`, `stage_cleared` e vitória final, mantendo `achievement`.
- Acrescentar `hqs_seen` com migração segura, contagem de leituras e a conquista
  Cronista de Nottgard; atualizar o Diário e o fluxo de run.
- Não usar o CLI de vendoring externo: as imagens são candidatas locais,
  aprovadas e pertencentes ao projeto. Validar por SHA-256 e importação Godot,
  sem alegar recibo externo.
- Continuar a branch de integração já publicada; criar commits locais separados
  para arte e mecânica após a aprovação deste plano. A publicação fica fora do
  escopo até pedido específico.

## Plano de voo

1. Após aprovação, reconciliar os estados operacionais de PLAN-040 e
   ART-PROMPTS-027/028/029; confirmar, por evidência, as 40 variantes aprovadas.
2. Copiar as 40 imagens finais para `assets/hq/hq_n<nn>_q<n>.png`; conferir
   dimensões e paridade SHA-256. Fazer commit de arte isolado.
3. Expandir catálogo, detecção de marcos, abertura/fechamento das HQs,
   `hqs_seen`, migração do perfil e Cronista; preservar HQN-11 a HQN-14.
4. Testar cada transição, saves antigos/novos, leitura parcial versus completa,
   Diário/replay e layout; executar suíte completa e smoke test.
5. Revisar escopo e links, criar evidência final e reconciliar SPEC-100. Commit
   de mecânica separado. Sem push, PR ou merge sem autorização adicional.

## Evidência e reconciliação

Execução e verificação concluídas em 2026-09-30. Consultar EVID-130 para as
variantes finais e hashes, e EVID-131 para critérios, testes e reconciliação.

- Arte: `e03942f` — `Add approved HQN-01 to HQN-10 artwork`.
- Mecânica e documentação: `001b1a6` —
  `Integrate HQN-01 to HQN-10 story comics`.
- Não houve push, PR ou merge.
