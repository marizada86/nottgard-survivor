from pathlib import Path
from PIL import Image,ImageChops,ImageStat
import sys,json,hashlib,shutil,datetime
r=Path.cwd(); b=r/'.atena/generated/continuous-draft-2026-10-09'; jobsfile=b/'jobs.json'; data=json.loads(jobsfile.read_text(encoding='utf-8')); code,original=sys.argv[1:3]; job=next(j for j in data['jobs'] if j['code']==code); src=Path(original);dst=r/job['destination'];dst.parent.mkdir(parents=True,exist_ok=True)
assert not dst.exists(),dst
shutil.copyfile(src,dst);assert src.read_bytes()==dst.read_bytes()
im=Image.open(dst).convert('RGB'); lum=im.convert('L');mask=lum.point(lambda x:255 if x>12 else 0)
border=max(lum.crop((0,0,im.width,1)).getextrema()[1],lum.crop((0,im.height-1,im.width,im.height)).getextrema()[1],lum.crop((0,0,1,im.height)).getextrema()[1],lum.crop((im.width-1,0,im.width,im.height)).getextrema()[1]); channels=im.split();diff=max(ImageChops.difference(channels[0],channels[1]).getextrema()[1],ImageChops.difference(channels[1],channels[2]).getextrema()[1])
job.update(status='GENERATED_DRAFT_PENDING_HUMAN_REVIEW',original=str(src),sha256=hashlib.sha256(dst.read_bytes()).hexdigest(),native_size=im.size,visible_bbox=mask.getbbox(),border_max=border,channel_difference=diff,technical_flags=[x for x,test in [('SIZE_NORMALIZATION',im.size!=(1024,1024)),('EDGE_LIGHT',border>12),('COLOR_DIFFERENCE',diff>16)] if test],runtime_admission=False,generated_at=datetime.datetime.now(datetime.timezone.utc).isoformat())
data['generated']=sum(j['status'].startswith('GENERATED') for j in data['jobs']);data['remaining']=41-data['generated'];jobsfile.write_text(json.dumps(data,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
for p in [r/'.atena/state/plan.yaml',r/'.atena/state/plan-053-imagens.yaml']:
 t=p.read_text(encoding='utf-8')
 import re
 t=re.sub(r'remaining_native_vfx_frames: \d+', 'remaining_native_vfx_frames: '+str(data['remaining']),t)
 t=re.sub(r'checkpoint: DEV-024/S-005/AO02','checkpoint: S-007/VFX/FILA-023/CONTINUOUS-DRAFT',t)
 p.write_text(t,encoding='utf-8')
print(json.dumps(dict(code=code,generated=data['generated'],remaining=data['remaining'],flags=job['technical_flags'])))
