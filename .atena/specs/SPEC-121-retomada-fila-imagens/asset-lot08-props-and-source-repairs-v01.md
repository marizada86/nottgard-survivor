# ASSET-LOT08/v01 — três props e dois ciclos em quadros individuais

DRAFT, origin planned, implementation_preceded_spec false. Pedido2026-10-16: "aprovado, commite e continue". LOT05–07 commitados em22c1049b; aceite visual LOT07 não dispensou NE06_SWORD_CROSSING_COLUMNS, nem aceite LOT06 dispensou FC02_ORIGIN. PLAN_CHANGE_REQUEST para novo escopo, modo per-plan preservado; escopo aprovado explicitamente em 2026-10-16: “aprovo por plano”, antes da produção. Sem implementar/admitir, Claude continua responsável. PLAN-103 e outros checkpoints preservados.

## Escopo:11PNGs, cinco entradas de revisão

| Entrada | Arquivos-fonte | Saída |
|---|---:|---|
| PR01 templo-alvo |1|Prop estático experimental para destino da escolta em Feng-tu|
| PR02 jaula |1|Jaula vazia de Vhaerith, Durao|
| PR03 canoa |1|Canoa vazia do Estige, Shedaklah|
| GR01..GR04 |4|Quatro poses individuais de idle de Graz’zt, substituição candidata da folha retida NE06|
| FJ01..FJ04 |4|Quatro fases individuais de jato, substituição candidata da folha retida FC02|

Onze fontes/desenhos, uma galeria com três props e dois reprodutores. Sem variantes extras. Autoridades: [ART-032/pendências](../../backlog/ARTE.md), [SPEC-118](../SPEC-118-acontecimentos-exclusivos-por-fase.md), [implementação estática ART032](../../vault/drafts/PLAN-ART032-IMPLEMENT-v01.md), que deixa templo/jaula/canoa DEFERRED; [LOT06](asset-lot06-expanded-v02.md) e [LOT07](asset-lot07-npc-idles-v01.md) para ciclos. `data/stage_events.json` confirma destino templo de Tou Um, Vhaerith na jaula e Reaper que conjura canoa por ouro; sem alterar evento/recompensa/quest. Busca nominal em assets/generated não encontrou fontes com nomes templo_alvo/jaula_vhaerith/canoa_estige; reconfirmar antes de produzir, sem alegar inexistência absoluta de nomes alternativos.

As referências locais foram inspecionadas: torii_01 para materiais/arquitetura Feng-tu, corrente_01 para ferro Durao, doca_01 para madeira/corda; não copiar esses objetos como se fossem identidade dos props novos. Graz’zt usa estático atual como identidade; ícone FC01 e jato FC02v03 são referências de paleta/direção, não de geometria aprovada para runtime. Hashes em [references.json](../../generated/asset-lot08-2026-10-16/references.json). Aparência/arquitetura dos três props não está descrita por completo: propostas abaixo são hipóteses DRAFT, nunca canon de Tou Um ou do vault.

## Bíblia e contextos — DRAFT v01

Fantasia sombria isométrica, pixel art densa, luz superior esquerda, materiais gastos e silhueta legível. Personagem N/A nos três props vazios; identidade de objeto/contexto definida abaixo. Sem cenário/chão/sombra adicionados, NPCs incorporados, texto, símbolos religiosos/rúnicos novos ou lore inventada. Transparência nativa; sólidos opacos, falloff legítimo somente na chama. Nenhum exterior narrativo novo.

