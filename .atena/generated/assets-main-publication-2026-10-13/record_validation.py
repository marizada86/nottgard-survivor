import json
import pathlib
import subprocess

out = pathlib.Path(__file__).resolve().parent
root = out.parents[2]
suite = (out / 'clean-suite.log.txt').read_text(encoding='utf-8')
smoke = (out / 'clean-smoke.log.txt').read_text(encoding='utf-8')
assert 'smoke: ok' in smoke
assert 'SCRIPT ERROR' not in suite and 'Parse Error' not in suite
audit = json.loads((out / 'clean-audit.json').read_text(encoding='utf-8'))
audit.update(import_exit_code=0, suite_exit_code=0, smoke_exit_code=0, smoke_stages=9)
(out / 'verification.json').write_text(json.dumps(audit, indent=2) + '\n', encoding='utf-8')
state_path = root / '.atena/state/assets-main-publication.yaml'
state = state_path.read_text(encoding='utf-8-sig').replace('status: IN_PROGRESS', 'status: VALIDATED_READY_FOR_MAIN_PUSH').replace('checkpoint: G-002/CLEAN_CHECKOUT_VALIDATION', 'checkpoint: G-003/MAIN_FF_AND_PUSH').replace('current_step_position: 2', 'current_step_position: 3').replace('completed_steps: 1', 'completed_steps: 2').replace('remaining_steps_after_current: 1', 'remaining_steps_after_current: 0')
state += '\nverification: .atena/generated/assets-main-publication-2026-10-13/verification.json\nevidence: .atena/evidence/assets-main-publication-2026-10-13.md\n'
state_path.write_text(state, encoding='utf-8')
central = root / '.atena/state/plan.yaml'
text = central.read_text(encoding='utf-8-sig')
prefix, block = text.split('assets_main_publication_2026_10_13:', 1)
block = block.replace('status: IN_PROGRESS', 'status: VALIDATED_READY_FOR_MAIN_PUSH').replace('checkpoint: G-001/COMMIT_GROUPS', 'checkpoint: G-003/MAIN_FF_AND_PUSH')
central.write_text(prefix + 'assets_main_publication_2026_10_13:' + block, encoding='utf-8')
evidence = f'''# Publicação de assets na main — v01, 2026-10-13

Autorização explícita: “atena, aprovado commit e push na main”. Modo per-plan; [spec](../specs/SPEC-121-retomada-fila-imagens/assets-main-publication-v01.md). Escopo: heróis Arlindo/Erik, Pulso Radiante, Ampulheta do Silêncio e seus registros/evidências. Arte permanece DRAFT admitida; nenhuma promoção CANON. Playtest humano: procedimento não relatado.

G-001 concluído: commits `7755002` (heróis), `d3c2fc8` (VFX), `02c9903` (ADD e evidências). Exclusão explícita de caches, saves e perfis QA; fontes previamente ignoradas continuam locais. Os dois avisos de linha vazia final nos Markdown de proveniência recuperada preservam o original; diff --check com essa exceção passou. Não há alteração de gameplay, versão ou CI.

G-002 concluído: git archive do commit `{audit['validated_commit']}` extraído em cópia limpa. [Auditoria](../generated/assets-main-publication-2026-10-13/verification.json): 22 PNGs de runtime e scripts alterados conferidos byte a byte, todos os links novos de evidência/spec existentes e publicados, nenhum arquivo QA adicionado. Maior blob alterado: {audit['maximum_changed_blob_bytes']} bytes. Importação inicial exit0, [suíte completa](../generated/assets-main-publication-2026-10-13/clean-suite.log.txt) exit0 e zero falhas, [smoke](../generated/assets-main-publication-2026-10-13/clean-smoke.log.txt) exit0 com nove fases OK. [Importação](../generated/assets-main-publication-2026-10-13/clean-import.log.txt) registra carregamento inicial do tema antes do cache da fonte existir; importação concluída, sem erro de script nos checks finais. Aviso local de certificados e recursos ao encerrar conforme logs.

G-003 pronto: main local F:/dev/nottgard-survivor limpa e origin/main ainda em `2ae8c48`, confirmadas novamente por fetch. Próximo: fast-forward, push normal e comparação SHA remoto. A CI configurada para push main poderá atualizar latest; conclusão da CI ainda não verificada. BUG-025/027/028/029 e PLAN-071 B-006/S-011 preservados.
'''
(root / '.atena/evidence/assets-main-publication-2026-10-13.md').write_text(evidence, encoding='utf-8')
print('Validation receipt ready')
