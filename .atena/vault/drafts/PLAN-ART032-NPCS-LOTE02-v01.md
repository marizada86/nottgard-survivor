---
id: PLAN-ART032-NPCS-LOTE02
revision: v01
card: ART-032
status: COMPLETED_VISUALLY_ACCEPTED_DRAFT
content_state: DRAFT
approval_mode: per-plan
---

# ART-032 — segundo lote de NPCs

O dono esclareceu “Produzir as próximas imagens de ART-032” após “aprovado”. A escolha autoriza preparar esta frente; o escopo de seis peças abaixo aguarda aprovação própria. Modalidade per-plan preservada, sem nova pergunta de modalidade. O piloto anterior permanece concluído e visualmente aceito, com NP01 v02 e NP02/NP03/PT01 v01 DRAFT. Classificação: PLAN_CHANGE_REQUEST, extensão por novo plano limitado, sem substituir o piloto fechado, PLAN-071 ou revisão de heróis.

## Escopo e contrato DRAFT v01

| Ordem | Código / fonte v01 | Contexto confirmado e hipótese visual |
|---:|---|---|
| 1 | NP04 Nyxara | Uma das Irmãs Radiantes, guerreira/guia emprestada por Malcanthet em Shendilavri. Proposta: adulta, armadura completa prata envelhecida, tecido ameixa, cabelo escuro preso, espada baixa. Sem inferir raça/asas/chifres pelo título. |
| 2 | NP05 Vaelis | Outra Irmã Radiante; guia/combatente com armadura e cansaço mencionados. Proposta distinta: adulta, cabelo castanho trançado, armadura bronze escuro, tecido cinza-malva, postura cansada de repouso. Sem cena biográfica, gravidez ou ferimento incorporado. |
| 3 | NP06 Graz'zt aliado | Lorde do Abismo, aliado do grupo e invocado por anéis; espada citada no vault. Proposta: humanoide adulto alto/imponente, pele cinza escura, vestes/armadura negra e manto violeta, espada baixa. Aparência não definida nas fontes consultadas; não importar anatomia externa, chifres, seis dedos ou marca registrada como canon de Nottgard. |
| 4 | NP07 Reaper barqueiro | Conjura canoa em troca de ouro no Estige. Proposta: figura encapuzada de tecido cinza gasto, rosto em sombra, vara simples de barqueiro. Não afirmar esqueleto/morto-vivo ou copiar um inimigo inexistente. Sem canoa, rio ou foice incorporados. |
| 5 | NP08 Vhaerith Aetherion | Elfo arqueólogo/conhecedor de runas, preso em Durao. Proposta: elfo adulto maduro, orelhas pontudas, cabelo grisalho, túnica azul-cinza gasta, mãos vazias; jaula apenas como contexto textual. Sem runa recebida, sangue/ferimento ou jaula incorporados. |
| 6 | NP09 mercador de Rivenheart | Papel genérico da loja de itens sem magia na cidade de Shendilavri. Sem nome/espécie/gênero definidos nas fontes. Proposta: adulto encapuzado com rosto parcialmente oculto, traje vinho/couro, bolsa pequena e gesto comercial; sem fixar súcubo/íncubo por origem geográfica. |

Uma chamada imagegen built-in por peça, uma figura completa estática por PNG, alfa verdadeiro e espaço transparente confortável. Solicitar 1024×1024 e registrar o tamanho real retornado. Salvar originais byte a byte em `.atena/generated/art032-npcs-lote02-2026-10-11/sources/`; nunca substituir as quatro fontes aceitas do piloto. Auditoria, prompts/hashes e galeria/prancha de leitura a 80 px para as seis figuras; Graz'zt também a 128 px para inspeção, sem fixar escala runtime. Máximo de três versões por defeito, correções limitadas a invariantes do contrato, preservando histórico.

## Bíblia e identidade/contexto

Estilo CANON de PLAN-001: fantasia sombria isométrica, Diablo II/Halls of Torment, leitura sem excesso de distrações. Bíblia de produção DRAFT v01 herda o acabamento do piloto aceito. Câmera três-quartos elevada, figuras voltadas para baixo/direita, luz superior esquerda; pintura com clusters de pixel, materiais gastos, sem chibi/fotorrealismo/vetor. Referências locais `assets/interactions/curandeiro.png` e `assets/animations/heroes/durvall/idle.png` apenas para acabamento/câmera, nunca identidade, espécie, figurino ou cenário. Revisões SHA256 registradas no pacote.

Fonte principal: vault de Nottgard somente leitura, notas canônicas de Nyxara/Vaelis/Irmãs Radiantes, Graz'zt (NPC e lore), Reaper do Estige, Vhaerith, Rivenheart e Sessões 15/16/18/19–20p1. `data/stage_events.json`/SPEC-118 fornecem contexto mecânico. Papéis não justificam inventar aparência canônica. Consultados nomes de arquivos de Nottcard e seus JSONs em `F:/dev/nottcard/data/`; não foram encontrados registros/referências visuais com os nomes pesquisados. Não alegar inexistência global de referências. Nottcard também somente leitura.

Toda peça possui entidade aplicável; N/A de identidade não se aplica. As identidades físicas não documentadas são explicitamente hipóteses DRAFT autorizáveis para experimentação. Nyxara/Vaelis são duas candidatas distintas, sem afirmar parentesco biológico ou espécie. Contexto textual suficiente: guias/aliados, barqueiro de pacto, prisioneiro de pacto e vendedor opcional; não desenhar combate/castelo/jaula/canoa/mapa. Sem chão, sombra projetada, texto, símbolo sagrado novo, moldura, grade ou animação. Trajes completos; contraste contido; armas/varas inteiras e baixas.