- PR01: pequeno pavilhão/entrada de templo como marcador compacto de destino, pedra escura e madeira vermelha envelhecida compatíveis com torii local, poucos degraus e cobertura simples escura. Vazio, entrada legível/inativa, sem figura divina, altar novo, brasão ou símbolo exclusivo de Tou Um. A geometria é hipótese artística, não representação canônica da arquitetura. Contexto: ponto de chegada da escolta, sem definir colisão/tamanho de edifício em jogo.
- PR02: jaula alta vazia de ferro escuro envelhecido sobre base curta de pedra, barras verticais e porta fechada claramente legíveis. Centro entre barras transparente, sem prisioneiro, sangue, runas ou efeito de portal. Hipótese DRAFT de jaula, sem decidir escala literal gigantesca no runtime. Vhaerith permanece sprite separado; oclusão/frente/fundo/layers serão decididos na integração, não recortados/admitidos neste lote.
- PR03: canoa estreita vazia de madeira escura gasta, borda inteira, pequenos bancos internos e amarração simples, vista três-quartos coerente com o mapa. Sem água, rio, Reaper, passageiro, movimento ou efeito de conjuração. Não transformar em navio, carroça ou dracar decorado. Contexto existente de travessia, sem viagem implementada.
- GR01..04: identidade existente de Graz’zt (pele cinza, cabelo negro, armadura escura/prata, manto violeta, espada baixa). Quatro poses quase idênticas de respiração/cabelo/tecido, pés/espada estáveis e retorno4→1; arma inteira e proporcional em TODAS. Sem chifres/dedos adicionais, ataque, aura ou anatomia externa. Uma figura completa por PNG, sem grade, para remover a causa de corte entre colunas.
- FJ01..04: identidade pessoal N/A, VFX isolado para direita, amarelo claro/laranja/âmbar/vermelho escuro. Fases fina→língua→larga/redemoinho→brasas, comprimento máximo e emissão consistentes, sem equipamento/ator/fundo. Uma fase por PNG, sem grade. **Mudança contratual explícita proposta:** emissão em ponto INTERNO fixo (alvo x128,y512 num canvas1024), ponta atéx850 e margens livres; entregar coordenada de referência por quadro para preparação. Não exigir raiz cortada na borda esquerda como U06 antigo, pois foi a retenção anterior. Aprovação do LOT08 autoriza essa revisão DRAFT de produção, sem mudar mecânica/alcance/dano; Claude confirma registro/consumer em outro escopo.

BLOCKING de entrada: aprovação do novo escopo, incluindo hipóteses de props e revisão de ancoragem do jato. Nenhuma lacuna textual restante após esse aceite. RESOLVABLE: margens, origem/continuidade, arma completa, alfa, identidade e legibilidade. DEFERRED: aparência CANON, preparação/registro/normalização, layers/oclusão, destinos/consumers, MEC-004, admissão/implementação/playtest.

## Etapas, tentativas e recuperação

1. S-001 inventário/prontidão/proposta: concluído. Fontes antigas e retidas preservadas; nenhum PNG novo gerado. Próximo passo depende de aprovação deste plano.
2. S-002 produzir11PNGs individuais via imagegen. Props e figuras alvo quadrado1024, margens≥12%; VFX quadrado1024 com origem interna, medir nativo real sem prometer dimensões exatas. Cada arquivo é uma chamada. No máximo três tentativas por arquivo por defeito objetivo, escopo total máximo33chamadas. Esse novo orçamento/método precisa de aprovação: não prolonga silenciosamente o limite esgotado dos lotes anteriores. Começar GR01/FJ01, usá-los como referências de consistência dos demais dentro do mesmo plano; sem gate visual intermediário, todos DRAFT para revisão conjunta.
3. S-003 QA: corpo/props/arma inteiros, alfa/margens, poses reais e consistência dos ciclos/ancoragem. Para VFX alfa variável é esperado. Previews80/128px para props/figura e loop comparativo; nenhum recorte/normalização oculta de fonte. Coordenada de emissão é anotação proposta, não prova semântica automática por bbox. Se limite de tentativas persistir, reter arquivo/ciclo explicitamente; não liberar a retenção antiga sem demonstrar nova fonte completa e decisão humana.
4. S-004 galeria conjunta cinco entradas, dois players, manifestos/prompts/hashes/evidência/entrega local para Claude. Conferir caminhos/controles; distinguir DOM offline de render de navegador. Aceite parcial por entrada/revisão permitido. Parar no gate visual conjunto; não presumir aceite por aprovação de fontes antigas.

Fontes versionadas em .atena/generated/art-candidates/asset-lot08/, entrega em .atena/generated/asset-lot08-2026-10-16/. Recuperação por revisões, referências readonly e retenção seletiva. Conteúdo DRAFT; sem assets oficiais/código/dados/cânone/dependências/commit/push/merge/exportação/publicação ou envio a Claude. Nenhum playtest ou alegação de diversão. Implementação permanece com Claude; produção/reparo visual desta proposta não é integração.

## Resultado da execução v01 — 2026-10-16

Quatro etapas concluídas: 11 fontes selecionadas, 12 tentativas preservadas, cinco entradas na galeria. GR02/v02 substitui v01 por deriva de escala. Todas as fontes têm1254×1254, não1024. Sem contato alfa≥16 nas bandas externas4px; margens dos props62/45/99px abaixo do alvo12%, alfa residual e registro requerem preparação. Graz’zt com arma completa e dispersão de base1px; jato com origem interna proposta próxima de169,652, ainda não pivô semântico certificado. Retenções antigas permanecem. [Entrega](../../generated/asset-lot08-2026-10-16/ENTREGA-PARA-IMPLEMENTACAO.md) e [evidência](../../evidence/asset-lot08-props-and-source-repairs-2026-10-16.md). Aceite visual conjunto PENDING, DRAFT, sem admissão ou implementação.
