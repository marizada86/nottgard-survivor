from pathlib import Path
import json,hashlib,re
r=Path.cwd(); b=r/'.atena/generated/art045-priority-review/v01'
reply='atena aprovado, execute o plano, por lotes está demorando, a intenção é que quando eu chegar daqui 4 horas eu verifique o maior numero de assets.'
for file,num,label in [('er02-native-audit-v02.json','037','erik-idle'),('ao01-gate-v01.json','038','arlindo-retrato')]:
 p=b/file; d=json.loads(p.read_text(encoding='utf-8')); candidate=r/Path(d['candidate']); assert hashlib.sha256(candidate.read_bytes()).hexdigest()==d['sha256']
 d.update(owner_reply=reply,visual_approval='APPROVED_BY_OWNER',content_state='CANON_VISUAL_REVISION',runtime_admission=False)
 p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
 (r/('.atena/vault/canon/ASSET-APPROVAL-REGISTER-'+num+'-'+label+'-2026-10-09.md')).write_text('# '+label+' — aprovação visual\n\nDono aprovou a revisão apresentada: '+d['id']+'. SHA256 '+d['sha256']+'. CANON limitado à revisão visual; pendências técnicas não dispensadas; sem admissão runtime. [Recibo](../../generated/art045-priority-review/v01/'+file+').\n',encoding='utf-8')
decision=dict(revision='v02',classification='IN_PLAN',owner_reply=reply,approval_mode='per-plan',execution='Generate remaining approved plan assets continuously as DRAFT, including experimental effect gates; human review deferred until owner returns',canonical_promotion='Only explicitly approved ER02v02 and AO01v01; future assets DRAFT',runtime_admission=False,scope='Complete AO02, then remaining41 native frames FILA023; other16 hero strips outside bounded side scope',technical_pending='Normalize and validate idle grid/body height/pivot before integration')
(b/'continuous-draft-authorization-v02.json').write_text(json.dumps(decision,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
for p in [r/'.atena/state/plan.yaml',r/'.atena/state/plan-053-imagens.yaml',r/'.atena/state/dev-024-art045-pilots.yaml']:
 t=p.read_text(encoding='utf-8').replace('S-004/AO01-APPROVAL','S-005/AO02').replace('task: AO01 portrait, status: GENERATED_WAITING_VISUAL_APPROVAL','task: AO01 portrait, status: APPROVED_BY_OWNER').replace('task: AO02 idle, status: WAITING_AO01_VISUAL_APPROVAL','task: AO02 idle, status: EXECUTING_DRAFT')
 t+='\ncontinuous_draft_execution:\n  approval_mode: per-plan\n  status: APPROVED\n  receipt: .atena/generated/art045-priority-review/v01/continuous-draft-authorization-v02.json\n  human_review: deferred_until_owner_returns\n  runtime_admission: false\n'
 p.write_text(t,encoding='utf-8')
q=(r/'.atena/generated/CHATGPT-FILA-023-vfx-habilidades-dos-herois.md').read_text(encoding='utf-8')
jobs=[]
for m in re.finditer(r'#### (H\d+) - `([^`]+)`[^\n]*\n(.*?)(?=\n#### |\n## H|\Z)',q,re.S):
 code,name,section=m.groups(); prompt=re.search(r'```text\s*(.*?)```',section,re.S)
 if not prompt or int(code[1:])<401 or code=='H403':continue
 effect=name.rsplit('_',1)[0]
 if '_loop_' in name:effect=name.split('_loop_')[0]
 jobs.append(dict(code=code,name=name,effect=effect,prompt=prompt.group(1).strip(),destination='.atena/generated/art-candidates/vfx/'+effect+'/'+name+'_v01.png',status='PLANNED_DRAFT'))
 # Gate first for new effects; Sylas already approved.
jobs.sort(key=lambda j:(int(j['code'][1:])//100,0 if 'PEAK frame' in j['prompt'] or 'loop 00:' in j['prompt'] else 1,int(j['code'][1:])))
assert len(jobs)==41,len(jobs)
dest=r/'.atena/generated/continuous-draft-2026-10-09';dest.mkdir(exist_ok=True)
(dest/'jobs.json').write_text(json.dumps(dict(plan='PLAN-053',revision='continuous-v02',state='DRAFT',initial_remaining=41,jobs=jobs),ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
print('Approval recorded; 41 ordered VFX jobs prepared.')
