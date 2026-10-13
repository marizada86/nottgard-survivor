"""Verify the 17 prepared derivatives, then admit only the approved destinations."""
from pathlib import Path
import hashlib
import json
import shutil
import re
import numpy as np
from PIL import Image
OUT=Path(__file__).resolve().parent
ROOT=OUT.parents[2]
data=json.loads((OUT/'manifest.json').read_text(encoding='utf-8'))
prep=json.loads((OUT/'preparation.json').read_text(encoding='utf-8'))
assert data['approval']=='APPROVED_EXPLICITLY' and prep['count']==17
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
for e in data['entries']:
    assert sha(ROOT/e['path'])==e['sha256']
    path=ROOT/e['derived_path']
    with Image.open(path) as im:
        assert im.format=='PNG' and im.mode=='RGBA'
        rgba=np.array(im);w,h=im.size
    a=rgba[:,:,3];ys,xs=np.where(a>0)
    margins=[int(xs.min()),int(ys.min()),w-int(xs.max())-1,h-int(ys.max())-1]
    assert min(margins)>=e['padding'],e['code']
    assert set(np.unique(a)).isdisjoint(set(range(1,9)))
    assert h==e['target_visible_height']+8
    src_record=next(r for r in prep['records'] if r['code']==e['code'])
    sx,sy,sw,sh=src_record['source_crop']
    assert abs((w-8)/(h-8)-sw/sh)<=1/(h-8)
    e.update({'derived_sha256':sha(path),'derived_size':[w,h],'derived_margins_px':margins,'alpha_trace_cleanup':True,'source_bytes_unchanged':True})
for r in data['receipts']:assert sha(ROOT/r['path'])==r['sha256']
data['prepared']=17
(OUT/'preparation-audit.json').write_text(json.dumps({'status':'PASS','count':17,'engine':prep['engine'],'source_bytes':'UNCHANGED','derivative_alpha_padding_aspect':'PASS','entries':data['entries']},ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
for e in data['entries']:
    target=ROOT/e['destination']
    previous=data['snapshot'][e['destination']]
    assert target.exists()==previous['exists']
    if target.exists():assert sha(target)==previous['sha256']
    target.parent.mkdir(parents=True,exist_ok=True)
    shutil.copyfile(ROOT/e['derived_path'],target)
    assert sha(target)==e['derived_sha256']
    e['runtime_admission']=True
data.update({'admitted':17,'runtime_admission':True})
(OUT/'manifest.json').write_text(json.dumps(data,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
statepath=ROOT/'.atena/state/art032-implementation.yaml'
state=statepath.read_text(encoding='utf-8')
state=state.replace('prepared: 0','prepared: 17').replace('admitted: 0','admitted: 17').replace('runtime_admission: false','runtime_admission: true')
statepath.write_text(state,encoding='utf-8')
rootpath=ROOT/'.atena/state/plan.yaml'
prefix,tail=rootpath.read_text(encoding='utf-8').split('art032_next_request_2026_10_12:',1)
prefix=prefix.replace('prepared: 0','prepared: 17').replace('admitted: 0','admitted: 17').replace('runtime_admission: false','runtime_admission: true')
rootpath.write_text(prefix+'art032_next_request_2026_10_12:'+tail,encoding='utf-8')
print('Preparation audit PASS; 17 derivatives admitted byte-for-byte to bounded destinations. Originals and receipts unchanged.')
