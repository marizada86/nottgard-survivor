---
id: PLAN-ART032-JUIBLEX
revision: v01
card: ART-032
status: COMPLETED_VISUALLY_ACCEPTED_DRAFT
content_state: DRAFT
approval_mode: per-plan
---

# ART-032 — Manifestação de Juiblex

O dono pediu **“atena, continue”** depois do fechamento dos pontos ART-032 e da identificação da Manifestação de Juiblex como próxima imagem pendente. Classificação **PLAN_CHANGE_REQUEST**: preparar novo plano lateral limitado a uma peça, preservando os três lotes aceitos e a cadeia PLAN-071/revisão de heróis. Modo **per-plan** já escolhido; não repetir a seleção de modalidade. Esta preparação entrega um escopo concreto para G0; geração depende do aceite deste plano, conforme o checkpoint do projeto.

## Escopo DRAFT v01

**MJ01 — Manifestação de Juiblex v01:** uma fonte PNG estática de corpo inteiro, isométrica, para futuro chefe de Shedaklah após o pacto com Zuggtmoy (SPEC-118). Produzir uma manifestação ativa do próprio Juiblex, sem representar o ritual de Thullgrime ou o backup sem consciência. A comparação deverá distinguir a nova proposta tanto do receptáculo humanoide existente quanto da massa dormente PT04.

Proposta física DRAFT: corpo amorfo assimétrico de gel verde-oliva escuro, base larga coesa, lobo principal elevado fora do centro e três filamentos espessos de comprimentos diferentes, dobrados para dentro do quadro. Os filamentos são extensões do mesmo ser, não pequenas criaturas ou raízes de cenário. Forma vigilante em repouso, com direção de frente para baixo/direita; brilho úmido localizado e recessos escuros. Sem forma humana, pernas/braços anatômicos, rosto, olhos definidos, casulo ou núcleo luminoso exposto. Essas ausências fazem parte da proposta experimental, não de uma declaração anatômica canônica. A silhueta ativa e assimétrica, mais larga e filamentosa, diferencia o chefe das referências.

Uma chamada built-in imagegen, 1024×1024 solicitado, alfa verdadeiro, um corpo completo por imagem. Registrar tamanho efetivo retornado. Motivo no máximo 65–70% de largura/altura; margem mínima 10% em todos os lados (caixa alfa >8), sem clipping visível. Fontes intactas em `.atena/generated/art032-juiblex-2026-10-12/sources/MJ01_manifestacao_juiblex_v01.png`, sem substituir arquivos runtime. Registrar prompt, refs/revisões, origem e SHA256; até três versões por defeito, somente ajustes do contrato, histórico preservado. Galeria e prancha Godot com leitura a 80/128 px e comparação do receptáculo na mesma altura visível; PT04 contextual para diferenciar repouso dormente. Prévia pode recortar em memória, sem alterar o PNG original nem determinar tamanho/pivô runtime.

## Bíblia, identidade e contexto

Estilo CANON [PLAN-001](../canon/PLAN-001-nottgard-survivors.md): fantasia sombria isométrica, leitura acima de espetáculo e pouca poluição. Bíblia de produção **DRAFT v01**: pintura com clusters de pixel, câmera três-quartos elevada orientada para baixo/direita, luz superior esquerda, gel viscoso com grandes massas legíveis, filamentos espessos e pouco brilho. Paleta verde-oliva/verde-negro e pequenos reflexos pálidos; contraste pela silhueta e grandes áreas de material, sem depender só da cor. Sem chão, sombra projetada, aura, poça de habilidade, explosão, cenário, raízes interplanares desenhadas, vítimas, slimes menores, texto, moldura, sheet ou animação. Sem anatomia importada de franquias externas.

**Identidade aplicável, não N/A:** Juiblex é a entidade pegajosa e filamentosa vista na Sessão 12; Sessão 16 estabelece mente-colmeia, manifestações são partes do próprio ser. O receptáculo de Thullgrime é um backup sem a consciência do original (Sessão 17 e nota de criatura). Cor/material já usados no projeto são referência de linguagem, não prova de olhos/núcleo ou forma humanoide obrigatórios. Cena textual suficiente: chefe substituto de Shedaklah depois da aliança de Zuggtmoy; sem ilustrar os eventos/desfechos da campanha. Nenhuma posição de mapa é requisito para fonte isolada.

