from pathlib import Path
import hashlib
import json
import runpy

base = Path(__file__).parent
audit = json.loads((base / 'audit.json').read_text(encoding='utf-8'))
codes = ['L03', 'L04', 'L05', 'P01', 'P02', 'P03', 'C01', 'C02', 'C03']
assert [r['code'] for r in audit['records']] == codes
accepted = []
for r in audit['records']:
    for path, digest in [(r['source'], r['source_sha256']), (r['prepared'], r['hashes']['final'])]:
        assert hashlib.sha256((base / path).read_bytes()).hexdigest() == digest
    accepted.append(dict(code=r['code'], revision=r['revision'], source=r['source'],
                         source_sha256=r['source_sha256'], prepared=r['prepared'],
                         prepared_sha256=r['hashes']['final'], native_sha256=r['hashes']['native'],
                         size=r['size']))
receipt = dict(plan='PLAN-065', spec='SPEC-132', gate='G2_ACCEPTED_PER_PIECE',
               date='2026-10-11', owner_reply='Aprovo as nove revisões v01',
               content_state='CANON_VISUAL_G2', runtime_admission=False,
               scope='Visual acceptance of each named v01 source and prepared derivative shown in the gallery; includes Gothic capitals of L03/L04, contrast and cursors at 32/40 px.',
               records=accepted, integration_authorized=False, commit_authorized=False, push_authorized=False)
path = base / 'owner-approval.json'
if path.exists():
    assert json.loads(path.read_text(encoding='utf-8')) == receipt, 'Existing owner receipt differs'
else:
    path.write_text(json.dumps(receipt, ensure_ascii=False, indent=2)+'\n', encoding='utf-8')
runpy.run_path(str(base / 'reconcile_approval.py'))
