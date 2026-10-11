"""Read-only contract checks; writes only this QA package's audit and gallery."""
import hashlib
import html
import json
import re
from pathlib import Path
import subprocess
from urllib.parse import unquote
from PIL import Image

ROOT = Path(__file__).resolve().parents[3]
OUT = Path(__file__).resolve().parent
REL = OUT.relative_to(ROOT).as_posix()

def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()

def git(*args):
    return subprocess.check_output(['git', *args], cwd=ROOT)

def read(name):
    path = OUT / name
    if not path.exists() and path.suffix == '.log':
        path = OUT / 'tracked-logs' / path.with_suffix('.txt').name
    return path.read_text(encoding='utf-8-sig')

records = []
expected = {'titulo', 'quartel', 'hq', 'vitoria', 'derrota', 'evolucao', 'chefe', 'ficha'}
for dimensions in [(1280, 720), (1920, 1080)]:
    report_name = 'captures_%dx%d.json' % dimensions
    if dimensions == (1920, 1080) and not (OUT / report_name).exists():
        # Existing capture report used viewport texture allocation size in its filename.
        # Every recorded image uses the actual rendered image dimensions, checked below.
        report_name = 'captures_2880x1620.json'
    report = json.loads(read(report_name))
    assert report['kind'] == 'real_runtime_synthetic_QA'
    assert report['profile'].startswith('res://' + REL + '/')
    assert {r['screen'] for r in report['records']} == expected
    assert len(report['records']) == 8
    for r in report['records']:
        path = ROOT / r['path'].removeprefix('res://')
        with Image.open(path) as image:
            assert image.size == dimensions == tuple(r['size']) and r['save_status'] == 0
        records.append({**r, 'relative_path': path.relative_to(OUT).as_posix(), 'sha256': sha(path), 'technical_visual_review': 'COMPLETED'})

mobile = json.loads(read('mobile/captures_1280x720.json'))
assert mobile['touch_preview'] and len(mobile['records']) == 2
for r in mobile['records']:
    path = ROOT / r['path'].removeprefix('res://')
    with Image.open(path) as image:
        assert image.size == (1280, 720) and r['save_status'] == 0
    records.append({**r, 'relative_path': path.relative_to(OUT).as_posix(), 'sha256': sha(path), 'technical_visual_review': 'COMPLETED_TOUCH_PREVIEW'})
layout = json.loads(read('mobile/header-layout.json'))
assert not layout['overlap']
assert layout['title_bottom'] < layout['subtitle_top'] < layout['subtitle_bottom'] < layout['tabs_top']

receipt = json.loads((ROOT / '.atena/generated/fila026-remaining-2026-10-11/admission-receipt.json').read_text(encoding='utf-8-sig'))
assert len(receipt['records']) == 10
assets = []
for r in receipt['records']:
    path = ROOT / r['destination']
    assert sha(path) == r['sha256']
    assert git('show', 'HEAD:' + r['destination']) == path.read_bytes()
    assets.append({'code': r['code'], 'revision': r['revision'], 'path': r['destination'], 'sha256': sha(path)})
manifest = ROOT / '.atena/generated/ASSET-PRODUCTION-MANIFEST-001.json'
assert git('show', 'HEAD:' + manifest.relative_to(ROOT).as_posix()) == manifest.read_bytes()
for path in ['data/lettering.json', 'data/cursor.json', 'core/version.gd', 'export_presets.cfg', 'ui/hero_panel.gd']:
    assert git('show', 'HEAD:' + path) == (ROOT / path).read_bytes(), path

code = ['ui/lettering.gd', 'ui/hud.gd', 'ui/run.gd', 'ui/hq_screen.gd', 'ui/menu.gd', 'ui/character_sheet.gd', 'tests/test_lettering_assets.gd']
assert 'testes: 0 falha(s)' in read('suite.log')
assert 'RESUMO;erros=0;avisos=9' in read('project-audit.log')
assert 'smoke: ok' in read('smoke.log') and read('smoke.log').count('estado=running') == 9
logs = ['suite.log', 'suite-errors.log', 'project-audit.log', 'project-audit-errors.log', 'smoke.log', 'smoke-errors.log', 'capture1280.log', 'capture1280-errors.log', 'capture1920.log', 'capture1920-errors.log', 'capture-mobile.log', 'capture-mobile-errors.log']
for name in logs:
    text = read(name)
    assert 'SCRIPT ERROR' not in text and 'Parse Error' not in text, name
