from pathlib import Path
import hashlib,json
import numpy as np
from PIL import Image
out=Path(__file__).resolve().parent
root=out.parents[2]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
receipt=json.loads((out/'authorization.json').read_text(encoding='utf-8'))
for e in receipt['sources']:assert sha(root/e['path'])==e['sha256']
rows=[];images=[]
for family,name in enumerate(['orbe_arcano_voo','orbe_arcano_impacto']):
    a=np.array(Image.open(out/(name+'.png')));assert a.shape==(256,1024,4) and (a[:,:,:3]==255).all()
    images.append(a)
    for i in range(4):
        alpha=a[:,i*256:(i+1)*256,3];assert max(alpha[0].max(),alpha[-1].max(),alpha[:,0].max(),alpha[:,-1].max())==0
        yy,xx=np.where(alpha>12)
        rows.append({'code':receipt['sources'][family*4+i]['code'],'visible_gt12':int((alpha>12).sum()),'bbox_gt12':[int(xx.min()),int(yy.min()),int(xx.max()+1),int(yy.max()+1)],'peak_alpha':int(alpha.max())})
def ring_fit(alpha,xs,ys,rs):
    angles=np.arange(240)*np.pi*2/240
    c,s=np.cos(angles),np.sin(angles)
    def sample(cx,cy,r):
        x=np.rint(cx+c*r-0.5).astype(int);y=np.rint(cy+s*r-0.5).astype(int)
        return alpha[y,x].astype(float)
    best=None
    for cy in ys:
        for cx in xs:
            for r in rs:
                center=sample(cx,cy,r)
                contrast=float(center.mean()-0.5*(sample(cx,cy,r-2).mean()+sample(cx,cy,r+2).mean()))
                if best is None or contrast>best[0]:best=(contrast,float(cx),float(cy),float(r))
    return {'contrast_score':best[0],'pivot':[best[1],best[2]],'radius':best[3]}
flight=ring_fit(images[0][:,:256,3],np.arange(132,138,.5),np.arange(125,131,.5),np.arange(19,26,.5))
impact=ring_fit(images[1][:,256:512,3],np.arange(124,133,.5),np.arange(121,131,.5),np.arange(37,45,.5))
result={'status':'PASS','rows':rows,'calibration_method':'Search for luminous geometric annulus in Q01/Q06 using mean circle intensity contrast against radii +/-2px. Narrow ring rather than brightness centroid; inspect previews as well. Coordinates reference pixel centers. One constant pivot and scale per animation, never per frame.','flight':dict(flight,screen_ring_radius=5,scale=5/flight['radius']),'impact':dict(impact,screen_ring_radius=12,scale=12/impact['radius']),'native_sources_preserved':True,'q08_residue_preserved':rows[-1]['visible_gt12']>0,'atlas_sha256':{n:sha(out/(n+'.png')) for n in ['orbe_arcano_voo','orbe_arcano_impacto']}}
assert result['q08_residue_preserved']
result['flight']['visible_tail_extent_px']=(flight['pivot'][0]-rows[0]['bbox_gt12'][0])*result['flight']['scale']
(out/'derivative-audit.json').write_text(json.dumps(result,indent=2)+'\n',encoding='utf-8')
print(json.dumps(result))
