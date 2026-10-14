# GIFs Durvall v02 — 5 fps

PLAN-103 / SPEC-176 / B-002, IN_PLAN. Pedido explícito "faça os gifs", aplicado aos retornos P1 v02, P3 v02 e P4 v02; 5 fps preserva a última preferência da avaliação. DRAFT, sem admissão runtime ou promoção CANON.

Referências de identidade e cena conferidas na geração: Durvall ficha DRAFT r1 aprovada, idle como autoridade; P1 direita, P3 frente, P4 ataque à direita. Esta etapa apenas deriva prévias animadas dos três PNGs existentes, sem alterar as fontes. Sem lacunas BLOCKING. Aceite visual e problemas técnicos de grade/cortes permanecem pendentes.

Script: ../generated/m1-movimento/piloto-durvall/build_review_v02.py. Reutiliza a extração da avaliação v01: componentes alfa >=128 quando separáveis, senão divisão uniforme com componente dominante por célula; escala constante por tira e âncora horizontal do topo, origem vertical comum. Sem interpolação temporal. Esta prévia não reconstrói partes cortadas nem substitui um teste no jogo.

Saídas na pasta ../generated/m1-movimento/piloto-durvall/avaliacao/v02/: p1_5fps.gif (seis quadros), p3_5fps.gif (seis), p4_5fps.gif (quatro), durvall_p1_p3_p4_v02_5fps.gif (12 quadros comparativos, 2,4 s). Todos a 200 ms por quadro, loop infinito. Report.json registra extração, dimensões e hashes das fontes.

Verificação: os quatro GIFs abrem, têm a contagem esperada e duração 200 ms; comparativo conferido visualmente no primeiro e sexto quadros. Fontes PNG e GIFs v01 preservados. Nenhuma instalação ou alteração do código do jogo; sem commit/push.

Etapas DERIVE e VERIFY concluídas (2/2). Próximo checkpoint: dono avaliar fluidez, troca de pernas, oscilações e passagem final/início, além da leitura do golpe e dos cortes de espada; dizer quais ações aprova ou precisa revisar. Aceite subjetivo permanece PENDING.
