from pathlib import Path
from PIL import Image
import json,hashlib
root=Path(__file__).resolve().parents[4];out=Path(__file__).parent
actor='sucubo';base=root/'.atena/generated/art-candidates/enemies-shendilavri'/actor
selection=json.loads((base/'frame-selection.json').read_text())
rows=[]
for state,count in {'idle':4,'move':6,'attack':4,'death':6}.items():
 for i in range(count):
  v=selection.get(f'{state}_{i:02d}',{}).get('version',1)
  p=base/f'{actor}_{state}_{i:02d}_v{v:02d}.png'
  im=Image.open(p).convert('RGBA');a=im.getchannel('A');h=a.histogram();b=a.point(lambda x:255 if x>=11 else 0).getbbox()
  row=dict(state=state,index=i,version=v,path=p.relative_to(root).as_posix(),size=im.size,sha256=hashlib.sha256(p.read_bytes()).hexdigest(),bbox=b,solidity=sum(h[230:])/sum(h[11:]),clipped=b[0]==0 or b[1]==0 or b[2]==im.width or b[3]==im.height,native_alpha=True)
  rows.append(row)
(out/'sucubo-selected-source-audit.json').write_text(json.dumps(rows,indent=2)+'\n',encoding='utf-8')
assert all(r['solidity']>=.9 and not r['clipped'] for r in rows),[r for r in rows if r['clipped'] or r['solidity']<.9]
print('20 selected preview sources: native alpha, solidity >=0.90, no visible cuts. Owner walk decision remains pending.')
