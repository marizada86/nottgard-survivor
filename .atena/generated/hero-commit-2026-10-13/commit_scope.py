"""Prepare a scoped index snapshot; --stage performs only authorized local Git writes."""
from pathlib import Path
import hashlib, json, re, subprocess, sys
import numpy as np
from PIL import Image
OUT=Path(__file__).resolve().parent
ROOT=OUT.parents[2]
def git(*args):return subprocess.check_output(['git',*args],cwd=ROOT)
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def save(p,obj):p.write_text(json.dumps(obj,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
assert not git('diff','--cached','--name-only').strip()
head=git('rev-parse','HEAD').decode().strip()
assert head=='e6aea39f16b43e18d2d4501e870645a97b6d4dfe'
inventory=json.loads((ROOT/'.atena/generated/hero-spread-review-2026-10-13/accepted-hero-inventory.json').read_text(encoding='utf-8'))
assert inventory['accepted_strips']==14 and inventory['accepted_frames']==76
for e in inventory['selected']:
    assert sha(ROOT/e['path'])==e['sha256'],e['code']
    receipt=json.loads((ROOT/e['receipt']).read_text(encoding='utf-8'))
    assert any(x['code']==e['code'] and x['sha256']==e['sha256'] for x in receipt['entries'])
    w,h=e['cell']; atlas=np.array(Image.open(ROOT/e['path']).convert('RGBA'))
    assert atlas.shape==(h,w*e['frames'],4)
    folder=(ROOT/'.atena/generated/hero-wide-actions-2026-10-12/frames'/e['code']) if w==512 else ROOT/'.atena/generated/hero-body-pivot-2026-10-12/v02/frames'/e['code']
    for n in range(e['frames']):assert np.array_equal(atlas[:,n*w:(n+1)*w],np.array(Image.open(folder/f'f{n+1:02d}.png').convert('RGBA')))
sources=ROOT/'.atena/generated/hero-normalization-2026-10-10'
m=json.loads((sources/'manifest.json').read_text(encoding='utf-8'))
for e in m['records']:assert sha(sources/e['local_source'])==e['source_sha256'],e['code']
folders=['.atena/generated/hero-body-pivot-2026-10-12','.atena/generated/hero-mask-feasibility-2026-10-12','.atena/generated/hero-wide-actions-2026-10-12','.atena/generated/hero-spread-review-2026-10-13','.atena/generated/hero-normalization-2026-10-10']
paths=git('ls-files','--others','--exclude-standard','--',*folders).decode().splitlines()
paths+=['.atena/generated/ART-PROMPTS-060-erik-e-arlindo-jogaveis.md','.atena/generated/CHATGPT-FILA-027-erik-e-arlindo.md','.atena/state/plan-053-imagens.yaml','.atena/backlog/ARTE.md']
for base in ['hero-extraction-review-2026-10-11','hero-body-pivot-2026-10-12','hero-mask-feasibility-2026-10-12','hero-wide-actions-2026-10-12','hero-spread-review-2026-10-13']:paths.append('.atena/evidence/'+base+'.md')
for name in ['hero-extraction-review-2026-10-11','hero-body-pivot','hero-mask-feasibility','hero-wide-actions','hero-spread-exception']:paths.append('.atena/state/'+name+'.yaml')
for name in ['hero-body-pivot-v01','hero-wide-actions-v01','hero-spread-exception-v01']:paths.append('.atena/specs/SPEC-121-retomada-fila-imagens/'+name+'.md')
paths+=['.atena/generated/hero-commit-2026-10-13/plan.md','.atena/generated/hero-commit-2026-10-13/commit_scope.py']
paths=sorted(set(paths))
assert all(p.startswith('.atena/') and (ROOT/p).is_file() for p in paths)
state=ROOT/'.atena/state/plan.yaml'
current=state.read_text(encoding='utf-8')
base=git('show','HEAD:.atena/state/plan.yaml').decode()
prefix=current.split('art032_publication_2026_10_12:',1)[0].split('\n',1)[1]
def block(text,key):return re.search(r'^'+key+r':\n.*?(?=^\S|\Z)',text,re.M|re.S).group()
base=base.replace(block(base,'image_queue_resume_2026_10_10'),block(current,'image_queue_resume_2026_10_10'))
commit_block='hero_local_commit_2026_10_13:\n  plan: PLAN-053\n  revision: HERO-COMMIT/v01\n  request_classification: IN_PLAN\n  mode: per-plan\n  status: VALIDATED_READY_TO_COMMIT\n  owner_reply: "commit e continue"\n  checkpoint: S-002/LOCAL_COMMIT_AUTHORIZED\n  ordered_steps: [S-001, S-002, S-003]\n  current_step_position: 2\n  completed_steps: 1\n  total_steps: 3\n  remaining_steps_after_current: 1\n  content_state: DRAFT\n  push_merge_export: NOT_AUTHORIZED\n  runtime_admission: false\n  canonical_promotion: false\n  specification: .atena/generated/hero-commit-2026-10-13/plan.md\n  next_objective: "Verificar commit e retornar à análise AO09/AO10"\n'
assert 'hero_local_commit_2026_10_13:' not in current
staged='version: 2\n'+commit_block+prefix+base.split('\n',1)[1]
(OUT/'staged-plan.yaml').write_text(staged,encoding='utf-8')
state.write_text('version: 2\n'+commit_block+current.split('\n',1)[1],encoding='utf-8')
plan={'status':'PREFLIGHT_PASS','owner_reply':'commit e continue','prior_head':head,'branch':git('branch','--show-current').decode().strip(),'accepted_strips':14,'accepted_frames':76,'sources_verified':len(m['records']),'paths':paths,'worktree_hashes':{p:sha(ROOT/p) for p in paths},'partial_state_path':'.atena/state/plan.yaml','partial_state_sha256':sha(OUT/'staged-plan.yaml'),'push_authorized':False,'runtime_admission':False}
save(OUT/'scope.json',plan)
print('Preflight PASS:',len(paths)+1,'scoped files;20 sources;14atlas/76cells; central state staged selectively; no runtime changes.')
if '--stage' in sys.argv:
    for p in paths:subprocess.run(['git','add','--',p],cwd=ROOT,check=True,stdout=subprocess.DEVNULL,stderr=subprocess.PIPE)
    blob=git('hash-object','-w','--path=.atena/state/plan.yaml',str(OUT/'staged-plan.yaml')).decode().strip()
    subprocess.run(['git','update-index','--add','--cacheinfo','100644',blob,'.atena/state/plan.yaml'],cwd=ROOT,check=True)
    actual=git('diff','--cached','--name-only').decode().splitlines()
    assert sorted(actual)==sorted(paths+['.atena/state/plan.yaml'])
    subprocess.run(['git','diff','--cached','--check'],cwd=ROOT,check=True)
    blobs={p:git('rev-parse',':'+p).decode().strip() for p in actual}
    save(OUT/'staging-verification.json',{'status':'PASS','blobs':blobs,'scope':plan,'excluded_local_changes':git('diff','--name-only').decode().splitlines()})
    print('Staging PASS: exact scope, blobs captured, whitespace check passed.')
