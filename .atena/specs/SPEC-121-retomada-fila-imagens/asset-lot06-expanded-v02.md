# ASSET-LOT06/v02 — oito fontes / 29 desenhos

DRAFT, origin planned, implementation_preceded_spec false. Substitui a proposta v01 de duas fontes antes de qualquer geração. PLAN_CHANGE_REQUEST pedido "atena estou indo dormir faça um lote maior". Novo escopo e modo aprovados explicitamente em 2026-10-16: "Aprovo as 8 fontes por plano", resposta à lista completa FC01/FC02 e seis idles. Aprovação per-plan; nenhum checkpoint intermediário pendente de escopo. Próximo gate humano é revisão conjunta das oito fontes. Implementação com Claude. PLAN-103, outros planos e gates de runtime preservados.

## Escopo e autoridade

| Código | Conteúdo | Desenhos | Referência/autoridade |
|---|---|---:|---|
| FC01 | Ícone do lança-chamas | 1 | U05, ART-PROMPTS-043; assets/icons/items/adaga.png como estilo |
| FC02 | Jato de chamas em loop | 4 | U06, ART-PROMPTS-043; paleta do FC01, sem desenhar o equipamento |
| IE01 | Altar de doação em repouso | 4 | assets/interactions/doacao.png |
| IE02 | Mesa de aposta em repouso | 4 | assets/interactions/aposta.png |
| IE03 | Ampulheta em repouso | 4 | assets/interactions/ampulheta.png |
| IE04 | Arcanista em repouso | 4 | FILA028 AR01 v02, derivado normalizado aceito |
| IE05 | Peregrino ferido em repouso | 4 | FILA028 EV03 v01, derivado normalizado aceito |
| IE06 | Contador de histórias em repouso | 4 | FILA028 EV04 v02, derivado normalizado aceito |

FC01/FC02: [proposta v01](asset-lot06-flamethrower-v01.md), [ART-PROMPTS-043](../../generated/ART-PROMPTS-043-ui-e-vfx-pendentes.md), [FILA012](../../generated/CHATGPT-FILA-012-ui-e-vfx-pendentes.md). MEC-004 ainda pendente, somente ensaio visual DRAFT antecipado autorizado; não define duração/dano/alcance/divindade. Idles estendem de forma explícita e aprovada a produção de interações ART-022, quatro quadros como os NPCs do LOT03, sem reabrir suas fontes aceitas. Seis PNGs de identidade inspecionados antes da produção; fontes FILA028 de estado CANON_SOURCE_VISUAL_ONLY são referência, novas animações permanecem DRAFT. Preparação histórica aceita em FILA028-PREP; nenhuma admissão automática destas animações. Registrar hashes e caminhos em references.json.

Inventário anterior reconciliado: FILA02236/36 e FILA02360/60 já produzidas; não regenerar. Busca por nomes/estados das seis interações antes de gerar para evitar duplicação. Novo caminho único de candidatas .atena/generated/animation-candidates/asset-lot06/ (substitui caminho proposto art-candidates na v01); entrega .atena/generated/asset-lot06-2026-10-16/.

## Bíblia visual, identidade e cena — DRAFT v02

Pixel art de fantasia sombria, materiais/paleta/câmera da referência específica, luz superior esquerda. Objetos isolados do mapa, sem cenário, chão ou sombras de chão adicionados. Identidade e pose-base conservadas. Câmera/escala/base estáveis nos quatro quadros, quarto retorna próximo do primeiro. PNG transparente nativo, sólidos opacos; chamas, brilho e efeitos podem ter falloff alfa legítimo. Não acrescentar nomes, lore, símbolos, produtos ou personagens.

