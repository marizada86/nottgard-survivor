# ASSET-LOT09/v01 — sete pontos, 28 poses

DRAFT. Origin planned; implementation_preceded_spec false. PLAN_CHANGE_REQUEST: extensão de animação ART-032 após aceite visual LOT08 (“aprovado, continue”). Continuação autoriza inventário/proposta; novo escopo aprovado explicitamente em2026-10-16 (“aprovado”), antes da produção. Modalidade per-plan já escolhida e preservada. Claude permanece responsável por implementação. PLAN-103 e outras frentes preservados.

## Autoridade e prontidão

[PLAN-001 CANON de estilo](../../vault/canon/PLAN-001-nottgard-survivors.md), [pontos DRAFT aceitos](../../vault/drafts/PLAN-ART032-PONTOS-v01.md), [admissão estática](../../vault/drafts/PLAN-ART032-IMPLEMENT-v01.md), [SPEC-118](../SPEC-118-acontecimentos-exclusivos-por-fase.md) e `data/stage_events.json`. Sete referências runtime inspecionadas; snapshot com hashes em [references.json](../../generated/asset-lot09-2026-10-16/references.json). Busca nominal em `assets/animations/interactions/` não encontrou esses sete ciclos; reconfirmar candidatos/outras frentes antes da primeira geração. Não repetir estáticos nem produzir novos personagens. Não há necessidade de lore externa adicional; vault/Nottcard permanecem somente leitura.

## Bíblia e escopo DRAFT v01

Fantasia sombria isométrica, câmera e silhueta da referência, luz superior esquerda, clusters de pixel e materiais gastos. Uma folha por entrada, quatro poses reais em linha4×1; repouso antes da interação, sem ativação, recompensa, coleta, combate ou transformação narrativa. Objetos estruturais permanecem imóveis; variar somente elementos orgânicos/luz existentes. Sem cenário, chão/sombra projetada, texto, runas novas ou símbolos novos. Fundo transparente, sólidos opacos; brilho restrito ao motivo existente. Identidade pessoal/figurino N/A em seis objetos; identidade biológica aplicável à massa dormente, preservando casulo/olhos existentes. Posição no mapa não é requisito; contextos abaixo delimitam a cena.

| Código | Referência readonly | Movimento proposto / contexto |
|---|---|---|
| EP01 | assets/interactions/trono_zuggtmoy.png | Trono vazio de madeira e micélio malva, destino do pedido de Zuggtmoy. Madeira/assento/raízes fixos, variação mínima das bordas dos fungos; sem soberana ou nuvem de esporos. |
| EP02 | assets/interactions/arco_pedra.png | Arco fechado/inativo de pedra musgosa. Estrutura e face central opacas, somente oscilação tonal mínima nas fissuras já existentes, sem portal aberto ou novo glifo. |
| EP03 | assets/interactions/massa_thullgrime.png | Massa dormente oliva/malva, casulo central e olhos existentes. Pulsação pequena do gel/casulo, sem crescer, despertar, acrescentar olhos/membros ou virar chefe. |
| EP04 | assets/interactions/estrela_do_norte.png | Estrela azul-clara de peregrinação, silhueta e centro fixos, pulsação pequena da luz e raios existentes; sem rotação/translação ou oito pontas inventadas. |
| EP05 | assets/interactions/coracao_limo.png | Núcleo ovoide verde compacto de coleta, centro luminoso pulsa discretamente; sem órgão humano, nova anatomia ou gotas destacadas. |
| EP06 | assets/interactions/esporo_zuggtmoy.png | Cápsula fúngica malva perfurada com base curta, leve expansão/contração; sem abrir, liberar nuvem ou mudar para cogumelo diferente. |
| EP07 | assets/interactions/limo_juiblex.png | Porção baixa de gel oliva com filamentos, pequena ondulação interna/reflexos; base e extensão contidas, sem face/olhos/núcleo ou movimento de criatura. |

Sete fontes,28poses, sete players numa galeria única. As animações são hipóteses DRAFT novas, não CANON nem implicitamente aceitas pela aprovação dos estáticos. EP02 pode ter variação muito discreta: não inventar magia para tornar movimento evidente.

## Etapas, checks e recuperação

1. S-001 prontidão/proposta: sete referências/contextos inspecionados e hashes persistidos. Aprovação específica recebida; nenhuma lacuna BLOCKING textual de produção. Sem lacunas textuais impeditivas para ensaio DRAFT após aceite.
2. S-002 produção: built-in imagegen, uma folha por chamada, quatro colunas numa linha, alvo1536×1024; registrar dimensões reais, sem prometer tamanho. Células com largura inteira, motivo inteiro com margens≥48px, base/escala fixas e retorno4→1. Até três tentativas por fonte por defeito objetivo, máximo21chamadas; persistir prompts/revisões/bytes nativos. Sem variantes extras ou gate por fonte.
3. S-003 auditoria: quatro poses efetivas, geometria da folha, arma N/A, silhuetas/identidade, alfa/margens, base/escala, continuidade4→1. Previews48/80/128px conforme leitura e contatos sem esticar. Poses distintas não são demonstradas somente por hash diferente. Estrutura do arco/trono não deve deformar. Um defeito persistente após limite gera retenção seletiva; não repetir além do orçamento ou fabricar quadros por recorte. Resíduos de alfa/pivô demandam notas explícitas, sem PASS de admissão.
4. S-004 entrega: fontes em `.atena/generated/animation-candidates/asset-lot09/`; galeria em `.atena/generated/asset-lot09-2026-10-16/`, sete players com pausa/replay/FPS/repetição/scrub, manifestos/hashes/prompts/evidência e handoff local para Claude. Conferir caminhos/controles, distinguir DOM offline de render real. Parar no aceite visual conjunto; aceite parcial por código/revisão permitido.

RESOLVABLE: margens, alfa, movimento discreto, registro e retorno. DEFERRED: CANON, preparação/pivôs/escala, consumer, admissão, implementação, ativação/coleta, playtest e métricas de diversão. Recuperação preserva fontes versionadas e referências/hash; não substituir assets atuais. Novo escopo não altera arquitetura/mecânica/código/dados, não fecha bugs ou retenções antigas. Sem dependências, commit, push, merge, exportação, publicação ou mensagem a Claude. Aprovação per-plan autorizará somente estas quatro etapas; gate visual posterior permanece independente.


Resultado:4/4 etapas concluídas, sete fontes/28poses em dez tentativas. EP01v03,EP02v02,demaisv01. Margens/alfa/registro pendentes, aceite visual conjunto PENDING. Evidência: ../../evidence/asset-lot09-event-points-2026-10-16.md.

Aceite posterior2026-10-16: 'aprovado, continue'. Direção visual das sete revisões selecionadas/28poses aceita DRAFT; visual-acceptance.json no pacote. Supera PENDING visual anterior, preserva preparação/registro e ausência de admissão/CANON. Implementação com Claude.
