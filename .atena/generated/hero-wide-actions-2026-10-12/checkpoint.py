"""Advance only the current approved wide-action operational checkpoint."""
from pathlib import Path
import json
import re
import sys
OUT=Path(__file__).resolve().parent
ROOT=OUT.parents[2]
position,completed,checkpoint,status=int(sys.argv[1]),int(sys.argv[2]),sys.argv[3],sys.argv[4]
p=OUT/'manifest.json';m=json.loads(p.read_text(encoding='utf-8'));m.update({'current_step_position':position,'completed_steps':completed,'checkpoint':checkpoint,'status':status});p.write_text(json.dumps(m,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
fields={'current_step_position':str(position),'completed_steps':str(completed),'remaining_steps_after_current':str(5-position),'checkpoint':checkpoint,'status':status}
for p in [ROOT/'.atena/state/plan.yaml',ROOT/'.atena/state/hero-wide-actions.yaml']:
    text=p.read_text(encoding='utf-8')
    if p.name=='plan.yaml':prefix,tail=text.split('hero_mask_feasibility_2026_10_12:',1)
    else:prefix,tail=text,''
    for key,value in fields.items():prefix=re.sub(r'^  '+key+r':.*$','  '+key+': '+value,prefix,flags=re.M)
    p.write_text(prefix+('hero_mask_feasibility_2026_10_12:'+tail if p.name=='plan.yaml' else ''),encoding='utf-8')
print(f'{completed}/5 complete; current {position}/5 {checkpoint}; after current {5-position}.')
