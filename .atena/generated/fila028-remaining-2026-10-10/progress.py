from pathlib import Path
import json,re
base=Path(__file__).parent;root=base.parents[2]
jobs=json.loads((base/'jobs.json').read_text(encoding='utf-8'));jobs['scope_approval']='APPROVED';jobs['owner_reply']='Aprovo as 11 peças'
codes={json.loads(p.read_text(encoding='utf-8'))['code'] for p in (base/'receipts').glob('*.json')}
for j in jobs['jobs']:
    j['state']='GENERATED_PENDING_VISUAL_ACCEPTANCE' if j['code'] in codes else 'APPROVED_PENDING_GENERATION'
(base/'jobs.json').write_text(json.dumps(jobs,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
ordered=[j['code'] for j in jobs['jobs']]+['AUDIT'];count=len(codes);checkpoint=f'S-{count+1:03}/{ordered[count]}'
p=root/'.atena/state/fila028-remaining.yaml';t=p.read_text(encoding='utf-8');t=re.sub(r'^completed_steps: \d+',f'completed_steps: {count}',t,flags=re.M);t=re.sub(r'^checkpoint: .*',f'checkpoint: {checkpoint}',t,flags=re.M);p.write_text(t,encoding='utf-8')
print(checkpoint)
