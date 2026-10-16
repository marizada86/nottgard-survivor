# ASSET-LOT03/v01 — seis sequências de interações

Estado DRAFT. Seis fontes v01 / 29 quadros, direção visual aceita pelo dono em 2026-10-16: "aprovado, deixe a implementação para o claude, continue a produção". [Recibo](visual-acceptance.json). Nenhuma fonte ou sequência admitida em runtime. Implementação atribuída a Claude pelo dono. Este documento é entrega local, não confirmação de envio, implementação ou aceite de outro agente.

| Código | Fonte preservada | Grade nativa | Quadros |
|---|---|---|---:|
| IA01 | [Baú comum](../animation-candidates/asset-lot03/IA01_v01.png) | 1536×1024, 3×2, células 512×512 | 6 |
| IA02 | [Baú de chefe](../animation-candidates/asset-lot03/IA02_v01.png) | 1536×1024, 3×2, células 512×512 | 6 |
| IA03 | [Loja](../animation-candidates/asset-lot03/IA03_v01.png) | 1254×1254, 2×2, células 627×627 | 4 |
| IA04 | [Ferreiro](../animation-candidates/asset-lot03/IA04_v01.png) | 1254×1254, 2×2, células 627×627 | 4 |
| IA05 | [Curandeiro](../animation-candidates/asset-lot03/IA05_v01.png) | 1254×1254, 2×2, células 627×627 | 4 |
| IA06 | [Barril](../animation-candidates/asset-lot03/IA06_v01.png) | 1536×1024, 3×2, células 512×512; última célula excluída | 5 |

[Galeria/reprodutores](index.html), [manifesto](manifest.json), [contagens e hashes](inspection.json), [prompts](prompts.md), [checagem offline do player](player-check.json). As células em frames/ são extrações brutas para QA, não arquivos de animação final. Fontes/referências preservadas por SHA-256. Não recortar 512×512 de uma fonte de 1254×1254: as células dos NPCs são 627×627.

## Pendências de preparação, sem esconder problemas na prévia

- Base do contorno com alfa≥128 varia 22/33/1/8/2/36 px respectivamente em IA01..IA06. Essa métrica inclui o contorno todo, não é anotação semântica de ponto de contato. Confirmar pivôs do corpo estático antes de alinhar. Variação no entulho IA06 tem componente intencional de queda; não recentralizar cada pedaço independentemente nem nivelar toda a silhueta para cima.
- Alfa modal do conteúdo ≥128 é 253 no primeiro quadro de todas as fontes, e existem pixels alfa 1..15 fora do corpo. Não são PNGs finais com materiais sólidos estritamente alfa255. Auditar e corrigir alfa dos materiais sólidos de forma autorizada, preservando vapor/chama/aberturas e bordas. Fontes não foram deschaveadas nem alteradas; não há fundo de cor para remover. Evitar limiar global que destrua vapor do curandeiro ou brilho contido do baú de chefe.
- A sexta célula de IA06 não tem pixels alfa≥16, mas tem 1962 pixels alfa1..15. Excluir essa célula da sequência de cinco quadros; não transformá-la em pose final ou quadro de desaparecimento inventado.
- IA01: conferir o momento em que moedas são reveladas; no quarto quadro o interior aparece escuro, moedas visíveis nos finais. IA02: verificar ferragens/correntes e luz interna ao abrir. IA03: movimento discreto, conferir se retorna ao repouso sem salto. IA04: verificar mão/martelo e estabilidade da estação. IA05: conferir dedos/gestos e continuidade do vapor. Não aceitar diversidade de hashes como prova de movimento correto.

O plano histórico usa células finais 192×192 para interações, mas os NPCs atuais têm cenário próprio detalhado. Não impor essa redução sem confirmar escala/consumer na implementação. Baús devem conectar aos estáticos fechado/aberto e manter base; idles retornam ao início; barril termina assentado. Preservar identidades e não acrescentar lore, armas, símbolos ou produtos.

Antes de integrar: confirmar autorização/escopo de admissão na frente responsável; preparar tiras/versionamento/pivôs e teste visual contra estáticos. Destinos/consumers a confirmar (overlay/interações/props). Não substituir automaticamente portal, altar, fonte ou folhas existentes. IA01 é candidata de correção do chest_open antigo; resto acrescenta sequências próprias ao inventário de interações.

FPS 2/4/8/10/12 da galeria são apenas opções de inspeção; 8 FPS é padrão do reprodutor, não decisão de runtime. Transições não voltam ao início por padrão; botão Repetir serve para comparação. A reprodução usa células nativas sem correção de base, para expor saltos. Checagem offline do player testa lógica, caminhos e controles; o adaptador do navegador não inicializou nesta sessão, portanto não declarar screenshot/render de navegador conferido. Contatos PNG foram inspecionados visualmente.

Aceite de direção/poses do dono registrado; as pendências técnicas acima não foram dispensadas. Em jogo, a frente de implementação deve apresentar build/escopo/objetivo/procedimento/critérios antes do playtest. Consistência técnica não prova fluidez, peso ou diversão. Nenhuma alteração de assets oficiais, código, dados, cânone, commit, push, merge ou exportação nesta produção.
