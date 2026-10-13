"""Record approved implementation contract and snapshot before runtime mutations."""
from pathlib import Path
import hashlib
import json
import re
import shutil
import subprocess
OUT=Path(__file__).resolve().parent
ROOT=OUT.parents[2]
assert not (OUT/'manifest.json').exists()
pre=json.loads((ROOT/'.atena/generated/art032-implementation-preflight-2026-10-12/manifest.json').read_text(encoding='utf-8'))
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
for e in pre['entries']:assert sha(ROOT/e['path'])==e['sha256']
for r in pre['receipts']:assert sha(ROOT/r['path'])==r['sha256']
allowed=['core/happenings.gd','ui/overlay.gd','ui/happening_art.gd','data/stage_events.json','tests/test_happening_art.gd']+[e['proposed_destination'] for e in pre['entries']]
snapshot={}
for p in allowed:
    target=ROOT/p
    snapshot[p]={'exists':target.exists(),'sha256':sha(target) if target.exists() else None}
    if target.exists():
        backup=OUT/'backup'/p;backup.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(target,backup)
        assert sha(backup)==sha(target)
protected=json.loads((ROOT/'.atena/generated/art032-juiblex-2026-10-12/protected-snapshot.json').read_text(encoding='utf-8'))
protected={p:h for p,h in protected.items() if p not in allowed}
for package in ['art032-npcs-2026-10-11','art032-npcs-lote02-2026-10-11','art032-pontos-2026-10-11','art032-juiblex-2026-10-12']:
    for p in (ROOT/'.atena/generated'/package/'sources').glob('*.png'):protected[p.relative_to(ROOT).as_posix()]=sha(p)
    p=ROOT/'.atena/generated'/package/'visual-acceptance.json';protected[p.relative_to(ROOT).as_posix()]=sha(p)
rootpath=ROOT/'.atena/state/plan.yaml';before=rootpath.read_text(encoding='utf-8')
for p,h in protected.items():
    actual=hashlib.sha256(before.split('active_plan:',1)[1].encode()).hexdigest() if '#active_plan_tail' in p else sha(ROOT/p)
    assert actual==h,p
entries=[]
for e in pre['entries']:
    item={**e,'destination':e['proposed_destination'],'derived_path':(OUT/'normalized'/Path(e['proposed_destination']).name).relative_to(ROOT).as_posix(),'target_visible_height':96 if e['code'] in ['PT01','PT05','PT06','PT07'] else 240,'padding':4,'content_state':'DRAFT_AUTHORIZED_RUNTIME_USE','runtime_admission':False}
    entries.append(item)
