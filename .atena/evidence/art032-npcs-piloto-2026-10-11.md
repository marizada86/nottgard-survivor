# ART-032 — quatro fontes DRAFT, 2026-10-11

Plano [PLAN-ART032-NPCS-PILOTO/v01](../vault/drafts/PLAN-ART032-NPCS-PILOTO-v01.md), aprovado antes da produção com **“Aprovo as quatro peças DRAFT”**, modo per-plan. Classificação/rota preservadas: produção selecionada agora, mantendo PLAN-071 e revisão de heróis. Quatro de cinco passos concluídos; S-005 revisão visual do dono pendente. Estado: [art032-npcs-piloto.yaml](../state/art032-npcs-piloto.yaml). Nenhuma promoção a CANON, admissão runtime, commit, push ou build neste lote.

## Fontes e revisões

| Peça DRAFT | Fonte nativa | Margem mínima (alfa > 8) | Alfa máximo na borda |
|---|---|---:|---:|
| NP01 João Barbosa v02 | [PNG](../generated/art032-npcs-2026-10-11/sources/NP01_joao_barbosa_v02.png) | 15,15% | 0/255 |
| NP02 desertor de Durao v01 | [PNG](../generated/art032-npcs-2026-10-11/sources/NP02_desertor_durao_v01.png) | 11,40% | 1/255 |
| NP03 vítima enfeitiçada v01 | [PNG](../generated/art032-npcs-2026-10-11/sources/NP03_vitima_enfeiticada_v01.png) | 12,52% | 1/255 |
| PT01 Estrela do Norte v01 | [PNG](../generated/art032-npcs-2026-10-11/sources/PT01_estrela_do_norte_v01.png) | 12,44% | 1/255 |

Cinco saídas nativas preservadas em quatro candidatas. [NP01 v01](../generated/art032-npcs-2026-10-11/sources/NP01_joao_barbosa_v01.png) tinha margem mínima de 5,58%; uma correção dirigida de enquadramento via imagegen produziu v02, mantendo a identidade proposta. Histórico não selecionado e não apagado. Fontes reais 1254×1254 PNG RGBA, apesar do pedido 1024×1024. Cópias byte a byte idênticas aos originais do built-in **image_gen**; sem limpeza ou redimensionamento nativo. Três bordas têm alfa residual 1/255, registrado, sem corte visível do objeto. Alfa > 8 é uma aproximação da caixa visível; brilhos muito fracos podem ultrapassá-la.

Referências/autoridade: direção CANON PLAN-001; sprites locais de Durvall/curandeiro apenas para câmera/acabamento; João Barbosa, Tou Um, Tou Um e Lu Yueh, Sessões 16/18 do vault somente leitura para papéis/contexto. Revisões e hashes completos em [jobs.json](../generated/art032-npcs-2026-10-11/jobs.json). Aparência de João/desertor é hipótese DRAFT; espécie/gênero do desertor não definidos, rosto oculto. Vítima humana adulta genérica. PT01 é miragem/ponto de orientação, identidade de personagem N/A; geometria luminosa não é símbolo canônico.

## Verificação e limites

[Auditoria](../generated/art032-npcs-2026-10-11/audit.json): PASS_WITH_NATIVE_ALPHA_NOTE. PNG/RGBA/transparência verdadeira/hash/dimensões/margem/corpo inteiro conferidos; hashes das referências, dos arquivos runtime/assets/data/testes protegidos e da cadeia ativa PLAN-071 inalterados. HEAD continua fc5c709f3ef5c4acdc7c5a8a842747b72c7f70ec. Nenhuma suite de gameplay reexecutada: produção isolada, sem alteração runtime; isto não é playtest.

[Galeria HTML](../generated/art032-npcs-2026-10-11/index.html) entregue com links locais e metadados das cinco prévias validados. A inspeção de renderização pelo navegador não ocorreu: sua política bloqueia URLs file://. Não foi tentado contorno do bloqueio. Alternativa independente: [prancha estática Godot](../generated/art032-npcs-2026-10-11/review-reading.png), renderizada em OpenGL Compatibility e inspecionada, com recortes somente em memória e alturas de motivo de 80 px (atores) e 48/80 px (estrela). Não equivale à normalização PNG final nem a uma captura do jogo. [QA](../generated/art032-npcs-2026-10-11/gallery-qa.json) e [log de render](../generated/art032-npcs-2026-10-11/preview-renderer/render-log.txt) registram execução/limites. Avisos ambientais de cache de shader e certificados não impediram o PNG; não houve operação de rede. Erro inicial de inferência de tipo do script corrigido antes da execução válida.

Verificação final: `git diff --check` sem erros de whitespace; `tools/backlog_check.ps1 -Brief` registrou P0=0, P1 abertos=4, P1 implementados aguardando playtest=14, verificações manuais pendentes=0 e alertas de organização=0. Alterações alheias pré-existentes preservadas; nenhum staging/commit nesta produção.

Inspeção Atena: cajado e traje azul/marfim distinguem João; capuz/pose retraída distinguem desertor; postura curvada/mão no peito e roupa malva distinguem vítima a 80 px. Núcleo e pontas da estrela legíveis a 48/80 px. Contraste sobre mapas, identidade definitiva, adequação subjetiva e conforto dependem de revisão humana/etapas futuras; não são aceites inferidos.

[Prompts completos](../generated/art032-npcs-2026-10-11/prompts.md) incluem revisões finais e histórico; [correção João v02](../generated/art032-npcs-2026-10-11/correction-NP01-v02.txt). Native outputs/default tool origin and SHA256 remain in jobs.json.

## Próximo checkpoint

S-005, posição 5/5, quatro concluídos, zero após o passo atual. Objetivo: o dono avaliar **NP01 v02, NP02 v01, NP03 v01, PT01 v01** na prancha/fontes. Conferir estilo/câmera, proposta física de João, rosto oculto/neutralidade de espécie do desertor, leitura da vítima a 80 px e da estrela a 48/80 px. Saída: aceite visual das revisões explicitamente identificadas ou ajustes por código. Aceite ainda PENDENTE; não autoriza automaticamente integração, CANON, commit ou push. Demais peças de ART-032 permanecem abertas.

## Aceite visual registrado — 2026-10-11

O dono aprovou explicitamente **NP01 João Barbosa v02, NP02 desertor v01, NP03 vítima v01 e PT01 Estrela do Norte v01** com “Aprovo visualmente as quatro revisões”. A pergunta incluía estilo/aparência proposta, leitura dos atores a 80 px, estrela a 48/80 px e ressalva de alfa 1/255. [Recibo com hashes](../generated/art032-npcs-2026-10-11/visual-acceptance.json). S-005 concluído; total **5/5**, zero passos restantes. As seções anteriores são o histórico da entrega antes do aceite; o estado atual prevalece neste fechamento. Fontes continuam DRAFT; NP01 v01 histórico não aprovado. Sem promoção a CANON, normalização/admissão, integração, commit, push ou build. Aceite visual não é playtest nem teste de contraste sobre os mapas. Estados, jobs/auditoria/QA, galeria e backlog reconciliados; hashes nativos e cadeia PLAN-071 protegidos. Próxima execução exige novo escopo/checkpoint aprovado.
