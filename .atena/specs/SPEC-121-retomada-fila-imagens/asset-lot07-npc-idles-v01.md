# ASSET-LOT07/v01 — nove NPCs / 36 poses de repouso

DRAFT, origin planned, implementation_preceded_spec false. Pedido 2026-10-16: "aprovado, continue"; aceite visual das oito fontes LOT06 registrado separadamente com FC02_ORIGIN preservado. PLAN_CHANGE_REQUEST da frente de produção, escopo aprovado antes da primeira geração. Modo per-plan já escolhido, sem repetir seleção. Aprovação específica recebida em2026-10-16: "aprovado", em resposta ao plano de nove fontes/36poses. Preferência persistente do dono: lotes maiores e revisão conjunta, implementação com Claude. PLAN-103, planos de heróis e outras frentes preservados.

## Escopo, autoridade e inventário

Nove folhas, quatro poses de idle por figura,36quadros. Família completa dos nove NPCs ART-032 já estáticos no projeto, sem criar figurantes para completar volume. [PLAN-001 CANON](../../vault/canon/PLAN-001-nottgard-survivors.md) para estilo apenas; aparência DRAFT autorizada nas fontes de [NPCs piloto](../../vault/drafts/PLAN-ART032-NPCS-PILOTO-v01.md), [NPCs lote02](../../vault/drafts/PLAN-ART032-NPCS-LOTE02-v01.md) e [implementação estática](../../vault/drafts/PLAN-ART032-IMPLEMENT-v01.md). Extensão de animação proposta de forma explícita; o plano estático não autorizava gerar novas imagens. Não promover hipóteses físicas a cânone nem consultar/inferir lore externa nova.

| Código | Referência readonly | Contexto existente |
|---|---|---|
| NE01 | assets/interactions/npc_joao_barbosa.png | João Barbosa, peregrino/aliado |
| NE02 | assets/interactions/npc_desertor_durao.png | Desertor, evento/resgate em Durao |
| NE03 | assets/interactions/npc_vitima_enfeiticada.png | Vítima humana debilitada em Shendilavri |
| NE04 | assets/interactions/npc_nyxara.png | Nyxara, Irmã Radiante, aliada/guia |
| NE05 | assets/interactions/npc_vaelis.png | Vaelis, Irmã Radiante, aliada/guia |
| NE06 | assets/interactions/npc_grazzt_aliado.png | Graz'zt aliado, arte atual com espada baixa |
| NE07 | assets/interactions/npc_reaper_barqueiro.png | Reaper barqueiro, interação/pacto |
| NE08 | assets/interactions/npc_vhaerith_aetherion.png | Vhaerith Aetherion, arqueólogo/resgatável |
| NE09 | assets/interactions/npc_mercador_rivenheart.png | Mercador genérico, interação comercial |

Nove referências inspecionadas visualmente; [snapshot/hash](../../generated/asset-lot07-2026-10-16/references.json). Busca nominal em assets/animations e animation-candidates não encontrou idles desses nove IDs; reconfirmar antes de produzir caso outra frente avance. Não alegar inexistência absoluta de arquivos renomeados. Fontes estáticas e entregas LOT03..06 preservadas.

## Bíblia/identidades e contexto — DRAFT v01

Identidade pessoal aplicável a todas as nove figuras; referências atuais prevalecem sobre antigas hipóteses de aparência. Fantasia sombria com clusters de pixel, materiais gastos, câmera elevada três-quartos/facing da referência, luz superior esquerda; sem mudar pose-base, equipamento, proporção ou expressão. Contexto textual: repouso no mapa antes de interação. Respiração discreta e pequeno movimento de tecido/cabelo/mãos, quarto quadro retornando perto do primeiro. Não representar combate, deslocamento, cura, recompensa ou mudança de quest. Fundo transparente, sem chão, sombras de chão, rótulos ou cenário novo; sólidos opacos, margens reais medidas.

