from pathlib import Path
from PIL import Image
import json,hashlib
r=Path.cwd(); b=r/'.atena/generated/art045-priority-review/v01'; p=r/'.atena/generated/art-candidates/heroes-novos/erik/er02-idle-v02.png'; im=Image.open(p); a=im.getchannel('A'); w=im.width//4
frames=[]
for i in range(4):
 c=a.crop((i*w,0,(i+1)*w,im.height)); mask=c.point(lambda x:255 if x>128 else 0); box=mask.getbbox(); frames.append(dict(frame=i+1,bbox=box,edge_alpha_max=max(c.crop((0,0,w,1)).getextrema()[1],c.crop((0,im.height-1,w,im.height)).getextrema()[1],c.crop((0,0,1,im.height)).getextrema()[1],c.crop((w-1,0,w,im.height)).getextrema()[1])))
rec=dict(id='ER02-v02',state='DRAFT',status='PENDING_VISUAL_APPROVAL_WITH_TECHNICAL_NORMALIZATION_PENDING',candidate=str(p.relative_to(r)),sha256=hashlib.sha256(p.read_bytes()).hexdigest(),size=im.size,requested=[1024,384],alpha_extrema=a.getextrema(),transparent_fraction=a.histogram()[0]/(im.width*im.height),frames=frames,visual_review='Four southeast poses; anatomical right-hand torch corrected; appearance matches approved Erik. Breathing subtle, flame changes. Body height excludes sword/flame and is not certified by this alpha audit.',pending=['Normalize grid resolution by approved asset workflow','Exact body height300/baseline368 validation','Owner idle visual acceptance'],runtime_admission=False)
(b/'er02-native-audit-v02.json').write_text(json.dumps(rec,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
# Audit-only alpha composite; native artwork untouched.
bg=Image.new('RGBA',im.size,(92,103,113,255)); bg.alpha_composite(im); bg.convert('RGB').save(b/'er02-alpha-review-v02.png')
p=r/'.atena/state/dev-024-art045-pilots.yaml'; t=p.read_text(encoding='utf-8').replace('checkpoint: S-003/ER02','checkpoint: S-004/AO01').replace('task: ER02 idle, status: EXECUTING_DRAFT','task: ER02 idle, status: GENERATED_AUDITED_PENDING_ACCEPTANCE').replace('task: AO01 portrait, status: PLANNED','task: AO01 portrait, status: EXECUTING_DRAFT');p.write_text(t,encoding='utf-8')
(b/'visual-readiness-ao01.json').write_text(json.dumps(dict(revision='v01',state='DRAFT',identity='Original Nottcard Arlindo portrait is authoritative; face/hat/coat/scarf/gloves preserved',scene='Chest-up wet stone alley, amber lamp',style='Brook/Leoric pictorial finish only',authority='DEV024 authorized draft; owner portrait gate before idle',blocking_gaps=[],deferred=['Owner visual acceptance'],reference='.atena/generated/art045-priority-review/v01/arlindo.png'),ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
print(json.dumps(rec))
