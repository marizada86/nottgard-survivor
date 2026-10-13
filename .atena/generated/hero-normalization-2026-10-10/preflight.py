from pathlib import Path
from PIL import Image
import json, hashlib
base=Path(__file__).parent
manifest=json.loads((base/'manifest.json').read_text(encoding='utf-8'))
reports=[]
for r in manifest['records']:
    if r['status']!='PREPARATION_READY': continue
    source=base/r['local_source']; assert hashlib.sha256(source.read_bytes()).hexdigest()==r['source_sha256']
    im=Image.open(source).convert('RGBA'); frames=[]
    for i in range(r['expected_frames']):
        f=Image.open(base/r['frames'][i]['path']).convert('RGBA') if r['frames'] else im.crop((im.width*i//r['expected_frames'],0,im.width*(i+1)//r['expected_frames'],im.height))
        # Read-only geometry; no crop or resized image is saved.
        a=f.getchannel('A').point(lambda v:255 if v>8 else 0); box=a.getbbox()
        assert box is not None, r['code']+' empty frame'
        w,h=box[2]-box[0],box[3]-box[1]
        frames.append(dict(frame=i+1,bbox=box,width=w,height=h,edge=min(box[0],box[1],f.width-box[2],f.height-box[3])<=1,maximum_fit_scale=min(236/w,348/h)))
    reports.append(dict(code=r['code'],frames=frames,extraction_review_needed=not bool(r['frames']),edge_frames=[f['frame'] for f in frames if f['edge']],shared_fit_scale_upper_bound=min(f['maximum_fit_scale'] for f in frames),body_landmarks='PENDING_NOT_INFERRED_FROM_EFFECT_BOUNDS',feet_anchor='PENDING',artistic_review='PENDING',runtime_admission=False))
summary=dict(strips_checked=len(reports),prior_extractions_available=sum(not r['extraction_review_needed'] for r in reports),extraction_review_needed=[r['code'] for r in reports if r['extraction_review_needed']],reports=reports,source_hashes_passed=True,no_raster_output=True,geometry_only=True,next='Review extraction and body/feet landmarks before applying common scale; alpha extent includes magic effects and cannot establish body height.')
(base/'preflight.json').write_text(json.dumps(summary,indent=2)+'\n',encoding='utf-8')
print(json.dumps({k:v for k,v in summary.items() if k!='reports'}))
