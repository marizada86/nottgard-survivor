from pathlib import Path
from PIL import Image
import json,hashlib
root=Path(__file__).resolve().parents[3];base=Path(__file__).parent
reports=[]
for p in sorted((base/'receipts').glob('*.json')):
    job=json.loads(p.read_text(encoding='utf-8'));src=root/job['destination'];im=Image.open(src)
    assert hashlib.sha256(src.read_bytes()).hexdigest()==hashlib.sha256(Path(job['source']).read_bytes()).hexdigest()
    assert im.mode=='RGBA',job['code']+' missing native alpha'
    a=im.getchannel('A');box=a.point(lambda x:255 if x>8 else 0).getbbox();assert box
    margin=min(box[0]/im.width,box[1]/im.height,(im.width-box[2])/im.width,(im.height-box[3])/im.height)
    reports.append(dict(code=job['code'],version=job['version'],size=list(im.size),mode=im.mode,sha256=hashlib.sha256(src.read_bytes()).hexdigest(),bbox=box,alpha_extrema=a.getextrema(),margin_fraction=round(margin,4),margin_pass=margin>=.15-1/min(im.size),margin_nominal_pass=margin>=.15,margin_rounding_tolerance_pixels=1,native_alpha_pass=a.getextrema()==(0,255),runtime_admission=False))
(base/'geometry-audit.json').write_text(json.dumps({'content_state':'DRAFT','reports':reports},indent=2)+'\n',encoding='utf-8')
print(json.dumps([{'code':r['code'],'version':r['version'],'margin':r['margin_fraction'],'pass':r['margin_pass'],'alpha':r['native_alpha_pass']} for r in reports]))
