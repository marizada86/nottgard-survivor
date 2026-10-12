# ART-032 — préflight de implementação DRAFT v01

Pedido: **“atena, proxima imagem, depois iplemente”**. As fontes previstas de ART-032 estão completas: dezessete revisões DRAFT visualmente aceitas em vinte e sete originais, quatro recibos. Nenhuma próxima imagem desta frente está definida no plano fechado. Pergunta de escopo enviada: implementar as dezessete agora ou qual outra imagem antes, confirmando se a implementação posterior é ART-032. Classificação PLAN_CHANGE_REQUEST; modalidade per-plan preservada. Este documento é preparação independente, não autorização de geração, transformação ou runtime.

## Inventário e consumo propostos

| Revisão | Uso | Evento | Destino proposto |
|---|---|---|---|
| NP01 v02 | escort ally | `feng_tu/escolta_do_peregrino` | `assets/interactions/npc_joao_barbosa.png` |
| NP02 v01 | rescue point | `durao/desertores` | `assets/interactions/npc_desertor_durao.png` |
| NP03 v01 | rescue point | `shendilavri/vitimas_drenadas` | `assets/interactions/npc_vitima_enfeiticada.png` |
| PT01 v01 | pilgrimage point | `feng_tu/peregrinacao_da_estrela` | `assets/interactions/estrela_do_norte.png` |
| NP04 v02 | first reward ally | `shendilavri/vitimas_drenadas` | `assets/interactions/npc_nyxara.png` |
| NP05 v01 | second reward ally | `shendilavri/vitimas_drenadas` | `assets/interactions/npc_vaelis.png` |
| NP06 v02 | pact point and reward ally | `goranthis/o_nome_tres_vezes` | `assets/interactions/npc_grazzt_aliado.png` |
| NP07 v01 | pact point | `shedaklah/barqueiro_do_estige` | `assets/interactions/npc_reaper_barqueiro.png` |
| NP08 v01 | pact point | `durao/vhaerith_na_jaula` | `assets/interactions/npc_vhaerith_aetherion.png` |
| NP09 v01 | pact point | `shendilavri/mercador_de_rivenheart` | `assets/interactions/npc_mercador_rivenheart.png` |
| PT02 v02 | collect target | `shedaklah/pedido_de_zuggtmoy` | `assets/interactions/trono_zuggtmoy.png` |
| PT03 v02 | collect target | `shedaklah/portal_sem_vao` | `assets/interactions/arco_pedra.png` |
| PT04 v02 | intercept target | `molor/ritual_de_estagnacao` | `assets/interactions/massa_thullgrime.png` |
| PT05 v01 | drop from elite | `shedaklah/pedido_de_zuggtmoy` | `assets/interactions/coracao_limo.png` |
| PT06 v02 | collect item | `shedaklah/portal_sem_vao` | `assets/interactions/esporo_zuggtmoy.png` |
| PT07 v02 | collect item | `shedaklah/portal_sem_vao` | `assets/interactions/limo_juiblex.png` |
| MJ01 v03 | static boss sprite | `shedaklah/pedido_de_zuggtmoy` | `assets/enemies/manifestacao_de_juiblex.png` |

[Manifesto/revisões/hashes](manifest.json). Todos os dezessete hashes de fontes e quatro recibos conferidos; IDs de eventos existem. Snapshot dos ativos/runtime e cadeia PLAN-071 permanece igual. A imagem atual de Juiblex continua o provisório; este préflight não modifica nenhum PNG ou código do jogo.

## Impacto delimitado para futuro plano ART-032

1. Preparar derivados no Godot com alfa/caixa/padding/proporção e âncora de base, preservando bytes dos originais. Definir dimensões finais no plano aprovado, com prévias 48/80/128px e contraste em cenas reais. Resíduos nativos de alfa 1/255 devem ser tratados no contrato dos derivados, sem retocar originais.
2. Conectar arte por metadata de eventos, mantendo regras, horários, custos e recompensas. Interações já têm campo `asset` em `_add_point`; collect items/rescue/star e drops de elite precisam propagar a imagem. Allies usam hoje `sprite` em `assets/enemies`; propor campo de arte de evento em `assets/interactions` com fallback compatível, preservando tintas das novas imagens.
3. Diferenciar Nyxara e Vaelis na recompensa de dois aliados, sem novos atributos ou alterações de RNG. Conectar João na escolta, Graz'zt no pacto/aliado, demais NPCs em pontos existentes. Coletáveis 48px, NPCs/props a altura definida no contrato; rótulos/anel/seta/vida/interação permanecem acessíveis.
4. Admitir derivado MJ01 somente no caminho estático do chefe. `ui/enemy_view.gd` já carrega por ID; não criar animações novas ou mudar mecânica de chefe. Restaurar provisório via snapshot se necessário.
5. Validar imports/refs e manifesto, testes de eventos (coleta por drop, resgate, escolta, recompensas das Irmãs/Graz'zt, estrelas, pactos e alvo), renderização e capturas em biomas. Rodar checks aplicáveis existentes e suite; relatar playtest humano como pendente.

Não há fonte do templo-alvo da escolta, jaula ou canoa entre estas dezessete. Contexto desses props foi textual nos planos aceitos e permanece conteúdo adiado; não alegar cobertura de todos os pontos/props ou inventar novos assets sem escopo. ART-032 continua aberto até admissão/validação. Aparências/lore continuam DRAFT salvo promoção explícita.

## Fila conferida

Registros locais reconciliados de FILA-022 (36/36), FILA-023 (60/60) e FILA-027 (20/20) evitam regeneração por cursores históricos. Erik/Arlindo têm extração/normalização pendente e fontes retidas; não reiniciar a passada cancelada. FILA-028 e altar possuem fontes/derivados aceitos, com admissão pendente. ART-033 lista costas dos heróis, e Korrak está explicitamente adiado; esse inventário não escolhe ou autoriza nova frente.

Préflight concluído: inventário e mapa de consumo (2/2). Próximo objetivo depende da definição da imagem e do alvo de implementação; depois preparar plano limitado com checkpoints. Geração, transformação, admissão, integração, CANON, commit, push e build não executados. Bugs: P0=0, quatro P1 abertos, quatorze implementados aguardando playtest.
