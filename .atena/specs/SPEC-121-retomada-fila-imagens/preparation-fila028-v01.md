# FILA-028-PREP/v01 — preparação proposta de 34 fontes CANON

Pedido “atena, aprovado, commit e continue”; aceite e commit das últimas onze fontes concluídos em 09bdda2. Continuação classificada PLAN_CHANGE_REQUEST, pois os planos de geração excluíam recorte, exportação final e montagem. Modalidade per-plan preservada; escopo desta preparação aguarda aprovação. Registro de fontes CANON não é admissão runtime.

## Escopo e etapas

S-001 validar ferramentas locais e consolidar parâmetros/máscaras; S-002 preparar quinze ícones IC01–IC13/I01/I02; S-003 preparar dezoito props/NPCs EV01–EV06/AR01/SE01–SE11; S-004 extrair e montar seis quadros do altar AL01; S-005 auditar imagens derivadas, margens, alfa, contaminação, identidade e pareamento; S-006 galeria/preview do loop e entrega com evidência.

Entradas: [manifesto de 34 fontes](../../generated/fila028-preparation-2026-10-10/manifest.json), hashes conferidos, registros CANON AL/EV, IC/AR/SE e REMAINING. Saídas propostas exclusivamente `.atena/generated/fila028-preparation-2026-10-10/normalized/`, máscaras, frames, parâmetros, auditoria e galeria no mesmo pacote. Nunca sobrescrever fontes ou assets ativos. Derivadas DRAFT técnico até revisão da preparação.

## Método proposto para aprovação

Processamento determinístico com ferramenta local Godot já adotada pelo projeto: adaptar somente para o pacote os métodos existentes `tools/normalize_lote_2_candidates.gd` e `tools/normalize_animation_grid.gd`, usando Image para remoção do fundo, recorte, redução e montagem. Sem nova geração por IA, repintura ou mudanças criativas. Godot será localizado e validado antes de executar; não instalar dependências se ausente. Python permitido apenas para hashes, metadados e relatórios, sem editar pixels.

Ícones: preservar alfa nativo, enquadrar proporcionalmente em 128×128 com contorno/margens adequados, sem esticar. IC04/IC03 têm exceções nas fontes aceitas; preparação pode acrescentar margem transparente preservando desenho. Auditar margem 15% nos IC, 18% em I01/I02 e evitar corte de brilhos.

Props: remover ciano/magenta por máscaras conectadas às bordas com tolerância medida do fundo; separar regiões internas de fundo somente quando confirmadas visualmente. Não apagar tons válidos do objeto pelo matiz apenas. Preservar transparência visual sugerida/cores dos cristais e brilhos; se houver ambiguidade ou perda material, registrar e segurar a peça para revisão, sem inventar fidelidade. Reduzir proporcionalmente e centralizar em 256×256; Eco SE01 em 128×128. Parear SE02/SE03 por corpo arquitetônico, preservando base/selos e abertura; padding pode variar, câmera não pode ser repintada.

Altar: fonte AL01 v02 1536×1024, grade 3×2 divisível, seis células 512×512, ordem esquerda-direita/cima-baixo. Remover magenta por célula e montar linha 1152×192 de seis quadros 192×192. Corpo da pedra/pano/bacia opaco, mesma escala e âncora em todos; brilho/chamas variáveis. Conferir diferenças reais entre quadros antes de afirmar invariância/loop; se a fonte aprovada não suportar o contrato, deixar AL01 retido com evidência. Não fabricar novos quadros nem alterar conteúdo.

## Prontidão visual e aceite

Direção e identidades vêm das 34 fontes aceitas e prompts autoritativos. Cena isolada, view de trabalho existente. Identidades de personagens aplicáveis AR01/EV03/EV04 genéricas já aprovadas; demais entidades objetos/símbolos. Referências/revisões estão no manifesto e registros; fontes CANON, derivadas DRAFT técnico. Preparação não promove lore ou arquitetura.

Checks: SHA256 das fontes antes/depois iguais, 34 entradas identificadas, saídas RGBA/dimensões exatas, ausência de bordas chroma e perda de silhueta, margens ícones, corpo do altar alfa 1, âncora/invariância e prévia de loop. Galeria com fundos claro/escuro/checker e tamanhos reais, links válidos, comparação fonte/derivada e câmaras pareadas. Usar ferramentas de alfa existentes no escopo do pacote. Definir máscaras específicas em vez de testes que apenas espelhem o script. Revisão humana decide contorno, materiais/transparência e loop; sem playtest do jogo nesta etapa.

BLOCKING: aprovação deste plano/método. RESOLVABLE: localizar Godot existente, limiar chroma, máscaras, pivôs/ocupação e extração do altar. DEFERRED: admissão em assets, mudanças de código, testes de jogo/playtest, merge, commit/push e heróis. Sem publicação ou alteração de save. Checkpoint final OWNER-PREPARATION-REVIEW; peças que falhem ficam retidas com motivo. Recuperação: descartar apenas derivadas do pacote se necessário, fontes intactas; manter PLAN-071 e retorno dos heróis NORMALIZATION-EXTRACTION-11.

## Execução autorizada e resultado

Dono aprovou “Aprovo a preparação das 34 fontes”. Seis etapas executadas em modalidade per-plan; [evidência](../../evidence/fila028-preparation-2026-10-10.md). 34 derivadas DRAFT, 33 com métricas aprovadas/revisão visual pendente, AL01 retido por corpo variável. Checkpoint OWNER-PREPARATION-REVIEW. Sem integração, commit ou push.
