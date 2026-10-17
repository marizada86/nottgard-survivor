# ASSET-LOT11/v01 — oito ruínas, 32 poses

DRAFT, origin planned, implementation_preceded_spec false. PLAN_CHANGE_REQUEST após “atena aprovado, continue”, aceite do LOT10. Inventário e proposta preparados; novo escopo aprovado explicitamente em2026-10-16 (“aprovado, continue”), antes da geração. Modalidade per-plan preservada. Implementação e preparação com Claude. PLAN-103 e outras frentes preservados; aprovação visual LOT10 não autoriza esta extensão automaticamente.

## Autoridade e referências

[FILA-028 SE04–SE11](../../generated/CHATGPT-FILA-028-eventos-arcanista-icones-segredos-e-altar.md), [ART-PROMPTS-061](../../generated/ART-PROMPTS-061-eventos-arcanista-icones-segredos-e-altar.md), [produção estática](generation-fila028-remaining-v01.md), [preparação](preparation-fila028-v01.md), [SPEC-152](../SPEC-152-fatia-piloto-de-segredos-ecos-e-reliquias.md), `data/secrets.json` para contexto dos pontos de interesse. Oito normalizados SE04..SE11/v02 inspecionados, [snapshot/hash](../../generated/asset-lot11-2026-10-16/references.json). Registro de preparação identifica referências CANON_PREPARATION_VISUAL_ONLY; novas animações permanecem DRAFT. Aparência das fontes prevalece sobre descrições genéricas antigas. Não consultar/inventar lore externa nova; vault e Nottcard somente leitura.

Busca nominal em assets/animations e animation-candidates não encontrou ciclos desses oito IDs antes da proposta; reconfirmar antes da produção, sem alegar inexistência absoluta de fontes renomeadas. Estáticos já produzidos e aceitos não serão refeitos/substituídos. Não criar nova fase, ruína, personagem ou regra para preencher lote.

## Bíblia, identidade e cena — DRAFT v01

Fantasia sombria isométrica, câmera/silhueta/paleta da referência individual, luz superior esquerda, clusters de pixel e materiais gastos. Ruínas isoladas como pontos de interesse já existentes no mapa. Identidade pessoal/figurino N/A: construções e ambientes compactos sem personagem; identidade arquitetônica/material e contexto por bioma aplicáveis. Cena textual basta, posição no mapa não é pré-requisito. Preservar solo/escombros incorporados ao sprite, sem acrescentar cenário externo, sombra de chão ou fundo. Transparência nativa substitui fundo histórico da referência, estruturas sólidas opacas, falloff legítimo somente em emissão/névoa existentes.

Quatro poses de repouso, estrutura/base/câmera/escala imóveis. Só variar luz, névoa/esporos e tecidos que já existam na referência. Ciclo discreto repouso→pequeno pico→relaxamento→próximo do início. Não ativar/interagir/destruir, revelar tesouro, abrir porta, reacender fogueira ou inventar símbolos/efeitos para criar movimento.

| Código | Referência normalizada v02 | Identidade e variação restrita |
|---|---|---|
| RU01 Dagruve | SE04 | Capela escura gótica em ruínas, vitral/luz quente e névoa baixa existentes; luz/névoa discretas, lápides/pedra/telhado fixos, sem culto ou figura nova. |
| RU02 Docas | SE05 | Galpão gasto de madeira/ferro, toldo vermelho rasgado, caixas/corda/lanterna existentes; pequeno movimento do toldo e luz da lanterna, sem porta abrindo, carga mudando ou mar/água novos. |
| RU03 Shedaklah | SE06 | Arco/muro fúngico com cogumelos e limo existentes; esporos discretos e brilho orgânico mínimo, pedra/cogumelos principais fixos, sem crescimento/novas espécies. |
| RU04 Molor | SE07 | Estrutura de pedra com estalactites, altar partido e gel verde existentes; reflexos do gel mínimos, pilares/altar/teto fixos, sem goteira destacada, desabamento ou nova magia. |
| RU05 Durao | SE08 | Acampamento rasgado com tendas, bandeira caída, armas e fogueira apagada existentes; bordas de tecido mexem minimamente, fogueira permanece apagada, sem soldado/sangue/arma nova. |
| RU06 Feng-tu | SE09 | Colunas/arco claro quebrados, estrela de pedra caída e tecido vermelho existentes; somente tecido discreto, estrela/escombros/pedra fixos, sem novo emblema ou representação canônica adicional de Tou Um. |
| RU07 Shendilavri | SE10 | Arcos rosados e escadaria com cortinas vermelhas rasgadas/pétalas existentes; cortinas mínimas, pilares/escada/pétalas fixos, sem figura/sedução narrativa ou novo ornamento. |
| RU08 Goranthis | SE11 | Salão aberto arruinado com mesas, taças, fitas prateadas e iluminação existente; fitas/luz mínimas, mesas/pedra/objetos fixos, sem festa ativa/personagens ou texto. |

