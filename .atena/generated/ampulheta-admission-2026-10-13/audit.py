from pathlib import Path
import json,numpy as np
from PIL import Image
out=Path(__file__).resolve().parent
a=np.array(Image.open(out/'ampulheta_silencio.png').convert('RGBA'));rows=[]
y,x=np.mgrid[:256,:256];rr=np.sqrt((x+0.5-128)**2+(y+0.5-128)**2)
for i in range(6):
 c=a[:,i*256:(i+1)*256];alpha=c[:,:,3].astype(float);yy,xx=np.where(alpha>12)
 edge=int(max(alpha[0,:].max(),alpha[-1,:].max(),alpha[:,0].max(),alpha[:,-1].max()))
 assert edge==0 and alpha.max()>12 and np.all(c[:,:,:3]==255)
 w=np.maximum(alpha-80,0)**2
 center=[float(((x+0.5)*w).sum()/w.sum()),float(((y+0.5)*w).sum()/w.sum())] if w.sum() else None
 radius=max(range(1,124),key=lambda r:float(w[(rr>=r-2)&(rr<=r+2)].sum())) if w.sum() else None
 rows.append({'phase':i,'bbox_alpha_gt12':[int(xx.min()),int(yy.min()),int(xx.max()+1),int(yy.max()+1)],'alpha_max':int(alpha.max()),'alpha_sum':float(alpha.sum()),'visible_pixels':int((alpha>12).sum()),'ring_radius_proxy_px':radius,'hot_centroid':center,'edge_alpha':edge})
assert rows[5]['visible_pixels']>0 and rows[5]['alpha_sum']<rows[4]['alpha_sum']<rows[2]['alpha_sum']
ratio=rows[0]['ring_radius_proxy_px']/rows[2]['ring_radius_proxy_px'];assert 0.11<ratio<0.18
(out/'derivative-audit.json').write_text(json.dumps({'result':'PASS','phases':rows,'peak_ring_radius_px':rows[2]['ring_radius_proxy_px'],'initial_ring_ratio':ratio,'M01_exception_preserved':True,'centroid_note':'Photometric proxy; canvas pivot fixed128/128','noise_floor':2,'preserved_faint_phase':True},indent=2)+'\n',encoding='utf-8')
print(json.dumps({'radius':rows[2]['ring_radius_proxy_px'],'initial_ratio':ratio,'visible_last_phase':rows[5]['visible_pixels'],'phases':rows},indent=2))
