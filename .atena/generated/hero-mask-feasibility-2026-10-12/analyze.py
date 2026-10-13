"""Read-only assessment of transparent curved corridors between action poses."""
from pathlib import Path
import hashlib
import json
import numpy as np
from PIL import Image

OUT=Path(__file__).resolve().parent
ROOT=OUT.parents[2]
SOURCE=ROOT/'.atena/generated/hero-normalization-2026-10-10'
manifest=json.loads((SOURCE/'manifest.json').read_text(encoding='utf-8'))
anchors={'AO09':[178,485,788,1138,1525,1830],'AO10':[175,470,730,1100,1480,1860],'ER08':[240,750,1200,1840],'ER09':[182,520,820,1210,1530,1890],'ER10':[185,540,860,1180,1550,1990]}
records=[]
for code,centers in anchors.items():
    source=next(s for s in manifest['records'] if s['code']==code)
    path=SOURCE/source['local_source'];assert hashlib.sha256(path.read_bytes()).hexdigest()==source['source_sha256']
    alpha=np.array(Image.open(path).convert('RGBA'))[:,:,3]
    height,width=alpha.shape
    corridors=[]
    for n in range(len(centers)-1):
        midpoint=(centers[n]+centers[n+1])/2
        radius=min((centers[n+1]-centers[n])*.38,width/len(centers)*.38)
        start=max(2,round(midpoint-radius));stop=min(width-2,round(midpoint+radius))
        columns=np.arange(start,stop)
        # Require a three-pixel corridor; one diagonal empty pixel can split
        # eight-connected contours even when its own alpha is insignificant.
        maximum=np.maximum.reduce([alpha[:,start-1:stop-1],alpha[:,start:stop],alpha[:,start+1:stop+1]])
        significant=maximum>8
        cost=significant.astype(float)*1_000_000+(maximum.astype(float)/255)**2+.00001*((columns-midpoint)/max(1,radius))**2
        previous=cost[0].copy();back=np.zeros(cost.shape,dtype=np.int8)
        for y in range(1,height):
            candidates=np.vstack([np.r_[np.inf,previous[:-1]],previous,np.r_[previous[1:],np.inf]])
            choice=np.argmin(candidates,axis=0)
            previous=cost[y]+candidates[choice,np.arange(len(columns))]
            back[y]=choice.astype(np.int8)-1
        position=int(previous.argmin());trace=[0]*height
        for y in range(height-1,-1,-1):
            trace[y]=int(columns[position])
            if y:position+=int(back[y,position])
        crossings=int(sum(max(alpha[y,x-1:x+2])>8 for y,x in enumerate(trace)))
        opaque=int(sum(max(alpha[y,x-1:x+2])>128 for y,x in enumerate(trace)))
        corridors.append({'between':[n+1,n+2],'interval':[start,stop],'significant_rows_crossed':crossings,'opaque_rows_crossed':opaque,'clear_three_pixel_corridor':crossings==0,'trace_x_by_y':trace})
    order_ok=all(all(corridors[i]['trace_x_by_y'][y]<corridors[i+1]['trace_x_by_y'][y] for y in range(height)) for i in range(len(corridors)-1))
    safe=order_ok and all(c['clear_three_pixel_corridor'] for c in corridors)
    records.append({'code':code,'source':path.relative_to(ROOT).as_posix(),'source_sha256':source['source_sha256'],'size':[width,height],'observed_poses':len(centers),'pose_centers_visual_estimates':centers,'corridors':corridors,'ordered_non_intersecting':order_ok,'status':'NONRECTANGULAR_EXTRACTION_FEASIBLE_GEOMETRY_ONLY' if safe else 'HELD_AMBIGUOUS_CONNECTED_PIXELS_IN_SEARCH_INTERVAL','not_a_global_impossibility_proof':True,'artistic_acceptance':'PENDING','raster_modified':False,'runtime_admission':False})
report={'plan':'PLAN-053/DEV-024/v03','revision':'mask-feasibility-v01','authorization':'Existing route: assess masks for the five retained action strips','content_state':'DRAFT','status':'READ_ONLY_ANALYSIS_COMPLETE','inputs':5,'method':'dynamic programming transparent three-pixel curved corridor, alpha>8, ±1 column/row; visually estimated inter-pose bands','scope_limit':'No paint, no loss of significant pixels, no regeneration, no assumption that a corridor proves artistic identity/loop quality','feasible':[r['code'] for r in records if r['status'].startswith('NONRECTANGULAR')],'held':[r['code'] for r in records if r['status'].startswith('HELD')],'records':records}
(OUT/'analysis.json').write_text(json.dumps(report,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
print('Feasible curved separation geometry:',report['feasible'])
print('Retained ambiguities:',report['held'])
for r in records:print(r['code'],[(c['significant_rows_crossed'],c['opaque_rows_crossed']) for c in r['corridors']])
