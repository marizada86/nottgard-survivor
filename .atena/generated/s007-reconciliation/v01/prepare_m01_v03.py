from pathlib import Path
import json,copy
out=Path(__file__).parent;root=out.parents[3];p=out/'mh-generation-jobs-2026-10-09.json';d=json.loads(p.read_text(encoding='utf-8'));j=next(x for x in d['jobs'] if x['code']=='M01');assert j['status']=='REJECTED_VISUAL' and j['version']=='v02'
j['rejection_reason']='Native reduction insufficient: ring still about14%of peak radius instead of about10%; preserve rejection and use final third version.'
d.setdefault('rejected_native_versions',[]).append(copy.deepcopy(j));base=j['prompt'].split('\n\nReference1')[0]
refs=j['referenced_image_paths'][:2]
for k in list(j):
 if k not in ['code','effect','name','prompt','referenced_image_paths','transparent_background','source_queue']:del j[k]
j.update(version='v03',status='PENDING',destination='.atena/generated/art-candidates/vfx/ampulheta_silencio/ampulheta_silencio_spark_v03.png',referenced_image_paths=refs)
j['prompt']=base+'\n\nReference1 is APPROVED M03 PEAK: retain only QUIET painted white-gray identity; Reference2 approved physical pilot STYLE ONLY. Create a NEW tiny SPARK phase, not a peak, not an edit of any previous spark. A tiny white point at exact center, with a minuscule fine circular halo DIAMETER70pixels on1254canvas, or5.6%of square width. The ENTIRE mark including grains must fit inside a90pixel diameter central region; outer99%of square is empty black. Ring radius about35pixels, not80pixels. Hourglasses only four barely detectable little hints on the micro ring. No full-sized circle, giant hourglass, bursting rays, central disk, scene, border or perspective. Keep bright pinpoint at exact imagecenter. Generate one square1024requested native frame.'
assert not (root/j['destination']).exists();p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8');print('M01 third final version prepared')
