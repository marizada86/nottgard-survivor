---
id: PLAN-ART032-NPCS-PILOTO
revision: v01
card: ART-032
status: COMPLETED_VISUALLY_ACCEPTED_DRAFT
content_state: DRAFT
approval_mode: per-plan
---

# ART-032 — primeiro lote de NPCs e ponto de acontecimento

Aprovação de execução: **“Aprovo as quatro peças DRAFT”**, 2026-10-11, per-plan. Não constitui aceite visual das futuras imagens.

Pedido: “atena, commit e vamos criar as proximas imagens”. Frente escolhida explicitamente: **“NPCs e pontos de acontecimentos (ART-032) — recomendado”**. Commit separado FILA-026 executado `fc5c709f3ef5c4acdc7c5a8a842747b72c7f70ec`. Este plano propõe quatro novas fontes DRAFT e revisão; não substitui PLAN-071, não resolve a extração de heróis e não integra assets no jogo.

Modo por plano preservado da sessão. A escolha da frente autoriza sua preparação; o escopo abaixo foi aprovado explicitamente em 2026-10-11. Rota: produção agora, retorno à revisão de arte; commits de novas fontes, push, promoção a CANON e integração têm gates próprios.

## Escopo e entregáveis

| Código | Peça v01 | Contexto e identidade |
|---|---|---|
| NP01 | João Barbosa | Devoto de Tou Um, guia/escolta em Feng-tu. Sem aparência física definida no vault; traje de peregrino proposto como hipótese visual DRAFT, sem inventar biografia ou poderes. |
| NP02 | Desertor de Durao | Uma das três figuras perseguidas por Molydeus. Espécie e gênero não definidos: figura adulta encapuzada, rosto coberto e equipamento militar gasto como hipótese DRAFT. Não afirmar que é humano ou demônio. |
| NP03 | Vítima enfeitiçada | Humano adulto debilitado a resgatar em Shendilavri; vestido, sem gore ou cena narrativa. Roupa e fisionomia genéricas DRAFT. |
| PT01 | Estrela do Norte | Miragem luminosa que guia a peregrinação em Feng-tu; ponto de orientação, sem pedestal/relíquia/corpo de divindade. Identidade de personagem N/A. |

Um arquivo por peça, alfa real, corpo/efeito inteiro, margens claras. Fontes nativas preservadas byte a byte em `.atena/generated/art032-npcs-2026-10-11/sources/`; prompts, hashes, auditoria e galeria no mesmo pacote. Pedido de canvas 1024×1024, tamanho real retornado será registrado. Prévia de leitura 80 px para atores e 48/80 px para a estrela, sem transformar a fonte nem alegar tamanho runtime final.

## Bíblia visual aplicável v01 — DRAFT de produção

Autoridade de estilo: direção CANON de PLAN-001 (fantasia sombria isométrica, poucas distrações, legibilidade), sprites locais `assets/animations/heroes/durvall/idle.png` (câmera/acabamento, nunca identidade) e `assets/interactions/curandeiro.png` (materiais/acabamento, nunca copiar cenário/equipamento). Fontes do próprio projeto, uso apenas como referência derivada; nenhuma referência externa nova. Fontes de lore em `F:/dev/nottgard-vault/`, somente leitura: João Barbosa, Tou Um, Tou Um e Lu Yueh, Sessões 16/18. SPEC-118 e `data/stage_events.json` dão contexto do acontecimento implementado; não substituem o vault para lore.

Linguagem: pintura detalhada com clusters de pixel, contraste contido e bordas limpas; câmera isométrica elevada, corpo três-quartos voltado para baixo/direita; luz superior esquerda. Figuras em repouso, sem grade/animação/cena. Paleta: ferro, tecido gasto, tons abissais; João azul escuro/marfim discreto; desertor cinza/ocre; vítima malva/cinza pálido; estrela branco/azul frio. Paletas e aparência são propostas DRAFT.

NP01: peregrino adulto de expressão calma, traje azul/marfim, cajado simples e bolsa pequena; sem atributos de herói, uniforme de combatente, halos/asa ou símbolo canônico inventado. NP02: pose retraída, capuz/lenço ocultando o rosto, mãos baixas, roupa militar danificada, sem arma erguida ou anatomia que fixe a espécie. NP03: adulto humano enfraquecido, curvado mas de pé, roupa completa e gasta, sem correntes/jaula/objetos de cena. PT01: estrela luminosa isolada e legível, flare compacto com pontas claras e brilho frio discreto, sem alegar quantidade canônica de pontas ou geometria exata.

