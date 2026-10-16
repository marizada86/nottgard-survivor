# ASSET-LOT04/v01 — seis quebráveis, 30 poses

Estado DRAFT. Origin planned; implementation_preceded_spec false. Pedido do dono: "aprovado, deixe a implementação para o claude, continue a produção" (2026-10-16). Aceite do LOT03 registrado separadamente. Escopo aprovado per-plan pelo dono com "aprovo" em 2026-10-16, antes da produção. Classificação PLAN_CHANGE_REQUEST da frente de produção, sem substituir PLAN-103. Não pedir novamente a escolha do nível de aprovação.

## Escopo proposto

Seis folhas-fonte, cinco poses por sequência, 30 quadros totais, uma galeria conjunta com reprodução e aceite por código/revisão:

| Código | Identidade/arquivo estático | Bioma/contexto |
|---|---|---|
| QB01 | `assets/enemies/candelabro_quebravel.png` | Dagruve/Docas, suporte de velas |
| QB02 | `assets/enemies/caixote_quebravel.png` | Dagruve/Docas, caixote alto |
| QB03 | `assets/enemies/arbusto_quebravel.png` | Quebrável genérico, identidade fúngica da arte existente |
| QB04 | `assets/enemies/saco_de_esporos_quebravel.png` | Shedaklah, saco orgânico rosa/violeta |
| QB05 | `assets/enemies/casulo_viscoso_quebravel.png` | Molor, casulo viscoso verde |
| QB06 | `assets/enemies/urna_funeraria_quebravel.png` | Durao, urna de pedra com fratura azul |

Inventário: seis estáticos inspecionados; `data/enemies.json` registra flags inerte/quebravel e biomas; não existem death.png nos seis caminhos esperados `assets/animations/enemies/<id>/death.png`, nem candidatas death encontradas pelos nomes consultados. A busca não prova inexistência absoluta de cópias com outros nomes, confirmar antes de produzir. `ui/enemy_view.gd` resolve textura pelo id e tiras por fonte/estado; este lote não modifica o consumer.

Autoridade: [PLAN-041 de animação](../../vault/drafts/PLAN-041-animacao-padrao-zumbi-para-inimigos-e-interacoes-2026-09-29.md), perfil D (estático + death de cinco quadros); ART-022; [SPEC-063](../SPEC-063-objetos-quebraveis-e-rebalanceamento-de-pocao.md) e [ART-PROMPTS-024](../../generated/ART-PROMPTS-024-cenario-e-quebraveis-por-bioma.md) para contexto. Barril do LOT03 fora deste lote, já aceito. Carroça, carga, lanterna, espelho, estátua e relicário ficam para lote posterior; não entram automaticamente.

## Bíblia e identidades — DRAFT v01

Entidades relevantes são os próprios objetos; identidade estruturada abaixo, sem N/A genérico. Preservar câmera/material/paleta das referências, luz superior esquerda, composição isométrica fixa e pixel art densa. Nenhuma nova criatura, lore, símbolo ou equipamento. Fonte transparente, sem cenário/sombra de chão; materiais sólidos opacos, exterior vazio. Identidade do primeiro quadro deve coincidir com o estático; última pose é destroço assentado. Nada some magicamente no meio da sequência.

