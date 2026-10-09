from pathlib import Path
import json,copy
out=Path(__file__).parent;root=out.parents[3];p=out/'mh-generation-jobs-2026-10-09.json';d=json.loads(p.read_text(encoding='utf-8'));j=next(x for x in d['jobs'] if x['code']=='M01');assert j['status']=='REJECTED_VISUAL' and j['version']=='v01'
j['rejection_reason']='Initial ring too large compared with target about10%of M03 peak radius; centered quiet identity otherwise retained.'
d.setdefault('rejected_native_versions',[]).append(copy.deepcopy(j));target=str(root/j['destination']);base=j['prompt']
for k in list(j):
 if k not in ['code','effect','name','prompt','referenced_image_paths','transparent_background','source_queue']:del j[k]
j.update(version='v02',status='PENDING',destination='.atena/generated/art-candidates/vfx/ampulheta_silencio/ampulheta_silencio_spark_v02.png')
j['referenced_image_paths'].append(target)
j['prompt']=base+'\n\nEDIT TARGET is Reference3, rejected M01 v01 ONLY. Preserve exact black square canvas, exact center point and tiny quiet circular/hourglass identity, but SHRINK the ENTIRE LIGHT MARK to60%of Reference3 current diameter around the unchanged pivot. The actual ring diameter should be about100pixels on1254canvas, total grains/motifs extent at most120pixels. Reference1 is approved PEAK for identity only; do not enlarge to it. Extremely small bright central dot, tiny thin ring, empty black everywhere else. Do not move center or add new rays.'
assert not (root/j['destination']).exists();p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8');print('M01 v02 prepared; v01 preserved')