## Lacunas e limites

- BLOCKING de prontidão visual: nenhuma para fontes experimentais DRAFT. O checkpoint de aprovação de escopo permanece pendente.
- RESOLVABLE: aparências propostas e diferenciação das Irmãs, margens/alfa/legibilidade após retorno nativo; revisão do dono por código/revisão.
- DEFERRED: anatomia/figurino canônicos, ícones separados, animação, tamanho final/pivô/runtime, mapas/contraste, jaula/canoa e demais pontos ART-032. Publicação, integração e promoção a CANON não fazem parte deste plano.

## Plano ordenado e aceitação

| Posição | Passo | Saída / verificação / checkpoint |
|---:|---|---|
| 1/5 | S-001 prontidão/fontes/prompts | Concluído: papéis/referências/prompts preparados; G0 aprovado antes da produção. |
| 2/5 | S-002 gerar NP04–NP09 | Concluído: seis candidatas em oito saídas nativas; NP04/NP06 v02 corrigidos, histórico preservado. |
| 3/5 | S-003 auditoria | PNG/RGBA/alfa real, tamanho, hash, margem visível mínima 10%, corpo/acessórios inteiros; inspeção nativa e prévias 80/128 px. Alfa residual e recortes de brilho devem ser relatados. |
| 4/5 | S-004 galeria/evidência | Seis candidatas e histórico, prompts, origem/hash, comparações e roteiro de revisão; validar links/contrato e estado. Prancha Godot local; não contornar o bloqueio conhecido de URLs file:// no navegador. |
| 5/5 | S-005 revisão do dono | Concluído: dono respondeu “Aprovo visualmente as seis revisões” para NP04/NP06 v02 e NP05/NP07–NP09 v01; DRAFT, sem CANON/admissão. |

Execução local limitada ao pacote, ao plano/estado/evidência e à linha ART-032 do backlog. Atena prepara os inputs e responde pela integração futura; não há necessidade demonstrada de especialista delegado. Sem mudança arquitetural, dependência, política ou dados mecânicos. Recuperação: preservar fontes originais/versões, hashes das quatro aceitas e dos arquivos runtime/ativos, além da cadeia de retorno PLAN-071; novas fontes são isoladas e podem permanecer não admitidas. Testes de gameplay não necessários sem código alterado; checks de arquivos, referências, alfa/dimensões, links e estado são obrigatórios.

Impacto do novo plano: seis fontes e um novo gate visual, sem alterar o aceite anterior. Critério técnico não substitui julgamento humano. G0 exige aprovação do escopo **NP04–NP09/v01**, modo per-plan já selecionado. Commit, push, build, integração, normalização/admissão e promoção a CANON não são autorizados por G0.

## Aprovação de execução — 2026-10-11

G0 aprovado explicitamente com **“Aprovo as seis peças DRAFT”** para NP04–NP09/v01, modo per-plan. S-002 liberada; toda produção continua DRAFT. Não autoriza integração, normalização, CANON, commit, push ou build.

## Entrega para S-005 — 2026-10-11

**4/5 passos concluídos.** Candidatas DRAFT: **NP04 Nyxara v02, NP05 Vaelis v01, NP06 Graz’zt v02, NP07 Reaper v01, NP08 Vhaerith v01, NP09 mercador v01**. S-002: oito chamadas/saídas nativas, seis candidatas; S-003: alfa/hashes/margens/contexto e leitura verificadas; S-004: galeria, prancha e evidência entregues. Histórico NP04/NP06 v01 preservado, não selecionado. Fontes reais 1254×1254, sem limpeza/redimensionamento nativo; cinco bordas têm alfa 1/255, Vhaerith tem borda vazia. [Evidência de entrega](../../evidence/art032-npcs-lote02-delivery-2026-10-11.md). O texto de preparação acima preserva o histórico anterior a G0.

Próximo objetivo: dono conferir estilo/câmera, distinção das duas Irmãs, proposta física de Graz’zt e leitura/gestos de Reaper/Vhaerith/mercador a 80px (Graz’zt também 128px). Inputs são fontes/revisões e prancha; saída é aceite visual identificado ou correções por código. Aparências e adornos continuam hipóteses DRAFT; o pergaminho no cinto de Vhaerith não é a runa devida. Aprovação S-005 pendente e não autoriza integração, CANON, commit ou push.

## Fechamento S-005 — 2026-10-11

**5/5 passos concluídos.** Aceite explícito “Aprovo visualmente as seis revisões” para **NP04 Nyxara v02, NP05 Vaelis v01, NP06 Graz’zt v02, NP07 Reaper v01, NP08 Vhaerith v01 e NP09 mercador v01**. [Recibo com hashes](../../generated/art032-npcs-lote02-2026-10-11/visual-acceptance.json). Aparências/adornos permanecem DRAFT; não houve promoção a CANON, normalização/admissão, integração, commit, push ou build. Histórico v01 NP04/NP06 não aceito. Texto de entrega anterior registra o estado antes desta decisão.

Próximo objetivo preparado: novo plano para os pontos restantes ART-032 (trono de Zuggtmoy, arco de pedra, massa de Thullgrime, Coração de Limo, esporo e limo); arte própria da Manifestação de Juiblex permanece pendente específica. Inputs futuros: vault, contexto SPEC-118, bíblia de props e as dez fontes já aceitas. Saída futura: escopo/prompts DRAFT limitados, referências/hashes, checks de alfa/leitura e gate visual próprios. Ainda não há escopo executivo aprovado para essas peças; este aceite fecha apenas o lote 02.
