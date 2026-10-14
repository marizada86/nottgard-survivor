from pathlib import Path
from collections import deque
import hashlib,json
import numpy as np
from PIL import Image
out=Path(__file__).resolve().parent
root=out.parents[2]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
receipt=json.loads((out/'authorization.json').read_text(encoding='utf-8'))
for e in receipt['sources']:assert sha(root/e['path'])==e['sha256']
rows=[];atlases=[]
for family,name in enumerate(['onda_cortante_voo','onda_cortante_impacto']):
    a=np.array(Image.open(out/(name+'.png')));assert a.shape==(256,1024,4) and (a[:,:,:3]==255).all();atlases.append(a)
    for i in range(4):
        alpha=a[:,i*256:(i+1)*256,3];assert max(alpha[0].max(),alpha[-1].max(),alpha[:,0].max(),alpha[:,-1].max())==0
        yy,xx=np.where(alpha>12)
        rows.append({'code':receipt['sources'][family*4+i]['code'],'version':receipt['sources'][family*4+i]['version'],'visible_gt12':int((alpha>12).sum()),'bbox_gt12':[int(xx.min()),int(yy.min()),int(xx.max()+1),int(yy.max()+1)],'peak_alpha':int(alpha.max())})
def main_component(alpha):
    mask=alpha>=204;seen=np.zeros_like(mask);best=[]
    for y,x in zip(*np.where(mask)):
        if seen[y,x]:continue
        q=deque([(int(y),int(x))]);seen[y,x]=True;component=[]
        while q:
            cy,cx=q.popleft();component.append((cy,cx))
            for dy in [-1,0,1]:
                for dx in [-1,0,1]:
                    ny,nx=cy+dy,cx+dx
                    if 0<=ny<256 and 0<=nx<256 and mask[ny,nx] and not seen[ny,nx]:seen[ny,nx]=True;q.append((ny,nx))
        if len(component)>len(best):best=component
    yy,xx=np.array(best).T
    return [int(xx.min()),int(yy.min()),int(xx.max()+1),int(yy.max()+1)]
boxes=[main_component(atlases[0][:,i*256:(i+1)*256,3]) for i in range(4)]
box=boxes[0];pivot=[(box[0]+box[2])/2,(box[1]+box[3])/2];height=box[3]-box[1]
alpha=atlases[1][:,256:512,3];yy,xx=np.indices(alpha.shape);rings=np.rint(np.hypot(xx+0.5-128,yy+0.5-128)).astype(int)
radius=max(r for r in range(1,100) if np.median(alpha[rings==r])/255>=0.5)
result={'status':'PASS','rows':rows,'flight':{'principal_bboxes':boxes,'pivot':pivot,'main_height':height,'scale':18/height,'screen_main_height':18,'method':'Largest 8-connected bright component >=0.8 of RGB-derived alpha; R01 bbox midpoint is geometric reference. Same pivot/scale in all four frames, narrow rays outside bright component not used to set size.'},'impact':{'pivot':[128,128],'main_radius':radius,'scale':12/radius,'screen_radius':12,'method':'Centered radial median >=0.5 in accepted R06, excludes thin decorative rays.'},'r08_residue_preserved':rows[-1]['visible_gt12']>0,'sources_unchanged':True,'atlas_sha256':{n:sha(out/(n+'.png')) for n in ['onda_cortante_voo','onda_cortante_impacto']}}
assert result['r08_residue_preserved']
(out/'derivative-audit.json').write_text(json.dumps(result,indent=2)+'\n',encoding='utf-8')
print(json.dumps(result))
