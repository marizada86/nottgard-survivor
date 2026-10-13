# SPEC-121 — Publicação dos assets na main / v01

Estado: aprovado per-plan em2026-10-13. Dono: **“atena, aprovado commit e push na main”**. A autorização cobre os commits/integracão/push da entrega deste chat na main; CI existente disparada por push pode atualizar latest. Sem mudança de versão ou fluxo CI, nenhuma promoção CANON ou playtest humano inventado. Preparada antes de commit.

Escopo: arte de Arlindo/Erik (18tiras/101quadros+2estáticos), Pulso e Ampulheta (2atlas+helpers/roteamento/testes), estados/specs/evidências e artefatos de revisão da sessão. Não incluir dados de saves/perfis/caches QA; candidatas sob art-candidates continuam ignoradas e locais, sem force-add. [Plano/pathspec](../../generated/assets-main-publication-2026-10-13/plan.json) delimita publicação. Backups/fontes/recibos selecionados publicados somente quando não ignorados, preservando proveniência. Logs de checks ligados nos documentos terão cópia textual publicável; originais.log continuam locais. Referências históricas podem apontar para fontes ignoradas, explicitamente locais; não se declara migração integral de outras branches.

G-001: criar branch de preparação codex/assets-admission-main-2026-10-13 neste worktree (HEAD detached2ae8c48), commits separados heroes, nova-vfx e registros ADD. Main F:/dev/nottgard-survivor limpa e igual a origin/main após fetch autorizado. Nenhum reset/rebase/destruição de arquivos ou código alheio.

G-002: extrair git archive de HEAD commitado em pasta local, importar Godot, suíte completa e smoke em APPDATA QA isolado. Conferir byte a byte hashes dos22assets/runtime/helpers/fontes incluídos no commit, pathspec e links publicáveis. Resultado precisa PASS antes do push. Não instalar dependências/exportar localmente.

G-003: confirmar main/remote sem avanço conflitante; integrar por fast-forward na main limpa, push normal sem force e conferir SHA remoto por ls-remote. Se referência tiver avançado ou houver mudanças concorrentes, analisar/integrar sem perder trabalho; não forçar o remoto. Registrar recibo de commits/range/hash e estado da CI somente quando observado. Sem declarar workflow/release concluído a partir de push.

Modo per-plan escolhido/escopo Git explícito; etapas3, checkpointsG-001,G-002,G-003. Não repetir pedido de aprovação. Retornos PLAN071 B006/S011 e pendências subjetivas anteriores preservados. “Aprovado” aceita a entrega local da Ampulheta; procedimento de playtest não foi relatado e não será inventado.

Aceite: escopo e índice controlados, check checkout limpo0falhas/smoke9fases, main avançada sem perda, push normal confirmado por SHA, fatos Git/evidências reconciliados. Publicação no Git não converte DRAFT em CANON, nem fecha BUG-025/027/028/029. Manter somente pendências reais, sem fabricação de playtests ou histórico.
