# PLAN-053 / DEV-024 — exceção de variação AO04/AO07, v01

Data: 2026-10-13. Intenção **DRAFT**, proposta pendente de aprovação, modalidade **per-plan** já escolhida pelo dono. Retomada “atena, continue” classificada IN_PLAN para examinar a próxima pendência; a exceção proposta é PLAN_CHANGE_REQUEST por alterar dois critérios de aceite. Nenhuma exceção ou aprovação visual é inferida do pedido de continuar.

## Problema e revisão concreta

AO04 (`move_se`) e AO07 (`move_n`, de costas), candidatas **body-pivot-v01/v02**, já foram preparadas no escopo aprovado e permanecem retidas. Mediana corporal 290 px, escala proporcional única por tira, seis quadros por tira, células 256×384 e sola-alvo y=368. A variação corporal raster é 14 px em AO04 e 13 px em AO07; o contrato [ART-PROMPTS-060](../../generated/ART-PROMPTS-060-erik-e-arlindo-jogaveis.md) estabelece `height_spread ≤12 px`. Os demais critérios estruturais medidos passaram. Revisão e hashes: [review.json](../../generated/hero-spread-review-2026-10-13/review.json); [galeria específica](../../generated/hero-spread-review-2026-10-13/index.html).

Autoridade visual: [PLAN-001 CANON](../../vault/canon/PLAN-001-nottgard-survivors.md), [SPEC-160](../SPEC-160-arlindo-orlando-e-erik-blackthorn-jogaveis.md), identidade e alvos em ART-PROMPTS-060, primeiras tiragens DRAFT locais e [contrato body/pivot](hero-body-pivot-v01.md). Arlindo: chapéu marrom, sobretudo de gola alta, cachecol vinho, luvas, mãos livres. Cena de revisão: corpo inteiro isolado, câmera isométrica, luz do alto esquerdo, fundo escuro e preview corporal de 85 px. Não há nova lore, mudança de identidade ou promoção de aparência. Vault/Nottcard somente leitura.

## Alteração limitada proposta

Aceitar visualmente as duas candidatas existentes **somente se o dono aprovar também a exceção**: máximo 14 px de variação para AO04 v02 e 13 px para AO07 v02, nos hashes exatos registrados. O limite global de 12 px permanece; não generalizar a outras revisões ou tiras. Registrar o resultado como DRAFT visualmente aceito **com exceção**, mantendo a falha original visível. Nenhum falso PASS sem ressalva.

O excesso é 2/1 px nas células e aproximadamente 0,586/0,293 px quando o corpo-alvo mede 85 px. Essa redução não demonstra qualidade da passada ou ausência de oscilação perceptível. O dono avalia porte/figurino, direção, movimento e continuidade junto ao idle; o playtest futuro continua pendente. A correção de passada anteriormente cancelada não é reaberta.

Escopo posterior à aprovação: recibo com hashes dos dois atlas e doze quadros, inventário novo totalizando 14 tiras/76 quadros, evidência e estado operacional. Preservar o inventário histórico 12/64 e recibos anteriores. Se a exceção não for aprovada, manter AO04/AO07 retidas e preparar outra rota antes de alterar desenhos. Não gerar, redimensionar, deformar ou repintar PNGs neste plano. Sem integração, CANON, commit, push, build ou exportação; sem dependências/arquitetura novas.

## Sequência e critérios

| Ordem | Etapa estável | Objetivo / saída / checagem |
|---|---|---|
| 1/3 | S-001 REVIEW_EXISTING | Conferir fontes, 2 atlas/12 células, escala, mediana, margem/base, 12 tiras aceitas e links; galeria e proposta concretas. Concluída. |
| 2/3 | S-002 OWNER_EXCEPTION_GATE | Aceite explícito de AO04/AO07 v02 **e** exceção 14/13 px; pendente. Manter DRAFT. |
| 3/3 | S-003 RECEIPT_INVENTORY | Após aprovação, confirmar novamente hashes, registrar exceção e inventário 14/76, reconciliar evidência e estado. Não modificar os recibos históricos. |

BLOCKING: decisão S-002 para executar a exceção. RESOLVABLE: registro após resposta. DEFERRED: AO09/AO10 (separação ambígua), ER03 (sete poses), ER06 (corte na fonte), admissão e playtest. As quatro wide v01 aceitas e as oito candidatas v02 aceitas são preservadas. Retorno anterior PLAN-071 e cauda operacional existentes permanecem íntegros.

Recuperação: novos registros em pacote específico; nenhum raster ou runtime modificado. Atena é responsável pelos registros; integração futura exige gate próprio. [AGENTS.md](../../../AGENTS.md) determina para PLAN_CHANGE_REQUEST: “The replacement needs approval.” A proposta altera o critério destas duas peças; a autorização anterior para preparar e o aceite das quatro wide não cobrem essa exceção.

## Resultado do checkpoint

2026-10-13: **“Aprovo as duas v02 com exceção de 14/13 px (recomendado)”**. S-002 aprovada explicitamente; S-003 concluída após reconferir hashes e registrar recibo/inventário 14/76. Plano 3/3 concluído, exceção limitada aos hashes de AO04/AO07 v02. Sem alteração do critério global, PNG, runtime, CANON ou Git. Os textos de pendência acima descrevem a proposta antes deste aceite; o registro atual está no [estado](../../state/hero-spread-exception.yaml).
