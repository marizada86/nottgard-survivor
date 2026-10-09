from pathlib import Path
import json,hashlib,sys,shutil
from datetime import datetime,timezone
from PIL import Image,ImageChops
root=Path(__file__).resolve().parents[4];out=Path(__file__).parent
code,original=sys.argv[1:3];jobs_file=sys.argv[sys.argv.index('--jobs')+1] if '--jobs' in sys.argv else 'ef-generation-jobs-2026-10-09.json';p=out/jobs_file;data=json.loads(p.read_text(encoding='utf-8'));job=next(j for j in data['jobs'] if j['code']==code)
dest=root/job['destination'];assert not dest.exists();assert job['status']=='PENDING'
shutil.copyfile(original,dest)
sha=lambda path:hashlib.sha256(path.read_bytes()).hexdigest()
assert sha(dest)==sha(Path(original))
im=Image.open(dest).convert('RGB');r,g,b=im.split();lum=im.convert('L');w,h=im.size
bbox=lum.point(lambda v:255 if v>12 else 0).getbbox();hist=lum.histogram()
border=max(lum.crop(box).getextrema()[1] for box in [(0,0,w,1),(0,h-1,w,h),(0,0,1,h),(w-1,0,w,h)])
job.update(status='REJECTED_VISUAL' if len(sys.argv)>3 and sys.argv[3]=='reject' else 'GENERATED_VISUALLY_INSPECTED',generated_at=datetime.now(timezone.utc).isoformat(),original_path=original,sha256=sha(dest),visual_inspected=True,native_dimensions=[w,h],native_mode=Image.open(dest).mode,canvas_square=w==h,visible_bbox_above12=bbox,outer_border_max_luminance=border,maximum_channel_difference=max(ImageChops.difference(r,g).getextrema()[1],ImageChops.difference(r,b).getextrema()[1],ImageChops.difference(g,b).getextrema()[1]),mean_luminance=sum(i*n for i,n in enumerate(hist))/(w*h),visible_fraction_above12=sum(hist[13:])/(w*h),native_bytes_preserved=True,runtime_admission=False)
assert w==h and bbox and bbox[0]>0 and bbox[1]>0 and bbox[2]<w and bbox[3]<h,'Inspect/correct native margins before continuing'
p.write_text(json.dumps(data,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
generated=sum(j['status'].startswith('GENERATED') for j in data['jobs']);remain=data.get('remaining_at_start',107)-generated
state=root/'.atena/state/plan-053-imagens.yaml';t=state.read_text(encoding='utf-8')
if '\nvfx_generation_progress:' not in t:t+='\nvfx_generation_progress:\n  jobs: .atena/generated/s007-reconciliation/v01/ef-generation-jobs-2026-10-09.json\n  native_generated_since_E03: 0\n  last_frame: none\n'
import re
gate=re.search(r'\nvfx_gate:\n(.*?)(?=\n\S|\Z)',t,re.S)
assert gate
block=re.sub(r'(  remaining_native_vfx_frames: )\d+',lambda m:m[1]+str(remain),gate.group(1));t=t[:gate.start(1)]+block+t[gate.end(1):]
counter=data.get('counter_field','native_generated_since_E03')
t=re.sub(r'(  '+counter+r': )\d+',lambda m:m[1]+str(generated),t)
t=re.sub(r'(  last_frame: )[^\n]+',lambda m:m[1]+code,t);state.write_text(t,encoding='utf-8')
print(json.dumps({k:job[k] for k in ['code','status','native_dimensions','visible_bbox_above12','outer_border_max_luminance','maximum_channel_difference','mean_luminance','visible_fraction_above12']},ensure_ascii=False))
