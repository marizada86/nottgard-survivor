# FILA029-PRODUCTION/v01

Estado DRAFT. Origin: planned; implementation_preceded_spec: false.
Pedido: "atena, aprovado, continue a produção de assets, o claude irá implementar" (2026-10-15). Modo per-plan mantido para esta frente; escopo B01 aprovado pelo dono com "prossiga atena" em 2026-10-15.
Classificação: PLAN_CHANGE_REQUEST para a próxima peça; nenhum plano ativo substituído. PLAN-103 e retorno da produção de névoa preservados enquanto o dono decide este lote.

## Próxima peça proposta e entradas

B01 `botao_acao_moldura`, FILA-029/ART-047. Uma imagem, prompt existente, nenhuma geração encontrada no caminho esperado ou nos registros consultados. Selecionada por substituir um elemento muito visível do Quartel e ter escopo pequeno independente da implementação da névoa. Não representa redefinição das prioridades gerais de M5.
Autoridade: [ART-PROMPTS-062 r1](../../generated/ART-PROMPTS-062-botao-de-acao-jogar.md), [FILA-029](../../generated/CHATGPT-FILA-029-botao-de-acao-jogar.md). Contrato técnico e composição permanecem como escritos.

Mini bíblia DRAFT r1: interface gótica sombria em pixel art; moldura baixa e larga 5:1 em aço claro dessaturado, cantos chanfrados, ornamento apenas nas pontas; centro uniforme esticável e pedra quase preta no interior. Sem rótulo ou ícone, pois o jogo os desenha. Fundo magenta #FF00FF para a fonte, sem halo. Identidade de entidade N/A: moldura de interface, sem personagem. Cena textual: ação principal JOGAR no Quartel e reutilização via nove fatias. Referências locais existentes, a serem inspecionadas antes da geração: `assets/ui/ficha/ficha_aba_moldura.png` (família), `assets/ui/ficha/ficha_moldura_detalhe.png` (ornamento), `assets/ui/evolucao_painel_moldura.png` (material). Autoridade específica do prompt limita o ouro da terceira referência: saída deve ser neutra para tingimento. Nenhuma referência externa ou lore nova.

## Etapas propostas

1. S-001: contrato e inventário textual; concluído. Conferir hashes e inspecionar as três referências antes da chamada de geração.
2. S-002: gerar B01 v01 com imagegen, uma peça por chamada, prompt existente e três referências com papéis declarados. Salvar PNG original versionado em `.atena/generated/art-candidates/botao-acao/`; até três tentativas com defeito objetivo por tentativa, sem sobrescrever fontes.
3. S-003: inspecionar proporção, materiais, bordas, ornamento e área central; criar galeria e manifesto da fonte, registrar dimensões reais e pendências. Candidatas e previews apenas em generated; não tratar imagem nativa como asset final de 320×64 se não o for.
4. S-004: apresentar candidata DRAFT para avaliação da direção visual e entregar referências/contrato ao implementador Claude. Aceite em escala real no jogo (Quartel desktop e mobile) permanece gate posterior à implementação; avaliação do PNG não o substitui.

Saídas: fonte B01 versionada, manifesto, galeria, evidência e instruções locais de entrega. Nada em assets/, ui/, core/ ou data/. Sem novas dependências, geração de rótulo, promoção canônica, commit/push ou exportação. Nenhum envio automático a outro chat/agente.

Destino final de referência, a cargo da implementação após autorização: `assets/ui/ficha/botao_acao_moldura.png`, 320×64 RGBA, fatias E/D/T/B 28/28/20/20. Gerar fonte com cerca de 1536 px de largura, proporção 5:1. Validação futura: esticar 280..420×56..72, rótulo JOGAR 28 px e glifo 32 px, tintas normal/foco/desabilitado, sem halo magenta. Estes checks de integração não serão declarados feitos nesta produção.

BLOCKING: nenhuma lacuna de entrada ou aprovação. Três referências inspecionadas antes de produzir; referências secundárias têm dourado/âmbar, excluído expressamente pelo contrato neutro de B01. A primeira fornece a família de aço. Nenhuma alteração de direção exigida. Hashes e papéis em generated/fila029-production-2026-10-15/references.json.
DEFERRED: normalização final/admissão e aceite in-game pelo responsável da implementação. Recuperação: novas versões nas candidatas, sem substituir assets ou referências. Conteúdo DRAFT até promoção explícita.
