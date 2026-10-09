from pathlib import Path
import json
from PIL import Image
root=Path.cwd();out=Path(__file__).parent;d=json.loads((out/'nm-generation-jobs-2026-10-09.json').read_text(encoding='utf-8'));g=json.loads((out/'n03-owner-gate-2026-10-09.json').read_text(encoding='utf-8'))
def proxy(path):
 im=Image.open(path).convert('L');w,h=im.size;radial=[0]*(w//2)
 for k,v in enumerate(im.get_flattened_data()):
  if v<=80:continue
  radius=int(((k%w-w/2)**2+(k//w-h/2)**2)**.5)
  if 5<=radius<len(radial):radial[radius]+=(v-80)**2
 return max(range(8,len(radial)-3),key=lambda r:sum(radial[r-3:r+4]))
peak=proxy(root/g['candidate']);rows=[]
for j in d['jobs']:
 if j['code'] not in ['N01','N02','N04'] or j['status']!='GENERATED_VISUALLY_INSPECTED':continue
 radius=proxy(root/j['destination']);rows.append(dict(code=j['code'],version=j['version'],bright_ring_radius_proxy_px=radius,ratio_to_approved_peak=radius/peak))
a=dict(method='Dominant bright annulus around exact canvas center, weights max(lum-80,0)^2 and7px radial window; photometric proxy, not exact geometric radius',peak_radius_proxy_px=peak,rows=rows);(out/'pulse-phase-radius-audit-2026-10-09.json').write_text(json.dumps(a,ensure_ascii=False,indent=2)+'\n',encoding='utf-8');print(json.dumps(a))
