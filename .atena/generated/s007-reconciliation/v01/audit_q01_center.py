from pathlib import Path
import json
from PIL import Image
root=Path(__file__).resolve().parents[4];out=Path(__file__).parent
d=json.loads((out/'pq-generation-jobs-2026-10-09.json').read_text(encoding='utf-8'))
selected=next(x for x in d['jobs'] if x['code']=='Q01')
rows=[]
for j in d.get('rejected_native_versions',[])+[selected]:
 p=root/j['destination']
 if not p.is_file():continue
 im=Image.open(p).convert('L');w,h=im.size;numx=numy=den=0
 # Hot core centroid is a position proxy; visual review of circular ring remains required.
 for y in range(int(h*.3),int(h*.7)):
  for x in range(int(w*.3),int(w*.7)):
   weight=max(im.getpixel((x,y))-210,0)**2
   numx+=x*weight;numy+=y*weight;den+=weight
 assert den
 center=[numx/den/w,numy/den/h]
 rows.append(dict(version=j['version'],path=j['destination'],core_hotlight_centroid_proxy_normalized=center,offset_from_canvas_center_normalized=[center[0]-.5,center[1]-.5],note='Technical hotlight proxy, not exact geometric pivot; native pixels unchanged.'))
p=out/'q01-centering-audit-2026-10-09.json';p.write_text(json.dumps(dict(rows=rows,native_sources_unchanged=True),indent=2)+'\n',encoding='utf-8')
print(json.dumps(rows))
