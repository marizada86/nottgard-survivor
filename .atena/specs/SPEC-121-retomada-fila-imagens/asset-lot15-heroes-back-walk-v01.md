# ASSET-LOT15/v01 — caminhadas de costas, ART-033/BUG-027

DRAFT, origin planned, implementation_preceded_spec false. Pedido “aprovado, commit e continue”2026-10-17 aceita LOT14 e autoriza commit local. Novo lote proposto é PLAN_CHANGE_REQUEST, per-plan preservado, aprovação de produção PENDING. Nenhuma geração antes da aprovação deste escopo.

## Autoridade e diagnóstico atual

[ART-PROMPTS-056](../../generated/ART-PROMPTS-056-costas-ao-andar-para-cima-zynara-leoric-nyrelia.md), [SPEC-123](../SPEC-123-revisao-da-movimentacao-dos-herois.md), [prompts históricos](../../generated/heroes-back-walk-prompts-2026-10-04.json), [BUG-027/ART-033](../../backlog/BUGS.md), `ui/hero_view.gd`. Nove fontes atuais inspecionadas: idle/move_n/move_ne de Zynara, Leoric e Nyrelia. As seis caminhadas ainda mostram rosto ou máscara/broche frontal; código não cria costas. [Snapshots por hash](../../generated/asset-lot15-2026-10-17/references.json).

AO09/AO10/ER03/ER06 aparecem pendentes em registros antigos, mas evidência posterior hero-admission-v01 já registra18tiras/101poses aceitas; não regenerar por cabeçalho histórico. Escolha LOT15 se baseia no BUG-027 ainda aberto e nas fontes atuais vistas.

## Bíblia/identidade/cena DRAFT v01

Três entidades nomeadas, identidade pessoal aplicável. Costas derivadas das frentes são hipóteses visuais já previstas no ART-033/056; novas revisões permanecem DRAFT e precisam de aceite humano, inclusive primeiro quadro de cada herói antes de integração.

- Zynara: elfa alta/esguia, cabelos muito longos prata/brancos, orelhas pontudas, casaco preto com bordados dourados em barra/punhos, botas pretas, bolsa no quadril anatômico direito, pequena ampulheta na mão anatômica esquerda. Costas: cabelos sobre omoplatas e bordado de barra coerente; não copiar detalhes exclusivos da frente para trás. Ampulheta visível à esquerda da tela na vista posterior.
- Leoric: porte baixo/compacto do idle, chapéu preto com faixa castanha, casaco/manto castanho, botas e cajado de madeira retorcida com cristal azul na mão anatômica direita (direita da tela de costas). Não desenhar barba/rosto na nuca, não aumentar corpo para altura humana.
- Nyrelia: capuz e manto verde muito escuro, bordas e painel vertical dourados previstos como proposta de costas em ART-056, roupa interna/botas escuras. Mostrar traseira do capuz/manto, sem máscara frontal ou broches frontais nas costas, sem criar arma ou símbolo narrativo.

Vista elevada isométrica, luz superior esquerda e acabamento pixel art de cada idle, sem impor ao Leoric as proporções dos outros. Norte: costas completas; NE: três quartos de costas indo para cima/direita, nenhuma face/olho/máscara frontal; borda de orelha de Zynara permitida sem rosto. Não espelhar para fabricar mão/direção.

Contexto textual: deslocamento nos mapas existentes, sem cenário no PNG. Ciclo alterna pernas/pés, com balanço contido de cabelo/tecido; não animar só tecido enquanto personagem desliza. Sem flutuação nova. Referência de ritmo atual é defeituosa na orientação e NÃO autoridade de face/costas.

## Escopo

| Grupo | Fontes | Direção | Poses |
|---|---|---|---:|
| ZN | ZN00..05 | Zynara norte |6|
| ZE | ZE00..05 | Zynara nordeste |6|
| LN | LN00..05 | Leoric norte |6|
| LE | LE00..05 | Leoric nordeste |6|
| YN | YN00..05 | Nyrelia norte |6|
| YE | YE00..05 | Nyrelia nordeste |6|

36PNGs individuais/36desenhos, seis entradas de revisão conjunta. Cada ciclo: contato direito→recuo/transferência→passagem→contato esquerdo→recuo→passagem/retorno. Primeiro N por herói ancora escala/roupa posterior dos demais. NE usa a mesma identidade posterior com rotação de câmera/facing solicitada, não espelho.

Solicitar canvas1024quadrado, apoio em82% e margem≥12%, medir dimensão real. Escala relativa dos heróis deve respeitar idle: alturas corporais de referência Zynara368, Leoric224, Nyrelia352 nos assets atuais, não normalizar todos para a mesma altura visível. Alvos técnicos finais ART-056 (células256×384, bases376/368/368, spread≤12px/centro≤9px/largura≤16%) pertencem à preparação; medir proxies nativos agora sem alegar equivalência automática entre1254px e célula final.

