from pathlib import Path
import hashlib,json,re
out=Path(__file__).resolve().parent;root=out.parents[2]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
manifest=json.loads((out/'manifest.json').read_text(encoding='utf-8'))
for e in manifest['sources']:assert sha(root/e['path'])==e['sha256']
protected=json.loads((out/'protected.json').read_text(encoding='utf-8'));assert all(sha(root/p)==h for p,h in protected.items())
accepted=[{'code':e['code'],'version':e['version'],'path':e['path'],'sha256':e['sha256'],'content_state':'DRAFT_VISUALLY_ACCEPTED'} for e in manifest['sources'] if e['acceptance']=='PENDING_VISUAL_ACCEPTANCE']
assert len(accepted)==25
receipt={'revision':'assets-batch-review/v01','batch':'L-001','owner_reply':'Aprovo as 25 fases DRAFT do lote L-001','accepted':accepted,'historical_gate_acceptances_preserved':[{'code':e['code'],'version':e['version'],'sha256':e['sha256']} for e in manifest['sources'] if e['acceptance']=='HISTORICAL_GATE_ACCEPTED'],'exceptions':[],'content_state':'DRAFT_WITH_HISTORICAL_GATES_PRESERVED','canonical_promotion':False,'authorized_next_action':'PREPARE_JOINT_ADMISSION_PROPOSAL','admission_execution_authorized':False,'git_authorized':False}
(out/'visual-acceptance.json').write_text(json.dumps(receipt,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=out/'index.html';s=p.read_text(encoding='utf-8').replace('25 fases adicionais aguardam aceite.','25 fases adicionais aceitas visualmente DRAFT pelo dono.').replace('PENDING_VISUAL_ACCEPTANCE','DRAFT_VISUALLY_ACCEPTED');p.write_text(s,encoding='utf-8')
p=root/'.atena/state/assets-batch-review.yaml';s=p.read_text(encoding='utf-8').replace('status: TECHNICAL_REVIEW_COMPLETE_AWAITING_OWNER_VISUAL_ACCEPTANCE','status: COMPLETED_VISUALLY_ACCEPTED_DRAFT').replace('S-004/VISUAL_BATCH_ACCEPTANCE','S-004/VISUAL_BATCH_ACCEPTANCE_RECORDED').replace('approval_status: PENDING_VISUAL_ACCEPTANCE','approval_status: VISUALLY_ACCEPTED_EXPLICITLY');s=re.sub(r'next_objective:.*','next_objective: Escolher modo/aprovar proposta conjunta assets-l001-admission/v01.',s);s+='visual_acceptance: .atena/generated/assets-batch-review-2026-10-13/visual-acceptance.json\nadmission_proposal: .atena/specs/SPEC-121-retomada-fila-imagens/assets-l001-admission-v01.md\nadmission_mode: unconfigured\nadmission_execution_authorized: false\n';p.write_text(s,encoding='utf-8')
for name in ['plan.yaml','plan-053-imagens.yaml']:
 p=root/'.atena/state'/name;s=p.read_text(encoding='utf-8');prefix,block=s.split('assets_batch_review_2026_10_13:',1)
 block=block.replace('status: TECHNICAL_REVIEW_COMPLETE_AWAITING_OWNER_VISUAL_ACCEPTANCE','status: COMPLETED_VISUALLY_ACCEPTED_DRAFT').replace('S-004/VISUAL_BATCH_ACCEPTANCE','S-004/VISUAL_BATCH_ACCEPTANCE_RECORDED').replace('additional_phases_pending_acceptance: 25','additional_phases_pending_acceptance: 0')
 block+='  visual_acceptance: .atena/generated/assets-batch-review-2026-10-13/visual-acceptance.json\n  admission_mode: unconfigured\n'
 s=prefix+'assets_batch_review_2026_10_13:'+block
 s+='''assets_l001_admission_2026_10_13:
  plan: PLAN-053
  revision: assets-l001-admission/v01
  classification: PLAN_CHANGE_REQUEST
  state_file: .atena/state/assets-l001-admission.yaml
  mode: unconfigured
  status: PROPOSED_AWAITING_SCOPE_AND_MODE
  checkpoint: PLAN_APPROVAL
  completed_steps: 0
  total_steps: 5
  content_state: DRAFT_WITH_HISTORICAL_GATES_PRESERVED
  runtime_admission: false
  canonical_promotion: false
  return_plan: PLAN-071
  return_checkpoint: B-006/S-011
'''
 if name=='plan-053-imagens.yaml':
  s=s.replace('S-007/VFX/L-001/VISUAL_BATCH_ACCEPTANCE','S-007/VFX/L-001/ADMISSION_PLAN_APPROVAL').replace('status: L001_30_IMAGES_REVIEWED_AWAITING_OWNER','status: L001_VISUALLY_ACCEPTED_ADMISSION_PROPOSED').replace('L-001: 30 fontes E/F/H1/H2/H3 recuperadas por hash; cinco sequencias conferidas; aceite de25fases DRAFT pendente.','L-001:25fases DRAFT aceitas e cinco gates preservados; proposta conjunta de cinco atlas preparada.').replace('Aceite visual agrupado com excecoes; preparar proposta conjunta de admissao e depois lote42herois.','Escolher modo e aprovar assets-l001-admission/v01; depois lote42herois.')
 p.write_text(s,encoding='utf-8')
for rel in ['.atena/evidence/assets-batch-review-2026-10-13.md','.atena/specs/SPEC-121-retomada-fila-imagens/assets-batch-review-v01.md']:
 with (root/rel).open('a',encoding='utf-8') as f:f.write('\nAceite posterior: dono respondeu “Aprovo as25fases DRAFT do loteL-001”, sem exceções.30hashes reverificados; cinco gates históricos preservados. Recibo `.atena/generated/assets-batch-review-2026-10-13/visual-acceptance.json`. Proposta conjunta assets-l001-admission/v01 preparada prospectivamente: cinco atlas, três armas/ativações de Durvall/Brook/Maelor; guarda segue estado real e Comunhão um ciclo visual0,6s sem cura contínua. Escopo/modo pendentes, nenhuma normalização/admissão executada.\n')
with (root/'.atena/backlog/ARTE.md').open('a',encoding='utf-8') as f:f.write('\n2026-10-13 — ART-028/030: loteL00130fontes E/F/H1/H2/H3,25fases adicionais aceitas DRAFT pelo dono; cinco gates históricos preservados. Proposta conjunta assets-l001-admission/v01 preparada, escopo/modo pendentes; sem integração/CANON/Git. Recibo `.atena/generated/assets-batch-review-2026-10-13/visual-acceptance.json`.\n')
targets=[root/'.atena/specs/SPEC-121-retomada-fila-imagens/assets-l001-admission-v01.md'];count=0
for p in targets:
 for link in re.findall(r'\]\(([^)]+)\)',p.read_text(encoding='utf-8')):assert (p.parent/link).exists(),link;count+=1
central=(root/'.atena/state/plan.yaml').read_text(encoding='utf-8');assert re.search(r'active_plan:\s+id: PLAN-071',central) and 'checkpoint: B-006/S-011' in central
result={'status':'PASS','source_hashes_verified':30,'additional_frames_accepted':25,'historical_gates_preserved':5,'runtime_files_unchanged':len(protected),'proposal_links_verified':count,'admission_mode':'unconfigured','admission_execution':False,'canonical_promotion':False,'git_operations':'NONE','active_plan071_preserved':True}
(out/'acceptance-proposal-checks.json').write_text(json.dumps(result,indent=2)+'\n',encoding='utf-8')
print(json.dumps(result))
