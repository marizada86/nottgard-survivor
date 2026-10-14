from pathlib import Path
import hashlib,json,re,subprocess
out=Path(__file__).resolve().parent;root=out.parents[2]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
v=json.loads((out/'verification.json').read_text(encoding='utf-8'));assert v['status']=='PASS'
for p,h in v['runtime_sha256'].items():assert sha(root/p)==h,p
protected=json.loads((out/'protected.json').read_text(encoding='utf-8'))
assert [p for p,h in protected.items() if sha(root/p)!=h]==['core/melee_vfx.gd','ui/run.gd']
for e in json.loads((out/'authorization.json').read_text(encoding='utf-8'))['sources']:assert sha(root/e['path'])==e['sha256']
receipt={'owner_reply':'atena commit e proximo','classification':'IN_PLAN_AUTHORIZED_LOCAL_GIT_AND_QUEUE_CONTINUATION','scope':'L001 review/admission local delivery and associated evidence; then L002 42-image review','build_id':v['build_id'],'delivery_accepted':True,'human_playtest_procedure':'NOT_REPORTED','subjective_specific_criteria':'NOT_INDEPENDENTLY_VERIFIED','content_state':'DRAFT_WITH_HISTORICAL_GATES_PRESERVED','canonical_promotion':False,'commit_authorized':True,'push_authorized':False,'merge_authorized':False,'export_authorized':False,'runtime_hash_verification':'PASS','backlog':'P0=0; open P1 BUG025/027/028/029; 16 awaiting playtest; 0 alerts','branch':subprocess.check_output(['git','branch','--show-current'],cwd=root,text=True).strip()}
(out/'owner-delivery-and-commit-authorization.json').write_text(json.dumps(receipt,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
for name in ['assets-l001-admission.yaml','plan.yaml','plan-053-imagens.yaml']:
 p=root/'.atena/state'/name;s=p.read_text(encoding='utf-8')
 if name!='assets-l001-admission.yaml':prefix,s=s.split('assets_l001_admission_2026_10_13:',1)
 s=s.replace('status: LOCAL_TECHNICAL_DELIVERED_AWAITING_OWNER_PLAYTEST','status: OWNER_ACCEPTED_LOCAL_DELIVERY').replace('S-005/OWNER_RUNTIME_PLAYTEST','S-005/OWNER_DELIVERY_ACCEPTANCE_RECORDED').replace('human_runtime_playtest: PENDING_NOT_PERFORMED','human_runtime_playtest: PROCEDURE_NOT_REPORTED')
 s+='owner_delivery_acceptance: .atena/generated/assets-l001-admission-2026-10-13/owner-delivery-and-commit-authorization.json\n' if name=='assets-l001-admission.yaml' else '  owner_delivery_acceptance: .atena/generated/assets-l001-admission-2026-10-13/owner-delivery-and-commit-authorization.json\n'
 if name!='assets-l001-admission.yaml':s=prefix+'assets_l001_admission_2026_10_13:'+s
 if name=='plan-053-imagens.yaml':s=s.replace('S-007/VFX/L-001/OWNER_RUNTIME_PLAYTEST','S-007/VFX/L-001/OWNER_DELIVERY_ACCEPTANCE_RECORDED').replace('status: L001_ADMITTED_LOCAL_OWNER_PLAYTEST_PENDING','status: L001_OWNER_ACCEPTED_LOCAL_DELIVERY').replace('playtest humano pendente.','entrega local aceita; procedimento de playtest nao relatado.').replace('Playtest humano L001; depois conferir lote42herois existente, sem regeneracao automatica.','Commit local autorizado; retomar revisao L002/42herois existente, sem regeneracao automatica.')
 if name=='assets-l001-admission.yaml':s=re.sub(r'next_objective:.*','next_objective: Commit local autorizado e revisao L002/42fontes em seguida.',s)
 p.write_text(s,encoding='utf-8')
for rel in ['.atena/evidence/assets-l001-admission-2026-10-13.md','.atena/specs/SPEC-121-retomada-fila-imagens/assets-l001-admission-v01.md']:
 with (root/rel).open('a',encoding='utf-8') as f:f.write('\nDono respondeu “atena commit e proximo”: entrega local aceita, procedimento humano não relatado, commit local L001 e continuação da revisãoL002 autorizados. Runtime final/hash das30fontes reverificados, sem nova alteração de implementação; checks prévios continuam válidos. Sem CANON/push/merge/exportação. Recibo `.atena/generated/assets-l001-admission-2026-10-13/owner-delivery-and-commit-authorization.json`.\n')
print('PASS final runtime/source hashes; local delivery and commit approval recorded.')
