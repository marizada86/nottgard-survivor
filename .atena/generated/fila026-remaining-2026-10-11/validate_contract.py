from pathlib import Path
import re,hashlib,json,subprocess

base=Path(__file__).parent
root=base.parents[2]
audit=json.loads((base/'audit.json').read_text(encoding='utf-8'))
jobs=json.loads((base/'jobs.json').read_text(encoding='utf-8'))
assert [r['code'] for r in audit['records']]==['L03','L04','L05','P01','P02','P03','C01','C02','C03']
approval_path=base/'owner-approval.json'
approved=approval_path.exists()
admitted=(base/'admission-receipt.json').exists()
expected_state='CANON_VISUAL_G2' if approved else 'DRAFT'
assert all(r['content_state']==expected_state and r['runtime_admission']==admitted for r in audit['records'])
if approved:
    receipt=json.loads(approval_path.read_text(encoding='utf-8'))
    assert receipt['owner_reply']=='Aprovo as nove revisões v01'
    assert len(receipt['records'])==9 and audit['gate']=='G2_ACCEPTED_PER_PIECE'
    for accepted,record in zip(receipt['records'],audit['records']):
        assert accepted['code']==record['code'] and accepted['revision']==record['revision']=='v01'
        assert accepted['prepared_sha256']==record['hashes']['final']
        assert record['checks']['owner_acceptance']=='ACCEPTED_G2_v01'
        for path,digest in [(accepted['source'],accepted['source_sha256']),(accepted['prepared'],accepted['prepared_sha256'])]:
            assert hashlib.sha256((base/path).read_bytes()).hexdigest()==digest
    assert jobs['owner_g2_status']=='ACCEPTED_PER_PIECE' and jobs['content_state']==expected_state
    proposal=json.loads((base/'admission-proposal.json').read_text(encoding='utf-8'))
    assert proposal['png_count']==10 and proposal['status']=='PROPOSED_NOT_EXECUTED'
    for entry in proposal['entries']:
        assert hashlib.sha256((root/entry['source']).read_bytes()).hexdigest()==entry['sha256']
        if admitted:
            assert hashlib.sha256((root/entry['destination']).read_bytes()).hexdigest()==entry['sha256']
        else:
            assert not entry['runtime_admission'] and not (root/entry['destination']).exists()
assert jobs['g1']=='ACCEPTED_L01_v01' and audit['technical_status']=='PASS'
assert jobs['optional_L02']=='DEFERRED_OPTIONAL_NOT_GENERATED'
selection=json.loads((base.parent/'fila026-l01-2026-10-11/owner-selection.json').read_text(encoding='utf-8'))
assert selection['owner_reply']=='Aprovo L01 v01' and selection['selected']=='v01'
old_audit=json.loads((base.parent/'fila026-l01-2026-10-11/audit.json').read_text(encoding='utf-8'))
assert old_audit['selected']=='v01' and old_audit['gate']=='G1_ACCEPTED'
for record in old_audit['records']:
    for output in record['outputs'].values():
        path=base.parent/'fila026-l01-2026-10-11'/output['path']
        assert hashlib.sha256(path.read_bytes()).hexdigest()==output['sha256']

paths=[base/'index.html',base.parent/'fila026-l01-2026-10-11/index.html',
       root/'.atena/evidence/fila026-remaining-2026-10-11.md',root/'.atena/evidence/fila026-l01-2026-10-11.md',
       root/'.atena/vault/canon/ASSET-APPROVAL-FILA026-L01-v01.md',
       root/'.atena/generated/CHATGPT-FILA-026-lettering-placas-e-cursor.md']
count=0
if approved:
    paths.append(root/'.atena/vault/canon/ASSET-APPROVAL-FILA026-G2-v01.md')
if admitted:
    paths.append(root/'.atena/evidence/fila026-admission-2026-10-11.md')
    admission=json.loads((base/'admission-receipt.json').read_text(encoding='utf-8'))
    assert admission['status']=='ADMITTED_VALIDATED_WAITING_ART_COMMIT'
    assert admission['tests_status']==admission['imports_status']=='PASS'
for path in paths:
    text=path.read_text(encoding='utf-8')
    links=re.findall(r'(?:src|href)="([^"]+)"',text) if path.suffix=='.html' else re.findall(r'\]\(([^)]+)\)',text)
    for link in links:
        if '://' in link or link.startswith('#'): continue
        assert (path.parent/link).is_file(),(path,link)
        count+=1
head=subprocess.check_output(['git','show','HEAD:.atena/state/plan.yaml']).decode('utf-8').replace('\r\n','\n')
current=(root/'.atena/state/plan.yaml').read_text(encoding='utf-8')
assert head.split('\nactive_plan:\n',1)[1]==current.split('\nactive_plan:\n',1)[1]
runtime_changed=subprocess.check_output(['git','diff','--name-only','--','assets','data','ui','project.godot']).decode().strip()
assert set(runtime_changed.splitlines()).issubset({'data/cursor.json'}) if admitted else not runtime_changed,runtime_changed
captures={p:hashlib.sha256((root/p).read_bytes()).hexdigest() for p in ['.atena/generated/ficha-c-integration/v01/desktop_heroi_durvall.png','assets/ui/title/title_background.png']}
result=dict(local_links_verified=count,technical_audit='PASS',selected_logo='v01',
            accepted_logo_derivatives_unchanged=True,nine_revision_state=expected_state,optional_L02_deferred=True,
            PLAN071_and_returns_unchanged=True,runtime_admitted=admitted,runtime_changes_authorized=True,preview_reference_hashes=captures,
            commits_created=0,pushes_performed=0,owner_G2='ACCEPTED_PER_PIECE' if approved else 'PENDING')
(base/'contract-check.json').write_text(json.dumps(result,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
jobs.update(current_step='S-013/ART_COMMIT_GATE' if admitted else ('S-013/ADMISSION_GATE' if approved else 'S-012/G2'),
            status='ADMITTED_VALIDATED_WAITING_ART_COMMIT' if admitted else ('VISUALLY_ACCEPTED_WAITING_ADMISSION_GATE' if approved else 'GENERATED_PREPARED_AUDITED_WAITING_G2'))
(base/'jobs.json').write_text(json.dumps(jobs,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
print(json.dumps(result,ensure_ascii=False))
