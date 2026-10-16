# ASSET-LOT03/v01 — seis animações de interações

Estado DRAFT. Origin planned; implementation_preceded_spec false. Pedido em 2026-10-16: "aprovado, commit e vamos continuar a produção". LN01 v01 aceita e entregas anteriores commitadas em 16fbcf0a. Escopo deste conjunto aprovado pelo dono com "aprovado por plano", em 2026-10-16. Classificação PLAN_CHANGE_REQUEST da frente de produção, sem substituir PLAN-103. Implementação atribuída pelo dono a Claude.

## Escopo: seis fontes / seis sequências / 29 quadros

| Código | Sequência | Quadros | Grade-fonte proposta |
|---|---|---:|---|
| IA01 | Baú comum abrindo | 6 | 3×2 |
| IA02 | Baú de chefe abrindo | 6 | 3×2 |
| IA03 | Loja em repouso | 4 | 2×2 |
| IA04 | Ferreiro em repouso | 4 | 2×2 |
| IA05 | Curandeiro em repouso | 4 | 2×2 |
| IA06 | Barril rompendo | 5 | 3×2, sexta célula vazia |

Origem: ART-022 e [PLAN-041 de animação](../../vault/drafts/PLAN-041-animacao-padrao-zumbi-para-inimigos-e-interacoes-2026-09-29.md), que propõe 6 quadros de abertura, 4 de idle dos três NPCs e perfil D de 5 quadros de quebra. Referência técnica histórica: [ART-PROMPTS-014](../../generated/ART-PROMPTS-014-animacao-dagruve-piloto.md) e [SPEC-017](../SPEC-017-piloto-animacao-dagruve.md). Corrigir o baú comum é motivado pela solidez problemática descrita no PLAN-041; sua animação antiga já existe. Baú de chefe, três NPCs e barril não têm folhas próprias nos caminhos/nomes consultados. Não considerar buscas por nome uma prova de inventário global perfeito; confirmar novamente antes de produzir.

Altar fora deste lote: já possui fonte/preparação aceita na FILA-028; portal, ritual e fonte mantidos conforme recomendação histórica, sem defeito novo comprovado. Camadas de cenário ART-PROMPTS-026 já têm 27 imagens admitidas; não regerar. Não incluir lança-chamas MEC-004 nem heróis M1.

## Bíblia visual e identidades — DRAFT v01

As oito referências estáticas locais foram inspecionadas antes desta proposta: `assets/interactions/chest_closed.png`, `chest_open.png`, `bau_chefe_fechado.png`, `bau_chefe_aberto.png`, `loja.png`, `ferreiro.png`, `curandeiro.png` e `assets/props/barril_01.png`. São identidades existentes; não inventar nomes, lore ou equipamento. Conferir hashes antes/depois da produção. Fonte cortada/folha animada problemática não substitui a referência estática de identidade.

Família: pixel art densa pintada, fantasia sombria, câmera isométrica 2:1, luz superior esquerda, materiais sólidos e detalhe compatível com os PNGs. A câmera e a composição não passeiam entre quadros. Corpo/equipamento/estrutura devem permanecer opacos; alfa verdadeiro somente no vazio/efeitos que o exigem. Nenhuma sombra de chão nova ou cenário. Grades com células de 512×512 e corredores transparentes internos de segurança, mesma escala, pivô e linha de apoio em cada célula; reduzir depois é responsabilidade da preparação. Nativo solicitado não é dimensão garantida pelo gerador.