- NE01: homem de cabelo/barba escuros, traje azul/marfim gasto, sandálias, cajado simples à direita da imagem e bolsa/cinto. Respiração/tecido mínimos; cajado firme, mãos/rosto preservados. Sem transformá-lo em herói/mago ou acrescentar símbolos.
- NE02: capuz bege, rosto escuro/oculto, lenço castanho-vermelho, roupa militar cinza/ocre danificada com ombreira, botas e mãos baixas. Postura retraída, sem revelar espécie/rosto, sacar arma ou acrescentar feridas.
- NE03: adulto humano pálido de cabelo castanho, roupa malva/bege gasta, curvado de pé, mão no peito. Respiração débil discreta, mão mantém apoio. Não curar/endireitar, adicionar sangue/correntes ou mudar estado narrativo.
- NE04: mulher de cabelo escuro preso, armadura prata envelhecida, tecido ameixa, espada baixa à direita. Cabelo/tecido mínimos, lâmina baixa fixa; sem asas/chifres, armadura nova ou gesto de ataque.
- NE05: mulher de cabelo castanho trançado, armadura bronze escuro e tecido cinza-malva, postura cansada. Respiração/tecido mínimos; sem espada inventada, ferimento/gravidez ou mudança de roupa.
- NE06: humanoide alto de pele cinza-escura, cabelo negro longo, armadura escura com detalhes prateados e manto violeta, espada baixa. Preservar mãos/anatomia exatamente da arte atual; não adicionar chifres/dedos ou atributos externos. Manto/cabelo discretos, lâmina fixa, sem ataque/aura.
- NE07: figura encapuzada cinza-preta de rosto oculto, roupa gasta, vara longa diagonal com duas mãos e bolsa/cinto. Respiração/tecido mínimos, vara inteira estável, sem foice/esqueleto/canoa/rio ou rosto novo.
- NE08: elfo adulto de cabelo grisalho longo e orelhas pontudas, túnica azul-cinza com marfim, cinto/bolsas e mãos vazias. Respiração/cabelo mínimos; sem arma, jaula, runa nova ou ferimento.
- NE09: figura encapuzada vinho de rosto oculto, traje couro/tecido com ornamentos existentes, bolsa no cinto e mão aberta comercial. Gesto mínimo, sem surgir moeda/produto, revelar rosto ou inferir espécie demoníaca.

Sem lacunas BLOCKING textuais para ensaio DRAFT. Aprovação de entrada recebida; checkpoint atual: revisão visual conjunta da produção. RESOLVABLE: grade real, margens, continuidade/registro, anatomia/equipamentos e alfa. DEFERRED: admissão/consumers, normalização/pivôs/escala/temporização, movimento/ataque de aliados e playtest. Nenhuma integração incluída.

## Produção, checks, recuperação e checkpoints

1. S-001 inventário/bíblia/proposta: concluído. Nove identidades e hashes prontos; escopo aprovado; produção e entrega de candidatas concluídas, gate visual pendente.
2. S-002 nove fontes imagegen, uma chamada por folha, até três tentativas por fonte para defeitos objetivos. Nova disposição proposta **4×1 numa única linha**, alvo1536×1024, células384×1024 (medir real), para evitar deslocamento sistemático entre linhas visto no LOT06. Mesma escala/pés em todas poses, alvo de base localy820, corpo inteiro até600px de altura e largura≤260px, com margem≥48px incluindo espada/vara. Dimensões solicitadas não são garantidas. Se a folha não atender layout, corrigir dentro das tentativas; não fabricar poses por recorte. Fontes versionadas em .atena/generated/animation-candidates/asset-lot07/.
3. S-003 QA: contar quatro poses, medir grade/dimensões/alfa/margens e deslocamentos, revisar mãos/rosto/armas/props e retorno4→1. Células nativas retangulares devem manter proporção na prévia, **não esticar para quadrado**. Contatos/players ajustados à geometria real; previews de leitura80px e opcional128px, sem impor escala de runtime. Preservar originais. Correções sem ultrapassar três tentativas; problema material persistente gera retenção por código, não PASS falso. Hash distinto não prova idle correto. Fontes com alfa/pivô pendentes só podem receber avaliação de direção com notas explícitas.
4. S-004 uma galeria conjunta com nove players, controles de pausa/reinício/scrub/FPS/repetição, manifesto/prompts/hashes/evidência/entrega local para Claude. Conferir arquivos/links e lógica dos controles; separar DOM offline de render real. Parar na revisão humana conjunta, permitindo aceite parcial por código/revisão. Sem presumir aceite de animação pela aprovação dos estáticos.

Recuperação por fontes versionadas, retenção seletiva e referências readonly. Diretório de entrega .atena/generated/asset-lot07-2026-10-16/. Não alterar fontes aceitas, assets oficiais, código/dados, cânone, dependências, mecânicas ou publicar/commitar/push/exportar. Não enviar a outro chat. Implementação continua com Claude em sua frente autorizada. Nenhum playtest nem alegação de diversão/fluidez em jogo nesta produção.

Resultado 2026-10-16:9fontes/36recortes nativos em15tentativas; NE06v03 retido por espada após limite de três tentativas. S-001..S-004 entregues com retenção, sem PASS global de admissão. Dimensões reais variadas, larguras inteiras de célula preservadas, contatos/player sem esticar. [Evidência](../../evidence/asset-lot07-npc-idles-2026-10-16.md).
