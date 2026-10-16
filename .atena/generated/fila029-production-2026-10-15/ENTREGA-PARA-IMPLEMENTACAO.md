# B01 — entrega de produção para implementação

Conteúdo DRAFT. Fonte selecionada: [B01 v03](../art-candidates/botao-acao/B01_v03.png), direção visual aceita pelo dono em 2026-10-15 ("aprovado, faça lotes maiores para aprovação"). [Recibo](visual-acceptance.json). Implementação atribuída a Claude pelo dono; este é um arquivo local, sem envio automático a outro agente e sem integração realizada.

Autoridade: [ART-PROMPTS-062 r1](../ART-PROMPTS-062-botao-de-acao-jogar.md); [galeria](index.html), [manifesto](manifest.json), [inspeção](inspection.json). Fonte 2172×724; contorno aproximado x=62..2107, y=163..508, 2046×346 (5,91:1). Preservar o original e criar derivadas versionadas. A caixa foi detectada por magenta R>180/B>180/G<100; não é máscara final de alfa.

Destino futuro proposto: `assets/ui/ficha/botao_acao_moldura.png`, 320×64 RGBA; nove fatias E/D/T/B 28/28/20/20. A proporção da fonte não coincide com 5:1, portanto decidir recorte/ajuste ao normalizar e comparar forma. A prévia 320×64 da galeria é simulação de escala, não asset final.

Remover magenta com tolerância e erosão de 1 px conforme o contrato; auditar halo e contorno antes de admitir. Manter o preenchimento quase preto opaco. Metal neutro para tintas de estado; rótulo JOGAR/Bloqueado e glifo são desenhados pelo jogo. Não adicionar palavras à textura.

Integração de referência: `PlayBtn` e `HqPlayBtn`, `SheetArt.frame(...)`, possível auxiliar `UiKit.action_button`. Confirmar especificação/autorizações no contexto de implementação antes de modificar consumers, assets ou dados. Nenhuma modificação desses arquivos foi feita nesta produção.

Validação futura prevista no ART-PROMPTS: nove fatias entre 280..420 px de largura e 56..72 px de altura; JOGAR a 28 px, glifo 32 px e folga; tintas normal/foco/desabilitado; comparação com abas do Quartel; desktop 1280×720 e mobile. Verificações de foco, controle e toque pertinentes à versão integrada. Aceite visual em jogo é obrigatório e não foi realizado. Gate da direção visual da fonte v03 concluído; admissão e integração continuam pendentes.

v01/v02 retidas como histórico, não recomendadas: v01 toca bordas; v02 tem grão interior acima do limite medido. v03 melhorou ambos; não possui PASS completo de admissão. Sem promoção canônica, commit, push ou exportação desta frente autorizados.
