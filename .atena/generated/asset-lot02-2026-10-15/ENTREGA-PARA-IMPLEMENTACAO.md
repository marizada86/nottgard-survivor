# ASSET-LOT02/v01 — entrega de fontes

Estado DRAFT. Cinco fontes, seis assets. Direção visual das seis entradas v01 aceita pelo dono em 2026-10-16: "atena aprovado agora vamos para o item CHATGPT-FILA-032". [Recibo](visual-acceptance.json). Implementação atribuída a Claude; este arquivo é entrega local, não envio nem confirmação de execução por outro agente.

| Código | Fonte original | Papel/extração futura |
|---|---|---|
| UI01 | [UI01_v01.png](../art-candidates/asset-lot02/UI01_v01.png) | Moldura de progresso; canal preto sem preenchimento |
| UI02-A | [UI02_v01.png](../art-candidates/asset-lot02/UI02_v01.png) | Losango âmbar na metade esquerda (x=0..886) |
| UI02-B | mesma fonte UI02 | Caveira na metade direita (x=887..1773) |
| UI03 | [UI03_v01.png](../art-candidates/asset-lot02/UI03_v01.png) | Casela bloqueada com silhueta/cadeado |
| UI04 | [UI04_v01.png](../art-candidates/asset-lot02/UI04_v01.png) | Casela desbloqueada de centro livre |
| PR01 | [PR01_v01.png](../art-candidates/asset-lot02/PR01_v01.png) | Reparo de pilar_01 com capitel/base inteiros |

[Manifesto](manifest.json), [inspeção](inspection.json), [galeria conjunta](index.html), [prompts](prompts.md). Hashes por fonte; UI02-A/B compartilham um hash. Originais preservados. Referências originais mantidas e conferidas por hash.

## Contratos de integração, ainda pendentes

UI: ART-PROMPTS-043 / FILA-012 U01..U04. Dimensões nativas não são dimensões finais de interface. As fontes têm magenta, alfa totalmente opaco; remover o fundo/halo preservando interior e metal. Recortes das prévias são diagnósticos com limiar amplo, não máscaras prontas. UI01 objeto ~9,21:1 difere de 8:1; UI03/UI04 têm caixa ~1,03:1. Decidir ajustes limitados na preparação e pedir aceite de derivadas quando alterar direção.

SPEC-163 e `ui/stage_progress.gd` descrevem barra atual com 4 px. Esta produção de moldura não autoriza aumentar, mover ou substituir o layout por conta própria. Definir adaptação no plano da implementação. Catalogo: `ui/pause_menu.gd` e `ui/menu.gd`; manter ícones reais visíveis e estado bloqueado claro. Tamanho dos marcadores e teste sobre HUD real continuam pendentes; a caveira é mais ornamentada que o losango, portanto conferir leitura a tamanho final. Sem mecânica nova nem mudança de progressão.

PR01: fonte RGBA nativa, manter transparência; não remover preto. Caixa por alfa≥16 x=428/y=80/w=397/h=1099. Há traços residuais de alfa baixo fora da caixa (a caixa alpha>0 é mais ampla), e o corpo amostrado tem alfa 252..253, não 255. Auditar suporte de alfa, limpar apenas ruído externo de forma controlada e tornar materiais sólidos opacos quando autorizado, preservando furo da argola/contorno. Não declarar alfa final pronto com base na prévia. Alvo de referência futuro 256×256; preservar margens e capitel/base inteiros, manter ponto de contato no chão e escala da família. `assets/props/pilar_01.png` é o destino de referência após aprovação de admissão; `ui/prop.gd` usa variantes e a variante 1 foi retirada como paliativo. Reintrodução ao sorteio/âncora pertence à implementação. Não acrescentar corrente da variante 3.

Antes de integrar, confirmar autorização de admissão e escopo dos consumers na frente responsável. Assets oficiais, código, dados, layout e referências não foram alterados aqui. Checks apropriados de importação, render, controle/toque/layout e suíte/smoke cabem à implementação. Leitura subjetiva e experiência em jogo exigem feedback humano. Commit, push, exportação e promoção canônica não estão autorizados por esta entrega.