Vault de Nottgard somente leitura é autoridade de lore: `03_NPCs/Juiblex.md`, `07_Criaturas/Receptáculo de Juiblex.md` e Sessões 12/16/17. SPEC-118, `data/enemies.json`, `data/stage_events.json` e `data/boss_phases.json` são contexto da adaptação. Não mexer em números, habilidades, fases, áudio ou código. Verificação local: `assets/enemies/manifestacao_de_juiblex.png` e `assets/enemies/receptaculo_de_juiblex.png` têm o mesmo SHA256 `ce81d3cfd119e64f69b81d38592170dfcb2c3f97393945bb03cdabf714a77b96`; a pendência de arte própria está confirmada. O renderer usa caminho por ID (`ui/enemy_view.gd`); admissão futura ativaria a imagem e exige autorização separada.

Referências visuais locais inspecionadas: receptáculo e slime de Juiblex, apenas câmera/pixel/material/cores, nunca pose humanoide, olhos, núcleo ou identidade do backup. PT04 v02 DRAFT visualmente aceito serve para comparação de silhueta/estado, sem editar a fonte. Nottcard somente leitura: buscas de nomes de arquivos visuais e por “juiblex” nos JSONs de `F:/dev/nottcard/data/` sem resultados; não afirmar ausência global de referências. Papéis/paths/SHA256 no pacote.

Atena prepara inputs, gera/audita e responde pela integração futura; não há necessidade demonstrada de agente especialista delegado. O escopo não altera arquitetura, dependência ou permissão.

## Lacunas, recuperação e aceitação

- **BLOCKING visual:** nenhuma para experimento DRAFT com a identidade acima. **G0 de escopo:** pendente; é o bloqueio operacional antes de geração.
- **RESOLVABLE:** geometria proposta, enquadramento/alfa e diferenciação a 80/128px; corrigir dentro do contrato e levar a revisão humana.
- **DEFERRED:** aceitação visual, canonização de anatomia, animações/direções, tamanho/pivô, contraste em biomas, runtime, integração e playtest. Preparação/admissão das dezesseis fontes anteriores fora deste plano.

Recuperação: preservar fontes/versões, hashes das vinte e quatro fontes históricas ART-032 e dos três recibos, ativos/runtime e cauda `active_plan:`. Se houver conflito relevante de identidade, parar no checkpoint e pedir decisão. Testes de gameplay não são necessários sem runtime alterado; checar PNG/RGBA/alfa/hash/margem, refs/links, consistência de estado e backlog. Critérios técnicos não provam aceitação humana/diversão.

## Plano ordenado

| Posição | Passo | Objetivo / output / checks / gate |
|---:|---|---|
| 1/5 | S-001 prontidão | Lore, identidade/contexto, bíblia, escopo/prompt, refs/hashes, snapshot e estado. Concluído; G0 antes de S-002 pendente. |
| 2/5 | S-002 MJ01 | Uma fonte DRAFT nativa e origem/hash; versão inteira, margens, alfa. Executar após G0 per-plan. |
| 3/5 | S-003 auditoria | Inspecionar fonte, enquadramento/material, comparação com receptáculo e massa; leitura 80/128px, refs/snapshot. |
| 4/5 | S-004 galeria/evidência | PNGs/galeria/prancha Godot, prompts/jobs/auditoria, links e estado. Sem contornar bloqueio conhecido de file:// ou alegar renderização browser. |
| 5/5 | S-005 dono | Aceite visual por revisão ou correção limitada, com geometrias DRAFT explícitas; checkpoint humano obrigatório. |

**1/5 concluído; passo atual S-002 (2/5), três passos depois do atual; checkpoint G0/SCOPE_APPROVAL pendente.** Próximo objetivo preparado: gerar MJ01 após aprovação deste escopo, auditar e apresentar a comparação. G0 autoriza somente esta produção DRAFT; não autoriza promoção a CANON, normalização/admissão, integração, commit, push ou build.

## G0 aprovado — 2026-10-12

