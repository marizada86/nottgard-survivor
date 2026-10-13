"""Validate and stage only the explicitly authorized, accepted ART-032 lots."""
import hashlib
import json
import subprocess
from html.parser import HTMLParser
from pathlib import Path

ROOT = Path(__file__).resolve().parents[3]
OUT = Path(__file__).resolve().parent
PACKAGES = ['.atena/generated/art032-npcs-2026-10-11', '.atena/generated/art032-npcs-lote02-2026-10-11']
FILES = ['.atena/backlog/ARTE.md', '.atena/state/art032-npcs-piloto.yaml', '.atena/state/art032-npcs-lote02.yaml', '.atena/evidence/art032-npcs-piloto-2026-10-11.md', '.atena/evidence/art032-npcs-lote02-preparation-2026-10-11.md', '.atena/evidence/art032-npcs-lote02-delivery-2026-10-11.md', '.atena/vault/drafts/PLAN-ART032-NPCS-PILOTO-v01.md', '.atena/vault/drafts/PLAN-ART032-NPCS-LOTE02-v01.md']

def git(*args):
    return subprocess.check_output(['git', *args], cwd=ROOT)

def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()

class Links(HTMLParser):
    def __init__(self):
        super().__init__(); self.links = []
    def handle_starttag(self, tag, attrs):
        for key, value in attrs:
            if key in ('src', 'href', 'data-source') and value:
                self.links.append(value)

assert not git('diff', '--cached', '--name-only').strip(), 'Existing index must be preserved'
accepted, native = [], []
for directory in PACKAGES:
    package = ROOT / directory
    jobs = json.loads((package / 'jobs.json').read_text(encoding='utf-8'))
    receipt = json.loads((package / 'visual-acceptance.json').read_text(encoding='utf-8'))
    assert receipt['status'] == 'APPROVED_EXPLICITLY' and receipt['content_state'] == 'DRAFT'
    assert {(j['code'], j['revision'], j['sha256']) for j in jobs['jobs']} == {(j['code'], j['revision'], j['sha256']) for j in receipt['accepted']}
    for record in receipt['accepted']:
        assert sha(ROOT / record['path']) == record['sha256']
        accepted.append(record)
    for job in jobs['jobs'] + jobs.get('previous_native_versions', []):
        assert sha(ROOT / job['destination']) == job['sha256'] == sha(Path(job['original_path']))
        native.append(job['destination'])
    snapshot = json.loads((package / 'protected-snapshot.json').read_text(encoding='utf-8'))
    for path, expected in snapshot.items():
        if '#active_plan_tail' in path:
            actual = hashlib.sha256((ROOT / '.atena/state/plan.yaml').read_text(encoding='utf-8').split('active_plan:', 1)[1].encode()).hexdigest()
        else:
            actual = sha(ROOT / path)
        assert actual == expected, path
    qa = json.loads((package / 'gallery-qa.json').read_text(encoding='utf-8'))
    assert qa['gallery_local_links'] == qa['gallery_metadata'] == 'PASS'
    assert sha(package / qa['reading_image']) == qa['reading_image_sha256']
    parser = Links(); parser.feed((package / 'index.html').read_text(encoding='utf-8'))
    for link in parser.links:
        assert (package / link).is_file(), link
assert len(accepted) == 10 and len(native) == 13
head = git('rev-parse', 'HEAD').decode().strip()
working = (ROOT / '.atena/state/plan.yaml').read_text(encoding='utf-8')
base = git('show', 'HEAD:.atena/state/plan.yaml').decode('utf-8')
blocks = working.split('art032_npcs_lote02_2026_10_11:', 1)[1].split('fila026_remaining_2026_10_11:', 1)[0]
staged_root = base.replace('version: 2\n', 'version: 2\nart032_npcs_lote02_2026_10_11:' + blocks, 1)
assert staged_root != base
assert staged_root.split('active_plan:', 1)[1] == base.split('active_plan:', 1)[1]
candidate = OUT / 'staged-plan.yaml'
candidate.write_text(staged_root, encoding='utf-8')
verification = {'date':'2026-10-11', 'owner_request':'atena, aprovado, commite e continue a Próxima frente proposta: os pontos de acontecimentos restantes de ART-032.', 'authority':'EXPLICIT_LOCAL_COMMIT_ONLY', 'base_head':head, 'accepted_draft_sources':10, 'native_outputs_preserved':13, 'source_hashes_and_gallery_links':'PASS', 'protected_runtime_assets_and_plan071_chain':'PASS', 'unrelated_changes':'EXCLUDED_AND_PRESERVED', 'root_state_staging':'ART032_BLOCKS_ONLY_OVER_HEAD', 'canon_admission_push_build':False, 'selected_revisions':accepted, 'scope_paths':PACKAGES + FILES + ['.atena/state/plan.yaml', '.atena/generated/art032-commit-2026-10-11/verify_stage.py', '.atena/generated/art032-commit-2026-10-11/precommit-verification.json']}
(OUT / 'precommit-verification.json').write_text(json.dumps(verification, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
git('add', '--', *PACKAGES, *FILES, '.atena/generated/art032-commit-2026-10-11/verify_stage.py', '.atena/generated/art032-commit-2026-10-11/precommit-verification.json')
blob = git('hash-object', '-w', '--', str(candidate)).decode().strip()
git('update-index', '--cacheinfo', '100644,' + blob + ',.atena/state/plan.yaml')
paths = git('diff', '--cached', '--name-only').decode().splitlines()
for path in paths:
    assert path in verification['scope_paths'] or any(path.startswith(p + '/') for p in PACKAGES), path
assert len([p for p in paths if '/sources/' in p and p.endswith('.png')]) == 13
git('diff', '--cached', '--check')
print(json.dumps({'status':'PASS', 'accepted':10, 'native':13, 'staged_files':len(paths), 'base_head':head, 'runtime_changes':0, 'unrelated_changes_preserved':True}))
