from pathlib import Path
from PIL import Image
import json,hashlib,shutil,sys
r=Path.cwd();b=r/'.atena/generated/art045-priority-review/v01';s=Path(sys.argv[1]);p=r/'.atena/generated/art-candidates/heroes-novos/arlindo/ao02-idle-v01.png';shutil.copyfile(s,p);assert s.read_bytes()==p.read_bytes();im=Image.open(p);a=im.getchannel('A') if im.mode=='RGBA' else None
rec=dict(id='AO02-v01',state='DRAFT',status='GENERATED_PENDING_REVIEW',candidate=str(p.relative_to(r)),sha256=hashlib.sha256(p.read_bytes()).hexdigest(),size=im.size,requested=[1024,384],alpha_extrema=a.getextrema() if a else None,technical_pending=['Exact grid resolution','Body height290 and baseline368','Human visual review'],runtime_admission=False)
(b/'ao02-native-audit-v01.json').write_text(json.dumps(rec,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'.atena/state/dev-024-art045-pilots.yaml';t=p.read_text(encoding='utf-8').replace('status: EXECUTING\n','status: GENERATED_SCOPE_COMPLETE_REVIEW_PENDING\n').replace('task: AO02 idle, status: EXECUTING_DRAFT','task: AO02 idle, status: GENERATED_AUDITED_PENDING_REVIEW').replace('parent_status: SUSPENDED_FOR_APPROVED_SIDE_SCOPE','parent_status: RESUMED_CONTINUOUS_DRAFT');p.write_text(t,encoding='utf-8')
print('AO02 native preserved; four pilot pieces generated; parent VFX resumes.')
