from pathlib import Path
import json,hashlib
from PIL import Image
import numpy as np
out=Path(__file__).resolve().parent
root=out.parents[2]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
receipt=json.loads((out/'authorization.json').read_text(encoding='utf-8'))
for e in receipt['sources']:assert sha(root/e['path'])==e['sha256']
rows=[]
for family,name in enumerate(['orbe_radiante_voo','orbe_radiante_impacto']):
    a=np.array(Image.open(out/(name+'.png')))
    assert a.shape==(256,1024,4) and (a[:,:,:3]==255).all()
    for i in range(4):
        alpha=a[:,i*256:(i+1)*256,3]
        assert max(alpha[0].max(),alpha[-1].max(),alpha[:,0].max(),alpha[:,-1].max())==0
        yy,xx=np.where(alpha>12)
        rows.append({'code':receipt['sources'][family*4+i]['code'],'visible_gt12':int((alpha>12).sum()),'bbox_gt12':[int(xx.min()),int(yy.min()),int(xx.max()+1),int(yy.max()+1)],'peak_alpha':int(alpha.max())})
    if family==0:flight=a[:,:256,3]
    else:impact=a[:,256:512,3]
def radius(alpha,threshold):
    yy,xx=np.indices(alpha.shape)
    rings=np.rint(np.hypot(xx+0.5-128,yy+0.5-128)).astype(int)
    radii=[r for r in range(1,100) if np.median(alpha[rings==r])/255>=threshold]
    return max(radii)
flight_radius=radius(flight,0.8)
impact_radius=radius(impact,0.5)
result={'status':'PASS','rows':rows,'pivot':[128,128],'flight_core_radius':flight_radius,'impact_peak_radius':impact_radius,'flight_scale':5/flight_radius,'impact_scale':12/impact_radius,'radius_method':'Centered radial median; P01 >=0.8 for bright core, P06 >=0.5 for main luminous body, excludes narrow rays/tail. Same scale across each four frames. Exact visual pivot not inferred from photometric centroid.','native_sources_unchanged':True,'p08_residue_preserved':rows[7]['visible_gt12']>0,'atlases':{name:sha(out/(name+'.png')) for name in ['orbe_radiante_voo','orbe_radiante_impacto']}}
assert result['p08_residue_preserved']
(out/'derivative-audit.json').write_text(json.dumps(result,indent=2)+'\n',encoding='utf-8')
print(json.dumps(result))
