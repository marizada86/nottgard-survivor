"""Copy native image bytes unchanged, read-only alpha audit, persist exact provenance."""
from pathlib import Path
import hashlib
import json
import re
import shutil
import sys
from datetime import datetime, timezone
import numpy as np
from PIL import Image

OUT = Path(__file__).resolve().parent
ROOT = OUT.parents[2]
assert not (OUT/'visual-acceptance.json').exists(), 'Closed owner-approved lot; a revision requires a new authorized checkpoint.'
code, original = sys.argv[1:3]
data = json.loads((OUT/'jobs.json').read_text(encoding='utf-8'))
assert data['approval'] == 'APPROVED_PER_PLAN'
job = next(j for j in data['jobs'] if j['code'] == code)
if len(sys.argv) > 3:
    revision = sys.argv[3]
    assert revision in ['v02','v03'] and int(revision[1:]) == int(job['revision'][1:])+1
    previous = json.loads(json.dumps(job))
    previous['status'] = 'PRESERVED_NOT_SELECTED_CORRECTION'
    data.setdefault('previous_native_versions',[]).append(previous)
    job['revision'] = revision
    job['destination'] = job['destination'].replace('_'+previous['revision']+'.png','_'+revision+'.png')
    job['prompt'] = (OUT/('correction-'+code+'-'+revision+'.txt')).read_text(encoding='utf-8').strip()
    job['references'] = [previous['destination']]
    job['correction_of'] = previous['sha256']
source = Path(original)
destination = ROOT/job['destination']
assert not destination.exists(), 'Never overwrite native versions'
shutil.copyfile(source,destination)
def sha(p):
    return hashlib.sha256(p.read_bytes()).hexdigest()
assert sha(source) == sha(destination)
with Image.open(destination) as image:
    mode, size = image.mode, image.size
    rgba = np.array(image.convert('RGBA'))
alpha = rgba[:,:,3]
ys,xs = np.where(alpha > 8)
assert len(xs)
bbox = [int(xs.min()),int(ys.min()),int(xs.max())+1,int(ys.max())+1]
margins = [bbox[0],bbox[1],size[0]-bbox[2],size[1]-bbox[3]]
edge = np.concatenate([alpha[0],alpha[-1],alpha[:,0],alpha[:,-1]])
inspection = {'dimensions':list(size),'mode':mode,'bbox_alpha_above8':bbox,'margins_px':margins,'minimum_margin_percent':round(100*min(margins)/max(size),2),'border_max_alpha':int(edge.max()),'border_exactly_empty':int(edge.max()) == 0,'alpha_genuine':mode == 'RGBA' and float(np.mean(alpha == 0)) > .1,'transparent_fraction':float(np.mean(alpha == 0)),'no_visible_border_clipping_alpha_above8':int(edge.max()) <= 8,'margin_10_percent_met':all(margins[i] >= .1*size[i%2] for i in range(4)),'native_copy_hash':True}
job.update({'status':'GENERATED_PENDING_VISUAL_AUDIT','original_path':str(source),'sha256':sha(destination),'tool':'built-in image_gen','generated_at_utc':datetime.now(timezone.utc).isoformat(),'inspection':inspection})
data['generated'] = sum('sha256' in j for j in data['jobs'])
(OUT/'jobs.json').write_text(json.dumps(data,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
(OUT/'prompts.md').write_text('# ART-032 pontos — prompts efetivos DRAFT\n\n'+'\n\n'.join('## '+j['code']+' '+j['title']+' '+j['revision']+'\n\n```text\n'+j['prompt']+'\n```' for j in data['jobs'])+'\n\n## Histórico\n\n'+'\n\n'.join(j['code']+' '+j['revision']+'\n\n```text\n'+j['prompt']+'\n```' for j in data.get('previous_native_versions',[]))+'\n',encoding='utf-8')
statepath = ROOT/'.atena/state/art032-pontos.yaml'
state = statepath.read_text(encoding='utf-8')
state = re.sub(r'^generated: \d+$','generated: '+str(data['generated']),state,flags=re.M)
statepath.write_text(state,encoding='utf-8')
rootpath = ROOT/'.atena/state/plan.yaml'
prefix, tail = rootpath.read_text(encoding='utf-8').split('art032_npcs_lote02_2026_10_11:',1)
prefix = re.sub(r'^  generated: \d+$','  generated: '+str(data['generated']),prefix,flags=re.M)
rootpath.write_text(prefix+'art032_npcs_lote02_2026_10_11:'+tail,encoding='utf-8')
print(json.dumps({'code':code,'revision':job['revision'],'saved':job['destination'],'sha256':job['sha256'],'inspection':inspection},ensure_ascii=False))
