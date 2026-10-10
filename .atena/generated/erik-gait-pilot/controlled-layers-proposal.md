# Proposta concreta: poses por camadas

Estado PROPOSED, aguardando pedido explícito de edição raster por código. Não implementado. O uso padrão de imagegen para editar imagens só pode ser substituído por outro método quando o dono pedir explicitamente essa alternativa.

Escopo inicial: um piloto move_e de Erik. Fonte: cópia da primeira figura de guided-final-contacts-v01.png, mantendo os originais intocados. Separar torso/equipamento, coxas, panturrilhas e botas em camadas com máscaras registradas. Definir quadril, joelhos e tornozelos e usar a geometria cycle-guide-v01.json para seis fases; ordem de profundidade constante da perna próxima, troca real dos ângulos e contatos.

Gerar derivados DRAFT e uma prévia. Conferir recortes, costuras, partes ocultas e ausência de deformação antes de aceitar o piloto. Pintura/inpainting de partes faltantes continua possível pelo imagegen; o controle da pose e montagem usa código local. Só após inspeção normalizar as células256x384 e baseline/pivô. Nenhuma dependência nova, nenhum código de gameplay, admissão, commit ou push.

Aceitação: contatos1/4 com perna próxima em lados opostos; passagens2/5 opostas; ciclo sem duplicação, emendas ou deslizamento evidente; identidade/câmera/equipamento constantes; alfa real, margens e grade final verificadas. Recuperação: remover apenas derivados, preservar todas as fontes e máscaras.