Cena/contexto textual suficiente: NPCs aliados/resgatáveis devem se distinguir de inimigos pelos gestos e silhueta; os indicadores de missão permanecem no código. Sem chão, sombra projetada, rótulo, moldura, placa ou fundo incorporado. Feedback/animação e teste de contraste sobre mapa são posteriores à fonte; sem integração nesta etapa. Não confundir ensaio visual com playtest humano.

## Lacunas

- **BLOCKING:** nenhuma para geração experimental DRAFT após aprovação do escopo.
- **RESOLVABLE:** aparência não canônica de João/desertor; primeiras candidatas são hipóteses para revisão do dono, sem fixar identidade no vault. Retornos nativos, alfa, recorte e leitura auditados antes da galeria.
- **DEFERRED:** aceites visuais, sprites em runtime, pivô/pés/normalização final, animações, comparação em aparelho e integração. Demais personagens/pontos de ART-032 ficam fora deste primeiro lote.

## Passos ordenados

| Posição | Passo | Saída/checkpoint |
|---:|---|---|
| 1/5 | S-001 fontes, inventário e bíblia | Concluído; escopo aprovado com “Aprovo as quatro peças DRAFT”. |
| 2/5 | S-002 geração NP01, NP02, NP03, PT01 | Concluído: quatro candidatas DRAFT em cinco chamadas built-in imagegen, com correção de margem NP01 v02 e histórico v01 preservado; sem CANON/admissão. |
| 3/5 | S-003 auditoria | Concluído: hashes/PNG/RGBA/margens e leitura Godot 48/80 px; ressalva nativa de alfa 1/255 em três bordas registrada. |
| 4/5 | S-004 galeria/evidências | Concluído: fontes, prompts, galeria e prancha estática com evidências; HTML validado por links/metadados, renderização browser não verificada por bloqueio de file://. |
| 5/5 | S-005 revisão do dono | Concluído: “Aprovo visualmente as quatro revisões”, NP01 v02 e NP02/NP03/PT01 v01; continuam DRAFT, sem promoção ou admissão. |

Responsável de integração: Atena em checkpoint futuro autorizado. Sem especialista delegado. Skill imagegen é a ferramenta de produção. Reversão: novas fontes isoladas em generated, nenhuma dependência ou runtime alterado. Contrato: quatro peças rastreáveis, hipóteses explicitadas, originais preservados, diagnósticos honestos; legibilidade subjetiva depende do dono.

## Fila reconciliada

O `plan-053-imagens.yaml` desta checkout é um registro antigo que ainda cita N03. A branch local existente `codex/fila-imagens-continuacao-2026-10-09`, commit `cf17d7c3a0ff059320c7f580fd6a7d4ef8ec8aa1`, registra FILA-022 36/36 e FILA-023 60/60 fontes geradas, coerente com o checkpoint de heróis de 2026-10-10 no estado raiz. Nenhuma dessas imagens será regenerada por falta de cópia nesta checkout. Isso é reconciliação de inventário; sem merge de branch ou alteração da cadeia de retorno PLAN-071.

## Entrega do checkpoint — 2026-10-11

4/5 passos concluídos; S-005 pendente. Candidatas para revisão: **NP01 v02, NP02 v01, NP03 v01, PT01 v01**, todas DRAFT. NP01 v01 não selecionada por margem e preservada como histórico. Evidência: [auditoria e revisão](../../evidence/art032-npcs-piloto-2026-10-11.md). Próximo objetivo: o dono avaliar estilo, leitura e hipóteses físicas nas revisões exatas; saída é aceite visual identificado ou ajustes por código. Integração, normalização final e demais peças de ART-032 dependem de planos/checkpoints futuros. Nenhum commit, push, build ou promoção executado neste lote.

## Fechamento S-005 — 2026-10-11

**5/5 passos concluídos.** O dono respondeu “Aprovo visualmente as quatro revisões” à pergunta que identificava NP01 v02, NP02 v01, NP03 v01 e PT01 v01 e informava a ressalva de alfa 1/255. Aceite exclusivamente visual; não promoveu aparência/lore a CANON nem autorizou integração, normalização, commit ou push. [Recibo das revisões e hashes](../../generated/art032-npcs-2026-10-11/visual-acceptance.json). A entrega anterior documenta o histórico antes deste aceite. Próximo objetivo preparado: novo plano para normalização/admissão destas fontes ou produção das demais peças ART-032, usando fontes aceitas, bíblia/contexto e auditoria como entradas; saída futura deve preservar originais e definir checks/checkpoint próprios. Nenhuma execução futura autorizada por este aceite.
