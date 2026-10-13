"""Bind approved source hashes and pose/ground landmarks before raster preparation."""
from pathlib import Path
import hashlib
import json
import re
import subprocess
import numpy as np
from PIL import Image

OUT=Path(__file__).resolve().parent
ROOT=OUT.parents[2]
def sha(path):return hashlib.sha256(path.read_bytes()).hexdigest()
def save(name,value):(OUT/name).write_text(json.dumps(value,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
assert not (OUT/'manifest.json').exists()
reply='Aprovo a preparação das quatro ações em 512×512'
original=ROOT/'.atena/generated/hero-normalization-2026-10-10'
body=ROOT/'.atena/generated/hero-body-pivot-2026-10-12'
m=json.loads((body/'manifest.json').read_text(encoding='utf-8'))
n=json.loads((ROOT/'.atena/generated/hero-mask-feasibility-2026-10-12/native-extractions.json').read_text(encoding='utf-8'))
receipt=json.loads((body/'visual-acceptance.json').read_text(encoding='utf-8'))
assert len(receipt['entries'])==8
for entry in receipt['entries']:assert sha(ROOT/entry['path'])==entry['sha256']
body_source=next(r for r in m['records'] if r['code']=='AO08')
records=[{'code':'AO08','hero':'arlindo','action':'attack','source':body_source['source'],'source_sha256':body_source['source_sha256'],'requested_scale':body_source['requested_scale'],'scale_basis':'Original approved body target 290 divided by median native hat-to-sole height; constant across cycle','reference_body_height':290,'frames':[{'frame':f['frame'],'path':f['path'],'sha256':f['sha256'],'head_y':f['head_y'],'ground_y':f['feet_y'],'hip_x':f['waist_x'],'significant_bbox':f['significant_bbox'],'pose':'standing_cast'} for f in body_source['frames']]}]
heads={'ER08':[268,354,258,341],'ER09':[187,205,216,227,208,212]}
hips={'ER08':[230,304,214,324],'ER09':[176,182,200,213,194,184],'ER10':[184,196,227,213,183,190]}
ground={'ER08':[705,706,693,705],'ER09':[614,594,600,612,610,608],'ER10':[623,627,607,627,626,630]}
death_heads=[162,238,310,354,478,501]
for code in ['ER08','ER09','ER10']:
    source=next(r for r in n['records'] if r['code']==code)
    assert sha(ROOT/source['source'])==source['source_sha256']
    frames=[]
    for index,f in enumerate(source['frames']):
        path=ROOT/'.atena/generated/hero-mask-feasibility-2026-10-12'/f['path'];assert sha(path)==f['sha256']
        a=np.array(Image.open(path).convert('RGBA'))[:,:,3];ys,xs=np.where(a>8)
        if code=='ER10':head_y=death_heads[index];roi=None
        else:
            center=heads[code][index];roi=[center-35,0,center+35,420]
            yy,_=np.where(a[:420,center-35:center+35]>32);head_y=int(yy.min())
        frames.append({'frame':index+1,'path':path.relative_to(ROOT).as_posix(),'sha256':sha(path),'head_y':head_y,'head_roi':roi,'hip_x':hips[code][index],'ground_y':ground[code][index],'significant_bbox':[int(xs.min()),int(ys.min()),int(xs.max()+1),int(ys.max()+1)],'pose':('first_leaned_reference' if index==0 else 'kneeling_or_falling' if index<4 else 'lying_contact') if code=='ER10' else 'standing_or_lunging' if code=='ER08' else 'standing_or_crouching','landmark_uncertainty_source_px':5})
    # A death pose is already leaned/bent; do not force it to standing height.
    target=285 if code=='ER10' else 300
    requested=target/(frames[0]['ground_y']-frames[0]['head_y'])
    records.append({'code':code,'hero':'erik','action':{'ER08':'attack','ER09':'active','ER10':'death'}[code],'source':source['source'],'source_sha256':source['source_sha256'],'requested_scale':requested,'reference_body_height':target,'scale_basis':'First upright pose mapped to 300 px' if code!='ER10' else 'First slightly leaned death pose provisionally 285 px (95% standing reference); compare silhouette/head with accepted idle, not a per-frame height target','frames':frames})
for record in records:
    limits=[]
    for f in record['frames']:
        x0,y0,x1,y1=f['significant_bbox'];hip=f['hip_x'];floor=f['ground_y']
        limits.extend([246/max(.001,hip-x0),246/max(.001,x1-hip),438/max(.001,floor-y0)])
        if y1>floor:limits.append(54/(y1-floor))
    record['fit_limit']=min(limits);record['fit_conflict']=record['requested_scale']>record['fit_limit']
    record['cell']=[512,512];record['center_x']=256;record['ground_y']=448;record['guard_px']=10
    ref_code='AO02' if record['hero']=='arlindo' else 'ER02'
    ref=next(e for e in receipt['entries'] if e['code']==ref_code)
    record['idle_reference']={'path':ref['path'],'sha256':ref['sha256'],'cell':[256,384],'source_ground_y':368,'target_body_height':290 if record['hero']=='arlindo' else 300}
assert sum(len(r['frames']) for r in records)==20
protected={}
for folder in ['assets','core','ui','data','tests','scenes']:
    for p in (ROOT/folder).rglob('*'):
        if p.is_file():protected[p.relative_to(ROOT).as_posix()]=sha(p)
for package in [original,body,ROOT/'.atena/generated/hero-mask-feasibility-2026-10-12']:
    for p in package.rglob('*.png'):protected[p.relative_to(ROOT).as_posix()]=sha(p)
for p in [body/'visual-acceptance.json',body/'manifest.json',ROOT/'.atena/generated/hero-mask-feasibility-2026-10-12/native-extractions.json']:
    protected[p.relative_to(ROOT).as_posix()]=sha(p)
statepath=ROOT/'.atena/state/plan.yaml';before=statepath.read_text(encoding='utf-8')
protected['.atena/state/plan.yaml#prior_tail']=hashlib.sha256(before.split('hero_mask_feasibility_2026_10_12:',1)[1].encode()).hexdigest()
manifest={'plan':'PLAN-053','revision':'DEV-024/hero-wide-actions-v01','owner_reply':reply,'approval_mode':'per-plan','approval_status':'APPROVED_EXPLICITLY','content_state':'DRAFT','runtime_admission':False,'canonical_promotion':False,'commit_push_export':False,'status':'APPROVED_LANDMARKS_RECORDED','current_step_position':2,'completed_steps':1,'total_steps':5,'checkpoint':'S-002/PREPARE_20','records':records,'head_before':subprocess.check_output(['git','rev-parse','HEAD'],cwd=ROOT).decode().strip(),'method':'Godot deterministic proportional Lanczos; one scale per cycle; crop alpha extent; clear only derivative alpha<=8; explicit body/ground references','landmark_review':'All twenty native poses inspected; first death height 285 provisional compared with idle, crouch/fall compression is preserved, no claim of human acceptance'}
save('manifest.json',manifest);save('protected-snapshot.json',protected)
for p in [statepath,ROOT/'.atena/state/hero-wide-actions.yaml']:
    text=p.read_text(encoding='utf-8')
    if p==statepath:prefix,tail=text.split('hero_mask_feasibility_2026_10_12:',1)
    else:prefix,tail=text,''
    prefix=prefix.replace('status: PROPOSED_AWAITING_SCOPE_APPROVAL','status: IN_PROGRESS').replace('approval_status: PENDING','approval_status: APPROVED_EXPLICITLY').replace('checkpoint: G0/WIDE-CANVAS-SCOPE','checkpoint: S-002/PREPARE_20').replace('current_step_position: 1','current_step_position: 2').replace('completed_steps: 0','completed_steps: 1').replace('remaining_steps_after_current: 4','remaining_steps_after_current: 3').replace('next_execution_authorized: false','next_execution_authorized: true')
    prefix+='  owner_reply: "'+reply+'"\n  manifest: .atena/generated/hero-wide-actions-2026-10-12/manifest.json\n'
    p.write_text(prefix+('hero_mask_feasibility_2026_10_12:'+tail if p==statepath else ''),encoding='utf-8')
specpath=ROOT/'.atena/specs/SPEC-121-retomada-fila-imagens/hero-wide-actions-v01.md'
spec=specpath.read_text(encoding='utf-8').replace('v01 PROPOSTA DRAFT','v01 DRAFT APROVADA').replace('escopo **pendente de aprovação**','escopo **aprovado explicitamente**')
spec+='\nAutorização de 2026-10-12: **“'+reply+'”**. S-001 1/5 concluído; marco de morte inicial 285 px é uma calibração provisória da pose já inclinada, comparada ao idle; não altera cânone nem força alturas dos quadros da queda. Referências/marcadores e hashes registrados antes dos derivados.\n'
specpath.write_text(spec,encoding='utf-8')
print('S-001 complete 1/5: twenty frame hashes, prior accepted idles and source/ground references recorded.')
print('Fit conflicts:',[r['code'] for r in records if r['fit_conflict']])
