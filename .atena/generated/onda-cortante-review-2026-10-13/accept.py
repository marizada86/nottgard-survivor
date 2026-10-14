from pathlib import Path
import hashlib,json,re
out=Path(__file__).resolve().parent
root=out.parents[2]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
recovery=json.loads((out/'recovery.json').read_text(encoding='utf-8'))
for e in recovery['sources']:assert sha(root/e['path'])==e['sha256']
accepted=[{k:e[k] for k in ['code','version','path','sha256']} for e in recovery['sources'] if e['code']!='R01']
assert len(accepted)==7 and next(e for e in accepted if e['code']=='R05')['version']=='v02'
receipt={'revision':'onda-cortante-review/v01','date':'2026-10-13','owner_reply':'Aprovo as sete fases DRAFT','accepted':accepted,'historical_r01_v02_preserved':recovery['sources'][0]['sha256'],'content_state':'DRAFT_VISUALLY_ACCEPTED','canonical_promotion':False,'scope':'Visual acceptance of seven selected phases and permission to prepare normalization/admission proposal only','runtime_admission_authorized':False,'git_authorized':False,'runtime_playtest':'NOT_PERFORMED_BY_THIS_APPROVAL'}
(out/'visual-acceptance.json').write_text(json.dumps(receipt,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=root/'.atena/state/onda-cortante-review.yaml';s=p.read_text(encoding='utf-8').replace('status: TECHNICAL_REVIEW_DELIVERED_PENDING_OWNER_VISUAL_ACCEPTANCE','status: COMPLETED_VISUALLY_ACCEPTED_DRAFT').replace('checkpoint: S-004/OWNER_SEQUENCE_REVIEW','checkpoint: S-004/SEQUENCE_ACCEPTANCE_RECORDED')
s=re.sub(r'^pending_visual_acceptance:.*$', 'pending_visual_acceptance: []',s,flags=re.M)
s=re.sub(r'^next_objective:.*$', 'next_objective: Selecionar modo e aprovar onda-cortante-admission/v01 antes de executar.',s,flags=re.M)
s+='''visual_acceptance: .atena/generated/onda-cortante-review-2026-10-13/visual-acceptance.json
visual_owner_reply: 'Aprovo as sete fases DRAFT'
admission_proposal: .atena/specs/SPEC-121-retomada-fila-imagens/onda-cortante-admission-v01.md
admission_mode: unconfigured
''';p.write_text(s,encoding='utf-8')
for name in ['plan.yaml','plan-053-imagens.yaml']:
    p=root/'.atena/state'/name;s=p.read_text(encoding='utf-8');prefix,block=s.split('onda_cortante_review_2026_10_13:',1)
    block=block.replace('TECHNICAL_REVIEW_DELIVERED_PENDING_OWNER_VISUAL_ACCEPTANCE','COMPLETED_VISUALLY_ACCEPTED_DRAFT').replace('S-004/OWNER_SEQUENCE_REVIEW','S-004/SEQUENCE_ACCEPTANCE_RECORDED')
    block+='  visual_acceptance: .atena/generated/onda-cortante-review-2026-10-13/visual-acceptance.json\n  admission_proposal: .atena/specs/SPEC-121-retomada-fila-imagens/onda-cortante-admission-v01.md\n  admission_mode: unconfigured\n'
    s=prefix+'onda_cortante_review_2026_10_13:'+block
    if name=='plan-053-imagens.yaml':
        s=s.replace('S-007/VFX/ONDA_CORTANTE/OWNER_SEQUENCE_REVIEW','S-007/VFX/ONDA_CORTANTE/ADMISSION_PLAN_APPROVAL').replace('ONDA_CORTANTE_REVIEW_DELIVERED_OWNER_VISUAL_ACCEPTANCE_PENDING','ONDA_CORTANTE_VISUALLY_ACCEPTED_ADMISSION_PROPOSED')
        s=s.replace('Orbe Arcano entrega aceita; Onda Cortante oito fontes verificadas, sete fases DRAFT aguardam aceite visual.','Onda Cortante sete fases aceitas DRAFT e R01v02 preservado; proposta de admissao v01 preparada, sem execucao.').replace('Aceite visual Onda Cortante R02/R03/R04/R05v02/R06/R07/R08; depois proposta de admissao.','Selecionar modo e aprovar onda-cortante-admission/v01 antes de executar.')
    s+='''onda_cortante_admission_2026_10_13:
  plan: PLAN-053
  revision: onda-cortante-admission/v01
  classification: PLAN_CHANGE_REQUEST
  state_file: .atena/state/onda-cortante-admission.yaml
  mode: unconfigured
  approval_status: PENDING_OWNER_CHOICE
  status: PROPOSED_NOT_EXECUTABLE
  checkpoint: PLAN_APPROVAL
  completed_steps: 0
  total_steps: 4
  content_state: DRAFT
  canonical_promotion: false
  return_plan: PLAN-071
  return_checkpoint: B-006/S-011
''';p.write_text(s,encoding='utf-8')
p=out/'index.html';s=p.read_text(encoding='utf-8').replace('R02–R08 aguardam aceite visual.','Sete fases aceitas visualmente DRAFT; R05 usa v02.').replace('PENDING_VISUAL_ACCEPTANCE','DRAFT_VISUALLY_ACCEPTED');p.write_text(s,encoding='utf-8')
with (root/'.atena/evidence/onda-cortante-review-2026-10-13.md').open('a',encoding='utf-8') as f:f.write('\n## Aceite visual registrado\n\nDono respondeu “Aprovo as sete fases DRAFT”. [Recibo](../generated/onda-cortante-review-2026-10-13/visual-acceptance.json) identifica R02/R03/R04/R06/R07/R08v01 e R05v02 por hash; R01v02 aprovado preservado. Revisão4/4 concluída e visualmente aceita, sem CANON. [Proposta de admissão v01](../specs/SPEC-121-retomada-fila-imagens/onda-cortante-admission-v01.md) preparada: duas armas, terceiro despacho na camada existente, calibração própria, quatro etapas/recuperação/checks; execução depende de escopo/modo aprovado. Runtime não alterado nesta resposta.\n')
with (root/'.atena/generated/CHATGPT-FILA-022-vfx-projeteis-e-explosoes.md').open('a',encoding='utf-8') as f:f.write('\n## Onda Cortante — aceite visual, 2026-10-13\n\nR02/R03/R04/R06/R07/R08v01 e R05v02 aceitos DRAFT pelo dono (“Aprovo as sete fases DRAFT”); R01v02 aprovado preservado. Oito hashes conferidos; proposta onda-cortante-admission/v01 preparada e pendente de escopo/modo. Não é admissão runtime/CANON. Recibo: `.atena/generated/onda-cortante-review-2026-10-13/visual-acceptance.json`.\n')
protected=json.loads((out/'protected.json').read_text(encoding='utf-8'));assert all(sha(root/p)==h for p,h in protected.items())
spec=root/'.atena/specs/SPEC-121-retomada-fila-imagens/onda-cortante-admission-v01.md'
links=re.findall(r'\]\(([^)]+)\)',spec.read_text(encoding='utf-8'))
assert all((spec.parent/p).exists() for p in links)
result={'status':'PASS','accepted_phases':7,'r05_revision':'v02','native_source_hashes':'PASS','proposal_links_verified':len(links),'runtime_files_unchanged':len(protected),'admission_mode':'unconfigured','execution_authorized':False,'canonical_promotion':False}
(out/'acceptance-proposal-checks.json').write_text(json.dumps(result,indent=2)+'\n',encoding='utf-8')
print(json.dumps(result))
