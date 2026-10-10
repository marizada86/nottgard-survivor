# Falta de alternância de pernas — revisão do dono

Classificação: IN_PLAN, correção necessária para aceitação da produção DEV-024. O dono anexou quatro tiras e relatou a mesma perna à frente em todos os passos, inclusive em outros jogadores. A inspeção visual confirma o defeito nas fontes anexadas, antes da reprodução. Não foi demonstrado ainda o alcance nos demais heróis.

O carregador ui/sprite_strip_frames.gd cria uma região distinta por índice, da esquerda para a direita; ui/hero_view.gd pede seis quadros para caminhada. A galeria build_review.py também divide a fonte em regiões distintas e não transforma poses. Essa leitura não encontrou um mecanismo que substitua todos os passos pela mesma pose. Não houve reprodução do jogo neste diagnóstico.

O prompt ER04-prompt-v01.txt já exige contato esquerdo no quadro 1 e direito no quadro 4. Portanto a instrução existe, mas o resultado gerado não a cumpre. As auditorias audit_hero_motion.gd e audit_hero_candidate_strip.gd medem dimensões, alfa, bounds e bordas; não identificam pernas nem alternância anatômica. O número de quadros e a existência de pixels não validam um ciclo de caminhada.

Conclusão: defeito confirmado de geração de poses e falha de aceitação/revisão. Não há evidência suficiente para atribuí-lo ao código de reprodução. As dez caminhadas de Erik e Arlindo exigem revisão/correção do ciclo, e a produção completa de arquivos não equivale à conclusão visual. Normalização, recorte ou reordenação não criam o contato oposto inexistente.

Próximo método: produzir e validar primeiro dois contatos anatômicos opostos, preservando direção, equipamento e escala; somente então gerar as passagens e montar seis fases. Validar visualmente 1 contra 4 e 3 contra 6 antes de admitir. Não espelhar o corpo inteiro, pois inverteria tocha, espada e assimetrias. Revisão dos outros heróis deve registrar resultados por tira, sem presumir que todos apresentam o mesmo defeito.
