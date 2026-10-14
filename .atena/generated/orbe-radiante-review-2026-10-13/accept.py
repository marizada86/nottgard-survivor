from pathlib import Path
import hashlib, json, re, shutil

out=Path(__file__).resolve().parent
root=out.parents[2]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
recovery=json.loads((out/'recovery.json').read_text(encoding='utf-8'))
for e in recovery['sources']:
    assert sha(root/e['path'])==e['sha256']
receipt={'revision':'orbe-radiante-review/v01','date':'2026-10-13','owner_reply':'Aprovo os sete quadros DRAFT','accepted':[{'code':e['code'],'version':e['version'],'path':e['path'],'sha256':e['sha256']} for e in recovery['sources'] if e['code']!='P01'],'historical_p01_preserved':recovery['sources'][0]['sha256'],'content_state':'DRAFT_VISUALLY_ACCEPTED','canonical_promotion':False,'scope':'Visual acceptance of P02-P08 v01 and permission to prepare normalization/admission proposal only','runtime_admission_authorized':False,'git_authorized':False,'runtime_playtest':'NOT_PERFORMED_BY_THIS_APPROVAL'}
(out/'visual-acceptance.json').write_text(json.dumps(receipt,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
state=root/'.atena/state/orbe-radiante-review.yaml'
s=state.read_text(encoding='utf-8').replace('status: TECHNICAL_REVIEW_DELIVERED_PENDING_OWNER_VISUAL_ACCEPTANCE','status: COMPLETED_VISUALLY_ACCEPTED_DRAFT').replace('checkpoint: S-004/OWNER_SEQUENCE_REVIEW','checkpoint: S-004/SEQUENCE_ACCEPTANCE_RECORDED')
s=re.sub(r'^pending_visual_acceptance:.*$', 'pending_visual_acceptance: []', s, flags=re.M)
s=re.sub(r'^next_objective:.*$', 'next_objective: Selecionar modo e aprovar orbe-radiante-admission/v01 antes da execucao.', s, flags=re.M)
s+='''visual_acceptance: .atena/generated/orbe-radiante-review-2026-10-13/visual-acceptance.json
visual_owner_reply: 'Aprovo os sete quadros DRAFT'
admission_proposal: .atena/specs/SPEC-121-retomada-fila-imagens/orbe-radiante-admission-v01.md
admission_mode: unconfigured
'''
state.write_text(s,encoding='utf-8')
for name in ['plan.yaml','plan-053-imagens.yaml']:
    p=root/'.atena/state'/name
    s=p.read_text(encoding='utf-8')
    prefix,block=s.split('orbe_radiante_review_2026_10_13:',1)
    block=block.replace('TECHNICAL_REVIEW_DELIVERED_PENDING_OWNER_VISUAL_ACCEPTANCE','COMPLETED_VISUALLY_ACCEPTED_DRAFT').replace('S-004/OWNER_SEQUENCE_REVIEW','S-004/SEQUENCE_ACCEPTANCE_RECORDED')
    block+='  visual_acceptance: .atena/generated/orbe-radiante-review-2026-10-13/visual-acceptance.json\n  admission_proposal: .atena/specs/SPEC-121-retomada-fila-imagens/orbe-radiante-admission-v01.md\n  admission_mode: unconfigured\n'
    s=prefix+'orbe_radiante_review_2026_10_13:'+block
    if name=='plan-053-imagens.yaml':
        s=s.replace('S-007/VFX/ORBE_RADIANTE/OWNER_SEQUENCE_REVIEW','S-007/VFX/ORBE_RADIANTE/ADMISSION_PLAN_APPROVAL').replace('ORBE_RADIANTE_REVIEW_DELIVERED_OWNER_VISUAL_ACCEPTANCE_PENDING','ORBE_RADIANTE_VISUALLY_ACCEPTED_ADMISSION_PROPOSED').replace('Orbe Radiante oito fontes verificadas; revisao DRAFT entregue, aceite visual P02-P08 pendente; Ampulheta/Pulso/herois preservados.','Orbe Radiante P02-P08 aceitos DRAFT; P01 aprovado preservado; proposta de admissao v01 preparada, sem execucao.').replace('Aceite visual Orbe Radiante P02-P08; depois proposta de admissao. Playtests humanos anteriores preservados.','Aprovar escopo/modo orbe-radiante-admission/v01; playtests humanos anteriores preservados.')
    s+='''orbe_radiante_admission_2026_10_13:
  plan: PLAN-053
  revision: orbe-radiante-admission/v01
  classification: PLAN_CHANGE_REQUEST
  state_file: .atena/state/orbe-radiante-admission.yaml
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
'''
    p.write_text(s,encoding='utf-8')
page=out/'index.html'
s=page.read_text(encoding='utf-8').replace('P02–P08 aguardam aceite visual.','P02–P08 v01 aceitos visualmente como DRAFT em 2026-10-13.').replace('PENDING_VISUAL_ACCEPTANCE','DRAFT_VISUALLY_ACCEPTED')
page.write_text(s,encoding='utf-8')
with (root/'.atena/evidence/orbe-radiante-review-2026-10-13.md').open('a',encoding='utf-8') as f:
    f.write('\n## Aceite visual registrado\n\nDono respondeu “Aprovo os sete quadros DRAFT”. [Recibo de aceite](../generated/orbe-radiante-review-2026-10-13/visual-acceptance.json) identifica P02–P08 v01 por hash; P01 aprovado historicamente preservado. Revisão4/4 concluída e visualmente aceita, sem promoção CANON. [Proposta de admissão v01](../specs/SPEC-121-retomada-fila-imagens/orbe-radiante-admission-v01.md) preparada: impacto de renderer e metadados analisado, quatro etapas e recuperação/checks definidos; execução depende de escolha/aprovação do modo. Nenhuma transformação ou integração nesta resposta.\n')
with (root/'.atena/generated/CHATGPT-FILA-022-vfx-projeteis-e-explosoes.md').open('a',encoding='utf-8') as f:
    f.write('\n## Orbe Radiante — aceite visual da sequência, 2026-10-13\n\nP02–P08 v01 aceitos DRAFT pelo dono (“Aprovo os sete quadros DRAFT”); P01 v01 aprovado preservado. Oito hashes verificados; proposta orbe-radiante-admission/v01 preparada e pendente de escopo/modo. Não confundir aceite visual com admissão ou CANON. Recibo: `.atena/generated/orbe-radiante-review-2026-10-13/visual-acceptance.json`.\n')
protected=json.loads((out/'protected.json').read_text(encoding='utf-8'))
assert all(sha(root/p)==h for p,h in protected.items())
spec=root/'.atena/specs/SPEC-121-retomada-fila-imagens/orbe-radiante-admission-v01.md'
for target in re.findall(r'\]\(([^)]+)\)',spec.read_text(encoding='utf-8')):
    assert (spec.parent/target).exists(),target
print('PASS: seven accepted hashes recorded; proposal links valid; runtime unchanged; admission unconfigured/not executable.')
