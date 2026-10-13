"""Update only this lot's operational checkpoint; keep all return state intact."""
from pathlib import Path
import json
import re
import sys
OUT=Path(__file__).resolve().parent
ROOT=OUT.parents[2]
assert not (OUT/'visual-acceptance.json').exists()
position, completed, checkpoint, status = int(sys.argv[1]), int(sys.argv[2]), sys.argv[3], sys.argv[4]
data=json.loads((OUT/'jobs.json').read_text(encoding='utf-8'))
data.update({'current_step':checkpoint,'current_step_position':position,'completed_steps':completed,'status':status})
(OUT/'jobs.json').write_text(json.dumps(data,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
changes={'status':status,'checkpoint':checkpoint,'current_step_position':str(position),'completed_steps':str(completed),'remaining_steps_after_current':str(5-position)}
statepath=ROOT/'.atena/state/art032-pontos.yaml'
state=statepath.read_text(encoding='utf-8')
for key,value in changes.items(): state=re.sub(r'^'+key+r': .+$',key+': '+value,state,flags=re.M)
state=re.sub(r'^completed_ordered_steps: .+$','completed_ordered_steps: ['+', '.join('S-%03d'%n for n in range(1,completed+1))+']',state,flags=re.M)
if 'native_outputs_preserved:' not in state: state+='native_outputs_preserved: '+str(len(data['jobs'])+len(data.get('previous_native_versions',[])))+'\n'
statepath.write_text(state,encoding='utf-8')
rootpath=ROOT/'.atena/state/plan.yaml'
prefix,tail=rootpath.read_text(encoding='utf-8').split('art032_npcs_lote02_2026_10_11:',1)
for key,value in changes.items(): prefix=re.sub(r'^  '+key+r': .+$','  '+key+': '+value,prefix,flags=re.M)
rootpath.write_text(prefix+'art032_npcs_lote02_2026_10_11:'+tail,encoding='utf-8')
print(f'{completed}/5 completed; current {position}/5 {checkpoint}; remaining after current {5-position}; {status}')
