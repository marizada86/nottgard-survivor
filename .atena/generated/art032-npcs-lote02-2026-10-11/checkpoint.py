"""Advance only this image plan, preserving the pilot and the root return chain."""
import json
from pathlib import Path
import re
import sys
OUT = Path(__file__).resolve().parent
ROOT = OUT.parents[2]
assert not (OUT/'visual-acceptance.json').exists(), 'Closed owner-approved lot; do not reset checkpoints.'
step = sys.argv[1]
assert step in ['S-003','S-004','S-005']
position = int(step[-1])
status = 'GENERATED_AUDITED_WAITING_VISUAL_APPROVAL' if step == 'S-005' else 'APPROVED_EXECUTION_IN_PROGRESS'
checkpoint = step+'/'+{'S-003':'AUDIT','S-004':'GALLERY','S-005':'OWNER_VISUAL_REVIEW'}[step]
objective = {'S-003':'Consolidar auditoria nativa e leitura 80/128 px','S-004':'Concluir galeria, links, evidências e roteiro de revisão','S-005':'Revisão do dono das seis revisões DRAFT; aceite identificado ou ajustes por código'}[step]
data = json.loads((OUT/'jobs.json').read_text(encoding='utf-8'))
assert data['approval'] == 'APPROVED_PER_PLAN' and data['generated'] == 6
data.update({'status':status,'current_step':checkpoint,'completed_steps':position-1,'current_step_position':position,'owner_visual_acceptance':'PENDING'})
(OUT/'jobs.json').write_text(json.dumps(data,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
updates = {'status':status,'checkpoint':checkpoint,'current_step_position':str(position),'completed_steps':str(position-1),'remaining_steps_after_current':str(5-position),'next_objective':"'"+objective+"'"}
statepath = ROOT/'.atena/state/art032-npcs-lote02.yaml'
state = statepath.read_text(encoding='utf-8')
for key,value in updates.items():
    state,n = re.subn(r'^'+key+r':.*$',key+': '+value,state,flags=re.M)
    assert n == 1,key
state = re.sub(r'^completed_ordered_steps:.*$','completed_ordered_steps: ['+', '.join('S-00'+str(i) for i in range(1,position))+']',state,flags=re.M)
statepath.write_text(state,encoding='utf-8')
rootpath = ROOT/'.atena/state/plan.yaml'
prefix,tail = rootpath.read_text(encoding='utf-8').split('art032_npcs_piloto_2026_10_11:',1)
for key,value in updates.items():
    if key == 'remaining_steps_after_current':
        continue
    prefix,n = re.subn(r'^  '+key+r':.*$','  '+key+': '+value,prefix,flags=re.M)
    assert n == 1,key
rootpath.write_text(prefix+'art032_npcs_piloto_2026_10_11:'+tail,encoding='utf-8')
print(f'{checkpoint}: completed {position-1}/5, current {position}/5, after current {5-position}; six DRAFT sources, no runtime changes.')
