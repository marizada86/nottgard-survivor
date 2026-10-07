---
title: Piloto lateral articulado de Durvall
created: 2026-10-06
plan: PLAN-066
spec: SPEC-133
canonical: false
status: IMPLEMENTED_AWAITING_OWNER_PLAYTEST
request_classification: PLAN_CHANGE_REQUEST
approval_mode: per-batch
checkpoint: B-002 / S-005 / R-002
approved: 2026-10-06
approval_basis: 'Dono respondeu Imagem e piloto articulado ao esclarecimento de alcance'
---

Controlar a alternância das pernas por articulações é a proposta após a falha das folhas completas e dos dois contatos individuais. É um piloto lateral em cópia isolada para comparar a aparência e o contato, sem admissões oficiais.

## Escopo e impacto

Preparar componentes visuais de tronco, coxas, canelas e botas de Durvall a partir das referências já autorizadas, com o ImageGen para edição da arte. Montar uma hierarquia articulada no Godot existente, sem dependências novas. Cada perna mantém identidade própria, com fases deslocadas por meio ciclo; o movimento dos joelhos e pés passa a ser controlado por posições e rotações explícitas.

Após o relato do dono sobre a espada junto ao joelho, a continuidade da empunhadura é um requisito explícito de triagem: manter inicialmente braço, mão e espada no mesmo componente visual. Caso a espada seja articulada separadamente, seu pivô deve ser o ponto de pegada na mão e acompanhar o braço. Não utilizar as candidatas com arma desprendida como fonte dessa ligação; conferir contra a arte oficial. Joelho, tecido e sobreposições não podem ocultar totalmente ou substituir a pegada.

A mudança sai da geração direta de quadros completos e usa um modelo articulado para produzir as poses. Pode introduzir emendas nas peças e diferenças de luz/oclusão; isto precisa de validação visual antes de expandir. O piloto pode exportar seis quadros 256×384 para manter o contrato final, em vez de impor o rig ao runtime oficial. Nenhuma arquitetura oficial ou contrato canônico será alterado nesta etapa.

## Voo limitado

1. Preparar guia e componentes somente da lateral E, preservando proporção, espada e câmera. Até três tentativas de produção de componentes antes de reavaliar.
2. Montar duas pernas separadas e seis poses: contato, apoio/recuperação e impulso alternados. Moderar amplitude em relação à v03, sem aumentar o corpo.
3. Conferir contato dos pés sobre chão e alternância completa em dois ciclos; registrar limites e emendas.
4. Preparar comparação em cópia isolada, com seis quadros a 10 fps, altura-alvo 60 px, velocidade 190 px/s e alternância F8. Se o piloto não passar na triagem, não integrar ao teste nem expandir às diagonais.

## Aceite e recuperação

Cada perna deve poder ser identificada nas duas metades do ciclo, sem repetir o mesmo apoio. Contatos 1/4 no chão, recuperação dos joelhos clara, loop 6→1 sem salto, corpo e espada consistentes. O dono avalia o resultado em tamanho de jogo antes da extensão às outras direções.

Conferir nos seis quadros a mesma mão envolvendo o cabo, continuidade antebraço/mão/arma e lâmina ligada ao punho, especialmente quando o joelho sobe. Espada flutuando ou presa visualmente à perna reprova a candidata.

Originais, v01–v07 e teste v03/revisão 2 preservados. Guardar componentes, guia, poses e capturas em nova pasta gerada. Sem alterações no projeto oficial, velocidade ou progresso. Nenhum commit/publicação. A aprovação deste piloto cobre apenas o R-002; aceite visual, B-003/B-004 e eventual mudança de arquitetura oficial são gates separados.

Gaps BLOCKING técnicos conhecidos: nenhum. Escolha de método R-002 aprovada pelo dono em 2026-10-06. Aceite visual do resultado permanece pendente.

Entrega: piloto lateral articulado produzido com duas tentativas de componentes; seis poses exportadas e teste isolado validado com movimento real e F8. [Evidência e limites](../../evidence/EVID-175-durvall-piloto-articulado-2026-10-06.md). Próximo checkpoint: avaliação visual do dono, antes de qualquer expansão.
