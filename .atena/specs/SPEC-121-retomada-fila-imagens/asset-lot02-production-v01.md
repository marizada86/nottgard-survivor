# ASSET-LOT02/v01 — UI pendente e pilar cortado

Estado DRAFT. Origem planned; implementation_preceded_spec: false. Pedido "continue", após instrução de lotes maiores para aprovação. Classificação PLAN_CHANGE_REQUEST: novo escopo de produção da frente de arte; preservar PLAN-103 e seus checkpoints. Modo per-plan confirmado para este lote pelo dono com "aprovado", em 2026-10-15. Não alterar o modo per-batch do PLAN-103.

## Escopo proposto: seis assets, cinco fontes

| Código desta revisão | Entrega pretendida | Fonte/contrato | Papel e limite |
|---|---|---|---|
| UI01 | Moldura de progresso da fase | FILA-012 U01, ART-002 | Metal/pedra, canal preto, 8:1, ornamento caveira à direita; preenchimento pertence ao jogo |
| UI02-A | Losango âmbar do progresso | FILA-012 U02, ART-002 | Primeiro ícone da fonte pareada 2:1 |
| UI02-B | Caveira do chefe | FILA-012 U02, ART-002 | Segundo ícone da mesma fonte pareada, vermelho escuro/âmbar |
| UI03 | Casela de item bloqueado | FILA-012 U03, ART-003 | Quadrada, metal/pedra escuros, silhueta e cadeado discretos |
| UI04 | Casela de item desbloqueado | FILA-012 U04, ART-003 | Quadrada da mesma família, interior livre e filete dourado fino |
| PR01 | Pilar de Dagruve com topo/base inteiros | ART-048 | Preservar identidade do pilar_01; capitel completo como pilar_03, correia e argola, margens transparentes |

São cinco chamadas iniciais (UI02 é uma fonte com dois ícones, conforme contrato existente), não seis variações artificiais. Entregar fontes e prévias; o par será identificado por seus dois componentes no manifesto. Extração/normalização definitiva continua parte da implementação. Até três tentativas por fonte, cada correção por defeito objetivo. Uma galeria final, seis entradas, aceitação conjunta com opção de reter peças individualmente; não interromper a cada imagem.

## Evidência e inventário

Autoridade de UI: [ART-PROMPTS-043](../../generated/ART-PROMPTS-043-ui-e-vfx-pendentes.md), [FILA-012](../../generated/CHATGPT-FILA-012-ui-e-vfx-pendentes.md). Busca local não encontrou PNGs com nomes dessas quatro fontes. U07..U09 já geradas, fora do lote. Backlog MEC-002 e MEC-003 registra implementação da barra e catálogo por código, sem arte nova; consumers `ui/stage_progress.gd`, `ui/pause_menu.gd` e `ui/menu.gd` conferidos. [SPEC-163](../SPEC-163-barra-de-progresso-da-fase-mec-002.md) define a barra atual em 4 px: a fonte 8:1 é opcional para futura integração; produzir não autoriza aumentar/mover elementos da HUD ou substituir esse contrato.

Pilar: [ART-048 no backlog](../../backlog/ARTE.md). Referências `assets/props/pilar_01.png` e `assets/props/pilar_03.png` inspecionadas: primeira está cortada no capitel/topo e base; segunda mostra capitel/base inteiros. `ui/prop.gd` e `data/scenery.json` usados como contexto de escala/cenário. Reintrodução ao sorteio e âncora só na implementação autorizada.

Sem geração nova de FILA-028, FILA-022/023 ou de heróis M1: inventários reconciliados e gates separados preservados. Lança-chamas U05/U06 excluído por mecânica MEC-004 ainda pendente. Nenhuma nova lore, divindade ou símbolo exclusivo.

## Mini bíblia e prontidão visual

Autoridade geral CANON: `vault/canon/PLAN-001-nottgard-survivors.md`, visual sombrio/isométrico e leitura acima de espetáculo. Direção específica de produção DRAFT v01.

