from pathlib import Path
import json,hashlib
r=Path.cwd(); b=r/'.atena/generated/art045-priority-review/v01'; p=b/'er01-gate-v01.json'; d=json.loads(p.read_text(encoding='utf-8'))
assert hashlib.sha256((r/d['candidate']).read_bytes()).hexdigest()==d['sha256']
d.update(status='APPROVED_BY_OWNER',content_state='CANON',owner_reply='atena, aprovo, prossiga',approval_scope='ER01 v01 visual only; no runtime admission')
p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
(r/'.atena/vault/canon/ASSET-APPROVAL-REGISTER-036-erik-retrato-2026-10-09.md').write_text('# ER01 — retrato Erik v01\n\nCANON: candidato ER01 v01 aprovado pelo dono: “atena, aprovo, prossiga”. SHA256 '+d['sha256']+'. [Recibo](../../generated/art045-priority-review/v01/er01-gate-v01.json). Aceite visual; admissão runtime não incluída. ER02 permanece DRAFT até aceite.\n',encoding='utf-8')
for p in [r/'.atena/state/plan.yaml',r/'.atena/state/plan-053-imagens.yaml',r/'.atena/state/dev-024-art045-pilots.yaml']:
 t=p.read_text(encoding='utf-8').replace('S-002/ER01-APPROVAL','S-003/ER02').replace('task: ER01 portrait, status: GENERATED_WAITING_VISUAL_APPROVAL','task: ER01 portrait, status: APPROVED_BY_OWNER').replace('task: ER02 idle, status: WAITING_ER01_VISUAL_APPROVAL','task: ER02 idle, status: EXECUTING_DRAFT')
 p.write_text(t,encoding='utf-8')
(b/'visual-readiness-er02.json').write_text(json.dumps(dict(state='DRAFT',revision='v01',identity='ER01 v01 approved plus original Nottcard portrait; pre-shaving Erik',scene='Isolated full-body isometric southeast idle with right-hand torch, no environment',authority='Owner approval limited to portrait; idle draft authorized by DEV024',blocking_gaps=[],deferred=['Native grid/alpha audit','Owner idle acceptance'],references=[d['candidate'],str(b/'erik.png')]),ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
