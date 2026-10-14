from pathlib import Path
import hashlib,json,re
out=Path(__file__).resolve().parent;root=out.parents[2];sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
proposed=json.loads((out/'selected-candidates.json').read_text(encoding='utf-8'));candidates=proposed['candidates'];assert [(e['code'],e['version']) for e in candidates]==[('H402','v03'),('H406','v02')]
for e in candidates:assert sha(root/e['path'])==e['sha256']
previous=json.loads((root/'.atena/generated/assets-l002-review-2026-10-13/visual-acceptance.json').read_text(encoding='utf-8'));assert len(previous['accepted'])==39
for e in previous['accepted']+previous['historical_gate_acceptances_preserved']:assert sha(root/e['path'])==e['sha256']
protected=json.loads((out/'protected.json').read_text(encoding='utf-8'));assert all(sha(root/p)==h for p,h in protected.items())
receipt={'revision':'sylas-two-frame-correction/v01','accepted_at':'2026-10-14','owner_reply':'Aprovo H402 v03 e H406 v02 DRAFT (Recomendado)','accepted':[{'code':e['code'],'version':e['version'],'path':e['path'],'sha256':e['sha256'],'content_state':'DRAFT_VISUALLY_ACCEPTED'} for e in candidates],'previous_39_acceptances_preserved':True,'historical_H403_v02_preserved':True,'exceptions':[],'canonical_promotion':False,'authorized_next_action':'PREPARE_JOINT_L002_ADMISSION_PROPOSAL','admission_execution_authorized':False,'git_authorized':False}
(out/'visual-acceptance.json').write_text(json.dumps(receipt,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
initial=json.loads((root/'.atena/generated/assets-l002-review-2026-10-13/manifest.json').read_text(encoding='utf-8'))
selected=[]
for old in initial['sources']:
 e=next((e for e in receipt['accepted'] if e['code']==old['code']),old).copy()
 e['acceptance']='HISTORICAL_GATE_ACCEPTED' if e['code']=='H403' else 'DRAFT_VISUALLY_ACCEPTED'
 e['acceptance_record']='.atena/generated/sylas-two-frame-correction-2026-10-13/visual-acceptance.json' if e['code'] in ['H402','H406'] else '.atena/generated/assets-l002-review-2026-10-13/visual-acceptance.json'
 e['group']=int(e['code'][1:-2]);assert sha(root/e['path'])==e['sha256'];selected.append(e)
assert len(selected)==42 and len({e['code'] for e in selected})==42
dest=root/'.atena/generated/assets-l002-admission-2026-10-14';dest.mkdir(exist_ok=True)
families=[{'hero':hero,'group':n,'sources':[e for e in selected if e['group']==n]} for n,hero in zip(range(4,11),['sylas','kayron','korrak','leoric','nyrelia','zynara','bromnor'])];assert all(len(f['sources'])==6 for f in families)
(dest/'selected-sources.json').write_text(json.dumps({'revision':'assets-l002-admission/v01','prepared_at':'2026-10-14','sources':selected,'families':families,'accepted_DRAFT_frames':41,'historical_gate_frames':1,'canonical_promotion':False,'new_generation':0,'runtime_admission':False},ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=out/'index.html';s=p.read_text(encoding='utf-8').replace('Dois candidatos para aceite visual conjunto.','H402v03/H406v02 aceitos visualmente DRAFT pelo dono em2026-10-14.').replace('PENDING_OWNER_VISUAL_ACCEPTANCE','DRAFT_VISUALLY_ACCEPTED');p.write_text(s,encoding='utf-8')
p=root/'.atena/state/sylas-two-frame-correction.yaml';s=p.read_text(encoding='utf-8').replace('status: TECHNICAL_CORRECTION_COMPLETE_AWAITING_OWNER_VISUAL_ACCEPTANCE','status: COMPLETED_VISUALLY_ACCEPTED_DRAFT').replace('S-004/OWNER_TWO_FRAME_VISUAL_ACCEPTANCE','S-004/TWO_FRAME_ACCEPTANCE_RECORDED').replace('owner_visual_acceptance: PENDING','owner_visual_acceptance: APPROVED_EXPLICITLY');s=re.sub(r'next_objective:.*','next_objective: Escolher modo e aprovar proposta conjunta assets-l002-admission/v01.',s);s+='visual_acceptance: .atena/generated/sylas-two-frame-correction-2026-10-13/visual-acceptance.json\naccepted_at: 2026-10-14\nadmission_proposal: .atena/specs/SPEC-121-retomada-fila-imagens/assets-l002-admission-v01.md\nadmission_execution_authorized: false\n';p.write_text(s,encoding='utf-8')
p=root/'.atena/state/assets-l002-review.yaml';s=p.read_text(encoding='utf-8').replace('status: COMPLETED_VISUALLY_ACCEPTED_WITH_EXCLUSIONS','status: COMPLETED_VISUALLY_ACCEPTED_AFTER_CORRECTIONS').replace('approval_status: APPROVED_39_DRAFT_RESERVED_2','approval_status: APPROVED_39_PLUS_CORRECTED_2');s=re.sub(r'next_objective:.*','next_objective: Escolher modo e aprovar proposta conjunta assets-l002-admission/v01.',s);s+='resolved_exclusions: {H402v01: H402v03, H406v01: H406v02}\nremaining_exclusions: []\ncorrection_acceptance: .atena/generated/sylas-two-frame-correction-2026-10-13/visual-acceptance.json\nadmission_proposal: .atena/specs/SPEC-121-retomada-fila-imagens/assets-l002-admission-v01.md\n';p.write_text(s,encoding='utf-8')
for n in ['plan.yaml','plan-053-imagens.yaml']:
 p=root/'.atena/state'/n;s=p.read_text(encoding='utf-8');prefix,block=s.split('sylas_two_frame_correction_2026_10_13:',1)
 block=block.replace('status: TECHNICAL_CORRECTION_COMPLETE_AWAITING_OWNER_VISUAL_ACCEPTANCE','status: COMPLETED_VISUALLY_ACCEPTED_DRAFT').replace('S-004/OWNER_TWO_FRAME_VISUAL_ACCEPTANCE','S-004/TWO_FRAME_ACCEPTANCE_RECORDED');block+='  visual_acceptance: .atena/generated/sylas-two-frame-correction-2026-10-13/visual-acceptance.json\n'
 prefix=prefix.replace('status: COMPLETED_VISUALLY_ACCEPTED_WITH_EXCLUSIONS','status: COMPLETED_VISUALLY_ACCEPTED_AFTER_CORRECTIONS').replace('additional_frames_pending_acceptance: 2','additional_frames_pending_acceptance: 0')
 s=prefix+'sylas_two_frame_correction_2026_10_13:'+block
 if n=='plan-053-imagens.yaml':s=s.replace('S-007/VFX/L-002/TWO_FRAME_VISUAL_ACCEPTANCE','S-007/VFX/L-002/ADMISSION_PLAN_APPROVAL').replace('status: L002_39_ACCEPTED_2_CORRECTED_AWAITING_OWNER','status: L002_42_VISUALLY_ACCEPTED_ADMISSION_PROPOSED').replace('L00239fases aceitas, H403v02 preservado; H402v03/H406v02 corrigidos DRAFT aguardam aceite conjunto.','L00242fontes visualmente aceitas, H402v03/H406v02 e H403v02 preservados; proposta conjunta seteatlas preparada.').replace('Aceite visual H402v03/H406v02; depois proposta conjunta de admissao42fontes L002.','Escolher modo/aprovar assets-l002-admission/v01 antes de normalizar/integrar.')
 s+='''assets_l002_admission_2026_10_14:
  plan: PLAN-053
  revision: assets-l002-admission/v01
  classification: PLAN_CHANGE_REQUEST
  state_file: .atena/state/assets-l002-admission.yaml
  mode: unconfigured
  status: PROPOSED_AWAITING_SCOPE_AND_MODE
  checkpoint: PLAN_APPROVAL
  completed_steps: 0
  total_steps: 5
  images: 42
  atlases: 7
  content_state: DRAFT_WITH_H403_V02_HISTORICAL_GATE_PRESERVED
  runtime_admission: false
  canonical_promotion: false
  return_plan: PLAN-071
  return_checkpoint: B-006/S-011
''';p.write_text(s,encoding='utf-8')
for rel in ['.atena/evidence/sylas-two-frame-correction-2026-10-13.md','.atena/specs/SPEC-121-retomada-fila-imagens/sylas-two-frame-correction-v01.md']:
 with (root/rel).open('a',encoding='utf-8') as f:f.write('\n2026-10-14 — Dono aceitou “AprovoH402v03eH406v02DRAFT (Recomendado)”. Dois hashes conferidos,39aceites/H403v02 preservados, fontes/runtime intactos. Recibo `.atena/generated/sylas-two-frame-correction-2026-10-13/visual-acceptance.json`. Proposta conjunta assets-l002-admission/v01 preparada:42fontes/seteatlas/setehabilidades, dois metadados opcionais de apresentação e validação determinística; escopo/modo pendentes. Nenhuma normalização/admissão/Git/CANON nesta ação.\n')
with (root/'.atena/backlog/ARTE.md').open('a',encoding='utf-8') as f:f.write('\n2026-10-14 — ART030 L002: H402v03/H406v02 aceitos DRAFT,39demais fases e H403v02 preservados.42fontes selecionadas para proposta conjunta assets-l002-admission/v01,seteatlas/setehabilidades. Escopo/modo pendentes; sem normalização/admissão/CANON/Git. Recibo `.atena/generated/sylas-two-frame-correction-2026-10-13/visual-acceptance.json`.\n')
evidence='''# L002 admissão — preparação da proposta / 2026-10-14

Correções H402v03/H406v02 aceitas DRAFT pelo dono;39fases anteriores e H403v02 histórico preservados.42hashes conferidos,3049arquivos runtime intactos. [Seleção](../generated/assets-l002-admission-2026-10-14/selected-sources.json), [recibo](../generated/sylas-two-frame-correction-2026-10-13/visual-acceptance.json), [proposta prospectiva](../specs/SPEC-121-retomada-fila-imagens/assets-l002-admission-v01.md).

Leitura de Battle.use_active/_fire_nova e helpers locais identificou dados reais disponíveis para pulsos/ciclos. Proposta usa estadoativo para Kayron e alvo real charmed para Nyrelia; apenas dois metadados visuais opcionais propostos no active bem-sucedido: visual_originSylas e visual_target_idNyrelia. Não implementar ainda. PulsosKorrak/Bromnor no nova sem segundoatlasnoactive, Leoric conserva oito projéteis e Zynara conserva time_slow4s com flash breve. Preservação do gameplay, comparação baseline e regressões delimitadas na spec.

Autoridade/prontidão: bíblia L002, sete motivos já aceitos e entidadecorpoN/A; nenhuma geração/repintura. Primeiro checkpoint executável depende de seleção explícita do modo/escopo. BLOCKINGaprovacao; calibrações/metadados resolvíveis no plano; feedback humano runtime e bugs025/027/028/029 diferidos. PLAN071/B006/S011 preservado. Sem CANON/Git/exportação e nenhum teste do jogo repetido por não haver alteração runtime.
'''
(root/'.atena/evidence/assets-l002-admission-proposal-2026-10-14.md').write_text(evidence,encoding='utf-8')
count=0
for p in [root/'.atena/specs/SPEC-121-retomada-fila-imagens/assets-l002-admission-v01.md',root/'.atena/evidence/assets-l002-admission-proposal-2026-10-14.md']:
 for link in re.findall(r'\]\(([^)]+)\)',p.read_text(encoding='utf-8')):assert (p.parent/link).exists(),(p,link);count+=1
assert re.search(r'active_plan:\s+id: PLAN-071',(root/'.atena/state/plan.yaml').read_text(encoding='utf-8'))
result={'status':'PASS','new_acceptances':2,'old_acceptances_preserved':39,'historical_gate_preserved':1,'selected_source_hashes_verified':42,'runtime_files_unchanged':len(protected),'proposal_document_links_verified':count,'admission_mode':'unconfigured','admission_execution_authorized':False,'canonical_promotion':False,'git_operations':'NONE'}
(dest/'proposal-checks.json').write_text(json.dumps(result,indent=2)+'\n',encoding='utf-8');print(json.dumps(result))