UI: frontal plana, pixel art densa, metal/pedra escuros, âmbar/dourado discretos; sem texto, glifos ou personagens. Referências de família existentes: `assets/ui/ficha/ficha_aba_moldura.png`, `assets/ui/ficha/ficha_moldura_detalhe.png`, `assets/ui/evolucao_painel_moldura.png`, já inspecionadas na produção B01; papéis adaptados ao prompt específico. UI01 comprida/estreita; UI02 ícones isolados em metades sem contato; UI03/UI04 caselas correspondentes, mesmo enquadramento. Fundo magenta #FF00FF conforme contrato. Identidade de entidade N/A para molduras e marcadores genéricos sem personagem. Cena textual: barra da HUD e catálogo na pausa/Quartel; escala final sujeita à implementação, sem prometer dimensões nativas do gerador.

PR01: identidade de prop relevante, não personagem. Pilar quadrado de pedra cinza desgastada com leve musgo, ferragens/correia marrom e argola, mesma orientação isométrica, iluminação e materiais das referências. Sem acrescentar correntes novas, símbolos, efeitos ou cenário. Topo/base completos, margem livre de pelo menos 5% em todos os lados, chão ausente, alfa nativo preservado. Alvo futuro de 256×256, sujeito à redução e âncora pelo implementador. A fonte cortada fornece identidade e a pilar_03 somente a completude de capitel/base; não adotar sua corrente como detalhe da variante 1.

Referências locais; anexar com papéis explícitos e conferir hashes antes/depois. Sem fontes externas. UI03 e UI04 mantêm a mesma família por uso das referências comuns e, após inspecionar, da primeira fonte como referência de consistência da segunda.

BLOCKING visual: nenhuma lacuna textual relevante para produção experimental DRAFT; escopo aprovado. RESOLVABLE: variações de proporção, margens, textura e organização do par, tratadas nas correções previstas e retidas se não resolverem. DEFERRED: preparação definitiva, posição/layout, nove fatias, alfa por chave das UIs, consumers, runtime, aceite em jogo. Entrega v01 contém notas técnicas de proporção e alfa de PR01; não é aprovação técnica de admissão.

## Etapas, saídas e checks

1. S-001: contrato/inventário/proposta — concluído; referências do pilar inspecionadas, UI já documentada em B01; hashes a conferir antes de produzir.
2. S-002: produzir cinco fontes no imagegen, salvar originais versionados em `.atena/generated/art-candidates/asset-lot02/`. Até três tentativas por fonte; sem pedir aceite entre imagens salvo bloqueio real/gate obrigatório.
3. S-003: inspecionar sem texto, família/material, margem/contorno, quantidade de ícones, proporção e correspondência entre caselas. PR01 exige topo/base inteiros e alfa real; UI exige centro/área de ícone legíveis. Gerar prévias de QA proporcionais, contato e transparência quando aplicável, sem chamar de assets normalizados. Medir dimensões e hashes; registrar retenções. Nenhum PASS completo de admissão por mera inspeção da fonte.
4. S-004: publicar apenas galeria local conjunta em `.atena/generated/asset-lot02-2026-10-15/`, manifesto com seis entradas e cinco fontes, prompts, evidência e entrega local para Claude. Parar no aceite humano por código/revisão. Estética/legibilidade no jogo ficam pendentes da implementação e playtest.

Produção por imagegen integrada; sem dependência nova. Nenhuma alteração em assets/, ui/, core/, data/, lore externa ou configuração. Sem envio a outro chat. Sem commit, push, merge, exportação ou promoção canônica. Recuperação por novas revisões e retenção seletiva; preservar fontes/consumers/referências atuais. Implementação: Claude conforme instrução do dono; responsabilidade da produção encerra na entrega documentada para avaliação, sem alegar integração feita.

Impacto: nova produção de UI e uma correção de prop, sem ampliar mecânicas. Aceite de cada uma das seis entradas rastreado à fonte/revisão/hash; rejeição parcial não invalida o restante. Retorno PLAN-103 B-004/R3_PROPOSAL_AWAITING_G-M3-3; B-002/S-008 e B-003 preservados. Backlog consultado: 0 P0, 4 P1 sem implementação, 18 aguardando playtest, 0 alertas; RTK já enabled.