baseline = ['assets/animations/heroes/arlindo/idle.png', 'assets/animations/heroes/erik/idle.png', 'assets/heroes/arlindo.png', 'assets/heroes/erik.png']
for path in baseline:
    assert not git('ls-tree', 'HEAD', '--', path).strip(), path
assert not git('diff', '--', 'tests/test_animation_assets.gd').strip()
for ref in ['7c4da5d', '1ef33bf']:
    subprocess.run(['git', 'merge-base', '--is-ancestor', ref, 'HEAD'], cwd=ROOT, check=True)
plan = (ROOT / '.atena/state/plan.yaml').read_text(encoding='utf-8-sig')
old = git('show', 'HEAD:.atena/state/plan.yaml').decode('utf-8-sig')
assert plan.split('active_plan:', 1)[1] == old.split('active_plan:', 1)[1]
assert git('rev-parse', 'HEAD').decode().strip() == 'c8abf75d1fbbeb077f16afcde4a9be5ff0b2051c'
subprocess.run(['git', 'diff', '--check'], cwd=ROOT, check=True)

docs = ['.atena/evidence/fila026-integration-2026-10-11.md', '.atena/vault/drafts/PLAN-065-lettering-e-cursor-2026-10-06.md', '.atena/vault/drafts/SPEC-132-lettering-e-cursor-do-jogo.md', '.atena/backlog/ARTE.md', '.atena/backlog/MECANICAS.md', '.atena/backlog/RELEASES.md']
for path in docs:
    source = ROOT / path
    for target in re.findall(r'\]\(([^\s)]+)\)', source.read_text(encoding='utf-8-sig')):
        if target.startswith(('https:', 'http:', '#', 'mailto:')):
            continue
        assert (source.parent / unquote(target.split('#', 1)[0])).exists(), (path, target)
for path in ['.atena/state/fila026-remaining.yaml', '.atena/state/plan-065-lettering-cursor.yaml']:
    text = (ROOT / path).read_text(encoding='utf-8-sig')
    assert 'CODE_COMMIT_PENDING_EXPLICIT_APPROVAL' in text or 'CODE_COMMIT_AUTHORIZED' in text
    assert 'current_step_position: 16' in text and 'total_steps: 16' in text
    assert 'human_playtest: PENDING' in text

