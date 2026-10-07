---
id: EVID-173
created: 2026-10-06
plan: PLAN-066
spec: SPEC-133
checkpoint: B-002 / S-005
request_classification: IN_PLAN
status: REVISION_REQUIRES_WORKFLOW_DECISION
official_assets_changed: false
---

# Revisão da alternância das pernas de Durvall

O dono autorizou seguir as recomendações da EVID-172. Executadas três tentativas de revisão lateral, preservadas como v04, v05 e v06. A alternância anatômica permanece pouco convincente; nenhuma foi selecionada para o teste. O teste jogável continua na v03, revisão 2.

## Candidatas e prompts

Produção via ImageGen integrado e skill imagegen. Referências: arte oficial previamente autorizada e guia de poses local; o vídeo do dono não foi enviado. O guia é um diagrama de produção, com cores temporárias para identificar as duas pernas, não substitui a arte do jogo. Nenhum pixel da arte foi redesenhado por script. A comparação usa regiões brutas das seis células, com redução uniforme apenas para apresentação.

| Tentativa | Estratégia | Imagem e prompt | Resultado da inspeção |
|---|---|---|---|
| v04 | Editar v03 com ordem anatômica explícita e referência E/idle oficiais | [Imagem](../generated/durvall-run-refinement/v01/pilot-e-raw-v04.png), [prompt exato](../generated/durvall-run-refinement/v01/pilot-e-prompt-v04.txt) | Pares 1/4, 2/5 e 3/6 continuam semelhantes. Altura 399–411 px, acima do alvo de cerca de 360; apoios 451–481. |
| v05 | Guia de poses explícito como alvo, E/idle como aparência | [Imagem](../generated/durvall-run-refinement/v01/pilot-e-raw-v05.png), [prompt exato](../generated/durvall-run-refinement/v01/pilot-e-prompt-v05.txt) | Sobreposição das pernas ainda ambígua; 3/6 parecem extensões de contato em vez de recuperação. Apoio do quadro 4 em y432, 37 px acima do contato 1 em y469. |
| v06 | Guia como referência principal e somente idle para identidade | [Imagem](../generated/durvall-run-refinement/v01/pilot-e-raw-v06.png), [prompt exato](../generated/durvall-run-refinement/v01/pilot-e-prompt-v06.txt) | Persistem repetições aparentes da mesma perna visível e poses 3/6 inadequadas. Altura 444–448 px, identidade/câmera/espada mudam relativamente ao piloto. |

As quatro imagens v03–v06 têm tamanho 1536×1024, seis células 512×512 e alfa zero no canto. Bbox por alfa ≥26/255 não toca bordas, mas isso não demonstra alternância correta. [Auditoria com hashes e limites por quadro](../generated/durvall-run-refinement/v01/pilot-e-revision-audit.json). A largura total inclui tecido/espada e não mede a amplitude entre os pés; não se declarou redução de 20% atingida.

[Comparação das quatro sequências](../generated/durvall-run-refinement/v01/pilot-e-revision-comparison.png) e [guia anatômico de seis poses](../generated/durvall-run-refinement/v01/pilot-e-pose-guide-v05.png), inspecionados visualmente. Todos os prompts exatos e PNGs brutos preservados no projeto, além das saídas originais no diretório de imagens geradas do Codex.

## Aceite e próximo checkpoint

Alternância e amplitude moderada não aprovadas; não há candidata pronta para avaliação de jogo. Células e transparência passaram pela triagem, mas contato, tamanho/câmera e ciclo não passaram pela revisão visual. Nenhum smoke de jogo executado para estas imagens, pois não foram integradas ao teste. O estado permanece pendente no S-005; B-003/B-004 não iniciados.

O PLAN-066 exige rever a direção após três tentativas. A recuperação passou pela produção de uma pose por imagem, primeiro os contatos opostos 1/4, em um lote limitado a seis imagens, conforme [plano por poses](../vault/drafts/PLAN-066-recuperacao-poses-2026-10-06.md). É uma escolha técnica dentro da revisão lateral autorizada; a classificação inicial que exigia outra aprovação foi corrigida antes de perguntar ao dono. A dupla falhou e o restante do lote foi interrompido.

## Recuperação por contatos individuais

Geradas somente duas imagens na recuperação R-001: [contato 1](../generated/durvall-run-refinement/v01/pilot-e-v07-frame-1.png), [prompt 1](../generated/durvall-run-refinement/v01/pilot-e-v07-frame-1-prompt.txt), [contato 4](../generated/durvall-run-refinement/v01/pilot-e-v07-frame-4.png) e [prompt 4](../generated/durvall-run-refinement/v01/pilot-e-v07-frame-4-prompt.txt). Guia de uma pose e move_e oficial como entradas; nunca o vídeo do dono. Saídas quadradas 1280×1280, embora o prompt pedisse 1024×1024. Mesmo isolados, os contatos mantêm uma configuração muito semelhante de pernas, sem demonstrar a inversão de sobreposição solicitada; corpo/espada também mudam. Nenhuma correção por pixels ou transformação por quadro.

As outras quatro poses não foram geradas, conforme condição de interrupção do R-001. São cinco chamadas de ImageGen nesta sessão: três folhas e duas poses de recuperação. O resultado não conclui a tarefa. A [proposta R-002](../vault/drafts/PLAN-066-piloto-articulado-2026-10-06.md) muda a representação de produção para pernas articuladas e precisa de decisão antes de execução; não é apresentada como correção já implementada.

## Reconciliação

Em seguida, o dono apontou na [captura anexada](../generated/durvall-run-refinement/v01/owner-feedback-sword-knee.png) que a espada saiu da mão e aparece junto ao joelho. Classificação IN_PLAN no S-005: defeito de continuidade da arma nas candidatas. Inspeção confirma ausência de pegada legível entre mão e cabo nas poses de recuperação mostradas; a mão aparece à frente, enquanto o cabo se confunde com a região do joelho. Não é consequência da entrada/movimentação da partida. A revisão anterior citava identidade/câmera/espada, mas deveria ter identificado explicitamente esse desprendimento. A captura não permite atribuir todos os recortes a versões/quadros com certeza; o defeito é registrado sem inventar essa correspondência.

Critério de rejeição explicitado: a mesma mão deve envolver o cabo em todos os quadros, com ligação antebraço→mão→punho da espada contínua; joelho/tecido não podem substituir a pegada. No piloto articulado proposto, preservar inicialmente braço, mão e arma juntos e ancorar eventual articulação da espada no ponto de empunhadura da mão, nunca na perna. A correção é requisito da candidata, não aprovação ou execução do R-002. Nenhuma imagem foi corrigida neste relato; a captura do dono foi somente preservada localmente, sem envio a gerador.

Mantidos velocidade, seis quadros e 10 fps, fontes e jogo oficiais, perfil real e cópia jogável anterior. A autorização de revisão ficou registrada antes da primeira geração; foram três tentativas no novo ciclo, além das três históricas. Nenhum aceite final, bug fechado, commit, push ou publicação.

Nota de publicação (2026-10-07): fontes, imagens e projetos de teste dos pilotos Durvall permanecem locais, aguardando decisão do dono após bloqueio da revisão automática. As referências históricas a `.atena/generated/durvall-*` registram trabalho local; não indicam assets admitidos ou publicados. Os registros e o mapa das referências pendentes estão na evidência de consolidação.
