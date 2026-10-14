# Durvall — P1 v02, P3 v02 e P4 v02, 2026-10-14

PLAN-103 / SPEC-176 / B-002, IN_PLAN, per-batch preservado, autorização explícita: "atena agora vamos para P1 v02, P3 v02 e P4 v02". Revisão P1-P3-P4/v02. Conteúdo DRAFT; sem promoção CANON, integração runtime, commit ou publicação.

Fontes locais do checkout principal F:/dev/nottgard-survivor: PROMPT-P1-v02.md e PROMPTS-v02.md, copiados para ../generated/m1-movimento/piloto-durvall/. PLAN-103 D20 registra feedback humano: P2/P3 bons a 5 fps, P5 descartado, P1 precisa de fluidez, P3 de separação e P4 de espaço para espada. O nome do retorno P4 v02 é **durvall_attack_wide_v01.png**, conforme o prompt; a primeira fonte wide é v01 embora o prompt seja v02.

Prontidão visual: identidade Durvall, ficha DRAFT r1 aprovada no G-D1, idle como autoridade obrigatória de rosto, figurino, arma e acabamento. Contexto textual: pintura de pixel, câmera três-quartos, luz superior esquerda; P1 perfil direita, P3 frente, P4 ataque em três-quartos direita. Sem lacunas BLOCKING para geração experimental; identidade visual e fluidez finais aguardam revisão humana.

Image_gen integrada, transparent_background=true. Cada chamada usou o texto integral da revisão respectiva, sem acréscimos, e somente os dois anexos previstos: durvall_idle.png mais gabarito_move_e_v02.png / gabarito_move_s_v02.png / gabarito_attack_wide.png. Nenhum retorno defeituoso anterior foi usado como referência.

Mudanças do prompt: P1 passada média de ~40% da altura, trote quase ereto, transições menores, seis quadros; P3 seis quadros com faixas transparentes de separação; P4 quatro células quadradas 512×512, preservando a altura corporal do idle.

Retornos nativos preservados em ../generated/m1-movimento/piloto-durvall/retorno/: durvall_move_e_v02.png, durvall_move_s_v02.png, durvall_attack_wide_v01.png. V01 anteriores intactas. Relatório medido com Pillow já disponível: ../generated/m1-movimento/piloto-durvall/avaliacao/report-v02.json (dimensões, alfa e hashes).

Inspeção: seis poses em P1/P3, quatro em P4; linhas/números do gabarito ausentes. Fontes não respeitam as dimensões exatas dos gabaritos. P1/P3 ainda mostram espada encostando/cortada na última borda; P3 não garante as faixas vazias previstas e a orientação tende a três-quartos. P4 oferece extensão de lâmina visível no golpe, mas não garante quatro células quadradas nem folgas por célula; não se declara aprovação técnica. Altura corporal, base, passada e mão da arma exigem auditoria posterior. Fluidez e identidade permanecem sem aceite humano nesta revisão.

Etapas P1, P3, P4 e VERIFY concluídas (4/4); próximo checkpoint B-002/S-008/V02_OWNER_REVIEW. Próximo objetivo: dono revisa os três retornos; depois preparar avaliação animada/normalização conforme decisão, antes de admitir no jogo. Este pedido gerou apenas as três novas fontes; GIFs anteriores preservados.

Backlog inicial: zero P0, quatro P1 abertos, 16 implementados aguardando playtest, um alerta de organização. Sem código do jogo alterado, dependências instaladas, Git ou exportação.
