"""Final contract/link/hash/commit checks; no image edits or Git mutations."""
from pathlib import Path
import hashlib
import json
import re
import subprocess
OUT=Path(__file__).resolve().parent
ROOT=OUT.parents[2]
def sha(p): return hashlib.sha256(p.read_bytes()).hexdigest()
def git(*args): return subprocess.check_output(['git',*args],cwd=ROOT)
data=json.loads((OUT/'jobs.json').read_text(encoding='utf-8'))
assert data['completed_steps']==4 and data['current_step_position']==5
assert data['status']=='DELIVERED_DRAFT_OWNER_VISUAL_REVIEW_PENDING'
assert len(data['jobs'])==6 and len(data['previous_native_versions'])==5
for j in data['jobs']+data['previous_native_versions']:
    assert sha(ROOT/j['destination'])==j['sha256']==sha(Path(j['original_path']))
for r in data['sources']+data['style_references']:
    p=Path(r['path']);p=p if p.is_absolute() else ROOT/p
    assert sha(p)==r['sha256']
for p,expected in json.loads((OUT/'protected-snapshot.json').read_text(encoding='utf-8')).items():
    actual=hashlib.sha256((ROOT/'.atena/state/plan.yaml').read_text(encoding='utf-8').split('active_plan:',1)[1].encode()).hexdigest() if '#active_plan_tail' in p else sha(ROOT/p)
    assert actual==expected,p
commit='51b51f7369ae34eede997435e6eb52ea057daf25'
assert git('rev-parse','HEAD').decode().strip()==commit
assert not git('diff','--cached','--name-only').strip()
old=json.loads((ROOT/'.atena/generated/art032-commit-2026-10-11/precommit-verification.json').read_text(encoding='utf-8'))
paths=git('show','--format=','--name-only',commit).decode().splitlines()
for p in paths:
    assert p in old['scope_paths'] or any(p.startswith(d+'/') for d in old['scope_paths'] if d.startswith('.atena/generated/art032-npcs-')),p
committed_native=[p for p in paths if '/sources/' in p and p.endswith('.png')]
assert len(committed_native)==13
for p in committed_native: assert hashlib.sha256(git('show',commit+':'+p)).hexdigest()==sha(ROOT/p),p
statepath=ROOT/'.atena/state/art032-pontos.yaml'
state=statepath.read_text(encoding='utf-8')
rootpath=ROOT/'.atena/state/plan.yaml'
prefix,tail=rootpath.read_text(encoding='utf-8').split('art032_npcs_lote02_2026_10_11:',1)
assert 'human_visual_acceptance: PENDING' in state and 'completed_steps: 4' in state
if 'previous_lots_local_commit:' not in state:
    state+='previous_lots_local_commit: '+commit+'\nprevious_lots_commit_receipt: .atena/generated/art032-commit-2026-10-11/commit-receipt.json\n'
    statepath.write_text(state,encoding='utf-8')
    prefix+='  previous_lots_local_commit: '+commit+'\n  previous_lots_commit_receipt: .atena/generated/art032-commit-2026-10-11/commit-receipt.json\n'
    rootpath.write_text(prefix+'art032_npcs_lote02_2026_10_11:'+tail,encoding='utf-8')
for relative in ['.atena/vault/drafts/PLAN-ART032-PONTOS-v01.md','.atena/evidence/art032-pontos-2026-10-11.md']:
    path=ROOT/relative
    for link in re.findall(r'\]\(([^)]+)\)',path.read_text(encoding='utf-8')): assert (path.parent/link).resolve().is_file(),link
qa=json.loads((OUT/'gallery-qa.json').read_text(encoding='utf-8'))
assert qa['preview_count']==12 and sha(OUT/qa['reading_image'])==qa['reading_image_sha256']
git('diff','--check')
verification={'plan':data['plan'],'revision':'v01','status':'PASS_OWNER_VISUAL_GATE_PENDING','completed_steps':4,'total_steps':5,'current_step':'S-005','content_state':'DRAFT','review_candidates':6,'native_outputs_preserved':11,'native_sources_and_references_hashes':'PASS','runtime_prior_accepted_sources_and_plan071_return':'UNCHANGED_HASH_VERIFIED','links_contract_and_state':'PASS','gallery_preview_count':12,'reading_sheet':[1000,1440],'browser_render_verification':qa['browser_render_verification'],'local_commit_of_previous_lots':commit,'committed_original_png_blobs_verified':13,'git_index':'EMPTY','new_lot_committed':False,'push':False,'runtime_admission':False,'canonical_promotion':False,'human_visual_acceptance':'PENDING','unrelated_dirty_changes':'PRESERVED'}
(OUT/'delivery-verification.json').write_text(json.dumps(verification,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'status':verification['status'],'previous_commit':commit[:7],'committed_native_blobs_verified':13,'new_candidates':6,'preserved_natives':11,'steps':'4/5','pending':'S-005 owner visual acceptance','index':'EMPTY'}))
