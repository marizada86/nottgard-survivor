---
id: EVID-172
created: 2026-10-06
plan: PLAN-066
spec: SPEC-133
checkpoint: B-002 / S-005
request_classification: IN_PLAN
status: OWNER_FEEDBACK_RECOMMENDATIONS
official_assets_changed: false
---

# Avaliação das passadas de Durvall no vídeo

O dono relata pernas sem movimento nas diagonais inferiores, leitura ruim na diagonal superior direita, troca dos pés incorreta no norte e boa direção visual lateral com passada excessiva. A revisão recomenda alternância anatômica clara antes de ampliar a produção. A lateral serve como referência de energia, com amplitude moderada; não há aceite final da sequência.

Fonte local: `D:/dev/nottgard/lives/2026-10-06 18-49-15.mp4`, 1920×1080, 60 fps, duração 53,1333 s. Capturas locais por FFmpeg já instalado no Krita, sem dependências novas. Extraídos 16 quadros por trecho, espaçados em 100 ms, de 0,3 s antes a 1,2 s depois dos tempos indicados. Ampliação por vizinho mais próximo, sem alteração da arte fonte. O painel do vídeo identifica PILOTO v03 e revisão 2.

## Observações e recomendação por direção

| Trecho | Observação nos quadros | Recomendação |
|---|---|---|
| 13 s | A lateral ainda aparece no início; a diagonal inferior direita entra perto de 13,2 s. Poses mudam, mas uma perna domina a silhueta e o apoio oposto fica pouco legível. | Tornar explícita a passagem da perna de trás à frente, com flexão e recuperação do joelho. |
| 15 s | A diagonal inferior esquerda repete a leitura da direita espelhada. Há pequenas variações nas botas, sem troca convincente do apoio. | Corrigir SE e revisar SW independente no lote das outras direções; preservar o lado anatômico da espada. |
| 17 s | A diagonal superior direita entra perto de 17,2 s. Pernas sobrepostas, recuperação e contato pouco distintos. | Separar as silhuetas das duas pernas na perspectiva de costas, com contato, impulso e retorno claros. |
| 26 s | A direção norte entra perto de 26,1 s. Pernas/solas variam; a passagem do peso entre elas permanece pouco clara. | Alternar sola visível da perna em recuperação e pé de apoio, evitando que tecido/cabelo escondam toda a troca. |
| 32 s | A lateral espelhada entra perto de 31,9 s. Extensão ampla comunica corrida, conforme preferência do dono, mas a abertura é excessiva. | Experimentar alcance horizontal dos pés cerca de 20% menor que na v03, como ponto de partida visual sujeito ao próximo teste. Manter tamanho corporal e identidade. |

[Quadros de 13 s](../generated/durvall-run-refinement/v01/video-review/sequence-13s.jpg), [15 s](../generated/durvall-run-refinement/v01/video-review/sequence-15s.jpg), [17 s](../generated/durvall-run-refinement/v01/video-review/sequence-17s.jpg), [26 s](../generated/durvall-run-refinement/v01/video-review/sequence-26s.jpg) e [32 s](../generated/durvall-run-refinement/v01/video-review/sequence-32s.jpg).

## Causa provável e sequência proposta

O [quadro comparativo das fontes](../generated/durvall-run-refinement/v01/video-review/source-cycles.png) mostra que as poses mudam. O problema observado é a leitura da troca das pernas, não prova de um AnimatedSprite congelado. Na v03, pares 1/4, 2/5 e 3/6 mantêm configurações muito semelhantes; a identidade anatômica não permite confirmar uma alternância correta. Na arte SE, uma perna permanece dominante; em NE/N há oclusão e pouca diferenciação das fases. Esta é uma hipótese visual reforçada pelas fontes, sem telemetria de animação gravada no vídeo.

O runtime usa SE para SW por espelhamento; a cópia substitui somente E/W pelo piloto. Assim, os defeitos diagonais/norte pertencem às fontes anteriores. `sync_visual` só chama `play` quando a animação desejada muda, sem reinício explícito a cada frame em movimento uniforme.

Proposta para a próxima revisão do piloto: identificar pernas anatômicas A/B em um guia, produzir contato A → apoio A e recuperação B → impulso A → contato B → apoio B e recuperação A → impulso B, e conferir fechamento 6→1. Os quadros 4–6 precisam mostrar a outra perna liderando, não repetir 1–3 com variações de cabelo/tecido. Moderar a extensão lateral e o contato alto do quadro 4 sem escalas individuais. Manter inicialmente seis quadros a 10 fps e a velocidade atual para comparar a contribuição das poses.

Validar dois ciclos em direção fixa, com passos identificáveis, no tamanho de jogo e ampliado. Depois testar troca de direção/parada. Aceitar o piloto revisado antes de SE/SW, NE/NW e N/S no B-003. Oito quadros só se as seis poses corretas ainda não derem leitura suficiente, com decisão explícita sobre duração.

## Reconciliação

Pedido de recomendações em S-005, dentro do plano. O relato não autoriza geração adicional nem B-003/B-004. Três tentativas preservadas; gate visual permanece pendente. Arte, código e gameplay oficiais preservados. A proposta de reduzir amplitude é ajuste de revisão do piloto, não mudança canônica do objetivo de corrida firme.

Nota de publicação (2026-10-07): fontes, imagens e projetos de teste dos pilotos Durvall permanecem locais, aguardando decisão do dono após bloqueio da revisão automática. As referências históricas a `.atena/generated/durvall-*` registram trabalho local; não indicam assets admitidos ou publicados. Os registros e o mapa das referências pendentes estão na evidência de consolidação.