## Etapas e checkpoints

1. S-001 prontidão/proposta: nove referências vistas/hash, diagnóstico, bíblia, identidade e cena textual estruturados. Único BLOCKING: aprovação do novo escopo/orçamento/revisão conjunta. Modo per-plan já selecionado; não repetir escolha de nível.
2. S-002 produção built-in imagegen, um PNG por pose, máximo3tentativas por arquivo e108chamadas no total. Fontes versionadas em `.atena/generated/art-candidates/asset-lot15/`, prompts/origens/entradas preservados. Sem fabricar poses por recorte/espelho/translação de sprites antigos.
3. S-003 QA: costas reais nos36quadros, mão/ampulheta/cajado, traje/escala/altura relativa, passos alternados, opacidade/margens/banda4px, bbox/apoio/continuidade e retorno. Leituras48/80/128, contatos integrais sem alinhamento escondido; flags para face/máscara/cajado trocado/escala/recorte. Após limite, reter quadro/grupo afetado. Nenhum novo desenho de costas promovido CANON pelo modelo.
4. S-004 galeria conjunta em `.atena/generated/asset-lot15-2026-10-17/`, seis players loop6 com pausa/replay/FPS/repeat/scrub, manifestos/refs/hash/origens/prompts/evidência/handoff local para Claude. Checar links/controles offline e distinguir de render real. Parar no aceite humano dos primeiros quadros/36revisões, aceitação parcial por herói/direção/revisão possível, antes de qualquer integração.

RESOLVABLE: consistência posterior, vista NE, mão/acessório, escala/apoio/alfa/margens e ritmo. DEFERRED: normalização/pivô/packing/import, consumer/flipNW/temporização, suíte runtime e playtest/feeling em run. Não declarar BUG-027 corrigido só por gerar fontes; implementação e teste com Claude em escopo posterior. Costas novas permanecem DRAFT.

## Impacto e recuperação

Não substitui LOT14 aceito nem libera retenções históricas. PLAN-103/PLAN-053/SPEC-123 preservados. Sem código/dados/assets oficiais, dependências, arquitetura material, lore externo, publicação/commit/push/exportação/merge ou mensagem a outro chat. Recuperação por fontes versionadas/hashes e seleção explícita, sem sobrescrever originais. Aprovação do LOT14 não autoriza este novo lote; aguardando confirmação deste LOT15/v01.

Aprovação explícita2026-10-17: “aprovo, por plano”. Escopo36fontes/108chamadas máximas/revisão conjunta autorizado; S-001 concluída, S-002 executável. Supera PENDING_SCOPE_APPROVAL anterior; não autoriza implementação, CANON, commit ou push.

## Resultado da execução autorizada — 2026-10-17

S-001..S-004 concluídas para produção/revisão local:36fontes selecionadas/52tentativas, seis ciclos6quadros. ZN00/ZE03/ZE04/LE03/LE04/YE01/YE02/YE05v02, YN03/YN04/YE03/YE04v03, demaisv01. [Galeria](../../generated/asset-lot15-2026-10-17/index.html), [manifesto](../../generated/asset-lot15-2026-10-17/manifest.json) e [evidência](../../evidence/asset-lot15-heroes-back-walk-2026-10-17.md).

Inspeção não libera uso direto: alfa modal253/resíduos,11margens abaixo12%, registro/escala/cadência pendentes. Nyrelia03/04 N/NE atingiu3tentativas e mantém deslocamento vertical; reter para preparação/revisão. Bbox não certifica pivô nem escala anatômica; proporção final requer comparação aos idles. Retenções históricas preservadas, BUG-027 aberto.

Checkpoint atual OWNER_JOINT_VISUAL_REVIEW/PENDING: primeiro quadro por herói/direção e36revisões aguardam aceite humano, parcial por herói/direção/revisão permitido. Tudo DRAFT, sem runtime/CANON. Próximo objetivo após aceite: preparação/implementação com Claude em escopo posterior. O PENDING inicial e proposal-check.json são histórico de prontidão, superados pela aprovação explícita do plano; não significam aprovação visual das saídas.
## Aceite visual e continuação — 2026-10-17

“aprovado, proximo” aceita os primeiros quadros e as36revisões selecionadas deste lote como direção visual DRAFT. [Recibo por hash](../../generated/asset-lot15-2026-10-17/visual-acceptance.json). Supera o checkpoint visual PENDING acima, preservando todas as retenções técnicas e BUG-027 aberto. Não promove CANON nem autoriza implementação/commit/push.

Continuação IN_PLAN de reconciliação operacional e entrega: verificar coberturas posteriores das filas locais e reunir links/fontes/retenções para Claude em [índice consolidado](../../generated/asset-production-handoff-2026-10-17/index.html). Sem orçamento novo de geração; nenhuma nova fonte obrigatória identificada no catálogo local inspecionado. Não declara completude de fontes históricas recuperadas nem aceite in-game.
