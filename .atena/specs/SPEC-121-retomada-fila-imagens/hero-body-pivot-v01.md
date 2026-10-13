# PLAN-053 / DEV-024/v03 — corpo e pivô, preparação v01

Continuação **IN_PLAN** solicitada por “atena, continuar a fila de assets”. Rota anterior explicitamente aprovada: preparar as demais peças, preservar primeiras tiragens, manter ER03/ER06 para decisão antes da integração. Modalidade per-plan vigente; este documento detalha o checkpoint BODY-FEET-LANDMARKS já autorizado. Não reabre a correção de passada cancelada. ART-032 concluída e publicada; retorno PLAN-071 preservado.

Intenção e candidatos **DRAFT**. Referências: [ART-PROMPTS-060](../../generated/ART-PROMPTS-060-erik-e-arlindo-jogaveis.md), [SPEC-160](../SPEC-160-arlindo-orlando-e-erik-blackthorn-jogaveis.md), [PLAN-001 CANON](../../vault/canon/PLAN-001-nottgard-survivors.md), [extração anterior](../../evidence/hero-extraction-review-2026-10-11.md). Identidade aplicável: Erik com cabelo/barba, cicatriz, cachecol, ombreira, espada/tocha/medalhão; Arlindo com chapéu, sobretudo, cachecol vinho, luvas e mãos livres. Fontes efetivas: snapshot local de vinte primeiras tiragens DRAFT e sessenta quadros de onze tiras extraídas. Nottcard/Vault são referências somente leitura; nenhuma nova aparência/lore proposta. Cena: heróis isolados em câmera isométrica, alto esquerdo iluminado, avaliação da silhueta e alinhamento sobre fundo de revisão. Aceite de identidade/material/passada ainda pertence ao dono.

## Contrato da preparação

AO02–AO08 (sete tiras), ER02/ER04/ER05/ER07 (quatro). AO03/AO04/AO07/ER04/ER05 usam extrações históricas preservadas; as outras seis usam os trinta quadros extraídos em 2026-10-11. Sem alterar fontes ou extrações. ER03 (sete poses), ER06 (corte na fonte), AO09/AO10/ER08/ER09/ER10 (separação retangular insegura) ficam retidos; avaliar máscaras/regeração é próximo trabalho, fora deste processamento.

Marcar topo corporal, sola inferior e centro do tronco nas imagens inspecionadas. Em Arlindo o topo do chapéu faz parte da silhueta; em Erik excluir chama/pomo da espada acima do cabelo. Sola usa a extremidade inferior visível do pé, não o centro da caixa global. Centro horizontal estimado na faixa da cintura pelo alfa, conferido na prancha; não usar o brilho/projétil como centro do herói. Registrar método, coordenadas e incerteza, sem tratar máscara de alfa como segmentação anatômica automática.

Derivar no Godot já disponível, em projeto isolado: limpar somente traços alfa <=8/255 no derivado, preservar RGB e todos os pixels significativos da extração, escala proporcional **única por tira** baseada na mediana cabeça–sola. Sem zoom por quadro ou deformação. Células 256×384; sola-alvo y=368, centro x=128; cabeça–pés medianos 290 px Arlindo e 300 px Erik (ART-PROMPTS-060; corrigir o metadado genérico 290 do préflight histórico). Na caminhada, medir variação natural e registrar quando excede o limite de 12 px. A preparação não conserta erros de anatomia/passada.

O cálculo verifica o encaixe de toda a arte/efeitos com dez px de margem. Se altura corporal e encaixe forem incompatíveis, gerar apenas candidato diagnóstico com redução uniforme para caber, marcar **HELD_SIZE_CONFLICT** e não afirmar cumprimento do alvo corporal. Não cortar efeito/arma, não ampliar célula e não integrar para contornar o contrato. Remover apenas alfa residual já declarado, sem refazer/chromakey/repintar fundos. Hash/quantidade/tamanho/margens/ancoragem/escala conferidos; pixels excluídos antes do resize devem ser apenas alfa <=8.

## Sequência operacional

| Ordem | Passo | Saída e checagem |
|---|---|---|
| 1/4 | SOURCES_LANDMARKS | Confirmar vinte fontes/sessenta extrações, coordenadas de corpo/base e prontidão. Preservar runtime/estado de retorno e seleção. |
| 2/4 | PREPARE | Godot gera candidatos separados: sessenta células e onze tiras; conflitos ficam explicitamente retidos. |
| 3/4 | AUDIT | Verificar fontes/hash, alfa, encaixe/base, diferença de escala/altura e links; registrar falhas reais dos critérios sem promover exceção. |
| 4/4 | GALLERY_GATE | Prancha estática e galeria animada, evidência/estado; pedir revisão artística somente após saída concreta. |

BLOCKING para preparação: nenhuma, com fontes locais e referências conhecidas. RESOLVABLE: marcações/encaixe e margem. DEFERRED: sete tiras retidas, aprovação artística e exceções, runtime/CANON/commit/push/export. Não editar assets/, core/, ui/, data/ ou Git. Recuperação: novos candidatos em pacote dedicado; originais, extrações e runtime preservados por hash. Nenhuma dependência ou arquitetura muda; Atena é dona da preparação e eventual integração futura tem gate separado.
