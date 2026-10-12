# PLAN-ART032-PUBLISH/v01 — commit e push

Pedido explícito **“atena, commit e push”**, 2026-10-12. IN_PLAN: publicação Git da entrega local ART-032 concluída 6/6. Modalidade per-plan preservada; nenhum novo escopo de arte/mecânica. Conteúdo DRAFT autorizado no runtime, sem promoção a CANON. Destino: origin/codex/assets-preparation-2026-10-10. O push inclui os dois commits anteriores dessa branch ainda não enviados (lettering fc5c709 e NPCs 51b51f7). Não altera main, não faz merge e não aciona o workflow de latest, cujo gatilho push se limita a main.

1. S-001: conferir bugs, testes/evidências/hashes e selecionar somente runtime ART-032, fontes/lotes de pontos/Juiblex ainda não commitados e documentos necessários. Preservar alterações locais de lettering/heróis. Construir a versão de plan.yaml para o índice com as novas frentes ART-032 e a cauda já commitada; manter a versão local completa.
2. S-002: validar diff/checks, caminhos e índice; commit local de arte/runtime/registro ART-032. Autorizado explicitamente. A conexão de arte aos acontecimentos não muda as mecânicas existentes.
3. S-003: push normal para a branch atual, sem force; conferir SHA remoto e registrar recibo local. Autorizado explicitamente. Se houver divergência remota, parar antes de qualquer merge/rebase não autorizado.

Prontidão: suite final da implementação zero falhas, sete capturas em seis biomas, 17 fontes admitidas; quatro P1 ainda abertos (BUG-025/027/028/029) e 14 implementados aguardam playtest. Ausências anteriores de idle.png de Erik/Arlindo preservadas. Não rerodar testes sem mudança de código; reaplicar auditoria de hashes e diff. Playtest humano permanece pendente.

O plano e o recibo são registros operacionais. Não publicar perfis temporários de QA, caches ou alterações de outras frentes; fontes/hashes/recibos ART-032 e backups específicos permanecem rastreáveis. Recuperação: nenhuma alteração do conteúdo das outras frentes; não resetar o checkout nem usar push forçado.

Check de staging: o log bruto import-log.txt contém espaços finais emitidos pelo Godot. Preservado localmente sem edição e excluído do commit; imports são comprovados por auditoria e testes finais incluídos.
