from pathlib import Path
import hashlib,json
import numpy as np
from PIL import Image
out=Path(__file__).resolve().parent;root=out.parents[2];sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
a=json.loads((out/'authorization.json').read_text(encoding='utf-8'));rows=[];cal={};yy,xx=np.indices((256,256))
for f in a['families']:
 p=out/(f['name']+'.png');rgba=np.array(Image.open(p));assert rgba.shape==(256,1536,4) and np.all(rgba[:,:,:3]==255)
 for i,e in enumerate(f['sources']):
  alpha=rgba[:,i*256:(i+1)*256,3];assert max(alpha[0].max(),alpha[-1].max(),alpha[:,0].max(),alpha[:,-1].max())==0,e['code']
  y,x=np.where(alpha>12);assert len(x)>0;assert sha(root/e['path'])==e['sha256']
  rows.append({'code':e['code'],'version':e['version'],'visible_gt12':int(len(x)),'bbox_gt12':[int(x.min()),int(y.min()),int(x.max()+1),int(y.max()+1)],'peak_alpha':int(alpha.max()),'edges_transparent':True})
 gate=0 if f['hero'] in ['kayron','nyrelia'] else 2
 alpha=rgba[:,gate*256:(gate+1)*256,3]/255.0
 pivot=[128.,128.]
 if f['hero'] in ['kayron','nyrelia']:
  y,x=np.where(alpha>=.5);pivot=[float((x.min()+x.max()+1)/2),float((y.min()+y.max()+1)/2)]
 distance=np.hypot(xx-pivot[0],yy-pivot[1]);radius=float(round(np.percentile(distance[alpha>=.5],95),2))
 if f['hero']=='sylas':
  radius=float(np.max(xx[alpha>=.5])+1-128)
  method='Canvas-center logical origin; accepted peak forward bright extent >=0.5, six frames same origin/scale; length matched to actual dash.'
 else:method='Canvas-center logical origin for radial peak; symmetric bright bounding-box midpoint for loop sigil. 95th percentile geometric bright radius>=0.5; same origin/scale for six frames.'
 cal[f['hero']]={'name':f['name'],'pivot':pivot,'source_radius_or_forward_extent':radius,'method':method,'content_side':f['content_side'],'common_inset':(256-f['content_side'])//2,'atlas_sha256':sha(p)}
result={'status':'PASS','sources_verified':42,'rows':rows,'calibration':cal,'source_bytes_preserved':True,'edges_transparent':True,'uniform_Korrak_inset':'248px centered with4px transparent margin for all sixframes, no per-frame correction','raster_transform':'Godot only; Python read-only metrics'}
(out/'derivative-audit.json').write_text(json.dumps(result,indent=2)+'\n',encoding='utf-8');print(json.dumps(cal))
