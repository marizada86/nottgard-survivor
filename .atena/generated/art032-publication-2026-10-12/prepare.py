"""Prepare a bounded ART-032 Git checkpoint without absorbing other local work."""
from pathlib import Path
import hashlib
import json
import subprocess

OUT = Path(__file__).resolve().parent
ROOT = OUT.parents[2]
def git(*args):
    return subprocess.check_output(['git', *args], cwd=ROOT).decode('utf-8')
def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()
assert git('branch', '--show-current').strip() == 'codex/assets-preparation-2026-10-10'
assert git('diff', '--cached', '--name-only') == ''
verification = json.loads((ROOT/'.atena/generated/art032-implementation-2026-10-12/delivery-verification.json').read_text(encoding='utf-8'))
assert verification['status'] == 'PASS' and verification['test_failures'] == 0
block = '''art032_publication_2026_10_12:
  plan: PLAN-ART032-PUBLISH
  revision: v01
  request_classification: IN_PLAN
  status: APPROVED_PREPARED
  mode: per-plan
  owner_reply: 'atena, commit e push'
  checkpoint: S-001/SCOPED_STAGING_PREPARED
  current_step_position: 1
  completed_steps: 0
  total_steps: 3
  remaining_steps_after_current: 2
  ordered_steps: [S-001, S-002, S-003]
  branch: codex/assets-preparation-2026-10-10
  destination: origin/codex/assets-preparation-2026-10-10
  scope: ART032_IMPLEMENTATION_AND_UNCOMMITTED_ART032_PRODUCTION_RECORDS
  content_state: DRAFT_AUTHORIZED_RUNTIME_USE
  canonical_promotion: false
  main_merge_release_export: NOT_REQUESTED
  evidence: .atena/generated/art032-publication-2026-10-12/plan.md
'''
path = ROOT/'.atena/state/plan.yaml'
working = path.read_text(encoding='utf-8')
assert 'art032_publication_2026_10_12:' not in working
assert working.startswith('version: 2\n')
before_head = git('show', 'HEAD:.atena/state/plan.yaml')
anchor = 'art032_npcs_lote02_2026_10_11:'
prefix = working.split(anchor, 1)[0]
assert prefix.startswith('version: 2\nart032_implementation_2026_10_12:')
staged = 'version: 2\n' + block + prefix[len('version: 2\n'):] + anchor + before_head.split(anchor, 1)[1]
path.write_text('version: 2\n' + block + working[len('version: 2\n'):], encoding='utf-8')
(OUT/'staged-plan.yaml').write_text(staged, encoding='utf-8')
(OUT/'plan.md').write_text('''# PLAN-ART032-PUBLISH/v01 — commit e push

Pedido explícito **“atena, commit e push”**, 2026-10-12. IN_PLAN: publicação Git da entrega local ART-032 concluída 6/6. Modalidade per-plan preservada; nenhum novo escopo de arte/mecânica. Conteúdo DRAFT autorizado no runtime, sem promoção a CANON. Destino: origin/codex/assets-preparation-2026-10-10. O push inclui os dois commits anteriores dessa branch ainda não enviados (lettering fc5c709 e NPCs 51b51f7). Não altera main, não faz merge e não aciona o workflow de latest, cujo gatilho push se limita a main.

1. S-001: conferir bugs, testes/evidências/hashes e selecionar somente runtime ART-032, fontes/lotes de pontos/Juiblex ainda não commitados e documentos necessários. Preservar alterações locais de lettering/heróis. Construir a versão de plan.yaml para o índice com as novas frentes ART-032 e a cauda já commitada; manter a versão local completa.
2. S-002: validar diff/checks, caminhos e índice; commit local de arte/runtime/registro ART-032. Autorizado explicitamente. A conexão de arte aos acontecimentos não muda as mecânicas existentes.
3. S-003: push normal para a branch atual, sem force; conferir SHA remoto e registrar recibo local. Autorizado explicitamente. Se houver divergência remota, parar antes de qualquer merge/rebase não autorizado.

Prontidão: suite final da implementação zero falhas, sete capturas em seis biomas, 17 fontes admitidas; quatro P1 ainda abertos (BUG-025/027/028/029) e 14 implementados aguardam playtest. Ausências anteriores de idle.png de Erik/Arlindo preservadas. Não rerodar testes sem mudança de código; reaplicar auditoria de hashes e diff. Playtest humano permanece pendente.

O plano e o recibo são registros operacionais. Não publicar perfis temporários de QA, caches ou alterações de outras frentes; fontes/hashes/recibos ART-032 e backups específicos permanecem rastreáveis. Recuperação: nenhuma alteração do conteúdo das outras frentes; não resetar o checkout nem usar push forçado.
''', encoding='utf-8')

paths = ['.atena/backlog/ARTE.md', '.atena/evidence/art032-implementation-2026-10-12.md', '.atena/evidence/art032-juiblex-delivery-2026-10-12.md', '.atena/evidence/art032-juiblex-preparation-2026-10-12.md', '.atena/evidence/art032-pontos-2026-10-11.md', '.atena/state/art032-implementation.yaml', '.atena/state/art032-juiblex.yaml', '.atena/state/art032-next-request-2026-10-12.yaml', '.atena/state/art032-pontos.yaml', '.atena/vault/drafts/PLAN-ART032-IMPLEMENT-v01.md', '.atena/vault/drafts/PLAN-ART032-JUIBLEX-v01.md', '.atena/vault/drafts/PLAN-ART032-PONTOS-v01.md', 'core/happenings.gd', 'data/stage_events.json', 'ui/overlay.gd', 'ui/happening_art.gd', 'ui/happening_art.gd.uid', 'tests/test_happening_art.gd', '.atena/generated/art032-commit-2026-10-11/commit-receipt.json']
manifest = json.loads((ROOT/'.atena/generated/art032-implementation-2026-10-12/manifest.json').read_text(encoding='utf-8'))
for entry in manifest['entries']:
    assert sha(ROOT/entry['destination']) == entry['derived_sha256']
    paths.extend([entry['destination'], entry['destination'] + '.import'])
packages = ['art032-implementation-2026-10-12', 'art032-implementation-preflight-2026-10-12', 'art032-juiblex-2026-10-12', 'art032-pontos-2026-10-11', 'art032-publication-2026-10-12']
for package in packages:
    paths += git('ls-files', '--others', '--exclude-standard', '--', '.atena/generated/'+package).splitlines()
paths = sorted({p for p in paths if not Path(p).name.startswith(('capture-profile', 'test-profile')) and '.godot/' not in p and '__pycache__/' not in p})
for p in paths:
    assert (ROOT/p).is_file(), p
    assert (ROOT/p).stat().st_size < 90_000_000, p
selection = {'owner_reply': 'atena, commit e push', 'head_before': git('rev-parse', 'HEAD').strip(), 'branch': git('branch', '--show-current').strip(), 'scope': 'ART032', 'paths': paths, 'partial_index_path': '.atena/state/plan.yaml', 'partial_index_source': (OUT/'staged-plan.yaml').relative_to(ROOT).as_posix(), 'working_plan_sha256': sha(path), 'protected_implementation_snapshot': '.atena/generated/art032-implementation-2026-10-12/protected-snapshot.json', 'total_bytes': sum((ROOT/p).stat().st_size for p in paths)}
(OUT/'selection.json').write_text(json.dumps(selection, ensure_ascii=False, indent=2)+'\n', encoding='utf-8')
print(f'Prepared {len(paths)} exact paths, {selection["total_bytes"]/1024/1024:.1f} MiB plus partial plan.yaml; no index mutation yet.')