- QB01: a arte é um conjunto de três velas de cera em suporte circular e bandeja quadrada de madeira/ferragens, não uma coluna metálica. Preservar quantidades e cores; suporte cede, velas tombam/apagam e bandeja quebra, terminando em cera/madeira/ferragem. Sem explosão de fogo, sem novo dano ou fumaça que esconda o corpo.
- QB02: caixote vertical de tábuas escuras, reforços de ferro e corda em um lado. Racha, tábuas se abrem e caem, ferragens/corda assentam. Não trocar por caixa baixa ou adicionar loot.
- QB03: apesar do nome arbusto, o PNG é um organismo fúngico de tronco/raízes e copa em forma de cogumelo castanho-rosado com bolsas pendentes. Preservar essa identidade: fratura física do tronco/copa e queda de fragmentos, sem trocar por arbusto verde comum nem criar criatura ou membros móveis.
- QB04: saco orgânico arredondado rosa/violeta com fibras e veios luminosos existentes. Fissura/rompimento e colapso de membrana, conteúdo visível apenas se derivado dos materiais já presentes; sem revelar monstro ou criar nuvem que sugira nova área de dano. Efeito de esporos discreto e puramente visual, se necessário, dentro da célula; avaliar transparência separada do corpo.
- QB05: casulo oval verde viscoso preso por fibras sobre base pedregosa. Fibras cedem, membrana abre, casulo colapsa no mesmo ponto. Não revelar personagem/ovo novo, sem ataque/poça de gameplay; manter pedras/base identificáveis e corpo sólido até romper.
- QB06: urna escura de pedra cinza com duas alças, motivos de crânio e fratura azul já presente. A fratura aumenta e a urna se parte em cacos pesados; luz existente enfraquece ao assentar. Sem fantasma, ossos novos, selo ou explosão adicionados.

Contexto textual: objetos isolados no mapa, imóvel até a destruição por golpe. Produzir apenas desenhos da ruptura, não colisão, loot, duração ou dano. Arte de baixa opacidade pode ser sutil no vapor/partículas; não aceitar corpo fantasmagórico como opaco. Referências locais a anexar por peça com papel de identidade, hashes antes/depois.

BLOCKING de entrada: nenhuma lacuna textual para ensaio DRAFT; aprovação do escopo recebida. Checkpoint visual concluído: dono aprovou as seis revisões selecionadas com "aprovado, commite" em 2026-10-16. Conteúdo permanece DRAFT; preparação técnica pendente. RESOLVABLE na preparação: material, alfa e pivô. DEFERRED: admissão, alinhamento final, redução, temporização runtime e teste em jogo.

## Produção, validação e saída

1. S-001: inventário, referência visual e proposta — concluído; seis identidades específicas prontas. Aprovação per-plan recebida.
2. S-002: seis chamadas imagegen, uma folha por objeto, cinco poses em grade 3×2 (sexta célula vazia), células-alvo 512×512 e corredores generosos, mesma câmera/base/escala. Poses: intacto → impacto/fissura → ruptura → queda → escombros assentados. Até três tentativas por fonte, uma correção objetiva por tentativa, sem interromper a cada imagem. PNGs originais versionados em `.atena/generated/animation-candidates/asset-lot04/`. Pedir alfa nativo; não prometer dimensões nativas exatas.
3. S-003: conferir número real de poses, sexta célula, transparência/corpo sólido, continuidade física/identidade, margens e pivô. Extrair células de QA pela grade nativa, não inventar quadros. Reprodutor em velocidade de inspeção e contatos; hashes/medidas, defeitos e retenções explícitos. Checagem de lógica do player é distinta de inspeção visual e de playtest.
4. S-004: galeria conjunta em generated/asset-lot04-2026-10-16, manifesto, prompts, evidência e entrega local para Claude. Parar no gate de direção visual das seis sequências/poses, permitindo aceite parcial. Aparência/fluidez/legibilidade em jogo dependem da implementação e do dono.

Reusar ferramentas de QA do LOT03 adaptadas ao novo conjunto, sem modificar sua entrega aceita nem aplicar correção silenciosa às fontes. Se a base/grade/alfa não cumprir o alvo, registrar como candidata para preparação ou reter, sem PASS falso de admissão. Preservar originais e refs; recuperação por revisões e retenção seletiva. Conteúdo DRAFT, sem promoção canônica. Sem assets oficiais/código/dados/novas dependências, commit/push/exportação ou envio a outro chat. Implementação fica com Claude, conforme instrução reiterada do dono; escopo de admissão deve ser confirmado nessa frente. Retorno/checkpoints PLAN-103 preservados.

Atualização autorizada 2026-10-16: aceite visual por revisão/hash registrado em generated/asset-lot04-2026-10-16/visual-acceptance.json. Commit local das entregas pendentes LOT03/LOT04 explicitamente autorizado com 'aprovado, commite'; push/exportação continuam fora do escopo.
