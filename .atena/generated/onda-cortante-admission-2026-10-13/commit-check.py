from pathlib import Path
import hashlib,json,re,subprocess
out=Path(__file__).resolve().parent
root=out.parents[2]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
v=json.loads((out/'verification.json').read_text(encoding='utf-8'))
assert v['status']=='PASS'
for p,h in v['runtime_sha256'].items():assert sha(root/p)==h,p
protected=json.loads((out/'protected.json').read_text(encoding='utf-8'))
assert [p for p,h in protected.items() if sha(root/p)!=h]==['ui/radiant_orb_layer.gd']
for family in ['orbe-radiante','orbe-arcano','onda-cortante']:
 folder=root/f'.atena/generated/{family}-admission-2026-10-13'
 for e in json.loads((folder/'authorization.json').read_text(encoding='utf-8'))['sources']:assert sha(root/e['path'])==e['sha256']
receipt={'owner_reply':'atena aprovado, commit','classification':'IN_PLAN_AUTHORIZED_LOCAL_GIT','scope':['orbe-radiante-admission/v01','orbe-arcano-admission/v01','onda-cortante-admission/v01'],'onda_delivery_accepted':True,'human_playtest_procedure':'NOT_REPORTED','subjective_specific_criteria':'NOT_INDEPENDENTLY_VERIFIED','content_state':'DRAFT','canonical_promotion':False,'commit_authorized':True,'push_authorized':False,'merge_authorized':False,'export_authorized':False,'branch':subprocess.check_output(['git','branch','--show-current'],cwd=root,text=True).strip(),'pre_commit_head':subprocess.check_output(['git','rev-parse','HEAD'],cwd=root,text=True).strip(),'runtime_hash_verification':'PASS','backlog':'P0=0; open P1=BUG-025/027/028/029; 16 awaiting playtest; 0 organizational alerts'}
(out/'owner-delivery-and-commit-authorization.json').write_text(json.dumps(receipt,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=root/'.atena/state/onda-cortante-admission.yaml';s=p.read_text(encoding='utf-8').replace('status: LOCAL_TECHNICAL_DELIVERED_AWAITING_OWNER_PLAYTEST','status: OWNER_ACCEPTED_LOCAL_DELIVERY').replace('S-004/OWNER_RUNTIME_PLAYTEST','S-004/OWNER_DELIVERY_ACCEPTANCE_RECORDED').replace('human_runtime_playtest: PENDING_NOT_PERFORMED','human_runtime_playtest: PROCEDURE_NOT_REPORTED');s=re.sub(r'next_objective:.*','next_objective: Commit local autorizado; depois conferir proxima pendencia da fila existente.',s);s+='owner_delivery_acceptance: .atena/generated/onda-cortante-admission-2026-10-13/owner-delivery-and-commit-authorization.json\n';p.write_text(s,encoding='utf-8')
for name in ['plan.yaml','plan-053-imagens.yaml']:
 p=root/'.atena/state'/name;s=p.read_text(encoding='utf-8');prefix,block=s.split('onda_cortante_admission_2026_10_13:',1)
 block=block.replace('status: LOCAL_TECHNICAL_DELIVERED_AWAITING_OWNER_PLAYTEST','status: OWNER_ACCEPTED_LOCAL_DELIVERY').replace('S-004/OWNER_RUNTIME_PLAYTEST','S-004/OWNER_DELIVERY_ACCEPTANCE_RECORDED')
 block+='  owner_acceptance: .atena/generated/onda-cortante-admission-2026-10-13/owner-delivery-and-commit-authorization.json\n'
 s=prefix+'onda_cortante_admission_2026_10_13:'+block
 if name=='plan-053-imagens.yaml':s=s.replace('ONDA_CORTANTE/OWNER_RUNTIME_PLAYTEST','ONDA_CORTANTE/OWNER_DELIVERY_ACCEPTANCE_RECORDED').replace('ONDA_CORTANTE_ADMITTED_LOCAL_OWNER_PLAYTEST_PENDING','ONDA_CORTANTE_OWNER_ACCEPTED_LOCAL_DELIVERY').replace('Onda Cortante admitida localmente DRAFT; suite/smoke/69capturas/paridade PASS, playtest humano pendente.','Onda Cortante entrega local aceita DRAFT; procedimento de playtest nao relatado; commit local autorizado.').replace('Playtest humano Onda Cortante; depois conferir proxima pendencia nas filas existentes sem regeneracao automatica.','Concluir commit local autorizado; depois conferir proxima pendencia nas filas existentes sem regeneracao automatica.')
 s+='''assets_git_checkpoint_2026_10_13:
  classification: IN_PLAN_AUTHORIZED_LOCAL_GIT
  owner_reply: 'atena aprovado, commit'
  scope: [orbe-radiante-admission/v01, orbe-arcano-admission/v01, onda-cortante-admission/v01]
  mode: per-plan
  status: AUTHORIZED_PRE_COMMIT_VERIFIED
  evidence: .atena/generated/onda-cortante-admission-2026-10-13/owner-delivery-and-commit-authorization.json
  content_state: DRAFT
  canonical_promotion: false
  push_authorized: false
  merge_authorized: false
  return_plan: PLAN-071
  return_checkpoint: B-006/S-011
'''
 p.write_text(s,encoding='utf-8')
for rel in ['.atena/evidence/onda-cortante-admission-2026-10-13.md','.atena/specs/SPEC-121-retomada-fila-imagens/onda-cortante-admission-v01.md']:
 with (root/rel).open('a',encoding='utf-8') as f:f.write('\n2026-10-13 — Dono respondeu “atena aprovado, commit”: entrega local aceita, procedimento humano não relatado; DRAFT mantido. Commit local das três famílias pendentes autorizado; sem autorização de push/merge/exportação. Hashes do runtime final e fontes reverificados; checks anteriores permanecem válidos, sem nova alteração de implementação. Recibo: `.atena/generated/onda-cortante-admission-2026-10-13/owner-delivery-and-commit-authorization.json`.\n')
print('PASS unchanged verified runtime, 24 source hashes, acceptance and local commit authorization recorded.')
