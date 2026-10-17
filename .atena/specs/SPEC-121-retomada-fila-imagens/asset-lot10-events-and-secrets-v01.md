# ASSET-LOT10/v01 — eventos restantes e segredos

DRAFT, origin planned, implementation_preceded_spec false. PLAN_CHANGE_REQUEST após aceite LOT09 (“aprovado, continue”). Inventário/proposta preparados; este novo escopo foi aprovado explicitamente em2026-10-16 (“aprovado, continue”), antes da geração. Modalidade per-plan preservada, sem repetir seleção de nível. Claude permanece responsável por preparação/admissão/implementação. PLAN-103 e outras frentes preservados.

## Autoridade e prontidão

[SPEC-164](../SPEC-164-eventos-aleatorios-novos-mec-005.md), [SPEC-152](../SPEC-152-fatia-piloto-de-segredos-ecos-e-reliquias.md), [FILA-028](../../generated/CHATGPT-FILA-028-eventos-arcanista-icones-segredos-e-altar.md) e [preparação dos estáticos](preparation-fila028-v01.md). Fontes estáticas têm aceite prévio registrado na FILA-028; derivados técnicos DRAFT usados como referência, não como nova promoção CANON. [Sete referências/hash](../../generated/asset-lot10-2026-10-16/references.json) inspecionadas. LOT06 já cobre Peregrino/Contador/Arcanista: não duplicar. Busca nominal em animation-candidates/assets/animations não encontrou os IDs deste lote; reconfirmar antes de produzir, sem alegar inventário absoluto perfeito.

## Bíblia e contexto DRAFT v01

Fantasia sombria isométrica, câmera/silhueta da referência, luz superior esquerda, clusters de pixel e materiais gastos. Objetos isolados no mapa, repouso no estado da respectiva referência. Nenhum personagem novo, lore, regra, ativação, transição de estado ou recompensa. Identidade pessoal/figurino N/A: sete objetos/efeitos; identidade material e contexto abaixo aplicáveis. Contexto textual basta, sem posição de mapa obrigatória. Transparência nativa substitui fundo histórico das referências; sem cenário, chão/sombra nova, rótulo ou runa nova. Estruturas sólidas opacas, brilho existente pode ter falloff.

| Código | Referência normalizada | Identidade e movimento limitado |
|---|---|---|
| ES01 | EV01_v02 | Pacto de Sangue: laje rachada, adaga e selo vermelho existentes, gotas já desenhadas. Só filamento vermelho existente oscila; pedra/adaga/gotas fixas, sem sangue novo, sacrifício ou personagem. |
| ES02 | EV02_v01 | Relicário: baú escuro com ferragens douradas, correntes e fecho de osso. Leve brilho especular nas ferragens; baú fechado e corrente rígida. Sem abrir, balançar/desatar ou gerar loot. |
| ES03 | EV05_v02 | Carroça Abandonada: madeira tombada, roda, caixas/sacos e objeto luminoso existentes. Só brilho discreto oscila; ruína/carga imóveis, sem nova chama, emboscada ou personagem. Não confundir com quebrável QB07. |
| ES04 | EV06_v02 | Pedra do Eclipse: disco negro sobre bloco estriado, aro violeta existente. Luz do aro pulsa, pedra fixa; sem escurecer cenário, céu/lua ou ativar efeito mecânico. |
| ES05 | SE01_v03 | Eco: fragmento azul-pálido cristalino com fio branco-azulado/partículas existentes. Luz pulsa e partículas mínimas próximas; centro fixo, sem flutuação ampla, face, texto ou recolhimento. |
| ES06 | SE02_v03 | Câmara selada: alvenaria/porta fechada, três selos de cera vermelha e ferro, luz violeta inferior. Só luz inferior oscila; três selos intactos e fixos, sem abertura/destruição. |
| ES07 | SE03_v02 | Câmara aberta: mesma família arquitetônica, vão violeta e restos de selos existentes no chão. Só brilho do vão oscila; arquitetura/restos fixos, sem novo saque ou transição fechado→aberto. |

ES06 e ES07 são ciclos independentes dos dois estados estáticos existentes; parear a arquitetura na revisão, sem alegar interpolação ou sequência de abertura. Referências de aparência prevalecem sobre hipóteses genéricas. Não inventar movimento físico para tornar objeto rígido mais animado.

## Escopo e etapas

Sete folhas, quatro poses por folha,28desenhos; uma galeria com sete players. Até três tentativas por fonte por defeito objetivo, máximo21chamadas. Nenhuma variante adicional. Cada chamada built-in imagegen com sua referência, originais/versionamentos/prompts/hashes preservados.

1. S-001 prontidão/proposta: concluída. Sete identidades e referências inspecionadas, contextos e limites definidos. Aprovação recebida antes da produção; nenhuma lacuna BLOCKING textual restante.
2. S-002 produção: uma linha4×1 por fonte, alvo2048×768, células512×768, motivo≤300px de largura, margem solicitada≥64px e base localy600. Medir resultado nativo, sem prometer dimensões exatas. Mesmo enquadramento/base/escala, fases luz baixa→pico discreto→relaxamento→próxima do início. Sem gate intermediário por fonte.
3. S-003 QA: quatro poses efetivas, transparência/solidez, células inteiras, zero contato alfa≥16 na banda4px, margens reais, identidade/rigidez, base/escala e retorno4→1. Leituras48/80/128 e contatos preservando proporção. Hash distinto não comprova animação. Defeito persistente no limite gera retenção seletiva; não ocultar corte ou fabricar poses por crop. Notas de alfa/registro não equivalem a PASS de admissão.
4. S-004 galeria única, sete players com pausa/replay/FPS/repetição/scrub, fontes em `.atena/generated/animation-candidates/asset-lot10/`, pacote em `.atena/generated/asset-lot10-2026-10-16/`; manifesto, referências, prompts, medidas, evidência e entrega local para Claude. Validar caminhos/hashes/controles, distinguir DOM offline de render real. Parar no aceite visual conjunto, permitindo aceite parcial por código/revisão.

RESOLVABLE: leitura de luz discreta, alfa/margem, registro/rigidez e pareamento arquitetônico. DEFERRED: CANON, normalização/pivô/escala/temporização/consumer, admissão/implementação, transições, contraste runtime e playtest. Recuperação por fontes versionadas, sem sobrescrever referências nem alterar entregas anteriores. Escopo não muda arquitetura, mecânica, código/dados, dependências ou permissões; não resolve bugs e retenções anteriores. Sem commit, push, merge, exportação, publicação ou mensagem a Claude. Aprovação per-plan permitirá executar S-001..S-004; gate visual permanece independente.

Resultado2026-10-16:4/4 etapas entregues, sete fontes/28poses em13tentativas; ES01/ES05v02, ES04/ES07v03, demaisv01. Todos nativos2048×768, sem contato alfa≥16 nas bandas4px; várias margens abaixo64px, alfa/registro e pareamento das câmaras pendentes. [Evidência](../../evidence/asset-lot10-events-and-secrets-2026-10-16.md). Aceite visual conjunto PENDING, nenhuma admissão/CANON/implementação.

Aceite posterior2026-10-16: 'atena aprovado, continue'. Sete revisões selecionadas/28poses aceitas como direção visual DRAFT, recibo visual-acceptance.json no pacote. Supera PENDING visual anterior, preserva preparação/registro/pareamento e ausência de admissão/CANON. Implementação com Claude.