- IA01: baú de madeira castanha com ferragens escuras. Fechado → trava cede → tampa começa a levantar → abertura maior → moedas visíveis → aberto igual à referência, sem trocar modelo/câmera. Sem brilho mágico acrescentado ao baú comum. Corpo e fundo de madeira opacos.
- IA02: mesmo princípio com o baú ornamentado de chefe, madeira/ferro/ouro, moedas e brilho dourado contido do aberto já existente. Diferenciar do baú comum, sem mudar brasões ou acrescentar símbolos.
- IA03: comerciante anônimo encapuzado sob toldo vermelho; balcão, moedas, frascos e lanterna fixos. Respiração e pequeno movimento das mãos/capa, sem mudar posição ou acrescentar produto. Quarto quadro retorna próximo ao primeiro para loop. Contexto: interação de loja no mapa.
- IA04: ferreiro anônimo encapuzado, bigorna, martelo, armas apoiadas e fornalha existentes. Pequeno ciclo de trabalho/repouso de quatro poses, mão/martelo com arco curto e retorno; bigorna/base/forja imóveis. Sem novo ataque/arma ou fogo fora do equipamento. Contexto: evento de forja.
- IA05: curandeiro anônimo de capuz verde, ervas, caldeirão e mesa de poções. Respiração/pequeno gesto sobre caldeirão e vapor discreto; corpo/caldeirão sólidos, móveis/base imóveis, sem magia nova nem novas divindades. Retorno ao início. Contexto: evento de cura.
- IA06: barril vertical castanho com aros de ferro e corda na base. Intacto → impacto/trinca → ruptura → aduelas se separam → escombros assentados. Sem fogo, sangue ou explosão mágica. Conservar localização da base e não vazar para células vizinhas; sexta célula totalmente vazia. Contexto: destruição de prop.

Identidade de entidade é aplicável para objetos/NPCs, estruturada acima; não se usa N/A genérico. Contexto de cena textual basta: todos são isolados no mapa, câmera fixa, sem produzir uma nova cena completa. Todas as fontes/folhas seguem DRAFT e o aceite prévio dos estáticos não aprova as novas poses.

BLOCKING visual: nenhuma lacuna textual para ensaio DRAFT; aprovação específica recebida. RESOLVABLE: grade/câmera, anatomia/mãos, quantidade, contorno e consistência; corrigir com até três tentativas por fonte, cada uma por defeito objetivo, reter se persistir. DEFERRED: admissão, recorte/alinhamento definitivos, parâmetros runtime, fluidez e aparência em jogo, alteração dos consumers. As seis fontes v01 foram entregues com pendências explícitas de alinhamento e alfa, sem PASS de admissão.

## Etapas e checks

1. S-001 — contrato, inventário mínimo, referências e proposta: concluído. Fontes existentes revistas visualmente. Resultado: seis peças definidas; objetivo seguinte é a produção autorizada.
2. S-002 — gerar as seis folhas com imagegen integrada, uma chamada por sequência com suas referências declaradas; PNG original em `.atena/generated/animation-candidates/asset-lot03/`, versionado. Sem pedir aprovação por imagem dentro do plano; preservar tentativas e motivos. Usar alfa nativo, sem apagar conteúdo para esconder falha de identidade ou anatomia.
3. S-003 — conferir quadros/grade/corredores, mesma identidade/material/câmera/base, corpo sólido e anatomia. Extrair apenas prévias de QA em células fixas, contato e reprodutor HTML a 8/10/12 FPS para inspeção, sem declarar arquivo final normalizado. Se a grade divergir, registrar/ajustar extração explicitamente ou reter; não inventar quadros. Hashes de fontes e referências, dimensões e limites no manifesto. Julgamento de fluidez é humano; modelo só verifica consistência observável.
4. S-004 — galeria conjunta das seis sequências, manifesto com contagem de frames e versões, prompts e evidência, entrega local para Claude. Aceite por código/revisão, permitindo retenção parcial; parar nesse checkpoint. Quando houver teste em jogo, a frente responsável deve informar build, objetivo, procedimento e critérios antes do playtest.

Antes do aceite: sequência de baú deve ligar fechado/aberto, idles devem voltar ao início sem salto evidente, barril deve terminar assentado; sem repetição de pose apresentada como movimento novo. Métricas automáticas não comprovam fluidez ou prazer. Sem integração, assets oficiais/código/dados, novas dependências, cânone, commit/push/exportação ou envio a outro chat. Preservar originais e trabalhar em novas revisões; reverter somente arquivos novos da produção quando necessário, nunca apagar fontes aceitas. Claude confirma plano/autorização de admissão na frente de implementação. Retorno PLAN-103 e demais frentes mantidos.
