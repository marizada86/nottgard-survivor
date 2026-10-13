"""Read source geometry; record body landmarks and a deterministic Godot job."""
from pathlib import Path
import hashlib
import json
import statistics
import subprocess
from PIL import Image
import numpy as np

OUT=Path(__file__).resolve().parent
ROOT=OUT.parents[2]
SOURCE=ROOT/'.atena/generated/hero-normalization-2026-10-10'
def sha(path):return hashlib.sha256(path.read_bytes()).hexdigest()
def save(name,value):(OUT/name).write_text(json.dumps(value,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
assert not (OUT/'manifest.json').exists()
m=json.loads((SOURCE/'manifest.json').read_text(encoding='utf-8'))
r=json.loads((SOURCE/'extraction-review-v01.json').read_text(encoding='utf-8'))
prior={'AO03','AO04','AO07','ER04','ER05'}
safe={'AO02','AO05','AO06','AO08','ER02','ER07'}
head_overrides={'ER04':[137,139,140,148,140,142], 'ER05':[60,60,64,63,65,65], 'ER07':[110,112,112,112,111,112]}
protected={}
for folder in ['assets','core','ui','data','tests','scenes']:
    for p in (ROOT/folder).rglob('*'):
        if p.is_file():protected[p.relative_to(ROOT).as_posix()]=sha(p)
for p in SOURCE.rglob('*.png'):protected[p.relative_to(ROOT).as_posix()]=sha(p)
before=(ROOT/'.atena/state/plan.yaml').read_text(encoding='utf-8')
protected['.atena/state/plan.yaml#prior_tail']=hashlib.sha256(before.encode()).hexdigest()
records=[]
for s in m['records']:
    source=SOURCE/s['local_source'];assert sha(source)==s['source_sha256']
    if s['code'] in prior:inputs=s['frames']
    elif s['code'] in safe:inputs=next(x for x in r['records'] if x['code']==s['code'])['frames']
    else:continue
    frames=[]
    for n,f in enumerate(inputs):
        path=SOURCE/f['path'];assert sha(path)==f['sha256']
        pixels=np.array(Image.open(path).convert('RGBA'));alpha=pixels[:,:,3]
        yy,xx=np.where(alpha>8);box=[int(xx.min()),int(yy.min()),int(xx.max()+1),int(yy.max()+1)]
        head=head_overrides.get(s['code'],[box[1]]*len(inputs))[n]
        feet=box[3]
        waist=head+(feet-head)*.55
        y0=max(0,round(waist-(feet-head)*.025));y1=min(alpha.shape[0],round(waist+(feet-head)*.025))
        band=alpha[y0:y1,:].astype(float);weights=np.where(band>128,band,0).sum(axis=0)
        anchor=float((weights*np.arange(alpha.shape[1])).sum()/weights.sum())
        frames.append({'frame':n+1,'path':path.relative_to(ROOT).as_posix(),'sha256':sha(path),'size':[alpha.shape[1],alpha.shape[0]],'significant_bbox':box,'head_y':head,'feet_y':feet,'waist_x':round(anchor,3),'body_height':feet-head,'landmark_uncertainty_source_px':3,'source_edge_pixels_gt8':int((alpha[:,0]>8).sum()+(alpha[:,-1]>8).sum()+(alpha[0,:]>8).sum()+(alpha[-1,:]>8).sum()),'landmark_method':'visually reviewed head; lower visible sole; alpha-weighted waist centroid in anatomical row band, pending annotated board review'})
    target=290 if s['hero']=='arlindo' else 300
    proposed=target/statistics.median(f['body_height'] for f in frames)
    # Fit around the anatomical anchor, rather than around the effect bounding box.
    limits=[]
    for f in frames:
        x0,y0,x1,y1=f['significant_bbox'];cx=f['waist_x'];fy=f['feet_y']
        limits.extend([118/max(.001,cx-x0),118/max(.001,x1-cx),358/max(.001,fy-y0)])
    fit=min(limits);scale=min(proposed,fit)
    records.append({'code':s['code'],'hero':s['hero'],'source':source.relative_to(ROOT).as_posix(),'source_sha256':s['source_sha256'],'frames':frames,'cell':[256,384],'feet_y':368,'center_x':128,'guard_px':10,'target_body_height':target,'requested_scale':proposed,'fit_limit':fit,'scale':scale,'size_conflict':fit<proposed,'body_spread_estimated':(max(f['body_height'] for f in frames)-min(f['body_height'] for f in frames))*scale,'output':'strips/'+s['code']+'.png','content_state':'DRAFT','runtime_admission':False})
assert len(records)==11 and sum(len(s['frames']) for s in records)==60
manifest={'plan':'PLAN-053/SPEC-121/S-007','revision':'DEV-024/v03/body-pivot-v01','content_state':'DRAFT','approval_mode':'per-plan','authorization':'existing approved preparation route + atena, continuar a fila de assets','status':'LANDMARKS_RECORDED_PREPARATION_AUTHORIZED','completed_steps':1,'total_steps':4,'ordered_steps':['SOURCES_LANDMARKS','PREPARE','AUDIT','GALLERY_GATE'],'runtime_admission':False,'canonical_promotion':False,'commit_push_export':False,'source_count':20,'input_frames':60,'strips':11,'held_unprocessed':['ER03','ER06','AO09','AO10','ER08','ER09','ER10'],'method':'Godot proportional Lanczos, one scale per strip; alpha <=8 clear on derivative only; anatomical anchors; source bytes preserved','records':records,'git_head':subprocess.check_output(['git','rev-parse','HEAD'],cwd=ROOT).decode().strip()}
save('manifest.json',manifest);save('protected-snapshot.json',protected)
block='''hero_body_pivot_2026_10_12:
  plan: PLAN-053
  revision: DEV-024/v03/body-pivot-v01
  request_classification: IN_PLAN
  mode: per-plan
  status: IN_PROGRESS
  checkpoint: S-007/BODY-PIVOT/PREPARE
  current_step_position: 2
  completed_steps: 1
  total_steps: 4
  remaining_steps_after_current: 2
  ordered_steps: [SOURCES_LANDMARKS, PREPARE, AUDIT, GALLERY_GATE]
  content_state: DRAFT
  strips: 11
  input_frames: 60
  runtime_admission: false
  canonical_promotion: false
  commit_push_export: NOT_AUTHORIZED
  specification: .atena/specs/SPEC-121-retomada-fila-imagens/hero-body-pivot-v01.md
  manifest: .atena/generated/hero-body-pivot-2026-10-12/manifest.json
  next_objective: 'Preparar as onze candidatas em Godot e auditar os conflitos de escala'
'''
(ROOT/'.atena/state/plan.yaml').write_text('version: 2\n'+block+before[len('version: 2\n'):],encoding='utf-8')
(ROOT/'.atena/state/hero-body-pivot.yaml').write_text('version: 1\n'+block,encoding='utf-8')
print('Sources/landmarks 1/4: twenty sources and sixty extraction hashes verified; eleven strips; seven retained inputs unchanged.')
print('Size conflicts:',[s['code'] for s in records if s['size_conflict']])