- FC01: equipamento genérico descrito em U05, tubo de metal escuro/reservatório de óleo/correias de couro, pequena chama âmbar-laranja no bico. Objeto inteiro diagonal, ícone quadrado com folga; adaga é referência apenas de tratamento de materiais. Sem mãos/personagem, sem símbolo divino.
- FC02: identidade de personagem N/A, efeito isolado emitido por bico fora da folha. Jato para direita, núcleo amarelo claro/miolo laranja/bordas vermelho-escuras. Quatro fases U06 fina→língua longa/faíscas→larga/redemoinho→pontas em brasas; comprimento máximo consistente. Origem deliberada no meio da borda esquerda de cada célula, contato nessa borda é previsto; pontas e outras bordas não podem cortar/contaminar células adjacentes. Transparência nativa substitui fundo magenta histórico por aprovação deste plano. Não impor alfa255 ao brilho, não inserir arma no VFX.
- IE01: altar cinza em degraus, painel com mão dourada existente, bacia dourada com energia contida, velas, tecido vermelho, moedas e crânio existentes. Só chamas e pequenos filamentos de luz variam; bacia/pedra/tecido/objetos não mudam ou pulam. Sem ativação, sacrifício ou loot novo.
- IE02: mesa de madeira escura, feltro verde gasto, cartas sem texto legível, dados, moedas, copo e vela. Só chama e brilho discreto variam, objetos fixos. Dados não rolam, cartas não trocam, moeda não surge; não representar resultado de aposta ou mãos.
- IE03: ampulheta alta de pedra/metal escuros, pontas, vidro e areia violeta luminosa. Areia pulsa/flui discretamente, pequenas faíscas próximas; estrutura e nível geral da areia conservados para repouso cíclico, sem virar ampulheta ou representar passagem de tempo/ativação. Sem relógio novo ou símbolo.
- IE04: figura encapuzada em roxo, livro fechado marrom/dourado junto ao corpo, mão direita da imagem elevada com chama violeta. Respiração mínima e chama oscilando, livro/mãos/roupa/equipamento preservados. Não abrir livro, conjurar ataque, criar rosto/equipamento ou trocar gênero/pose.
- IE05: viajante ferido sentado/reclinado junto à pedra alta com musgo, capuz azul, mão no abdômen, botas/faixas, bolsa e bastão existentes. Respiração discreta, cabeça/mão muito sutis sem alterar posição; cenário incorporado à referência (pedra/bolsa) fica fixo, sem novo cenário. Não curar/levantar, mostrar ferida nova, sangue ou mudar estado de quest.
- IE06: contador encapuzado verde-oliva sentado em cepo, rolo/pergaminho no colo e mão aberta elevada, pequena fogueira à direita. Respiração/gesto mínimo e chama, mão/pergaminho/cepo conservados. Sem letras novas, novos interlocutores, produtos ou revelação de rosto.

Sem lacunas BLOCKING de entrada após aprovação recebida. RESOLVABLE durante QA: grade real, margens, quantidade, origem FC02, alfa, posição, base e ciclo. DEFERRED: preparação final, pivôs/escala/redução/temporização/admissão/implementação e playtest humano. FC01/FC02 são antecipação visual sem alterar MEC-004.

## Etapas e recuperação

1. S-001 entradas/impacto/bíblia/checkpoint: concluída, mudança v01→v02 aprovada antes da geração. Oito fontes/29desenhos, até três tentativas por fonte, uma correção objetiva por tentativa, sem pedir aprovação por imagem.
2. S-002 gerar fontes: imagegen, uma chamada por asset; FC01 quadrado1×1; FC02 e IE01..06 quatro poses2×2. Alvo1024×1024/células512, medir dimensões reais sem prometer tamanho. IE: silhueta320–360px por célula, margens≥48px e base localy420, sem contato com divisões. FC02 origem na borda esquerda intencional, distância das outras bordas e comprimento alvo≤420px. PNGs nativos preservados/versionados, nenhuma edição silenciosa de fonte.
3. S-003 QA: medir grade/alfa/margens/base, contar poses e origem, conferir continuidade do estático/loop. Células brutas, contatos e prévias reduzidas do ícone32/48/64. Repetir correções até limite; se persistir problema material, reter código explicitamente, entregar restante sem substituir humano. Hash distinto não comprova ciclo correto. Sólidos quase opacos/ruído e base podem exigir preparação, sem PASS falso de admissão. FC02 alfa variável é esperado, não avaliar VFX como corpo sólido.
4. S-004 galeria conjunta oito peças, sete players com pausa/reinício/scrub/FPS/repetição e ícone estático; manifesto/prompts/hashes/evidência/entrega local para Claude. Validar caminhos/controles e separar DOM offline de render de navegador. Parar na revisão visual conjunta, permitir aceite parcial por código/revisão. Objetivo humano: identidade, legibilidade e continuidade; nenhum playtest nesta galeria.

Fontes e refs readonly, recuperação por revisões e retenção seletiva. Conteúdo DRAFT, sem promoção canônica. Sem assets oficiais/código/dados/dependências, commit/push/merge/exportação/publicação ou envio a Claude. Não agendar automação: execução segue nesta tarefa até a entrega autorizada. Aprovação visual humana não presumida durante ausência do dono.

Resultado:8fontes/29desenhos em12tentativas, S-001..S-004 entregues com FC02 tecnicamente retido por origem e idles pendentes de registro. Ver [evidência](../../evidence/asset-lot06-expanded-2026-10-16.md). Galeria/medidas explicitam critérios não atingidos; não foi atribuído PASS global. Checkpoint humano de revisão conjunta pendente.
