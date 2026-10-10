from pathlib import Path
import json,shutil,hashlib
r=Path.cwd(); b=r/'.atena/generated/art045-priority-review/v01'
for name in ['plan.yaml','plan-053-imagens.yaml']:
 p=r/'.atena/state'/name
 shutil.copyfile(p,b/('before-route-'+name))
 t=p.read_text(encoding='utf-8').replace('status: AWAITING_OWNER_ROUTE','status: EXECUTING_WITH_RETURN').replace('checkpoint: S-007/PRIORITY/DEV-024','checkpoint: DEV-024/S-002/ER01').replace('Escolher rota DEV024; cinco Sylas preparados como retorno;41 fontes restantes.','Gerar ER01 DRAFT v01 e submeter gate; retorno Sylas preservado.')
 p.write_text(t,encoding='utf-8')
review=json.loads((b/'review.json').read_text(encoding='utf-8'))
review.update(status='APPROVED_EXECUTING',owner_reply='atena prossiga conforme as recomendações',route='execute-now-then-return',approval_mode='per-plan',approved_scope='Four pilots ER01 ER02 AO01 AO02, five ordered steps; separate visual gates')
(b/'review.json').write_text(json.dumps(review,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
state='''id: DEV-024
revision: v01
status: EXECUTING
approval_mode: per-plan
owner_reply: "atena prossiga conforme as recomendações"
parent: PLAN-053
parent_status: SUSPENDED_FOR_APPROVED_SIDE_SCOPE
return_checkpoint: S-007/VFX/FILA-023/H-REMAINING
checkpoint: S-002/ER01
steps:
  - {id: S-001, task: visual preparation, status: COMPLETED}
  - {id: S-002, task: ER01 portrait, status: EXECUTING_DRAFT}
  - {id: S-003, task: ER02 idle, status: WAITING_ER01_VISUAL_APPROVAL}
  - {id: S-004, task: AO01 portrait, status: PLANNED}
  - {id: S-005, task: AO02 idle, status: WAITING_AO01_VISUAL_APPROVAL}
runtime_admission: false
content_state: DRAFT
'''
(r/'.atena/state/dev-024-art045-pilots.yaml').write_text(state,encoding='utf-8')
refs=[]
for p in [b/'erik.png',r/'assets/portraits/brook.png',r/'assets/portraits/leoric.png']:
 refs.append(dict(path=str(p),sha256=hashlib.sha256(p.read_bytes()).hexdigest()))
(b/'visual-readiness-er01.json').write_text(json.dumps(dict(revision='v01',state='DRAFT',identity='Erik Nottcard portrait primary; visible appearance preserved, pre-shaving version',scene='Chest-up portrait in dark blue mist forest',style='Brook and Leoric approved pictorial finish; reference subjects not transferred',authority='Owner approves candidate revision; no new lore or runtime admission',blocking_gaps=[],deferred=['Human visual approval of ER01 before ER02'],references=refs),ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
print('Route approved; recoverable suspension saved; S-001 complete; S-002 ER01 ready.')