## Etapas e aceitação

Oito folhas, quatro poses por fonte,32desenhos. Uma galeria conjunta com oito players. Cada chamada built-in imagegen gera uma folha; até três tentativas por fonte por defeito objetivo, máximo24chamadas. Sem variantes extras, poses fabricadas ou gate intermediário por imagem.

1. S-001 prontidão/proposta: concluída, referências/identidades/contextos inspecionados e hashes persistidos. Aprovação específica recebida; nenhuma lacuna BLOCKING textual restante na entrada.
2. S-002 produção: uma linha4×1, alvo2048×768, células512×768, motivo≤300px de largura e base localy600; solicitar margens≥64px, medir real sem prometer dimensões. Mesmos base/escala/câmera/posição por quadro, detalhes incorporados completamente contidos em cada célula. Fontes em `.atena/generated/animation-candidates/asset-lot11/`, prompts e origem/hash/versionamento preservados. Corrigir cortes/deriva relevantes dentro do orçamento, reter seletivamente se persistirem no limite.
3. S-003 QA: contar quatro poses efetivas, transparência/solidez, grade real, zero contato alfa≥16 na banda4px, margens/base/escala e deriva horizontal; conferir rigidez arquitetônica, ausência de novos objetos e retorno4→1. Contatos/prancha e leituras48/80/128 preservando proporção. Hash diferente não comprova animação/fluidez. Registrar folga abaixo do alvo, alfa/registro e outras limitações sem ocultar cortes ou dar PASS de admissão.
4. S-004 galeria em `.atena/generated/asset-lot11-2026-10-16/`, oito players pausa/replay/FPS/repetição/scrub; manifesto/hash/referências/prompts/medidas/evidência e handoff local para Claude. Conferir arquivos/links/controles, distinguir simulação DOM offline de render real. Parar no aceite visual conjunto; aceite parcial por código/revisão permitido.

RESOLVABLE: leitura da arquitetura em tamanho pequeno, sutileza do movimento, alfa/margens/registro. DEFERRED: admissão/consumer, normalização/pivô/escala/temporização, implementação, contraste runtime, CANON das novas poses, playtest e diversão. Recuperação por arquivos versionados, referências readonly e retenção seletiva. Escopo não altera ativos oficiais/código/dados, mecânica, arquitetura material, dependências ou permissões. Não fecha bugs, retenções anteriores ou planos de outras frentes. Sem commit/push/merge/exportação/publicação ou mensagem a Claude. Aprovação per-plan permitirá somente S-001..S-004; aceite visual é checkpoint posterior independente.

Resultado2026-10-16:4/4 etapas entregues com retenções, oito fontes/32poses de QA em15tentativas; RU01..04v01,RU05v03,RU06v02,RU07v03,RU08v01. RU05/RU07 retidos por deriva e RU08 por contato/deriva após três tentativas; nenhum novo ensaio autorizado. [Evidência](../../evidence/asset-lot11-ruins-2026-10-16.md). Aceite visual PENDING, sem admissão/CANON/implementação.

Aceite posterior2026-10-16: 'aprovado, commit e continue'. Direção visual das oito revisões selecionadas/32poses de QA aceita DRAFT; recibo visual-acceptance.json no pacote. Supera PENDING visual anterior, preservando as três retenções técnicas RU05/RU07/RU08 e demais notas de preparação. Sem admissão/CANON. Commit local das entregas pendentes LOT10/LOT11 autorizado; sem push/exportação.