audit = {'plan': 'PLAN-065', 'spec': 'SPEC-132', 'revision': 'FILA026-INTEGRATION/v01', 'status': 'PASS_LOCAL_IMPLEMENTED_PENDING_PLAYTEST', 'code_state': 'LOCAL_UNCOMMITTED', 'visual_content_state': 'CANON_ACCEPTED_V01_UNCHANGED', 'suite': {'exit_code': 0, 'failures': 0, 'known_diagnostics': 'Missing Arlindo/Erik idle images already absent in HEAD; resource/RID shutdown diagnostics remain'}, 'project_audit': {'exit_code': 0, 'errors': 0, 'warnings': 9}, 'smoke': {'exit_code': 0, 'running_stages': 9}, 'g5_commits_verified_ancestors': ['7c4da5d', '1ef33bf'], 'capture_processes_exit_code': 0, 'capture_kind': 'actual_runtime_synthetic_QA', 'captures': records, 'touch_header_layout': layout, 'accepted_runtime_assets': assets, 'manifest_unchanged_sha256': sha(manifest), 'code_sha256': {p: sha(ROOT / p) for p in code}, 'logs_sha256': {p: sha(OUT / p) for p in logs}, 'checks': {'fallback_banner_reuse_and_restore': 'PASS_IN_FULL_SUITE', 'cursor_auto_mouse_modal_contract': 'PASS_IN_FULL_SUITE', 'plan071_active_state_and_return_chain': 'UNCHANGED', 'version_export_configuration': 'UNCHANGED', 'runtime_asset_bytes': 'UNCHANGED', 'git_diff_check': 'PASS'}, 'coverage_limits': ['HQ initial Uma Noite sem Fim and Dagruve boss used for runtime screenshots', 'Touch is desktop preview, not native device acceptance', 'OS cursor does not appear in viewport screenshots; real-window human check pending', 'Synthetic QA captures do not represent a human playtest or gameplay satisfaction'], 'publication': {'code_commit': 'PENDING_EXPLICIT_OWNER_APPROVAL', 'code_push': 'NOT_AUTHORIZED', 'build_release': 'NOT_AUTHORIZED', 'head_unchanged': git('rev-parse', 'HEAD').decode().strip()}}
(OUT / 'audit.json').write_text(json.dumps(audit, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
scope = {'plan': 'PLAN-065', 'mechanic': 'MEC-058', 'status': 'PROPOSAL_ONLY_PENDING_OWNER_APPROVAL', 'proposed_subject': 'feat(ui): integrate approved lettering across game screens', 'tracked_whitelist': code + docs + ['.atena/state/fila026-remaining.yaml', '.atena/state/plan-065-lettering-cursor.yaml'], 'partial_file': {'.atena/state/plan.yaml': 'Only fila026_remaining_2026_10_11 entry; preserve hero extraction and PLAN-071 tail'}, 'evidence_package': REL, 'exclude_generated_temporary_profiles': ['*-profile.json', '*-profile.json.bak'], 'exclude_other_work': ['Hero extraction/review and FILA-027 changes', 'tests/test_quartel.gd.uid', '.atena/generated/controller-experience/v01/unit-profile.json', '.atena/generated/controller-experience/v01/unit-profile.json.bak'], 'runtime_art_already_in_separate_commit': '86c453fe2f6328b9495f8bb0cdc36618e02111f2', 'push_build': 'Separate explicit gate'}
(OUT / 'commit-proposal.json').write_text(json.dumps(scope, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')

sections = []
for label, subset in [('1280 × 720', records[:8]), ('1920 × 1080', records[8:16]), ('Touch simulado · 1280 × 720', records[16:])]:
    cards = ''.join('<figure><a href="%s"><img src="%s" alt="%s" loading="lazy"></a><figcaption>%s</figcaption></figure>' % (r['relative_path'], r['relative_path'], html.escape(r['screen']), html.escape(r['screen'])) for r in subset)
    sections.append('<h2>%s</h2><div class="grid">%s</div>' % (label, cards))
(OUT / 'index.html').write_text('''<!doctype html><html lang="pt-BR"><meta charset="utf-8"><meta name="viewport" content="width=device-width"><title>FILA-026 · integração v01</title><style>body{background:#100f16;color:#e7dfca;font:16px system-ui;margin:30px auto;max-width:1500px;padding:0 20px}h1,h2{color:#d7b65f}p{max-width:1000px;line-height:1.6}a{color:#d7b65f}.grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(450px,1fr));gap:20px}figure{margin:0;background:#211c29;padding:10px;border:1px solid #66512d;border-radius:8px}img{width:100%;display:block}figcaption{padding:10px 0} @media(max-width:550px){.grid{grid-template-columns:1fr}}</style><h1>FILA-026 · integração v01</h1><p>PLAN-065 / SPEC-132. Peças CANON v01 já aceitas; integração local ainda sem commit. Suíte: zero falhas. Auditoria: zero erros, nove avisos existentes. Smoke: nove fases. Capturas reais do runtime com perfil sintético e resultados preparados para QA.</p><p>Os cenários incluem a primeira HQ e o chefe de Dagruve. Touch foi simulado no desktop. O cursor do sistema operacional não aparece nestas capturas: leitura, hotspot e troca de formas na janela real aguardam playtest humano. Nenhuma build ou publicação foi feita.</p><p><a href="audit.json">Auditoria técnica</a> · <a href="../../evidence/fila026-integration-2026-10-11.md">Evidência e roteiro de playtest</a></p>''' + ''.join(sections) + '</html>\n', encoding='utf-8')
print('integration contract PASS: 18 captures, 10 unchanged accepted PNGs, suite 0 failures, audit 0 errors/9 warnings, smoke 9 stages')
