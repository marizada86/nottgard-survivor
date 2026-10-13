"""Persist the exact production approval before image generation."""
import hashlib
import json
from pathlib import Path
import re

OUT = Path(__file__).resolve().parent
ROOT = OUT.parents[2]
REPLY = 'Aprovo as seis peças DRAFT'
jobs_path = OUT/'jobs.json'
data = json.loads(jobs_path.read_text(encoding='utf-8'))
assert data['approval'] == 'PENDING_SCOPE_APPROVAL'
assert [j['code'] for j in data['jobs']] == ['NP04','NP05','NP06','NP07','NP08','NP09']
for source in data['sources']+data['style_references']:
    path = Path(source['path'])
    if not path.is_absolute():
        path = ROOT/path
    assert hashlib.sha256(path.read_bytes()).hexdigest() == source['sha256'], path
data.update({'approval':'APPROVED_PER_PLAN','owner_reply':REPLY,'approved_date':'2026-10-11','current_step':'S-002/GENERATION','status':'APPROVED_GENERATION_IN_PROGRESS','owner_visual_acceptance':'PENDING'})
jobs_path.write_text(json.dumps(data,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
statepath = ROOT/'.atena/state/art032-npcs-lote02.yaml'
state = statepath.read_text(encoding='utf-8').replace('status: PREPARED_PENDING_SCOPE_APPROVAL','status: APPROVED_GENERATION_IN_PROGRESS').replace('approval_status: PENDING_SCOPE_APPROVAL','approval_status: APPROVED_EXPLICITLY').replace('checkpoint: G0/SCOPE_APPROVAL','checkpoint: S-002/GENERATION')
state = re.sub(r'^next_objective:.*$', "next_objective: 'Gerar NP04-NP09 DRAFT na ordem aprovada, depois auditar e apresentar galeria'",state,flags=re.M)
state += 'scope_owner_reply: "'+REPLY+'"\napproved_date: "2026-10-11"\nhuman_visual_acceptance: PENDING\n'
statepath.write_text(state,encoding='utf-8')
rootpath = ROOT/'.atena/state/plan.yaml'
rootstate = rootpath.read_text(encoding='utf-8')
prefix, tail = rootstate.split('art032_npcs_piloto_2026_10_11:',1)
prefix = prefix.replace('status: PREPARED_PENDING_SCOPE_APPROVAL','status: APPROVED_GENERATION_IN_PROGRESS').replace('checkpoint: G0/SCOPE_APPROVAL','checkpoint: S-002/GENERATION')
prefix = re.sub(r'^  next_objective:.*$', "  next_objective: 'Gerar seis fontes DRAFT na ordem NP04-NP09; auditar e apresentar galeria'",prefix,flags=re.M)
prefix += '  scope_owner_reply: "'+REPLY+'"\n  approved_date: "2026-10-11"\n'
rootpath.write_text(prefix+'art032_npcs_piloto_2026_10_11:'+tail,encoding='utf-8')
planpath = ROOT/'.atena/vault/drafts/PLAN-ART032-NPCS-LOTE02-v01.md'
plan = planpath.read_text(encoding='utf-8').replace('status: PREPARED_PENDING_SCOPE_APPROVAL','status: APPROVED_IN_EXECUTION')
plan += '\n## Aprovação de execução — 2026-10-11\n\nG0 aprovado explicitamente com **“'+REPLY+'”** para NP04–NP09/v01, modo per-plan. S-002 liberada; toda produção continua DRAFT. Não autoriza integração, normalização, CANON, commit, push ou build.\n'
planpath.write_text(plan,encoding='utf-8')
snapshot = json.loads((OUT/'protected-snapshot.json').read_text(encoding='utf-8'))
for path, expected in snapshot.items():
    actual = hashlib.sha256(rootpath.read_text(encoding='utf-8').split('active_plan:',1)[1].encode()).hexdigest() if '#active_plan_tail' in path else hashlib.sha256((ROOT/path).read_bytes()).hexdigest()
    assert actual == expected, path
print('Six-source approval persisted; source/reference/runtime/PLAN071 hashes verified; S-002 executable per-plan.')
