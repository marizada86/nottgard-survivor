from pathlib import Path
import json,re
root=Path(__file__).resolve().parents[4];out=Path(__file__).parent
pause=json.loads((out/'owner-pause-2026-10-07.json').read_text(encoding='utf-8'))
import hashlib
for row in pause['preserved']:assert hashlib.sha256((root/row['path']).read_bytes()).hexdigest()==row['sha256']
receipt=dict(date='2026-10-08',request='atena, continue',classification='IN_PLAN',plan='PLAN-053',spec='SPEC-121',status='RESUMED',prior_pause='owner-pause-2026-10-07.json',checkpoint='S-006/GORANTHIS/GUARDIAO/CORRECT-MOVE03',identity_gate='APPROVED',approval_mode='per-plan',visual_review='move03 v01 repeats original near leg lead, correction needed.',remaining_new_frames=75,return_plan='PLAN-071')
(out/'resume-2026-10-08.json').write_text(json.dumps(receipt,indent=2)+'\n',encoding='utf-8')
for rel in ['.atena/state/plan.yaml','.atena/state/plan-053-imagens.yaml']:
 p=root/rel;t=p.read_text(encoding='utf-8').replace('  status: PAUSED_BY_OWNER','  status: EXECUTING_CYCLES',1)
 if rel.endswith('/plan.yaml'):
  t=t.replace('S-006/GORANTHIS/GUARDIAO/REVIEW-MOVE03',receipt['checkpoint'],1)
  t=re.sub(r"  current: 'PLAN-053 / SPEC-121[^\n]*","  current: 'PLAN-053 / SPEC-121 retomado 2026-10-08; Guardiao sete fontes preservadas, corrigir move03. Goranthis identidades aprovadas.'",t,count=1)
 else:
  t=re.sub(r"  current: 'S-006[^\n]*","  current: 'S-006 retomado 2026-10-08; Guardiao sete fontes preservadas, corrigir move03; nenhum integrado.'",t,count=1)
  t=t.replace('owner_pause:\n','owner_pause:\n  status: RESUMED\n  resumed_at: 2026-10-08\n  resume_receipt: .atena/generated/goranthis-resume/v01/resume-2026-10-08.json\n',1)
 t=re.sub(r"  next: '[^\n]*","  next: 'Corrigir contato oposto move03 e concluir Guardiao; 75 novos quadros Goranthis, retorno PLAN-071 preservado.'",t,count=1);p.write_text(t,encoding='utf-8')
for rel in ['.atena/generated/ART-PROMPTS-049-mobs-goranthis.md','.atena/generated/CHATGPT-FILA-018-mobs-goranthis.md']:
 p=root/rel;t=p.read_text(encoding='utf-8');t=re.sub(r'^status:.*','status: "retomado em 2026-10-08; Guardião em execução, identidades aprovadas"',t,count=1,flags=re.M);p.write_text(t,encoding='utf-8')
print('Resumed IN_PLAN; preserved seven source hashes valid; correcting move03 before remaining12 Guardiao frames.')
