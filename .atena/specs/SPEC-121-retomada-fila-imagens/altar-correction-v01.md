# AL01-CORR/v01 — proposta DRAFT de correção do altar

Aceite visual posterior: dono aprovou “Aprovo com ciclo de 900 ms”. Tira AL01_loop_v03 e seis frames promovidos a CANON de preparação visual conforme [registro](../../vault/canon/ASSET-APPROVAL-FILA028-ALTAR-CORRECTION-v01.md); S-006/ACCEPTED. Sem integração, commit ou push autorizados. Trechos DRAFT/PENDING abaixo são históricos da proposta/entrega.

Atualização de execução: dono aprovou “Aprovo a correção do altar”. Cinco etapas executadas; [evidência](../../evidence/fila028-altar-correction-2026-10-10.md). Doze checks técnicos aprovados, candidata DRAFT AL01_loop_v03 aguardando OWNER-ALTAR-REVIEW. A proposta original abaixo preserva o contexto anterior ao aceite do escopo.

Pedido: “atena, proxima pendencia”, após aceite e commit local 7af88e7 das 33 derivadas. Classificação PLAN_CHANGE_REQUEST: preparação anterior concluiu seis etapas e reteve AL01; fabricar novos quadros de efeito excede o método anterior, que proibia novos quadros. Proposta delimitada à correção do altar; per-plan já escolhido preservado, escopo de execução PENDING. [Estado](../../state/fila028-altar-correction.yaml).

## Evidência e prontidão visual

Fonte de identidade CANON AL01 v02 e aceite das quatro velas: [registro](../../vault/canon/ASSET-APPROVAL-FILA028-AL-EV-2026-10-10.md), [fonte](../../generated/fila028-generation-2026-10-10/native-sources/AL01_v02.png). Frame inicial recortado de preparação DRAFT retida: [f0](../../generated/fila028-preparation-2026-10-10/frames/AL01_v02_f0.png). [Auditoria anterior](../../generated/fila028-preparation-2026-10-10/audit.json): na ROI de corpo 65,110–125,140, 1.750–1.795 pixels RGB mudam entre quadros. Corpo opaco na ROI; amostra não equivale a máscara completa. Altar rejeitado por invariância, não por dimensões.

Bíblia aplicável: pixel art sombria nítida, câmera isométrica três quartos, luz principal superior esquerda, pedra escura, pano vermelho, bacia circular, metal escuro e quatro velas da identidade aceita. Cena isolada, sem cenário/texto/emblemas. Identidade de personagem N/A, entidade é o altar. Referência ativa altar_active.png orientou fonte v02, mas conteúdo aceito v02 é autoridade desta correção. Nenhuma lore/facção nova. Fonte CANON preservada; frame f0 DRAFT autorizado apenas como entrada experimental após aprovação; correção resultante DRAFT até revisão identificada.

## Método recomendado

Godot Image determinístico local, sem IA, instalação ou edição por Python. Reutilizar um único corpo do primeiro quadro já recortado, incluindo pedra/pano/bacia/metal/corpos das velas. Marcar manualmente regiões/máscaras das quatro chamas acima dos pavios e das brasas dentro da bacia, com margem mínima para efeito. Reutilizar pixels das próprias chamas em camadas separadas para oscilação discreta de até um pixel na região livre acima dos pavios, se não interferir no corpo; modular calor/brilho apenas nas máscaras de fogo/brasas, nunca no pano/pedra/borda da bacia. Não repintar identidade nem usar quadros cuja pedra varia. Se separar uma chama demandar reconstruir corpo oculto, preservar sua forma e usar apenas pulsação de brilho nessa região, registrando a limitação. Remover pequenos resíduos de fundo somente onde confirmados como fundo nas máscaras, sem alterar o arquivo original.

Gerar seis fases de ciclo periódico com variação sutil, corpo/pivô/escala constantes. Não exigir que último frame seja cópia do primeiro: conferir a transição cíclica último→primeiro na mesma cadência das demais. Tempo de preview inicial 900 ms, ajustável na galeria entre 600/900/1200 ms; escolha de ritmo é humana. Sem afirmar diversão/playtest nem integração.

## Cinco etapas e critérios

S-001 BASE_MASKS: registrar hashes/revisões, base 192×192 e máscaras separadas de corpo, fogo e área permitida de efeitos; preview das máscaras confirma exclusão de pedra/pano/bacia/velas físicas. Se máscaras não puderem ser isoladas com segurança, segurar correção com evidência, sem inventar pixels de corpo.

S-002 EFFECT_FRAMES: seis quadros 192×192 derivados da mesma base, somente efeitos nas máscaras aprovadas pelo contrato. Salvar base, máscaras e parâmetros; nenhum assets ativo modificado.

S-003 PACK: tira RGBA 1152×192 com seis células, ordem 0–5. Saídas em `.atena/generated/fila028-altar-correction-2026-10-10/` apenas, `normalized/AL01_loop_v03.png` e frames irmãos. Fonte AL01 v02 e derivada retida anterior preservadas. Nome v03 identifica candidata derivada, não nova fonte CANON.

S-004 AUDIT: dimensões, transparência de fundo, fontes/33 peças aceitas intactas por hash, corpo completamente igual à base fora das áreas de efeito (RGB e alfa, todos os pixels), corpo segmentado opaco em todos os quadros, âncora invariável, zero diferenças não autorizadas, máscaras limitadas às chamas/brasas. Checar variação real no fogo em pelo menos quatro quadros distintos e transições cíclicas sem deslocamento de corpo; medir deltas entre pares adjacentes inclusive 5→0 e inspecionar preview. Nada de usar só ROI para afirmar corpo inteiro invariável. Se falhar, reter resultado e documentar até três ajustes locais pertinentes; sem nova IA ou expansão criativa automática.

S-005 GALLERY: comparação fonte/frame fixo/loop retido/correção, máscaras sobrepostas, seis quadros, fundos escuro/claro/checker e cadências. Links e contrato conferidos, evidência e estado persistente atualizados. Checkpoint OWNER-ALTAR-REVIEW; aparência/ritmo do loop, conservação de materiais e quatro velas precisam do dono antes de promoção.

## Impacto, recuperação e pendências

Impacto: autoriza nova construção técnica DRAFT dos efeitos; não promove a candidata ou muda as 33 peças CANON. AL01 anterior segue retido até aceite de nova revisão. PLAN-071 e retorno S-007/ORIGINAL-GENERATIONS/NORMALIZATION-EXTRACTION-11 preservados. Depois do altar, retornar à extração/normalização pendente dos heróis, sujeito ao estado aprovado daquele plano.

BLOCKING: aprovação desta proposta/método; único gate de início. RESOLVABLE: delimitação das máscaras, remoção de resíduos, intensidade/defasagem dos efeitos e velocidade de preview. DEFERRED: integração no jogo, playtest, promoção CANON, commit, push, merge. Não instalar dependências. Recuperação: preservar fontes/arte aprovada, manter pacote novo isolado para revisão ou descarte autorizado; sem sobrescrever resultados anteriores.
