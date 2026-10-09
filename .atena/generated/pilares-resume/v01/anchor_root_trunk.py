from pathlib import Path
from PIL import Image
import json,re,statistics
root=Path(__file__).resolve().parents[4];out=Path(__file__).parent;base=root/'.atena/generated/art-candidates/enemies-pilares/sintese_abissal'
packing=json.loads((base/'strips/packing.json').read_text());selection=json.loads((base/'frame-selection.json').read_text());rows=[]
for state,items in packing['sources'].items():
 if state=='death':continue
 for i,item in enumerate(items):
  im=Image.open(root/item['path'].removeprefix('res://')).convert('RGBA');a=im.getchannel('A');box=a.point(lambda v:255 if v>=230 else 0).getbbox();h=box[3]-box[1]
  pixels=im.load();xs=[]
  for y in range(box[1]+int(h*.63),box[1]+int(h*.82)):
   for x in range(box[0],box[2]):
    r,g,b,alpha=pixels[x,y]
    if alpha>=230 and r>=120 and g>=.80*r and b>=.70*r:xs.append(x)
  assert len(xs)>50,(state,i)
  proposed=statistics.median(xs); old=float(re.findall(r'-?\d+(?:\.\d+)?',item['anchor'])[0])
  key=f'{state}_{i:02}';selection.setdefault(key,{})['anchor_x_offset']=round(proposed-old,3)
  selection[key]['anchor_x_reason']='Median of opaque ivory root/bone in lower trunk, excluding extended foremost root tip. Technical anchoring only; native RGBA unchanged.'
  rows.append(dict(state=state,index=i,source=item['path'],prior_anchor_x=old,root_trunk_anchor_x=proposed,offset=round(proposed-old,3)))
(base/'frame-selection.json').write_text(json.dumps(selection,indent=2)+'\n')
(out/'root-trunk-anchoring-review.json').write_text(json.dumps(rows,indent=2)+'\n')
print(json.dumps(rows,indent=2))