manifest={'plan':'PLAN-ART032-IMPLEMENT','revision':'v01','owner_reply':'pode implementar','approval_mode':'per-plan','approval':'APPROVED_EXPLICITLY','content_state':'DRAFT_AUTHORIZED_RUNTIME_USE','origin':'guided-before-implementation','implementation_preceded_spec':False,'current_step_position':2,'completed_steps':1,'total_steps':6,'entries':entries,'receipts':pre['receipts'],'allowed_runtime_paths':allowed,'snapshot':snapshot,'git_head':subprocess.check_output(['git','rev-parse','HEAD'],cwd=ROOT).decode().strip(),'git_index':subprocess.check_output(['git','diff','--cached','--name-only'],cwd=ROOT).decode(),'transform':{'engine':'Godot 4.7.2','method':'alpha<=8 clear on derivative, crop visible, proportional Lanczos to target visible height, four pixel padding','source_bytes':'PRESERVE','canonical_promotion':False},'runtime_admission':False,'commit_push_build':False}
(OUT/'normalized').mkdir(exist_ok=True)
(OUT/'manifest.json').write_text(json.dumps(manifest,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
(OUT/'protected-snapshot.json').write_text(json.dumps(protected,indent=2)+'\n',encoding='utf-8')
state='''version: 1
plan: PLAN-ART032-IMPLEMENT
revision: v01
request_classification: PLAN_CHANGE_REQUEST
owner_reply: 'pode implementar'
status: APPROVED_IN_PROGRESS
approval_mode: per-plan
approval_status: APPROVED_EXPLICITLY
content_state: DRAFT_AUTHORIZED_RUNTIME_USE
checkpoint: S-002/DERIVATIVES
current_step_position: 2
completed_steps: 1
total_steps: 6
remaining_steps_after_current: 4
ordered_steps: [S-001, S-002, S-003, S-004, S-005, S-006]
completed_ordered_steps: [S-001]
source_count: 17
prepared: 0
admitted: 0
runtime_admission: false
canonical_promotion: false
commit_push_build: NOT_AUTHORIZED
visual_bible: .atena/vault/drafts/PLAN-ART032-IMPLEMENT-v01.md
output_package: .atena/generated/art032-implementation-2026-10-12
evidence: .atena/evidence/art032-implementation-2026-10-12.md
preserved_checkpoint: PLAN071_AND_HERO_EXTRACTION_REVIEW
human_playtest: PENDING_NOT_PERFORMED
next_objective: 'Preparar dezessete derivados Godot, depois integrar e validar os eventos/chefe localmente'
'''
(ROOT/'.atena/state/art032-implementation.yaml').write_text(state,encoding='utf-8')
requestpath=ROOT/'.atena/state/art032-next-request-2026-10-12.yaml'
request=requestpath.read_text(encoding='utf-8')
request=request.replace('PREFLIGHT_COMPLETE_REQUEST_CLARIFICATION_PENDING','RESOLVED_IMPLEMENT_ART032').replace('G0/REQUEST_CLARIFICATION','IMPLEMENTATION_SCOPE_CONFIRMED').replace('new_image_scope: UNDEFINED','new_image_scope: NONE_REQUESTED_BEFORE_ART032_IMPLEMENTATION').replace('runtime_implementation_scope: PENDING_CONFIRMATION','runtime_implementation_scope: ART032_17_ACCEPTED_SOURCES').replace('next_execution_authorized: false','next_execution_authorized: true')
request+='owner_clarification: "pode implementar"\nimplementation_plan: PLAN-ART032-IMPLEMENT/v01\n'
requestpath.write_text(request,encoding='utf-8')
block='''art032_implementation_2026_10_12:
  plan: PLAN-ART032-IMPLEMENT
  revision: v01
  state_file: .atena/state/art032-implementation.yaml
  request_classification: PLAN_CHANGE_REQUEST
  status: APPROVED_IN_PROGRESS
  mode: per-plan
  owner_reply: 'pode implementar'
  approval_status: APPROVED_EXPLICITLY
  checkpoint: S-002/DERIVATIVES
  current_step_position: 2
  completed_steps: 1
  total_steps: 6
  remaining_steps_after_current: 4
  source_count: 17
  prepared: 0
  admitted: 0
  content_state: DRAFT_AUTHORIZED_RUNTIME_USE
  runtime_admission: false
  canonical_promotion: false
  commit_push_build: NOT_AUTHORIZED
  evidence: .atena/evidence/art032-implementation-2026-10-12.md
'''
tail=before[len('version: 2\n'):]
prefix,old=tail.split('art032_juiblex_2026_10_12:',1)
prefix=prefix.replace('PREFLIGHT_COMPLETE_REQUEST_CLARIFICATION_PENDING','RESOLVED_IMPLEMENT_ART032').replace('G0/REQUEST_CLARIFICATION','IMPLEMENTATION_SCOPE_CONFIRMED').replace('next_execution_authorized: false','next_execution_authorized: true')
rootpath.write_text('version: 2\n'+block+prefix+'art032_juiblex_2026_10_12:'+old,encoding='utf-8')
assert rootpath.read_text(encoding='utf-8').split('art032_juiblex_2026_10_12:',1)[1]==before.split('art032_juiblex_2026_10_12:',1)[1]
(ROOT/'.atena/evidence/art032-implementation-2026-10-12.md').write_text('# ART-032 — implementação local, 2026-10-12\n\nContrato [PLAN-ART032-IMPLEMENT/v01](../vault/drafts/PLAN-ART032-IMPLEMENT-v01.md) preparado antes da execução. Aprovação explícita **“pode implementar”** confirma preparação/admissão/integração das dezessete fontes aceitas ART-032; per-plan preservado. S-001 concluída, S-002 atual, 1/6. [Manifesto/backup e revisões](../generated/art032-implementation-2026-10-12/manifest.json). Fontes/recibos/protected snapshot verificados; uso runtime DRAFT autorizado, não promoção a CANON. Nenhum commit/push/build autorizado.\n',encoding='utf-8')
print('S-001 PASS: 17 source/receipt hashes; approved contract and snapshots recorded; S-002 authorized, 1/6 done.')
