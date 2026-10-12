"""Persist only the implementation step, preserving the suspended return chain."""
from pathlib import Path
import json
import re
import sys
OUT=Path(__file__).resolve().parent
ROOT=OUT.parents[2]
position,completed,checkpoint,status=int(sys.argv[1]),int(sys.argv[2]),sys.argv[3],sys.argv[4]
data=json.loads((OUT/'manifest.json').read_text(encoding='utf-8'))
data.update({'current_step_position':position,'completed_steps':completed,'checkpoint':checkpoint,'status':status})
(OUT/'manifest.json').write_text(json.dumps(data,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
fields={'current_step_position':str(position),'completed_steps':str(completed),'remaining_steps_after_current':str(6-position),'checkpoint':checkpoint,'status':status}
statepath=ROOT/'.atena/state/art032-implementation.yaml'
state=statepath.read_text(encoding='utf-8')
for key,value in fields.items():state=re.sub(r'^'+key+r':.*$',key+': '+value,state,flags=re.M)
state=re.sub(r'^completed_ordered_steps:.*$','completed_ordered_steps: ['+', '.join('S-%03d'%n for n in range(1,completed+1))+']',state,flags=re.M)
statepath.write_text(state,encoding='utf-8')
rootpath=ROOT/'.atena/state/plan.yaml'
prefix,tail=rootpath.read_text(encoding='utf-8').split('art032_next_request_2026_10_12:',1)
for key,value in fields.items():prefix=re.sub(r'^  '+key+r':.*$','  '+key+': '+value,prefix,flags=re.M)
rootpath.write_text(prefix+'art032_next_request_2026_10_12:'+tail,encoding='utf-8')
print(f'{completed}/6 complete; current {position}/6 {checkpoint}; remaining after current {6-position}.')