Resposta explícita **“Aprovo MJ01 DRAFT”** ao plano v01 de uma fonte estática amorfa/filamentosa, auditoria e galeria comparativa 80/128px. Modalidade per-plan. **S-001 concluído; S-002 autorizado, 1/5 concluído, três passos após o atual.** Zero lacunas BLOCKING para hipótese DRAFT. Produção/correções do contrato autorizadas; aceite visual S-005 posterior. Sem integração, CANON, preparação/admissão, commit, push ou build. Texto anterior registra a preparação antes deste aceite.

## Entrega S-004 — 2026-10-12

**4/5 passos concluídos; S-005 atual, zero passos após o atual.** Candidata **MJ01 Manifestação de Juiblex v03**, DRAFT. Três saídas nativas 1254×1254 RGBA (pedido 1024×1024) preservadas, sem limpeza/recorte/redimensionamento original. Correções exclusivamente de enquadramento: v01 margem 4,23%; v02 margem 13,16% mas largura 72,09%; ambas não selecionadas. v03 ocupa 60,53% da largura e 48,09% da altura, margem mínima 18,26%, borda totalmente transparente. Hash nativo/cópia verificado.

[Galeria](../../generated/art032-juiblex-2026-10-12/index.html), [prancha comparativa](../../generated/art032-juiblex-2026-10-12/review-reading.png), [auditoria](../../generated/art032-juiblex-2026-10-12/audit.json), [prompts](../../generated/art032-juiblex-2026-10-12/prompts.md), [evidência](../../evidence/art032-juiblex-delivery-2026-10-12.md). Seis prévias Godot completas, comparando MJ01/receptáculo/PT04 com a mesma altura visível a 80/128px. Igualar altura serve à comparação de forma, não fixa escala runtime. Fontes antigas e cadeia PLAN-071 conferidas; links/metadados verificados. Não alegar render browser ou playtest.

Próximo objetivo S-005: dono avaliar silhueta/filamentos, estilo/material, diferenciação do receptáculo e da massa dormente, leitura 80/128px e geometria experimental DRAFT. Inputs são v03 e comparação; output aceite identificado ou correção por código. **Aceite visual humano pendente**, sem CANON, preparação/admissão, integração, commit, push ou build. O limite de três versões por defeito de enquadramento foi consumido; eventual novo defeito exige registro e checkpoint próprio. Textos anteriores registram os estados de preparação/aprovação.

## Fechamento S-005 — 2026-10-12

**5/5 passos concluídos; zero passos restantes.** Resposta explícita **“Aprovo visualmente MJ01 v03”** ao gate identificado da candidata e comparação 80/128px. Classificação desta decisão **IN_PLAN**. Aceite exclusivo de **MJ01 Manifestação de Juiblex v03**, com silhueta/base/três extensões/material e margem/borda apresentados; geometrias continuam hipóteses DRAFT. [Recibo por revisão/hash](../../generated/art032-juiblex-2026-10-12/visual-acceptance.json). v01/v02 históricos não foram aceitos. Fontes e prancha de entrega permanecem intactas; esta última conserva a indicação histórica pré-aceite.

ART-032 tem agora **dezessete fontes selecionadas DRAFT visualmente aceitas** nos quatro planos, em vinte e sete originais preservados. Admissão/runtime, animações, contraste em bioma e demais conteúdos adiados não estão concluídos. Não houve CANON, normalização, integração, novo commit, push ou build. Registros/estado/jobs/auditoria/QA/galeria/backlog reconciliados; fontes/referências/recibos anteriores/runtime/cauda PLAN-071 conferidos por hash, Git preservado.

Próximo objetivo preparado: **plano futuro de preparação/admissão ART-032**, com as dezessete revisões e quatro recibos, identidade/contexto/bíblia, contrato de tamanho/pivô/transparência e pontos de consumo SPEC-118/renderer como inputs. Saída futura: escopo e destinos limitados, transformação determinística preservando originais, auditoria/galeria e gates de admissão/integração próprios. Nenhuma execução desse próximo plano é autorizada pelo aceite visual. Textos anteriores mantêm o histórico de preparação/produção/entrega.
