# FILA-028-REMAINING/v01 — produção e auditoria

## Aceite posterior e commit

Dono respondeu “atena, aprovado, commit e continue” após a galeria e as ressalvas. Onze seleções aceitas como fontes visuais CANON, versões anteriores preservadas DRAFT; [registro](../vault/canon/ASSET-APPROVAL-FILA028-REMAINING-2026-10-10.md). Hashes selecionados conferidos antes do commit. Commit local explicitamente autorizado, abrangendo este lote, auditoria, galerias, registros de aceite dos 34 assets e estado. Sem novo push. Abaixo permanece a evidência histórica de produção anterior ao aceite; preparação/runtime dependem do próximo plano.

PLAN-053/SPEC-121. Autorização explícita “Aprovo as 11 peças”, per-plan preservado. Etapas S-001–S-012 executadas (12/12), checkpoint OWNER-VISUAL-REVIEW pendente. Novas fontes DRAFT; nenhuma promoção CANON, recorte, exportação final, integração, commit ou push neste lote.

## Entradas e saídas

[Galeria das onze seleções](../generated/fila028-remaining-2026-10-10/index.html), [auditoria de todas as versões](../generated/fila028-remaining-2026-10-10/audit.json), [prompts e referências](../generated/fila028-remaining-2026-10-10/jobs.json). Recibos individuais contêm prompts exatos efetivamente enviados e origem do built-in imagegen. Fontes nativas em `native-sources/`, cópias byte a byte em `art-candidates/fila028-remaining/`. Nenhum pixel editado por scripts; eles apenas analisam imagens e escrevem JSON/HTML/estado.

Pedidos de ART-PROMPTS-061/059; SE02 v03 aceita no registro CANON é referência de identidade de SE03. Âncoras locais e hashes conferidos. Identidade de personagem N/A para ruínas, câmara e bênçãos, incluindo mão simbólica genérica de I01. Direção e cenas documentadas na spec; nenhum conteúdo de lore novo.

Seleção: SE03–SE11 v02, I01 v03, I02 v02. Vinte e três fontes preservadas. I01 precisou de terceira tentativa para atingir a margem de 18%; demais peças têm duas versões. As versões anteriores ficam no histórico, sem aceite.

## Correções e resultados

- SE03: três selos quebrados no chão e porta entreaberta, luz violeta; enquadramento reduzido em v02. Revisão humana deve confirmar correspondência com SE02, não se afirma invariância exata de câmera/escala. Altura aproximada da composição aberta 53,99%, contra 60,45% da fechada; a base/selos e abertura diferem, bbox não prova escala arquitetônica idêntica.
- SE04: cruz de lápide não solicitada retirada; telhado desabado, vitral quebrado, lápides e névoa preservados.
- SE05–SE10: enquadramento reduzido, preservando materiais e elementos dos biomas; altura aproximada das seleções entre 53% e 66%, em vez de exigir preenchimento máximo. Todas inteiras, sem corte nas bordas. O alvo aproximado inicial de 70% não é declarado exato.
- SE11: mesas antes em pé passaram a tombadas, com pernas expostas; taças quebradas e fitas prateadas preservadas.
- I01: mão de cinco dedos e três fitas; alfa RGBA nativo, margem 24,24%. I02: estrela azul-branca, caminho vermelho e pegada, alfa RGBA nativo, margem 19,06%. Ambos passam 18% sem tolerância adicional.

`audit.py`: 23 fontes/cópias com hashes iguais, referências válidas, onze seleções quadradas, 81 links locais conferidos. Análise de props RGB (bbox por distância >35 do ciano dominante), aproximação explícita, não máscara final. Fundos ciano desviam até 8–10 níveis RGB de #00FFFF; uniformidade exata não atingida, ressalva visível na galeria, tratamento futuro no recorte. Não se afirma alfa pronto nos props com fundo de recorte. Inspeção visual feita nas saídas nativas; avaliação artística e leitura a 80/48px continuam com o dono.

Corrigido em progress.py o regex de checkpoint para ancorar início da linha: uma versão inicial também alcançava return_checkpoint. Retorno dos heróis restaurado e conferido em NORMALIZATION-EXTRACTION-11; PLAN-071 preservado. `git diff --check` válido. Backlog: P0=0, quatro P1 abertos (BUG-025/027/028/029), 14 implementados aguardando playtest, zero alertas. Nenhum código do jogo mudou.

## Próximo checkpoint

Dono revisar versões identificadas da galeria, comparar as câmaras e verificar ruínas por bioma e bênçãos a 48px. Saída: aceite visual ou correções específicas. Todas as 34 peças da FILA-028 agora têm fontes geradas; 23 anteriores têm aceite visual, estas onze permanecem DRAFT. Recorte, normalização, montagem do altar e admissão runtime ainda requerem planos próprios; heróis continuam no checkpoint de retorno separado.
