from pathlib import Path
import hashlib,json
import numpy as np
from PIL import Image
out=Path(__file__).resolve().parent;root=out.parents[2]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
a=json.loads((out/'authorization.json').read_text(encoding='utf-8'))
rows=[];calibration={}
yy,xx=np.indices((256,256))
for family in a['families']:
 p=out/(family['name']+'.png');rgba=np.array(Image.open(p));assert rgba.shape==(256,1536,4)
 assert np.all(rgba[:,:,:3]==255)
 for i,e in enumerate(family['sources']):
  alpha=rgba[:,i*256:(i+1)*256,3]
  assert max(alpha[0].max(),alpha[-1].max(),alpha[:,0].max(),alpha[:,-1].max())==0,e['code']
  y,x=np.where(alpha>12);assert len(x)>0
  assert sha(root/e['path'])==e['sha256']
  rows.append({'code':e['code'],'version':e['version'],'visible_gt12':len(x),'bbox_gt12':[int(x.min()),int(y.min()),int(x.max()+1),int(y.max()+1)],'peak_alpha':int(alpha.max()),'edges_transparent':True})
 gate_index=next(i for i,e in enumerate(family['sources']) if e['code']==family['gate'])
 alpha=rgba[:,gate_index*256:(gate_index+1)*256,3]/255.0
 if family['name'].startswith('melee') or family['name'].startswith('durvall'):
  pivot=[128,128];distance=np.hypot(xx-128,yy-128)
  radius=float(round(np.percentile(distance[alpha>=.5],95),2))
  method='Canvas-center origin per accepted directional reference; 95th percentile radius of gate alpha>=0.5, excludes faint sparks; one pivot/scale for all six frames.'
 else:
  angles=np.arange(240)*np.pi*2/240;c,s=np.cos(angles),np.sin(angles)
  def sample(cx,cy,r):return alpha[np.rint(cy+s*r-.5).astype(int),np.rint(cx+c*r-.5).astype(int)]
  best=(-1,None,None,None)
  for cy in np.arange(118,137,1):
   for cx in np.arange(120,137,1):
    for r in np.arange(72,102,1):
     score=float(sample(cx,cy,r).mean()-.5*(sample(cx,cy,r-3).mean()+sample(cx,cy,r+3).mean()))
     if score>best[0]:best=(score,float(cx),float(cy),float(r))
  pivot=[best[1],best[2]];radius=best[3]
  method='Geometric annulus fit: mean circle intensity contrast against radius +/-3, 240 angular samples, centers near canvas center. Excludes cardinal star/spark bounding-box bias. Fixed pivot/radius for six frames.'
 calibration[family['name']]={'pivot':pivot,'main_radius':radius,'method':method,'atlas_sha256':sha(p)}
assert len(rows)==30
result={'status':'PASS','sources_unchanged':True,'atlases':5,'cells':30,'rows':rows,'calibration':calibration,'rgb':'white','edges_transparent':True,'raster_editing_tool':'Godot prepare.gd only; Python read-only audit'}
(out/'derivative-audit.json').write_text(json.dumps(result,indent=2)+'\n',encoding='utf-8')
print(json.dumps(calibration))
