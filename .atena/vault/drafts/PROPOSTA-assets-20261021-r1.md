# Produção de assets — proposta DRAFT r1

Data: 2026-10-21. Origem: pedido guiado do dono nesta sessão. Estado: DRAFT, sem promoção a CANON. Plano pai: PLAN-103, marco M5/B-006.

## Registro inicial da proposta (histórico)

Preparar e produzir candidatas raster dos lotes U, V, Q, C e N descritos pelo dono. A lista `ASSET-GENERATION-LIST-20261021-r1.md` e o diagnóstico `ASSET-CHECKUP-20261021-r1.md` determinarão cada destino, dimensão final, defeito, referências e prompt; ambos ainda não foram localizados. Não reconstruir seu conteúdo por suposição.

Prioridade solicitada: U01–U08, V01/V07, Quartel, miniaturas e introduções. Demais V01–V11 e personagens N permanecem no escopo proposto, com sequência posterior a confirmar na leitura dos documentos. Nomes citados: Reaper, Beholder, Kein, Astherion e Kūkan Shito. Não presumir identidade ou lista completa.

Fontes de geração com fundo cinza ou magenta liso, conforme pedido; escolher por contraste com a paleta da peça. A remoção relatada pelo dono para Síntese e Nidhogg é evidência fornecida, não teste repetido nesta sessão. Derivados finais respeitarão dimensões e transparência previstas pelo contrato de cada item.

## Sequência delimitada proposta

1. S-001 — conferir os dois documentos, consumidores/dimensões, bible visual, identidade e contexto; preparar manifesto e prompts resolvidos.
2. S-002 / B-001 — U01–U08; conferir também o esboço citado de três cartões verticais, sem inventar seu código.
3. S-003 / B-002 — V01 e V07.
4. S-004 / B-003 — Quartel: 18 melhorias, 9 marcas e 12 categorias, sujeitos à conferência da lista.
5. S-005 / B-004 — miniaturas.
6. S-006 / B-005 — oito introduções de chefe.
7. S-007 / B-006 — demais V e lote N, somente após inventário completo e confirmação de escopo.
8. S-008 — consolidar manifesto, galeria, evidências e pendências de aceite visual.

Batches estáveis propostos, ainda não executáveis. Quantidade de chamadas só será definida pelo inventário; uma chamada ImageGen por peça distinta. Sem agentes delegados. Integração e revisão sob responsabilidade da Atena nesta sessão.

## Prontidão inicial (histórico)

- BLOCKING: localizar os dois documentos e resolver seus anexos CANON; sem isso não há contrato por peça verificável.
- RESOLVIDO: nível de aprovação **por plano (per-plan)** selecionado pelo dono: "atena por plano". Não repetir a seleção. O contrato completo ainda depende dos documentos ausentes. A ordem proposta detalha a frente M5 e não substitui o PLAN-103; seu checkpoint atual permanece preservado.
- RESOLVABLE: conferir referências, revisões, autoridade, condições de uso e bible antes de cada geração. Identidade de personagem é N/A para UI sem entidade; símbolos representados ainda exigem identidade e fonte. Contexto de UI deve incluir layout, escala e legibilidade. Para entidades, registrar identidade, cena, câmera e materiais antes da produção.
- DEFERRED: admissão no runtime, mudanças mecânicas/arquiteturais, promoção canônica, commit, push, build, exportação e publicação. Não autorizados por esta proposta.

## Aceite, rastreabilidade e recuperação

Guardar fontes e candidatas versionadas em `.atena/generated/asset-production-20261021-r1/`, sem sobrescrever assets existentes. Registrar por item: código, origem documental, prompt completo/blocos, referências e revisão CANON/DRAFT, saída, dimensões, fundo, revisão candidata e resultado da inspeção. Avaliar fidelidade à identidade e à bible, recorte/margens, resíduos de fundo, texto acidental e leitura no tamanho final. Preparar galeria para aceite visual do dono. Correções objetivas até três candidatas por peça; depois registrar bloqueio para decisão. Recuperação: descartar seletivamente candidatas novas; originais permanecem preservados.

Nenhuma aprovação visual, satisfação subjetiva ou playtest é presumido. Evidência desta preparação: leitura de add.yaml, plan.yaml, estado PLAN-103, CANON PLAN-001 e EVID-275; busca pelos dois nomes em todas as worktrees registradas e na cópia principal sem resultados. Backlog conferido: 0 P0, 4 P1 abertos, 18 P1 implementados aguardando playtest, 0 alertas de organização. RTK já registrado como enabled no add.yaml. Nenhuma geração realizada.

Autorização de execução: dono respondeu "aprovado, pode gerar" em 2026-10-21. Escopo proposto aprovado por plano; não pedir nova aprovação para gerar dentro dele. A aprovação não promove conteúdo a CANON nem elimina a necessidade dos documentos e referências de cada peça.

Próximo objetivo: obter caminhos acessíveis dos documentos, concluir S-001 e gerar dentro do escopo aprovado. Checkpoint: S-001/INPUT_DOCUMENTS_PENDING. Modo: per-plan. Etapa 1/8, zero concluídas, sete restantes após a atual. Nenhuma geração realizada.

## Reconciliação operacional — checkpoint de commit em 2026-10-21

Os dois documentos foram localizados em F:/dev/abyss-megadungeon/.atena/vault/drafts e copiados para a pasta desta produção. As pendências iniciais de localização foram resolvidas; o inventário completo está autorizado por plano. A prontidão visual e as decisões de autoridade estão em visual-readiness.md.

S-001 a S-006 concluídas; S-007 em execução (etapa 7/8; seis concluídas, uma após a atual). Foram produzidas 96 fontes PNG DRAFT: 92 selecionadas tecnicamente e quatro versões substituídas preservadas. U, V, Q e C têm fontes; N01 Reaper tem três poses. Restam 33 poses de N02–N10; N11 reutiliza o mímico existente, sem nova imagem. Próximo objetivo: N02, com os prompts e anexos de remaining-n-jobs.json; saída PNG DRAFT e inspeção de identidade/margens, autorizadas pelo plano vigente. S-008 consolida a entrega e o aceite humano.

O dono autorizou commit local ao responder “commit”. Push, integração, promoção canônica, build e publicação continuam sem autorização. Este checkpoint é parcial; 38 PNGs foram entregues a assets_incoming do projeto PC, e os demais permanecem nesta cópia de trabalho. A aprovação de geração não equivale a aceite visual. As fontes ainda requerem preparação para o tamanho final e transparência quando aplicável.